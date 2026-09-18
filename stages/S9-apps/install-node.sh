#!/bin/sh
# 安装 Node.js 官方二进制（默认 v24 LTS）到 /usr/local
set -eu
V="${NODE_VERSION:-v24.21.0}"
A="$(uname -m)"; case "$A" in x86_64) A=x64;; aarch64) A=arm64;; esac
D="node-${V}-linux-${A}"
cd /tmp
wget -q -O node.tar.xz "https://nodejs.org/dist/${V}/${D}.tar.xz"
tar -xJf node.tar.xz -C /usr/local --strip-components=1
rm -f node.tar.xz
/usr/local/bin/node -v; /usr/local/bin/npm -v
