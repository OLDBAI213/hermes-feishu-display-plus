# hermes-feishu-display-plus

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](LICENSE)
[![Hermes Agent](https://img.shields.io/badge/Hermes_Agent-%3E%3D0.14.0-9B59B6.svg)](https://github.com/NousResearch/hermes-agent)
[![Version](https://img.shields.io/badge/version-0.1.0-blue.svg)](https://github.com/OLDBAI213/hermes-feishu-display-plus/releases)

> **让 Hermes 在飞书里的状态一目了然。** 工具调用记录、三状态显示、结构化正文。

---

## 痛点

Hermes 在飞书里默认输出是扁平的——收到消息没反馈、工具调用一堆碎片、长时间任务看不到进度。你发了一条消息，不知道 Hermes 有没有收到；它调用了哪些工具，你也不清楚；跑个长时间任务，完全看不到进展。

## 解决方案

**hermes-feishu-display-plus** 是飞书套件的显示增强包，解决这些问题：

| 场景 | 安装前 | 安装后 |
|------|--------|--------|
| 收到消息 | 无反馈 | `已收到，正在思考...` |
| 工具调用 | 碎片散落 | 🧰 工具调用记录（编号聚合） |
| 工具失败 | 单独一条错误 | 聚合到同一条记录里 |
| 编辑失败 | 裸露 `写入文件` / `待办` 气泡 | 不降级发送单独工具行 |
| 长时间任务 | 看不到进度 | 已用时间、轮次、当前活动 |
| 流式编辑 | `post update` 失败后退回纯文本 | `post` payload 结构符合飞书更新要求 |
| 模型名 | `Xiaomi MiMo` | `小米 MiMo` |

---

## 一键安装

```powershell
iex (irm https://raw.githubusercontent.com/OLDBAI213/hermes-feishu-display-plus/main/bootstrap.ps1)
```

**注意：** 需要先安装 [hermes-feishu-zh](https://github.com/OLDBAI213/hermes-feishu-zh)（中文化包）。

---

## 快速命令

| 操作 | 命令 |
|------|------|
| **安装** | `iex (irm https://raw.githubusercontent.com/OLDBAI213/hermes-feishu-display-plus/main/bootstrap.ps1)` |
| **验证** | `powershell -ExecutionPolicy Bypass -File .\verify.ps1` |
| **回滚** | `powershell -ExecutionPolicy Bypass -File .\install.ps1 -Rollback latest` |

---

## 验证结果

- 显示增强验证：20/20 通过
- Hermes 显示/飞书相关测试：232 通过

---

## 飞书套件

这是 **hermes-feishu-display-plus**，飞书套件的显示增强包。完整飞书体验需要安装套件的三个包：

| 包 | 定位 | 说明 |
|----|------|------|
| [hermes-feishu-zh](https://github.com/OLDBAI213/hermes-feishu-zh) | 中文化 | 基础包，必装 |
| **hermes-feishu-display-plus** | 显示增强 | 本包 |
| [hermes-feishu-adapter-optimization](https://github.com/OLDBAI213/hermes-feishu-adapter-optimization) | 适配优化 | 图片、文件、音视频、忙碌队列 |

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
