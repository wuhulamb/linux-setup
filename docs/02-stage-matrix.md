# 02 阶段矩阵

各阶段的目录坐标与「装包 / 配置」来源；验证要点见 `docs/verification.md`。

| 阶段 | 目录 | 装包（见 packages.md） | 主要配置（configs/） |
|---|---|---|---|
| S0 | `stages/S0-prep` | 宿主机依赖 | — |
| S1 | `stages/S1-base-install` | 发行版专属 | — |
| S2 | `stages/S2-base-config` | 基础 | dotfiles(部分) |
| S3 | `stages/S3-network` | 网络 | `configs/network/`；`configs/proxy/`(可选子项) |
| S3‑代理（可选） | `stages/S3-network/apply-proxy.sh` | 网络代理 | `configs/proxy/` |
| S4 | `stages/S4-remote-shell` | 远程 | `configs/dotfiles/`(可选子项) |
| S5 | `stages/S5-fonts-dpi` | 字体 | `configs/fonts/` |
| S6 | `stages/S6-desktop-session` | 图形 | `configs/i3/`、`configs/wallpaper/`(可选) |
| S7 | `stages/S7-ime` | 输入法 | `configs/fcitx5/`、`configs/rime/` |
| S8 | `stages/S8-terminal` | 终端 | `configs/kitty/` |
| S9 | `stages/S9-apps` | 应用 | `configs/models.json.example` |
| S10 | `stages/S10-keepalive` | —（无装包） | `configs/keepalive/`(可选) |