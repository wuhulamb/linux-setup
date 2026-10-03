# proxy/

Shadowsocks 本地 SOCKS5 代理的**偏好记录**（S3 可选子模块；阶段文档见
`docs/stages/S3-proxy.md`，部署脚本 `stages/S3-network/apply-proxy.sh`）。
**真实配置不入库**，仅运行期提供。

- `shadowsocks-libev.json.example` —— 配置模板（服务器/口令为 `<...>` 占位符）；
  真实配置放仓库根 `shadowsocks-config.json`（被 `.gitignore` 忽略）或经 `SS_*` 环境变量。
- `shadowsocks-local.service` —— 部署到 guest 的 systemd 单元模板
  （以 `shadowsocks` 系统用户运行 `ss-local`，监听 `127.0.0.1:1080`，开机自启）。
- `proxychains4.conf` —— proxychains 配置模板（`strict_chain` + `socks5 127.0.0.1 1080`），
  部署到 `/etc/proxychains4.conf`（**必须 `root:root 0644`**；普通用户 `cp` 会残留
  `user:user`，属主约定见 `docs/01-conventions.md`）；用法见阶段文档。