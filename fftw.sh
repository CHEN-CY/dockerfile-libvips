#!/bin/bash

set -e

# Install fftw library to /usr
FFTW_VERSION_MAJOR=3
FFTW_VERSION_MINOR=3
FFTW_VERSION_MICRO=4

FFTW_DIR=fftw-${FFTW_VERSION_MAJOR}.${FFTW_VERSION_MINOR}.${FFTW_VERSION_MICRO}

cd /tmp
curl http://www.fftw.org/${FFTW_DIR}.tar.gz | tar zx
cd ${FFTW_DIR}
FLAGS="-ofast" && \
  CFLAGS=${FLAGS} CXXFLAGS=${FLAGS} && \
  ./configure \
    --prefix=/usr \
    --enable-shared \
    --enable-threads && \
  make -j && \
  make install
ldconfig || true

# Clean up
cd /tmp
rm -rf /tmp/${FFTW_DIR}
