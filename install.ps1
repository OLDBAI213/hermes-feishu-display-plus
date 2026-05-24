param(
    [ValidateSet("stable")]
    [string]$Profile = "stable",
    [string]$HermesHome = $(if ($env:HERMES_HOME) { $env:HERMES_HOME } else { "E:\AI\hermes" }),
    [switch]$VerifyOnly,
    [string]$Rollback = ""
)

$ErrorActionPreference = "Stop"
$PackageRoot = Split-Path -Parent $MyInvocation.MyCommand.Path

function Write-Step {
    param([string]$Message)
    Write-Host "`n== $Message =="
}

function Resolve-HermesPython {
    param([string]$AgentRoot)
    foreach ($candidate in @(
        (Join-Path $AgentRoot "venv\Scripts\python.exe"),
        (Join-Path $AgentRoot ".venv\Scripts\python.exe")
    )) {
        if (Test-Path -LiteralPath $candidate) { return $candidate }
    }
    $python = Get-Command python -ErrorAction SilentlyContinue
    if ($python -and $python.Source) { return $python.Source }
    throw "Python not found."
}

function Resolve-HermesHome {
    param([string]$Requested)
    $full = [System.IO.Path]::GetFullPath($Requested)
    if (-not (Test-Path -LiteralPath (Join-Path $full "config.yaml"))) {
        throw "config.yaml not found under HermesHome: $full"
    }
    if (-not (Test-Path -LiteralPath (Join-Path $full "hermes-agent"))) {
        throw "hermes-agent not found under HermesHome: $full"
    }
    return $full
}

function New-Backup {
    param([string]$HermesRoot)
    $stamp = Get-Date -Format "yyyyMMdd-HHmmss"
    $dir = Join-Path $HermesRoot "backups\hermes-feishu-display-plus-$stamp"
    New-Item -ItemType Directory -Force -Path $dir | Out-Null
    Copy-Item -LiteralPath (Join-Path $HermesRoot "config.yaml") -Destination (Join-Path $dir "config.yaml") -Force
    # Also backup source files that will be patched
    $replacementJson = Join-Path $PackageRoot "patches\source.replacements.json"
    if (Test-Path -LiteralPath $replacementJson) {
        $items = Get-Content -LiteralPath $replacementJson -Raw -Encoding UTF8 | ConvertFrom-Json
        $backedUp = @{}
        foreach ($item in $items) {
            $target = Join-Path $HermesRoot $item.file
            if ((Test-Path -LiteralPath $target) -and (-not $backedUp.ContainsKey($item.file))) {
                $backupName = ($item.file -replace '[\\/]', '__') + ".bak"
                Copy-Item -LiteralPath $target -Destination (Join-Path $dir $backupName) -Force
                $backedUp[$item.file] = $true
            }
        }
        if ($backedUp.Count -gt 0) {
            Write-Host "  ✅ Backed up $($backedUp.Count) source files"
        }
    }
    return $dir
}

function Restore-LatestBackup {
    param([string]$HermesRoot)
    $backupRoot = Join-Path $HermesRoot "backups"
    $latest = Get-ChildItem -LiteralPath $backupRoot -Directory -Filter "hermes-feishu-display-plus-*" -ErrorAction SilentlyContinue |
        Sort-Object Name -Descending |
        Select-Object -First 1
    if (-not $latest) { throw "No hermes-feishu-display-plus backup found." }
    $configBackup = Join-Path $latest.FullName "config.yaml"
    if (-not (Test-Path -LiteralPath $configBackup)) { throw "Backup missing config.yaml: $($latest.FullName)" }
    Copy-Item -LiteralPath $configBackup -Destination (Join-Path $HermesRoot "config.yaml") -Force
    Write-Host "Restored config.yaml from $($latest.FullName)"
    # Restore source files
    $backedUp = $false
    Get-ChildItem -LiteralPath $latest.FullName -Filter "*.bak" | ForEach-Object {
        $backupFile = $_.FullName
        # Extract original relative path from backup filename: e.g. "hermes-agent__gateway__run.py.bak"
        $origRel = $_.BaseName -replace '\.bak$', ''  # base name without .bak
        $origPath = Join-Path $HermesRoot ($origRel -replace '__', '/')
        if (Test-Path -LiteralPath $origPath) {
            Copy-Item -LiteralPath $backupFile -Destination $origPath -Force
            Write-Host "Restored source: $origRel"
            $backedUp = $true
        }
    }
    if (-not $backedUp) {
        Write-Host "No source file backups found in $($latest.FullName)"
    } else {
        Write-Host "Source files restored."
    }
}

function Merge-ConfigPatch {
    param(
        [string]$Python,
        [string]$ConfigPath,
        [string]$PatchPath
    )
    $script = @'
import os
from pathlib import Path
from ruamel.yaml import YAML

config_path = Path(os.environ["CONFIG_PATH"])
patch_path = Path(os.environ["PATCH_PATH"])
yaml = YAML()
yaml.preserve_quotes = True
config = yaml.load(config_path.read_text(encoding="utf-8")) or {}
patch = yaml.load(patch_path.read_text(encoding="utf-8")) or {}

def merge(dst, src):
    for key, value in src.items():
        if isinstance(value, dict):
            current = dst.get(key)
            if not isinstance(current, dict):
                current = {}
                dst[key] = current
            merge(current, value)
        else:
            dst[key] = value

merge(config, patch)
with config_path.open("w", encoding="utf-8") as f:
    yaml.dump(config, f)
'@
    $env:CONFIG_PATH = $ConfigPath
    $env:PATCH_PATH = $PatchPath
    $script | & $Python -
}

