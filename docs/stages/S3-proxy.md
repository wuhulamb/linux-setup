# S3 网络代理（S3 可选子模块）

> 本模块是 `S3` 网络阶段的可选子项，脚本为 `stages/S3-network/apply-proxy.sh` /
> `verify-proxy.sh`（原独立阶段已并入 S3）。

## 目标
- 在 guest 内以 **客户端（ss-local）** 方式运行 `shadowsocks-libev`：监听
  `127.0.0.1:1080` 提供本地 SOCKS5 代理，systemd **开机自启**（`shadowsocks-local.service`）。
- **真实服务器/口令不入库**：仓库只保留占位符模板与部署脚本。

## 配置来源（不入库）
默认读取仓库根 `shadowsocks-config.json`（已被 `.gitignore` 忽略）；也可用 `SS_CONFIG`
指定，或用运行期环境变量 `SS_SERVER`/`SS_PORT`/`SS_PASSWORD`/`SS_METHOD` 生成。格式：

```json
{
    "server": "<SERVER_HOST>",
    "server_port": 8388,
    "local_address": "127.0.0.1",
    "local_port": 1080,
    "password": "<PASSWORD>",
    "timeout": 60,
    "method": "aes-256-gcm"
}
```

## 步骤
1. 按 `distros/<distro>/packages.md` 的“网络代理”一节装包（Debian `shadowsocks-libev proxychains4` /
   Arch `shadowsocks-libev proxychains-ng`）。
2. 放置真实配置（见上）。
3. 运行 `stages/S3-network/apply-proxy.sh`：
   - 创建系统用户 `shadowsocks`（不可登录）；
   - 部署 `/etc/shadowsocks-libev/config.json`（`root:shadowsocks 0640`）；
   - 部署 `configs/proxy/shadowsocks-local.service`，**禁用**包自带的
     `shadowsocks-libev.service`（服务端，避免误监听上游端口），启用并启动本地服务。
4. QEMU 验证。

## 设计要点
- 只跑 **ss-local 客户端**：上游服务器在配置里，本机只开本地 SOCKS5。
- 专用系统用户 + 0640 配置，口令不全世界可读；单元含 `NoNewPrivileges=true`。

## proxychains（命令行强制走代理）
- 配置：`configs/proxy/proxychains4.conf` → `/etc/proxychains4.conf`
  （`strict_chain` + `proxy_dns` + `socks5 127.0.0.1 1080`）。
- 用法：`proxychains4 -q curl -s https://api.ipify.org`（出口 IP 即代理服务器）。
- 仅对动态链接、非 setuid 的程序生效；ssh 建议用 `ProxyCommand`。

## 使用方法
```bash
curl -x socks5h://127.0.0.1:1080 https://www.google.com   # socks5h：DNS 也经代理
export ALL_PROXY=socks5h://127.0.0.1:1080                # 仅当前 shell
```

## 验证
方法见 `docs/verification.md` 的 S3‑代理小节；对应脚本 `verify-proxy.sh`。

## 验证结果（Debian 13 @ `/dev/sdc`）
`shadowsocks-local.service`：`enabled` + `active`，监听 `127.0.0.1:1080`；
经代理访问 `https://www.google.com/generate_204` 返回 `204`，出口 IP 为代理服务器（已脱敏）。