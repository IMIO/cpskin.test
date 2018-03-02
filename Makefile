#!/usr/bin/make
UID := $(shell id -u)
GID := $(shell id -g)
build:
	docker build --no-cache --force-rm --pull --build-arg user_uid=1000 --build-arg group_uid=1000  -t docker-staging.imio.be/iasmartweb/test:1000 .

jenkins-build:
	docker build --no-cache --force-rm --pull --build-arg user_uid=110 --build-arg group_uid=65534 -t docker-staging.imio.be/iasmartweb/test:110 .

local-build:
	docker build --no-cache --force-rm --pull --build-arg user_uid=${UID} -t docker-staging.imio.be/iasmartweb/test:${UID} .
