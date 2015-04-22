#!/usr/bin/env bash
 
# names of latest versions of each package
export NGINX_VERSION=1.8.0
export VERSION_PCRE=pcre-8.36
export VERSION_LIBRESSL=libressl-2.1.6
export VERSION_NGINX=nginx-$NGINX_VERSION
export NPS_VERSION=1.9.32.3
export VERSION_PAGESPEED=v${NPS_VERSION}-beta
 
# URLs to the source directories
export SOURCE_LIBRESSL=ftp://ftp.openbsd.org/pub/OpenBSD/LibreSSL/
export SOURCE_PCRE=ftp://ftp.csx.cam.ac.uk/pub/software/programming/pcre/
export SOURCE_NGINX=http://nginx.org/download/
export SOURCE_RTMP=https://github.com/arut/nginx-rtmp-module.git
export SOURCE_PAGESPEED=https://github.com/pagespeed/ngx_pagespeed/archive/
 
# clean out any files from previous runs of this script
rm -rf build
mkdir build
 
# ensure that we have the required software to compile our own nginx
sudo apt-get -y install curl wget build-essential libgd-dev libgeoip-dev checkinstall git
 
# grab the source files
echo "Download sources"
wget -P ./build $SOURCE_PCRE$VERSION_PCRE.tar.gz
wget -P ./build $SOURCE_LIBRESSL$VERSION_LIBRESSL.tar.gz
wget -P ./build $SOURCE_NGINX$VERSION_NGINX.tar.gz
wget -P ./build $SOURCE_PAGESPEED$VERSION_PAGESPEED.tar.gz
wget -P ./build https://dl.google.com/dl/page-speed/psol/${NPS_VERSION}.tar.gz
git clone $SOURCE_RTMP ./build/rtmp
 
# expand the source files
echo "Extract Packages"
cd build
tar xzf $VERSION_NGINX.tar.gz
tar xzf $VERSION_LIBRESSL.tar.gz
tar xzf $VERSION_PCRE.tar.gz
tar xzf $VERSION_PAGESPEED.tar.gz
tar xzf ${NPS_VERSION}.tar.gz -C ngx_pagespeed-${NPS_VERSION}-beta
cd ../
# set where LibreSSL and nginx will be built
export BPATH=$(pwd)/build
export STATICLIBSSL=$BPATH/$VERSION_LIBRESSL
 
# build static LibreSSL
echo "Configure & Build LibreSSL"
cd $STATICLIBSSL
./configure LDFLAGS=-lrt --prefix=${STATICLIBSSL}/.openssl/ && make install-strip
 
# build nginx, with various modules included/excluded
echo "Configure & Build Nginx"
cd $BPATH/$VERSION_NGINX
#echo "Download and apply path"
#wget -q -O - $NGINX_PATH | patch -p0
mkdir -p $BPATH/nginx
./configure  --with-openssl=$STATICLIBSSL \
--with-ld-opt="-lrt"  \
--sbin-path=/usr/sbin/nginx \
--conf-path=/etc/nginx/nginx.conf \
--error-log-path=/var/log/nginx/error.log \
--http-log-path=/var/log/nginx/access.log \
--with-pcre=$BPATH/$VERSION_PCRE \
--with-http_ssl_module \
--with-http_spdy_module \
--with-file-aio \
--with-ipv6 \
--with-http_gzip_static_module \
--with-http_stub_status_module \
--without-mail_pop3_module \
--without-mail_smtp_module \
--without-mail_imap_module \
--with-http_image_filter_module \
 --lock-path=/var/lock/nginx.lock \
 --pid-path=/run/nginx.pid \
 --http-client-body-temp-path=/var/lib/nginx/body \
 --http-fastcgi-temp-path=/var/lib/nginx/fastcgi \
 --http-proxy-temp-path=/var/lib/nginx/proxy \
 --http-scgi-temp-path=/var/lib/nginx/scgi \
 --http-uwsgi-temp-path=/var/lib/nginx/uwsgi \
 --with-debug \
 --with-pcre-jit \
 --with-http_stub_status_module \
 --with-http_realip_module \
 --with-http_auth_request_module \
 --with-http_addition_module \
 --with-http_geoip_module \
 --with-http_gzip_static_module \
 --add-module=$BPATH/rtmp \
 --add-module=$BPATH/ngx_pagespeed-${NPS_VERSION}-beta
 
touch $STATICLIBSSL/.openssl/include/openssl/ssl.h
make && sudo checkinstall --pkgname="nginx-libressl" --pkgversion="$NGINX_VERSION" \
--provides="nginx" --requires="libc6, libpcre3, zlib1g" --strip=yes \
--stripso=yes --backup=yes -y --install=yes
 
echo "All done.";
echo "This build has not edited your existing /etc/nginx directory.";
echo "If things aren't working now you may need to refer to the";
echo "configuration files the new nginx ships with as defaults,";
echo "which are available at /etc/nginx-default";