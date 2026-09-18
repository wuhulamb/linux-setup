#!/usr/bin/env bash
# 用 grub-mkrescue 构建 Debian 自动安装 ISO（内核/initrd + preseed）
# 依赖: xorriso grub-mkrescue mtools
set -euo pipefail
ROOT="$(cd "$(dirname "$0")/.." && pwd)"; cd "$ROOT/work"
[ -d debian-installer ] || tar xzf netboot.tar.gz
rm -rf isodir; mkdir -p isodir/boot/grub
cp debian-installer/amd64/linux     isodir/boot/linux
cp debian-installer/amd64/initrd.gz isodir/boot/initrd.gz
cat > isodir/boot/grub/grub.cfg <<'G'
set timeout=3
set default=0
serial --unit=0 --speed=115200
terminal_input console serial
terminal_output console serial
menuentry "Auto install (serial)" {
    linux /boot/linux auto=true priority=critical \
        preseed/url=http://10.0.2.2:8000/preseed.cfg \
        console=ttyS0,115200n8 DEBIAN_FRONTEND=text
    initrd /boot/initrd.gz
}
G
cp "$ROOT/distros/debian/preseed.cfg" "$ROOT/work/preseed.cfg"
grub-mkrescue -o "$ROOT/work/inst.iso" isodir
echo "built $ROOT/work/inst.iso"
echo "提示：先在 work/ 里对 preseed.cfg 起 HTTP 服务（python3 -m http.server 8000）"
