#!/bin/sh
# S4 可选子项 verify：dotfiles 已部署（在 guest 内运行）
set -eu
. "$(cd "$(dirname "$0")/../.." && pwd)/lib/log.sh"
: "${TARGET_USER:?set TARGET_USER}"
H="$(getent passwd "$TARGET_USER" | cut -d: -f6)"
ls -l "$H/.vimrc" "$H/.gitconfig" 2>/dev/null || true
su - "$TARGET_USER" -c 'git config --list' 2>/dev/null || true