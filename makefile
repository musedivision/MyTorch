SHELL:=/bin/bash

-include .password

.ONESHELL:
.DEFAULT=all
.PHONY: help test

export PUBLIC_PORT := 8888

export VERSION											:= 3
export PROJECT_NAME										:= mytorch
export FUNCTION_NAME									:= lab
export NETWORK_NAME                                     := fastai
export DOCKER_REPO										:= musedivision

help: ## This help.
	@echo "CURRENT VERSION: ${VERSION}"
	@awk 'BEGIN {FS = ":.*?## "} /^[a-zA-Z_-]+:.*?## / {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}' $(MAKEFILE_LIST)
	ecs-cli configure --cluster forsite --region ap-southeast-2 --default-launch-type FARGATE


############################################################
# RUN
############################################################


up: build run

compose:
	# launching docker containers
	docker-compose up -d

open:
	open http://localhost:8888

build: ## Build the container
	docker build -t $(PROJECT_NAME)-${FUNCTION_NAME} .

build-nc: ## Build the container without caching
	docker build --no-cache -t $(PROJECT_NAME)-${FUNCTION_NAME} .

run:
	docker run -d --rm \
	-p 8888:8888 \
	-e JUPYTER_ENABLE_LAB=no \
	-v "$$PWD/volume":/home/jovyan \
	--name="$(PROJECT_NAME)-${FUNCTION_NAME}" \
	$(PROJECT_NAME)-${FUNCTION_NAME} \
	start-notebook.sh --NotebookApp.password='${JUPYTER_PASSWORD_SHA}'

start:
	docker run -d --rm \
        -p 8889:8888 \
        -e JUPYTER_ENABLE_LAB=yes \
        -v "$$PWD/volume":/home/jovyan \
		-v "${shell cd .. && pwd}":/home/jovyan/code \
        --name="$(PROJECT_NAME)-${FUNCTION_NAME}" \
        $(DOCKER_REPO)/$(PROJECT_NAME) \
        start-notebook.sh --NotebookApp.password='${JUPYTER_PASSWORD_SHA}'
	open http://localhost:8889/

clean:
	docker stop $(PROJECT_NAME)-${FUNCTION_NAME} || true

clean_images:
	docker rmi -f $(PROJECT_NAME)-${FUNCTION_NAME}

#######################################################################################################################
#   DEPLOYMENT   -- maybe i could upload to docker hub                                                                                                       #
########################################################################################################################

