FROM alpine:3.2
MAINTAINER Will Jordan <will.jordan@gmail.com>

RUN apk --update add bash
WORKDIR /root

ENV MOZJPEG_VERSION_MAJOR 3
ENV MOZJPEG_VERSION_MINOR 1
ADD mozjpeg.sh /root/
RUN ./mozjpeg.sh

ENV LIBVIPS_VERSION_MAJOR 8
ENV LIBVIPS_VERSION_MINOR 0
ENV LIBVIPS_VERSION_PATCH 2
ADD vips.sh /root/
RUN ./vips.sh

ENV CPATH /usr/local/include
ENV LIBRARY_PATH /usr/local/lib
