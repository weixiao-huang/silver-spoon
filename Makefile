#--------------------------------------------------------------------
# User Editable Interface
#--------------------------------------------------------------------

# Dir mapped into docker container
SOURCE     := src

# Docker image name
IMAGE      := assembly

# Docker container name
CONTAINER  := assembly-ct

#--------------------------------------------------------------------
# Docker flags and container settings
#--------------------------------------------------------------------

# container's work dir
WORKDIR	   := /usr/src/app

# map SOURCE into WORKDIR
VOLFLAGS   := -v $(CURDIR)/$(SOURCE):$(WORKDIR)

# Bash in container
BASH       := /bin/bash

V          := @


DFLAGS     := --privileged -itd $(VOLFLAGS)

docker_run          = docker run $(DFLAGS) --name $(CONTAINER) $(IMAGE)
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
	$(V)$(docker_run) $(BASH)

start:
	$(V)docker start $(CONTAINER)

stop:
	$(V)docker stop $(CONTAINER)

rm:
	$(V)docker rm $(CONTAINER)
