# S5 字体与 HiDPI

## 字体来源与安装
字体文件**不入库**：来源、安装方式与 `FONTS_REPO` 见 **`configs/fonts/README.md`**
（个人仓库 https://github.com/wuhulamb/fonts ；也可预先放到 `configs/fonts/files/`，该目录被 ignore）。

`configs/fonts/fonts.conf` 是本仓库记录的 fontconfig 偏好（sans-serif/monospace 首选与回退），
由 `apply.sh` 部署到 `~/.config/fontconfig/fonts.conf`。

## HiDPI（按机器设置 Xft.dpi）
`apply.sh` 安装 `/usr/local/bin/apply-xft-dpi` 并挂到
`/etc/X11/Xsession.d/25apply-xft-dpi`（**早于** `30x11-common_xresources` 与 i3），
在 X 会话初始化阶段写入 `~/.Xresources` 并 `xrdb`。

- 判定：AMD Ryzen 7 7840 → **240**，其它 → **135**（可用 `XFT_DPI` 或 `/etc/xft-dpi` 覆盖）。
- 登录界面（greeter）的 DPI 是另一套机制，见 S6（greeter 读不到用户 `~/.Xresources`）。

> 注：Xft.dpi 钩子写入 `/etc/X11/Xsession.d/`（S5 只放置文件），待 S6 安装 X11 后于每次会话
> 初始化生效；无图形（headless）场景此部分不适用，可仅做字体部分。

## 步骤
1. 按 `distros/<distro>/packages.md` 装 `fontconfig`（必要时装 CJK 字体）。
2. 字体到位（`configs/fonts/files/` 或 `FONTS_REPO`），运行 `apply.sh`。
3. QEMU 验证。

## 验证
方法见 `docs/verification.md`。S5 要点：`fc-match "Microsoft YaHei"` 命中；会话内
`xrdb -query | grep Xft.dpi` 为按机器判定值。