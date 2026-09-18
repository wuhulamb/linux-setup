# 00 总览

## 这是什么
一份**跨发行版（Debian / Arch）的 Linux 安装偏好记录**：按照阶段安装，用
**QEMU + OVMF(UEFI)** 对每个阶段做验证。重点记录**区别于默认安装的个人偏好**
（网络、输入法、终端、字体、桌面等），而不是各发行版安装器的基础步骤。

## 原则
1. **分阶段**：每个阶段有明确目标与可执行的验证，阶段之间尽量独立。
2. **发行版无关**：除第一阶段（基础系统安装）外，安装“逻辑”不应依赖发行版；
   - 具体要装哪些软件，**在文档里逐发行版写清楚**（见 `distros/<distro>/packages.md`
     与各阶段文档 `docs/stages/`），**不做包名映射**；
   - 脚本只做发行版无关的事：部署配置、启用 systemd 服务、检测硬件。
3. **配置与流程分离**：`configs/` 放个人配置文件，`stages/` 放流程脚本。
4. **验证留痕**：每阶段用 QEMU+UEFI 验证，详细日志/截图写入 `artifacts/`（不进 git）。
5. **不含隐私**：仓库中不出现任何密码、密钥、学号、邮箱等；用占位符，运行期经环境变量传入。

## 阶段一览
| 阶段 | 目标 | 文档 |
|---|---|---|
| S0 | 准备：约定 + QEMU 脚手架 | `docs/stages/S0-prep.md` |
| S1 | 基础系统安装（可启动，**发行版相关**） | `docs/stages/S1-base-install.md` |
| S2 | 基础配置（用户/sudo/主机名/工具） | `docs/stages/S2-base-config.md` |
| S3 | 网络（DHCP/Wi‑Fi/校园网认证/DNS） | `docs/stages/S3-network.md` |
| S3‑proxy | 网络代理（Shadowsocks 本地 SOCKS5 + proxychains，可选） | `docs/stages/S3-proxy.md` |
| S4 | 远程与 Shell（ssh + dotfiles） | `docs/stages/S4-remote-shell.md` |
| S5 | 字体与 HiDPI（Xft.dpi） | `docs/stages/S5-fonts-dpi.md` |
| S6 | 图形与登录（X11 + i3 + lightdm，含随机壁纸） | `docs/stages/S6-desktop-session.md` |
| S7 | 输入法（fcitx5 + rime，可选 vinput 语音） | `docs/stages/S7-ime.md` |
| S8 | 终端（kitty + 主题） | `docs/stages/S8-terminal.md` |
| S9 | 应用/开发（Node.js + pi + uv + 工具，可选） | `docs/stages/S9-apps.md` |

> 装包见 `distros/<distro>/packages.md`；验证要点见 `docs/verification.md`。

## 目录结构
```
docs/        文档（总览/约定/阶段矩阵/验证）
stages/      各阶段流程脚本（apply/verify）+ 该阶段说明
configs/     个人偏好（真正区别于默认安装的内容，含 proxy/wallpaper/）
lib/         发行版无关公共库（检测/部署/服务/日志）
distros/     发行版专属：基础安装 + 各阶段软件清单
qemu/        QEMU+OVMF 验证脚手架
tools/       获取镜像、构建自动安装介质
secrets/     私密信息说明（真实文件 gitignore）
artifacts/   验证产物（日志/截图，gitignore）
```

## 使用顺序
1. S0 准备：装宿主机依赖、确认 `TARGET`、`DISTRO`。
2. S1：按 `distros/<distro>/bootstrap.sh` 装最小系统；QEMU 验证启动链。
3. S2…S9：先按对应 `packages.md` 装包，再跑该阶段 `apply.sh`，最后 `verify.sh`（QEMU 内）。
