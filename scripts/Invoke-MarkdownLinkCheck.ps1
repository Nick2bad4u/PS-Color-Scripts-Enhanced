<#
.SYNOPSIS
    Run markdown-link-check across repository markdown files.

.DESCRIPTION
    Uses npx to run markdown-link-check@3.12.2 against every Markdown file in the repository,
    excluding node_modules and the .git directory. The script honours the optional configuration
    file specified via -ConfigPath (defaults to ./.markdown-link-check.json).

.PARAMETER ConfigPath
    Optional path to the markdown-link-check configuration file.

.PARAMETER Paths
    One or more markdown files to validate. When omitted the script scans the repository recursively.

.EXAMPLE
    pwsh -NoProfile -File ./scripts/Invoke-MarkdownLinkCheck.ps1

.EXAMPLE
    pwsh -NoProfile -File ./scripts/Invoke-MarkdownLinkCheck.ps1 -Paths docs/README.md
#>

[CmdletBinding()]
param(
    [Parameter()]
    [string]$ConfigPath = '.markdown-link-check.json',

    [Parameter()]
    [string[]]$Paths
)

$scriptRoot = Split-Path -Parent $MyInvocation.MyCommand.Path
$repoRoot = Resolve-Path -LiteralPath (Join-Path -Path $scriptRoot -ChildPath '..')

function Resolve-ScanPath {
    param([string]$Path)

    if ([string]::IsNullOrWhiteSpace($Path)) {
        return $null
    }

    $expanded = [System.Environment]::ExpandEnvironmentVariables($Path)
    if ($expanded.StartsWith('~')) {
        $userHome = [System.Environment]::GetFolderPath('UserProfile')
        if (-not $userHome) {
            $userHome = $HOME
        }

        if ($expanded.Length -eq 1) {
            $expanded = $userHome
        }
        elseif ($expanded.Length -gt 1 -and ($expanded[1] -eq '/' -or $expanded[1] -eq '\')) {
            $expanded = Join-Path -Path $userHome -ChildPath $expanded.Substring(2)
        }
    }

    if (-not [System.IO.Path]::IsPathRooted($expanded)) {
        $expanded = Join-Path -Path $repoRoot -ChildPath $expanded
    }

    return [System.IO.Path]::GetFullPath($expanded)
}

$resolvedConfig = $null
if ($ConfigPath) {
    $resolvedConfig = Resolve-ScanPath -Path $ConfigPath
    if (-not (Test-Path -LiteralPath $resolvedConfig)) {
        Write-Warning "markdown-link-check config not found at '$resolvedConfig'. Proceeding with defaults."
        $resolvedConfig = $null
    }
}

if (-not $Paths) {
    $Paths = Get-ChildItem -Path $repoRoot -Filter '*.md' -File -Recurse | Where-Object {
        $relativePath = $_.FullName.Substring($repoRoot.Path.Length)
        $relativePath -notmatch '^[\\/]node_modules[\\/]' -and
        $relativePath -notmatch '^[\\/]\.git[\\/]' -and
        $relativePath -notmatch '^[\\/]dist[\\/]' -and
        $relativePath -notmatch '^[\\/]\.vscode[\\/]' -and
        $relativePath -notmatch '^[\\/]\.idea[\\/]' -and
        $relativePath -notmatch '^[\\/]\.github[\\/]' -and
        $relativePath -notmatch '^[\\/]Invoke-MarkdownLinkCheck.ps1[\\/]'
    } | Select-Object -ExpandProperty FullName
}
else {
    $Paths = $Paths | ForEach-Object { Resolve-ScanPath -Path $_ }
}

if (-not $Paths) {
    Write-Host 'No markdown files found.'
    return
}

foreach ($file in $Paths) {
    if (-not (Test-Path -LiteralPath $file)) {
        Write-Warning "Skipping missing file $file"
        continue
    }

    $arguments = @('--yes', 'markdown-link-check@3.12.2')
    if ($resolvedConfig) {
        $arguments += '-c'
        $arguments += $resolvedConfig
    }
    $arguments += $file

    Write-Host "🔗 Checking $file" -ForegroundColor Cyan

    # Suppress Node.js deprecation warnings
    $env:NODE_NO_WARNINGS = '1'
    & npx @arguments
    $exitCode = $LASTEXITCODE
    Remove-Item Env:\NODE_NO_WARNINGS -ErrorAction SilentlyContinue

    if ($exitCode -ne 0) {
        throw "markdown-link-check reported failures for '$file'."
    }
}

Write-Host '✅ Markdown links validated.' -ForegroundColor Green
