#!/usr/bin/env pwsh
<#
.SYNOPSIS
    Installs shared security scanning modules into .git/hooks/ for local testing

.DESCRIPTION
    Only installs TruffleHogShared.psm1 if needed
    No Git hooks (pre-commit, pre-push) are installed here
#>

$ErrorActionPreference = "Stop"

$RepoRoot = Resolve-Path "$PSScriptRoot/.."
$GitHooksDir = "$RepoRoot/.git/hooks"
$HookSourceDir = "$RepoRoot/scripts/githooks"
$ExpectedFiles = @("post-checkout.ps1")

Import-Module "$PSScriptRoot/shared/LoggingUtils.psm1" -ErrorAction Stop
Import-Module "$PSScriptRoot/shared/TruffleHogShared.psm1" -ErrorAction Stop

Write-Log -Message "Installing TruffleHog shared modules for testing..." -Type "info"

foreach ($file in $ExpectedFiles) {
    $src = Join-Path $HookSourceDir $file
    $dst = Join-Path $GitHooksDir $file

    if (-not (Test-Path $src)) {
        Write-Log -Message "Missing $file in scripts/githooks/" -Type "error"
        continue
    }

    Copy-Item $src $dst -Force
    Write-Log -Message "Installed $file into .git/hooks/" -Type "info"
}

Write-Log -Message "Done." -Type "info"
