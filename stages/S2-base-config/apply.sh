#!/bin/sh
# S2 apply：创建用户 + 管理员组（发行版无关）
set -eu
ROOT="$(cd "$(dirname "$0")/../.." && pwd)"
. "$ROOT/lib/log.sh"
: "${NEW_USER:?set NEW_USER}"
: "${NEW_PASS:?set NEW_PASS (runtime only)}"

if ! id "$NEW_USER" >/dev/null 2>&1; then
    useradd -m -s /bin/bash "$NEW_USER"
fi
printf '%s:%s\n' "$NEW_USER" "$NEW_PASS" | chpasswd
usermod -aG sudo  "$NEW_USER" 2>/dev/null || true
usermod -aG wheel "$NEW_USER" 2>/dev/null || true   # Arch
log "user $NEW_USER ready"
