# S5 字体与 HiDPI（Fonts / Xft.dpi）

## 目标
- 安装并使用个人字体到 `~/.fonts`，部署 `fontconfig` 偏好（`configs/fonts/fonts.conf`）。
- **按机器**设置 `Xft.dpi`：AMD Ryzen 7 7840 笔记本 = 240，其它 = 135。
  - 用户会话：由 `configs/` 的脚本在 **X 会话初始化阶段**写入 `~/.Xresources` 并 `xrdb`。
  - 登录界面（greeter）：见 S6（greeter 是 lightdm 用户，读不到用户 `~/.Xresources`）。

## 步骤
1. 按 `distros/<distro>/packages.md` 的“字体与 HiDPI”装 `fontconfig`（必要时装 CJK 字体）。
2. 把字体文件放入 `configs/fonts/files/`（个人字体，自行放置），运行 `apply.sh`。
3. QEMU 验证：`verify.sh`（`fc-match`、`xrdb -query`）。

## QEMU 验证
- `fc-match "Microsoft YaHei"` 命中已装字体；
- 在会话里 `xrdb -query | grep Xft.dpi` 为按机器判定值。
