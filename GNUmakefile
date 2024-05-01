#
# Configurable variables, override by passing them to the make command, e.g. make REGISTRY=ghcr.io
#
REGISTRY:=docker.io
IMAGE_NAME:=outlyernet/resiliosync-multiarch
# Pass EXTRA_TAGS= to disable the default of adding :latest
EXTRA_TAGS:=latest
# Official and semi-official architectures: https://github.com/docker-library/official-images#architectures-other-than-amd64
PLATFORMS:=linux/amd64,linux/i386,linux/arm/v7,linux/arm64,linux/arm/v5
# load or push
ACTION:=load

#
# Computed variables
#
FQDN_IMAGE=$(REGISTRY)/$(IMAGE_NAME)
ACTION_PARAM=$(addprefix --,$(ACTION))
# tag1 tag2 ...
ALL_TAGS=$(RELEASE) $(EXTRA_TAGS)
# registry/image:tag1 registry/image:tag2 ...
ALL_TAGS_FQDN=$(foreach tag,$(ALL_TAGS),$(FQDN_IMAGE):$(tag))
# -t registry/image -t registry/image ...
ALL_TAGS_PARAM=$(foreach full_tag,$(ALL_TAGS_FQDN),-t $(full_tag))

all: multiarch-builder build

build:
	@# Debug with --progress plain, it displays printed outputs from layers
	echo docker buildx build . \
		$(ACTION_PARAM) \
		-f Dockerfile \
		--platform $(PLATFORMS) \
		$(ALL_TAGS_PARAM)

# A new builder is required to build multiarch images
multiarch-builder:
	-docker buildx create --name multiarch --use

# Prints the list of tags to be used by build/push , useful to debug
print-tags:
	@echo Tags: $(addprefix "\n - ",$(ALL_TAGS))
	@echo Tags with image name: $(addprefix "\n - ",$(ALL_TAGS_FQDN))

.PHONY: all build multiarch-builder print-tags
