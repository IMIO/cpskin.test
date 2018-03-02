cpskin.test
===========

Introduction
------------
cpskin.test repo is used to create a Docker image which you should be use to dev and test your package.
In this image are included :
- Robotframework (witch Xvfb)
- Buildout cache (in /home/plone/.buildout forlder)


How to use cpskin.test image to test your package
-------------------------------------------------
First, create a docker-compose.yml file, it should seems like this :

    version: '3.4'
    services:
      zeo:
        image: docker-staging.imio.be/cpskin.test:${uid}
        user: plone
        volumes:
            - .:/home/plone/website
        working_dir: /home/plone/website
        command: /home/plone/website/bin/zeoserver fg
      instance:
        image: docker-staging.imio.be/cpskin.test:${uid}
        user: plone
        ports:
          - "8081:8081"
        links:
          - zeo:db
        volumes:
          - .:/home/plone/website
        working_dir: /home/plone/website
        environment:
          - ZEO_HOST=db
          - ZEO_PORT=8100
        command: /home/plone/website/bin/instance fg

Makefile :

    .env:
    	echo uid=${UID} > .env

    build:
        docker-compose pull
        docker-compose run zeo /usr/bin/python bootstrap.py -c docker-dev.cfg --buildout-version 2.7.0
        docker-compose run zeo bin/buildout -c docker-dev.cfg

    up: .env var/instance/minisites
    	docker-compose up

.env
This file is used to docker-compose, it sets variables (uid in our case) which are used to docker-compose files

build section
In this section, we run buildout, it's fast because all eggs are already downloaded and compiled

up section
Start zeo and instance
