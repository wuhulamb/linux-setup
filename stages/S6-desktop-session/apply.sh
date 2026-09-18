#!/bin/sh
# S6 apply：i3 + lightdm + 会话/greeter DPI
set -eu
ROOT="$(cd "$(dirname "$0")/../.." && pwd)"
. "$ROOT/lib/log.sh"; . "$ROOT/lib/deploy.sh"; . "$ROOT/lib/svc.sh"; . "$ROOT/lib/detect.sh"
: "${TARGET_USER:?set TARGET_USER}"
H="$(getent passwd "$TARGET_USER" | cut -d: -f6)"

# i3
deploy_file "$ROOT/configs/i3/config" "$H/.config/i3/config" 644 "$TARGET_USER"

# lightdm：默认 i3 + 图形目标
install -D -m755 "$ROOT/lib/detect.sh" /usr/local/lib/linux-setup/detect.sh
mkdir -p /etc/lightdm
cat > /etc/lightdm/lightdm.conf <<'EOS'
[Seat:*]
greeter-session=lightdm-gtk-greeter
user-session=i3
EOS
svc_enable lightdm 2>/dev/null || true
systemctl set-default graphical.target 2>/dev/null || true

# greeter DPI（按机器）——greeter 读不到用户 ~/.Xresources
mkdir -p /usr/local/bin
cat > /usr/local/bin/set-greeter-dpi <<'EOS'
#!/bin/sh
. /usr/local/lib/linux-setup/detect.sh
dpi="$(preferred_dpi)"
conf=/etc/lightdm/lightdm-gtk-greeter.conf
[ -f "$conf" ] || exit 0
if grep -q '^xft-dpi=' "$conf"; then sed -i "s/^xft-dpi=.*/xft-dpi=$dpi/" "$conf"
else sed -i "/^\[greeter\]/a xft-dpi=$dpi" "$conf"; fi
EOS
chmod 755 /usr/local/bin/set-greeter-dpi
cat > /etc/systemd/system/greeter-dpi.service <<'EOS'
[Unit]
Description=Set lightdm-gtk-greeter Xft DPI based on machine
After=local-fs.target
Before=lightdm.service display-manager.service
[Service]
Type=oneshot
ExecStart=/usr/local/bin/set-greeter-dpi
RemainAfterExit=yes
[Install]
WantedBy=graphical.target
EOS
systemctl daemon-reload 2>/dev/null || true
svc_enable greeter-dpi.service
/usr/local/bin/set-greeter-dpi 2>/dev/null || true

# 会话输入法环境变量（供 S7）
for kv in GTK_IM_MODULE=fcitx QT_IM_MODULE=fcitx XMODIFIERS=@im=fcitx SDL_IM_MODULE=fcitx GLFW_IM_MODULE=ibus; do
    grep -q "^${kv%%=*}=" /etc/environment 2>/dev/null || echo "$kv" >> /etc/environment
done
log "desktop/session deployed"
