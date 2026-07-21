<#
.SYNOPSIS
    Run the repository lint implementation under PowerShell 7 or later.
#>

#Requires -Version 7.0

[CmdletBinding()]
param(
    [Parameter()]
    [string]$SettingsPath,

    [Parameter()]
    [string]$SourcePath,

    [Parameter()]
    [switch]$Fix
)

$repoRoot = Split-Path -Path $PSScriptRoot -Parent
$lintScript = Join-Path -Path $PSScriptRoot -ChildPath 'Lint-Module.ps1'
$parameters = @{
    TreatWarningsAsErrors = $true
    Fix                   = $Fix
}
$parameters.SettingsPath = if ($PSBoundParameters.ContainsKey('SettingsPath')) {
    $SettingsPath
}
else {
    Join-Path -Path $repoRoot -ChildPath 'PSScriptAnalyzerSettings.psd1'
}
if ($PSBoundParameters.ContainsKey('SourcePath')) {
    $parameters.Path = $SourcePath
}

& $lintScript @parameters
