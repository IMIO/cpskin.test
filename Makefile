#!/usr/bin/make
UID := $(shell id -u)
build:
	docker build --no-cache --force-rm --pull --build-arg plone_uid=1000 -t docker-staging.imio.be/cpskin.test:1000 .

jenkins-build:
	docker build --no-cache --force-rm --pull --build-arg plone_uid=110 -t docker-staging.imio.be/cpskin.test:110 .

local-build:
	docker build --no-cache --force-rm --pull --build-arg plone_uid=${UID} -t docker-staging.imio.be/cpskin.test:${UID} .
