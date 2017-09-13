
# try to infer the correct QEMU
ifndef QEMU
QEMU := $(shell if which qemu-system-i386 > /dev/null; \
	then echo 'qemu-system-i386'; exit; \
	elif which i386-elf-qemu > /dev/null; \
	then echo 'i386-elf-qemu'; exit; \
	else \
	echo "***" 1>&2; \
	echo "*** Error: Couldn't find a working QEMU executable." 1>&2; \
	echo "*** Is the directory containing the qemu binary in your PATH" 1>&2; \
	echo "***" 1>&2; exit 1; fi)
endif


IMAGE      := ucore
CONTAINER  := ucore-container

VOLFLAGS   := -v $(PWD)/src/:/usr/src/app/
PORTFLAGS  := -p 1234:1234

DFLAGS     := --privileged --rm -it $(VOLFLAGS) $(PORTFLAGS)
BASH       := /bin/bash

WORKDIR	   := /usr/src/app

docker_run = docker run $(DFLAGS) --name $(CONTAINER) $(IMAGE)

docker_bash = $(docker_run) $(BASH) -c "$(1)"


# Get the Ubuntu environment
all: build run

build:
	docker build -t $(IMAGE) .

run:
	@$(call docker_bash,make)

clean:
	@$(call docker_bash,make clean)

qemu: run
	qemu -S src/bin/bootblock

debug:
	@$(call docker_bash,gdb)