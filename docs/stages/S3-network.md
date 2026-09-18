# S3 网络

装包：见 `packages.md` 的“网络”。
配置：`configs/network/`（NetworkManager 有线 DHCP + Wi‑Fi WPA‑EAP + ECNU 认证）。
流程：`stages/S3-network/apply.sh`。
验证：`verify.sh`（IP/路由/DNS/联网/`nmcli`）。

设计要点：
- 有线 `route-metric=100`、无线 `600`，避免默认路由冲突；
- 缺任一接口都不报错、不阻塞启动；
- DNS 由 NetworkManager 管理；
- ECNU 有线认证仅在“外网不可达”时尝试（`ecnu_net_login.py` + systemd）。
