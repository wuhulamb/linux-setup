# 验证（QEMU + OVMF UEFI）

每阶段结束后，用 QEMU 从**整个目标盘**启动，验证该阶段成果；产物写入 `artifacts/`。

## 通用启动（见 qemu/run-guest.sh）
```bash
TARGET=/dev/sdX qemu/run-guest.sh
```
- 固件：OVMF 4M（`OVMF_CODE_4M.fd` + 复制的 `OVMF_VARS_4M.fd`）。
- 串口：unix socket（`artifacts/guest.sock`）；图形阶段用 `-vnc` + `screenshot.sh`。

## 各阶段验证要点
- **S1**：完整启动链 `OVMF → bootloader → kernel → initramfs → root fs → systemd → login`。
- **S2**：普通用户登录、sudo、hostname、`systemctl --failed`。
- **S3**：`ip -4`、`ip r`、`/etc/resolv.conf`、`getent hosts`、`nmcli dev status`；包管理器可用。
- **S3‑proxy**：`systemctl is-enabled/is-active shadowsocks-local`；`ss -lntp | grep 1080`；`curl -x socks5h://127.0.0.1:1080 ...` 连通。
- **S4**：`systemctl is-active ssh`、SSH 实际登录、dotfiles 生效。
- **S5**：`fc-match`；会话内 `xrdb -query | grep Xft.dpi`。
- **S6**：`lightdm`/`Xorg`/i3；`screendump` 截图确认 greeter；`greeter xft-dpi`；`i3 -C` 配置解析通过、`flameshot --version`、Print 绑定存在。
- **S6‑壁纸（可选）**：`feh --version`；`random-wallpaper.service` enabled、`/var/lib/wallpapers/current` 为有效 PNG；i3/greeter 配置含壁纸行。
- **S7**：`fcitx5` 运行；`~/.local/share/fcitx5/rime/build/` 生成；默认 rime、Shift 切中英。
- **S7‑vinput（可选）**：`vinput-daemon` 用户服务 active；日志含模型加载完成与 D-Bus `org.fcitx.Vinput`。
- **S8**：`kitty --version`、`x-terminal-emulator`；`font-size.conf` 按设备生成（非 7840→12.0，`KITTY_FONT_SIZE=14.0` 可验证覆盖）；kitty.conf 含三个 map。
- **S9**：`node -v`、`npm -v`、`pi --version`；`uv --version`；工具版本 `fdfind --version`/`rg --version`/`ffmpeg -version`/`firefox-esr --version`/`obs --version`。

## 证据留存
- `artifacts/*.log`：串口/命令输出；
- `artifacts/*.ppm`：截图（可转 png）；
- 关键结论（脱敏）记入对应阶段文档 `docs/stages/Sx.md` 的“验证结果”。
