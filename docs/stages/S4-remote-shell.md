# S4 远程（SSH）

## 目标
- 安装并启用 `openssh-server`（Arch: `openssh` / `sshd`）。

## 可选子项：dotfiles（偏好）
`configs/dotfiles/{vimrc,gitconfig.example}` → 由独立脚本 `apply-dotfiles.sh` /
`verify-dotfiles.sh` 部署（git 身份 `GIT_NAME`/`GIT_EMAIL` 运行期覆盖，模板内为占位符，不落仓库）。

> `xprofile` 已废止：输入法环境变量统一由 S6 写入 `/etc/environment`，
> 避免同一目的两处实现（见 `docs/stages/S6-desktop-session.md`）。

## 步骤
1. 按 `distros/<distro>/packages.md` 的“远程与 Shell”装包。
2. 运行 `stages/S4-remote-shell/apply.sh`（启用 ssh）。
3. （可选）运行 `stages/S4-remote-shell/apply-dotfiles.sh`（`TARGET_USER`）。
4. QEMU 验证。

## 验证
方法见 `docs/verification.md`。S4 要点：`systemctl is-active ssh`、实际 SSH 登录（可用 hostfwd）；
可选子项 dotfiles：`~/.vimrc` / `~/.gitconfig` 就位且 `git config --list` 正确。