# Arch 手动安装要点（pacstrap）

```bash
# 在 archiso live 环境（UEFI 启动）
sgdisk -Z "$TARGET"
sgdisk -n1:0:+512M -t1:ef00 -c1:"EFI System Partition" "$TARGET"
sgdisk -n2:0:0     -t2:8300 "$TARGET"
mkfs.fat -F32 "${TARGET}1"
mkfs.ext4    "${TARGET}2"
mount "${TARGET}2" /mnt
mount --mkdir "${TARGET}1" /mnt/boot/efi
pacstrap -K /mnt base linux linux-firmware grub efibootmgr \
  networkmanager wpa_supplicant iw rfkill wireless-regdb sudo vim git \
  openssh fontconfig python
genfstab -U /mnt >> /mnt/etc/fstab
arch-chroot /mnt
# 之后：时区/locale/用户/GRUB 安装、串口 enable 等，见 docs/stages/S1-base-install.md
grub-install --target=x86_64-efi --efi-directory=/boot/efi --removable
grub-mkconfig -o /boot/grub/grub.cfg
```
