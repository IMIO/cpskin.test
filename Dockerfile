FROM docker-staging.imio.be/base:latest
RUN apt-get -qy update && apt-get -qy install build-essential python-dev python-yaml git rsync gcc libxml2-dev libxslt1-dev zlib1g-dev libjpeg-dev lynx
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
