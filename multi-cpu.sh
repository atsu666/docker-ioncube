#!/bin/bash

# docker build -t atsu666/ioncube:7.4-arm64 . # 各アーキテクチャで実行すること

docker manifest create atsu666/ioncube:7.4 \
    atsu666/ioncube:7.4-amd64 \
    atsu666/ioncube:7.4-arm64

docker manifest push atsu666/ioncube:7.4