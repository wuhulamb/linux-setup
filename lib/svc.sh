# lib/svc.sh — systemd 服务封装（Debian 与 Arch 都用 systemd）
svc_enable()     { systemctl enable "$1"        2>/dev/null || true; }
svc_disable()    { systemctl disable "$1"       2>/dev/null || true; }
svc_start()      { systemctl start  "$1"        2>/dev/null || true; }
svc_enable_now() { systemctl enable --now "$1"  2>/dev/null || true; }
svc_restart()    { systemctl restart "$1"       2>/dev/null || true; }
svc_active()     { systemctl is-active --quiet "$1"; }
