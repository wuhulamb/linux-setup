# rime/

**本目录不保存 rime 配置**。rime 配置来自个人仓库：
**https://github.com/wongdean/rime-settings**

安装方式（`stages/S7-ime/apply.sh` 已实现）：
```bash
git clone --depth 1 https://github.com/wongdean/rime-settings.git /tmp/rime-settings
mkdir -p ~/.local/share/fcitx5/rime
cp -a /tmp/rime-settings/. ~/.local/share/fcitx5/rime/
rm -rf /tmp/rime-settings
```

在本仓库层面，**只记录个人对上游配置的调整**（由 `stages/S7-ime/apply-rime-tweaks.py`
在安装时自动应用，见 `docs/stages/S7-ime.md`）：

1. `default.custom.yaml` 的 `schema_list` **只保留 `luna_pinyin`（全拼）**；
2. `luna_pinyin.custom.yaml` 启用 `"switches/@0/reset": 1`
   —— 第一个开关 `ascii_mode` 初始为 **英文**；
3. 删除 rime 仓库自带的 `font/`（其中的 HanaMin 字体改用个人字体仓库）。
