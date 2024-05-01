#!/bin/sh

set -e

# This script is meant to run in the base stage of a multi-stage Docker build
# to download the right platform binary.
#
# Download URLs take the form:
# https://download-cdn.resilio.com/$RELEASE/linux-$ARCH/resilio-sync_$ARCH.tar.gz
# e.g.
# https://download-cdn.resilio.com/2.6.3/linux-armhf/resilio-sync_armhf.tar.gz
# The architecture names as per Resilio are i386, x64, arm and armhf. There is no ARMv8 tarball
# BUT there is a DEB to be found at https://help.resilio.com/hc/en-us/articles/206178924
# AND it can be found at https://download-cdn.resilio.com/*/linux-arm64/resilio-sync_arm64.tar.gz
# despite not being linked at the download page

if test -z "$2" ; then
    echo "Usage: $0 <RESILIO_SYNC_VERSION> <OUTPUT_TARBALL>" >&2
    exit 1
fi

RELEASE="$1"
OUTPUT="$2"

ARCHITECTURE=`uname -r`
# Figure out with:
# AMD64:
# docker run --platform linux/amd64 --rm alpine linux64 uname -m # x86_64
# docker run --platform linux/i386 --rm alpine linux32 uname -m  # i686
# ARM64:
# docker run --platform linux/arm64 --rm alpine linux64 uname -m # aarch64
# docker run --platform linux/arm64 --rm alpine linux32 uname -m # armv8l
# docker run --platform linux/arm/v7 --rm alpine linux32 uname -m # armv7l
#
# Docker Hub doesn't appear to differentiate between armle and armhf
#
# Resilio's download url architectures: x64, i386, arm, armhf
# Resilio's ARM architecture names:
#  - arm or armhf
# Alpine's Docker image's ARM architecture names:
#  - arm/v6, arm/v7, arm64/v8
#
# armhf is a Debian-specific way of referring to arm v7 with "hard float",
#  armel without them, I assume
#  - Resilio's arm <=> Docker's arm/v6 <=> Debian's armel
#  - Resilio's armhf <=> Docker's arm/v7
# FIXME: I'm not sure about the arm variant to use for each case, it doesn't
#        appear to be a straightforward/failproof way of telling them apart
# XXX: Debian ARM images for bookworm appear to use armel in all cases when
#      using the bookworm-slim tag but not with the stable-slim tag despite it
#      being the stable version (?) 
#
# dpkg-architecture (from dpkg-dev) can be used to explore values
# dpkg-architecture -> print current
# dpkg-architecture -a $SOME_ARCH -> print values for architecture $SOME_ARCH
# e.g.:
# dpkg-architecture -a <ARCH> | grep DEB_HOST_ARCH=   # <OS_ARCH>
# with <ARCH> one of amd64, arm64, armel, i386
# <OS_ARCH> is armhf for the linux/arm64/v8 images and armel for the linux/arm/v7 images

which dpkg-architecture

OS_ARCH=`dpkg-architecture 2>/dev/null | grep DEB_HOST_ARCH= | cut -f2 -d=`

case "$OS_ARCH" in
    amd64) ARCHITECTURE='x64' ;;
    i386) ARCHITECTURE='i386' ;;
    arm64) ARCHITECTURE='arm64' ;;
    armhf) ARCHITECTURE='armhf' ;;
    # In practice I'm disabling the arm version since both v7l and v8 use armhf
    arm|armel|arm*) ARCHITECTURE='arm' ;;
    # TODO: 
    *)
        echo "Error, architecture: $OS_ARCH" >&2
        exit 1
        ;;
esac

# See https://www.resilio.com/platforms/desktop/
URL="https://download-cdn.resilio.com/$RELEASE/linux-$ARCHITECTURE/resilio-sync_$ARCHITECTURE.tar.gz"

echo "Downloading [$URL]" >&2
wget -O "$OUTPUT" "$URL"

test -f "$OUTPUT"
