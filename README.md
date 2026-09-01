# ZYHY-Network

当前版本：`V0.2.1`

让 Mac 同时使用公司网线和 `ZYHY-Private` Wi-Fi：普通网络走网线，OA、邮箱等内网地址自动走 Wi-Fi。

## 功能

- 仅在网线已连接且 Wi-Fi 为 `ZYHY-Private` 时启用分流
- 监听 macOS 网络变化并自动更新，不再每 5 秒轮询
- 每 5 分钟低频校验一次，配置未变化时不重写网络设置
- 支持 `zyhy-network refresh` 立即刷新 DNS、路由和分流配置
- GitHub 与 npm 安装提供相同的 `zyhy-network` 命令

## 安装

GitHub：

```bash
git clone https://github.com/lampardrodgers/ZYHY-Network.git
cd ZYHY-Network
sudo ./install.sh
```

npm：

```bash
npm install -g @sunjiehao/zyhy-network
zyhy-network install
```

需要修改系统配置时，命令会自动请求管理员权限。

## 常用命令

```bash
zyhy-network status                 # 查看状态
zyhy-network refresh                # 强制刷新
zyhy-network add '*.hq.cmcc'        # 添加域名后缀
zyhy-network add 172.21.0.0/16      # 添加网段
zyhy-network uninstall              # 卸载，保留配置
```

## 注意

- 网线和 `ZYHY-Private` Wi-Fi 需要同时连接；网络变化后会自动恢复分流
- Chrome 若无法打开内网，请关闭“设置 → 隐私和安全 → 安全 → 使用安全 DNS”
