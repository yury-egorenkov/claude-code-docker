CONF ?= .

# For local use in this makefile. This does not export to sub-processes.
-include .env.default.properties
-include $(CONF)/.env.properties

MAKEFLAGS        := --silent --always-make
MAKE_CONC        := $(MAKE) -j 128 CONC=true clear=$(or $(clear),false)

VERB_SHORT       ?= $(if $(filter false,$(verb)),,-v)
CLEAR_SHORT      ?= $(if $(filter false,$(clear)),,-c)

# Check if .git directory exists
GIT_SHA ?= latest
GIT_DIR_EXISTS := $(shell if [ -d ".git" ]; then echo "true"; else echo "false"; fi)
ifeq ($(GIT_DIR_EXISTS),true)
	GIT_SHA := $(shell git rev-parse --short=8 HEAD)
endif

DOCKER_LABEL ?= claude
DOCKER_TAG_WITH_GIT_SHA ?= $(DOCKER_LABEL):$(GIT_SHA)
DOCKER_TAG_LATEST ?= $(DOCKER_LABEL):latest
DOCKER_FILE ?= dockerfile

DOCKER_ENV := --env-file .env.default.properties --env-file $(or $(CONF),.)/.env.properties

DOCKER_NETWORK ?= bridge

WORKSPACE_DIR ?= app
WORK_DIR := $(PWD)/$(WORKSPACE_DIR)

default: docker

# TODO: keep command comments, and align them vertically.
#
# Note that if we do that, `uniq` will no longer dedup lines for commands whose
# names are repeated, usually with `<cmd_name>: export <VAR> ...`. We'd have to
# skip/ignore those lines.
help:	# Print help
	echo "Available commands are listed below"
	echo "Show this help: make help"
	echo "Show command definition: make -n <command>"
	echo
	for val in $(MAKEFILE_LIST); do grep -E '^\S+:' $$val; done | sed 's/:.*//' | uniq

docker: docker.build docker.clean docker.run

# TODO: only echo in verbose mode.
docker.build:
	echo "build: $(DOCKER_TAG_WITH_GIT_SHA)"
	DOCKER_BUILDKIT=0 docker build --progress=plain --build-arg LABEL=$(DOCKER_LABEL) --build-arg TZ=$(readlink /etc/localtime | sed 's#/var/db/timezone/zoneinfo/##') -f $(DOCKER_FILE) -t $(DOCKER_TAG_WITH_GIT_SHA) -t $(DOCKER_TAG_LATEST) .

docker.run.internal:
	$(eval export)
	echo $(DOCKER_RUN)
	docker run $(args) $(DOCKER_ENV) -v=$(PWD)/node:/home/node -v=$(WORK_DIR):$(WORKSPACE)/project -v=$(WORK_DIR)/../docs:$(WORKSPACE)/docs  --network $(DOCKER_NETWORK) $(DOCKER_TAG_LATEST)

docker.run:
	$(MAKE) docker.run.internal args="-it"

docker.run.d:
	$(MAKE) docker.run.internal args="-d --rm"

# Deletes all untagged images built from our project.
# TODO: only keep the latest, if any.
# TODO: un-hardcode the label both in the Dockerfile and here.
docker.clean:
	docker image prune -f --filter "label=project=$(DOCKER_LABEL)"

docker.ls:
	docker images --filter "label=project=$(DOCKER_LABEL)"
