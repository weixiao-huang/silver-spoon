# simple -> gdb -> make -> qemu = latest
FROM huangwx/gcc5-i686-elf:qemu

WORKDIR /usr/src/app

RUN ln -s /usr/bin/qemu-system-i386 /usr/local/bin/qemu
