FROM alpine:edge
MAINTAINER Will Jordan <will.jordan@gmail.com>

# Minimal bash layer
RUN \
  apk --update add bash && \
  rm -rf /var/cache/apk/* && \
  rm -rf /usr/share/terminfo/*

WORKDIR /root

ADD vips.sh mozjpeg.sh fftw.sh /root/
RUN ./vips.sh && rm vips.sh mozjpeg.sh fftw.sh

ENV CPATH /usr/local/include
ENV LIBRARY_PATH /usr/local/lib
