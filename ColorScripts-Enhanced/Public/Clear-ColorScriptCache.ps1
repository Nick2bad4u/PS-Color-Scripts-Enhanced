function Clear-ColorScriptCache {
    [CmdletBinding(SupportsShouldProcess = $true, ConfirmImpact = 'Medium', HelpUri = 'https://nick2bad4u.github.io/PS-Color-Scripts-Enhanced/docs/help-redirect.html?cmdlet=Clear-ColorScriptCache')]
    param(
        [Alias('help')]
        [switch]$h,

        [switch]$Force,

        [switch]$PassThru
    )

    if ($h) {
        Show-ColorScriptHelp -CommandName 'Clear-ColorScriptCache'
        return
    }

    Initialize-CacheDirectory

    if (-not $script:CacheDir) {
        Write-Warning $script:Messages.CacheDirectoryUnavailable
        return
    }

    if (-not (Test-Path -LiteralPath $script:CacheDir)) {
        Write-Verbose $script:Messages.CacheDirectoryMissing
        return
    }

    $cacheFiles = Get-ChildItem -Path $script:CacheDir -Filter '*.cache' -File -ErrorAction SilentlyContinue

    if (-not $cacheFiles -or $cacheFiles.Count -eq 0) {
        Write-Verbose $script:Messages.CacheAlreadyEmpty
        return
    }

    if (-not $Force -and -not (Invoke-ShouldProcess -Cmdlet $PSCmdlet -Target $script:CacheDir -Action 'Clear colorscript cache')) {
        return
    }

    $removed = 0
    foreach ($file in $cacheFiles) {
        try {
            Remove-Item -LiteralPath $file.FullName -Force -ErrorAction Stop
            $removed++
        }
        catch {
            Write-Warning ($script:Messages.FailedToRemoveCacheFile -f $file.Name, $_.Exception.Message)
        }
    }

    if ($PassThru) {
        return [pscustomobject]@{
            RemovedCount = $removed
            CachePath    = $script:CacheDir
        }
    }

    Write-ColorScriptInformation -Message ($script:Messages.CacheFilesRemoved -f $removed) -Quiet:$false
}
