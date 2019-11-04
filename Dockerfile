# BUILD Stage
FROM alpine:edge as builder

ENV DIR_SCRIPTS='/scripts' BPATH='/usr/src' DPATH='/dist'
RUN mkdir "$BPATH"

RUN apk add --no-cache curl make gcc g++ linux-headers libc-dev

ARG VERSION_NGINX=1.16.1
ARG VERSION_LIBRESSL=3.0.2
ARG VERSION_ZLIB=1.2.11
ARG VERSION_PCRE=8.43

ENV FILE_NGINX="http://nginx.org/download/nginx-${VERSION_NGINX}.tar.gz"
ENV PATH_NGINX="${BPATH}/nginx"
RUN mkdir -p "$PATH_NGINX" && curl -fsSL "$FILE_NGINX" | tar zxv -C "$PATH_NGINX" --strip-components=1
ENV FILE_LIBRESSL="http://ftp.openbsd.org/pub/OpenBSD/LibreSSL/libressl-${VERSION_LIBRESSL}.tar.gz"
ENV PATH_LIBRESSL="${BPATH}/libressl"
RUN mkdir -p "$PATH_LIBRESSL" && curl -fsSL "$FILE_LIBRESSL" | tar zxv -C "$PATH_LIBRESSL" --strip-components=1
ENV FILE_ZLIB="http://zlib.net/zlib-${VERSION_ZLIB}.tar.gz"
ENV PATH_ZLIB="${BPATH}/zlib"
RUN mkdir -p "$PATH_ZLIB" && curl -fsSL "$FILE_ZLIB" | tar zxv -C "$PATH_ZLIB" --strip-components=1
ENV FILE_PCRE="http://ftp.pcre.org/pub/pcre/pcre-${VERSION_PCRE}.tar.gz"
ENV PATH_PCRE="${BPATH}/pcre"
RUN mkdir -p "$PATH_PCRE" && curl -fsSL "$FILE_PCRE" | tar zxv -C "$PATH_PCRE" --strip-components=1

COPY ./scripts "$DIR_SCRIPTS"

RUN find "$DIR_SCRIPTS" -type f -maxdepth 1 | sort | xargs -n1 sh -c

# DIST Stage
FROM alpine:latest

COPY --from=builder /dist /

RUN addgroup -g 994 -S nginx \
 && adduser  -u 996 -S -D -h /var/cache/nginx -s /sbin/nologin -G nginx nginx

EXPOSE 80 443
CMD ["/usr/sbin/nginx", "-g", "daemon off;"]
