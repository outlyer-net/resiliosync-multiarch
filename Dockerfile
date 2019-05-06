# Resilio Sync
#
# VERSION               0.1
#

FROM arm32v7/debian:stretch-slim
ARG RELEASE="2.6.3"
# NOTE MAINTAINER is deprecated <https://docs.docker.com/engine/reference/builder/#maintainer-deprecated>
#MAINTAINER Toni Corvera <outlyer@gmail.com>
LABEL maintainer="Toni Corvera <outlyer@gmail.com>"
#LABEL com.resilio.version="$RELEASE"
LABEL net.outlyer.resilio.version="$RELEASE"

COPY qemu-arm-static /usr/bin
ADD https://download-cdn.resilio.com/$RELEASE/linux-armhf/resilio-sync_armhf.tar.gz /tmp/sync.tgz
RUN tar -xf /tmp/sync.tgz -C /usr/bin rslsync && rm -f /tmp/sync.tgz

COPY sync.conf.default /etc/
COPY run_sync /usr/bin/

EXPOSE 8888
EXPOSE 55555

VOLUME /mnt/sync

ENTRYPOINT ["run_sync"]
CMD ["--config", "/mnt/sync/sync.conf"]
