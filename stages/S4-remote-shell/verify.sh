#!/bin/sh
# S4 verify（在 guest 内运行）
set -eu
. "$(cd "$(dirname "$0")/../.." && pwd)/lib/log.sh"
systemctl is-active ssh 2>/dev/null || systemctl is-active sshd 2>/dev/null || true
: "${TARGET_USER:?set TARGET_USER}"
H="$(getent passwd "$TARGET_USER" | cut -d: -f6)"
ls -l "$H/.vimrc" "$H/.gitconfig" 2>/dev/null || true
su - "$TARGET_USER" -c 'git config --list' 2>/dev/null || true
