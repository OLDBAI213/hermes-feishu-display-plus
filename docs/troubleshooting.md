# 排查

## verify.ps1 失败

先看是哪一项失败：

- `structured post polisher exists`：当前 Hermes 源码没有结构化正文整理逻辑。
- `tool progress title marker exists`：当前 Hermes 源码没有工具调用记录抬头。
- `progress title/numbering tests exist`：当前 Hermes 测试里没有工具记录编号验证。

这些失败说明源码补丁还没有应用，或 Hermes 版本不包含对应能力。

## install.ps1 只改了配置但显示没变化

正常。当前 `install.ps1` 只合并显示配置，不改 Hermes 源码。

如果源码标记不存在，验证会失败，需要先把 Hermes 本机显示优化补丁抽出来。

## 回滚

```powershell
powershell -ExecutionPolicy Bypass -File .\install.ps1 -Rollback latest
```
