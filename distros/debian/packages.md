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

## 网络代理（S3-proxy，可选）
```bash
sudo apt install -y --no-install-recommends shadowsocks-libev proxychains4
# proxychains4 配置见 configs/proxy/proxychains4.conf（走本地 SOCKS5 127.0.0.1:1080）
# 用法：proxychains4 -q curl …
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
# 随机壁纸（可选，configs/wallpaper/）：feh 用于 i3 铺设壁纸；源图/裁剪见上游 wuhulamb/wallpaper-crop
sudo apt install -y --no-install-recommends feh
# 截图（i3 的 Print 键 → flameshot gui，见 configs/i3/config）
sudo apt install -y --no-install-recommends flameshot
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

### fcitx5-vinput 语音输入（可选）
```bash
# 构建依赖（fcitx5-vinput 需从源码编译）
sudo apt install -y --no-install-recommends \
  cmake g++ make pkgconf git wget \
  nlohmann-json3-dev libsystemd-dev libpipewire-0.3-dev \
  fcitx5-modules-dev python3
# 语音需要：
sudo apt install -y --no-install-recommends pipewire pipewire-audio wireplumber
# 然后运行：TARGET_USER=xu sudo -E stages/S7-ime/install-vinput.sh
# （自动下载 sherpa-onnx 共享库 + sense-voice int8 模型 ≈ 190MB，见 docs/stages/S7-ime.md）
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

# uv（Python 包/venv 管理器）；Debian 无官方 uv 包，用官方安装器装到 /usr/local/bin
curl -LsSf https://astral.sh/uv/install.sh | env UV_INSTALL_DIR=/usr/local/bin sh

# 常用工具与图形应用（本机部署记录）：
sudo apt install -y --no-install-recommends \
  fd-find ripgrep firefox-esr ffmpeg obs-studio
# 注：Debian trixie 无 rapid 版 firefox 包，官方是 firefox-esr；
# 需 Mozilla 官方 rapid 版请用其 apt 源或 tarball。
```
