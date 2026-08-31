#!/bin/bash
# 开箱安装：拷配置并启用分流。需要 sudo。
set -euo pipefail
if [[ $(id -u) -ne 0 ]]; then
  echo "请用: sudo $0" >&2
  exit 1
fi
cd "$(dirname "$0")"
chmod 755 zyhy-private-split
mkdir -p /usr/local/etc /usr/local/sbin
cp zyhy-private-split.conf /usr/local/etc/zyhy-private-split.conf
./zyhy-private-split install
echo
echo "装好了。新开浏览器标签访问 OA / 邮箱即可。"
echo "查看状态: zyhy-private-split status"
