#!/usr/bin/make
UID := $(shell id -u)
GID := $(shell id -g)
build:
	docker build --no-cache --pull --build-arg user_id=1000 --build-arg group_id=1000  -t docker-staging.imio.be/iasmartweb/test:1000 .

jenkins-build:
	docker build --no-cache --pull --build-arg user_id=110 --build-arg group_id=65534 -t docker-staging.imio.be/iasmartweb/test:110 .

local-build:
	docker build --pull --build-arg user_id=${UID} --build-arg group_id=${GID} -t docker-staging.imio.be/iasmartweb/test:${UID} .
