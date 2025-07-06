# TruffleHogShared.psm1 - Shared functions for TruffleHog Git hooks

# Import shared logging utility
$logPath = Join-Path -Path $PSScriptRoot -ChildPath "..\..\scripts\LoggingUtils.psm1"
Import-Module -Name $logPath -ErrorAction Stop

function Initialize-TruffleHogLogDir {
    param(
        [string]$BaseDir = $PSScriptRoot
    )

    $tempDir = Join-Path $BaseDir "../../.trufflehog-logs"
    New-Item -ItemType Directory -Path $tempDir -Force | Out-Null
    return $tempDir
}

function Invoke-TruffleHogScan {
    param(
        [string]$Content,
        [string]$SourceDescription = "content",
        [string]$LogDir,
        [string[]]$ExcludeDetectors = @("SlackWebhook")
    )

    Write-Log "🔍 Scanning: $SourceDescription" -Type "info"

    $excludeParam = if ($ExcludeDetectors.Count -gt 0) {
        "--exclude-detectors " + ($ExcludeDetectors -join " ")
    } else {
        ""
    }

    $scanResult = Write-Output $Content | docker run -i --rm `
        ghcr.io/trufflesecurity/trufflehog:latest stdin `
        --json $excludeParam *>&1

    $scanExitCode = $LASTEXITCODE

    $result = Parse-TruffleHogResults -ScanResult $scanResult -ScanExitCode $scanExitCode -SourceDescription $SourceDescription -LogDir $LogDir
    return $result
}

function Invoke-TruffleHogFileScan {
    param(
        [string]$FilePath,
        [string]$LogDir,
        [string[]]$ExcludeDetectors = @("SlackWebhook")
    )

    $tempFile = [System.IO.Path]::GetTempFileName()
    try {
        $FilePath | Out-File -FilePath $tempFile -Encoding UTF8

        $excludeParam = if ($ExcludeDetectors.Count -gt 0) {
            "--exclude-detectors " + ($ExcludeDetectors -join " ")
        } else {
            ""
        }

        Write-Log "🔍 Scanning file: $FilePath" -Type "info"

        $scanResult = docker run --rm -v "$($tempFile):/tmp/scan.txt" `
            ghcr.io/trufflesecurity/trufflehog:latest filesystem /tmp/scan.txt `
            --json $excludeParam *>&1

        $scanExitCode = $LASTEXITCODE

        $result = Parse-TruffleHogResults -ScanResult $scanResult -ScanExitCode $scanExitCode -SourceDescription