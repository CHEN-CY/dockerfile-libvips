FROM alpine:edge
ADD will.jordan@gmail.com-56bf67f5.rsa.pub /etc/apk/keys/
RUN apk add --update \
  --repository https://s3.amazonaws.com/wjordan-apk \
  libvips \
  && rm -rf /var/cache/apk/*
