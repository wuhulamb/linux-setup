# S6 图形与登录

## 目标
- 安装 X11 与 i3（含 i3status/i3lock/dmenu），部署 `configs/i3/config`。
- 安装 lightdm(+gtk greeter)，默认会话为 i3，默认目标 `graphical.target`。
- 装 `udisks2`（提供 `udisksctl`/`udisksd`）：桌面自动挂载 U 盘等可移动设备到 `/media/<user>/…`。

## 登录界面 DPI
greeter 以 `lightdm` 用户运行，**读不到用户 `~/.Xresources`**，故用 greeter 自身的
`[greeter] xft-dpi=`，由 `greeter-dpi.service`（`Before=lightdm.service`）在 lightdm
之前按机器写定（判定同 `lib/detect.sh`）。用户会话的 Xft.dpi 见 S5。

## 步骤
1. 按 `distros/<distro>/packages.md` 的“图形与登录”装包。
2. 运行 `stages/S6-desktop-session/apply.sh`：
   - 部署 i3 配置、lightdm 默认会话（`user-session=i3`）+ `graphical.target`；
   - 安装 greeter DPI 服务并执行一次；
   - 写 `/etc/environment` 的输入法环境变量（`GTK_IM_MODULE=fcitx` 等，供 S7；**唯一来源**，
  S4 的 `xprofile` 已废止）。
3. QEMU 验证（`verify.sh` + `qemu/screenshot.sh` 截图确认 greeter 渲染）。

## 截图（i3 的 Print 键）
`configs/i3/config` 含 `bindsym Print exec flameshot gui`：按 `Print` 调起 flameshot 截图
（需装 `flameshot`，见 `distros/<distro>/packages.md`）。

## 随机壁纸（可选）
可选功能，全部细节（源图/裁剪工具上游 https://github.com/wuhulamb/wallpaper-crop、
按设备裁剪 `dst/<尺寸>/`、组件与部署）见 **`configs/wallpaper/README.md`**；
部署脚本：`stages/S6-desktop-session/apply-wallpaper.sh`；`feh` 装包见 `packages.md`。

## 验证
方法见 `docs/verification.md`。S6 要点：`lightdm` active、`Xorg` 运行、i3 会话；
墙纸可选功能的要点也在其中。