FROM ubuntu:latest
RUN apt-get -qy update && apt-get -qy install build-essential python-dev python-yaml git rsync gcc libxml2-dev libxslt1-dev zlib1g-dev libjpeg-dev lynx xvfb firefox x11vnc x11-xkb-utils xfonts-100dpi xfonts-75dpi xfonts-scalable xfonts-cyrillic x11-apps
USER root
RUN mkdir -p /.buildout
WORKDIR /.buildout
COPY default.cfg .
RUN \
	wget -O  buildout-cache.tar.bz2 http://files.imio.be/website-buildout-cache.tar.bz2 &&\
	tar jxvf buildout-cache.tar.bz2 1>/dev/null &&\
	rm buildout-cache.tar.bz2
WORKDIR /root
RUN git clone https://github.com/IMIO/buildout.website.git
RUN git clone https://github.com/IMIO/cpskin.policy.git
WORKDIR /root/buildout.website
COPY test.cfg buildout.cfg
RUN \
	python bootstrap.py &&\
	bin/buildout
WORKDIR /root/cpskin.policy
RUN \
	python bootstrap.py buildout:download-cache=/.buildout/buildout-cache/downloads buildout:eggs-directory=/.buildout/buildout-cache/eggs &&\
	bin/buildout buildout:download-cache=/.buildout/buildout-cache/downloads buildout:eggs-directory=/.buildout/buildout-cache/eggs
WORKDIR /root
RUN rm -rf buildout.website
RUN rm -rf cpskin.policy
RUN chmod 777 -R /.buildout

# GeckoDriver
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
ADD xvfb-daemon-run /usr/bin/xvfb-daemon-run
RUN chmod a+x /usr/bin/xvfb-daemon-run
