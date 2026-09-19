#!/bin/sh
# S3 代理（可选子项）apply：部署 shadowsocks-libev 本地 SOCKS5 代理并开机自启（发行版无关）
#
# 真实服务器/口令不入库：
#   - 默认读取仓库根的 shadowsocks-config.json（已被 .gitignore 忽略）
#   - 或用 SS_CONFIG=/path/to/config.json 指定
#   - 或运行期用 SS_SERVER/SS_PASSWORD 等环境变量生成
set -eu
ROOT="$(cd "$(dirname "$0")/../.." && pwd)"
. "$ROOT/lib/log.sh"; . "$ROOT/lib/deploy.sh"; . "$ROOT/lib/svc.sh"

CONF="${SS_CONFIG:-$ROOT/shadowsocks-config.json}"
SS_DIR=/etc/shadowsocks-libev
SS_CONF="$SS_DIR/config.json"

# 1) 生成 / 取得配置
install -d -m 755 "$SS_DIR"
if [ -f "$CONF" ]; then
    install -m 640 "$CONF" "$SS_CONF"
elif [ -n "${SS_SERVER:-}" ] && [ -n "${SS_PASSWORD:-}" ]; then
    cat > "$SS_CONF" <<EOF
{
    "server": "$SS_SERVER",
    "server_port": ${SS_PORT:-8388},
    "local_address": "127.0.0.1",
    "local_port": ${SS_LOCAL_PORT:-1080},
    "password": "$SS_PASSWORD",
    "timeout": ${SS_TIMEOUT:-60},
    "method": "${SS_METHOD:-aes-256-gcm}"
}
EOF
    chmod 640 "$SS_CONF"
else
    die "missing $CONF（或设置 SS_SERVER/SS_PASSWORD，或用 SS_CONFIG 指定）"
fi

# 2) 专用系统用户（不可登录），配置仅该组可读
if ! id shadowsocks >/dev/null 2>&1; then
    useradd --system --no-create-home --shell /usr/sbin/nologin shadowsocks 2>/dev/null || \
    useradd --system --no-create-home --shell /sbin/nologin    shadowsocks
fi
chown root:shadowsocks "$SS_CONF"

# 3) 部署 systemd 单元并开机自启
deploy_file "$ROOT/configs/proxy/shadowsocks-local.service" \
            /etc/systemd/system/shadowsocks-local.service 644
svc_disable shadowsocks-libev.service            # 关闭包自带的服务端服务
systemctl daemon-reload 2>/dev/null || true
svc_enable_now shadowsocks-local.service
log "shadowsocks local proxy deployed (config: $SS_CONF)"
