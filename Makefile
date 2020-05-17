.PHONY: help

SHELL = /bin/bash

ATOM_USER_ID ?= $(shell id -u)
ATOM_USER_NAME ?= $(shell id -un)
ATOM_GROUP_ID ?= $(shell id -g)
ATOM_GROUP_NAME ?= $(shell id -gn)

DOCKER_TAG ?= hgdeoro/docker-atom-editor
# But all this is heavily based on https://github.com/jamesnetherton/docker-atom-editor

DOCKER_RUN_INTERACTIVE:=$(shell [ -t 0 ] && echo "-ti")

help:
	@echo "To build the image with latest release of Atom:"
	@echo "	$$ make build"
	@echo ""
	@echo "or with a specific version:"
	@echo "	$$ make build ARG_ATOM_VERSION=v1.46.0"
	@echo ""
	@echo "To run Atom on container and mount paths specified by MOUNT_DIRS:"
	@echo "  $$ make run MOUNT_DIRS=\"\$$HOME/projects /srv/projects\""
	@echo ""

build:
	docker build . -t $(DOCKER_TAG) \
		--build-arg ARG_ATOM_VERSION=$(ARG_ATOM_VERSION) \
		--build-arg ATOM_USER_NAME=$(ATOM_USER_NAME) \
		--build-arg ATOM_USER_ID=$(ATOM_USER_ID) \
		--build-arg ATOM_GROUP_NAME=$(ATOM_GROUP_NAME) \
		--build-arg ATOM_GROUP_ID=$(ATOM_GROUP_ID)

run:
	docker run --rm $(DOCKER_RUN_INTERACTIVE) \
		--mount type=bind,source=/tmp/.X11-unix/,target=/tmp/.X11-unix/ \
		--mount type=bind,source=/dev/shm,target=/dev/shm \
		--mount type=bind,source=$${HOME}/.atom,target=/home/$(ATOM_USER_NAME)/.atom \
		--mount type=bind,source=$${HOME}/.config/Atom,target=/home/$(ATOM_USER_NAME)/.config/Atom \
		$(shell for dir in $(MOUNT_DIRS) ; do echo "--mount type=bind,source=$${dir},target=$${dir} " ; done) \
		-e DISPLAY \
		-e ELECTRON_TRASH=trash-cli \
		$(DOCKER_TAG)
