# Changelog

## [0.1.0-local] - 2026-05-23

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

### Verified

- `verify.ps1`: 10 passed, 0 failed on the current local Hermes installation.
- `install.ps1`: created a config/source backup, merged `display.platforms.feishu`, checked/applied source replacements, and passed verification.
- Feishu processing reaction/status targeted tests: 5 passed, 0 failed after installing `lark-oapi==1.5.3`.
