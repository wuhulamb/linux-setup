#!/bin/sh
# S10 verify（在 guest 内运行）
set -eu
. "$(cd "$(dirname "$0")/../.." && pwd)/lib/log.sh"
systemctl is-enabled keep-sda-awake.timer 2>/dev/null || true
systemctl is-active  keep-sda-awake.timer 2>/dev/null || true
journalctl -u keep-sda-awake.service -n 5 --no-pager 2>/dev/null | tail -5 || true