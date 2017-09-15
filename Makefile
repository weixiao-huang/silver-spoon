
SOURCE     := code
IMAGE      := ucore
CONTAINER  := ucore-container
NETWORK    := ucore-net
WORKDIR	   := /usr/src/app

VOLFLAGS   := -v $(CURDIR)/$(SOURCE):$(WORKDIR)

BASH       := /bin/bash
QEMU       := qemu
QEMUFLAGS  := -s -S
GDB        := gdb
GDBINIT    := tools/gdbinit
GDBFLAGS   := -q -x $(GDBINIT)

# The default dockerNAT for windows
# you can change it in docker for windows Application
WIN_DOCKERNAT := 10.0.75.1

# Get the LOCALIP for DISPLAY in docker
ifeq ($(OS),Windows_NT)
	LOCALIP := $(WIN_DOCKERNAT)
else
    UNAME_S := $(shell uname -s)
    ifeq ($(UNAME_S),Linux)
		LOCALIP := $(shell ifconfig | grep -Eo 'inet (addr:)?([0-9]*\.){3}[0-9]*' | grep -Eo '([0-9]*\.){3}[0-9]*' | grep -v '127.0.0.1' | awk '{print $1}')
    endif
    ifeq ($(UNAME_S),Darwin)
		LOCALIP := docker.for.mac.localhost
    endif
endif


DFLAGS     := --privileged -itd $(VOLFLAGS)
DFLAGS_G   := $(DFLAGS) -e DISPLAY=$(LOCALIP):0 -v /tmp/.X11-unix:/tmp/.X11-unix

docker_run          = docker run $(DFLAGS) --name $(CONTAINER) $(IMAGE)
docker_run_graphics = docker run $(DFLAGS_G) --name $(CONTAINER) $(IMAGE)
docker_exec         = docker exec -it $(CONTAINER)

docker_bash = $(docker_run) $(BASH) -c "$(1)"

# Get the Ubuntu environment
exec:
	@$(docker_exec) $(BASH)

# main
init: build run

build:
	docker build -t $(IMAGE) .

run:
	$(call docker_run_graphics) $(BASH)

start:
	@docker start $(CONTAINER)

stop:
	@docker stop $(CONTAINER)

rm:
	@docker rm $(CONTAINER)

debug-qemu:
	@$(docker_exec) $(QEMU) $(QEMUFLAGS) bin/bootblock

debug-gdb:
	@$(docker_exec) $(GDB) $(GDBFLAGS)

# extra inner copy
clean:
	@$(call docker_bash,make clean)
