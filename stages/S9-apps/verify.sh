#!/bin/sh
# S9 verify（在 guest 内运行）
set -eu
. "$(cd "$(dirname "$0")/../.." && pwd)/lib/log.sh"
node -v 2>/dev/null || true
npm -v 2>/dev/null || true
pi --version 2>/dev/null | head -1 || true
