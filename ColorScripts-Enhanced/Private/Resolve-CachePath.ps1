function Get-ColorScriptUserProfilePath {
    try {
        $profilePath = & $script:GetUserProfilePathDelegate
    }
    catch {
        $profilePath = $null
    }

    if ($profilePath) {
        return $profilePath
    }

    return $HOME
}

function Expand-ColorScriptHomePath {
    param(
        [Parameter(Mandatory)]
        [string]$Path,

        [AllowNull()]
        [string]$HomeDirectory
    )

    if (-not $HomeDirectory -or -not $Path.StartsWith('~')) {
        return $Path
    }

    if ($Path.Length -eq 1) {
        return $HomeDirectory
    }

    if ($Path[1] -ne '/' -and $Path[1] -ne [char]92) {
        return $Path
    }

    $relativeSegment = $Path.Substring(2)
    if (-not $relativeSegment) {
        return $HomeDirectory
    }

    return Join-Path -Path $HomeDirectory -ChildPath $relativeSegment
}

function Test-ColorScriptPathQualifier {
    param(
        [Parameter(Mandatory)]
        [string]$Path
    )

    try {
        $qualifier = Split-Path -Path $Path -Qualifier -ErrorAction Stop
    }
    catch {
        return $true
    }

    if (-not $qualifier -or $qualifier -like '\\*') {
        return $true
    }

    $driveName = $qualifier.TrimEnd(':', '\')
    return $null -ne (Get-PSDrive -Name $driveName -ErrorAction SilentlyContinue)
}

function Get-ColorScriptCurrentProviderPath {
    try {
        $basePath = & $script:GetCurrentProviderPathDelegate
    }
    catch {
        $basePath = $null
    }

    if ($basePath) {
        return $basePath
    }

    try {
        return & $script:GetCurrentDirectoryDelegate
    }
    catch {
        return $null
    }
}

function Resolve-CachePath {
    param(
        [string]$Path
    )

    if ([string]::IsNullOrWhiteSpace($Path)) {
        return $null
    }

    $expanded = [System.Environment]::ExpandEnvironmentVariables($Path)
    $expanded = Expand-ColorScriptHomePath -Path $expanded -HomeDirectory (Get-ColorScriptUserProfilePath)

    if (-not (Test-ColorScriptPathQualifier -Path $expanded)) {
        return $null
    }

    try {
        $isRooted = & $script:IsPathRootedDelegate $expanded
    }
    catch {
        Write-Verbose "Unable to evaluate rooted state for cache path '$expanded': $($_.Exception.Message)"
        return $null
    }

    $candidate = $expanded
    if (-not $isRooted) {
        $basePath = Get-ColorScriptCurrentProviderPath
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
