DOCKER_CMD = $(shell which docker)
DOCKER_COMPOSE_OLD_CMD = $(shell which docker-compose)
DOCKER_COMPOSE_NEW_CMD = $(shell which docker)
ifeq ($(DOCKER_COMPOSE_NEW_CMD),)
	ifeq ($(DOCKER_COMPOSE_OLD_CMD),)
		$(error "DockerCompose not available on this system")
	else
		DOCKER_COMPOSE_CMD = ${DOCKER_COMPOSE_OLD_CMD}
	endif
else
	DOCKER_COMPOSE_CMD = ${DOCKER_COMPOSE_NEW_CMD} compose
endif

compose-uid := $(shell echo $(vendor)-$(app)-$(notdir $(shell pwd)) | tr A-Z a-z)
compose-prefix = -p ${compose-uid}

DOCKER_COMPOSE=${DOCKER_COMPOSE_CMD} ${compose-prefix}