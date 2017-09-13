SOURCE     := src
IMAGE      := ucore
CONTAINER  := ucore-container
WORKDIR	   := /usr/src/app

VOLFLAGS   := -v $(PWD)/$(SOURCE):$(WORKDIR)

BASH       := /bin/bash

LOCALIP = $(shell ifconfig | grep -Eo 'inet (addr:)?([0-9]*\.){3}[0-9]*' | grep -Eo '([0-9]*\.){3}[0-9]*' | grep -v '127.0.0.1' | awk '{print $1}')

DFLAGS     := --privileged --rm -it $(VOLFLAGS) $(PORTFLAGS)
DFLAGS_G   := $(DFLAGS) -e DISPLAY=$(LOCALIP):0 -v /tmp/.X11-unix:/tmp/.X11-unix

docker_run          = docker run $(DFLAGS) --name $(CONTAINER) $(IMAGE)
docker_run_graphics = docker run $(DFLAGS_G) --name $(CONTAINER) $(IMAGE)

docker_bash = $(docker_run) $(BASH) -c "$(1)"

# Get the Ubuntu environment
all: build run

# https://fredrikaverpil.github.io/2016/07/31/docker-for-mac-and-gui-applications/
config:
	xhost + $(LOCALIP)

# main
build:
	docker build -t $(IMAGE) .

run:
	$(call docker_run_graphics) $(BASH)

# extra inner copy
clean:
	@$(call docker_bash,make clean)

debug:
	@$(call docker_bash,gdb)
