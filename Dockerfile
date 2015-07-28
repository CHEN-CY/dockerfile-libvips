FROM alpine:edge
MAINTAINER Will Jordan <will.jordan@gmail.com>

WORKDIR /root

ADD vips.sh mozjpeg.sh fftw.sh /root/
RUN ./vips.sh && rm vips.sh mozjpeg.sh fftw.sh

ENV CPATH /usr/include/glib-2.0
