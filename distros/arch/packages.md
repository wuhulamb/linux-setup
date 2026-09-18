# Arch：各阶段需要安装的软件包

> 不做包名映射，仅在此列出。阶段脚本只部署配置 + 启用 systemd 服务。

## 基础（S2）
```bash
sudo pacman -S --needed base-devel ca-certificates curl wget less vim git bash-completion
```

## 网络（S3）
```bash
sudo pacman -S --needed networkmanager wpa_supplicant iw rfkill wireless-regdb python
sudo systemctl enable --now NetworkManager
```

## 远程与 Shell（S4）
```bash
sudo pacman -S --needed openssh
sudo systemctl enable --now sshd
```

## 字体与 HiDPI（S5）
```bash
sudo pacman -S --needed fontconfig
# 可选 CJK：noto-fonts-cjk
```

## 图形与登录（S6）
```bash
sudo pacman -S --needed xorg-server xorg-xinit xorg-xrandr xorg-xrdb xorg-xsetroot \
  i3-wm i3status i3lock dmenu \
  lightdm lightdm-gtk-greeter accountsservice polkit
sudo systemctl enable lightdm
```

## 输入法（S7）
```bash
sudo pacman -S --needed fcitx5 fcitx5-rime fcitx5-configtool \
  fcitx5-gtk fcitx5-qt
```

## 终端（S8）
```bash
sudo pacman -S --needed kitty
```

## 应用/开发（S9，可选）
```bash
# Node.js 官方二进制到 /usr/local，再 npm i -g pi；见 docs/stages/S9-apps.md
# 或 pacman -S nodejs npm
```
