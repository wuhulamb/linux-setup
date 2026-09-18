# S7 输入法（fcitx5 + rime）

## 目标
- 安装 fcitx5 + fcitx5-rime（+ GTK/Qt 前端、configtool）。
- 部署个人配置：
  - fcitx5：`configs/fcitx5/{config,profile,conf/*}`；
  - rime：`configs/rime/{default.custom.yaml,luna_pinyin.custom.yaml}` → `~/.local/share/fcitx5/rime/`。
- 关键偏好：
  - **开机默认输入法是 rime**（输入法组里只有 rime，避免回退到 `keyboard-us`/en）；
  - rime 初始为**英文**（`switches/@0/reset: 1`）；
  - 按 **Shift** 在 rime 内切换中文（需清空 fcitx5 的 `AltTriggerKeys`，否则 Shift 被抢）。
  - 主题（可选）：Material-Color 的 `theme-blue.conf`。

## 步骤
1. 按 `distros/<distro>/packages.md` 的“输入法”装包。
2. 运行 `apply.sh`（需在 X 会话下触发一次 rime 部署；脚本用 Xvfb 无头完成）。
3. QEMU 验证：`verify.sh`（检查配置、rime build 是否生成）。

## QEMU 验证
- `fcitx5` 运行；`~/.local/share/fcitx5/rime/build/` 生成；
- `xrdb`/profile 等配置正确；无 failed unit。
