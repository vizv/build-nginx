# NGINX Build Engine

This repository contains Dockerfile and build scripts for building a **small**, **fast**, and **customized** NGINX Docker image.

## Version Information

* [nginx/1.14.2](http://nginx.org/)

### Libraries

* [LibreSSL/2.8.3](http://www.libressl.org/)
* [zlib/1.2.11](http://zlib.net/)
* [PCRE/8.42](http://www.pcre.org/)

### Modules

All modules has been removed to keep the footprint small (and more secure)

## Usage

### Build

1. (Optional) you may modify `scripts` directory to adapt to your needs.
2. run `make`.

Note: When running `make`, you may specify version by setting `VERSION_XXX`, or set `IMAGE` and `TAG` for tagging Docker images.

### Run

* I recommend you use the latest version of Docker and deploy with `docker stack deploy -c nginx.yml nginx`.

More information about `docker stack deploy` please check [documents](https://docs.docker.com/engine/reference/commandline/stack_deploy/).
