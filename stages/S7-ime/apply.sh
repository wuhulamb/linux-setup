#!/bin/sh
# S7 apply：部署 fcitx5 + rime 配置并触发部署
set -eu
ROOT="$(cd "$(dirname "$0")/../.." && pwd)"
. "$ROOT/lib/log.sh"; . "$ROOT/lib/deploy.sh"; . "$ROOT/lib/svc.sh"
: "${TARGET_USER:?set TARGET_USER}"
H="$(getent passwd "$TARGET_USER" | cut -d: -f6)"

install -d -o "$TARGET_USER" -g "$TARGET_USER" "$H/.config/fcitx5" \
    "$H/.config/fcitx5/conf" "$H/.local/share/fcitx5/rime"
deploy_file "$ROOT/configs/fcitx5/config" "$H/.config/fcitx5/config" 644 "$TARGET_USER"
deploy_file "$ROOT/configs/fcitx5/profile" "$H/.config/fcitx5/profile" 644 "$TARGET_USER"
deploy_file "$ROOT/configs/fcitx5/conf/classicui.conf" "$H/.config/fcitx5/conf/classicui.conf" 644 "$TARGET_USER"
deploy_file "$ROOT/configs/fcitx5/conf/rime.conf" "$H/.config/fcitx5/conf/rime.conf" 644 "$TARGET_USER"
# rime 配置不入库：从个人仓库获取，再应用本仓库的个人调整
#   来源: https://github.com/wongdean/rime-settings
RIME_REPO="${RIME_REPO:-https://github.com/wongdean/rime-settings.git}"
RIME="$H/.local/share/fcitx5/rime"
_tmp="$(mktemp -d)"
if git clone --depth 1 "$RIME_REPO" "$_tmp" 2>/dev/null; then
    cp -a "$_tmp/." "$RIME/"
    # rime 自带字体 -> ~/.fonts（个人字体另有仓库）
    if [ -d "$RIME/font" ]; then cp -f "$RIME/font/"*.ttf "$H/.fonts/" 2>/dev/null || true; rm -rf "$RIME/font"; fi
    python3 "$ROOT/stages/S7-ime/apply-rime-tweaks.py" "$RIME" 2>/dev/null || true
fi
rm -rf "$_tmp"
chown -R "$TARGET_USER" "$RIME" 2>/dev/null || true

# 触发一次 rime 部署（无头）
install -d -o "$TARGET_USER" -g "$TARGET_USER" -m 700 "/run/user/$(id -u "$TARGET_USER")" 2>/dev/null || true
su - "$TARGET_USER" -c '
  export XDG_RUNTIME_DIR=/run/user/'"$(id -u "$TARGET_USER")"'
  Xvfb :98 -ac -screen 0 1280x800x24 >/tmp/xvfb_rime.log 2>&1 & sleep 3
  export DISPLAY=:98 GTK_IM_MODULE=fcitx QT_IM_MODULE=fcitx XMODIFIERS=@im=fcitx
  dbus-run-session -- bash -c "fcitx5 -d --replace >/tmp/fcitx5_rime.log 2>&1; sleep 45; fcitx5-remote -e >/dev/null 2>&1"
  pkill -f "Xvfb :98" >/dev/null 2>&1
' 2>/dev/null || true
log "ime deployed"
