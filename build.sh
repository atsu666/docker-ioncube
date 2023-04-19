#!/bin/bash
# docker buildx create --name mybuilder
docker buildx use mybuilder
docker buildx ls
docker buildx build --platform linux/amd64,linux/arm64 -t atsu666/ioncube:7.2 --push .