#!/bin/bash

# Installs mozjpeg library to /opt/mozjpeg
# Set version to install via ENV:
# $MOZJPEG_VERSION_MAJOR
# $MOZJPEG_VERSION_MINOR
set -e
apt-get update

cd /tmp
DEBIAN_FRONTEND=noninteractive apt-get install -y \
  curl \
  autoconf \
  make \
  nasm \
  pkg-config \
  libtool \
  libpng12-dev \

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
apt-get remove -y \
  curl \
  autoconf \
  make \
  nasm \
  pkg-config \
  libtool && \
  apt-get autoremove -y && \
  apt-get autoclean && \
  apt-get clean && \
  rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*
