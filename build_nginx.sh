#!/usr/bin/env bash

# names of latest versions of each package
export VERSION_PCRE=pcre-8.35
export VERSION_OPENSSL=openssl-1.0.1g
export VERSION_NGINX=nginx-1.7.1

# URLs to the source directories
export SOURCE_OPENSSL=https://www.openssl.org/source/
export SOURCE_PCRE=ftp://ftp.csx.cam.ac.uk/pub/software/programming/pcre/
export SOURCE_NGINX=http://nginx.org/download/

# clean out any files from previous runs of this script
rm -rf build
mkdir build

# ensure that we have the required software to compile our own nginx
sudo apt-get -y install curl wget build-essential

# grab the source files
wget -P ./build $SOURCE_PCRE$VERSION_PCRE.tar.gz
wget -P ./build $SOURCE_OPENSSL$VERSION_OPENSSL.tar.gz --no-check-certificate
wget -P ./build $SOURCE_NGINX$VERSION_NGINX.tar.gz

# expand the source files
cd build
tar xzf $VERSION_NGINX.tar.gz
tar xzf $VERSION_OPENSSL.tar.gz
tar xzf $VERSION_PCRE.tar.gz
cd ../

# set where OpenSSL and nginx will be built
export BPATH=$(pwd)/build
export STATICLIBSSL="$BPATH/staticlibssl"

# build static openssl
cd $BPATH/$VERSION_OPENSSL
rm -rf "$STATICLIBSSL"
mkdir "$STATICLIBSSL"
make clean
./config --prefix=$STATICLIBSSL no-shared enable-ec_nistp_64_gcc_128 \
&& make depend \
&& make \
&& make install_sw

# rename the existing /etc/nginx directory so it's saved as a back-up
mv /etc/nginx /etc/nginx-bk

# build nginx, with various modules included/excluded
cd $BPATH/$VERSION_NGINX
mkdir -p $BPATH/nginx
./configure --with-cc-opt="-I $STATICLIBSSL/include -I/usr/include" \
--with-ld-opt="-L $STATICLIBSSL/lib -Wl,-rpath -lssl -lcrypto -ldl -lz" \
--sbin-path=/usr/sbin/nginx \
--conf-path=/etc/nginx/nginx.conf \
--pid-path=/var/run/nginx.pid \
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
&& make && make install

# rename the compiled /etc/nginx directory so its accessible as a reference to the new nginx defaults
mv /etc/nginx /etc/nginx-default

# now restore the /etc/nginx-bk to /etc/nginx so the old settings are kept
mv /etc/nginx-bk /etc/nginx

echo "All done.";
echo "This build has not edited your existing /etc/nginx directory.";
echo "If things aren't working now you may need to refer to the";
echo "configuration files the new nginx ships with as defaults,";
echo "which are available at /etc/nginx-default";