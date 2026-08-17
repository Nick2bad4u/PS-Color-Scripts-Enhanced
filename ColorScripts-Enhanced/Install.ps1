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
            return Split-Path -Path $PROFILE.AllUsersAllHosts -Parent
        }

        return $paths | Where-Object { $_ -notlike "*$HOME*" } | Select-Object -First 1
    }

    if ($PROFILE.CurrentUserAllHosts) {
        return Split-Path -Path $PROFILE.CurrentUserAllHosts -Parent
    }

    $userHome = [Environment]::GetFolderPath('UserProfile')
    if (-not $userHome) {
        $userHome = $HOME
    }

    return $paths | Where-Object { $userHome -and $_ -like "$userHome*" } | Select-Object -First 1
}

function Assert-ColorScriptsInstallPrivilege {
    param(
        [switch]$AllUsers
    )

    if (-not $AllUsers -or $PSVersionTable.PSEdition -ne 'Desktop' -or $WhatIfPreference) {
        return
    }

    $principal = New-Object Security.Principal.WindowsPrincipal([Security.Principal.WindowsIdentity]::GetCurrent())
    if (-not $principal.IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) {
        throw 'AllUsers installation requires Administrator privileges.'
    }
}

function Write-ColorScriptsInstallHeader {
    Write-Host ''
    Write-Host '========================================================' -ForegroundColor Cyan
    Write-Host '  ColorScripts-Enhanced Module Installation' -ForegroundColor Cyan
    Write-Host '========================================================' -ForegroundColor Cyan
}

function New-ColorScriptsInstallRoot {
    [CmdletBinding(SupportsShouldProcess = $true)]
    param(
        [Parameter(Mandatory)]
        [string]$Path,

        [Parameter(Mandatory)]
        [System.Management.Automation.PSCmdlet]$Cmdlet
    )

    if ((Test-Path -LiteralPath $Path) -or -not $Cmdlet.ShouldProcess($Path, 'Create module directory')) {
        return
    }

    New-Item -Path $Path -ItemType Directory -Force | Out-Null
    Write-Host '[OK] Created module directory' -ForegroundColor Green
}

function Remove-ColorScriptsInstallDirectoryWithRetry {
    param(
        [Parameter(Mandatory)]
        [string]$Path
    )

    $attempt = 0
    $maxAttempts = 5
    while ($attempt -lt $maxAttempts) {
        $attempt++
        try {
            Remove-Item -LiteralPath $Path -Recurse -Force -ErrorAction Stop
            return $true
        }
        catch [System.IO.IOException], [System.UnauthorizedAccessException] {
            Start-Sleep -Milliseconds (80 * $attempt)
        }
    }

    return $false
}

function Move-ColorScriptsInstallDirectoryAside {
    param(
        [Parameter(Mandatory)]
        [string]$Path
    )

    try {
        $backupPath = "{0}.old.{1}" -f $Path, ([guid]::NewGuid().ToString('N'))
        Move-Item -LiteralPath $Path -Destination $backupPath -Force -ErrorAction Stop
    }
    catch {
        Write-Warning ("Failed to remove existing module '{0}': {1}" -f $Path, $_.Exception.Message)
        return $false
    }

    try {
        Remove-Item -LiteralPath $backupPath -Recurse -Force -ErrorAction Stop
    }
    catch {
        Write-Warning ("Moved existing module to '{0}' but could not delete it: {1}" -f $backupPath, $_.Exception.Message)
    }

    return $true
}

function Remove-ExistingColorScriptsInstall {
    [CmdletBinding(SupportsShouldProcess = $true)]
    param(
        [Parameter(Mandatory)]
        [string]$Path,

        [Parameter(Mandatory)]
        [System.Management.Automation.PSCmdlet]$Cmdlet
    )

    if (-not (Test-Path -LiteralPath $Path) -or -not $Cmdlet.ShouldProcess($Path, 'Remove existing module')) {
        return
    }

    $removed = Remove-ColorScriptsInstallDirectoryWithRetry -Path $Path
    if (-not $removed) {
        $removed = Move-ColorScriptsInstallDirectoryAside -Path $Path
    }

    if ($removed) {
        Write-Host '[OK] Removed existing module' -ForegroundColor Yellow
    }
}

