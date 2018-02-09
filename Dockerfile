FROM ubuntu:latest
ARG plone_uid=1000
ENV GOSU_VERSION 1.10
RUN apt-get -qy update && apt-get -qy install \
    ca-certificates \
	wget \
	build-essential \
	python-dev \
	python-yaml \
	git \
	rsync \
	gcc \
	libxml2-dev \
	libxslt1-dev \
    libffi-dev \
	zlib1g-dev \
	libjpeg-dev \
	lynx \
	xvfb \
	firefox \
	x11vnc \
	x11-xkb-utils \
	xfonts-100dpi \
	xfonts-75dpi \
	xfonts-scalable \
	xfonts-cyrillic \
	x11-apps
RUN useradd --shell /bin/bash -u $plone_uid -o -c "" -m plone
WORKDIR /home/plone
USER plone
RUN export HOME=/home/plone
RUN mkdir .buildout
COPY default.cfg .buildout/default.cfg
RUN \
	wget -O buildout-cache.tar.bz2 http://files.imio.be/website-buildout-cache.tar.bz2; \
	tar jxvf buildout-cache.tar.bz2 1>/dev/null; \
    mv buildout-cache/downloads .buildout/; \
    mv buildout-cache/eggs .buildout/; \
	rm buildout-cache.tar.bz2; \
    rm -rf buildout-cache
RUN git clone https://github.com/IMIO/buildout.website.git
WORKDIR /home/plone/buildout.website
RUN \
	/usr/bin/python bootstrap.py --buildout-version 2.7.0 -c prod.cfg ; \
	bin/buildout -c prod.cfg
WORKDIR  /home/plone
RUN rm -rf buildout.website

# GeckoDriver
USER root
ARG GECKODRIVER_VERSION=0.19.1
RUN wget --no-verbose -O /tmp/geckodriver.tar.gz https://github.com/mozilla/geckodriver/releases/download/v$GECKODRIVER_VERSION/geckodriver-v$GECKODRIVER_VERSION-linux64.tar.gz \
  && rm -rf /opt/geckodriver \
  && tar -C /opt -zxf /tmp/geckodriver.tar.gz \
  && rm /tmp/geckodriver.tar.gz \
  && mv /opt/geckodriver /opt/geckodriver-$GECKODRIVER_VERSION \
  && chmod 755 /opt/geckodriver-$GECKODRIVER_VERSION \
  && ln -fs /opt/geckodriver-$GECKODRIVER_VERSION /usr/bin/geckodriver

ENV DISPLAY=:123
# Install Xvfb init script
ADD xvfb.init /etc/init.d/xvfb
RUN chmod a+x /etc/init.d/xvfb
# ADD xvfb-daemon-run /usr/bin/xvfb-daemon-run
# RUN chmod a+x /usr/bin/xvfb-daemon-run

# COPY entrypoint.sh /usr/local/bin/entrypoint.sh
# RUN chmod a+x /usr/local/bin/entrypoint.sh
# ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]
# ENV SRC_FOLDER=src
