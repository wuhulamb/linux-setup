# media-dpms/ —— 媒体播放时防自动熄屏（部署件）

**背景**：桌面上播放视频时若长时间不操作，DPMS 会在默认超时（600s）后自动关闭屏幕，
打断观看。本模块让**任一 MPRIS 播放器处于 Playing 时禁用 DPMS**，全部暂停/停止/退出后恢复。

## 机制（media-dpms）
- `playerctl -l` 列出所有 MPRIS 播放器，逐一查 `status`；任一为 `Playing` →
  `xset s off` + `xset -dpms`（关闭屏保与 DPMS）；
- 否则恢复：`xset s on` + `xset +dpms` + `xset dpms 600 600 600`；
- 初始判定一次后，`playerctl -a --follow status` 监听播放状态变化（无播放器时也常驻监听）；
- 依赖 X11 的 `xset`（本项目 i3 会话适用）。service 内固定 `DISPLAY=:0` 与
  `XAUTHORITY=%h/.Xauthority`，保证会话内可读到授权。

## 部署件
- `media-dpms` —— 脚本，部署到 `~/bin/media-dpms`（**用户空间**）。
- `media-dpms.service` —— 用户级 systemd 单元，`WantedBy=default.target`
  随用户默认目标启动，`Restart=on-failure`。标准位置
  `~/.config/systemd/user/media-dpms.service`（本机即此路径）；若该目录被 root
  提前创建（属主 `root:root`，本机实际遇到过），先
  `sudo chown -R <user>:<user> ~/.config/systemd` 再部署，或改用等效的
  `~/.local/share/systemd/user/`（systemd 默认搜索）。

## 部署（guest 内，**以普通用户运行**，勿用 sudo / root）
```bash
# 前提：playerctl 已装（见 distros/<distro>/packages.md S6 节）；X11 会话
install -d -m755 ~/bin
install -m755 configs/media-dpms/media-dpms ~/bin/media-dpms
install -d -m755 ~/.config/systemd/user
install -m644 configs/media-dpms/media-dpms.service ~/.config/systemd/user/media-dpms.service
systemctl --user daemon-reload
systemctl --user enable --now media-dpms.service
```

## 验证（图形会话内）
```bash
systemctl --user is-active media-dpms      # active (running)
xset q | grep -A3 DPMS                     # 无播放：DPMS is Enabled（600/600/600）
# 播放视频（任一会话内 MPRIS 播放器）时：DPMS is Disabled；暂停/退出后自动恢复 600
```

## 参数
| 项 | 值 | 说明 |
|---|---|---|
| `DPMS_TIME` | 600 | 无播放时恢复的熄屏超时（秒），改脚本顶部变量 |
| 触发条件 | 任一 MPRIS 播放器 Playing | `playerctl -p <player> status` 判定 |

## 验证结果（Debian 13 @ 本机）
用户服务 `media-dpms.service` `active (running)`；VLC（`--loop --intf dummy`）播放时
`xset q` 显示 `DPMS is Disabled`，退出播放器后恢复 `DPMS is Enabled`（600/600/600）。