#!/usr/bin/env python3
"""对上游 rime-settings 配置应用本仓库的个人调整（不改动上游仓库本身）。

用法: apply-rime-tweaks.py <rime_user_dir>
调整:
  1) default.custom.yaml 的 schema_list 只保留 luna_pinyin（全拼）
  2) luna_pinyin.custom.yaml 启用 "switches/@0/reset": 1（初始英文）
"""
import os, re, sys

def tweak_schema_list(path):
    if not os.path.isfile(path): return False
    s = open(path, encoding='utf-8').read()
    new = "  schema_list:\n    - schema: luna_pinyin # 全拼\n"
    lines = s.splitlines(keepends=True)
    out, i, done = [], 0, False
    while i < len(lines):
        if not done and lines[i].strip().startswith('schema_list:'):
            out.append(new)
            i += 1
            while i < len(lines) and re.match(r'^\s{4,}(- schema:|#)', lines[i]):
                i += 1
            done = True
            continue
        out.append(lines[i]); i += 1
    if not done:
        return False
    open(path, 'w', encoding='utf-8').write(''.join(out))
    return True

def tweak_ascii_reset(path):
    if not os.path.isfile(path): return False
    s = open(path, encoding='utf-8').read()
    if 'switches/@0/reset' in s and not re.search(r'^\s*"switches/@0/reset"', s, re.M):
        s = s.replace('  #"switches/@0/reset": 1', '  "switches/@0/reset": 1', 1)
        open(path, 'w', encoding='utf-8').write(s)
        return True
    return False

def main():
    if len(sys.argv) != 2:
        sys.exit("usage: apply-rime-tweaks.py <rime_user_dir>")
    rime = sys.argv[1]
    a = tweak_schema_list(os.path.join(rime, 'default.custom.yaml'))
    b = tweak_ascii_reset(os.path.join(rime, 'luna_pinyin.custom.yaml'))
    print(f"rime tweaks: schema_list={a} ascii_reset={b}")

if __name__ == '__main__':
    main()
