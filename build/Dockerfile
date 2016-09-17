FROM ubuntu:latest
MAINTAINER Viz <viz@linux.com>

ENV DIR_SCRIPTS='/scripts' \
    BPATH='/tmp/build' \
    DPATH='/tmp/dist'

RUN apt-get update \
    && apt-get install -y wget build-essential libgd-dev \
    && apt-get clean && rm -rf /var/lib/apt/lists/* \
    && mkdir "$BPATH"

ENV PCRE_VERSION='8.39' \
    LIBRESSL_VERSION='2.4.2' \
    NGINX_VERSION='1.11.4' \
    MOD_RTMP_VERSION='1.1.9' \
    MOD_HEADERS_MORE_VERSION='0.31' \
    MOD_FANCYINDEX_VERSION='0.4.1' \
    SOURCE_PCRE='http://ftp.csx.cam.ac.uk/pub/software/programming/pcre' \
    SOURCE_LIBRESSL='http://ftp.openbsd.org/pub/OpenBSD/LibreSSL' \
    SOURCE_NGINX='http://nginx.org/download' \
    SOURCE_MOD_RTMP='https://github.com/arut/nginx-rtmp-module/archive' \
    SOURCE_MOD_HEADERS_MORE='https://github.com/openresty/headers-more-nginx-module/archive' \
    SOURCE_MOD_FANCYINDEX='https://github.com/aperezdc/ngx-fancyindex/archive'

ENV VERSION_PCRE="pcre-${PCRE_VERSION}" \
    VERSION_LIBRESSL="libressl-${LIBRESSL_VERSION}" \
    VERSION_NGINX="nginx-${NGINX_VERSION}" \
    VERSION_MOD_RTMP="v${MOD_RTMP_VERSION}" \
    VERSION_MOD_HEADERS_MORE="v${MOD_HEADERS_MORE_VERSION}" \
    VERSION_MOD_FANCYINDEX="v${MOD_FANCYINDEX_VERSION}" \
    PATH_PCRE="${BPATH}/pcre-${PCRE_VERSION}" \
    PATH_LIBRESSL="${BPATH}/libressl-${LIBRESSL_VERSION}" \
    PATH_NGINX="${BPATH}/nginx-${NGINX_VERSION}" \
    PATH_MOD_RTMP="${BPATH}/nginx-rtmp-module-${MOD_RTMP_VERSION}" \
    PATH_MOD_HEADERS_MORE="${BPATH}/headers-more-nginx-module-${MOD_HEADERS_MORE_VERSION}" \
    PATH_MOD_FANCYINDEX="${BPATH}/ngx-fancyindex-${MOD_FANCYINDEX_VERSION}"

# FIXME: checksum and verify signature before untar!
RUN cd "$BPATH" \
    && wget -qO- "${SOURCE_PCRE}/${VERSION_PCRE}.tar.gz" \
       | tar zxv \
    && wget -qO- "${SOURCE_LIBRESSL}/${VERSION_LIBRESSL}.tar.gz" \
       | tar zxv \
    && wget -qO- "${SOURCE_NGINX}/${VERSION_NGINX}.tar.gz" \
       | tar zxv \
    && wget -qO- "${SOURCE_MOD_RTMP}/${VERSION_MOD_RTMP}.tar.gz" \
       | tar zxv \
    && wget -qO- "${SOURCE_MOD_HEADERS_MORE}/${VERSION_MOD_HEADERS_MORE}.tar.gz" \
       | tar zxv \
    && wget -qO- "${SOURCE_MOD_FANCYINDEX}/${VERSION_MOD_FANCYINDEX}.tar.gz" \
       | tar zxv

COPY build /
CMD ["/build"]
