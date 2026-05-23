# 验收清单

## 必须通过

- 开始处理时有即时状态：`已收到，正在思考`。
- 开始状态里的服务商中文化，例如 `小米 MiMo`。
- 有处理中的 Feishu `Typing` 反应标记。
- 成功完成时会移除 `Typing`，失败时会切换为失败标记。
- 工具记录标题存在：`工具调用记录`。
- 工具记录有编号。
- 一轮对话里的工具调用聚合在一个状态栏。
- 工具失败不另起一堆消息。
- 结构化正文不会被拆成碎片行。
- 代码块内容不被结构化清单整理逻辑改写。
- 手机和电脑都可读。

## 本机测试来源

- `E:\AI\hermes\hermes-agent\tests\gateway\test_feishu_zh_progress.py`
- `E:\AI\hermes\hermes-agent\tests\gateway\test_run_progress_topics.py`
- `E:\AI\hermes\hermes-agent\tests\gateway\test_feishu.py`

## Feishu 可选依赖

处理反应测试需要 Hermes 环境安装 `lark-oapi`。本机已按 Hermes `feishu` extra 锁定版本补齐：

```powershell
uv pip install lark-oapi==1.5.3 qrcode==7.4.2
```
