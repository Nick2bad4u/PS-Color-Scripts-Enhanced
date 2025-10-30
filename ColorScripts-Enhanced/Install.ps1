# ColorScripts-Enhanced Installation Script

[CmdletBinding(SupportsShouldProcess = $true)]
param(
    [switch]$AllUsers,
    [switch]$AddToProfile,
    [switch]$SkipStartupScript,
    [switch]$BuildCache
)

function Get-ModuleInstallRoot {
    [CmdletBinding()]
    param(
        [switch]$AllUsersScope
    )

    $separator = [System.IO.Path]::PathSeparator
    $paths = $env:PSModulePath -split [System.Text.RegularExpressions.Regex]::Escape($separator) | Where-Object { $_ }

    if ($AllUsersScope) {
        if ($PROFILE.AllUsersAllHosts) {
            return Split-Path -Parent $PROFILE.AllUsersAllHosts
        }

        return $paths | Where-Object { $_ -notlike "*$HOME*" } | Select-Object -First 1
    }

    if ($PROFILE.CurrentUserAllHosts) {
        return Split-Path -Parent $PROFILE.CurrentUserAllHosts
    }

    $userHome = [Environment]::GetFolderPath('UserProfile')
    if (-not $userHome) {
        $userHome = $HOME
    }

    return $paths | Where-Object { $userHome -and $_ -like "$userHome*" } | Select-Object -First 1
}

$moduleRoot = Get-ModuleInstallRoot -AllUsersScope:$AllUsers
if (-not $moduleRoot) {
    throw 'Unable to determine module installation path.'
}

if ($AllUsers -and $PSVersionTable.PSEdition -eq 'Desktop') {
    $principal = New-Object Security.Principal.WindowsPrincipal([Security.Principal.WindowsIdentity]::GetCurrent())
    if (-not $principal.IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) {
        throw 'AllUsers installation requires Administrator privileges.'
    }
}

$destinationPath = Join-Path -Path $moduleRoot -ChildPath 'ColorScripts-Enhanced'
$sourcePath = $PSScriptRoot

Write-Host ''
Write-Host '========================================================' -ForegroundColor Cyan
Write-Host '  ColorScripts-Enhanced Module Installation' -ForegroundColor Cyan
Write-Host '========================================================' -ForegroundColor Cyan

$originalErrorActionPreference = $ErrorActionPreference
$ErrorActionPreference = 'Stop'

try {
    if (-not (Test-Path -LiteralPath $moduleRoot)) {
        if ($PSCmdlet.ShouldProcess($moduleRoot, 'Create module directory')) {
            New-Item -Path $moduleRoot -ItemType Directory -Force | Out-Null
            Write-Host '✓ Created module directory' -ForegroundColor Green
        }
    }

    if (Test-Path -LiteralPath $destinationPath) {
        if ($PSCmdlet.ShouldProcess($destinationPath, 'Remove existing module')) {
            Remove-Item -LiteralPath $destinationPath -Recurse -Force
            Write-Host '✓ Removed existing module' -ForegroundColor Yellow
        }
    }

    if ($PSCmdlet.ShouldProcess($destinationPath, 'Copy module files')) {
        Copy-Item -Path $sourcePath -Destination $destinationPath -Recurse -Force
        Write-Host '✓ Module files copied' -ForegroundColor Green
    }

    if ($PSCmdlet.ShouldProcess($destinationPath, 'Import module')) {
        Import-Module (Join-Path -Path $destinationPath -ChildPath 'ColorScripts-Enhanced.psd1') -Force
        Write-Host '✓ Module imported successfully' -ForegroundColor Green
    }

    $profileResult = $null
    if ($AddToProfile) {
        $profileArguments = @{ Scope = 'CurrentUserAllHosts' }
        if ($SkipStartupScript) {
            $profileArguments.SkipStartupScript = $true
        }

        if ($PSCmdlet.ShouldProcess($PROFILE.CurrentUserAllHosts, 'Update profile')) {
            $profileResult = Add-ColorScriptProfile @profileArguments
            if ($profileResult.Changed) {
                Write-Host "✓ Profile updated: $($profileResult.Path)" -ForegroundColor Green
            }
            else {
                Write-Host 'Profile already configured. Use -Force with Add-ColorScriptProfile to overwrite.' -ForegroundColor Yellow
            }
        }
    }

    $cacheResults = @()
    if ($BuildCache) {
        if ($PSCmdlet.ShouldProcess('ColorScripts-Enhanced cache', 'Build caches for all scripts')) {
            Write-Host ''
            Write-Host 'Building cache for all colorscripts...' -ForegroundColor Cyan
            $cacheResults = New-ColorScriptCache -ErrorAction Stop
            $successCount = ($cacheResults | Where-Object { $_.Status -in @('Updated', 'SkippedUpToDate') }).Count
            $failureCount = ($cacheResults | Where-Object { $_.Status -eq 'Failed' }).Count
            Write-Host "  Updated: $successCount" -ForegroundColor Green
            if ($failureCount) {
                Write-Host "  Failed:  $failureCount" -ForegroundColor Red
            }
        }
    }

    Write-Host ''
    Write-Host "[INFO] Source:      $sourcePath" -ForegroundColor Yellow
    Write-Host "[INFO] Destination: $destinationPath" -ForegroundColor Yellow
    Write-Host "[INFO] Scope:       $(if ($AllUsers) { 'AllUsers' } else { 'CurrentUser' })" -ForegroundColor Yellow

    Write-Host ''
    Write-Host 'ColorScripts-Enhanced installed successfully!' -ForegroundColor Green
    Write-Host 'Quick start:' -ForegroundColor Yellow
    Write-Host '  Show-ColorScript             # Display a random colorscript'
    Write-Host '  scs mandelbrot-zoom          # Display a specific colorscript'
    Write-Host '  Get-ColorScriptList          # List all scripts'
    Write-Host '  New-ColorScriptCache         # Pre-build caches (defaults to all)'

    if (-not $BuildCache) {
        Write-Host "Tip: Run 'New-ColorScriptCache' to prime caches (equivalent to -All)." -ForegroundColor Cyan
    }

    [pscustomobject]@{
        SourcePath      = $sourcePath
        DestinationPath = $destinationPath
        Scope           = if ($AllUsers) { 'AllUsers' } else { 'CurrentUser' }
        ProfileResult   = $profileResult
        CacheResults    = $cacheResults
    }
}
finally {
    $ErrorActionPreference = $originalErrorActionPreference
}
