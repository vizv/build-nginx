# Nginx Build Engine

This repository contains build scripts for customizing nginx.

* [nginx/1.13.4](http://nginx.org/)

## Libraries

* [zlib/1.2.11](http://zlib.net/)
* [PCRE/8.41](http://www.pcre.org/)
* [LibreSSL/2.5.5](http://www.libressl.org/)

## Modules

* [nginx-rtmp-module/1.2.0](https://github.com/arut/nginx-rtmp-module)
* [headers-more-nginx-module/0.32](https://github.com/openresty/headers-more-nginx-module)
* [ngx-fancyindex/0.4.2](https://github.com/aperezdc/ngx-fancyindex)

## Usage

``` bash
cd build
docker build -t build-nginx .

cd ..
docker run --rm -it \
           -v "$(pwd)/build/scripts:/scripts:ro" \
           -v "$(pwd)/dist/files:/dist" \
           build-nginx
docker rmi build-nginx

cd dist
docker build -t nginx .
```
