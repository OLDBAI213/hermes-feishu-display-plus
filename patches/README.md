# patches

这里存放显示优化补丁。

## 补丁文件

| 文件 | 说明 |
|------|------|
| `stable.config.yaml` | 飞书显示配置补丁，被 `Merge-ConfigPatch` 合并到 Hermes `config.yaml` |
| `source.replacements.json` | Hermes 源码替换补丁，被 `Apply-Replacements` 应用到 Hermes 源码 |

## `source.replacements.json` 包含的修改

- `gateway/run.py`：飞书工具调用记录添加标题和编号
- `gateway/platforms/feishu.py`：
  - 结构化正文整理管道入口
  - post payload 添加 title 字段支持飞书更新
  - 空文本元素处理
  - 小米 MiMo 显示名称本地化

每个补丁在安装时都会自动备份原始文件，支持通过 `-Rollback latest` 回滚。
