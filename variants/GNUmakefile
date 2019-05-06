
FLAVOURS:=Dockerfile.ubuntu Dockerfile.autobuild-debian Dockerfile.autobuild-ubuntu

all: $(FLAVOURS)

Dockerfile.ubuntu: ../Dockerfile
	sed 's/debian:stretch-slim/ubuntu/' $< > $@

Dockerfile.autobuild-debian: ../Dockerfile
	sed 's/#COPY qemu/COPY qemu/' $< > $@

Dockerfile.autobuild-ubuntu: Dockerfile.autobuild-debian
	sed 's/debian:stretch-slim/ubuntu/' $< > $@

distclean:
	$(RM) $(FLAVOURS)

.PHONY: all distclean