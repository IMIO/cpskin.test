FROM python:2
RUN apt-get -qy update && apt-get -qy install build-essential python-dev git rsync gcc libxml2-dev libxslt1-dev zlib1g-dev libjpeg-dev lynx
RUN mkdir -p .buildout
WORKDIR /root/.buildout
COPY default.cfg .
RUN \
	wget -O  buildout-cache.tar.bz2 http://files.imio.be/website-buildout-cache.tar.bz2 &&\
	tar jxvf buildout-cache.tar.bz2 1>/dev/null &&\
	rm buildout-cache.tar.bz2
RUN \
    apt-get autoremove -y &&\
    apt-get clean
