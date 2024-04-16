[dockerhub]: https://hub.docker.com/r/outlyernet/resiliosync-multiarch
[github]: https://github.com/outlyer-net/resiliosync-multiarch

## Unofficial Multi-architecture Resilio Sync Docker files

[![Static Badge](https://img.shields.io/badge/GitHub--_?style=social&logo=github)][github]
![GitHub Release](https://img.shields.io/github/v/release/outlyer-net/resiliosync-multiarch)
![GitHub Actions Workflow Status](https://img.shields.io/github/actions/workflow/status/outlyer-net/resiliosync-multiarch/deploy-image.yaml)
![GitHub last commit](https://img.shields.io/github/last-commit/outlyer-net/resiliosync-multiarch)


[![Static Badge](https://img.shields.io/badge/Docker%20Hub--_?style=social&logo=docker)][dockerhub]
![Docker Image Version](https://img.shields.io/docker/v/outlyernet/resiliosync-multiarch)
![Docker Image Size](https://img.shields.io/docker/image-size/outlyernet/resiliosync-multiarch)


This is a fork of the official [Resilio Sync for Docker repository](https://github.com/bt-sync/sync-docker) with small changes to be used on all architectures supported by Resilio Sync.

### Running with Docker Compose

This is my recommended way of running.

Edit `docker-compose/docker-compose.yml` to fit your needs, then:

```shell
cd docker-compose
docker compose up -d
```

### Running with Docker

See [upstream usage instructions](#usage) below, simple example:

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

### Pulling the image from Docker Hub

For the architectures included in the multiarch support (`amd64`, `armhf`, `arm64` and `i386`):

```shell
docker pull outlyernet/resiliosync-multiarch
```

which is equivalent to

```shell
docker pull outlyernet/resiliosync-multiarch:latest
```

may also use the version tag:

```shell
docker pull outlyernet/resiliosync-multiarch:2.7.3
```

As of this writing images for ARMv5 or ARMv6 (`armle`) are excluded from the automatic architecture selection mechanism, since Docker Hub doesn't appear to distinguish them from ARMv7. For those use:

```shell
docker pull outlyernet/resiliosync-multiarch:latest-armle
```

or

```shell
docker pull outlyernet/resiliosync-multiarch:2.6.3-armle
```

### Build instructions

> **WARNING:** \
> This is still somewhat volatile while I settle on how to
handle these images, the tags in particular are being re-defined
as I make small tweaks. Please keep it mind (everything should work, though).\
I'll remove this warning once the repository stabilises.

This repository has just a few key differences compared to the upstream one:

  1. Multiple `Dockerfile`s are provided, one per arch. They are different from the official one in the way the image is built, to ease multi-architecture support, but the end structure is the same, except the License for Resilio Sync is also included in the image.
  1. A makefile is provided to generate the different `Dockerfile`s and images.
  1. They're based on a _debian stable slim_ image instead of on an Ubuntu image.

In practice they should work exactly the same as the official one.

The `Dockerfile`s:

* `amd64.Dockerfile`: For AMD64 aka x86_64 aka x64 (64 bit PC)
* `arm64.Dockerfile`: For ARM64 aka ARMv8 aka AArch64 (64 bit ARM)
* `armhf.Dockerfile`: For armhf aka ARMv7 (and up), (32 bit ARM with hardware float support). Superseded by `arm64`.
* `armle.Dockerfile`: For armle aka EABI ARM (ARMv5 and up), (32 bit ARM). Superseded by `armhf` and `arm64`. Docker Hub does not provided official support for this architecture. NOTE: This image isn't a part of the auto-selected architecture images (e.g. `resiliosync-multiarch:latest`), you'll have to use `resiliosync-multiarch:armle-latest` directly.
* `i386.Dockerfile`: For i386 aka x86 aka IA-32 (32 bit PC). Superseded by `amd64`. Docker Hub does not provided official support for this architecture.

### Links

* [Docker Hub repository][dockerhub]: `outlyernet/resiliosync-multiarch`
* [Github repository][github]: `outlyer-net/resiliosync-multiarch`

---
> **Below is the official README**

## Resilio Sync

https://www.resilio.com

Sync uses peer-to-peer technology to provide fast, private file sharing for teams and individuals. By skipping the cloud, transfers can be significantly faster because files take the shortest path between devices. Sync does not store your information on servers in the cloud, avoiding cloud privacy concerns.

### Usage

```
# path to folder on the host to be mounted to container as Sync storage folder
DATA_FOLDER=/path/to/data/folder/on/the/host
mkdir -p $DATA_FOLDER

# port to access the webui on the host
WEBUI_PORT=8888

# ensure you have the latest image locally
docker pull resilio/sync

# run container from downloaded image
docker run -d --name Sync \
           -p 127.0.0.1:$WEBUI_PORT:8888 \
           -p 55555/tcp \
           -p 55555/udp \
           -v $DATA_FOLDER:/mnt/sync \
           -v /etc/localtime:/etc/localtime:ro \
           --restart always \
           resilio/sync
```
Note 1: we need to mount `/etc/localtime` from host OS to container to ensure container's time is synced with the host's time.

Note 2: you can use our official Docker image `resilio/sync` hosted on https://hub.docker.com/u/resilio or build image manually:
```
git clone git@github.com:bt-sync/sync-docker.git
cd sync-docker
docker build -t resilio/sync .
```

Be sure to always run docker container with `--restart` parameter to allow Docker daemon to handle Sync container (launch at startup as well as restart it in case of failure).

Go to `http://localhost:$WEBUI_PORT` in a web browser to access the web UI.

If you need to run Sync under specific user inside your container - use `--user` [parameter](https://docs.docker.com/engine/reference/run/#user) or [set](https://www.linuxserver.io/docs/puid-pgid/) `PUID` and `PGID` env vars for container.

Running Sync in docker container via [docker-compose](https://docs.docker.com/compose/) is described [here](https://github.com/bt-sync/sync-docker/tree/master/docker-compose).

### Volumes

* `/mnt/sync` - folder inside the container that contains the [storage folder](https://help.resilio.com/hc/en-us/articles/206664690-Sync-Storage-folder), [configuration file](https://help.resilio.com/hc/en-us/articles/206178884) and default download folder

* `/etc/localtime` - file (symlink) that [configures](https://unix.stackexchange.com/questions/85925/how-can-i-examine-the-contents-of-etc-localtime) the system-wide timezone of the local system that is used by applications for presentation to the user

### Ports

* `8888` - Webui port
* `55555` - Listening port (both TCP and UDP) for Sync traffic (you can change it, but in this case change it in Sync [settings](https://help.resilio.com/hc/en-us/articles/204762669-Sync-Preferences) as well)

Find more info [here](https://help.resilio.com/hc/en-us/articles/204754759-What-ports-and-protocols-are-used-by-Sync-) about ports used by Sync.

#### LAN access

If you do not want to limit the access to the webui - do not specify `localhost` address in `-p` parameter, 
in this case every person in your LAN will be able to access web UI via `http://<your_ip_address>:<WEBUI_PORT>`:

```
WEBUI_PORT=8888

docker run -d --name Sync \
           -p $WEBUI_PORT:8888 \
           -p 55555/tcp \
           -p 55555/udp \
           -v $DATA_FOLDER:/mnt/sync \
           -v /etc/localtime:/etc/localtime:ro \
           --restart always \
           resilio/sync
```

You can also force web UI to work over https instead of http. To do this you need to add `force_https` parameter in 
config file in `webui` section with `true` value. More info about config file parameters is [here](https://help.resilio.com/hc/en-us/articles/206178884-Running-Sync-in-configuration-mode).

#### Extra directories

If you need to mount extra directories, mount them in `/mnt/mounted_folders`:

```
OTHER_DIR=/path/to/some/dir/on/host
OTHER_DIR2=/path/to/some/another/dir/on/host

docker run -d --name Sync \
           -p 127.0.0.1:$WEBUI_PORT:8888 \
           -p 55555/tcp \
           -p 55555/udp \
           -v $DATA_FOLDER:/mnt/sync \
           -v $OTHER_DIR:/mnt/mounted_folders/DIR_NAME \
           -v $OTHER_DIR2:/mnt/mounted_folders/DIR_NAME2 \
           -v /etc/localtime:/etc/localtime:ro \
           --restart always \
           resilio/sync
```

Note: do not create directories at the root of `/mnt/mounted_folders` from the Sync web UI since they will not be mounted to the host. You need to mount those first as described above and then add them in Sync via web UI.

### Miscellaneous

- Additional info and various Sync guides can be found in our [help center](https://help.resilio.com)
- If you have any questions left, please contact us via [support page](https://help.resilio.com/hc/en-us/requests/new?ticket_form_id=91563) or visit our forum at [https://forum.resilio.com](https://forum.resilio.com)
- Read our [official blog](https://www.resilio.com/blog/)
- Docker [hub](https://hub.docker.com/r/resilio/sync/)
- Discover our [other products](https://www.resilio.com/sync-vs-connect/)
- Learn [legal information](https://www.resilio.com/legal/privacy/)
- If you found some security vulnerability in our product - please follow [this article](https://help.resilio.com/hc/en-us/articles/360000294599-How-to-Report-Security-Vulnerabilities-to-Resilio-Inc-)
