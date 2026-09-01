# 更新日志

## V0.2.2 - 2026-09-01

### Added

- 增加 `zyhy-network interval [seconds]`，用于查看或修改定时校验间隔。
- 间隔设为 `0` 时关闭定时校验，网络变化事件监听继续工作。

### Documentation

- 明确 GitHub 三步安装流程，以及安装后无需手动执行其他脚本。

## V0.2.1 - 2026-09-01

### Added

- 发布 npm 包 `@sunjiehao/zyhy-network`。
- 增加统一的 `zyhy-network` 命令，GitHub 与 npm 安装方式均可使用。
- 增加 `zyhy-network refresh`，用于立即刷新 DNS、路由和分流配置。

### Fixed

- LaunchDaemon 加载失败时自动重试，降低安装过程中的偶发失败。

## V0.2.0 - 2026-09-01

### Changed

- 将后台分流更新从 5 秒轮询改为 macOS 网络状态事件监听。
- 增加 300 秒一次的低频兜底校验，补偿漏掉的网络事件和内网 DNS 变化。
- 增加网络输入状态快照；状态未变化时不再改写路由、`/etc/hosts`、`/etc/resolver` 或代理例外。
- 对 DNS A 记录排序去重，并在临时解析失败时保留上一次有效结果。
- 增加 apply 互斥锁，避免事件监听和兜底校验并发修改网络状态。
- 安装时迁移旧的 `com.misakamikoto.zyhy-private-split` 服务，避免新旧守护进程同时运行。

### Fixed

- 减少与 Shadowrocket On Demand 网络状态重置的无效交互，降低网络配置抖动风险。
