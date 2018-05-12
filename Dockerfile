FROM ubuntu:16.04

RUN apt-get update
RUN apt-get install -y apt-transport-https

COPY ./config/sources.list /etc/apt/sources.list
RUN apt-get clean
RUN apt-get -y update && apt-get -y upgrade && apt-get -y dist-upgrade

RUN apt-get install -y build-essential qemu-system-x86 gdb make gcc-multilib g++-multilib

COPY ./config/.gdbinit /root

WORKDIR /usr/src/app

RUN ln -s /usr/bin/qemu-system-i386 /usr/local/bin/qemu
