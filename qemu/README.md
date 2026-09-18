# QEMU 验证脚手架

每个阶段结束后，都用 **QEMU + OVMF(UEFI)** 从**整个目标盘**启动来验证该阶段成果。
所有日志/截图输出到仓库外的 `artifacts/`（已在 `.gitignore` 中忽略，不进 git）。

约定：
- 目标盘：`$TARGET`（如 `/dev/sdc`）。**只操作它**。
- 固件：OVMF 4M（`/usr/share/OVMF/OVMF_CODE_4M.fd` + 每次复制一份 `OVMF_VARS_4M.fd`）。
- 串口：unix socket → 由 `guest-exec.sh` 驱动，日志落到 `artifacts/`。
