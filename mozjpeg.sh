#!/bin/bash

set -e

# Install mozjpeg library to /usr
MOZJPEG_VERSION_MAJOR=3
MOZJPEG_VERSION_MINOR=1

cd /tmp
apk --update add --virtual mozjpeg-build-deps \
  gcc g++ make libc-dev \
  curl \
  automake \
  autoconf \
  nasm \
  pkgconf \
  libtool \
  tar

apk --update add --virtual mozjpeg-dev-deps \
  libpng-dev

apk --update add \
  libpng

MOZJPEG_VERSION=${MOZJPEG_VERSION_MAJOR}.${MOZJPEG_VERSION_MINOR}
MOZJPEG_FILE=v${MOZJPEG_VERSION}.tar.gz
MOZJPEG_DIR=mozjpeg-${MOZJPEG_VERSION}
curl -L -O https://github.com/mozilla/mozjpeg/archive/${MOZJPEG_FILE}
tar -xf ${MOZJPEG_FILE}
cd ${MOZJPEG_DIR}
autoreconf -fiv
mkdir build
cd build
FLAGS="-Ofast -flto" && \
  CFLAGS=${FLAGS} CXXFLAGS=${FLAGS} && \
  ../configure && \
  make -j && \
  make -i install prefix=/usr libdir=/usr/lib

# Clean up
cd /tmp
apk del mozjpeg-build-deps
apk del mozjpeg-dev-deps
rm -rf /tmp/${MOZJPEG_DIR}
