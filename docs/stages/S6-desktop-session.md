# S6 图形与登录

装包：X11 + i3 + lightdm（见 `packages.md`）。
配置：`configs/i3/config`；lightdm 默认会话 i3、默认目标 graphical。
登录界面 DPI：greeter 以 `lightdm` 用户运行，**读不到用户 `~/.Xresources`**，
故用 greeter 的 `[greeter] xft-dpi=`，由 `greeter-dpi.service`（`Before=lightdm.service`）
在 lightdm 之前按机器写定。

验证：`verify.sh` + `qemu/screenshot.sh`（截图确认 greeter 与缩放）。
