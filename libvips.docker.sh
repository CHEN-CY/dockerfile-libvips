#!./dockerize.sh
FROM=alpine:edge
TAG=${TAG:-wjordan/libvips}
WORKDIR=/var/cache/dockerize
CACHE=/var/cache/docker
VOLUME="${HOME}/.docker-cache:${CACHE} ${PWD}:${WORKDIR}:ro /tmp"
CPATH=/usr/include/glib-2.0

#!/bin/sh
# Cache apk for faster rebuilds
ln -s ${CACHE}/apk /var/cache/apk
ln -s ${CACHE}/apk /etc/apk/cache

set -e

cd ${WORKDIR}
# Install mozjpeg from source
./mozjpeg.sh
# Install vips from source
./vips.sh

# Cleanup
rm -rf \
  /etc/ssl/certs/* \
  /var/tmp/* \
  || true
