# dotfiles/ —— shell/git 偏好（S4 可选子项）

- `vimrc`、`gitconfig.example` —— 个人偏好，由 `stages/S4-remote-shell/apply-dotfiles.sh` 部署
  （`~/.vimrc`、`~/.gitconfig`，git 身份运行期经 `GIT_NAME`/`GIT_EMAIL` 覆盖）。
- `xprofile` **已废止**：其中的输入法环境变量统一由 S6 写入 `/etc/environment`
  （避免同一目的两处实现，见 `docs/stages/S6-desktop-session.md`）。