#!/bin/bash

# Installs mozjpeg library to /opt/mozjpeg
# Set version to install via ENV:
# $MOZJPEG_VERSION_MAJOR
# $MOZJPEG_VERSION_MINOR
set -e

cd /tmp
apk --update add --virtual build-dependencies \
  gcc g++ make libc-dev \
  curl \
  automake \
  autoconf \
  nasm \
  pkgconf \
  libtool \
  tar

apk --update add --virtual dev-dependencies \
  libpng-dev

apk --update add \
  libpng

MOZJPEG_FILE=v$MOZJPEG_VERSION_MAJOR.$MOZJPEG_VERSION_MINOR.tar.gz
curl -L -O https://github.com/mozilla/mozjpeg/archive/$MOZJPEG_FILE
tar -xf $MOZJPEG_FILE
cd mozjpeg-$MOZJPEG_VERSION_MAJOR.$MOZJPEG_VERSION_MINOR
autoreconf -fiv
mkdir build
cd build
../configure && make && make -i install

# Clean up
cd /
apk del build-dependencies
apk del dev-dependencies
rm -rf /var/cache/apk/* /tmp/* /var/tmp/*
