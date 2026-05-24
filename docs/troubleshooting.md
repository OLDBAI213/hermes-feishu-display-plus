# 排查

## verify.ps1 失败

先看是哪一项失败：

- `structured post polisher exists`：当前 Hermes 源码没有结构化正文整理逻辑。
- `tool progress title marker exists`：当前 Hermes 源码没有工具调用记录抬头。
- `progress title/numbering tests exist`：当前 Hermes 测试里没有工具记录编号验证。

这些失败说明源码补丁还没有应用，或 Hermes 版本不包含对应能力。

## install.ps1 只改了配置但显示没变化

如果 `install.ps1` 成功但显示没变化，检查：

1. 运行 `.\install.ps1 -VerifyOnly` 查看哪些检查失败。
2. 如果源码检查失败，说明 `source.replacements.json` 中的标记（`find` 字段）与当前 Hermes 源码不匹配。
3. 如果 Hermes 源码已更新，标记文本可能已变动，需要更新 `source.replacements.json`。

## 小米 MiMo 显示未汉化

`verify.ps1` 会检查 `feishu.py` 中是否存在 `小米 MiMo` 和 `Xiaomi MiMo` 文本。
如果此项失败，说明小米 MiMo 显示优化补丁未应用，或者 `source.replacements.json` 中的 find 标记与当前源码不匹配。

## 依赖检查告警

如果安装时出现 "hermes-feishu-zh may not be installed" 告警：

1. 请确认已安装 `hermes-feishu-zh` 包。
2. 检查 `config.yaml` 中是否有 `language: zh` 配置。
3. 本包（hermes-feishu-display-plus）依赖 hermes-feishu-zh 提供的飞书中文本地化能力。

## 回滚

```powershell
powershell -ExecutionPolicy Bypass -File .\install.ps1 -Rollback latest
```

回滚会同时恢复：
- `config.yaml`（显示配置）
- Hermes 源码文件（之前被 `source.replacements.json` 修改的文件）

## 备份目录

备份存放在 `$HERMES_HOME/backups/hermes-feishu-display-plus-{时间戳}/` 下，
包含：
- `config.yaml` — 安装前的飞书显示配置
- `hermes-agent__gateway__run.py.bak` — 安装前的 run.py
- `hermes-agent__gateway__platforms__feishu.py.bak` — 安装前的 feishu.py
