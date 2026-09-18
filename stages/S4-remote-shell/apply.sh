#!/bin/sh
# S4 apply：启用 ssh + 部署 dotfiles（发行版无关）
set -eu
ROOT="$(cd "$(dirname "$0")/../.." && pwd)"
. "$ROOT/lib/log.sh"; . "$ROOT/lib/deploy.sh"; . "$ROOT/lib/svc.sh"
: "${TARGET_USER:?set TARGET_USER}"
H="$(getent passwd "$TARGET_USER" | cut -d: -f6)"

svc_enable_now ssh 2>/dev/null || svc_enable_now sshd 2>/dev/null || true
[ -f "$ROOT/configs/dotfiles/vimrc" ]    && deploy_file "$ROOT/configs/dotfiles/vimrc"    "$H/.vimrc" 644 "$TARGET_USER"
[ -f "$ROOT/configs/dotfiles/xprofile" ] && deploy_file "$ROOT/configs/dotfiles/xprofile" "$H/.xprofile" 644 "$TARGET_USER"
if [ -f "$ROOT/configs/dotfiles/gitconfig.example" ]; then
    deploy_file "$ROOT/configs/dotfiles/gitconfig.example" "$H/.gitconfig" 644 "$TARGET_USER"
fi
# 运行期可覆盖 git 身份
[ -n "${GIT_NAME:-}" ]  && su - "$TARGET_USER" -c "git config --global user.name  '$GIT_NAME'"  2>/dev/null || true
[ -n "${GIT_EMAIL:-}" ] && su - "$TARGET_USER" -c "git config --global user.email '$GIT_EMAIL'" 2>/dev/null || true
log "remote/shell config deployed"
