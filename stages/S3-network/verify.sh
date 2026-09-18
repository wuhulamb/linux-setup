#!/bin/sh
# S3 verify（在 guest 内运行）
set -eu
. "$(cd "$(dirname "$0")/../.." && pwd)/lib/log.sh"
ip -4 -br a || true
ip r || true
cat /etc/resolv.conf 2>/dev/null || true
command -v nmcli >/dev/null 2>&1 && nmcli -t -f DEVICE,TYPE,STATE,CONNECTION dev status || true
getent hosts deb.debian.org >/dev/null 2>&1 && echo DNS_OK || echo DNS_FAIL
