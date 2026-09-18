#!/bin/sh
# S2 verify（在 guest 内运行）
set -eu
. "$(cd "$(dirname "$0")/../.." && pwd)/lib/log.sh"
: "${TARGET_USER:?set TARGET_USER}"
id "$TARGET_USER"
groups "$TARGET_USER"
hostname
systemctl is-system-running || true
systemctl --failed --no-pager || true
