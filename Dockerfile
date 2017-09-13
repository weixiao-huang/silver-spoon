FROM huangwx/gcc5-i686-elf:make

EXPOSE 1234

COPY ./src /usr/src/app/
WORKDIR /usr/src/app
