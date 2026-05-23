# hermes-feishu-display-plus

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](LICENSE)
[![Hermes Agent](https://img.shields.io/badge/Hermes_Agent-%3E%3D0.14.0-9B59B6.svg)](https://github.com/NousResearch/hermes-agent)
[![Version](https://img.shields.io/badge/version-0.1.0-blue.svg)](https://github.com/OLDBAI213/hermes-feishu-display-plus/releases)

> **让 Hermes 在飞书里的状态一目了然。** 工具调用记录、三状态显示、结构化正文。

---

## 这是什么？

Hermes 在飞书里默认输出是扁平的——收到消息没反馈、工具调用一堆碎片、长时间任务看不到进度。

**hermes-feishu-display-plus** 解决这些问题：

| 场景 | 安装前 | 安装后 |
|------|--------|--------|
| 收到消息 | 无反馈 | `已收到，正在思考...` |
| 工具调用 | 碎片散落 | 🧰 工具调用记录（编号聚合） |
| 工具失败 | 单独一条错误 | 聚合到同一条记录里 |
| 长时间任务 | 看不到进度 | 已用时间、轮次、当前活动 |
| 模型名 | `Xiaomi MiMo` | `小米 MiMo` |

---

## 一键安装

```powershell
iex (irm https://raw.githubusercontent.com/OLDBAI213/hermes-feishu-display-plus/main/install.ps1)
```

---

## 快速命令

| 操作 | 命令 |
|------|------|
| **安装** | `iex (irm https://raw.githubusercontent.com/OLDBAI213/hermes-feishu-display-plus/main/install.ps1)` |
| **验证** | `powershell -ExecutionPolicy Bypass -File .\verify.ps1` |
| **回滚** | `powershell -ExecutionPolicy Bypass -File .\install.ps1 -Rollback latest` |

---

## 验证结果

- 显示增强验证：16/16 通过
- Hermes 本体测试：5/5 通过

---

## 依赖

需要先安装 [hermes-feishu-zh](https://github.com/OLDBAI213/hermes-feishu-zh)（中文化包）。

---

## 项目结构

```
hermes-feishu-display-plus/
├── install.ps1          # 安装/回滚脚本
├── verify.ps1           # 验证脚本
├── manifest.json        # 扩展清单
├── patches/             # 配置和源码替换规则
├── docs/                # 文档
├── tests/               # 测试
└── examples/            # 示例
```

---

## 许可证

MIT License

---

<div align="center">

**由 [小白 🤖](https://github.com/OLDBAI213) 独立维护** | Hermes Agent 社区扩展

</div>
