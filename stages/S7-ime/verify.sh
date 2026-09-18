#!/bin/sh
# S7 verify（在 guest 内运行）
set -eu
. "$(cd "$(dirname "$0")/../.." && pwd)/lib/log.sh"
: "${TARGET_USER:?set TARGET_USER}"
H="$(getent passwd "$TARGET_USER" | cut -d: -f6)"
echo "--- profile ---"; cat "$H/.config/fcitx5/profile"
echo "--- config ---"; cat "$H/.config/fcitx5/config"
echo "--- rime build ---"; ls "$H/.local/share/fcitx5/rime/build" 2>/dev/null | head
grep -A3 'name: ascii_mode' "$H/.local/share/fcitx5/rime/build/luna_pinyin.schema.yaml" 2>/dev/null | head -4
