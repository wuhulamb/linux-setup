# S5 字体与 HiDPI

## 装包
`fontconfig`（可选 CJK 字体）。见 `distros/<distro>/packages.md` 的“字体与 HiDPI”。

## 字体来源
字体文件**不入库**，来自个人仓库：
**https://github.com/wuhulamb/fonts**
`stages/S5-fonts-dpi/apply.sh` 默认会 `git clone` 到用户的 `~/.fonts`；
也可预先放到 `configs/fonts/files/`（该目录被 `.gitignore` 忽略）。

`configs/fonts/fonts.conf` 是**本仓库记录的 fontconfig 偏好**（sans-serif/monospace
首选与回退），由 `apply.sh` 部署到 `~/.config/fontconfig/fonts.conf`。

## HiDPI（按机器设置 Xft.dpi）
`apply.sh` 安装 `/usr/local/bin/apply-xft-dpi`，并挂到
`/etc/X11/Xsession.d/25apply-xft-dpi`（**早于** `30x11-common_xresources` 与 i3），
在 X 会话初始化阶段写入 `~/.Xresources` 并 `xrdb`。

- 判定：AMD Ryzen 7 7840 → **240**，其它 → **135**（可用 `XFT_DPI` 或 `/etc/xft-dpi` 覆盖）。
- 登录界面（greeter）的 DPI 不同处理，见 S6（greeter 读不到用户 `~/.Xresources`）。

## 验证
`verify.sh`：`fc-match` 命中字体、`~/.Xresources` 内容正确；会话内 `xrdb -query | grep Xft.dpi`。
