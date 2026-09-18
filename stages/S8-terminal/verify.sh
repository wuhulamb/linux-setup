#!/bin/sh
# S8 verify（在 guest 内运行）
set -eu
. "$(cd "$(dirname "$0")/../.." && pwd)/lib/log.sh"
command -v kitty && kitty --version 2>&1 | head -1 || true
readlink -f /usr/bin/x-terminal-emulator 2>/dev/null || true
: "${TARGET_USER:?set TARGET_USER}"
H="$(getent passwd "$TARGET_USER" | cut -d: -f6)"
cat "$H/.config/kitty/kitty.conf" 2>/dev/null || true
readlink "$H/.config/kitty/theme.conf" 2>/dev/null || true
