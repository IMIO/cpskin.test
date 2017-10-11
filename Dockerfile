FROM docker-staging.imio.be/base:latest
RUN apt-get -qy update && apt-get -qy install build-essential python-dev git rsync gcc libxml2-dev libxslt1-dev zlib1g-dev libjpeg-dev lynx
USER imio
WORKDIR /home/imio
RUN mkdir -p .buildout
WORKDIR /home/imio/.buildout
COPY default.cfg .
RUN \
	wget -O  buildout-cache.tar.bz2 http://files.imio.be/website-buildout-cache.tar.bz2 &&\
	tar jxvf buildout-cache.tar.bz2 1>/dev/null &&\
	rm buildout-cache.tar.bz2
WORKDIR /home/imio
RUN \
    git clone https://github.com/IMIO/buildout.website.git
	cd buildout.website
	sudo pip zc.buildout setuptools
	python bin/buildout
RUN \
    apt-get autoremove -y &&\
    apt-get clean
