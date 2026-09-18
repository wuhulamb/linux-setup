#!/bin/sh
# S8 apply：kitty 配置 + 设为默认终端
set -eu
ROOT="$(cd "$(dirname "$0")/../.." && pwd)"
. "$ROOT/lib/log.sh"; . "$ROOT/lib/deploy.sh"
: "${TARGET_USER:?set TARGET_USER}"
H="$(getent passwd "$TARGET_USER" | cut -d: -f6)"

# 部署 kitty 配置（含软链）
install -d -o "$TARGET_USER" -g "$TARGET_USER" "$H/.config/kitty"
cp -a "$ROOT/configs/kitty/." "$H/.config/kitty/"
chown -R "$TARGET_USER" "$H/.config/kitty" 2>/dev/null || true

# 设为默认终端（Debian）；移除默认终端（谨慎，先确保 kitty 已装）
if command -v kitty >/dev/null 2>&1; then
    update-alternatives --set x-terminal-emulator /usr/bin/kitty 2>/dev/null || \
    update-alternatives --install /usr/bin/x-terminal-emulator x-terminal-emulator /usr/bin/kitty 50 2>/dev/null || true
fi
# i3 的终端快捷键
[ -f "$H/.config/i3/config" ] && sed -i 's/exec xterm/exec kitty/' "$H/.config/i3/config" || true
log "kitty deployed"
