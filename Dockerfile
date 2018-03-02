FROM docker-staging.imio.be/iasmartweb/cache:latest
ARG user_id=1000
ARG group_id=1000
ENV GOSU_VERSION 1.10
RUN apt-get -qy update && apt-get -qy install \
    ca-certificates \
    firefox \
    gcc \
    git \
    libffi-dev \
    libssl-dev \
    python-dev \
    python-yaml \
    rsync \
    wget \
    x11-apps \
    x11-xkb-utils \
    x11vnc \
    xfonts-100dpi \
    xfonts-75dpi \
    xfonts-cyrillic \
    xfonts-scalable \
    xvfb
RUN usermod -u $user_id imio && usermod -g $group_id imio && chown $user_id:$group_id -R /home/imio
WORKDIR /home/imio
USER imio
RUN git clone https://github.com/IMIO/buildout.website.git
WORKDIR /home/imio/buildout.website
RUN \
	/usr/bin/python bootstrap.py -c dev.cfg ;\
	bin/buildout -c dev.cfg
WORKDIR  /home/imio
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
