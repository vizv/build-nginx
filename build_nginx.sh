#!/usr/bin/env bash

# names of latest versions of each package
export NGINX_VERSION=1.7.10
export VERSION_PCRE=pcre-8.36
export VERSION_LIBRESSL=libressl-2.1.3
export VERSION_NGINX=nginx-$NGINX_VERSION

# URLs to the source directories
export SOURCE_LIBRESSL=ftp://ftp.openbsd.org/pub/OpenBSD/LibreSSL/
export SOURCE_PCRE=ftp://ftp.csx.cam.ac.uk/pub/software/programming/pcre/
export SOURCE_NGINX=http://nginx.org/download/
#export NGINX_PATH=https://raw.githubusercontent.com/technion/libressl_nginx/master/nginx-libressl2.patch

# clean out any files from previous runs of this script
rm -rf build
mkdir build

# ensure that we have the required software to compile our own nginx
sudo apt-get -y install curl wget build-essential libgd-dev libgeoip-dev

# grab the source files
echo "Download sources"
wget -P ./build $SOURCE_PCRE$VERSION_PCRE.tar.gz
wget -P ./build $SOURCE_LIBRESSL$VERSION_LIBRESSL.tar.gz
wget -P ./build $SOURCE_NGINX$VERSION_NGINX.tar.gz

# expand the source files
cd build
tar xzf $VERSION_NGINX.tar.gz
tar xzf $VERSION_LIBRESSL.tar.gz
tar xzf $VERSION_PCRE.tar.gz
cd ../

# set where LibreSSL and nginx will be built
export BPATH=$(pwd)/build
export STATICLIBSSL=$BPATH/$VERSION_LIBRESSL

# build static LibreSSL
echo "Configure & Build LibreSSL"
cd $STATICLIBSSL
echo -e "#! /bin/bash \n./configure LDFLAGS=-lrt" > config
chmod +x config
./configure && make check
if  [ -d ".openssl" ]; then
  rm -Rf .openssl
fi

mkdir -p .openssl/lib

cp crypto/.libs/libcrypto.a ssl/.libs/libssl.a .openssl/lib
cd .openssl && ln -s ../include ./

# you might want to strip debugging-symbols
cd .openssl/lib && strip -g libssl.a  && strip -g libcrypto.a

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
 --with-http_gzip_static_module

touch $STATICLIBSSL/.openssl/include/openssl/ssl.h
make && sudo checkinstall --pkgname="nginx-libressl" --pkgversion="$NGINX_VERSION" \
--provides="nginx" --requires="libc6, libpcre3, zlib1g" --strip=yes \
--stripso=yes --backup=yes -y --install=yes

echo "All done.";
echo "This build has not edited your existing /etc/nginx directory.";
echo "If things aren't working now you may need to refer to the";
echo "configuration files the new nginx ships with as defaults,";
echo "which are available at /etc/nginx-default";