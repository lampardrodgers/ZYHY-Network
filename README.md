# ZYHY-Network

Mac 同时插网线、连 Wi-Fi **ZYHY-Private** 时：

- 普通上网走网线
- 公司内网走 Wi-Fi

已经按一台可用机器配好，别人下载就能用。

## 安装

电脑：macOS，网线 + Wi-Fi 名称是 `ZYHY-Private`。

```bash
git clone https://github.com/lampardrodgers/ZYHY-Network.git
cd ZYHY-Network
sudo ./install.sh
```

然后新开浏览器标签打开 OA / 邮箱。Chrome 请关掉「使用安全 DNS」。

## 已经包含

- `oa.hq.cmcc` 以及其它 `*.hq.cmcc`（含 iHR）
- `mail.cmhi.chinamobile.com` 以及 `*.cmhi.chinamobile.com`

## 卸载

```bash
sudo zyhy-private-split uninstall
```
