#!/bin/bash

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
  fftw-dev \

apk --update add --virtual run-dependencies \
  glib \
  libpng \
  libwebp \
  libexif \
  libxml2 \
  fftw \
  fftw-libs \
  orc-dev \

# Building from git dependencies
#  gobject-introspection \
#  swig \
#  gtk-doc \

# Optional dependencies (unused)
#  tiff-dev \
#  libgsf-dev
#  pango-dev \
#  imagemagick-dev \


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
apk del dev-dependencies
rm -rf /var/cache/apk/* /tmp/* /var/tmp/*
