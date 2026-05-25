# 安装

当前安装器处理飞书显示配置，并执行最小源码替换补丁检查。

```powershell
powershell -ExecutionPolicy Bypass -File .\install.ps1
```

只验证：

```powershell
powershell -ExecutionPolicy Bypass -File .\install.ps1 -VerifyOnly
```

回滚最近一次配置备份：

```powershell
powershell -ExecutionPolicy Bypass -File .\install.ps1 -Rollback latest
```

## 当前会修改什么

- `config.yaml`
  - `display.platforms.feishu.tool_progress = all`
  - `display.platforms.feishu.tool_preview_length = 120`
  - `display.platforms.feishu.streaming = true`
  - `display.platforms.feishu.runtime_footer.style = zh_detailed`

说明：工具调用记录由 `display.platforms.feishu.tool_progress` 控制。
- Hermes 源码
  - `gateway/run.py`：飞书工具调用记录标题和编号。
  - `gateway/platforms/feishu.py`：飞书 `post` 正文结构化整理入口、post update payload title、小米 MiMo 显示本地化。

## 当前不会修改什么

- 不修改模型配置。
- 不修改 API key。
- 不修改飞书凭证。

当前源码补丁仍是最小补丁，不是完整显示优化补丁。
