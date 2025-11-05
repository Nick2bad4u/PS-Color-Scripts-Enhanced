function Resolve-PreferredDirectory {
    param(
        [Parameter(Mandatory)][string]$Path,
        [scriptblock]$CreateDirectory,
        [scriptblock]$OnCreateFailure,
        [scriptblock]$OnResolutionFailure
    )

    $target = Resolve-CachePath -Path $Path
    if (-not $target) {
        if ($OnResolutionFailure) {
            & $OnResolutionFailure $Path
        }
        return $null
    }

    try {
        $directoryExists = Test-Path -LiteralPath $target -PathType Container
        if (-not $directoryExists) {
            if (Test-Path -LiteralPath $target -PathType Leaf) {
                throw [System.IO.IOException]::new("Path '$target' exists but is not a directory.")
            }

            if ($CreateDirectory) {
                $null = & $CreateDirectory $target
            }
            else {
                New-Item -ItemType Directory -Path $target -Force -ErrorAction Stop | Out-Null
            }
        }

        try {
            return (Resolve-Path -LiteralPath $target -ErrorAction Stop).ProviderPath
        }
        catch {
            return $target
        }
    }
    catch {
        if ($OnCreateFailure) {
            & $OnCreateFailure $target $_
        }
        return $null
    }
}
