# S8 终端（kitty）

## 目标
- 安装 **kitty**，设为系统默认终端（`x-terminal-emulator` → kitty），移除默认终端（如 xterm）。
- 字号 `font_size 12.0`，配置 `~/.config/kitty/kitty.conf`。
- 主题（个人）：`configs/kitty/`（`include ./theme.conf`；`theme.conf → other-themes/Nord.conf`）。

## 步骤
1. 按 `distros/<distro>/packages.md` 的“终端”装 `kitty`。
2. 运行 `apply.sh`（部署 kitty 配置、设置默认终端、i3 快捷键改用 kitty）。
3. QEMU 验证：`verify.sh`。

## QEMU 验证
- `kitty --version`；`x-terminal-emulator` 指向 kitty；`~/.config/kitty/kitty.conf` 正确；
- 用 kitty 的解析器确认 `font_size` 与主题（无需显示）。
