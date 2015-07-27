#!/bin/bash

# Installs Vips

# Install dependencies
apk --update add --virtual build-dependencies \
  gcc g++ make libc-dev \
  curl \
  automake \
  libtool \
  tar \
  gettext

apk --update add --virtual dev-dependencies \
  glib-dev \
  libpng-dev \
  libwebp-dev \
  libexif-dev \
  libxml2-dev \
  orc-dev

apk --update add --virtual run-dependencies \
  glib \
  libpng \
  libwebp \
  libexif \
  libxml2 \
  orc

# Building from git
apk --update add --virtual git-build-deps \
  git \
  gobject-introspection-dev \
  swig \
  gtk-doc \
  autoconf

# Install mozjpeg from source
./mozjpeg.sh

# Install fftw from source
./fftw.sh

# Optional dependencies (unused)
#  tiff-dev \
#  libgsf-dev
#  pango-dev \
#  imagemagick-dev \

# Build libvips
cd /tmp
git clone git://github.com/jcupitt/libvips.git
cd libvips
./bootstrap.sh
FLAGS="-Ofast" && \
  CFLAGS="$FLAGS" CXXFLAGS="$FLAGS" && \
  ./configure --enable-debug=no --without-python --without-gsf \
#  --enable-deprecated=no \
  $1 && \
  make -j && \
  make install

ldconfig || true

## Clean up
cd /
apk del git-build-deps
apk del build-dependencies
apk del dev-dependencies
rm -rf \
  /var/cache/apk/* \
  /tmp/* \
  /var/tmp/* \
  /usr/local/share/gtk-doc/html/libvips/ \
  || true

# Clean up vips static libs
rm -rf \
  /usr/local/lib/libvips-cpp.a \
  /usr/local/lib/libvips.a \
  /usr/local/lib/libvipsCC* \
  || true

# Clean up mozjpeg static libs
rm -rf \
  /usr/lib/libjpeg.a \
  /usr/lib/libturbojpeg.a \
  || true

# Clean up fftw static libs
rm -rf \
  /usr/lib/libfftw3.a \
  /usr/lib/libfftw3_threads.a \
  || true
