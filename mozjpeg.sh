#!/bin/sh

set -e

# Install mozjpeg to /usr
MOZJPEG_VERSION_MAJOR=3
MOZJPEG_VERSION_MINOR=1
MOZJPEG_VERSION=${MOZJPEG_VERSION_MAJOR}.${MOZJPEG_VERSION_MINOR}
MOZJPEG_DIR=/tmp/mozjpeg

apk --update add --virtual mozjpeg-build-deps \
  gcc g++ make libc-dev \
  curl \
  nasm \
  pkgconf \
  libtool \
  tar

apk --update add --virtual mozjpeg-dev-deps \
  libpng-dev

apk --update add --virtual mozjpeg-run-deps \
  libpng

cd /tmp
curl -L https://github.com/mozilla/mozjpeg/releases/download/v${MOZJPEG_VERSION}/mozjpeg-${MOZJPEG_VERSION}-release-source.tar.gz | tar -xz
cd mozjpeg
mkdir -p /usr/lib/bfd-plugins
ln -sfv /usr/libexec/gcc/$(gcc -dumpmachine)/5.1.0/liblto_plugin.so /usr/lib/bfd-plugins/
FLAGS="-Os -flto" && CFLAGS="${FLAGS}" CXXFLAGS="${FLAGS}" LDFLAGS="${FLAGS}" \
  ./configure \
  --disable-static \
  --prefix=/usr \
  --mandir=${MOZJPEG_DIR}/man \
  --infodir=${MOZJPEG_DIR}/info \
  --docdir=${MOZJPEG_DIR}/doc

make -j
make install
ldconfig || true

# Clean up
cd /
apk del mozjpeg-build-deps mozjpeg-dev-deps
rm -rf /var/cache/apk/*
rm -rf /etc/ssl/certs/*
rm -rf ${MOZJPEG_DIR}
