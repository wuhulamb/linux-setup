#!/usr/bin/env bash
# Arch 基础系统安装（第一阶段，发行版专属）
# 思路：无需自制 ISO —— 直接用官方 archiso 启动 QEMU，配合 archinstall 的 JSON 配置无人值守。
# 也可用 pacstrap 手动流程（见下）。
set -euo pipefail
ROOT="$(cd "$(dirname "$0")/../.." && pwd)"
say(){ printf '### %s\n' "$*"; }
say "1) 获取 archiso（tools/fetch-images.sh），用 qemu 启动"
say "2) 在 live 环境里执行 archinstall，读取本目录 archinstall.json"
say "   或按 distros/arch/pacstrap-notes.md 手动 pacstrap"
say "3) 目标盘仍由 \$TARGET 指定；UEFI+GPT+ESP+ext4"
