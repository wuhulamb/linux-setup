#!/bin/sh
# S9 apply：全局安装 pi，部署模型配置模板
set -eu
ROOT="$(cd "$(dirname "$0")/../.." && pwd)"
. "$ROOT/lib/log.sh"; . "$ROOT/lib/deploy.sh"
: "${TARGET_USER:?set TARGET_USER}"
H="$(getent passwd "$TARGET_USER" | cut -d: -f6)"

/usr/local/bin/npm install -g --ignore-scripts @earendil-works/pi-coding-agent
install -d -o "$TARGET_USER" -g "$TARGET_USER" -m 700 "$H/.pi/agent"
if [ -f "$ROOT/configs/models.json.example" ]; then
    deploy_file "$ROOT/configs/models.json.example" "$H/.pi/agent/models.json" 600 "$TARGET_USER"
fi
log "apps deployed"
