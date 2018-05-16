FROM golang

RUN apt-get update
RUN apt-get install -y apt-transport-https

# use utsc debian mirrors
RUN sed -i 's/deb.debian.org/mirrors.ustc.edu.cn/g' /etc/apt/sources.list

RUN apt-get clean
RUN apt-get -y update && apt-get -y upgrade && apt-get -y dist-upgrade