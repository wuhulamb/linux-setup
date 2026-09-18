# S2 基础配置（Base config）

## 目标
- 创建普通用户并加入管理员组（Debian `sudo` / Arch `wheel`）。
- 设置 hostname / locale / 时区；启用串口控制台。
- 安装基础工具（见 `distros/<distro>/packages.md` 的“基础”一节）。

## 步骤
1. 按 `distros/debian/packages.md` 或 `distros/arch/packages.md` 装包。
2. 运行 `apply.sh`（需 `NEW_USER`、`NEW_PASS` 环境变量，口令不落盘到仓库）。
3. QEMU 验证：`verify.sh`。

## QEMU 验证
- 普通用户可登录、`sudo`（或 `su`）可用、`hostname` 正确、串口/系统状态正常。
