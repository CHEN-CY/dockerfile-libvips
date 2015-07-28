#!/bin/sh

# Install mozjpeg from source
./mozjpeg.sh

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
LIBVIPS_DIR=/tmp/libvips
mkdir -p /usr/lib/bfd-plugins
ln -sfv /usr/libexec/gcc/$(gcc -dumpmachine)/5.1.0/liblto_plugin.so /usr/lib/bfd-plugins/
FLAGS="-Os -flto" && CFLAGS="${FLAGS}" CXXFLAGS="${FLAGS}" LDFLAGS="${FLAGS}" \
  ./configure \
  --enable-debug=no \
  --without-python \
  --without-gsf \
  --disable-static \
  --prefix=/usr \
  --mandir=${LIBVIPS_DIR}/man \
  --infodir=${LIBVIPS_DIR}/info \
  --docdir=${LIBVIPS_DIR}/doc

make -j
make install

ldconfig || true

## Clean up
cd /
apk del git-build-deps
apk del build-dependencies
apk del dev-dependencies
rm -rf \
  /var/cache/apk/* \
  /etc/ssl/certs/* \
  /tmp/* \
  /var/tmp/* \
  /usr/local/share/gtk-doc/html/libvips/ \
  || true

# Clean up vips static libs
rm -rf \
  /usr/lib/libvipsCC* \
  || true
