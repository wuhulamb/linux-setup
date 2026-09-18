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
deploy_file "$ROOT/configs/rime/default.custom.yaml" "$H/.local/share/fcitx5/rime/default.custom.yaml" 644 "$TARGET_USER"
deploy_file "$ROOT/configs/rime/luna_pinyin.custom.yaml" "$H/.local/share/fcitx5/rime/luna_pinyin.custom.yaml" 644 "$TARGET_USER"

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
