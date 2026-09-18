# S8 终端（kitty）

## 目标
- 安装 **kitty**，设为默认终端（`x-terminal-emulator` → kitty），移除默认终端（如 xterm）。
- 字号 `font_size 12.0`；主题：`configs/kitty/`（`kitty.conf` 中 `include ./theme.conf`，
  `theme.conf → other-themes/Nord.conf`）。

## 步骤
1. 按 `distros/<distro>/packages.md` 装 `kitty`。
2. 运行 `stages/S8-terminal/apply.sh`（部署配置、设置默认终端、i3 快捷键改用 kitty）。
3. QEMU 验证。

## 验证
方法见 `docs/verification.md`。S8 要点：`kitty --version`、`x-terminal-emulator` 指向 kitty、
`~/.config/kitty/kitty.conf` 正确（font_size/主题解析）。