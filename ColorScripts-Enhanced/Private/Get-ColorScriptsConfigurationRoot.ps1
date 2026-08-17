function Get-CachedColorScriptsConfigurationRoot {
    if (-not $script:ConfigurationRoot) {
        return $null
    }

    try {
        if (Test-Path -LiteralPath $script:ConfigurationRoot -PathType Container) {
            return $script:ConfigurationRoot
        }
    }
    catch {
        Write-Verbose ("Cached configuration root validation failed: {0}" -f $_.Exception.Message)
    }

    $script:ConfigurationRoot = $null
    return $null
}

function Get-ColorScriptsConfigurationRootCandidate {
    $candidates = New-Object 'System.Collections.Generic.List[string]'
    $overrideRoot = $env:COLOR_SCRIPTS_ENHANCED_CONFIG_ROOT
    if (-not [string]::IsNullOrWhiteSpace($overrideRoot)) {
        [void]$candidates.Add($overrideRoot)
    }

    if ($script:IsWindows -or $PSVersionTable.PSVersion.Major -le 5) {
        if ($env:APPDATA) {
            [void]$candidates.Add((Join-Path -Path $env:APPDATA -ChildPath 'ColorScripts-Enhanced'))
        }
    }
    elseif ($script:IsMacOS) {
        $macBase = Join-Path -Path $HOME -ChildPath 'Library'
        $macBase = Join-Path -Path $macBase -ChildPath 'Application Support'
        [void]$candidates.Add((Join-Path -Path $macBase -ChildPath 'ColorScripts-Enhanced'))
    }
    else {
        $xdgConfig = if ($env:XDG_CONFIG_HOME) {
            $env:XDG_CONFIG_HOME
        }
        else {
            Join-Path -Path $HOME -ChildPath '.config'
        }
        if (-not [string]::IsNullOrWhiteSpace($xdgConfig)) {
            [void]$candidates.Add((Join-Path -Path $xdgConfig -ChildPath 'ColorScripts-Enhanced'))
        }
    }

    if ($candidates.Count -eq 0) {
        [void]$candidates.Add([System.IO.Path]::Combine([System.IO.Path]::GetTempPath(), 'ColorScripts-Enhanced'))
    }

    return @($candidates | Where-Object { -not [string]::IsNullOrWhiteSpace($_) })
}

function Resolve-ColorScriptsConfigurationRootProbe {
    param(
        [Parameter(Mandatory)]
        [string[]]$Candidate
    )

    foreach ($item in $Candidate) {
        try {
            $resolvedCandidate = Resolve-CachePath -Path $item
        }
        catch {
            Write-Verbose ("Configuration root probe resolution failed for '{0}': {1}" -f $item, $_.Exception.Message)
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
        }

        # Preserve candidate priority even when the preferred location does not yet
        # exist. Probe mode reports where a later approved write will occur.
        return $resolvedCandidate
    }

    return $null
}

function New-ColorScriptsConfigurationDirectory {
    param(
        [Parameter(Mandatory)]
        [string]$Path
    )

    if ($script:CreateDirectoryDelegate) {
        $null = & $script:CreateDirectoryDelegate $Path
        return
    }

    New-Item -ItemType Directory -Path $Path -Force -ErrorAction Stop | Out-Null
}

function Write-ColorScriptsConfigurationDirectoryFailure {
    param(
        [Parameter(Mandatory)]
        [string]$Target,

        [AllowNull()]
        [object]$ErrorRecord
    )

    $message = if ($ErrorRecord -and $ErrorRecord.Exception) {
        $ErrorRecord.Exception.Message
    }
    elseif ($ErrorRecord) {
        $ErrorRecord.ToString()
    }
    else {
        'unknown reason'
    }
    Write-Verbose ("Unable to prepare configuration directory '{0}': {1}" -f $Target, $message)
}

function Get-ColorScriptsConfigurationRoot {
    param(
        [switch]$NoCreate
    )

    $cachedRoot = Get-CachedColorScriptsConfigurationRoot
    if ($cachedRoot) {
        return $cachedRoot
    }

    $candidates = @(Get-ColorScriptsConfigurationRootCandidate)
    if ($NoCreate) {
        return Resolve-ColorScriptsConfigurationRootProbe -Candidate $candidates
    }

    $createDirectoryAction = {
        param($path)
        New-ColorScriptsConfigurationDirectory -Path $path
    }
    $onCreateFailure = {
        param($target, $errorRecord)
        Write-ColorScriptsConfigurationDirectoryFailure -Target $target -ErrorRecord $errorRecord
    }

    $resolvedRoot = Resolve-PreferredDirectoryCandidate -CandidatePaths $candidates -CreateDirectory $createDirectoryAction -OnCreateFailure $onCreateFailure
    if ($resolvedRoot) {
        $script:ConfigurationRoot = $resolvedRoot
        return $script:ConfigurationRoot
    }

    Invoke-ColorScriptError -Message $script:Messages.UnableToDetermineConfigurationDirectory -ErrorId 'ColorScriptsEnhanced.ConfigurationRootUnavailable' -Category ([System.Management.Automation.ErrorCategory]::ResourceUnavailable)
}
