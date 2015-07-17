#!/bin/bash

# Install dependencies
apk --update add --virtual build-dependencies \
  gcc g++ libc-dev make
  automake \
  curl \
  gobject-introspection \
  gtk-doc \
  glib-dev \
  tar

apk --update add \
  libpng-dev \
  libwebp-dev \
  tiff-dev \
  libexif-dev \
  libxml2-dev \
  swig \
  imagemagick-dev \
  fftw-dev \
  orc-dev \
  pango-dev \
  libgsf-dev

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
apk del build-dependencies
rm -rf /var/cache/apk/* /tmp/* /var/tmp/*