function Copy-AndImportColorScriptsInstall {
    [CmdletBinding(SupportsShouldProcess = $true)]
    param(
        [Parameter(Mandatory)]
        [string]$SourcePath,

        [Parameter(Mandatory)]
        [string]$DestinationPath,

        [Parameter(Mandatory)]
        [System.Management.Automation.PSCmdlet]$Cmdlet
    )

    if ($Cmdlet.ShouldProcess($DestinationPath, 'Copy module files')) {
        Copy-Item -Path $SourcePath -Destination $DestinationPath -Recurse -Force
        Write-Host '[OK] Module files copied' -ForegroundColor Green
    }

    if ($Cmdlet.ShouldProcess($DestinationPath, 'Import module')) {
        Import-Module (Join-Path -Path $DestinationPath -ChildPath 'ColorScripts-Enhanced.psd1') -Force
        Write-Host '[OK] Module imported successfully' -ForegroundColor Green
    }
}

function Add-ColorScriptsInstallProfile {
    [CmdletBinding(SupportsShouldProcess = $true)]
    param(
        [switch]$SkipStartupScript,

        [Parameter(Mandatory)]
        [System.Management.Automation.PSCmdlet]$Cmdlet
    )

    $profileArguments = @{ Scope = 'CurrentUserAllHosts' }
    if ($SkipStartupScript) {
        $profileArguments.SkipStartupScript = $true
    }

    if (-not $Cmdlet.ShouldProcess($PROFILE.CurrentUserAllHosts, 'Update profile')) {
        return $null
    }

    $profileResult = Add-ColorScriptProfile @profileArguments
    if ($profileResult.Changed) {
        Write-Host "[OK] Profile updated: $($profileResult.Path)" -ForegroundColor Green
    }
    else {
        Write-Host 'Profile already configured. Use -Force with Add-ColorScriptProfile to overwrite.' -ForegroundColor Yellow
    }

    return $profileResult
}

function New-ColorScriptsInstallCache {
    [CmdletBinding(SupportsShouldProcess = $true)]
    [OutputType([object[]])]
    param(
        [Parameter(Mandatory)]
        [System.Management.Automation.PSCmdlet]$Cmdlet
    )

    if (-not $Cmdlet.ShouldProcess('ColorScripts-Enhanced cache', 'Build caches for eligible scripts')) {
        return @()
    }

    Write-Host ''
    Write-Host 'Building cache for eligible colorscripts...' -ForegroundColor Cyan
    $cacheResults = @(New-ColorScriptCache -ErrorAction Stop)
    $successCount = @($cacheResults | Where-Object { $_.Status -in @('Updated', 'SkippedUpToDate') }).Count
    $failureCount = @($cacheResults | Where-Object { $_.Status -eq 'Failed' }).Count
    Write-Host "  Updated: $successCount" -ForegroundColor Green
    if ($failureCount) {
        Write-Host "  Failed:  $failureCount" -ForegroundColor Red
    }

    return $cacheResults
}

function Write-ColorScriptsInstallSummary {
    param(
        [Parameter(Mandatory)]
        [string]$SourcePath,

        [Parameter(Mandatory)]
        [string]$DestinationPath,

        [switch]$AllUsers,
        [switch]$BuildCache
    )

    $scope = if ($AllUsers) { 'AllUsers' } else { 'CurrentUser' }
    Write-Host ''
    Write-Host "[INFO] Source:      $SourcePath" -ForegroundColor Yellow
    Write-Host "[INFO] Destination: $DestinationPath" -ForegroundColor Yellow
    Write-Host "[INFO] Scope:       $scope" -ForegroundColor Yellow
    Write-Host ''
    Write-Host 'ColorScripts-Enhanced installed successfully!' -ForegroundColor Green
    Write-Host 'Quick start:' -ForegroundColor Yellow
    Write-Host '  Show-ColorScript             # Display a random colorscript'
    Write-Host '  scs mandelbrot-zoom          # Display a specific colorscript'
    Write-Host '  Get-ColorScriptList          # List all scripts'
    Write-Host '  New-ColorScriptCache         # Pre-build policy-selected caches'

    if (-not $BuildCache) {
        Write-Host "Tip: Run 'New-ColorScriptCache' to prime policy-selected computational renderers." -ForegroundColor Cyan
    }
}

