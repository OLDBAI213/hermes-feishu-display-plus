# 当前状态

日期：2026-05-23

## 状态

本项目是本地草稿项目，已经具备项目结构、本机验证入口和配置层安装器。

## 已有本机能力

- 开始处理时即时状态：`⌛ 已收到，正在思考...`。
- Feishu `Typing` 反应标记：处理中显示，成功后移除，失败时切换失败标记。
- 开始状态里的小米服务商显示为 `小米 MiMo`，不再显示英文 `Xiaomi MiMo`。
- 飞书工具记录抬头：`工具调用记录`。
- 工具调用编号：`1.`、`2.`、`3.`。
- 同一轮对话的工具调用聚合在一个状态栏。
- 失败工具进入同一个状态栏。
- 飞书工具记录编辑失败时，不再降级发送裸露工具行。
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

- 备份目录示例：`$HERMES_HOME\backups\hermes-feishu-display-plus-20260523-221329`。
- 最新验证备份示例：`$HERMES_HOME\backups\hermes-feishu-display-plus-20260523-221923`。
- 已补 `lark-oapi==1.5.3` 后重跑 Feishu 处理反应测试：5 通过，0 失败。
- `verify.ps1`：16 通过，0 失败。

## 2026-05-24 反向审查修复：post update 回退纯文本

现象：

- 真实 `gateway.log` 中仍有 `Invalid post update payload rejected by API; falling back to plain text`。
- 出口审计显示失败集中在 `edit.build -> edit.result`，也就是飞书流式编辑/工具记录更新链路。

根因：

- 飞书 `post` payload 没有固定写入 `title`。
- 空行会生成空 `text` 元素，飞书 `message.update` 对这种格式拒绝。

处理：

- `gateway/platforms/feishu.py` 的 post payload 固定写入 `title: ""`。
- 空 `text` 改为空格占位，避免 update 被飞书拒绝。
- `patches/source.replacements.json` 已加入这两个源码替换，后续安装包会带上。
- `verify.ps1` 已新增 post update payload shape 检查。

验证：

- `verify.ps1`：19 通过，0 失败。
- Hermes 显示/飞书相关测试：232 通过，4 个第三方依赖 warning。
- 适配优化完整审查：37 通过，0 失败。
- Gateway 已重启，PID `18792`，15:01 后日志没有新的 `Invalid post update`。

自省：

- 之前只看 verify 和 mock fallback 会误判“显示增强没问题”。
- 以后显示增强必须同时反查 `gateway.log` 和 `feishu-outbound.ndjson`。

## 2026-05-24 反向审查修复：工具进度碎片气泡

现象：

- 飞书里出现裸露的 `写入文件`、`待办`、`终端` 等单独气泡。
- 这些不是模型正文，而是工具记录编辑失败后的降级发送。

根因：

- `gateway/run.py` 在编辑已有工具记录失败时，会调用 `adapter.send(content=msg)` 单独发送当前工具行。
- 飞书 `post update` 偶发失败后，这个降级分支会把工具记录拆成多个永久气泡。

处理：

- 飞书平台编辑工具记录失败时，禁止降级发送裸露工具行。
- 新增回归测试 `test_feishu_edit_failure_does_not_send_standalone_tool_lines`。
- `patches/source.replacements.json` 已同步该修复。
