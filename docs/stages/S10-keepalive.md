# S10 USB 根盘保活（可选附加）

## 目标
防止系统装在 USB 硬盘盒（RTL9210B 等桥接芯片）的盘上时，长时间无读写后
**固件级空闲休眠**在下次 IO 时唤醒失败 → SCSI 命令永久挂起 → 整机冻结。

## 背景
- 休眠发生在桥接/SSD 固件内部，USB 层面仍“在线”：内核**无任何错误日志**
  （USB autosuspend / LPM 均拦不住），盒子 LED 正常（空闲蓝灯），表象是系统突然无响应。
- 系统侧已豁免（sda 端口 `power/control=on`、内核 USB3 LPM 已禁用）仍会复现，
  只能靠“不让盘空闲”保活。

## 方案
systemd timer 每 3 分钟对根盘直读 1MB（`iflag=direct` 绕过页缓存，确保真实盘上 IO；
外层 `timeout 60` 防盘异常时无限阻塞）。部署件与参数见 `configs/keepalive/README.md`
（本阶段无新装包，仅用 coreutils 的 `dd`/`timeout`）。

## 步骤
1. （可选）确认根设备：`findmnt -n -o SOURCE /`，例 `/dev/sda2`。
2. 运行 `stages/S10-keepalive/apply.sh`：
   - 根设备默认自动探测；可用 `KEEP_ALIVE_DEVICE=/dev/sdX` 覆盖；
   - 部署 `keep-sda-awake.{service,timer}` 并开机自启。
3. QEMU 验证（`verify.sh`）。

## 验证
方法见 `docs/verification.md`。S10 要点：`keep-sda-awake.timer` enabled/active；
`journalctl -u keep-sda-awake.service` 无 timeout 报错（unit 无 failed）。