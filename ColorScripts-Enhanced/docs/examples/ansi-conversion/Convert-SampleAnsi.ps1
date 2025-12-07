[CmdletBinding()]
param(
    [Parameter()]
    [string]$AnsiPath = './assets/ansi-files/DEL-FLAG.ANS',

    [Parameter()]
    [string]$OutputPath = './dist/examples/DEL-FLAG.ps1'
)

$scriptRoot = Split-Path -Path $MyInvocation.MyCommand.Path -Parent
$repoRoot = [System.IO.Path]::GetFullPath((Join-Path -Path $scriptRoot -ChildPath '..'))
$repoRoot = [System.IO.Path]::GetFullPath((Join-Path -Path $repoRoot -ChildPath '..'))
$ansiFull = Resolve-Path -LiteralPath (Join-Path -Path $repoRoot -ChildPath $AnsiPath)
$outputFull = Join-Path -Path $repoRoot -ChildPath $OutputPath

$node = Get-Command node -ErrorAction SilentlyContinue
if (-not $node) {
    throw 'Node.js is required to run Convert-AnsiToColorScript.js. Install Node 18+ and re-run this script.'
}

$outputDirectory = Split-Path -Path $outputFull -Parent
if (-not (Test-Path -LiteralPath $outputDirectory)) {
    New-Item -ItemType Directory -Path $outputDirectory -Force | Out-Null
}

$converter = Join-Path -Path $repoRoot -ChildPath 'scripts\Convert-AnsiToColorScript.js'
if (-not (Test-Path -LiteralPath $converter)) {
    throw "Converter not found at '$converter'. Run this script from the repository workspace."
}

Write-Host "Converting $ansiFull to $outputFull" -ForegroundColor Cyan

& $node.Source $converter $ansiFull '--output' $outputFull '--encoding' 'utf8'
if ($LASTEXITCODE -ne 0) {
    throw "Conversion failed with exit code $LASTEXITCODE."
}

Write-Host '✓ Conversion complete. Preview the generated script with Show-ColorScript or the Test-All harness.' -ForegroundColor Green
