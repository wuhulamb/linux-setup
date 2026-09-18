# S2 基础配置

## 目标
- 创建普通用户并加入管理员组（Debian `sudo` / Arch `wheel`）。
- 设置 hostname / locale / 时区；启用串口控制台。
- 安装基础工具（见 `distros/<distro>/packages.md` 的“基础”一节）。

## 步骤
1. 按 `distros/<distro>/packages.md` 装基础工具。
2. 运行 `stages/S2-base-config/apply.sh`（需运行期环境变量 `NEW_USER`、`NEW_PASS`，口令不落仓库）。
3. QEMU 验证。

## 验证
方法见 `docs/verification.md`。S2 要点：普通用户可登录、sudo 可用、hostname 正确、无 failed unit。