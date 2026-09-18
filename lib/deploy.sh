# lib/deploy.sh — 幂等部署配置文件
# deploy_file <src> <dst> [mode] [owner]
deploy_file() {
    src="$1"; dst="$2"; mode="${3:-644}"; owner="${4:-}"
    [ -f "$src" ] || die "deploy_file: missing $src"
    install -D -m "$mode" "$src" "$dst"
    [ -n "$owner" ] && chown "$owner" "$dst" 2>/dev/null || true
}

# deploy_tree <srcdir> <dstdir> [owner]  —— 保留权限（含符号链接）
deploy_tree() {
    src="$1"; dst="$2"; owner="${3:-}"
    [ -d "$src" ] || die "deploy_tree: missing $src"
    mkdir -p "$dst"
    cp -a "$src/." "$dst/"
    [ -n "$owner" ] && chown -R "$owner" "$dst" 2>/dev/null || true
}
