# S3 网络

目标：无论「只有有线 / 只有 Wi‑Fi / 两者都有 / 都没有」，系统都能正常启动并尽可能联网。

## 设计
- 使用 **NetworkManager**：
  - 有线：`type=ethernet`（不绑定接口名）、DHCP、`route-metric=100`；
  - 无线：`type=wifi`、WPA-EAP/PEAP/MSCHAPv2、`route-metric=600`（备用）；
  - 两者同时存在靠 metric 避免默认路由冲突；缺任一接口都不报错、不阻塞启动。
- DNS 由 NetworkManager 写 `/etc/resolv.conf`。
- 校园网有线认证：`configs/network/ecnu_net_login.py` + systemd 服务，**仅在外网不可达时尝试**。
  （环境特定 / 个性化：无需校园网的机器跳过即可，见「可选子模块」。）
- 不硬编码接口名。

## 配置（configs/network/）
- `wired-dhcp.nmconnection` → 有线 DHCP profile；
- `ECNU-1X.nmconnection.example` → 校园 Wi‑Fi（WPA-EAP），凭据运行期生成，权限 0600；
- `ecnu_net_login.py` → `/usr/local/bin/ecnu_net_login`（srun_portal 协议）；
- `ecnu-net-login.service` → systemd 服务；凭据在 `/etc/ecnu/ecnu.conf`（0600，不入库）。

## 步骤
1. 按 `distros/<distro>/packages.md` 的“网络”一节装包。
2. 运行 `stages/S3-network/apply.sh`（运行期提供 `ECNU_USERNAME`/`ECNU_PASSWORD`，可选 `WIFI_SSID`）。
3. QEMU 验证。

## 可选子模块
- **校园网 ECNU**（个性化、环境特定）：含以上校园网有线认证服务与 Wi‑Fi EAP profile；
  配置/凭据见 `configs/network/`；无需校园网的机器可整体跳过。
- **本地 SOCKS5 代理**（可选）：Shadowsocks + proxychains，独立脚本
  `apply-proxy.sh` / `verify-proxy.sh`，详见 `docs/stages/S3-proxy.md`。

## 验证
方法见 `docs/verification.md`。S3 要点：虚拟以太网 DHCP 拿到地址、默认路由、DNS 正常、包管理器可用；
仅 Wi‑Fi/双网卡无法在 QEMU 内真实验证，改为校验配置合法性与加载（`nmcli` 可见 profile）。