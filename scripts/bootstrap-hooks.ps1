#!/usr/bin/env pwsh
<#
.SYNOPSIS
    Installs shared security scanning modules into .git/hooks/ for local testing

.DESCRIPTION
    Only installs TruffleHogShared.psm1 if needed
    No Git hooks (pre-commit, pre-push) are installed here
#>

$ErrorActionPreference = "Stop"

$RepoRoot = Resolve-Path "$PSScriptRoot\.."
$GitHooksDir = "$RepoRoot\.git\hooks"
$HookSourceDir = "$RepoRoot\scripts\githooks"
$ExpectedFiles = @("TruffleHogShared.psm1", "post-checkout")

# Import logger if needed
# Import-Module "$PSScriptRoot\LoggingUtils.psm1" -ErrorAction SilentlyContinue

function Write-Log($msg) { Write-Host "🔹 $msg" }

Write-Log "Installing TruffleHog shared modules for testing..."

foreach ($file in $ExpectedFiles) {
    $src = Join-Path $HookSourceDir $file
    $dst = Join-Path $GitHooksDir $file

    if (-not (Test-Path $src)) {
        Write-Log "❌ Missing $file in scripts/githooks/"
        continue
    }

    Copy-Item $src $dst -Force
    Write-Log "✅ Installed $file into .git/hooks/"
}

Write-Log "Done."
