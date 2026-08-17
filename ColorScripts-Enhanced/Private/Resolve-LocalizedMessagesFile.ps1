function Resolve-LocalizedMessageBaseDirectory {
    param(
        [Parameter(Mandatory)]
        [string]$BaseDirectory
    )

    try {
        return (Resolve-Path -LiteralPath $BaseDirectory -ErrorAction Stop).ProviderPath
    }
    catch {
        Write-ModuleTrace ("Resolve-LocalizedMessagesFile base resolution failed for '{0}': {1}" -f $BaseDirectory, $_.Exception.Message)
        return $BaseDirectory
    }
}

function Test-ColorScriptDirectoryExistence {
    param(
        [Parameter(Mandatory)]
        [string]$Path
    )

    try {
        if (Test-Path -LiteralPath $Path -PathType Container) {
            return $true
        }
    }
    catch {
        Write-ModuleTrace ("Directory existence probe failed for '{0}': {1}" -f $Path, $_.Exception.Message)
    }

    return [System.IO.Directory]::Exists($Path)
}

function Add-LocalizedCultureCandidate {
    param(
        [Parameter(Mandatory)]
        [AllowEmptyCollection()]
        [System.Collections.Generic.List[string]]$Destination,

        [AllowNull()]
        [string]$CultureName
    )

    if (-not [string]::IsNullOrWhiteSpace($CultureName) -and -not $Destination.Contains($CultureName)) {
        [void]$Destination.Add($CultureName)
    }
}

function Get-LocalizedCultureCandidate {
    param(
        [AllowNull()]
        [string[]]$CultureFallback
    )

    $candidateCultures = New-Object 'System.Collections.Generic.List[string]'
    if ($CultureFallback -and $CultureFallback.Count -gt 0) {
        foreach ($culture in $CultureFallback) {
            Add-LocalizedCultureCandidate -Destination $candidateCultures -CultureName $culture
        }
        return $candidateCultures.ToArray()
    }

    try {
        $currentCulture = [System.Globalization.CultureInfo]::CurrentUICulture
        Add-LocalizedCultureCandidate -Destination $candidateCultures -CultureName $currentCulture.Name
        Add-LocalizedCultureCandidate -Destination $candidateCultures -CultureName $currentCulture.Parent.Name
    }
    catch {
        Write-ModuleTrace ("Resolve-LocalizedMessagesFile culture discovery failed: {0}" -f $_.Exception.Message)
    }

    return $candidateCultures.ToArray()
}

function Resolve-LocalizedCultureDirectory {
    param(
        [Parameter(Mandatory)]
        [string]$BaseDirectory,

        [Parameter(Mandatory)]
        [string]$CultureName
    )

    $culturePath = Join-Path -Path $BaseDirectory -ChildPath $CultureName
    if (Test-ColorScriptDirectoryExistence -Path $culturePath) {
        return $culturePath
    }

    try {
        foreach ($directory in Get-ChildItem -LiteralPath $BaseDirectory -Directory -ErrorAction Stop) {
            if ([System.String]::Equals($directory.Name, $CultureName, [System.StringComparison]::OrdinalIgnoreCase)) {
                return $directory.FullName
            }
        }
    }
    catch {
        Write-ModuleTrace ("Resolve-LocalizedMessagesFile directory enumeration failed for '{0}': {1}" -f $CultureName, $_.Exception.Message)
    }

    return $null
}

function New-LocalizedMessageFileCandidate {
    param(
        [Parameter(Mandatory)]
        [string]$BaseDirectory,

        [Parameter(Mandatory)]
        [string]$FileName,

        [AllowNull()]
        [string[]]$CultureName
    )

    $candidates = New-Object 'System.Collections.Generic.List[object]'
    foreach ($culture in $CultureName) {
        if ([string]::IsNullOrWhiteSpace($culture)) {
            continue
        }

        $culturePath = Resolve-LocalizedCultureDirectory -BaseDirectory $BaseDirectory -CultureName $culture
        if ($culturePath -and (Test-ColorScriptDirectoryExistence -Path $culturePath)) {
            [void]$candidates.Add([pscustomobject]@{
                    CultureName = $culture
                    FilePath    = Join-Path -Path $culturePath -ChildPath $FileName
                })
        }
    }

    [void]$candidates.Add([pscustomobject]@{
            CultureName = $null
            FilePath    = Join-Path -Path $BaseDirectory -ChildPath $FileName
        })
    return $candidates.ToArray()
}

function Test-ColorScriptFileExistence {
    param(
        [Parameter(Mandatory)]
        [string]$Path
    )

    if (Test-Path -LiteralPath $Path -PathType Leaf) {
        return $true
    }

    try {
        if ([System.IO.File]::Exists($Path)) {
            return $true
        }
    }
    catch {
        Write-ModuleTrace ("File existence probe failed for '{0}': {1}" -f $Path, $_.Exception.Message)
    }

    return Test-Path -LiteralPath $Path -PathType Leaf
}

function Resolve-LocalizedMessageFileCandidate {
    param(
        [Parameter(Mandatory)]
        [object[]]$Candidate
    )

    foreach ($item in $Candidate) {
        if (-not $item.FilePath -or -not (Test-ColorScriptFileExistence -Path $item.FilePath)) {
            continue
        }

        $candidatePath = $item.FilePath
        try {
            $candidatePath = (Resolve-Path -LiteralPath $candidatePath -ErrorAction Stop).ProviderPath
        }
        catch {
            Write-ModuleTrace ("Resolve-LocalizedMessagesFile path resolution failed for '{0}': {1}" -f $item.FilePath, $_.Exception.Message)
        }

        return [pscustomobject]@{
            FilePath    = $candidatePath
            CultureName = $item.CultureName
        }
    }

    return $null
}

function Resolve-LocalizedMessagesFile {
    param(
        [Parameter(Mandatory)]
        [ValidateNotNullOrEmpty()]
        [string]$BaseDirectory,

        [Parameter()]
        [ValidateNotNullOrEmpty()]
        [string]$FileName = 'Messages.psd1',

        [Parameter()]
        [string[]]$CultureFallback
    )

    $resolvedBase = Resolve-LocalizedMessageBaseDirectory -BaseDirectory $BaseDirectory
    if (-not (Test-ColorScriptDirectoryExistence -Path $resolvedBase)) {
        return $null
    }

    $candidateCultures = @(Get-LocalizedCultureCandidate -CultureFallback $CultureFallback)
    $candidates = @(New-LocalizedMessageFileCandidate -BaseDirectory $resolvedBase -FileName $FileName -CultureName $candidateCultures)
    return Resolve-LocalizedMessageFileCandidate -Candidate $candidates
}
