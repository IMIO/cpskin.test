#!/usr/bin/make
UID := $(shell id -u)
build:
	docker build --force-rm --pull --build-arg plone_uid=1000 -t docker-staging.imio.be/cpskin.test:latest .

jenkins-build:
	docker build --build-arg plone_uid=110 -t docker-staging.imio.be/cpskin.test:110 .

local-build:
	docker build --build-arg plone_uid=${UID} -t docker-staging.imio.be/cpskin.test:${UID} .
