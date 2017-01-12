FROM busybox:latest
MAINTAINER Wenxuan Zhao <viz@linux.com>

COPY files /

RUN addgroup -g 999 -S nginx > /dev/null; \
    adduser  -u 999 -S -D -h /var/cache/nginx \
                          -s /sbin/nologin \
                          -G nginx nginx > /dev/null

EXPOSE 80 443
CMD ["/usr/sbin/nginx", "-g", "daemon off;"]
