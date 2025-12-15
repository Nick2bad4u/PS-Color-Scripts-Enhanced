function Get-ColorScriptsConfigurationRoot {
    param(
        [switch]$NoCreate
    )

    if ($script:ConfigurationRoot) {
        # The configuration directory can be deleted between calls (especially in tests that
        # use transient temp roots). If the cached directory no longer exists, clear the cache
        # and resolve/create again.
        try {
            if (Test-Path -LiteralPath $script:ConfigurationRoot -PathType Container) {
                return $script:ConfigurationRoot
            }
        }
        catch {
            Write-Verbose ("Cached configuration root validation failed: {0}" -f $_.Exception.Message)
        }

        $script:ConfigurationRoot = $null
    }

    $candidates = @()

    $overrideRoot = $env:COLOR_SCRIPTS_ENHANCED_CONFIG_ROOT
    if (-not [string]::IsNullOrWhiteSpace($overrideRoot)) {
        $candidates += $overrideRoot
    }

    if ($script:IsWindows -or $PSVersionTable.PSVersion.Major -le 5) {
        if ($env:APPDATA) {
            $candidates += (Join-Path -Path $env:APPDATA -ChildPath 'ColorScripts-Enhanced')
        }
    }
    elseif ($script:IsMacOS) {
        $macBase = Join-Path -Path $HOME -ChildPath 'Library'
        $macBase = Join-Path -Path $macBase -ChildPath 'Application Support'
        $candidates += (Join-Path -Path $macBase -ChildPath 'ColorScripts-Enhanced')
    }
    else {
        $xdgConfig = if ($env:XDG_CONFIG_HOME) { $env:XDG_CONFIG_HOME } else { Join-Path -Path $HOME -ChildPath '.config' }
        if (-not [string]::IsNullOrWhiteSpace($xdgConfig)) {
            $candidates += (Join-Path -Path $xdgConfig -ChildPath 'ColorScripts-Enhanced')
        }
    }

    if ($candidates.Count -eq 0) {
        $candidates = @([System.IO.Path]::Combine([System.IO.Path]::GetTempPath(), 'ColorScripts-Enhanced'))
    }

    $candidates = @($candidates | Where-Object { -not [string]::IsNullOrWhiteSpace($_) })

    if ($NoCreate) {
        foreach ($candidate in $candidates) {
            $resolvedCandidate = $null
            try {
                $resolvedCandidate = Resolve-CachePath -Path $candidate
            }
            catch {
                Write-Verbose ("Configuration root probe resolution failed for '{0}': {1}" -f $candidate, $_.Exception.Message)
                $resolvedCandidate = $null
            }

            if (-not $resolvedCandidate) {
                continue
            }

            if (Test-Path -LiteralPath $resolvedCandidate -PathType Container) {
                try {
                    $resolvedCandidate = (Resolve-Path -LiteralPath $resolvedCandidate -ErrorAction Stop).ProviderPath
                }
                catch {
                    Write-Verbose ("Configuration root probe path normalization failed for '{0}': {1}" -f $resolvedCandidate, $_.Exception.Message)
                }

                # Important: do not cache $script:ConfigurationRoot in probe mode.
                # Tests (and some callers) use transient temp roots which may be deleted later.
                return $resolvedCandidate
            }
        }

        return $null
    }

    $createDirectoryAction = {
        param($path)

        if ($script:CreateDirectoryDelegate) {
            $null = & $script:CreateDirectoryDelegate $path
        }
        else {
            New-Item -ItemType Directory -Path $path -Force -ErrorAction Stop | Out-Null
        }
    }

    $onCreateFailure = {
        param($target, $errorRecord)
        $message = if ($errorRecord -and $errorRecord.Exception) { $errorRecord.Exception.Message } elseif ($errorRecord) { $errorRecord.ToString() } else { 'unknown reason' }
        Write-Verbose ("Unable to prepare configuration directory '{0}': {1}" -f $target, $message)
    }

    $resolvedRoot = Resolve-PreferredDirectoryCandidate -CandidatePaths $candidates -CreateDirectory $createDirectoryAction -OnCreateFailure $onCreateFailure

    if ($resolvedRoot) {
        $script:ConfigurationRoot = $resolvedRoot
        return $script:ConfigurationRoot
    }

    Invoke-ColorScriptError -Message $script:Messages.UnableToDetermineConfigurationDirectory -ErrorId 'ColorScriptsEnhanced.ConfigurationRootUnavailable' -Category ([System.Management.Automation.ErrorCategory]::ResourceUnavailable)
}
