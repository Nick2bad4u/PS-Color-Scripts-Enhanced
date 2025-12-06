[CmdletBinding()]
param(
    [Parameter()]
    [string]$AnsiPath = './assets/ansi-files/we-ACiDTrip.ANS',

    [Parameter()]
    [int]$Every = 160,

    [Parameter()]
    [string]$OutputDirectory = './dist/examples/we-ACiDTrip'
)

$scriptRoot = Split-Path -Parent $MyInvocation.MyCommand.Path
$repoRoot = [System.IO.Path]::GetFullPath((Join-Path -Path $scriptRoot -ChildPath '..'))
$repoRoot = [System.IO.Path]::GetFullPath((Join-Path -Path $repoRoot -ChildPath '..'))

$ansiFull = Resolve-Path -LiteralPath (Join-Path -Path $repoRoot -ChildPath $AnsiPath)
$splitter = Join-Path -Path $repoRoot -ChildPath 'scripts/Split-AnsiFile.js'
if (-not (Test-Path -LiteralPath $splitter)) {
    throw "Splitter not found at '$splitter'."
}

$node = Get-Command node -ErrorAction SilentlyContinue
if (-not $node) {
    throw 'Node.js is required to run Split-AnsiFile.js. Install Node 18+ and re-run this script.'
}

$outDir = Join-Path -Path $repoRoot -ChildPath $OutputDirectory
if (-not (Test-Path -LiteralPath $outDir)) {
    New-Item -ItemType Directory -Path $outDir -Force | Out-Null
}

Write-Host "Splitting $ansiFull into $outDir (every $Every rows, auto break detection enabled)" -ForegroundColor Cyan

$arguments = @(
    $ansiFull,
    '--every', $Every,
    '--auto',
    '--output', $outDir
)

& $node.Source $splitter @arguments
if ($LASTEXITCODE -ne 0) {
    throw "Split failed with exit code $LASTEXITCODE."
}

Write-Host "✓ Slices written to $outDir" -ForegroundColor Green
Write-Host 'Convert each slice with Convert-AnsiToColorScript.js or the companion sample script.'
