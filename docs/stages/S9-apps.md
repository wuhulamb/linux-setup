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

## 验证
方法见 `docs/verification.md`。S9 要点：`node -v`/`npm -v`/`pi --version`/`uv --version` 及工具版本。