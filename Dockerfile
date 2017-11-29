FROM ubuntu:latest
ENV GOSU_VERSION 1.10
RUN apt-get -qy update && apt-get -qy install ca-certificates wget build-essential python-dev python-yaml git rsync gcc libxml2-dev libxslt1-dev zlib1g-dev libjpeg-dev lynx xvfb firefox x11vnc x11-xkb-utils xfonts-100dpi xfonts-75dpi xfonts-scalable xfonts-cyrillic x11-apps
USER root
RUN \
    dpkgArch="$(dpkg --print-architecture | awk -F- '{ print $NF }')"; \
    wget -O /usr/local/bin/gosu "https://github.com/tianon/gosu/releases/download/$GOSU_VERSION/gosu-$(dpkg --print-architecture)"; \
	chmod +x /usr/local/bin/gosu; \
	gosu nobody true; \
	wget -O  buildout-cache.tar.bz2 http://files.imio.be/website-buildout-cache.tar.bz2; \
	tar jxvf buildout-cache.tar.bz2 1>/dev/null; \
	rm buildout-cache.tar.bz2
COPY default.cfg buildout-cache/default.cfg
WORKDIR /root
RUN git clone https://github.com/IMIO/cpskin.core.git && git clone https://github.com/IMIO/cpskin.policy.git
WORKDIR /root/cpskin.core
RUN \
	python bootstrap.py --buildout-version 2.7.0 buildout:download-cache=/buildout-cache/downloads buildout:eggs-directory=/buildout-cache/eggs; \
	bin/buildout buildout:download-cache=/buildout-cache/downloads buildout:eggs-directory=/buildout-cache/eggs
WORKDIR /root/cpskin.policy
RUN \
	python bootstrap.py buildout:download-cache=/buildout-cache/downloads buildout:eggs-directory=/buildout-cache/eggs; \
	bin/buildout buildout:download-cache=/buildout-cache/downloads buildout:eggs-directory=/buildout-cache/eggs
WORKDIR /root
RUN rm -rf cpskin.core cpskin.policy
RUN chmod 777 -R /buildout-cache

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
# ADD xvfb-daemon-run /usr/bin/xvfb-daemon-run
# RUN chmod a+x /usr/bin/xvfb-daemon-run

COPY entrypoint.sh /usr/local/bin/entrypoint.sh

ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]
