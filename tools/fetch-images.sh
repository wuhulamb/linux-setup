#!/usr/bin/env bash
# 下载 Debian / Arch 安装介质到 work/
set -euo pipefail
ROOT="$(cd "$(dirname "$0")/.." && pwd)"; mkdir -p "$ROOT/work"; cd "$ROOT/work"
case "${1:-all}" in
  debian)
    wget -c http://deb.debian.org/debian/dists/stable/main/installer-amd64/current/images/netboot/netboot.tar.gz ;;
  arch)
    wget -c https://geo.mirror.pkgbuild.com/iso/latest/ -O arch-dir.html
    echo "从 arch-dir.html 里取最新 archlinux-x86_64.iso 链接后 wget" ;;
  all) "$0" debian; "$0" arch ;;
  *) echo "usage: $0 {debian|arch|all}"; exit 1 ;;
esac
