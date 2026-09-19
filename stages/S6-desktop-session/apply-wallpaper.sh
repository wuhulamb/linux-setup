#!/bin/sh
# S6 壁纸（可选）：部署随机壁纸脚本/服务，并追加 i3 与 lightdm-greeter 配置
#
# 前提（宿主侧已完成）：
#   - feh 已装（i3 显示壁纸；装包见 distros/<distro>/packages.md S6 节）
#   - configs/wallpaper/README.md 说明的壁纸（来自 wuhulamb/wallpaper-crop，裁剪出
#     dst/1920x1080 与 dst/2880x1800）已上传到 "$TARGET_USER/Pictures/wallpaper/dst/"
# 本脚本在 guest 内运行，幂等。
set -eu
ROOT="$(cd "$(dirname "$0")/../.." && pwd)"
. "$ROOT/lib/log.sh"; . "$ROOT/lib/deploy.sh"; . "$ROOT/lib/svc.sh"
: "${TARGET_USER:?set TARGET_USER}"
H="$(getent passwd "$TARGET_USER" | cut -d: -f6)"

# 1) 随机选壁纸脚本 + oneshot 服务（登录界面前生成 /var/lib/wallpapers/current）
deploy_file "$ROOT/configs/wallpaper/random-wallpaper" /usr/local/bin/random-wallpaper 755
deploy_file "$ROOT/configs/wallpaper/random-wallpaper.service" /etc/systemd/system/random-wallpaper.service 644
svc_enable random-wallpaper.service

# 2) 壁纸目录（两个尺寸都备好，设备在运行期按 CPU 自动选择）
#    目录可能被手工以 root 提前创建/上传 → 统一使出主为 TARGET_USER
for s in 1920x1080 2880x1800; do
    install -d -o "$TARGET_USER" -g "$TARGET_USER" "$H/Pictures/wallpaper/dst/$s"
done
chown -R "$TARGET_USER":"$TARGET_USER" "$H/Pictures/wallpaper" 2>/dev/null || true

# 3) i3：会话启动用 feh 铺壁纸；Ctrl+Mod1+l 锁屏用当前壁纸
I3="$H/.config/i3/config"
if [ -f "$I3" ]; then
    grep -q 'feh --bg-fill /var/lib/wallpapers/current' "$I3" || \
        echo 'exec --no-startup-id feh --bg-fill /var/lib/wallpapers/current' >> "$I3"
    grep -q 'i3lock -i /var/lib/wallpapers/current' "$I3" || \
        echo 'bindsym Ctrl+Mod1+l exec --no-startup-id i3lock -i /var/lib/wallpapers/current' >> "$I3"
fi

# 4) greeter 背景（与 S6 的 xft-dpi 并存）
GREETER=/etc/lightdm/lightdm-gtk-greeter.conf
if [ -f "$GREETER" ]; then
    grep -q '^background=/var/lib/wallpapers/current' "$GREETER" || \
        sed -i '/^\[greeter\]/a background=/var/lib/wallpapers/current' "$GREETER"
    grep -q '^user-background=false' "$GREETER" || \
        sed -i '/^background=\/var\/lib\/wallpapers\/current/a user-background=false' "$GREETER"
fi

# 5) 立即生成一张（目录为空则跳过，不阻塞）
/usr/local/bin/random-wallpaper 2>/dev/null || warn "壁纸目录为空，跳过（请先把 dst/ 上传到位）"
log "wallpaper deployed"