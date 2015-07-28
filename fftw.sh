#!/bin/sh

set -e

# Install fftw library to /usr
FFTW_VERSION_MAJOR=3
FFTW_VERSION_MINOR=3
FFTW_VERSION_MICRO=4

FFTW_FILE=fftw-${FFTW_VERSION_MAJOR}.${FFTW_VERSION_MINOR}.${FFTW_VERSION_MICRO}
FFTW_DIR=/tmp/${FFTW_FILE}

cd /tmp
curl http://www.fftw.org/${FFTW_DIR}.tar.gz | tar zx
cd ${FFTW_DIR}
mkdir -p /usr/lib/bfd-plugins
ln -sfv /usr/libexec/gcc/$(gcc -dumpmachine)/5.1.0/liblto_plugin.so /usr/lib/bfd-plugins/
FLAGS="-Os -flto" && CFLAGS="${FLAGS}" CXXFLAGS="${FLAGS}" LDFLAGS="${FLAGS}" \
  ./configure \
    --enable-shared \
    --enable-threads \
    --disable-static \
    --prefix=/usr \
    --mandir=${FFTW_DIR}/man \
    --infodir=${FFTW_DIR}/info \
    --docdir=${FFTW_DIR}/doc

make -j
make install
ldconfig || true

# Clean up
cd /tmp
rm -rf ${FFTW_DIR}
