# Changelog

## [0.1.1] - 2026-05-24

### 修复
- 新增依赖预检（安装前检查 hermes-feishu-zh 是否已装）
- verify.ps1 新增小米 MiMo 检查项
- 回滚逻辑完善（同时恢复源码文件）
- 更新过时文档（patches/README、troubleshooting、install）
- 修正 LICENSE 版权方
- 替换硬编码路径

### 优化
- 完善 README，增加痛点描述和依赖说明
- 添加 GitHub Topics 提高可发现性

## [0.1.0] - 2026-05-23

### Added

- Added local project structure.
- Added `manifest.json`.
- Added `patches/stable.config.yaml`.
- Added `install.ps1` for config-only install, backup, verify, and rollback.
- Added `patches/source.replacements.json` and source replacement application.
- Added verification markers for immediate received/thinking status and Feishu processing reactions.
- Added source replacement for Feishu start-status provider display: `Xiaomi MiMo` -> `小米 MiMo`.
- Added `verify.ps1` to check current Hermes display optimization markers.
- Added install, upgrade, troubleshooting, validation, and status docs.
- Added validation for Feishu `post` update payload shape: title must be present and text elements must not be empty, preventing `message.update` fallback to plain text.

### Verified

- `verify.ps1`: 10 passed, 0 failed on the current local Hermes installation.
- `install.ps1`: created a config/source backup, merged `display.platforms.feishu`, checked/applied source replacements, and passed verification.
- Feishu processing reaction/status targeted tests: 5 passed, 0 failed after installing `lark-oapi==1.5.3`.
- Feishu post payload shape targeted tests: 4 passed, 0 failed.
