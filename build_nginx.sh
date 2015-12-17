#!/bin/sh

# enable strict mode
set -e

# names of latest versions of each package
export PCRE_VERSION='8.38'
export LIBRESSL_VERSION='2.3.1'
export NGINX_VERSION='1.9.9'
export PSOL_VERSION='1.10.33.1'
export MOD_PAGESPEED_VERSION="$PSOL_VERSION"
export MOD_RTMP_VERSION='1.1.7'

export VERSION_PCRE="pcre-${PCRE_VERSION}"
export VERSION_LIBRESSL="libressl-${LIBRESSL_VERSION}"
export VERSION_NGINX="nginx-${NGINX_VERSION}"
export VERSION_PSOL="${PSOL_VERSION}"
export VERSION_MOD_PAGESPEED="release-${MOD_PAGESPEED_VERSION}-beta"
export VERSION_MOD_RTMP="v${MOD_RTMP_VERSION}"
 
# URLs to the source directories
export SOURCE_PCRE='http://ftp.csx.cam.ac.uk/pub/software/programming/pcre'
export SOURCE_LIBRESSL='http://ftp.openbsd.org/pub/OpenBSD/LibreSSL'
export SOURCE_NGINX='http://nginx.org/download'
export SOURCE_PSOL='https://dl.google.com/dl/page-speed/psol'
export SOURCE_MOD_PAGESPEED='https://github.com/pagespeed/ngx_pagespeed/archive'
export SOURCE_MOD_RTMP='https://github.com/arut/nginx-rtmp-module/archive'

# set paths
export BPATH='/tmp/build'

export PATH_PCRE="${BPATH}/pcre-${PCRE_VERSION}"
export PATH_LIBRESSL="${BPATH}/libressl-${LIBRESSL_VERSION}"
export PATH_NGINX="${BPATH}/nginx-${NGINX_VERSION}"
export PATH_MOD_PAGESPEED="${BPATH}/\
ngx_pagespeed-release-${MOD_PAGESPEED_VERSION}-beta"
export PATH_MOD_RTMP="${BPATH}/nginx-rtmp-module-${MOD_RTMP_VERSION}"
 
# clean out any files from previous runs of this script
rm -rf "$BPATH"
mkdir "$BPATH"
cd "$BPATH"

# proc for building faster
NB_PROC=$(grep -c '^processor' /proc/cpuinfo)
 
# ensure that we have the required software to compile our own nginx
apt-get -y install wget build-essential libgd-dev
 
# grab the source files
echo "Download sources"
wget "${SOURCE_PCRE}/${VERSION_PCRE}.tar.gz"
wget "${SOURCE_LIBRESSL}/${VERSION_LIBRESSL}.tar.gz"
wget "${SOURCE_NGINX}/${VERSION_NGINX}.tar.gz"
wget "${SOURCE_PSOL}/${VERSION_PSOL}.tar.gz"
wget "${SOURCE_MOD_PAGESPEED}/${VERSION_MOD_PAGESPEED}.tar.gz"
wget "${SOURCE_MOD_RTMP}/${VERSION_MOD_RTMP}.tar.gz"
 
# expand the source files
echo "Extract Packages"
tar xvf "${VERSION_PCRE}.tar.gz"
tar xvf "${VERSION_LIBRESSL}.tar.gz"
tar xvf "${VERSION_NGINX}.tar.gz"
tar xvf "${VERSION_MOD_PAGESPEED}.tar.gz"
tar xvf "${VERSION_PSOL}.tar.gz" -C "$PATH_MOD_PAGESPEED"
tar xvf "${VERSION_MOD_RTMP}.tar.gz"
 
# build static LibreSSL TODO: do I really want to pre-build it???
echo "Configure & Build LibreSSL"
cd "$PATH_LIBRESSL"
./configure LDFLAGS=-lrt --prefix=${PATH_LIBRESSL}/.openssl/
make install-strip -j $NB_PROC
 
# build nginx, with various modules included/excluded
echo "Configure & Build Nginx"
cd "$PATH_NGINX"

./configure --with-openssl="$PATH_LIBRESSL" \
            --with-ld-opt="-lrt"  \
            --sbin-path=/usr/sbin/nginx \
            --conf-path=/etc/nginx/nginx.conf \
            --error-log-path=/var/log/nginx/error.log \
            --http-log-path=/var/log/nginx/access.log \
            --with-pcre="$PATH_PCRE" \
            --with-http_ssl_module \
            --with-http_v2_module \
            --with-http_realip_module \
            --with-http_addition_module \
            --with-http_gzip_static_module \
            --with-http_stub_status_module \
            --with-http_auth_request_module \
            --with-file-aio \
            --with-ipv6 \
            --without-http_geo_module \
            --without-mail_pop3_module \
            --without-mail_smtp_module \
            --without-mail_imap_module \
            --lock-path=/var/lock/nginx.lock \
            --pid-path=/run/nginx.pid \
            --http-client-body-temp-path=/var/lib/nginx/body \
            --http-fastcgi-temp-path=/var/lib/nginx/fastcgi \
            --http-proxy-temp-path=/var/lib/nginx/proxy \
            --http-scgi-temp-path=/var/lib/nginx/scgi \
            --http-uwsgi-temp-path=/var/lib/nginx/uwsgi \
            --with-debug \
            --with-pcre-jit \
            --add-module="$PATH_MOD_RTMP" \
            --add-module="$PATH_MOD_PAGESPEED"
 
# TODO: Why touch?
touch "${PATH_LIBRESSL}/.openssl/include/openssl/ssl.h"
make -j $NB_PROC
make DESTDIR=/tmp/stage install

echo 'Done!'
