# Debian：各阶段需要安装的软件包

> 说明：本项目**不做包名映射**，只在此文档列出各发行版要装的软件。
> 阶段脚本只负责“部署配置 + 启用 systemd 服务”。安装包请按下面清单用 `apt` 执行。

## 基础（S2）
```bash
sudo apt update
sudo apt install -y --no-install-recommends \
  sudo ca-certificates curl wget less vim git bash-completion
```

## 网络（S3）
```bash
sudo apt install -y --no-install-recommends \
  network-manager wpasupplicant iw rfkill wireless-regdb python3
```

## 远程与 Shell（S4）
```bash
sudo apt install -y --no-install-recommends openssh-server
```

## 字体与 HiDPI（S5）
```bash
sudo apt install -y --no-install-recommends fontconfig
# 如需 CJK 回退字体：fonts-noto-cjk
```

## 图形与登录（S6）
```bash
sudo apt install -y --no-install-recommends \
  xorg xinit xserver-xorg x11-xserver-utils x11-utils dbus-x11 \
  i3 i3status i3lock suckless-tools \
  lightdm lightdm-gtk-greeter accountsservice polkitd
```

## 输入法（S7）
```bash
sudo apt install -y --no-install-recommends \
  fcitx5 fcitx5-rime fcitx5-config-qt \
  fcitx5-frontend-gtk3 fcitx5-frontend-gtk4 fcitx5-frontend-qt5 fcitx5-frontend-qt6 \
  librime1t64 librime-data librime-bin \
  librime-plugin-lua librime-plugin-octagram
# fcitx5 皮肤示例（Material-Color）见 configs 说明
```

## 终端（S8）
```bash
sudo apt install -y --no-install-recommends kitty
# 设为默认终端并移除默认终端：
sudo update-alternatives --set x-terminal-emulator /usr/bin/kitty
sudo apt purge -y xterm
```

## 应用/开发（S9，可选）
```bash
# Node.js 官方二进制（v24 LTS）到 /usr/local；再用 npm 全局装 pi
# 见 docs/stages/S9-apps.md。或 apt install nodejs npm（版本可能偏低）。
```
