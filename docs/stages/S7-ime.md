# S7 输入法（fcitx5 + rime）

## 装包
`fcitx5`、`fcitx5-rime`、configtool、GTK/Qt 前端（见 `distros/<distro>/packages.md` 的“输入法”）。

## rime
- 配置**不入库**：来源、个人调整细则与安装方式全部见 **`configs/rime/README.md`**
  （上游 https://github.com/wongdean/rime-settings）。
- 个人调整由 `stages/S7-ime/apply-rime-tweaks.py` 在 `apply.sh` 时自动应用。

## fcitx5 配置（configs/fcitx5/）
- `profile`：输入法组**只有 rime**（避免回退到 `keyboard-us`/en）；
- `config`：清空 `AltTriggerKeys`（默认 `Shift_L` 会抢走 Shift 导致 rime 无法中英切换）；
- `conf/classicui.conf`：主题（Material-Color）与字体；
- `conf/rime.conf`：单行预编辑。

### 最终效果
开机即 **rime**，初始**英文**（ascii_mode=1），按 **Shift** 切换**中文**。

## 步骤
1. 按 `packages.md` 装包。
2. 运行 `stages/S7-ime/apply.sh`（fcitx5/rime 配置 + rime 仓库克隆 + 个人调整 + Xvfb 无头触发 rime 部署）。
3. QEMU 验证。

## fcitx5-vinput 语音输入（可选，本地离线 ASR）
来源：**https://github.com/wuhulamb/fcitx5-vinput**（精简版：按住触发键说话→松开上屏，
默认右 `Alt`）。「fcitx5 插件 + 独立守护进程 `vinput-daemon`」双进程，经会话 D-Bus
（`org.fcitx.Vinput`）通信；守护进程由用户级 systemd 服务常驻。

- 构建/安装：`TARGET_USER=<user> sudo -E stages/S7-ime/install-vinput.sh`
  （构建依赖见 `packages.md`；语音需 `pipewire` + `wireplumber`）。
- **与上游 README 的差异（实测 2026-09）**：PyPI sherpa-onnx 1.13.x wheel 不打包 C API
  头文件/共享库，`uv add sherpa-onnx` 会构建失败；改为官方共享库 release
  `sherpa-onnx-v1.13.7-linux-x64-shared.tar.bz2`（≈28MB）→ `/opt/sherpa-onnx`，
  模型用 **int8** 版（≈160MB，CPU 可跑；fp32 约 1GB）。
- 产物：`/usr/bin/vinput-daemon`、`/usr/lib/.../fcitx5/fcitx5-vinput.so`、
  `/usr/share/fcitx5/addon/vinput.conf`、`/usr/share/systemd/user/vinput-daemon.service`；
  模型 `/usr/local/share/fcitx5-vinput/sense-voice/`；用户配置 `~/.config/fcitx5-vinput/config.json`；
  开机自启：`loginctl enable-linger <user>` + 用户服务默认启用。
- 使用：图形会话中聚焦输入框 → 按住右 `Alt`（「录音中」）→ 说话 → 松开（上屏）。

### 验证结果（Debian 13 @ `/dev/sdc`）
`vinput-daemon` 用户服务 `active (running)`，sense-voice 模型加载完成，D-Bus 服务正常。
说明：QEMU 无麦克风，录音链路需在真机上验证。

## 验证
方法见 `docs/verification.md`。S7 要点：`fcitx5` 运行、`~/.local/share/fcitx5/rime/build/`
生成、默认 rime/Shift 切中英；vinput 可选点（`verify-vinput.sh`）也在其中。