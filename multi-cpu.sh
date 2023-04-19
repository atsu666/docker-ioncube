#!/bin/bash

# docker build -t atsu666/ioncube:5.6-arm64 . # 各アーキテクチャで実行すること
# docker push atsu666/ioncube:5.6-arm64

docker manifest create atsu666/ioncube:5.6 \
    atsu666/ioncube:5.6-amd64 \
    atsu666/ioncube:5.6-arm64

docker manifest push atsu666/ioncube:5.6