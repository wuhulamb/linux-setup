#!/usr/bin/env bash
# 用 OVMF 从目标盘启动（用于验证），串口开 unix socket 供 guest-exec.sh 驱动
# 用法: TARGET=/dev/sdc ./run-guest.sh
set -euo pipefail
TARGET="${TARGET:?set TARGET=/dev/sdX}"
ROOT="$(cd "$(dirname "$0")/.." && pwd)"
ART="$ROOT/artifacts"; mkdir -p "$ART"
SOCK="${GUEST_SOCK:-$ART/guest.sock}"
MON="${MON_SOCK:-$ART/mon.sock}"
: "${OVMF_CODE:=/usr/share/OVMF/OVMF_CODE_4M.fd}"
: "${OVMF_VARS:=/usr/share/OVMF/OVMF_VARS_4M.fd}"
: "${VNC:=1}"                # 需要截图时用 -vnc 127.0.0.1:$VNC
cp -f "$OVMF_VARS" "$ART/OVMF_VARS.fd"
rm -f "$SOCK" "$MON"
exec qemu-system-x86_64 \
  -machine q35 -accel kvm -cpu host -m 4096 -smp 4 \
  -drive if=pflash,format=raw,readonly=on,file="$OVMF_CODE" \
  -drive if=pflash,format=raw,file="$ART/OVMF_VARS.fd" \
  -drive if=virtio,format=raw,file="$TARGET",cache=writeback \
  -netdev user,id=n0 -device virtio-net-pci,netdev=n0 \
  -vga std -vnc 127.0.0.1:${VNC} \
  -display none -serial unix:"$SOCK",server,nowait -monitor unix:"$MON",server,nowait
