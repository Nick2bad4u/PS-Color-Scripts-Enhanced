function Resolve-CachePath {
    param(
        [string]$Path
    )

    if ([string]::IsNullOrWhiteSpace($Path)) {
        return $null
    }

    $expanded = [System.Environment]::ExpandEnvironmentVariables($Path)

    $homeDirectory = $null
    try {
        $homeDirectory = & $script:GetUserProfilePathDelegate
    }
    catch {
        $homeDirectory = $null
    }

    if (-not $homeDirectory) {
        $homeDirectory = $HOME
    }

    if ($expanded -and $expanded.StartsWith('~') -and $homeDirectory) {
        if ($expanded.Length -eq 1) {
            $expanded = $homeDirectory
        }
        elseif ($expanded.Length -gt 1 -and ($expanded[1] -eq '/' -or $expanded[1] -eq [char]92)) {
            $relativeSegment = $expanded.Substring(2)
            $expanded = if ($relativeSegment) {
                Join-Path -Path $homeDirectory -ChildPath $relativeSegment
            }
            else {
                $homeDirectory
            }
        }
    }

    $candidate = $expanded

    $qualifier = $null
    try {
        $qualifier = Split-Path -Path $expanded -Qualifier -ErrorAction Stop
    }
    catch {
        $qualifier = $null
    }

    if ($qualifier -and $qualifier -notlike '\\*') {
        $driveName = $qualifier.TrimEnd(':', '\')
        if (-not (Get-PSDrive -Name $driveName -ErrorAction SilentlyContinue)) {
            return $null
        }
    }

    $isRooted = $false
    try {
        $isRooted = & $script:IsPathRootedDelegate $expanded
    }
    catch {
        Write-Verbose "Unable to evaluate rooted state for cache path '$expanded': $($_.Exception.Message)"
        return $null
    }

    if (-not $isRooted) {
        $basePath = $null

        try {
            $basePath = & $script:GetCurrentProviderPathDelegate
        }
        catch {
            $basePath = $null
        }

        if (-not $basePath) {
            try {
                $basePath = & $script:GetCurrentDirectoryDelegate
            }
            catch {
                $basePath = $null
            }
        }

        if (-not $basePath) {
            return $null
        }

        $candidate = Join-Path -Path $basePath -ChildPath $expanded
    }

    try {
        return & $script:GetFullPathDelegate $candidate
    }
    catch {
        Write-Verbose "Unable to resolve cache path '$Path': $($_.Exception.Message)"
        return $null
    }
}
