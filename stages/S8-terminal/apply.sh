#!/bin/sh
# S8 apply：kitty 配置 + 设为默认终端（字号按设备）
set -eu
ROOT="$(cd "$(dirname "$0")/../.." && pwd)"
. "$ROOT/lib/log.sh"; . "$ROOT/lib/deploy.sh"; . "$ROOT/lib/detect.sh"
: "${TARGET_USER:?set TARGET_USER}"
H="$(getent passwd "$TARGET_USER" | cut -d: -f6)"

# 部署 kitty 配置（含软链）
install -d -o "$TARGET_USER" -g "$TARGET_USER" "$H/.config/kitty"
cp -a "$ROOT/configs/kitty/." "$H/.config/kitty/"
chown -R "$TARGET_USER" "$H/.config/kitty" 2>/dev/null || true

# 字号按设备：r7 7840 → 14.0，其它 → 12.0（可用 KITTY_FONT_SIZE 覆盖）
FONT_SIZE="${KITTY_FONT_SIZE:-}"
if [ -z "$FONT_SIZE" ]; then
    if is_amd_7840; then FONT_SIZE=14.0; else FONT_SIZE=12.0; fi
fi
sed -i "s/^font_size 12.0$/font_size $FONT_SIZE/" "$H/.config/kitty/kitty.conf"
log "kitty font_size=$FONT_SIZE (configs/kitty/kitty.conf)"

# 设为默认终端（Debian）；移除默认终端（谨慎，先确保 kitty 已装）
if command -v kitty >/dev/null 2>&1; then
    update-alternatives --set x-terminal-emulator /usr/bin/kitty 2>/dev/null || \
    update-alternatives --install /usr/bin/x-terminal-emulator x-terminal-emulator /usr/bin/kitty 50 2>/dev/null || true
fi
# i3 的终端快捷键
[ -f "$H/.config/i3/config" ] && sed -i 's/exec xterm/exec kitty/' "$H/.config/i3/config" || true
log "kitty deployed"
