# S8 终端（kitty）

## 目标
- 安装 **kitty**，设为默认终端（`x-terminal-emulator` → kitty），移除默认终端（如 xterm）。
- **字号按设备（运行期）**：与 S5 `Xft.dpi` 同一套方案，不是部署时写死：
  每个 **X 会话初始化**时执行 `/usr/local/bin/apply-kitty-font-size`（挂在
  `/etc/X11/Xsession.d/26apply-kitty-font-size`，早于 i3），按当前机器 CPU 检测并
  重写 `~/.config/kitty/font-size.conf`（由 `kitty.conf` 以 `include` 引用）：
  - AMD Ryzen 7 7840 笔记本 → `14.0`；其它 → `12.0`；
  - 覆盖：`KITTY_FONT_SIZE` 环境变量或 `/etc/kitty-font-size` 文件（同 XFT_DPI 的约定）。
  - 因此同一份盘换到不同设备启动，字号会自动适配。
- 主题：`configs/kitty/`（`kitty.conf` 中 `include ./theme.conf`，`theme.conf → other-themes/Nord.conf`）。
- 快捷键（kitty_mod = Ctrl+Shift）：
  - `kitty_mod+0` → `change_font_size all 0`（重置字号）；
  - `kitty_mod+;` → `scroll_home`（滚到顶部）；
  - `kitty_mod+'` → `scroll_end`（滚到底部）。

## 步骤
1. 按 `distros/<distro>/packages.md` 装 `kitty`。
2. 运行 `stages/S8-terminal/apply.sh`（部署配置与初始 `font-size.conf`、安装
   `apply-kitty-font-size` 与 Xsession 钩子、默认终端、i3 快捷键改用 kitty）。
3. QEMU 验证。

## 验证
方法见 `docs/verification.md`。S8 要点：`kitty --version`、`x-terminal-emulator` 指向 kitty、
`~/.config/kitty/kitty.conf` 正确（含三个 map），`font-size.conf` 按设备生成
（本机非 7840 → 12.0，`KITTY_FONT_SIZE=14.0` 可验覆盖）。