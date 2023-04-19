#!/bin/bash

# docker build -t atsu666/ioncube:7.0-arm64 . # 各アーキテクチャで実行すること
# docker push atsu666/ioncube:7.0-arm64

docker manifest create atsu666/ioncube:7.0 \
    atsu666/ioncube:7.0-amd64 \
    atsu666/ioncube:7.0-arm64

docker manifest push atsu666/ioncube:7.0