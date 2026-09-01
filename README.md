# ZYHY-Network

当前版本：`V0.2.0`

办公时不用再在「网线」和「公司 Wi-Fi」之间来回切。

- 看网页、刷视频、走代理：用网线
- 打开 OA、邮箱、iHR：自动走公司 Wi-Fi `ZYHY-Private`

两个可以同时开着。

## 你需要

1. 一台 Mac
2. 插上公司网线
3. Wi-Fi 连上 **ZYHY-Private**（不要连别的公司 Wi-Fi）

## 怎么装

打开「终端」，把下面三行粘贴进去，回车，输入开机密码：

```bash
git clone https://github.com/lampardrodgers/ZYHY-Network.git
cd ZYHY-Network
sudo ./install.sh
```

装完后：

1. 用 **新标签页** 打开 OA、邮箱（不要刷新刚才失败的那一页）
2. 如果用的是 Chrome：设置 → 隐私和安全 → 安全 → 关掉「使用安全 DNS」

能打开就行，不用再配域名。

## 用的时候注意

- 网线要插着，Wi-Fi 必须是 `ZYHY-Private`，分流才会开
- 拔掉网线、或换成别的 Wi-Fi：全部按系统原来的方式上网，内网入口可能会打不开
- 插回网线并连回 `ZYHY-Private`：等几秒会自动恢复

后台会监听 macOS 的网络状态变化，只在有线网、公司 Wi-Fi、网关或 DNS
等实际发生变化时更新分流配置。另有每 5 分钟一次的低频校验，用来补偿
偶尔漏掉的系统事件和内网域名解析变化；配置内容没变时不会重写网络设置。

## 不想用了

```bash
sudo zyhy-private-split uninstall
```
