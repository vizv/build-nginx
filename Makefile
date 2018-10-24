.PHONY: all

VERSION_NGINX           ?=  '1.15.5'
VERSION_LIBRESSL        ?=   '2.8.2'
VERSION_ZLIB            ?=  '1.2.11'
VERSION_PCRE            ?=    '8.42'
VERSION_MOD_RTMP        ?=   '1.2.1'
VERSION_MOD_FANCYINDEX  ?=   '0.4.3'

IMAGE  ?=  nginx
TAG    ?=  $(VERSION_NGINX)

all:
	docker build -t $(IMAGE):$(TAG) \
                     --build-arg VERSION_NGINX=$(VERSION_NGINX) \
                     --build-arg VERSION_LIBRESSL=$(VERSION_LIBRESSL) \
                     --build-arg VERSION_ZLIB=$(VERSION_ZLIB) \
                     --build-arg VERSION_PCRE=$(VERSION_PCRE) \
                     --build-arg VERSION_MOD_RTMP=$(VERSION_MOD_RTMP) \
                     --build-arg VERSION_MOD_FANCYINDEX=$(VERSION_MOD_FANCYINDEX) \
                     .
	docker tag $(IMAGE):$(TAG) $(IMAGE):latest
