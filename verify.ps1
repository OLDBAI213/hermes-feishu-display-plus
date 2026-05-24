param(
    [string]$HermesHome = $(if ($env:HERMES_HOME) { $env:HERMES_HOME } else { "E:\AI\hermes" })
)

$ErrorActionPreference = "Stop"
$totalPass = 0
$totalFail = 0

function Write-Check {
    param([string]$Name, [bool]$Pass)
    if ($Pass) {
        $script:totalPass++
        Write-Host "  [OK] $Name" -ForegroundColor Green
    } else {
        $script:totalFail++
        Write-Host "  [FAIL] $Name" -ForegroundColor Red
    }
}

$AgentRoot = Join-Path $HermesHome "hermes-agent"
$FeishuPy = Join-Path $AgentRoot "gateway\platforms\feishu.py"
$RunPy = Join-Path $AgentRoot "gateway\run.py"
$ProgressTests = Join-Path $AgentRoot "tests\gateway\test_feishu_zh_progress.py"
$RunProgressTests = Join-Path $AgentRoot "tests\gateway\test_run_progress_topics.py"
$FeishuTests = Join-Path $AgentRoot "tests\gateway\test_feishu.py"

Write-Host "hermes-feishu-display-plus local verification"
Write-Host "HERMES_HOME: $HermesHome"

Write-Check "Hermes agent root exists" (Test-Path -LiteralPath $AgentRoot)
Write-Check "Feishu adapter source exists" (Test-Path -LiteralPath $FeishuPy)

if (Test-Path -LiteralPath $FeishuPy) {
    $source = Get-Content -LiteralPath $FeishuPy -Raw -Encoding UTF8
    Write-Check "structured post polisher exists" ($source.Contains("_polish_feishu_structured_text"))
    Write-Check "processing start status exists" ($source.Contains("已收到，正在思考"))
    Write-Check "processing reaction markers exist" ($source.Contains("_FEISHU_REACTION_IN_PROGRESS") -and $source.Contains("_FEISHU_REACTION_FAILURE"))
    Write-Check "processing start hook exists" ($source.Contains("async def on_processing_start"))
    Write-Check "processing complete hook exists" ($source.Contains("async def on_processing_complete"))
    Write-Check "post payload has title for Feishu update" ($source.Contains('"title": ""') -and $source.Contains('"content": rows'))
    Write-Check "post text elements avoid empty strings" ($source.Contains('text if text else " "'))
    Write-Check "Xiaomi MiMo display optimization exists" ($source.Contains("小米 MiMo") -and $source.Contains("Xiaomi MiMo"))
}

if (Test-Path -LiteralPath $RunPy) {
    $runSource = Get-Content -LiteralPath $RunPy -Raw -Encoding UTF8
    Write-Check "tool progress title marker exists" ($runSource.Contains("工具调用记录"))
    Write-Check "tool progress numbering source exists" ($runSource.Contains("numbered =") -and $runSource.Contains("enumerate(lines, start=1)"))
} else {
    Write-Check "gateway run source exists" $false
}

if (Test-Path -LiteralPath $ProgressTests) {
    $progress = Get-Content -LiteralPath $ProgressTests -Raw -Encoding UTF8
    Write-Check "localized process and emoji tests exist" ($progress.Contains("执行过程") -and $progress.Contains("browser_snapshot"))
} else {
    Write-Check "localized process and emoji tests exist" $false
}

if (Test-Path -LiteralPath $RunProgressTests) {
    $runProgress = Get-Content -LiteralPath $RunProgressTests -Raw -Encoding UTF8
    Write-Check "failed tool line aggregation test exists" ($runProgress.Contains("test_feishu_zh_progress_appends_failed_tool_line"))
    Write-Check "progress title/numbering tests exist" ($runProgress.Contains("工具调用记录") -and $runProgress.Contains("1. "))
} else {
    Write-Check "failed tool line aggregation test exists" $false
    Write-Check "progress title/numbering tests exist" $false
}

if (Test-Path -LiteralPath $FeishuTests) {
    $feishuTestsText = Get-Content -LiteralPath $FeishuTests -Raw -Encoding UTF8
    Write-Check "immediate received/thinking status test exists" ($feishuTestsText.Contains("test_start_sends_immediate_status_message") -and $feishuTestsText.Contains("已收到，正在思考"))
    Write-Check "typing reaction lifecycle tests exist" ($feishuTestsText.Contains("test_start_adds_typing_and_caches_reaction_id") -and $feishuTestsText.Contains("test_success_removes_typing_and_adds_nothing"))
    Write-Check "structured list readability test exists" ($feishuTestsText.Contains("test_markdown_post_polishes_split_structured_list_for_desktop_readability"))
    Write-Check "code block preservation test exists" ($feishuTestsText.Contains("test_markdown_post_polisher_does_not_rewrite_code_blocks"))
    Write-Check "post update payload shape tests exist" ($feishuTestsText.Contains("test_build_post_payload_never_emits_empty_text_elements") -and $feishuTestsText.Contains('self.assertIn("title", parsed["zh_cn"])'))
} else {
    Write-Check "structured post tests exist" $false
}

Write-Host ""
Write-Host "SUMMARY"
Write-Host "  Passed: $totalPass"
Write-Host "  Failed: $totalFail"

if ($totalFail -gt 0) { exit 1 }
