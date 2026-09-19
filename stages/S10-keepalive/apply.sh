#!/bin/sh
# S10 apply：USB 根盘保活（可选附加）—— 防硬盘盒固件空闲休眠导致整机冻结
#
# 目标设备：默认 findmnt 探测根设备；可用 KEEP_ALIVE_DEVICE=/dev/sdX 覆盖
# 部署件：configs/keepalive/（service 模板 + timer）
set -eu
ROOT="$(cd "$(dirname "$0")/../.." && pwd)"
. "$ROOT/lib/log.sh"; . "$ROOT/lib/deploy.sh"; . "$ROOT/lib/svc.sh"

KEEP_DEV="${KEEP_ALIVE_DEVICE:-$(findmnt -n -o SOURCE / 2>/dev/null || echo /dev/sda2)}"
sed "s|@ROOT_DEV@|$KEEP_DEV|" "$ROOT/configs/keepalive/keep-sda-awake.service" \
    > /etc/systemd/system/keep-sda-awake.service
chmod 644 /etc/systemd/system/keep-sda-awake.service
deploy_file "$ROOT/configs/keepalive/keep-sda-awake.timer" \
            /etc/systemd/system/keep-sda-awake.timer 644
systemctl daemon-reload 2>/dev/null || true
svc_enable_now keep-sda-awake.timer
log "keep-sda-awake deployed (device: $KEEP_DEV)"