# S9 应用/开发（可选）

- Node.js：`stages/S9-apps/install-node.sh`（官方二进制 v24 LTS → `/usr/local`）。
- pi：`npm install -g --ignore-scripts @earendil-works/pi-coding-agent`。
- 模型配置：`configs/models.json.example`（占位符）→ `~/.pi/agent/models.json`（运行期填 Key）。

验证：`verify.sh`（`node -v`/`npm -v`/`pi --version`）。