function Apply-Replacements {
    param(
        [string]$JsonPath,
        [string]$RootPath,
        [string]$BackupDir
    )
    if (-not (Test-Path -LiteralPath $JsonPath)) { return }
    $items = Get-Content -LiteralPath $JsonPath -Raw -Encoding UTF8 | ConvertFrom-Json
    $skipped = @()
    $applied = 0
    foreach ($item in $items) {
        $target = Join-Path $RootPath $item.file
        if (-not (Test-Path -LiteralPath $target)) {
            Write-Host "  ⚠️ 文件不存在，跳过: $($item.file)" -ForegroundColor Yellow
            $skipped += "$($item.file): 文件不存在"
            continue
        }
        $backupName = ($item.file -replace '[\\\\/]', '__') + ".bak"
        $backupPath = Join-Path $BackupDir $backupName
        if (-not (Test-Path -LiteralPath $backupPath)) {
            Copy-Item -LiteralPath $target -Destination $backupPath -Force
        }
        $text = Get-Content -LiteralPath $target -Raw -Encoding UTF8
        if ($text.Contains($item.replace)) {
            $applied++
            continue
        }
        if (-not $text.Contains($item.find)) {
            $skipped += "$($item.file): 标记未找到（可能 Hermes 已更新）"
            continue
        }
        $text = $text.Replace($item.find, $item.replace)
        Set-Content -LiteralPath $target -Value $text -Encoding UTF8 -NoNewline
        $applied++
    }
    if ($skipped.Count -gt 0) {
        Write-Host "  ⚠️ 跳过 $($skipped.Count) 条规则:" -ForegroundColor Yellow
        foreach ($s in $skipped) {
            Write-Host "    - $s" -ForegroundColor Yellow
        }
    }
    Write-Host "  ✅ 应用 $applied 条规则"
}

function Check-DependencyHermesFeishuZh {
    param([string]$HermesRoot)
    $configPath = Join-Path $HermesRoot "config.yaml"
    if (-not (Test-Path -LiteralPath $configPath)) {
        throw "config.yaml not found, cannot check dependency hermes-feishu-zh"
    }
    $config = Get-Content -LiteralPath $configPath -Raw -Encoding UTF8
    if ($config -match 'display\.platforms\.feishu\.[a-zA-Z_]+') {
        # Check if zh localization is configured (hermes-feishu-zh adds zh_localization)
        if ($config -match 'language:\s*zh' -or $config -match 'zh_localization') {
            Write-Host "  ✅ Dependency hermes-feishu-zh seems installed (zh localization found)"
            return $true
        }
    }
    Write-Host "  ⚠️ Dependency hermes-feishu-zh may not be installed!" -ForegroundColor Yellow
    Write-Host "  Expected: display config with zh language/localization" -ForegroundColor Yellow
    Write-Host "  This package depends on hermes-feishu-zh for Chinese Feishu integration." -ForegroundColor Yellow
    Write-Host "  Continuing anyway, but verify.ps1 checks may fail." -ForegroundColor Yellow
    return $false
}

$HermesHome = Resolve-HermesHome -Requested $HermesHome
$env:HERMES_HOME = $HermesHome
$AgentRoot = Join-Path $HermesHome "hermes-agent"
$Python = Resolve-HermesPython -AgentRoot $AgentRoot

if ($VerifyOnly) {
    & (Join-Path $PackageRoot "verify.ps1") -HermesHome $HermesHome
    exit $LASTEXITCODE
}

if ($Rollback) {
    if ($Rollback -ne "latest") { throw "Only -Rollback latest is supported." }
    Write-Step "Rollback"
    Restore-LatestBackup -HermesRoot $HermesHome
    & (Join-Path $PackageRoot "verify.ps1") -HermesHome $HermesHome
    exit $LASTEXITCODE
}

Write-Step "Dependency check"
Check-DependencyHermesFeishuZh -HermesRoot $HermesHome

Write-Step "Backup"
$backup = New-Backup -HermesRoot $HermesHome
Write-Host "Backup created: $backup"

Write-Step "Merge display config"
$patch = Join-Path $PackageRoot "patches\stable.config.yaml"
Merge-ConfigPatch -Python $Python -ConfigPath (Join-Path $HermesHome "config.yaml") -PatchPath $patch
Write-Host "Config merged: display.platforms.feishu"

Write-Step "Apply source display patch"
Apply-Replacements -JsonPath (Join-Path $PackageRoot "patches\source.replacements.json") -RootPath $HermesHome -BackupDir $backup
Write-Host "Source display patch checked/applied"

Write-Step "Verify"
& (Join-Path $PackageRoot "verify.ps1") -HermesHome $HermesHome
exit $LASTEXITCODE
