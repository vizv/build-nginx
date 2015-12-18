FROM ubuntu:latest
MAINTAINER Viz <viz@linux.com>

# TODO: including RTMP & PageSpeed modules is really heavy, remove them?

ENV DIR_SCRIPTS='/scripts' \
    BPATH='/tmp/build' \
    DPATH='/tmp/dist'

RUN apt-get update \
    && apt-get install -y wget build-essential libgd-dev \
    && apt-get clean && rm -rf /var/lib/apt/lists/* \
    && mkdir "$BPATH"

ENV PCRE_VERSION='8.38' \
    LIBRESSL_VERSION='2.3.1' \
    NGINX_VERSION='1.9.9' \
    PSOL_VERSION='1.10.33.1' \
    MOD_PAGESPEED_VERSION='1.10.33.1' \
    MOD_RTMP_VERSION='1.1.7' \
    SOURCE_PCRE='http://ftp.csx.cam.ac.uk/pub/software/programming/pcre' \
    SOURCE_LIBRESSL='http://ftp.openbsd.org/pub/OpenBSD/LibreSSL' \
    SOURCE_NGINX='http://nginx.org/download' \
    SOURCE_PSOL='https://dl.google.com/dl/page-speed/psol' \
    SOURCE_MOD_PAGESPEED='https://github.com/pagespeed/ngx_pagespeed/archive' \
    SOURCE_MOD_RTMP='https://github.com/arut/nginx-rtmp-module/archive'

ENV VERSION_PCRE="pcre-${PCRE_VERSION}" \
    VERSION_LIBRESSL="libressl-${LIBRESSL_VERSION}" \
    VERSION_NGINX="nginx-${NGINX_VERSION}" \
    VERSION_PSOL="${PSOL_VERSION}" \
    VERSION_MOD_PAGESPEED="release-${MOD_PAGESPEED_VERSION}-beta" \
    VERSION_MOD_RTMP="v${MOD_RTMP_VERSION}" \
    PATH_PCRE="${BPATH}/pcre-${PCRE_VERSION}" \
    PATH_LIBRESSL="${BPATH}/libressl-${LIBRESSL_VERSION}" \
    PATH_NGINX="${BPATH}/nginx-${NGINX_VERSION}" \
    PATH_MOD_PAGESPEED="${BPATH}/\
ngx_pagespeed-release-${MOD_PAGESPEED_VERSION}-beta" \
    PATH_MOD_RTMP="${BPATH}/nginx-rtmp-module-${MOD_RTMP_VERSION}"

# FIXME: checksum and verify signature before untar!
RUN cd "$BPATH" \
    && wget -qO- "${SOURCE_PCRE}/${VERSION_PCRE}.tar.gz" \
       | tar zxv \
    && wget -qO- "${SOURCE_LIBRESSL}/${VERSION_LIBRESSL}.tar.gz" \
       | tar zxv \
    && wget -qO- "${SOURCE_NGINX}/${VERSION_NGINX}.tar.gz" \
       | tar zxv \
    && wget -qO- "${SOURCE_PSOL}/${VERSION_PSOL}.tar.gz" \
       | tar zxv \
    && wget -qO- "${SOURCE_MOD_PAGESPEED}/${VERSION_MOD_PAGESPEED}.tar.gz" \
       | tar zxv \
    && wget -qO- "${SOURCE_MOD_RTMP}/${VERSION_MOD_RTMP}.tar.gz" \
       | tar zxv

COPY build /
CMD ["/build"]
