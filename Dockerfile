FROM debian:stretch
MAINTAINER Falko Zurell <falko.zurell@gmail.com>

LABEL description="container withings -> Garmin connect"

RUN apt-get update
RUN apt-get --fix-missing install curl python3 python3-pip -y && \
apt-get autoclean && apt-get --purge -y autoremove && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*
