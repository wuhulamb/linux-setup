# keepalive/ —— USB 根盘保活（可选附加）

**背景**：系统装在 USB 硬盘盒（如 Realtek RTL9210B 桥接）的盘上时，
长时间无读写后，桥接芯片/SSD 的**固件级空闲休眠**可能在下次 IO 时
唤醒失败 → SCSI 命令永久挂起 → 整机冻结（内核层无任何 USB 报错）。
系统侧 USB autosuspend（`power/control=on`）与 USB3 LPM 均拦不住这类休眠，
只能靠"不让盘空闲"解决。

## 部署件
- `keep-sda-awake.service` —— oneshot 单元**模板**（`@ROOT_DEV@` 由
  `stages/S10-keepalive/apply.sh` 替换为实际根设备），部署到
  `/etc/systemd/system/keep-sda-awake.service`。
- `keep-sda-awake.timer` —— 每 3 分钟触发一次，开机自启，部署到
  `/etc/systemd/system/keep-sda-awake.timer`。

## 参数（默认）
| 项 | 值 | 说明 |
|---|---|---|
| 间隔 | 每 3 分钟 | 低于常见盘盒空闲休眠定时（多为 10~30 分钟），留足余量 |
| 每次读取 | 1MB 直读 | `iflag=direct` 绕过页缓存，确保真实盘上 IO |
| 超时保护 | `timeout 60` | 盘若异常卡死，60s 后放弃并留日志，不无限阻塞 |
| 无新依赖 | — | 仅用 coreutils 的 `dd` / `timeout`，无需装包 |

## 部署与操作（guest 内）

### 确认根设备
```bash
findmnt -n -o SOURCE /     # 例: /dev/sda2 → 本模块保活的就是它
```

### 部署（随 S10）
```bash
sudo -E stages/S10-keepalive/apply.sh
# 若根设备探测不对，或想指定其它设备：
KEEP_ALIVE_DEVICE=/dev/sdX sudo -E stages/S10-keepalive/apply.sh
```
部署后检查：
```bash
systemctl is-enabled keep-sda-awake.timer   # enabled
systemctl is-active  keep-sda-awake.timer
journalctl -u keep-sda-awake.service        # 每次执行成功即可；出现 timeout 报错=盘异常
```

### 临时停用 / 卸载
```bash
systemctl disable --now keep-sda-awake.timer
rm -f /etc/systemd/system/keep-sda-awake.{service,timer}
systemctl daemon-reload
```

### 调整间隔
编辑 `/etc/systemd/system/keep-sda-awake.timer` 的 `OnUnitActiveSec`
（如 `10min`），再 `systemctl daemon-reload`。