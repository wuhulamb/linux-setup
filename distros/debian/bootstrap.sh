#!/usr/bin/env bash
# Debian 基础系统安装（第一阶段，发行版专属）
# 思路：用 grub-mkrescue 做一个含 netboot 内核的小 ISO，preseed 全自动安装到目标盘，
#       安装器在 guest 内完成 GPT/ESP/ext4/GRUB(UEFI)。
# 产物：work/inst.iso（由 tools/make-iso.sh 构建）；QEMU 启动见 qemu/run-installer.sh。
set -euo pipefail
ROOT="$(cd "$(dirname "$0")/../.." && pwd)"
say(){ printf '### %s\n' "$*"; }
say "1) 下载 netboot 内核与 initrd"
mkdir -p "$ROOT/work"; cd "$ROOT/work"
[ -f netboot.tar.gz ] || wget -O netboot.tar.gz \
  http://deb.debian.org/debian/dists/stable/main/installer-amd64/current/images/netboot/netboot.tar.gz
[ -d debian-installer ] || tar xzf netboot.tar.gz
say "2) 由 tools/make-iso.sh 构建 inst.iso（内含 preseed）"
"$ROOT/tools/make-iso.sh"
say "3) 用 qemu/run-installer.sh 安装到 \$TARGET，安装完自动关机"
