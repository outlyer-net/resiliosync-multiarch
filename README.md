[dockerhub]: https://hub.docker.com/r/outlyernet/resiliosync-multiarch
[github]: https://github.com/outlyer-net/resiliosync-multiarch
[official README]: https://github.com/bt-sync/sync-docker/blob/master/README.md
[official README#usage]: https://github.com/bt-sync/sync-docker/blob/master/README.md#usage

## Unofficial Multi-architecture Resilio Sync Docker files

[![Static Badge](https://img.shields.io/badge/GitHub--_?style=social&logo=github)][github]
![GitHub Release](https://img.shields.io/github/v/release/outlyer-net/resiliosync-multiarch)
![GitHub Actions Workflow Status](https://img.shields.io/github/actions/workflow/status/outlyer-net/resiliosync-multiarch/deploy-image.yaml)
![GitHub last commit](https://img.shields.io/github/last-commit/outlyer-net/resiliosync-multiarch)


[![Static Badge](https://img.shields.io/badge/Docker%20Hub--_?style=social&logo=docker)][dockerhub]
![Docker Image Version](https://img.shields.io/docker/v/outlyernet/resiliosync-multiarch)
![Docker Image Size](https://img.shields.io/docker/image-size/outlyernet/resiliosync-multiarch)


This is a fork of the official [Resilio Sync for Docker repository](https://github.com/bt-sync/sync-docker) with some changes to be used on all architectures supported by Resilio Sync.

This repository is based _debian stable slim_ image unlike the official repository, which uses an Ubuntu image.

The image is both available in [Docker Hub][dockerhub] as `outlyernet/resiliosync-multiarch` and in [GitHub's Container Registry][github] as `ghcr.io/outlyer-net/resiliosync-multiarch`.

### Running with Docker Compose

This is my recommended way of running.

Edit `docker-compose/docker-compose.yml` to fit your needs, then:

```shell
cd docker-compose
docker compose up -d
```

### Running with Docker

See [upstream usage instructions][official README#usage] below, simple example:

```shell
docker run -d --name Sync \
           -p 127.0.0.1:8888:8888 \
           -p 55555/tcp \
           -p 55555/udp \
           -v ./data:/mnt/sync \
           -v /etc/localtime:/etc/localtime:ro \
           --restart always \
           outlyernet/resiliosync-multiarch
```

### Pulling the image

Docker will automatically pull the appropriate image for the architecture it is invoked on.

Included architectures: _amd64_, _arm v5_, _arm v7_, _arm v8_ (aka _aarch64_) and _i386_.

Each version is tagged with a semantic versioning scheme, e.g. `:2.8.0`. `:latest` always points to the most up to date version.

#### Pulling from Docker Hub

```shell
docker pull outlyernet/resiliosync-multiarch
```
or
```shell
docker pull outlyernet/resiliosync-multiarch:latest
```
or
```shell
docker pull outlyernet/resiliosync-multiarch:2.8.0
```

**NOTE:** Previous versions have separate tags for each architecture, I'm dropping these now that multiarch support in Docker is more widespread.

#### Pulling from GitHub Container Registry

```shell
docker pull ghcr.io/outlyer-net/resiliosync-multiarch
```
or
```shell
docker pull ghcr.io/outlyer-net/resiliosync-multiarch:latest
```
or
```shell
docker pull ghcr.io/outlyer-net/resiliosync-multiarch:2.8.0
```

### Build instructions

A Makefile is included to ease building.

#### Build for a single architecture

Build for the current architecture with Docker:
```shell
docker build . -t resilio
```

or using the makefile, e.g. to build for _amd64_:
```shell
make build PLATFORMS=linux/amd64
```

The list of current platforms is:
* `linux/amd64`
* `linux/i386`
* `linux/arm/v7`
* `linux/arm64`
* `linux/arm/v5`

Multiple platforms can be passed, separated by commas, e.g. to build for _amd64_ and _arm64_:

```shell
make PLATFORMS=linux/amd64,linux/arm64
```

#### Build all architectures

```shell
make
```

#### Build with Docker

To build without using the makefile:
```shell
docker build .
```

### Links

* [Official Docker image _README_][official README]
* [Docker Hub repository][dockerhub]: `outlyernet/resiliosync-multiarch`
* [Github repository][github]: `outlyer-net/resiliosync-multiarch`
