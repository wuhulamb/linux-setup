# S4 远程与 Shell（SSH + dotfiles）

## 目标
- 安装并启用 `openssh-server`（`sshd`/`ssh`）。
- 部署个人 shell/编辑器/git 配置：`~/.bashrc`(可选)、`~/.vimrc`、`~/.gitconfig`、`~/.xprofile`。

## 步骤
1. 按 `distros/<distro>/packages.md` 的“远程与 Shell”装包。
2. 运行 `apply.sh`（`TARGET_USER`；git 身份用占位符，运行期可覆盖）。
3. QEMU 验证：`verify.sh`。

## QEMU 验证
- `systemctl is-active ssh`、实际 SSH 登录（可用 hostfwd）。
- dotfiles 已部署、`git config --list` 正确。
