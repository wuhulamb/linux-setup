# lib/detect.sh — 机器检测（发行版无关）
cpu_model() { grep -m1 'model name' /proc/cpuinfo 2>/dev/null | sed 's/.*: //'; }

# 是否为 AMD Ryzen 7 7840 系列（用于 HiDPI 判定）
is_amd_7840() { grep -qiE 'Ryzen 7 7840' /proc/cpuinfo 2>/dev/null; }

# 推荐的 Xft.dpi：7840 笔记本 240，其它 135；可用 XFT_DPI 或 /etc/xft-dpi 覆盖
preferred_dpi() {
    if [ -n "${XFT_DPI:-}" ]; then printf '%s\n' "$XFT_DPI"; return; fi
    if [ -r /etc/xft-dpi ]; then cat /etc/xft-dpi; return; fi
    if is_amd_7840; then echo 240; else echo 135; fi
}

# 列出以太网接口（ARPHRD_ETHER，排除 lo）
ethernet_ifaces() {
    for d in /sys/class/net/*; do
        n=$(basename "$d"); [ "$n" = lo ] && continue
        [ "$(cat "$d/type" 2>/dev/null)" = 1 ] && echo "$n"
    done
}

# 列出无线接口
wifi_ifaces() {
    for d in /sys/class/net/*; do
        n=$(basename "$d"); [ -d "$d/wireless" ] && echo "$n"
    done
}
