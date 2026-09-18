# S0 准备（Prep）

本阶段不安装任何东西，只确定**约定**与**验证脚手架**。

## 约定
- **目标盘**：由 `TARGET` 指定（如 `/dev/sdc`）。所有阶段只操作它。
- **发行版**：由 `DISTRO` 指定（`debian` / `arch`）。
- **普通用户**：由 `TARGET_USER` 指定；口令通过环境变量在运行期传入，**不写入仓库**。
- **禁用词**：仓库内不出现任何真实密码、密钥、学号、邮箱等（用占位符）。

## 依赖工具（宿主机）
`qemu-system-x86 ovmf xorriso mtools grub-efi-amd64-bin wget socat`
（Debian: `apt install ...`；Arch: `pacman -S qemu-full edk2-ovmf xorriso mtools grub wget socat`）

## QEMU 验证脚手架
见 `qemu/`：`run-installer.sh` / `run-guest.sh` / `guest-exec.sh` / `screenshot.sh`。
每阶段验证产物（串口日志、截图）写入 `artifacts/`，**不纳入 git**。

## 产出
- 能安全启动 QEMU+OVMF 并连上 guest 串口的脚手架。
