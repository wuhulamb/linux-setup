#!/bin/sh
# S9 apply：全局安装 pi，部署模型配置模板 + USB 根盘保活（可选附加）
set -eu
ROOT="$(cd "$(dirname "$0")/../.." && pwd)"
. "$ROOT/lib/log.sh"; . "$ROOT/lib/deploy.sh"; . "$ROOT/lib/svc.sh"
: "${TARGET_USER:?set TARGET_USER}"
H="$(getent passwd "$TARGET_USER" | cut -d: -f6)"

/usr/local/bin/npm install -g --ignore-scripts @earendil-works/pi-coding-agent
install -d -o "$TARGET_USER" -g "$TARGET_USER" -m 700 "$H/.pi/agent"
if [ -f "$ROOT/configs/models.json.example" ]; then
    deploy_file "$ROOT/configs/models.json.example" "$H/.pi/agent/models.json" 600 "$TARGET_USER"
fi
# 用户目录属主兜底：.pi 可能被手工以 root 提前创建 → 统一使出主为 TARGET_USER
chown -R "$TARGET_USER":"$TARGET_USER" "$H/.pi" 2>/dev/null || true

# USB 根盘保活（可选附加）：防硬盘盒固件空闲休眠导致整机冻结
# 根设备默认自动探测，可用 KEEP_ALIVE_DEVICE=/dev/sdX 覆盖
KEEP_DEV="${KEEP_ALIVE_DEVICE:-$(findmnt -n -o SOURCE / 2>/dev/null || echo /dev/sda2)}"
sed "s|@ROOT_DEV@|$KEEP_DEV|" "$ROOT/configs/keepalive/keep-sda-awake.service" \
    > /etc/systemd/system/keep-sda-awake.service
chmod 644 /etc/systemd/system/keep-sda-awake.service
deploy_file "$ROOT/configs/keepalive/keep-sda-awake.timer" \
            /etc/systemd/system/keep-sda-awake.timer 644
systemctl daemon-reload 2>/dev/null || true
svc_enable_now keep-sda-awake.timer
log "keep-sda-awake deployed (device: $KEEP_DEV)"
log "apps deployed"
