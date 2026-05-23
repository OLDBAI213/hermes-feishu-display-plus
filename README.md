# hermes-feishu-display-plus

飞书显示优化项目。只负责让 Hermes 在飞书里的内容更清楚、更好扫、更稳定，不负责汉化规则、飞书 API 适配、浏览器底座修复。

## 边界

- 做：工具调用记录、状态栏、长任务进度、结构化正文、失败汇总、桌面端和移动端可读性。
- 不做：新增中文化规则、图片/文件接收能力、`lark-cli` API 编排、浏览器自动化修复。
- 依赖：默认基于 `hermes-feishu-zh` 已经完成中文化。

## 当前本机雏形

- 工具进度气泡抬头：`🧰 工具调用记录`。
- 工具调用编号：`1.`、`2.`、`3.`。
- 同一轮对话的工具调用保持在同一个状态栏里。
- 工具失败行进入同一个工具记录，不另起一堆消息。
- 工具 emoji 统一：网页搜索、网页提取、浏览器快照、浏览器控制台、执行过程等。
- 长时间运行状态更短：已用时间、轮次、当前活动。
- 结构化清单整理：把碎片化字段行整理成有层级的字段清单。

## 验收规则

- 不改变飞书正文和 `post` 的原有顺序。
- 不丢工具调用、状态、错误、图片/文件提示。
- 手机和电脑都必须可读；不能为了手机牺牲电脑端，也不能为了电脑端让手机端拥挤。
- 清单类正文不能变成碎片日志，要有标题、字段和值的层次。
- 每个显示优化都要有本地测试或截图验证。

## 快速使用

当前安装器只合并显示配置，并验证 Hermes 本机是否已经包含显示优化源码标记。

```powershell
powershell -ExecutionPolicy Bypass -File .\install.ps1
```

只验证：

```powershell
powershell -ExecutionPolicy Bypass -File .\verify.ps1
```

回滚最近一次配置备份：

```powershell
powershell -ExecutionPolicy Bypass -File .\install.ps1 -Rollback latest
```

## 当前结构

```text
hermes-feishu-display-plus/
├── install.ps1
├── verify.ps1
├── manifest.json
├── patches/
│   └── stable.config.yaml
├── docs/
├── tests/
└── examples/
```

## 下一步

1. 从 Hermes 本机改动里提取显示优化源码补丁清单。
2. 给源码补丁加幂等安装和回滚。
3. 给桌面端和移动端分别补验收样例。
4. 和 `hermes-feishu-zh` 保持解耦：先中文化，再显示优化。
