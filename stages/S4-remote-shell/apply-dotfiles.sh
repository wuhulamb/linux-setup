#!/bin/sh
# S4 可选子项 apply：dotfiles（vimrc / gitconfig）偏好部署（发行版无关）
# 说明：xprofile 已废止——输入法环境变量统一由 S6 写 /etc/environment，
#       避免同一目的两处实现。见 docs/stages/S6-desktop-session.md。
set -eu
ROOT="$(cd "$(dirname "$0")/../.." && pwd)"
. "$ROOT/lib/log.sh"; . "$ROOT/lib/deploy.sh"
: "${TARGET_USER:?set TARGET_USER}"
H="$(getent passwd "$TARGET_USER" | cut -d: -f6)"

[ -f "$ROOT/configs/dotfiles/vimrc" ] && deploy_file "$ROOT/configs/dotfiles/vimrc" "$H/.vimrc" 644 "$TARGET_USER"
if [ -f "$ROOT/configs/dotfiles/gitconfig.example" ]; then
    deploy_file "$ROOT/configs/dotfiles/gitconfig.example" "$H/.gitconfig" 644 "$TARGET_USER"
fi
# 运行期可覆盖 git 身份
[ -n "${GIT_NAME:-}" ]  && su - "$TARGET_USER" -c "git config --global user.name  '$GIT_NAME'"  2>/dev/null || true
[ -n "${GIT_EMAIL:-}" ] && su - "$TARGET_USER" -c "git config --global user.email '$GIT_EMAIL'" 2>/dev/null || true
log "dotfiles deployed"