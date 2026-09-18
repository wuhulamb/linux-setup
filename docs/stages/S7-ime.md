# S7 输入法（fcitx5 + rime）

装包：`fcitx5`、`fcitx5-rime`、configtool、GTK/Qt 前端（见 `packages.md`）。
配置（`configs/`）：
- `fcitx5/profile`：输入法组**只有 rime**（避免开机回退到 `keyboard-us`/en）；
- `fcitx5/config`：清空 `AltTriggerKeys`（默认 `Shift_L` 会抢走 Shift）；
- `fcitx5/conf/*`：主题与单行预编辑；
- `rime/*.custom.yaml`：`switches/@0/reset: 1`（初始英文）。

效果：开机即 rime，初始英文，**Shift 切中文**。

验证：`verify.sh`（fcitx5 运行、rime build 生成、配置正确）。
