#!/bin/sh
# S8 apply：kitty 配置 + 设为默认终端
# 字号按设备（运行期）：与 Xft.dpi 同一方案，见 docs/stages/S8-terminal.md
set -eu
ROOT="$(cd "$(dirname "$0")/../.." && pwd)"
. "$ROOT/lib/log.sh"; . "$ROOT/lib/deploy.sh"; . "$ROOT/lib/detect.sh"
: "${TARGET_USER:?set TARGET_USER}"
H="$(getent passwd "$TARGET_USER" | cut -d: -f6)"

# 1) 部署 kitty 配置（含软链与模板）
install -d -o "$TARGET_USER" -g "$TARGET_USER" "$H/.config/kitty"
cp -a "$ROOT/configs/kitty/." "$H/.config/kitty/"
chown -R "$TARGET_USER" "$H/.config/kitty" 2>/dev/null || true

# 2) 机器检测库 + 会话初始化脚本（与 S5 apply-xft-dpi 同款，可在运行设备上按 CPU 判定）
install -D -m755 "$ROOT/lib/detect.sh" /usr/local/lib/linux-setup/detect.sh
# 初始生成（保证文件存在；之后每次 X 会话启动都按当前机器重写）
printf 'font_size %s\n' "$(preferred_kitty_font_size)" > "$H/.config/kitty/font-size.conf"
chown "$TARGET_USER" "$H/.config/kitty/font-size.conf"
cat > /usr/local/bin/apply-kitty-font-size <<'EOS'
#!/bin/sh
. /usr/local/lib/linux-setup/detect.sh
size="$(preferred_kitty_font_size)"
d="${KITTY_CONFIG_DIRECTORY:-$HOME/.config/kitty}"
mkdir -p "$d"
printf 'font_size %s\n' "$size" > "$d/font-size.conf"
EOS
chmod 755 /usr/local/bin/apply-kitty-font-size
# 挂到 X 会话初始化（与 25apply-xft-dpi 同段执行）
cat > /etc/X11/Xsession.d/26apply-kitty-font-size <<'EOS'
#!/bin/sh
[ -x /usr/local/bin/apply-kitty-font-size ] && /usr/local/bin/apply-kitty-font-size
EOS
chmod 755 /etc/X11/Xsession.d/26apply-kitty-font-size
# 兼容 startx
[ -f "$H/.xinitrc" ] && ! grep -q apply-kitty-font-size "$H/.xinitrc" && \
    sed -i 's#^exec #/usr/local/bin/apply-kitty-font-size\nexec #' "$H/.xinitrc" || true
log "kitty font_size: $(preferred_kitty_font_size)（本机检测；会话启动时自动重写）"

# 3) 设为默认终端（Debian）；移除默认终端（谨慎，先确保 kitty 已装）
if command -v kitty >/dev/null 2>&1; then
    update-alternatives --set x-terminal-emulator /usr/bin/kitty 2>/dev/null || \
    update-alternatives --install /usr/bin/x-terminal-emulator x-terminal-emulator /usr/bin/kitty 50 2>/dev/null || true
fi
# 4) i3 的终端快捷键
[ -f "$H/.config/i3/config" ] && sed -i 's/exec xterm/exec kitty/' "$H/.config/i3/config" || true
log "kitty deployed"