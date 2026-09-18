#!/bin/sh
# S3-proxy verify（在 guest 内运行）
set -eu
. "$(cd "$(dirname "$0")/../.." && pwd)/lib/log.sh"
systemctl is-enabled shadowsocks-local.service 2>/dev/null || true
systemctl is-active  shadowsocks-local.service 2>/dev/null || true
ss -lntp 2>/dev/null | grep 1080 || echo "NOT LISTENING on 1080"
# 通过代理访问（google 204；能通即代理链路生效）
if command -v curl >/dev/null 2>&1; then
    curl -s -m 15 -x socks5h://127.0.0.1:1080 -o /dev/null \
        -w 'proxy http_code=%{http_code}\n' \
        https://www.google.com/generate_204 || echo "proxy request failed"
fi
