# 当前状态

日期：2026-05-23

## 状态

本项目是本地草稿项目，已经具备项目结构、本机验证入口和配置层安装器。

## 已有本机能力

- 飞书工具记录抬头：`工具调用记录`。
- 工具调用编号：`1.`、`2.`、`3.`。
- 同一轮对话的工具调用聚合在一个状态栏。
- 失败工具进入同一个状态栏。
- 结构化正文清单整理，避免桌面端显示成碎片日志。
- 保留代码块，不改写 fenced code block。
- 已有最小源码替换补丁：`patches/source.replacements.json`。

## 当前验证入口

```powershell
powershell -ExecutionPolicy Bypass -File .\verify.ps1
```

## 未完成

- 还没有抽完整源码补丁；当前只有工具记录标题/编号和 post 结构化整理入口的最小替换。
- 还没有桌面端和移动端截图验收样例。

## 2026-05-23 本机验证

- `install.ps1 -VerifyOnly`：10 通过，0 失败。
- `install.ps1`：已创建配置/源码备份，合并 `display.platforms.feishu` 配置，并执行源码替换检查。
- 备份目录示例：`E:\AI\hermes\backups\hermes-feishu-display-plus-20260523-221329`。
- 最新验证备份示例：`E:\AI\hermes\backups\hermes-feishu-display-plus-20260523-221923`。
