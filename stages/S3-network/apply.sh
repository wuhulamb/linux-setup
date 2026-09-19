#!/bin/sh
# S3 apply：部署 NetworkManager 配置 + 校园网认证（发行版无关）
set -eu
ROOT="$(cd "$(dirname "$0")/../.." && pwd)"
. "$ROOT/lib/log.sh"; . "$ROOT/lib/deploy.sh"; . "$ROOT/lib/svc.sh"
: "${TARGET_USER:?set TARGET_USER}"
TARGET_HOME="$(getent passwd "$TARGET_USER" | cut -d: -f6)"

# 1) 有线 DHCP profile（通用）
deploy_file "$ROOT/configs/network/wired-dhcp.nmconnection" \
            /etc/NetworkManager/system-connections/wired-dhcp.nmconnection 600

# 2) 校园网 Wi-Fi（凭据运行期生成，不落仓库）
if [ -n "${WIFI_SSID:-}" ] && [ -n "${ECNU_USERNAME:-}" ] && [ -n "${ECNU_PASSWORD:-}" ]; then
    sed -e "s/<WIFI_SSID>/$WIFI_SSID/" -e "s/<CAMPUS_ID>/$ECNU_USERNAME/" \
        -e "s/<CAMPUS_PASSWORD>/$ECNU_PASSWORD/" \
        "$ROOT/configs/network/ECNU-1X.nmconnection.example" \
        > /etc/NetworkManager/system-connections/ECNU-1X.nmconnection
    chmod 600 /etc/NetworkManager/system-connections/ECNU-1X.nmconnection
fi

# 3) 校园网有线认证
install -D -m755 "$ROOT/configs/network/ecnu_net_login.py" /usr/local/bin/ecnu_net_login
mkdir -p /etc/ecnu
[ -n "${ECNU_USERNAME:-}" ] && [ -n "${ECNU_PASSWORD:-}" ] && \
    printf 'username=%s\npassword=%s\n' "$ECNU_USERNAME" "$ECNU_PASSWORD" > /etc/ecnu/ecnu.conf
chmod 600 /etc/ecnu/ecnu.conf 2>/dev/null || true
install -D -m644 "$ROOT/configs/network/ecnu-net-login.service" /etc/systemd/system/ecnu-net-login.service

# 4) 交给 NetworkManager
svc_enable_now NetworkManager
svc_enable_now ecnu-net-login
log "network config deployed"
