#!/usr/bin/env bash
# 从安装介质启动 QEMU（第一阶段用）
# 用法: TARGET=/dev/sdc MEDIA=work/inst.iso ./run-installer.sh
set -euo pipefail
TARGET="${TARGET:?set TARGET=/dev/sdX}"
MEDIA="${MEDIA:?set MEDIA=/path/to/installer.iso}"
ART="$(cd "$(dirname "$0")/.." && pwd)/artifacts"; mkdir -p "$ART"
: "${OVMF_CODE:=/usr/share/OVMF/OVMF_CODE_4M.fd}"
: "${OVMF_VARS:=/usr/share/OVMF/OVMF_VARS_4M.fd}"
cp -f "$OVMF_VARS" "$ART/OVMF_VARS.fd"
exec qemu-system-x86_64 \
  -machine q35 -accel kvm -cpu host -m 3072 -smp 4 \
  -drive if=pflash,format=raw,readonly=on,file="$OVMF_CODE" \
  -drive if=pflash,format=raw,file="$ART/OVMF_VARS.fd" \
  -drive if=virtio,format=raw,file="$TARGET",cache=writeback \
  -cdrom "$MEDIA" -boot order=d \
  -netdev user,id=n0 -device virtio-net-pci,netdev=n0 \
  -display none -serial file:"$ART/install.log" -monitor none
