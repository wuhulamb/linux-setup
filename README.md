# linux-setup

跨发行版（Debian / Arch）的 **Linux 安装偏好记录**：分阶段安装，每阶段用
**QEMU + OVMF(UEFI)** 验证；重点记录**区别于默认安装的个人配置**
（网络、输入法、终端、字体、桌面等）。安装思路与验证留痕见 `docs/`。

> 与 `debian-usb-install` 的关系：后者是“Debian 专用实例”，本仓库是“通用/偏好记录”。

## 快速开始
```bash
# 1) 宿主机依赖（Debian 例）
sudo apt install qemu-system-x86 ovmf xorriso mtools grub-efi-amd64-bin wget socat

# 2) 选发行版与目标盘
export DISTRO=debian TARGET=/dev/sdX TARGET_USER=<user>

# 3) 阶段一：基础系统（Debian 例）
distros/debian/bootstrap.sh          # 准备介质（tools/）
TARGET=$TARGET qemu/run-installer.sh # QEMU 跑安装器
TARGET=$TARGET qemu/run-guest.sh     # OVMF 验证启动链

# 4) 后续阶段：先按 distros/<distro>/packages.md 装包，再
stages/S3-network/apply.sh           # 部署配置
# 并在 guest 内运行各阶段 verify.sh 验证
```

## 目录
- `docs/` 文档（总览/约定/阶段矩阵/验证）
- `stages/` 阶段脚本（`apply.sh` 部署配置、`verify.sh` 验证）
- `configs/` 个人偏好（network/fcitx5/rime/kitty/i3/fonts/dotfiles）
- `lib/` 发行版无关库（detect/deploy/svc/log）
- `distros/` 发行版专属（基础安装 + 各阶段软件清单）
- `qemu/` 验证脚手架；`tools/` 镜像与介质构建；`secrets/` 私密说明

## 约定
- 脚本**不做包名映射**：要装什么，见 `distros/<distro>/packages.md` 与各阶段 README。
- 仓库**不含隐私**；口令/密钥等仅运行期经环境变量传入。
- 验证日志/截图写入 `artifacts/`（gitignore）。
