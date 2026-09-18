# 02 阶段矩阵

| 阶段 | 目录 | 装包（见 packages.md） | 主要配置（configs/） | QEMU 验证要点 |
|---|---|---|---|---|
| S0 | `stages/S0-prep` | 宿主机依赖 | — | 能启动 QEMU+OVMF、连串口 |
| S1 | `stages/S1-base-install` | 发行版专属 | — | UEFI→bootloader→kernel→initramfs→root→systemd→login |
| S2 | `stages/S2-base-config` | 基础 | dotfiles(部分) | 用户登录、sudo、主机名、无 failed unit |
| S3 | `stages/S3-network` | 网络 | `configs/network/` | DHCP/默认路由/DNS/联网；Wi‑Fi 配置加载 |
| S4 | `stages/S4-remote-shell` | 远程 | `configs/dotfiles/` | ssh active、实际登录、git 配置 |
| S5 | `stages/S5-fonts-dpi` | 字体 | `configs/fonts/` | `fc-match`、`xrdb -query` 的 Xft.dpi |
| S6 | `stages/S6-desktop-session` | 图形 | `configs/i3/` | lightdm/Xorg/i3；greeter 截图；greeter xft-dpi |
| S7 | `stages/S7-ime` | 输入法 | `configs/fcitx5/`,`configs/rime/` | fcitx5 运行、rime build、默认 rime/Shift 切中英 |
| S8 | `stages/S8-terminal` | 终端 | `configs/kitty/` | kitty 版本、默认终端、font_size/主题 |
| S9 | `stages/S9-apps` | 应用 | 模型模板 | node/npm/pi 版本 |
