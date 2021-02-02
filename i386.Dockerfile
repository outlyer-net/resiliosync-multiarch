# Unofficial Resilio Sync
#
# This Dockerfile creates an image for the i386 architecture.
#
# <https://github.com/outlyer-net/resiliosync-docker-multiarch>
#
# Must be defined before the first FROM
ARG DOCKER_PREFIX=i386
ARG RELEASE="2.6.4"
# Stage 0: "Builder" stage
# When creating the images for other architectures
#  commands (like mkdir, tar, mv...) won't be usable, so do the work here
#  in the host's platform, and just copy files over
FROM alpine
ARG ARCHITECTURE=i386
ARG RELEASE
ARG URL=https://download-cdn.resilio.com/$RELEASE/linux-$ARCHITECTURE/resilio-sync_$ARCHITECTURE.tar.gz
ADD $URL /tmp/sync.tgz
# sync.tgz only contains two files:
# rslsync and LICENSE.TXT
RUN tar -xf /tmp/sync.tgz -C /tmp

# Stage 1: The actual image
FROM ${DOCKER_PREFIX}/debian:stretch-slim
ARG RELEASE
# NOTE MAINTAINER is deprecated <https://docs.docker.com/engine/reference/builder/#maintainer-deprecated>
#MAINTAINER Toni Corvera <outlyer@gmail.com>
LABEL maintainer="Toni Corvera <outlyer@gmail.com>"
#LABEL com.resilio.version="$RELEASE"
LABEL net.outlyer.resilio.version="$RELEASE"

COPY --from=0 /tmp/rslsync /usr/bin/
COPY --from=0 /tmp/LICENSE.TXT /Resilio_Sync-LICENSE.txt

COPY sync.conf.default /etc/
COPY run_sync /usr/bin/

# webui port
EXPOSE 8888/tcp

# listening port
EXPOSE 55555/tcp

# listening port
EXPOSE 55555/udp

VOLUME /mnt/sync

ENTRYPOINT ["run_sync"]
CMD ["--config", "/mnt/sync/sync.conf"]
