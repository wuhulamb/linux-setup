#!/bin/sh
# S6 verify（在 guest 内运行）
set -eu
. "$(cd "$(dirname "$0")/../.." && pwd)/lib/log.sh"
systemctl is-active lightdm 2>/dev/null || true
systemctl is-enabled lightdm 2>/dev/null || true
systemctl get-default 2>/dev/null || true
pgrep -a Xorg 2>/dev/null || true
grep -n '^xft-dpi' /etc/lightdm/lightdm-gtk-greeter.conf 2>/dev/null || true
systemctl --failed --no-pager 2>/dev/null || true
