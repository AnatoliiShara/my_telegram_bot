REGISTRY ?= ghcr.io
OWNER    ?= anatoliishara
APP      ?= my-telegram-bot
IMG_REPO ?= $(REGISTRY)/$(OWNER)/$(APP)

VERSION  ?= v1.0.0
SHORTSHA ?= $(shell git rev-parse --short HEAD)
OS       ?= linux
ARCH     ?= amd64
TAG      ?= $(VERSION)-$(SHORTSHA)-$(OS)-$(ARCH)

build:
	CGO_ENABLED=0 GOOS=$(OS) GOARCH=$(ARCH) go build -ldflags="-s -w" -o bin/app ./...

docker-build:
	docker build -t $(IMG_REPO):$(TAG) .

docker-push:
	docker push $(IMG_REPO):$(TAG)

helm-set-tag:
	@which yq >/dev/null || (echo "yq is required"; exit 1)
	yq -i '.image.registry = "$(REGISTRY)" |
	       .image.repository = "$(OWNER)/$(APP)" |
	       .image.tag = "$(VERSION)-$(SHORTSHA)" |
	       .image.os = "$(OS)" |
	       .image.arch = "$(ARCH)"' helm/values.yaml

all: build docker-build docker-push helm-set-tag
