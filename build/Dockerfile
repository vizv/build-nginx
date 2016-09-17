FROM alpine:edge
MAINTAINER Viz <viz@linux.com>

ENV DIR_SCRIPTS='/scripts' \
    BPATH='/usr/src' \
    DPATH='/dist'
RUN mkdir "$BPATH"

RUN apk add --no-cache curl make gcc g++ linux-headers libc-dev

ENV GITHUB='https://github.com'

ENV NAME='zlib'
ENV VERSION='1.2.8'
ENV SOURCE='http://zlib.net'
ENV FILE_ZLIB="${SOURCE}/${NAME}-${VERSION}"
ENV PATH_ZLIB="${BPATH}/${NAME}-${VERSION}"
RUN cd "$BPATH" && curl -fsSL "${FILE_ZLIB}.tar.gz" | tar zxv

ENV NAME='pcre'
ENV VERSION='8.39'
ENV SOURCE='http://ftp.csx.cam.ac.uk/pub/software/programming/pcre'
ENV FILE_PCRE="${SOURCE}/${NAME}-${VERSION}"
ENV PATH_PCRE="${BPATH}/${NAME}-${VERSION}"
RUN cd "$BPATH" && curl -fsSL "${FILE_PCRE}.tar.gz" | tar zxv

ENV NAME='nginx-rtmp-module'
ENV VERSION='1.1.9'
ENV SOURCE="${GITHUB}/arut/${NAME}/archive"
ENV FILE_MOD_RTMP="${SOURCE}/v${VERSION}"
ENV PATH_MOD_RTMP="${BPATH}/${NAME}-${VERSION}"
RUN cd "$BPATH" && curl -fsSL "${FILE_MOD_RTMP}.tar.gz" | tar zxv

ENV NAME='headers-more-nginx-module'
ENV VERSION='0.31'
ENV SOURCE="${GITHUB}/openresty/${NAME}/archive"
ENV FILE_MOD_HEADERS_MORE="${SOURCE}/v${VERSION}"
ENV PATH_MOD_HEADERS_MORE="${BPATH}/${NAME}-${VERSION}"
RUN cd "$BPATH" && curl -fsSL "${FILE_MOD_HEADERS_MORE}.tar.gz" | tar zxv

ENV NAME='ngx-fancyindex'
ENV VERSION='0.4.1'
ENV SOURCE="${GITHUB}/aperezdc/${NAME}/archive"
ENV FILE_MOD_FANCYINDEX="${SOURCE}/v${VERSION}"
ENV PATH_MOD_FANCYINDEX="${BPATH}/ngx-fancyindex-${VERSION}"
RUN cd "$BPATH" && curl -fsSL "${FILE_MOD_FANCYINDEX}.tar.gz" | tar zxv

ENV NAME='libressl'
ENV VERSION='2.4.2'
ENV SOURCE='http://ftp.openbsd.org/pub/OpenBSD/LibreSSL'
ENV FILE_LIBRESSL="${SOURCE}/${NAME}-${VERSION}"
ENV PATH_LIBRESSL="${BPATH}/${NAME}-${VERSION}"
RUN cd "$BPATH" && curl -fsSL "${FILE_LIBRESSL}.tar.gz" | tar zxv

ENV NAME='nginx'
ENV VERSION='1.11.4'
ENV SOURCE='http://nginx.org/download'
ENV FILE_NGINX="${SOURCE}/${NAME}-${VERSION}"
ENV PATH_NGINX="${BPATH}/${NAME}-${VERSION}"
RUN cd "$BPATH" && curl -fsSL "${FILE_NGINX}.tar.gz" | tar zxv

COPY build /
CMD ["/build"]
