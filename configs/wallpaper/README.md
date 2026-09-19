# wallpaper/ —— 随机壁纸（部署件）

**源图片与裁剪工具不入库**：裁剪工具与 `src/` 图片在独立仓库
**https://github.com/wuhulamb/wallpaper-crop**（克隆后在其目录内裁剪，见下）。
本目录只存放「随机壁纸」的**部署件**与偏好记录：

- `random-wallpaper` —— 随机选图脚本（部署到 `/usr/local/bin/random-wallpaper`）。
- `random-wallpaper.service` —— systemd oneshot 单元（部署到
  `/etc/systemd/system/random-wallpaper.service`，`Before=display-manager`，
  `WantedBy=graphical.target`）。

## 按设备裁剪（在 wallpaper-crop 仓库内）

不同设备需要裁剪不同的 `dst/<尺寸>/`（判定同 `lib/detect.sh`）：

| 设备 | 尺寸 |
|---|---|
| 默认（其它） | `1920x1080` |
| AMD Ryzen 7 7840 笔记本 | `2880x1800` |

```bash
git clone https://github.com/wuhulamb/wallpaper-crop.git /tmp/wallpaper-crop
cd /tmp/wallpaper-crop
# 批量裁剪（若上游 process.sh 支持 SIZE/OUT 环境变量）：
SIZE=1920x1080 ./process.sh     # → dst/1920x1080/
SIZE=2880x1800 ./process.sh     # → dst/2880x1800/
# 若上游未支持，用 crop.sh 逐张按尺寸裁剪亦可：
# ./crop.sh 2880x1800 src/foo.jpg dst/2880x1800/foo.png
```

## 部署（guest）

1. 装 `feh`（i3 铺壁纸用；装包见 `distros/<distro>/packages.md`）。
2. 把 `dst/1920x1080/` 与 `dst/2880x1800/` 上传到
   `/home/xu/Pictures/wallpaper/dst/`（两部分都要，设备在运行期按 CPU 自动选尺寸）。
   - **属主要求**：`Pictures/wallpaper` 及其父目录必须属主为 `xu:xu`。
     若以 root 提前 `mkdir`/上传（或上传工具以 root 运行），目录会变成 `root:root`，
     桌面读图/选图会异常。纠正：`sudo chown -R xu:xu /home/xu/Pictures/wallpaper`；
     或直接跑下面的 `apply-wallpaper.sh`（已内置 chown 兕底）。
3. 运行部署：`TARGET_USER=xu sudo -E stages/S6-desktop-session/apply-wallpaper.sh`。

## 效果

`random-wallpaper` 在登录界面前选一张图放到 `/var/lib/wallpapers/current`；
i3 会话用 `feh --bg-fill` 铺设，`Ctrl+Mod1+l` 用 `i3lock -i` 锁屏，
greeter 背景指向同一文件。