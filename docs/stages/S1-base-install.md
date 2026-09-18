# S1 基础系统安装（发行版专属）

目标：GPT + ESP(FAT32, 512MiB) + ext4 root + UEFI bootloader(GRUB) + `console=ttyS0`。

## Debian
- `distros/debian/preseed.cfg`：GPT、`partman-auto/expert_recipe` 指定 ESP+ext4、
  `grub-installer/bootdev=/dev/vda`、`debian-installer/add-kernel-opts=console=ttyS0,115200n8`。
- `tools/make-iso.sh` 构建自动安装 ISO（netboot 内核 + preseed）。
- `distros/debian/bootstrap.sh` 概述流程。

## Arch
- `distros/arch/bootstrap.sh`：用 archiso + `archinstall`（`archinstall.json.example`）。
- 或 `distros/arch/pacstrap-notes.md` 手动流程（GPT/ESP/ext4、pacstrap、grub-install --removable）。

## QEMU 验证
`TARGET=/dev/sdX qemu/run-guest.sh`；确认 `OVMF → GRUB → kernel → initramfs → root → systemd → login`。
