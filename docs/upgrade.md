# 升级

当前版本是 `0.1.0-local`，还没有远程发布流程。

升级前：

1. 先运行 `verify.ps1` 确认当前 Hermes 状态。
2. 再运行 `install.ps1`，安装器会备份 `config.yaml`。
3. 如显示异常，运行 `install.ps1 -Rollback latest`。

后续正式版本需要补：

- 源码补丁抽取。
- 源码补丁幂等检查。
- 升级前后截图验收。
- 发布用 changelog。
