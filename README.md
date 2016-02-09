# [Dockerfile](https://registry.hub.docker.com/u/wjordan/libvips/) for libvips
[![](https://badge.imagelayers.io/wjordan/libvips:latest.svg)](https://imagelayers.io/?images=wjordan/libvips:latest 'wjordan/libvips:latest')

Installs libvips on Alpine Linux as base image.

## How to use

Download the image from Docker Hub:

```bash
$ docker pull wjordan/libvips
# .... pulling down image
```

## How to build

Just run `./libvips.docker.sh`.

Uses [dockerize](https://github.com/docker/docker/issues/14080#issuecomment-132841442) script instead of `docker build` to create the Docker image.

## License

Licensed under [MIT](http://opensource.org/licenses/mit-license.html)
