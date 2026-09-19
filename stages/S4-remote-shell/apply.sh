#!/bin/sh
# S4 apply：启用 openssh-server（发行版无关）
# dotfiles（vimrc / gitconfig，偏好）为可选子项，见 apply-dotfiles.sh
set -eu
ROOT="$(cd "$(dirname "$0")/../.." && pwd)"
. "$ROOT/lib/log.sh"; . "$ROOT/lib/svc.sh"

svc_enable_now ssh 2>/dev/null || svc_enable_now sshd 2>/dev/null || true
log "ssh enabled (dotfiles: 可选子项 apply-dotfiles.sh)"