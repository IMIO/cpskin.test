FROM docker-staging.imio.be/iasmartweb/cache:latest
ARG user_id=1000
ARG group_id=1000
ARG GECKODRIVER_VERSION=0.24.0
# ENV GOSU_VERSION 1.10
ENV PATH="/home/imio/.local/bin:${PATH}" \
  DISPLAY=:123
ADD xvfb.init /etc/init.d/xvfb
RUN apt-get -qy update && apt-get -qy install \
    ca-certificates \
    firefox \
    gcc \
    git \
    libffi-dev \
    libssl-dev \
    python-dev \
    python-virtualenv \
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
    xvfb \
  && runDeps="poppler-utils wv rsync lynx netcat libxml2 libxslt1.1 libjpeg62 libtiff5 libopenjp2-7" \
  && apt-get update \
  && apt-get install -y --no-install-recommends $runDeps \
  && rm -rf /home/imio/.local \
  && rm -rf /home/imio/.cache && usermod -u $user_id imio && groupmod -g $group_id -o imio \
  && cd /home/imio \
  && git clone https://github.com/IMIO/buildout.website.git \
  && cd /home/imio/buildout.website \
  && pip install -I --user -r https://raw.githubusercontent.com/IMIO/buildout.website/4.3.18.x/requirements.txt \
  && buildout -c dev.cfg \
  && cd /home/imio \
  && rm -rf /home/imio/buildout.website /home/imio/.local /home/imio/.cache \
  && chown -R $user_id:$group_id /home/imio \
  # GeckoDriver
  && wget --no-verbose -O /tmp/geckodriver.tar.gz https://github.com/mozilla/geckodriver/releases/download/v$GECKODRIVER_VERSION/geckodriver-v$GECKODRIVER_VERSION-linux64.tar.gz \
  && rm -rf /opt/geckodriver \
  && tar -C /opt -zxf /tmp/geckodriver.tar.gz \
  && rm /tmp/geckodriver.tar.gz \
  && mv /opt/geckodriver /opt/geckodriver-$GECKODRIVER_VERSION \
  && chmod 755 /opt/geckodriver-$GECKODRIVER_VERSION \
  && ln -fs /opt/geckodriver-$GECKODRIVER_VERSION /usr/bin/geckodriver \
  # Install Xvfb init script
  && chmod a+x /etc/init.d/xvfb
# ADD xvfb-daemon-run /usr/bin/xvfb-daemon-run
# RUN chmod a+x /usr/bin/xvfb-daemon-run

# COPY entrypoint.sh /usr/local/bin/entrypoint.sh
# RUN chmod a+x /usr/local/bin/entrypoint.sh
# ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]
# ENV SRC_FOLDER=src
