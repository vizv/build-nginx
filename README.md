# Nginx Build Engine

This repository contains build scripts for customizing nginx.

* [nginx/1.11.8](http://nginx.org/)

## Libraries

* [zlib/1.2.10](http://zlib.net/)
* [PCRE/8.39](http://www.pcre.org/)
* [LibreSSL/2.4.4](http://www.libressl.org/)

## Modules

* [nginx-rtmp-module/1.1.10](https://github.com/arut/nginx-rtmp-module)
* [headers-more-nginx-module/0.32](https://github.com/openresty/headers-more-nginx-module)
* [ngx-fancyindex/0.4.1](https://github.com/aperezdc/ngx-fancyindex)

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
