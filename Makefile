#--------------------------------------------------------------------
# User Editable Interface
#--------------------------------------------------------------------

# Dir mapped into docker container
SOURCE     := .

# Docker image name
IMAGE      := ucore

# Docker container name
CONTAINER  := ucore-container


#--------------------------------------------------------------------
# Get the LOCALIP of host for DISPLAY of different OS
#--------------------------------------------------------------------

ifeq ($(OS),Windows_NT)
#   The default dockerNAT for windows is 10.0.75.1
#   you can change it in docker for windows Application
	WIN_DOCKERNAT := 10.0.75.1
	LOCALIP := $(WIN_DOCKERNAT)
else
	UNAME_S := $(shell uname -s)
	ifeq ($(UNAME_S),Linux)
		LOCALIP := 
	endif
	ifeq ($(UNAME_S),Darwin)
		LOCALIP := docker.for.mac.localhost
	endif
endif


#--------------------------------------------------------------------
# Docker flags and container settings
#--------------------------------------------------------------------

# container's work dir
WORKDIR	   := /usr/src/app

# map SOURCE into WORKDIR
VOLFLAGS   := -v $(CURDIR)/$(SOURCE):$(WORKDIR)

# map X11-unix dir
GVOLFLAGS  := -v /tmp/.X11-unix:/tmp/.X11-unix

# Bash in container
BASH       := /bin/bash

V          := @


DFLAGS     := --privileged -itd $(VOLFLAGS)
DFLAGS_G   := $(DFLAGS) -e DISPLAY=$(LOCALIP):0 $(GVOLFLAGS)

docker_run          = docker run $(DFLAGS) --name $(CONTAINER) $(IMAGE)
docker_run_graphics = docker run $(DFLAGS_G) --name $(CONTAINER) $(IMAGE)
docker_exec         = docker exec -it $(CONTAINER)

# docker_bash = $(docker_run) $(BASH) -c "$(1)"


# >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
# Make Tasks
# >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

# Get the Ubuntu develop environment
exec:
	$(V)$(docker_exec) $(BASH)


# Main tasks
init: build run

build:
	$(V)docker build -t $(IMAGE) .

run:
	$(V)$(docker_run_graphics) $(BASH)

start:
	$(V)docker start $(CONTAINER)

stop:
	$(V)docker stop $(CONTAINER)

rm:
	$(V)docker rm $(CONTAINER)


# Container make command copies
qemu:
	$(V)$(docker_exec) make qemu

clean:
	$(V)$(docker_exec) make clean

# ...
