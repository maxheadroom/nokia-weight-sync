FROM debian:stretch
MAINTAINER Falko Zurell <falko.zurell@gmail.com>

LABEL description="container withings -> Garmin connect"
EXPOSE 9090
RUN apt-get update
RUN apt-get --fix-missing install curl python3 python3-pip -y
RUN mkdir /build
COPY . /build
WORKDIR /build
RUN pip3 install -r requirements.txt
ENTRYPOINT ["/build/nokia-weight-sync.py", "sync", "garmin"]
