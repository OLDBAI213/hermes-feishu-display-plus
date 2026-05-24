# 验收清单

## 必须通过

- 开始处理时有即时状态：`已收到，正在思考`。
- 开始状态里的服务商中文化，例如 `小米 MiMo`。
- 有处理中的 Feishu `Typing` 反应标记。
- 成功完成时会移除 `Typing`，失败时会切换为失败标记。
- 工具记录标题存在：`工具调用记录`。
- 工具记录有编号。
- 工具记录标题显示实时调用次数，例如 `工具调用记录（2次）`。
- 一轮对话里的工具调用聚合在一个状态栏。
- 工具失败不另起一堆消息。
- 结构化正文不会被拆成碎片行。
- 代码块内容不被结构化清单整理逻辑改写。
- 飞书 `post` 更新 payload 必须带 `title`，且不能生成空 `text` 元素，避免 `message.update` 被飞书拒绝后退回纯文本。
- 手机和电脑都可读。

## 本机测试来源

- `$HERMES_HOME\hermes-agent\tests\gateway\test_feishu_zh_progress.py`
- `$HERMES_HOME\hermes-agent\tests\gateway\test_run_progress_topics.py`
- `$HERMES_HOME\hermes-agent\tests\gateway\test_feishu.py`

## 当前最小验收命令

```powershell
$env:HERMES_HOME='C:\\Users\\YourName\\hermes'  # 替换为你的实际 HERMES_HOME 路径
uv run python -m pytest -q -n0 --timeout-method=thread `
  tests\gateway\test_feishu.py `
  tests\gateway\test_feishu_zh_progress.py `
  tests\gateway\test_run_progress_topics.py::test_feishu_keeps_one_progress_bubble_across_interim_messages `
  tests\gateway\test_run_progress_topics.py::test_feishu_zh_progress_appends_failed_tool_line
```

## Feishu 可选依赖

处理反应测试需要 Hermes 环境安装 `lark-oapi`。本机已按 Hermes `feishu` extra 锁定版本补齐：

```powershell
uv pip install lark-oapi==1.5.3 qrcode==7.4.2
```
