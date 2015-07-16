#!/bin/bash

# Install dependencies
apt-get update && DEBIAN_FRONTEND=noninteractive apt-get install -y \
  automake build-essential curl \
  gobject-introspection \
  gtk-doc-tools \
  libglib2.0-dev \
  libpng12-dev \
  libwebp-dev \
  libtiff5-dev \
  libexif-dev \
  libxml2-dev \
  swig \
  libmagickwand-dev \
  libfftw3-dev \
  liborc-0.4-dev \
  libpango1.0-dev \
  libgsf-1-dev

# Build libvips
cd /tmp
LIBVIPS_VERSION=$LIBVIPS_VERSION_MAJOR.$LIBVIPS_VERSION_MINOR.$LIBVIPS_VERSION_PATCH
curl -O http://www.vips.ecs.soton.ac.uk/supported/$LIBVIPS_VERSION_MAJOR.$LIBVIPS_VERSION_MINOR/vips-$LIBVIPS_VERSION.tar.gz && \
  tar zvxf vips-$LIBVIPS_VERSION.tar.gz && \
  cd vips-$LIBVIPS_VERSION && \
  FLAGS="-O2 -msse4.2 -ffast-math" && \
  FLAGS="$FLAGS -ftree-vectorize -fdump-tree-vect-details" && \
  CFLAGS="$FLAGS" CXXFLAGS="$FLAGS" && \
  ./configure --enable-debug=no --without-python --without-gsf \
  --with-jpeg-includes=/opt/mozjpeg/include \
  --with-jpeg-libraries=/opt/mozjpeg/lib64 \
  $1 && \
  make && \
  make install && \
  ldconfig

# Clean up
cd /
apt-get remove -y curl automake build-essential && \
  apt-get autoremove -y && \
  apt-get autoclean && \
  apt-get clean && \
  rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*
