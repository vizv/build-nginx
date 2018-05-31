# NGINX Build Engine

This repository contains Dockerfile and build scripts for building a **small**, **fast**, and **customized** NGINX Docker image.

## Version Information

* [nginx/1.13.12](http://nginx.org/)

### Libraries

* [LibreSSL/2.7.3](http://www.libressl.org/)
* [zlib/1.2.11](http://zlib.net/)
* [PCRE/8.42](http://www.pcre.org/)

### Modules

* [nginx-rtmp-module/1.2.1](https://github.com/arut/nginx-rtmp-module)
* [ngx-fancyindex/0.4.2](https://github.com/aperezdc/ngx-fancyindex)

## Usage

### Build

1. (Optional) you may modify `scripts` directory to adapt to your needs.
2. run `make`.

Note: When running `make`, you may specify version by setting `VERSION_XXX`, or set `IMAGE` and `TAG` for tagging Docker images.

### Run

* I recommend you use the latest version of Docker and deploy with `docker stack deploy -c nginx.yml nginx`.

More information about `docker stack deploy` please check [documents](https://docs.docker.com/engine/reference/commandline/stack_deploy/).
