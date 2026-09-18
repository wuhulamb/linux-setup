#!/usr/bin/env bash
# 通过 QEMU monitor 截图（图形阶段取证）
# 用法: ./screenshot.sh artifacts/greeter
set -euo pipefail
ROOT="$(cd "$(dirname "$0")/.." && pwd)"
MON="${MON_SOCK:-$ROOT/artifacts/mon.sock}"
OUT="${1:-$ROOT/artifacts/screen}"
printf 'screendump %s.ppm\n' "$OUT" | socat - UNIX-CONNECT:"$MON" >/dev/null
echo "saved $OUT.ppm"
