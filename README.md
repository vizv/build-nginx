# NGINX Build Engine

This repository contains Dockerfile and build scripts for building a **small**, **fast**, and **customized** NGINX Docker image.

## Version Information

* [nginx/1.13.5](http://nginx.org/)

### Libraries

* [LibreSSL/2.5.5](http://www.libressl.org/)
* [zlib/1.2.11](http://zlib.net/)
* [PCRE/8.41](http://www.pcre.org/)

### Modules

* [nginx-rtmp-module/1.2.0](https://github.com/arut/nginx-rtmp-module)
* [ngx-fancyindex/0.4.2](https://github.com/aperezdc/ngx-fancyindex)

## Usage

1. (Optional) you may modify `scripts` directory to adapt to your needs.
2. run `make`.

> Note: When running `make`, you may specify version by setting `VERSION_XXX`, or set `IMAGE` and `TAG` for tagging Docker images.