function Invoke-ColorScriptsEnhancedInstall {
    [CmdletBinding(SupportsShouldProcess = $true)]
    param(
        [switch]$AllUsers,
        [switch]$AddToProfile,
        [switch]$SkipStartupScript,
        [switch]$BuildCache,

        [Parameter(Mandatory)]
        [ValidateNotNullOrEmpty()]
        [string]$SourcePath
    )

    $moduleRoot = Get-ModuleInstallRoot -AllUsersScope:$AllUsers
    if (-not $moduleRoot) {
        throw 'Unable to determine module installation path.'
    }

    Assert-ColorScriptsInstallPrivilege -AllUsers:$AllUsers
    $destinationPath = Join-Path -Path $moduleRoot -ChildPath 'ColorScripts-Enhanced'
    Write-ColorScriptsInstallHeader

    $originalErrorActionPreference = $ErrorActionPreference
    $ErrorActionPreference = 'Stop'
    try {
        New-ColorScriptsInstallRoot -Path $moduleRoot -Cmdlet $PSCmdlet
        Remove-ExistingColorScriptsInstall -Path $destinationPath -Cmdlet $PSCmdlet
        Copy-AndImportColorScriptsInstall -SourcePath $SourcePath -DestinationPath $destinationPath -Cmdlet $PSCmdlet

        $profileResult = if ($AddToProfile) {
            Add-ColorScriptsInstallProfile -SkipStartupScript:$SkipStartupScript -Cmdlet $PSCmdlet
        }
        else {
            $null
        }

        $cacheResults = if ($BuildCache) {
            @(New-ColorScriptsInstallCache -Cmdlet $PSCmdlet)
        }
        else {
            @()
        }

        Write-ColorScriptsInstallSummary -SourcePath $SourcePath -DestinationPath $destinationPath -AllUsers:$AllUsers -BuildCache:$BuildCache
        return [pscustomobject]@{
            SourcePath      = $SourcePath
            DestinationPath = $destinationPath
            Scope           = if ($AllUsers) { 'AllUsers' } else { 'CurrentUser' }
            ProfileResult   = $profileResult
            CacheResults    = $cacheResults
        }
    }
    finally {
        $ErrorActionPreference = $originalErrorActionPreference
    }
}

# If the script is dot-sourced (e.g., in tests), do not execute the install workflow.
# Note: In some hosts (including Pester execution contexts) $MyInvocation.InvocationName may not
# reliably report '.' for dot-sourced scripts, so we use multiple signals.
$isDotSourced = $false
try {
    if ($MyInvocation.InvocationName -eq '.') {
        $isDotSourced = $true
    }
    elseif ($MyInvocation.Line -and $MyInvocation.Line.TrimStart().StartsWith('.')) {
        $isDotSourced = $true
    }
    else {
        try {
            $frame = Get-PSCallStack | Select-Object -First 1
            if ($frame -and $frame.Command -and $frame.Command.TrimStart().StartsWith('.')) {
                $isDotSourced = $true
            }
        }
        catch {
            Write-Verbose ("Dot-source detection via call stack failed: {0}" -f $_.Exception.Message)
        }
    }
}
catch {
    $isDotSourced = $false
}

if (-not $isDotSourced) {
    Invoke-ColorScriptsEnhancedInstall -SourcePath $PSScriptRoot @PSBoundParameters
}
