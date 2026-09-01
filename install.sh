#!/bin/bash
# 开箱安装：拷配置并启用分流。需要 sudo。
set -euo pipefail
if [[ $(id -u) -ne 0 ]]; then
  echo "请用: sudo $0" >&2
  exit 1
fi
cd "$(dirname "$0")"
chmod 755 zyhy-private-split bin/zyhy-network
mkdir -p /usr/local/bin /usr/local/etc /usr/local/sbin
cp zyhy-private-split.conf /usr/local/etc/zyhy-private-split.conf
./zyhy-private-split install
if [[ -e /usr/local/bin/zyhy-network ]] && \
   ! grep -q '^# zyhy-network managed GitHub-install wrapper$' /usr/local/bin/zyhy-network 2>/dev/null; then
  echo "保留已有的 /usr/local/bin/zyhy-network（它不是本项目安装的文件）。" >&2
else
  cp bin/zyhy-network /usr/local/bin/zyhy-network
  chmod 755 /usr/local/bin/zyhy-network
fi
echo
echo "装好了。新开浏览器标签访问 OA / 邮箱即可。"
echo "查看状态: zyhy-network status"
