#Requires -Version 5.1

[CmdletBinding()]
param(
    # Used by CI/build scripts to disable smoke tests if desired.
    [switch]$SkipCustomTests,

    # Kept for compatibility with older runners (this script does not run Pester).
    [switch]$SkipPester,

    # Kept for compatibility with older runners (lint is handled elsewhere).
    [switch]$SkipLint
)

$ErrorActionPreference = 'Stop'
$ProgressPreference = 'SilentlyContinue'

# These parameters are accepted for compatibility with older CI runners.
# This script does not run Pester or lint directly, but we still consume the parameters
# so PSScriptAnalyzer does not flag them as unused.
if ($SkipPester) {
    Write-Verbose 'SkipPester specified (no Pester suite is executed by this script).'
}
if ($SkipLint) {
    Write-Verbose 'SkipLint specified (no lint step is executed by this script).'
}

$script:Passed = 0
$script:Failed = 0

function Invoke-SmokeTest {
    param(
        [Parameter(Mandatory)]
        [string]$Name,

        [Parameter(Mandatory)]
        [scriptblock]$Action
    )

    try {
        & $Action
        $script:Passed++
        Write-Host ("[PASS] {0}" -f $Name) -ForegroundColor Green
    }
    catch {
        $script:Failed++
        Write-Host ("[FAIL] {0}: {1}" -f $Name, $_.Exception.Message) -ForegroundColor Red
    }
}

# Ensure we start from the repository root
$repoRoot = Split-Path -Parent $PSScriptRoot
Set-Location -LiteralPath $repoRoot

# IMPORTANT:
# Smoke tests call Clear-ColorScriptCache / New-ColorScriptCache.
# Always isolate cache/config so CI does NOT touch a developer's real %APPDATA% cache.
$originalCachePathEnv = $env:COLOR_SCRIPTS_ENHANCED_CACHE_PATH
$originalConfigRootEnv = $env:COLOR_SCRIPTS_ENHANCED_CONFIG_ROOT
$testRunRoot = Join-Path -Path ([System.IO.Path]::GetTempPath()) -ChildPath (
    'ColorScripts-Enhanced-Smoke-' + [guid]::NewGuid().ToString('N')
)

try {
    $env:COLOR_SCRIPTS_ENHANCED_CACHE_PATH = Join-Path -Path $testRunRoot -ChildPath 'cache'
    $env:COLOR_SCRIPTS_ENHANCED_CONFIG_ROOT = Join-Path -Path $testRunRoot -ChildPath 'config'

    New-Item -ItemType Directory -Path $env:COLOR_SCRIPTS_ENHANCED_CACHE_PATH -Force | Out-Null
    New-Item -ItemType Directory -Path $env:COLOR_SCRIPTS_ENHANCED_CONFIG_ROOT -Force | Out-Null

    $moduleManifest = Join-Path -Path $repoRoot -ChildPath 'ColorScripts-Enhanced/ColorScripts-Enhanced.psd1'

    Write-Host 'Running ColorScripts-Enhanced Smoke Tests' -ForegroundColor Cyan
    Write-Host '========================================' -ForegroundColor Cyan

    Invoke-SmokeTest -Name 'Import module' -Action {
        Import-Module $moduleManifest -Force -ErrorAction Stop
    }

    if (-not $SkipCustomTests) {
        Invoke-SmokeTest -Name 'Required commands exist' -Action {
            foreach ($cmd in @(
                    'Show-ColorScript',
                    'Get-ColorScriptList',
                    'New-ColorScriptCache',
                    'Clear-ColorScriptCache',
                    'Get-ColorScriptConfiguration'
                )) {
                if (-not (Get-Command $cmd -ErrorAction SilentlyContinue)) {
                    throw "Command not found: $cmd"
                }
            }
        }

        Invoke-SmokeTest -Name 'Alias scs exists' -Action {
            $alias = Get-Alias scs -ErrorAction Stop
            if ($alias.Definition -ne 'Show-ColorScript') {
                throw 'Alias scs not pointing to Show-ColorScript'
            }
        }

        Invoke-SmokeTest -Name 'Get-ColorScriptList returns scripts' -Action {
            $list = Get-ColorScriptList -Quiet
            if (-not $list -or $list.Count -eq 0) {
                throw 'No scripts returned'
            }
        }

        Invoke-SmokeTest -Name 'Show-ColorScript works (ReturnText)' -Action {
            $text = Show-ColorScript -Name 'bars' -ReturnText -Quiet -NoCache -ErrorAction Stop
            if ([string]::IsNullOrWhiteSpace($text)) {
                throw 'Show-ColorScript returned no output'
            }
        }

        Invoke-SmokeTest -Name 'Cache build + clear (isolated path)' -Action {
            Clear-ColorScriptCache -All -Confirm:$false -ErrorAction Stop
            New-ColorScriptCache -Name 'bars' -ErrorAction Stop | Out-Null
        }
    }
}
finally {
    $env:COLOR_SCRIPTS_ENHANCED_CACHE_PATH = $originalCachePathEnv
    $env:COLOR_SCRIPTS_ENHANCED_CONFIG_ROOT = $originalConfigRootEnv

    if ($testRunRoot -and (Test-Path -LiteralPath $testRunRoot)) {
        Remove-Item -LiteralPath $testRunRoot -Recurse -Force -ErrorAction SilentlyContinue
    }
}

Write-Host ''
Write-Host 'Summary:' -ForegroundColor Cyan
Write-Host ("  Passed: {0}" -f $script:Passed) -ForegroundColor Green
Write-Host ("  Failed: {0}" -f $script:Failed) -ForegroundColor Red

if ($script:Failed -gt 0) { exit 1 }
exit 0
