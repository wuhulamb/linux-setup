#!/usr/bin/env bash
# S1 入口：按 $DISTRO 调用对应 bootstrap（发行版专属）
set -euo pipefail
ROOT="$(cd "$(dirname "$0")/../.." && pwd)"
: "${DISTRO:?set DISTRO=debian|arch}"
: "${TARGET:?set TARGET=/dev/sdX}"
case "$DISTRO" in
  debian) exec "$ROOT/distros/debian/bootstrap.sh" ;;
  arch)   exec "$ROOT/distros/arch/bootstrap.sh" ;;
  *) echo "unsupported DISTRO=$DISTRO" >&2; exit 1 ;;
esac
