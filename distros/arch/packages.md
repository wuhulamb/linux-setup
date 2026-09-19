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

## 网络代理（S3-proxy，可选）
```bash
sudo pacman -S --needed shadowsocks-libev proxychains-ng
# proxychains4 配置见 configs/proxy/proxychains4.conf
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
  lightdm lightdm-gtk-greeter accountsservice polkit udisks2
sudo systemctl enable lightdm
# udisks2：提供 udisksctl/udisksd，桌面自动挂载 U 盘等可移动设备（/media/<user>/…）
# 随机壁纸（可选，configs/wallpaper/）：源图/裁剪见上游 wuhulamb/wallpaper-crop
sudo pacman -S --needed feh
# 截图（i3 的 Print 键 → flameshot gui）：
sudo pacman -S --needed flameshot
```

## 输入法（S7）
```bash
sudo pacman -S --needed fcitx5 fcitx5-rime fcitx5-configtool \
  fcitx5-gtk fcitx5-qt

# fcitx5-vinput 语音输入（可选，需从源码编译）：
# 依赖：cmake gcc make pkgconf git nlohmann-json libsystemd pipewire fcitx5
# 运行：TARGET_USER=<user> sudo -E stages/S7-ime/install-vinput.sh
```

## 终端（S8）
```bash
sudo pacman -S --needed kitty
```

## 应用/开发（S9，可选）
```bash
# Node.js 官方二进制到 /usr/local，再 npm i -g pi；见 docs/stages/S9-apps.md
# 或 pacman -S nodejs npm

# uv（Python 包/venv 管理器）：
sudo pacman -S --needed uv

# 常用工具与图形应用：
sudo pacman -S --needed fd ripgrep firefox ffmpeg obs-studio
```
