# S5 字体与 HiDPI

装包：`fontconfig`（可选 CJK 字体）。
配置：`configs/fonts/fonts.conf`，个人字体放入 `configs/fonts/files/`。
HiDPI：`stages/S5-fonts-dpi/apply.sh` 安装 `/usr/local/bin/apply-xft-dpi` 并挂到
`/etc/X11/Xsession.d/25apply-xft-dpi`（早于 `30x11-common_xresources` 与 i3）。
- 判定：AMD Ryzen 7 7840 → 240，其它 → 135（可用 `XFT_DPI`/`/etc/xft-dpi` 覆盖）。

验证：`verify.sh`（`fc-match`、`~/.Xresources`）。
