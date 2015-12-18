FROM ubuntu:latest
MAINTAINER Viz <viz@linux.com>

RUN addgroup --system nginx > /dev/null; \
    adduser  --system --disabled-login --ingroup nginx --no-create-home \
             --home /nonexistent --gecos "nginx user" --shell /bin/false \
             nginx > /dev/null

COPY files /

CMD ["/usr/sbin/nginx", "-g", "daemon off;"]
