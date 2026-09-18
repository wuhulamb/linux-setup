# S8 终端（kitty）

## 目标
- 安装 **kitty**，设为默认终端（`x-terminal-emulator` → kitty），移除默认终端（如 xterm）。
- **字号按设备**（`stages/S8-terminal/apply.sh` 判定，可用 `KITTY_FONT_SIZE` 覆盖）：
  - 默认（其它）：`font_size 12.0`；AMD Ryzen 7 7840：`font_size 14.0`。
- 主题：`configs/kitty/`（`kitty.conf` 中 `include ./theme.conf`，`theme.conf → other-themes/Nord.conf`）。
- 快捷键（kitty_mod = Ctrl+Shift）：
  - `kitty_mod+0` → `change_font_size all 0`（重置字号）；
  - `kitty_mod+;` → `scroll_home`（滚到顶部）；
  - `kitty_mod+'` → `scroll_end`（滚到底部）。

## 步骤
1. 按 `distros/<distro>/packages.md` 装 `kitty`。
2. 运行 `stages/S8-terminal/apply.sh`（部署配置 + 按设备字号 + 默认终端 + i3 快捷键改用 kitty）。
3. QEMU 验证。

## 验证
方法见 `docs/verification.md`。S8 要点：`kitty --version`、`x-terminal-emulator` 指向 kitty、
`~/.config/kitty/kitty.conf` 正确（font_size 按设备判定、主题与三个 map 都在）。