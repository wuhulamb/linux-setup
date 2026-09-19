#!/bin/sh
# S5 verify（在 guest 内运行）
set -eu
. "$(cd "$(dirname "$0")/../.." && pwd)/lib/log.sh"
fc-match "Microsoft YaHei" 2>/dev/null || true
fc-match monospace 2>/dev/null || true
: "${TARGET_USER:?set TARGET_USER}"
su - "$TARGET_USER" -c 'cat ~/.Xresources' 2>/dev/null || true
