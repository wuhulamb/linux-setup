# S7 输入法（fcitx5 + rime）

## 装包
`fcitx5`、`fcitx5-rime`、configtool、GTK/Qt 前端。见 `distros/<distro>/packages.md`。

## rime 配置来源与个人调整
rime 配置**不入库**，来自个人仓库：
**https://github.com/wongdean/rime-settings**
`stages/S7-ime/apply.sh` 会 `git clone` 到 `~/.local/share/fcitx5/rime/`。

本仓库只记录（并由 `stages/S7-ime/apply-rime-tweaks.py` 自动应用）以下**个人调整**：

1. `default.custom.yaml`：`schema_list` **只保留 `luna_pinyin`（全拼）**；
2. `luna_pinyin.custom.yaml`：启用 `"switches/@0/reset": 1`
   —— 第一个开关 `ascii_mode` 初始为**英文**；
3. 去掉 rime 仓库自带的 `font/`（HanaMin），字体改用个人字体仓库（见 S5）。

## fcitx5 配置（`configs/fcitx5/`）
- `profile`：输入法组**只有 rime**（避免开机回退到 `keyboard-us`/en）；
- `config`：清空 `AltTriggerKeys`（fcitx5 默认 `Shift_L` 会抢走 Shift，
  导致 rime 收不到 Shift、无法中英切换）；
- `conf/classicui.conf`：主题（Material-Color 的 `theme-blue`）与字体；
- `conf/rime.conf`：单行预编辑。

### 最终效果
开机即 **rime**，初始为**英文**（ascii_mode=1），按 **Shift** 切换到**中文**。

## 验证
`verify.sh`：`~/.config/fcitx5/{profile,config}` 正确；`~/.local/share/fcitx5/rime/build/`
已生成；`fcitx5` 运行、无 failed unit。
