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

    $resolvedBase = $BaseDirectory
    try {
        $resolvedBase = (Resolve-Path -LiteralPath $BaseDirectory -ErrorAction Stop).ProviderPath
    }
    catch {
        Write-ModuleTrace ("Resolve-LocalizedMessagesFile base resolution failed for '{0}': {1}" -f $BaseDirectory, $_.Exception.Message)
    }

    $baseExists = $false
    try {
        if (Test-Path -LiteralPath $resolvedBase -PathType Container) {
            $baseExists = $true
        }
    }
    catch {
        $baseExists = $false
    }

    if (-not $baseExists -and [System.IO.Directory]::Exists($resolvedBase)) {
        $baseExists = $true
    }

    if (-not $baseExists) {
        return $null
    }

    $candidateCultures = New-Object System.Collections.Generic.List[string]
    if ($CultureFallback -and $CultureFallback.Count -gt 0) {
        foreach ($culture in $CultureFallback) {
            if ([string]::IsNullOrWhiteSpace($culture)) { continue }
            if (-not $candidateCultures.Contains($culture)) {
                [void]$candidateCultures.Add($culture)
            }
        }
    }
    else {
        try {
            $currentCulture = [System.Globalization.CultureInfo]::CurrentUICulture
            if ($currentCulture -and $currentCulture.Name -and -not $candidateCultures.Contains($currentCulture.Name)) {
                [void]$candidateCultures.Add($currentCulture.Name)
            }

            $parentCulture = $currentCulture.Parent
            if ($parentCulture -and $parentCulture.Name -and -not $candidateCultures.Contains($parentCulture.Name)) {
                [void]$candidateCultures.Add($parentCulture.Name)
            }
        }
        catch {
            Write-ModuleTrace ("Resolve-LocalizedMessagesFile culture discovery failed: {0}" -f $_.Exception.Message)
        }
    }

    $candidates = New-Object System.Collections.Generic.List[pscustomobject]

    foreach ($cultureName in $candidateCultures) {
        if ([string]::IsNullOrWhiteSpace($cultureName)) { continue }
        $culturePath = Join-Path -Path $resolvedBase -ChildPath $cultureName
        $effectiveCulturePath = $null

        $cultureExists = $false
        try {
            if (Test-Path -LiteralPath $culturePath -PathType Container) {
                $cultureExists = $true
            }
        }
        catch {
            $cultureExists = $false
        }

        if (-not $cultureExists -and [System.IO.Directory]::Exists($culturePath)) {
            $cultureExists = $true
        }

        if ($cultureExists) {
            $effectiveCulturePath = $culturePath
        }
        else {
            try {
                $directories = Get-ChildItem -Path $resolvedBase -Directory -ErrorAction Stop
                $matched = $null
                foreach ($directory in $directories) {
                    if ([System.String]::Equals($directory.Name, $cultureName, [System.StringComparison]::OrdinalIgnoreCase)) {
                        $matched = $directory
                        break
                    }
                }

                if ($matched) {
                    $effectiveCulturePath = $matched.FullName
                }
            }
            catch {
                Write-ModuleTrace ("Resolve-LocalizedMessagesFile directory enumeration failed for '{0}': {1}" -f $cultureName, $_.Exception.Message)
            }
        }

        if ($effectiveCulturePath) {
            $effectiveExists = $false
            try {
                if (Test-Path -LiteralPath $effectiveCulturePath -PathType Container) {
                    $effectiveExists = $true
                }
            }
            catch {
                $effectiveExists = $false
            }

            if (-not $effectiveExists -and [System.IO.Directory]::Exists($effectiveCulturePath)) {
                $effectiveExists = $true
            }

            if ($effectiveExists) {
                $fileCandidate = Join-Path -Path $effectiveCulturePath -ChildPath $FileName
                $candidateInfo = [pscustomobject]@{
                    CultureName = $cultureName
                    FilePath    = $fileCandidate
                }
                [void]$candidates.Add($candidateInfo)
            }
        }
    }

    $rootCandidate = Join-Path -Path $resolvedBase -ChildPath $FileName
    $rootInfo = [pscustomobject]@{
        CultureName = $null
        FilePath    = $rootCandidate
    }
    [void]$candidates.Add($rootInfo)

    foreach ($candidate in $candidates) {
        $candidatePath = $candidate.FilePath
        if (-not $candidatePath) { continue }

        $leafExists = $false
        if (Test-Path -LiteralPath $candidatePath -PathType Leaf) {
            $leafExists = $true
        }
        else {
            try {
                $leafExists = [System.IO.File]::Exists($candidatePath)
            }
            catch {
                $leafExists = $false
            }

            if (-not $leafExists) {
                if (Test-Path -LiteralPath $candidatePath -PathType Leaf) {
                    $leafExists = $true
                }
            }
        }

        if ($leafExists) {
            try {
                $candidatePath = (Resolve-Path -LiteralPath $candidatePath -ErrorAction Stop).ProviderPath
            }
            catch {
                Write-ModuleTrace ("Resolve-LocalizedMessagesFile path resolution failed for '{0}': {1}" -f $candidate.FilePath, $_.Exception.Message)
            }

            return [pscustomobject]@{
                FilePath    = $candidatePath
                CultureName = $candidate.CultureName
            }
        }
    }

    return $null
}
