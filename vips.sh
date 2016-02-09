#!/bin/sh
set -e

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
  orc-dev \
  fftw-dev

apk --update add --virtual run-dependencies \
  glib \
  libpng \
  libwebp \
  libexif \
  libxml2 \
  orc \
  fftw

# Building from git
apk --update add --virtual git-build-deps \
  git \
  gobject-introspection-dev \
  swig \
  gtk-doc \
  autoconf

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
LIBVIPS_DIR=/tmp/libvips
mkdir -p /usr/lib/bfd-plugins
ln -sfv /usr/libexec/gcc/$(gcc -dumpmachine)/5.1.0/liblto_plugin.so /usr/lib/bfd-plugins/
FLAGS="-Os -flto -march=native" && \
  ./configure \
  --enable-debug=no \
  --without-python \
  --without-gsf \
  --disable-static \
  --prefix=/usr \
  --mandir=${LIBVIPS_DIR}/man \
  --infodir=${LIBVIPS_DIR}/info \
  --docdir=${LIBVIPS_DIR}/doc \
  CFLAGS="${FLAGS}" CXXFLAGS="${FLAGS}" LDFLAGS="${FLAGS}"

make -j V=1
make install-strip

ldconfig || true

## Clean up
cd /
apk del git-build-deps
apk del build-dependencies
apk del dev-dependencies
rm -rf \
  /usr/local/share/gtk-doc/html/libvips/ \
  || true

# Clean up vips static libs
rm -rf \
  /usr/lib/libvipsCC* \
  || true
