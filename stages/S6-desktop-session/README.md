# S6 图形与登录（X11 + i3 + lightdm）

## 目标
- 安装 X11 与 i3（含 i3status/i3lock/dmenu），部署 `configs/i3/config`。
- 安装 lightdm(+gtk greeter)，默认会话为 i3，默认目标 `graphical.target`。
- **登录界面的 DPI**：greeter 以 `lightdm` 用户运行，读不到用户 `~/.Xresources`，
  故用 greeter 自身的 `[greeter] xft-dpi=`（按机器生成，随开机生效）。

## 步骤
1. 按 `distros/<distro>/packages.md` 的“图形与登录”装包。
2. 运行 `apply.sh`（含 greeter DPI 服务与会话 Xft.dpi 挂钩）。
3. QEMU 验证：`verify.sh` + `qemu/screenshot.sh`。

## QEMU 验证
- `lightdm` active、`Xorg` 运行、i3 会话；
- 截图确认 greeter 渲染；
- 登录后 i3 启动、i3bar 正常。
