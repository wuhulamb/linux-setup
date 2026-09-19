#!/bin/sh
# S4 verify（在 guest 内运行）
set -eu
. "$(cd "$(dirname "$0")/../.." && pwd)/lib/log.sh"
systemctl is-active ssh 2>/dev/null || systemctl is-active sshd 2>/dev/null || true