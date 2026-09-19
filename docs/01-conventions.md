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
| `KITTY_FONT_SIZE` | 覆盖 kitty 字号判定（S8） | `14.0` / `12.0` |
| `GUEST_USER`/`GUEST_PASS` | QEMU 串口登录（运行期） | 不落仓库 |

## 目标盘安全
- 只操作 `TARGET`；容器/宿主机上的其它盘不碰。
- 清空/分区前先展示将执行的操作。

## 用户目录属主
- **原则**：凡以 root 部署到用户目录（`$H`）的目录/文件，最终属主必须是
  `TARGET_USER`，禁止残留 `root:root`（会导致该用户无法写入/应用读档异常）。
- 脚本侧保障：`install -d -o -g` / `deploy_file <owner>` / `chown -R` 兕底
  （重点：壁纸 `Pictures/wallpaper`、`.pi`、`.config/*`，见 S5/S6/S9）。
- 人工操作须知：**避免以 root 提前 `mkdir` 或上传文件到用户目录**（如壁纸
  `dst/` 上传、`.pi` 手工创建）；上传/创建用户目录内容时以普通用户执行，
  或事后修正属主。
- 自查与修正：
  ```bash
  # 列出用户目录下所有非用户所有的条目（root:root 等）
  find /home/<user> ! -user <user> 2>/dev/null | head
  # 修正（确认无刻意 root 属主后）：
  sudo chown -R <user>:<user> /home/<user>
  ```

## 隐私
- 仓库内**禁止**出现真实密码/密钥/学号/邮箱；一律占位符（`<...>`）。
- `secrets/` 只放 `README.md`；真实文件被 `.gitignore` 忽略。

## 日志与产物
- 验证产物写 `artifacts/`（串口日志、截图、命令输出），**不进 git**。
- 需要长期保留的证据，请贴到阶段文档的“验证结果”里（脱敏后）。

## 脚本风格
- `lib/*.sh` 与各阶段 `apply.sh`/`verify.sh` 用 **POSIX sh**，尽量少依赖。
- 仅当两发行版都用 systemd 时才用 `systemctl`。
- 例外：`stages/S1-base-install/run.sh` 与 `distros/*/bootstrap.sh` 用 **bash**（发行版安装流程需要）。
- 阶段脚本统一**可执行（0755）**，文档按 `sudo -E stages/<phase>/apply.sh` 直接调用。
