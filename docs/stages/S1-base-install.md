# S1 基础系统安装（发行版专属）

目标：得到**最小、可 UEFI 启动**的系统：GPT + ESP(FAT32, 512MiB) + ext4 root + GRUB(UEFI) + 串口控制台。
本阶段是**唯一发行版相关**的阶段，对外入口统一为 `stages/S1-base-install/run.sh`。

## Debian
- `distros/debian/preseed.cfg`：GPT、`partman-auto/expert_recipe` 指定 ESP+ext4、
  `grub-installer/bootdev=/dev/vda`、`debian-installer/add-kernel-opts=console=ttyS0,115200n8`。
- `tools/make-iso.sh` 构建自动安装 ISO（官方 netboot 内核 + preseed）。
- `distros/debian/bootstrap.sh` 概述流程（下载 netboot → make-iso → `qemu/run-installer.sh`）。

## Arch
- `distros/arch/bootstrap.sh`：官方 archiso + `archinstall`（`archinstall.json.example`）。
- 或 `distros/arch/pacstrap-notes.md` 手动流程（GPT/ESP/ext4、pacstrap、grub-install --removable）。

## 两发行版共同要点
- GPT；ESP 512MiB；root 用剩余空间。
- UEFI bootloader 安装到目标盘 ESP，并生成**可移动回退路径** `EFI/BOOT/BOOTX64.EFI`。
- 内核 cmdline 增加 `console=ttyS0,115200n8`，便于无头验证。

## 验证
方法见 `docs/verification.md`。S1 要点：从整盘启动确认完整启动链
`OVMF → bootloader(GRUB) → kernel → initramfs → root fs → systemd → login`。