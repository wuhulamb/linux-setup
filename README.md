# linux-setup

跨发行版（Debian / Arch）的 **Linux 安装偏好记录**：分阶段安装，每阶段用
**QEMU + OVMF(UEFI)** 验证；重点记录**区别于默认安装的个人配置**
（网络、输入法、终端、字体、桌面等）。

## 快速开始（Debian 例）
```bash
# 1) 宿主机依赖
sudo apt install qemu-system-x86 ovmf xorriso mtools grub-efi-amd64-bin wget socat

# 2) 选发行版与目标盘
export DISTRO=debian TARGET=/dev/sdX TARGET_USER=<user>

# 3) 阶段一：基础系统
distros/debian/bootstrap.sh          # 准备介质（tools/）
TARGET=$TARGET qemu/run-installer.sh # QEMU 跑安装器
TARGET=$TARGET qemu/run-guest.sh     # OVMF 验证启动链

# 4) 后续阶段：先按 distros/<distro>/packages.md 装包，再
stages/S3-network/apply.sh           # 部署配置
# 并在 guest 内运行各阶段 verify.sh 验证
```

## 文档导航
- `docs/00-overview.md` 总览与目录结构；`docs/01-conventions.md` 约定（变量/隐私/脚本风格）
- `docs/02-stage-matrix.md` 阶段坐标（装包/配置）；`docs/verification.md` 验证方法与各阶段要点
- `docs/stages/Sx.md` 各阶段唯一详细文档
- `distros/<distro>/packages.md` 各阶段装包清单（**不做包名映射**）
- `configs/*/README.md` 各配置模块的内容与来源（个人偏好；字体/rime 等**不入库**，仅记录来源）

## 入库红线
- **不含隐私**：口令/密钥/学号/邮箱一律占位符，仅运行期经环境变量传入；
  `secrets/` 只放说明，真实文件被 `.gitignore` 忽略。
- 验证日志/截图写入 `artifacts/`（gitignore），关键结论（脱敏）记入对应阶段文档。