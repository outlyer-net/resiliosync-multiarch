ARG RELEASE="2.8.1"
ARG BUILD="1390"
ARG BASE_IMAGE="debian:bookworm-slim"

FROM ${BASE_IMAGE} AS download_stage
ARG RELEASE
ARG BUILD

RUN apt-get update -y \
    && DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
        binutils \
        ca-certificates \
        dpkg-dev \
        wget \
    && rm -rf /var/lib/apt/lists/*

COPY image-build-helpers/downloader.sh /

RUN /downloader.sh "${RELEASE}" "${BUILD}" \
    && \
    test -x /tmp/rslsync \
    && \
    test -f /tmp/LICENSE.TXT

FROM ${BASE_IMAGE} AS final-stage

ARG RELEASE

LABEL maintainer="Toni Corvera <outlyer@gmail.com>"
LABEL net.outlyer.resilio.version="$RELEASE"

COPY --from=download_stage /tmp/rslsync /usr/bin/
COPY --from=download_stage /tmp/LICENSE.TXT /Resilio_Sync-LICENSE.txt

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
