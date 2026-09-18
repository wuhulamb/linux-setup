#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
ECNU 校园网有线认证（srun_portal 协议）——仅使用 Python 标准库。

与 https://github.com/ECNUSR/ecnu_network_login 的算法保持一致
（XXTEA 变体 + 自定义 base64，已用 node 参考实现逐字节校验）。
凭据从 /etc/ecnu/ecnu.conf 读取，不会输出到日志或命令行。

用法:
    ecnu_net_login --once
    ecnu_net_login --loop --interval 60
    ecnu_net_login --check          # 只检测网络是否连通
"""
import argparse
import hashlib
import hmac
import json
import logging
import os
import socket
import ssl
import subprocess
import sys
import time
import urllib.request

MASK = 0xFFFFFFFF
_ALPHA = "LVoJPiCN2R8G90yg+hmFHuacZ1OWMnrsSTXkYpUq/3dlbfKwv6xztjI7DeBE45QA"
CONF = os.environ.get("ECNU_CONF", "/etc/ecnu/ecnu.conf")
CHALLENGE = "https://login.ecnu.edu.cn/cgi-bin/get_challenge"
PORTAL = "https://login.ecnu.edu.cn/cgi-bin/srun_portal"

log = logging.getLogger("ecnu_net_login")


# --------------------------- srun_bx1 encoding ---------------------------
def _to_words(s, append_len):
    c = len(s)
    v = []
    i = 0
    while i < c:
        def cc(k):
            return ord(s[k]) if 0 <= k < c else 0
        v.append((cc(i) | (cc(i + 1) << 8) | (cc(i + 2) << 16) | (cc(i + 3) << 24)) & MASK)
        i += 4
    if append_len:
        v.append(c)
    return v


def _from_words(a, has_len):
    d = len(a)
    c = (d - 1) << 2
    if has_len:
        m = a[d - 1]
        if m < c - 3 or m > c:
            return None
        c = m
    out = []
    for x in a:
        x &= MASK
        out.append(chr(x & 0xff) + chr((x >> 8) & 0xff) + chr((x >> 16) & 0xff) + chr((x >> 24) & 0xff))
    s = ''.join(out)
    return s[:c] if has_len else s


def _xxtea(s, key):
    if s == '':
        return ''
    v = _to_words(s, True)
    k = _to_words(key, False)
    while len(k) < 4:
        k.append(0)
    n = len(v) - 1
    z, y = v[n], v[0]
    c = 0x9E3779B9
    q = 6 + 52 // (n + 1)
    d = 0
    while q > 0:
        q -= 1
        d = (d + c) & MASK
        e = (d >> 2) & 3
        p = 0
        while p < n:
            y = v[p + 1]
            m = ((z >> 5) ^ ((y << 2) & MASK))
            m = (m + ((y >> 3) ^ ((z << 4) & MASK) ^ (d ^ y))) & MASK
            m = (m + (k[(p & 3) ^ e] ^ z)) & MASK
            z = (v[p] + m) & MASK
            v[p] = z
            p += 1
        y = v[0]
        m = ((z >> 5) ^ ((y << 2) & MASK))
        m = (m + ((y >> 3) ^ ((z << 4) & MASK) ^ (d ^ y))) & MASK
        m = (m + (k[(n & 3) ^ e] ^ z)) & MASK
        z = (v[n] + m) & MASK
        v[n] = z
    return _from_words(v, False)


def _b64(s):
    if len(s) == 0:
        return s
    out = []
    imax = len(s) - len(s) % 3
    i = 0
    while i < imax:
        b10 = (ord(s[i]) << 16) | (ord(s[i + 1]) << 8) | ord(s[i + 2])
        out.append(_ALPHA[(b10 >> 18) & 63])
        out.append(_ALPHA[(b10 >> 12) & 63])
        out.append(_ALPHA[(b10 >> 6) & 63])
        out.append(_ALPHA[b10 & 63])
        i += 3
    rem = len(s) - imax
    if rem == 1:
        b10 = ord(s[i]) << 16
        out.append(_ALPHA[(b10 >> 18) & 63] + _ALPHA[(b10 >> 12) & 63] + '==')
    elif rem == 2:
        b10 = (ord(s[i]) << 16) | (ord(s[i + 1]) << 8)
        out.append(_ALPHA[(b10 >> 18) & 63] + _ALPHA[(b10 >> 12) & 63] + _ALPHA[(b10 >> 6) & 63] + '=')
    return ''.join(out)


def srun_encode(data, token):
    return _b64(_xxtea(data, token))


# --------------------------- networking helpers ---------------------------
def _ssl_ctx():
    ctx = ssl.create_default_context()
    ctx.check_hostname = False
    ctx.verify_mode = ssl.CERT_NONE
    return ctx


def http_get(url, timeout=8):
    req = urllib.request.Request(url, headers={'User-Agent': 'Mozilla/5.0'})
    with urllib.request.urlopen(req, timeout=timeout, context=_ssl_ctx()) as r:
        return r.status, r.read()


# Captive-portal 探测端点：(url, 期望状态码, 期望正文子串或 None)
# 只有返回“预期响应”才算真正联网；返回了响应但不符合预期
# （典型是 200 的 portal 登录页）则判为被劫持。
_PROBES = (
    ('http://connect.rom.miui.com/generate_204', 204, None),
    ('http://www.gstatic.com/generate_204', 204, None),
    ('http://connectivitycheck.gstatic.com/generate_204', 204, None),
    ('http://cp.cloudflare.com/generate_204', 204, None),
    ('http://captive.apple.com/hotspot-detect.html', 200, 'Success'),
    ('http://www.msftconnecttest.com/connecttest.txt', 200, 'Microsoft Connect Test'),
)


def is_network_ok():
    """判断是否真正连上互联网（排除 captive portal 劫持）。

    - 任一探测端点返回预期响应            -> 真正联网 (True)
    - 端点可达、但返回 2xx/3xx 且不符合预期 -> 极可能被 portal 劫持 (False)
    - 端点 4xx/5xx 或连接失败(超时/重置)   -> 该域名被屏蔽，继续试下一个
    - 所有端点都不可达                    -> 无法确认，判为未联网 (False)
    """
    for url, want_status, want_body in _PROBES:
        try:
            status, body = http_get(url, timeout=4)
        except Exception:
            continue
        if status == want_status and (want_body is None or want_body.encode() in body):
            return True
        # 端点有响应却不是预期内容：2xx/3xx 通常就是 portal 重定向后的页面
        if 200 <= status < 400:
            return False
    return False


def get_host_ip():
    s = socket.socket(socket.AF_INET, socket.SOCK_DGRAM)
    try:
        s.connect(('8.8.8.8', 80))
        return s.getsockname()[0]
    finally:
        s.close()


def has_ethernet_ipv4():
    """是否存在带 IPv4 地址的以太网接口（不硬编码接口名）。"""
    try:
        names = os.listdir('/sys/class/net')
    except OSError:
        return False
    for name in names:
        if name == 'lo':
            continue
        try:
            with open('/sys/class/net/%s/type' % name) as f:
                if f.read().strip() != '1':   # ARPHRD_ETHER
                    continue
        except OSError:
            continue
        try:
            out = subprocess.run(['ip', '-o', '-4', 'addr', 'show', 'dev', name],
                                 capture_output=True, text=True, timeout=5).stdout
        except Exception:
            out = ''
        if ' inet ' in out:
            return True
    return False


# --------------------------- srun login -----------------------------------
def get_token(username, ip, ts):
    status, content = http_get(
        '%s?callback=x&username=%s&ip=%s&_=%d' % (CHALLENGE, username, ip, ts))
    text = content.decode('utf-8', 'replace')
    start, end = text.find('('), text.rfind(')')
    return json.loads(text[start + 1:end])['challenge']


def get_info(username, password, ip, token):
    payload = ('{"username":"' + username + '","password":"' + password +
               '","ip":"' + ip + '","acid":"1","enc_ver":"srun_bx1"}')
    return '{SRBX1}' + srun_encode(payload, token)


def build_login_url(username, password, ip, ts):
    token = get_token(username, ip, ts)
    password_hmac = hmac.new(token.encode(), password.encode(), hashlib.md5).hexdigest()
    password_last = '{MD5}' + password_hmac
    info = get_info(username, password, ip, token)
    chksum = hashlib.sha1(
        (token + username + token + password_hmac + token + '1' + token + ip +
         token + '200' + token + '1' + token + info).encode()).hexdigest()
    url = ('callback=1&action=login&username=%s&password=%s&double_stack=0&chksum=%s'
           '&info=%s&ac_id=1&ip=%s&n=200&type=1&_=%d' %
           (username, password_last, chksum, info, ip, ts))
    url = url.replace('{', '%7B').replace('}', '%7D').replace('+', '%2B').replace('/', '%2F')
    return PORTAL + '?' + url


def login_once(username, password):
    ip = get_host_ip()
    ts = int(round(time.time() * 1000))
    url = build_login_url(username, password, ip, ts)
    try:
        http_get(url, timeout=10)
    except Exception as e:
        log.debug('portal request error: %s', e)
    return is_network_ok()


def load_conf():
    username = os.environ.get('ECNU_USERNAME')
    password = os.environ.get('ECNU_PASSWORD')
    if username and password:
        return username, password
    if not os.path.exists(CONF):
        return None, None
    with open(CONF) as f:
        for line in f:
            line = line.strip()
            if not line or line.startswith('#') or '=' not in line:
                continue
            k, v = line.split('=', 1)
            if k.strip() == 'username':
                username = v.strip().strip('"')
            elif k.strip() == 'password':
                password = v.strip().strip('"')
    return username, password


def main():
    ap = argparse.ArgumentParser(description='ECNU campus network login (srun_portal)')
    ap.add_argument('-m', '--mode', choices=['once', 'loop', 'check'], default='once')
    ap.add_argument('-i', '--interval', type=int, default=60)
    ap.add_argument('-v', '--verbose', action='store_true')
    args = ap.parse_args()
    logging.basicConfig(level=logging.DEBUG if args.verbose else logging.INFO,
                        format='%(asctime)s %(levelname)s: %(message)s')

    if args.mode == 'check':
        sys.exit(0 if is_network_ok() else 1)

    username, password = load_conf()
    if not username or not password:
        log.error('no credentials in %s', CONF)
        sys.exit(2)

    if args.mode == 'once':
        log.info('login %s', 'ok' if login_once(username, password) else 'failed')
        return

    while True:
        try:
            if not has_ethernet_ipv4():
                log.debug('no ethernet IPv4, skip')
            elif is_network_ok():
                log.debug('network online, skip')
            else:
                log.info('network offline, trying campus login ...')
                log.info('login %s', 'ok' if login_once(username, password) else 'failed')
        except Exception as e:
            log.warning('error: %s', e)
        time.sleep(max(10, args.interval))


if __name__ == '__main__':
    main()
