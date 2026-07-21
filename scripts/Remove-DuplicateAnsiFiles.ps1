<#
.SYNOPSIS
    Find or remove byte-identical ANSI files duplicated across active and unused collections.
#>

#Requires -Version 5.1

[CmdletBinding(SupportsShouldProcess = $true, ConfirmImpact = 'High')]
param(
    [Parameter()]
    [switch]$CheckOnly
)

Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'
$repoRoot = Split-Path -Path $PSScriptRoot -Parent
$activeRoot = Join-Path -Path $repoRoot -ChildPath 'assets/ansi-files'
$unusedRoot = Join-Path -Path $repoRoot -ChildPath 'assets/unused-ansi-files'

foreach ($requiredDirectory in @($activeRoot, $unusedRoot)) {
    if (-not (Test-Path -LiteralPath $requiredDirectory -PathType Container)) {
        throw "ANSI collection directory not found: $requiredDirectory"
    }
}

$duplicateCount = 0
$removedCount = 0
$conflictCount = 0
foreach ($activeFile in Get-ChildItem -LiteralPath $activeRoot -File) {
    $unusedPath = Join-Path -Path $unusedRoot -ChildPath $activeFile.Name
    if (-not (Test-Path -LiteralPath $unusedPath -PathType Leaf)) {
        continue
    }

    $activeHash = (Get-FileHash -LiteralPath $activeFile.FullName -Algorithm SHA256).Hash
    $unusedHash = (Get-FileHash -LiteralPath $unusedPath -Algorithm SHA256).Hash
    if ($activeHash -ne $unusedHash) {
        Write-Warning "Same-name files differ and were preserved: $($activeFile.Name)"
        $conflictCount++
        continue
    }

    $duplicateCount++
    if ($CheckOnly) {
        Write-Host "Duplicate: $unusedPath" -ForegroundColor Yellow
        continue
    }

    if ($PSCmdlet.ShouldProcess($unusedPath, 'Remove byte-identical duplicate ANSI file')) {
        Remove-Item -LiteralPath $unusedPath -Force -ErrorAction Stop
        $removedCount++
    }
}

[pscustomobject]@{
    Duplicates = $duplicateCount
    Removed    = $removedCount
    Conflicts  = $conflictCount
}

if ($conflictCount -gt 0) {
    throw "$conflictCount same-name ANSI file collision(s) have different content."
}
