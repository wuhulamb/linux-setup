#!/usr/bin/env bash
# 通过串口 socket 登录 guest 并执行命令/脚本，产物存到 artifacts/
# 依赖: socat。这里给出通用骨架，实际各阶段 verify.sh 可复用。
# 用法: GUEST_USER=root ./guest-exec.sh 'commands...'
set -euo pipefail
ROOT="$(cd "$(dirname "$0")/.." && pwd)"
SOCK="${GUEST_SOCK:-$ROOT/artifacts/guest.sock}"
LOG="$ROOT/artifacts/guest-exec.log"
USER="${GUEST_USER:-root}"
PASS="${GUEST_PASS:?set GUEST_PASS for login}"   # 仅运行期使用，勿写入版本库
CMDS="${1:?usage: guest-exec.sh 'commands'}"
{ printf 'wait for login...\n'; sleep 1; } >>"$LOG"
socat -t 600 - UNIX-CONNECT:"$SOCK" <<EOF >>"$LOG" 2>&1
$USER
$PASS
$CMDS
EOF
echo "done"
