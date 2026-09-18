# fonts/

- `fonts.conf` —— 本仓库记录的 **fontconfig 偏好**（sans-serif/monospace 首选与回退）。
- **字体文件不入库**。字体来自个人仓库：
  **https://github.com/wuhulamb/fonts**
  安装方式（任选其一）：
  ```bash
  # 直接克隆到用户字体目录
  git clone --depth 1 https://github.com/wuhulamb/fonts.git /tmp/fonts
  mkdir -p ~/.fonts && cp -a /tmp/fonts/. ~/.fonts/ && rm -rf /tmp/fonts
  fc-cache -f
  ```
  或在运行 `stages/S5-fonts-dpi/apply.sh` 前：
  ```bash
  export FONTS_REPO=https://github.com/wuhulamb/fonts.git
  ```
  也可把字体文件放到 `configs/fonts/files/`（该目录被 `.gitignore` 忽略，不入库）。
