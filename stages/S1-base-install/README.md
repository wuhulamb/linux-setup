# S1 基础系统安装（Base install，发行版专属）

目标：得到**最小、可 UEFI 启动**的系统：GPT + ESP(FAT32) + ext4 root + GRUB(UEFI) + 串口控制台。

## 发行版差异
- **Debian**：用官方 netboot 内核 + preseed 全自动安装。
  见 `distros/debian/{bootstrap.sh,preseed.cfg}`；用 `tools/make-iso.sh` 生成 ISO，`qemu/run-installer.sh` 安装。
- **Arch**：官方 archiso + `archinstall`（或 `pacstrap`）。
  见 `distros/arch/{bootstrap.sh,archinstall.json.example,pacstrap-notes.md}`。

> 本阶段是**唯一发行版相关**的阶段；对外入口统一为 `stages/S1-base-install/run.sh`。

## 要点（两发行版共同）
- GPT；ESP 512MiB；root 用 rest。
- UEFI bootloader 安装到目标盘 ESP，并生成**可移动回退路径** `EFI/BOOT/BOOTX64.EFI`。
- 内核 cmdline 增加 `console=ttyS0,115200n8`，便于无头验证。

## QEMU 验证（UEFI）
从整盘启动，确认完整启动链：
```
OVMF → bootloader(GRUB) → kernel → initramfs → root fs → systemd → login
```
命令：`TARGET=/dev/sdX qemu/run-guest.sh`，串口日志在 `artifacts/`。
