# Official and semi-official architectures: https://github.com/docker-library/official-images#architectures-other-than-amd64
ARCHITECTURES:=amd64 armhf i386 armle arm64
IMAGE_NAME=outlyernet/resiliosync-docker-multiarch

DOCKERFILE_IN=Dockerfile.in
DOCKERFILES=$(addsuffix .Dockerfile,$(ARCHITECTURES))
# The colon confuses make, leave it for later
IMAGES=$(addprefix $(IMAGE_NAME).latest-,$(ARCHITECTURES))

# Download URLs take the form:
# https://download-cdn.resilio.com/$RELEASE/linux-$ARCH/resilio-sync_$ARCH.tar.gz
# e.g.
# https://download-cdn.resilio.com/2.6.3/linux-armhf/resilio-sync_armhf.tar.gz
# The architecture names as per Resilio are i386, x64, arm and armhf. There is no ARMv8 tarball
# BUT there is a DEB to be found at https://help.resilio.com/hc/en-us/articles/206178924
# AND it can be found at https://download-cdn.resilio.com/*/linux-arm64/resilio-sync_arm64.tar.gz
# despite not being linked at the download page

# Translate the architecture names (resolution delayed to the actual rules)
# Docker Hub prefix:
# amd64 => amd64
# armhf => arm32v7
# arm64 => arm64v8
# armle => arm32v5 [unofficial]
# i386 => i386 [unofficial]
# XXX: Is there no arm32v6 debian image?
#DOCKER_PREFIX=$(shell echo $* | sed -e 's/armhf/arm32v7/' -e 's/armle/arm32v5/')
DOCKER_PREFIX=$(subst armhf,arm32v7,$(subst armle,arm32v5,$(subst arm64,arm64v8,$*)))
# Resilio's architecture name:
# amd64 => x64
# armhf => armhf
# armle => arm
# i386 => i386
# arm64 => arm64
#RESILIO_ARCH=$(shell echo $* | sed -e 's/armle/arm/' -e 's/amd64/x64/')
RESILIO_ARCH=$(subst armle,arm,$(subst amd64,x64,$*))

all: $(DOCKERFILES) $(IMAGES)

%.Dockerfile: $(DOCKERFILE_IN)
	sed -e 's#DOCKER_PREFIX=.*$$#DOCKER_PREFIX=$(DOCKER_PREFIX)#' \
		-e 's!ARCHITECTURE=.*$$!ARCHITECTURE=$(RESILIO_ARCH)!' $< > $@

$(IMAGE_NAME).latest-%: %.Dockerfile
	docker build -t $(subst .,:,$@) -f $< ..

manifest:
	@echo docker manifest create $(IMAGE_NAME):latest \
		$(IMAGES)

Dockerfile.ubuntu: ../Dockerfile
	sed 's/debian:stretch-slim/ubuntu/' $< > $@

Dockerfile.autobuild-debian: ../Dockerfile
	sed 's/#COPY qemu/COPY qemu/' $< > $@

Dockerfile.autobuild-ubuntu: Dockerfile.autobuild-debian
	sed 's/debian:stretch-slim/ubuntu/' $< > $@

distclean:
	$(RM) $(DOCKERFILES)

.PHONY: all distclean