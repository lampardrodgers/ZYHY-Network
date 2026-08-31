# ZYHY-Network

macOS 双通道分流：日常流量走网线（可叠加系统代理），杭研内网走 `ZYHY-Private` Wi-Fi。

只在「网线已连接 **并且** Wi-Fi 的 DHCP 域名是 `ZYHY-Private`」时启用分流。其它情况不改系统顺序：有网线优先网线，没网线全部走 Wi-Fi。

不修改 Shadowrocket 规则。浏览器走系统 HTTP 代理时，用系统代理旁路把内网域名直连出去。

## 要求

- 仅 macOS（在 Mac mini / Apple Silicon 上验证过）
- 有线网卡 + 机内 Wi-Fi 同时可用
- Wi-Fi 连的是 `ZYHY-Private`（用 DHCP `domain_name` 识别；新版 macOS 会把 SSID 打码）
- 安装需要管理员权限

Windows / Linux 不能直接用。

## 怎么走流量

```
YouTube / 公网  ──►  网线 ──► 系统代理（若已开启）──► 外网
OA / 邮箱 / iHR ──►  Wi-Fi ZYHY-Private ──► 内网
```

同时生效，互不抢默认路由。

系统层做了四件事：

1. **路由**：把内网网段从 Wi-Fi 出去（比网线那条 `172.16.0.0/12` 更具体）
2. **`/etc/resolver/<suffix>`**：这些后缀向 Private 的 DNS 查询，避免被 fake-ip 劫持
3. **`/etc/hosts`**：给精确主机名钉 IPv4
4. **系统代理 ExceptionsList**：Chrome / Edge 按主机名匹配旁路；只旁路网段不够，`oa.hq.cmcc` 仍会进 `127.0.0.1:1082`

## 安装

```bash
git clone https://github.com/lampardrodgers/ZYHY-Network.git
cd ZYHY-Network
chmod 755 zyhy-private-split
sudo mkdir -p /usr/local/etc
sudo cp zyhy-private-split.conf /usr/local/etc/
sudo ./zyhy-private-split install
zyhy-private-split status
```

会安装到：

| 路径 | 作用 |
| --- | --- |
| `/usr/local/sbin/zyhy-private-split` | 脚本 |
| `/usr/local/etc/zyhy-private-split.conf` | 配置 |
| `/Library/LaunchDaemons/com.zyhy.network.split.plist` | 每 5 秒检查一次网卡状态 |

装完用浏览器新开标签访问 OA / 邮箱验证。旧的错误页可能被缓存。

## 配置

`/usr/local/etc/zyhy-private-split.conf`：

```bash
WIFI_DOMAIN="ZYHY-Private"
DOMAINS="oa.hq.cmcc mail.cmhi.chinamobile.com"
SUFFIXES="hq.cmcc cmhi.chinamobile.com"
CIDRS="172.21.0.0/16 172.16.0.0/16"
```

| 项 | 含义 |
| --- | --- |
| `WIFI_DOMAIN` | 识别 Private 用的 DHCP 域名，一般等于 SSID |
| `DOMAINS` | 精确主机名，写入 `/etc/hosts` |
| `SUFFIXES` | 整个后缀走内网 DNS + 代理旁路。`*.hq.cmcc` 覆盖 OA、iHR 等，不必逐条加 |
| `CIDRS` | 强制从 Wi-Fi 出的 IPv4 网段。同一后缀可能落在不同网段 |

仓库里的 conf 是当前在用的一套：OA 多在 `172.21.0.0/16`，iHR（`ihr.hq.cmcc`）在 `172.16.0.0/16`。只加后缀不加网段时，解析会对、包仍可能从网线出去然后超时。

改 conf 后：

```bash
sudo zyhy-private-split apply
```

## 加减规则

```bash
zyhy-private-split list
zyhy-private-split status

sudo zyhy-private-split add foo.hq.cmcc          # 单个主机名
sudo zyhy-private-split add '*.example.com'      # 整个后缀
sudo zyhy-private-split add 10.20.0.0/16         # 整个网段

sudo zyhy-private-split remove foo.hq.cmcc
sudo zyhy-private-split remove '*.example.com'
sudo zyhy-private-split remove 10.20.0.0/16
```

OA 这类站点不要按每个链接加域名，优先加后缀和网段。某个链接仍超时：看解析到的 IP，把对应 `/16` 加上即可。

不要把 `*.chinamobile.com` 整段加进旁路，公网站也会绕过代理。邮箱用 `*.cmhi.chinamobile.com` 足够。

## 拷到其它 Mac

```bash
zyhy-private-split bundle ~/Downloads/zyhy-private-split.tgz
```

包里是当时的脚本 + conf。以后在本机 `add` 过规则，要再 `bundle` 一次再拷。

目标机器同样是 macOS，并且网线 + `ZYHY-Private`：

```bash
tar -xzf zyhy-private-split.tgz
cd zyhy-private-split
chmod 755 zyhy-private-split
sudo mkdir -p /usr/local/etc
sudo cp zyhy-private-split.conf /usr/local/etc/
sudo ./zyhy-private-split install
zyhy-private-split status
```

`sudo cp ...conf` 不要省，否则会落到脚本内置默认值。

## 卸载

```bash
sudo zyhy-private-split uninstall
```

拆掉守护进程、路由、hosts 块、resolver、代理旁路。`/usr/local/etc/zyhy-private-split.conf` 会保留。

## 故障排查

| 现象 | 常见原因 |
| --- | --- |
| curl 通、Chrome `ERR_TUNNEL_CONNECTION_FAILED` / 空响应 | 浏览器走系统代理；旁路没匹配到主机名 |
| `*.hq.cmcc` 有的通、有的 `ERR_CONNECTION_TIMED_OUT` | 解析到了尚未加入的网段（例如 iHR 在 `172.16.0.0/16`） |
| 刷新仍失败 | 用新标签；Chrome 关掉「使用安全 DNS / DoH」 |
| `status` 里 `split cond: no` | 没插网线，或 Wi-Fi 不是 `ZYHY-Private` |
| 拔网线 / 换 SSID 后内网又坏 | 按设计会拆分流；插回网线并连上 Private 后约 5 秒恢复 |

```bash
zyhy-private-split status
# 日志
tail -f /var/log/zyhy-private-split.log
```

## 不会上传的内容

脚本不保存账号、密码、证书、本机 IP、MAC、序列号。LaunchDaemon 标签用 `com.zyhy.network.split`，不含个人用户名。

内网域名、SSID、RFC1918 网段是分流规则本身，需要公开在配置里才能安装即用。
