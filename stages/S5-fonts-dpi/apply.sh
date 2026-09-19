#!/bin/sh
# S5 apply：字体 + fontconfig + 按机器 Xft.dpi 的会话初始化脚本
set -eu
ROOT="$(cd "$(dirname "$0")/../.." && pwd)"
. "$ROOT/lib/log.sh"; . "$ROOT/lib/deploy.sh"
: "${TARGET_USER:?set TARGET_USER}"
H="$(getent passwd "$TARGET_USER" | cut -d: -f6)"

mkdir -p "$H/.fonts" "$H/.config/fontconfig"
# 字体文件不入库：优先用本地 configs/fonts/files/，否则从个人仓库克隆
#   来源: https://github.com/wuhulamb/fonts
FONTS_REPO="${FONTS_REPO:-https://github.com/wuhulamb/fonts.git}"
if [ -d "$ROOT/configs/fonts/files" ]; then
    cp -a "$ROOT/configs/fonts/files/." "$H/.fonts/" 2>/dev/null || true
else
    _tmp="$(mktemp -d)"
    git clone --depth 1 "$FONTS_REPO" "$_tmp" 2>/dev/null && cp -a "$_tmp/." "$H/.fonts/" 2>/dev/null || true
    rm -rf "$_tmp"
fi
chown -R "$TARGET_USER" "$H/.fonts" 2>/dev/null || true
deploy_file "$ROOT/configs/fonts/fonts.conf" "$H/.config/fontconfig/fonts.conf" 644 "$TARGET_USER"
chown -R "$TARGET_USER":"$TARGET_USER" "$H/.config/fontconfig" 2>/dev/null || true   # 目录属主兜底

# 按机器设置 Xft.dpi 的脚本（供 X 会话初始化调用）
install -D -m755 "$ROOT/lib/detect.sh" /usr/local/lib/linux-setup/detect.sh
cat > /usr/local/bin/apply-xft-dpi <<'EOS'
#!/bin/sh
. /usr/local/lib/linux-setup/detect.sh
dpi="$(preferred_dpi)"
xr="$HOME/.Xresources"; tmp="$xr.tmp.$$"
[ -f "$xr" ] && grep -v '^[[:space:]]*Xft\.dpi' "$xr" >"$tmp" 2>/dev/null || : >"$tmp"
printf 'Xft.dpi: %s\n' "$dpi" >>"$tmp"; mv "$tmp" "$xr"
[ -n "${DISPLAY:-}" ] && command -v xrdb >/dev/null 2>&1 && \
    { xrdb -merge "$xr" 2>/dev/null || xrdb -nocpp -merge "$xr" 2>/dev/null || true; }
EOS
chmod 755 /usr/local/bin/apply-xft-dpi

# 挂到 X 会话初始化（早于 30x11-common_xresources / i3）
cat > /etc/X11/Xsession.d/25apply-xft-dpi <<'EOS'
#!/bin/sh
[ -x /usr/local/bin/apply-xft-dpi ] && /usr/local/bin/apply-xft-dpi
EOS
chmod 755 /etc/X11/Xsession.d/25apply-xft-dpi
# 兼容 startx
[ -f "$H/.xinitrc" ] && ! grep -q apply-xft-dpi "$H/.xinitrc" && \
    sed -i 's#^exec #/usr/local/bin/apply-xft-dpi\nexec #' "$H/.xinitrc" || true

log "fonts/xft-dpi deployed"
