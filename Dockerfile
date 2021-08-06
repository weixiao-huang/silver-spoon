FROM ubuntu:16.04

# use other ubuntu mirrors, you can config it to others, some recommend sources can be
# `mirrors.ustc.edu.cn`, `mirrors.tuna.tsinghua.edu.cn`, `mirrors.aliyun.com`
RUN sed -i 's/archive.ubuntu.com/mirrors.tuna.tsinghua.edu.cn/g' /etc/apt/sources.list
RUN apt-get -y update && apt-get -y upgrade && apt-get -y dist-upgrade

RUN apt-get install -y build-essential qemu-system-x86 gdb make gcc-multilib g++-multilib apt-transport-https wget ca-certificates

# use fantastic gbd config in https://github.com/cyrus-and/gdb-dashboard
# since git.io/.gdbinit is difficult to download, we mirror it into project
# RUN wget -P /root git.io/.gdbinit
COPY .gdbinit /root/.gdbinit

WORKDIR /usr/src/app

RUN ln -s /usr/bin/qemu-system-i386 /usr/local/bin/qemu
