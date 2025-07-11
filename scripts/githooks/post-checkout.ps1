#!/usr/bin/env pwsh
<#
.SYNOPSIS
    Auto-installs Git hooks if missing after branch checkout
#>

$ErrorActionPreference = "SilentlyContinue"

# Relative paths
$repoRoot = Resolve-Path "$PSScriptRoot\..\.."
$hookDir = "$repoRoot\.git\hooks"
$expected = @("post-checkout, "TruffleHogShared.psm1")
$missing = @()

foreach ($file in $expected) {
    $path = Join-Path $hookDir $file
    if (-not (Test-Path $path)) {
        $missing += $file
    }
}

if ($missing.Count -gt 0) {
    Write-Host "🛠️  Detected missing Git hooks: $($missing -join ', ')"
    Write-Host "🔧 Attempting to re-run scripts/bootstrap-hooks.ps1..."

    $bootstrap = "$repoRoot\scripts\bootstrap-hooks.ps1"
    if (Test-Path $bootstrap) {
        & pwsh $bootstrap
    } else {
        Write-Host "❌ Cannot find bootstrap-hooks.ps1. Please run it manually."
    }
}
