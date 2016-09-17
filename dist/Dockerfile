FROM busybox:latest
MAINTAINER Viz <viz@linux.com>

COPY files /

RUN addgroup -g 999 -S nginx > /dev/null; \
    adduser  -u 999 -S -D -h /var/cache/nginx \
                          -s /sbin/nologin \
                          -G nginx nginx > /dev/null

CMD ["/usr/sbin/nginx", "-g", "daemon off;"]
