# S4 远程与 Shell

## 目标
- 安装并启用 `openssh-server`（Arch: `openssh` / `sshd`）。
- 部署 dotfiles：`configs/dotfiles/{vimrc,gitconfig.example,xprofile}`。

## 步骤
1. 按 `distros/<distro>/packages.md` 的“远程与 Shell”装包。
2. 运行 `stages/S4-remote-shell/apply.sh`（`TARGET_USER`；git 身份 `GIT_NAME`/`GIT_EMAIL` 运行期覆盖，
   模板内为占位符，不落仓库）。
3. QEMU 验证。

## 验证
方法见 `docs/verification.md`。S4 要点：`systemctl is-active ssh`、实际 SSH 登录（可用 hostfwd）、
dotfiles 已部署且 `git config --list` 正确。