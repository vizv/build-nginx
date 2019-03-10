.PHONY: all

VERSION_NGINX           ?=  '1.14.2'
VERSION_LIBRESSL        ?=   '2.8.3'
VERSION_ZLIB            ?=  '1.2.11'
VERSION_PCRE            ?=    '8.42'

IMAGE  ?=  nginx
TAG    ?=  $(VERSION_NGINX)

all:
	docker build -t $(IMAGE):$(TAG) \
	             --build-arg VERSION_NGINX=$(VERSION_NGINX) \
	             --build-arg VERSION_LIBRESSL=$(VERSION_LIBRESSL) \
	             --build-arg VERSION_ZLIB=$(VERSION_ZLIB) \
	             --build-arg VERSION_PCRE=$(VERSION_PCRE) \
	             .
	docker tag $(IMAGE):$(TAG) $(IMAGE):latest
