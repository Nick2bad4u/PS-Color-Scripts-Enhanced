<#
.SYNOPSIS
    Get the current count of colorscripts in the module.

.DESCRIPTION
    Returns the count of .ps1 files in the ColorScripts-Enhanced/Scripts directory.
    This utility is used by build scripts and documentation generation to ensure
    accurate script counts throughout the documentation.

.PARAMETER ScriptsPath
    Path to the Scripts directory. Defaults to ColorScripts-Enhanced/Scripts.

.EXAMPLE
    .\Get-ColorScriptCount.ps1
    Returns: 245

.EXAMPLE
    $count = .\Get-ColorScriptCount.ps1
    Write-Host "Total scripts: $count"

.OUTPUTS
    System.Int32
    The count of colorscript files.
#>
[CmdletBinding()]
param(
    [Parameter()]
    [string]$ScriptsPath = (Join-Path $PSScriptRoot 'ColorScripts-Enhanced\Scripts')
)

if (-not (Test-Path $ScriptsPath)) {
    Write-Error "Scripts path not found: $ScriptsPath"
    return 0
}

$scripts = Get-ChildItem -Path $ScriptsPath -Filter '*.ps1' -File
$count = $scripts.Count

Write-Verbose "Found $count colorscripts in: $ScriptsPath"
return $count
