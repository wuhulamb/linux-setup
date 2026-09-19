# S9 应用 / 开发（可选）

## Node.js + pi
- Node.js：`stages/S9-apps/install-node.sh`（官方二进制 v24 LTS → `/usr/local`，满足 pi 的 node≥22.19）。
- pi：`npm install -g --ignore-scripts @earendil-works/pi-coding-agent`。
- 模型配置：`configs/models.json.example`（占位符）→ `~/.pi/agent/models.json`（运行期填 Key）。
- 步骤：下载 Node 官方 tar.xz → 全局装 pi → `apply.sh` 部署模型模板 → 验证。
- 说明：本阶段强发行版无关，但需要网络。

## uv（Python 包 / venv 管理器）
- 装到 `/usr/local/bin/uv`（Debian 无官方包，用官方安装器
  `curl -LsSf https://astral.sh/uv/install.sh | env UV_INSTALL_DIR=/usr/local/bin sh`；
  Arch：`pacman -S uv`），含 `uvx`。
- 常用：`uv init` / `uv add <pkg>` / `uv sync` / `uv run foo`。

## 常用工具与图形应用（本机部署记录）
```bash
# Debian
sudo apt install -y --no-install-recommends fd-find ripgrep firefox-esr ffmpeg obs-studio
# Arch: sudo pacman -S --needed fd ripgrep firefox ffmpeg obs-studio
```
- `fd-find` 二进制为 `fdfind`；`ripgrep` 为 `rg`。
- Debian trixie 官方只有 `firefox-esr`（Mozilla 官方 rapid 版需其 apt 源/tarball）。
- `obs-studio` 为录制/直播软件（需图形会话）。

## USB 根盘保活（可选附加）

**动机**：系统装在 USB 硬盘盒（RTL9210B 等桥接）的盘上时，长时间无读写后，
桥接/SSD 的**固件级空闲休眠**可能在下次 IO 时唤醒失败 → 整机冻结，且内核层
无任何 USB 错误日志（USB autosuspend / LPM 均拦不住，因其发生在固件内部）。

**方案**：systemd timer 每 3 分钟对根盘直读 1MB（`iflag=direct` 绕过页缓存，
保证真实盘上 IO，阻止空闲休眠；外层 `timeout 60` 防盘异常时无限阻塞）。
部署件与参数见 `configs/keepalive/README.md`（本机无新装包，仅用 `dd`/`timeout`）。

**部署**（随 S9 `apply.sh` 自动完成，需确认根设备）：
```bash
findmnt -n -o SOURCE /      # 确认根设备，例: /dev/sda2
TARGET_USER=<user> sudo -E stages/S9-apps/apply.sh
# 自动探测有误或想指定其它设备时:
# KEEP_ALIVE_DEVICE=/dev/sdX sudo -E stages/S9-apps/apply.sh
```

**验证与日常操作**：
```bash
systemctl is-enabled keep-sda-awake.timer   # 应为 enabled
systemctl is-active  keep-sda-awake.timer
journalctl -u keep-sda-awake.service        # 每次执行成功即可；timeout 报错=盘异常
# 临时停用: systemctl disable --now keep-sda-awake.timer
# 调整间隔: 编辑 timer 的 OnUnitActiveSec（如 10min）后 systemctl daemon-reload
```

## 验证
方法见 `docs/verification.md`。S9 要点：`node -v`/`npm -v`/`pi --version`/`uv --version` 及工具版本。