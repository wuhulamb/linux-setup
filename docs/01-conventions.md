# 01 约定

## 环境变量
| 变量 | 含义 | 示例 |
|---|---|---|
| `DISTRO` | 发行版 | `debian` / `arch` |
| `TARGET` | 目标盘（整盘） | `/dev/sdc` |
| `TARGET_USER` | 普通用户名 | `<user>` |
| `NEW_USER`/`NEW_PASS` | S2 创建用户用（运行期） | 口令**不落仓库** |
| `ECNU_USERNAME`/`ECNU_PASSWORD` | 校园网凭据（运行期） | 不落仓库 |
| `WIFI_SSID` | 校园 Wi‑Fi SSID | 可写默认 |
| `GIT_NAME`/`GIT_EMAIL` | git 身份（运行期） | 不落仓库 |
| `XFT_DPI` | 覆盖 HiDPI 判定 | `240` / `135` |
| `GUEST_USER`/`GUEST_PASS` | QEMU 串口登录（运行期） | 不落仓库 |

## 目标盘安全
- 只操作 `TARGET`；容器/宿主机上的其它盘不碰。
- 清空/分区前先展示将执行的操作。

## 隐私
- 仓库内**禁止**出现真实密码/密钥/学号/邮箱；一律占位符（`<...>`）。
- `secrets/` 只放 `README.md`；真实文件被 `.gitignore` 忽略。

## 日志与产物
- 验证产物写 `artifacts/`（串口日志、截图、命令输出），**不进 git**。
- 需要长期保留的证据，请贴到阶段文档的“验证结果”里（脱敏后）。

## 脚本风格
- `lib/*.sh` 与各阶段 `apply.sh`/`verify.sh` 用 **POSIX sh**，尽量少依赖。
- 仅当两发行版都用 systemd 时才用 `systemctl`。
