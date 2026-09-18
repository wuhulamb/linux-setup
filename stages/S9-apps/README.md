# S9 应用 / 开发环境（可选，个人偏好）

## 目标（示例）
- **Node.js**（官方二进制 v24 LTS 到 `/usr/local`，保证满足 `pi` 的 node>=22.19 要求）。
- 全局安装 `@earendil-works/pi-coding-agent`（`npm i -g --ignore-scripts ...`）。
- 用户的 `~/.pi/agent/models.json`（模型配置，**API Key 用占位符，不落仓库**）。

## 步骤
1. 下载 Node 官方 tar.xz 到 `/usr/local`。
2. `npm install -g --ignore-scripts @earendil-works/pi-coding-agent`。
3. 运行 `apply.sh` 部署 `models.json` 模板（运行期填 API Key）。
4. QEMU 验证：`verify.sh`（`node -v`/`npm -v`/`pi --version`）。

## 说明
- 本阶段强发行版无关（都用 Node 官方二进制），但仍需要网络。
