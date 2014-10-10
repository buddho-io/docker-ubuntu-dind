FROM ubuntu:14.04

MAINTAINER Lance Linder <lance@buddho.io>

ENV DEBIAN_FRONTEND noninteractive

# Update system and install prerequisites
RUN apt-get update -y && \
    apt-get upgrade -y && \
    apt-get install -y apt-transport-https && \
    apt-get clean

# Add Docker APT source
RUN echo deb https://get.docker.io/ubuntu docker main > /etc/apt/sources.list.d/docker.list && \
    apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys 36A1D7869245C8950F966E92D8576A8BA88D21E9 && \
    apt-get update -y && \
    apt-get install -y lxc-docker && \
    apt-get clean

RUN echo 'DOCKER_OPTS="-H :2375 unix:///var/run/docker.sock"' >> /etc/default/docker

# Basic cleanup
RUN rm -rf /tmp/* /var/tmp/* /var/lib/apt/lists/*

VOLUME /var/lib/docker

EXPOSE 2375

CMD /etc/init.d/docker start && sleep 1 && tail -F /var/log/upstart/docker.log
