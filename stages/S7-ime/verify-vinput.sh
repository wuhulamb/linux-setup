#!/bin/sh
# S7 verify: fcitx5-vinput（在 guest 内运行）
set -eu
. "$(cd "$(dirname "$0")/../.." && pwd)/lib/log.sh"
: "${TARGET_USER:?set TARGET_USER}"
U="$TARGET_USER"; H="$(getent passwd "$U" | cut -d: -f6)"

command -v vinput-daemon && vinput-daemon --version 2>&1 | head -1 || true
echo "--- fcitx5 插件产物 ---"
ls -l /usr/lib/x86_64-linux-gnu/fcitx5/fcitx5-vinput.so /usr/share/fcitx5/addon/vinput.conf 2>/dev/null || true
echo "--- 用户配置 ---"
cat "$H/.config/fcitx5-vinput/config.json" 2>/dev/null || true
echo "--- linger ---"
test -f /var/lib/systemd/linger/"$U" && echo "linger: on" || echo "linger: off"
echo "--- vinput-daemon 状态 ---"
su - "$U" -c 'XDG_RUNTIME_DIR=/run/user/'"$(id -u "$U")"' systemctl --user is-active vinput-daemon 2>/dev/null' || echo "inactive (需图形会话/登录后生效)"
echo "--- 模型 ---"
ls -lh /usr/local/share/fcitx5-vinput/sense-voice/ 2>/dev/null || true