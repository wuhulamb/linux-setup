#!/bin/sh
# S7 输入法（可选）：安装 fcitx5-vinput 语音输入（本地离线 ASR）
#   来源: https://github.com/wuhulamb/fcitx5-vinput （精简版：按住触发键说话→松开上屏）
#   默认触发键: 右 Alt（Alt_R）
#
# 与上游 README 的差异（实测）：
#   - 上游用 uv 装 PyPI sherpa-onnx 并取其 include/lib；但 1.13.x 的 PyPI wheel
#     不打包 C API 头文件与共享库，故这里改用官方共享库 release：
#       k2-fsa/sherpa-onnx v$SHERPA_VER linux-x64-shared
#   - 模型用 int8 版（约 160MB，CPU 可跑；原 README 的 fp32 版约 1GB）
#
# 构建依赖见 distros/<distro>/packages.md 的“输入法（S7）”，本脚本不做包管理。
# 用法: TARGET_USER=xu sudo -E ./install-vinput.sh
set -eu
ROOT="$(cd "$(dirname "$0")/../.." && pwd)"
. "$ROOT/lib/log.sh"
: "${TARGET_USER:?set TARGET_USER}"
U="$TARGET_USER"

SHERPA_VER=1.13.7
SHERPA_URL="https://github.com/k2-fsa/sherpa-onnx/releases/download/v${SHERPA_VER}/sherpa-onnx-v${SHERPA_VER}-linux-x64-shared.tar.bz2"
MODEL_URL="https://github.com/k2-fsa/sherpa-onnx/releases/download/asr-models/sherpa-onnx-sense-voice-zh-en-ja-ko-yue-int8-2024-07-17.tar.bz2"
SRC=/opt/fcitx5-vinput
SHERPA_ROOT=/opt/sherpa-onnx
MODEL_DIR=/usr/local/share/fcitx5-vinput/sense-voice

command -v cmake >/dev/null 2>&1 || die "缺少构建工具，请先按 packages.md(S7) 装包"

log "1/6 sherpa-onnx 共享库 (${SHERPA_VER})"
if [ ! -f "$SHERPA_ROOT/lib/libsherpa-onnx-c-api.so" ]; then
    wget -q -O /opt/sherpa-onnx.tar.bz2 "$SHERPA_URL" || die "下载 sherpa-onnx 失败"
    rm -rf "$SHERPA_ROOT"
    tar xjf /opt/sherpa-onnx.tar.bz2 -C /opt
    mv "/opt/sherpa-onnx-v${SHERPA_VER}-linux-x64-shared" "$SHERPA_ROOT"
    rm -f /opt/sherpa-onnx.tar.bz2
fi
[ -f "$SHERPA_ROOT/include/sherpa-onnx/c-api/c-api.h" ] || die "sherpa-onnx 头文件缺失"

log "2/6 获取源码"
[ -d "$SRC/.git" ] || git clone --depth 1 https://github.com/wuhulamb/fcitx5-vinput.git "$SRC"
log "3/6 构建并安装"
cmake -B "$SRC/build" -DCMAKE_BUILD_TYPE=Release -DSHERPA_ONNX_ROOT="$SHERPA_ROOT" >/dev/null
cmake --build "$SRC/build" -j"$(nproc)"
cmake --install "$SRC/build"

log "4/6 sense-voice int8 模型 (~160MB)"
if [ ! -f "$MODEL_DIR/model.int8.onnx" ]; then
    install -d "$MODEL_DIR"
    wget -q -O /opt/sense-voice.tar.bz2 "$MODEL_URL" || die "下载模型失败"
    _t="$(mktemp -d)"
    tar xjf /opt/sense-voice.tar.bz2 -C "$_t"
    cp "$_t"/*/model.int8.onnx "$MODEL_DIR/"
    cp "$_t"/*/tokens.txt "$MODEL_DIR/"
    rm -rf "$_t" /opt/sense-voice.tar.bz2
fi

log "5/6 用户 $U 配置"
H="$(getent passwd "$U" | cut -d: -f6)"
install -d -o "$U" -g "$U" "$H/.config/fcitx5-vinput"
cat > "$H/.config/fcitx5-vinput/config.json" <<JSON
{
  "model": "$MODEL_DIR/model.int8.onnx",
  "tokens": "$MODEL_DIR/tokens.txt",
  "language": "auto",
  "use_itn": true,
  "num_threads": 4,
  "device": "default"
}
JSON
chown "$U" "$H/.config/fcitx5-vinput/config.json"

log "6/6 用户服务开机自启（linger）"
install -d -o "$U" -g "$U" "$H/.config/systemd/user/default.target.wants"
ln -sf /usr/share/systemd/user/vinput-daemon.service \
       "$H/.config/systemd/user/default.target.wants/vinput-daemon.service"
chown -h "$U" "$H/.config/systemd/user/default.target.wants/vinput-daemon.service"
loginctl enable-linger "$U" 2>/dev/null || true
systemctl start "user@$(id -u "$U")" 2>/dev/null || true

log "fcitx5-vinput 安装完成；重启 fcitx5（fcitx5 -d）后按右 Alt 说话即可使用"