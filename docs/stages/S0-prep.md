# S0 准备

本阶段**不安装任何东西**，只确定「约定」与「QEMU 验证脚手架」。
（`stages/S0-prep/` 无脚本；脚手架实际位于 `qemu/`、`tools/` 与 `lib/`。）

## 约定
见 `docs/01-conventions.md`；关键变量：
- `TARGET`：目标盘（整盘），所有阶段只操作它；
- `DISTRO`：发行版（`debian` / `arch`）；
- `TARGET_USER`：普通用户名；口令仅运行期经环境变量传入，不写入仓库。

## 宿主机依赖
```
qemu-system-x86 ovmf xorriso mtools grub-efi-amd64-bin wget socat
```
- Debian：`apt install ...`；Arch：`pacman -S qemu-full edk2-ovmf xorriso mtools grub wget socat`

## QEMU 验证脚手架（qemu/）
- `run-installer.sh`：从安装介质启动（S1 用）；
- `run-guest.sh`：OVMF 从整盘启动（各阶段验证用），串口 unix socket；
- `guest-exec.sh`：经串口登录 guest 执行命令，产物写 `artifacts/`；
- `screenshot.sh`：经 QEMU monitor 截图（图形阶段取证）。

验证产物（串口日志、截图）写入 `artifacts/`，不纳入 git。

## 验证
方法见 `docs/verification.md`。S0 要点：能启动 `qemu/run-installer.sh` 并连上 guest 串口。