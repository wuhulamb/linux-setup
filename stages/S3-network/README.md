# S3 网络（Network / DHCP / Wi-Fi / 校园网认证）

目标：无论“只有有线 / 只有 Wi-Fi / 两者都有 / 都没有”，系统都能正常启动并尽可能联网。

## 设计
- 使用 **NetworkManager**：
  - 有线：`type=ethernet`（不绑定接口名）、DHCP、`route-metric=100`。
  - 无线：`type=wifi`、WPA-EAP/PEAP/MSCHAPv2、`route-metric=600`（备用）。
  - 两者同时存在时靠 metric 避免默认路由冲突；缺任一接口都不报错。
- DNS 由 NetworkManager 写 `/etc/resolv.conf`。
- 校园网有线认证：`configs/network/ecnu_net_login.py` + systemd 服务（仅在外网不可达时尝试，不阻塞启动）。
- 不硬编码接口名。

## 步骤
1. 按 `distros/<distro>/packages.md` 的“网络”一节装包。
2. 运行 `apply.sh`（需运行期提供 `ECNU_USERNAME`/`ECNU_PASSWORD`；Wi‑Fi SSID）。
3. QEMU 验证（通常只有虚拟以太网）：`verify.sh`。

## QEMU 验证
- 虚拟以太网 DHCP 拿到地址、默认路由、DNS 正常、`apt/pacman` 可用。
- 仅 Wi‑Fi / 双网卡无法在 QEMU 内真实验证，改为**校验配置合法性与加载**（`nmcli` 能看到 profile）。
