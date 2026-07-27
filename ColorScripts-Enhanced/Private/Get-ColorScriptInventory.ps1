function New-ColorScriptInventoryRecord {
    param(
        [Parameter(Mandatory)]
        [System.IO.FileInfo]$File
    )

    return [pscustomobject]@{
        Name        = $File.BaseName
        Path        = $File.FullName
        Category    = $null
        Categories  = @()
        Tags        = @()
        Description = $null
        Metadata    = $null
    }
}

function Get-ColorScriptExactNameRecord {
    param(
        [Parameter(Mandatory)]
        [string]$Name
    )

    if ([string]::IsNullOrWhiteSpace($Name) -or
        [System.Management.Automation.WildcardPattern]::ContainsWildcardCharacters($Name)) {
        return $null
    }

    $candidatePath = Join-Path -Path $script:ScriptsPath -ChildPath ("{0}.ps1" -f $Name)
    if (-not [System.IO.File]::Exists($candidatePath)) {
        return $null
    }

    return New-ColorScriptInventoryRecord -File ([System.IO.FileInfo]$candidatePath)
}

function Get-ColorScriptCachePolicyRecord {
    $cacheableNames = Get-ColorScriptCacheableNameSet
    if (-not $cacheableNames -or $cacheableNames.Count -eq 0) {
        return @()
    }

    $records = New-Object 'System.Collections.Generic.List[object]'
    foreach ($scriptName in @($cacheableNames | Sort-Object)) {
        $record = Get-ColorScriptExactNameRecord -Name $scriptName
        if ($record) {
            $null = $records.Add($record)
        }
        else {
            Write-Verbose ("Skipping missing cache-policy script '{0}'." -f $scriptName)
        }
    }

    return $records.ToArray()
}

function Get-ColorScriptInventoryDirectoryStamp {
    $currentStamp = $null
    try {
        $currentStamp = & $script:DirectoryGetLastWriteTimeUtcDelegate $script:ScriptsPath
        if ($currentStamp -eq [datetime]::MinValue) {
            $currentStamp = $null
        }
    }
    catch {
        $currentStamp = $null
    }

    return $currentStamp
}

function Get-ColorScriptFileInventory {
    param(
        [Parameter(Mandatory)]
        [AllowNull()]
        [AllowEmptyString()]
        [string]$Path
    )

    try {
        if ([string]::IsNullOrWhiteSpace($Path)) {
            return @()
        }

        if (-not (Test-Path -LiteralPath $Path -PathType Container)) {
            return @()
        }

        $files = New-Object 'System.Collections.Generic.List[System.IO.FileInfo]'
        foreach ($filePath in [System.IO.Directory]::EnumerateFiles($Path, '*.ps1', [System.IO.SearchOption]::TopDirectoryOnly)) {
            if (-not [string]::IsNullOrWhiteSpace($filePath)) {
                $null = $files.Add([System.IO.FileInfo]$filePath)
            }
        }

        return $files.ToArray()
    }
    catch {
        try {
            return @(Get-ChildItem -LiteralPath $Path -Filter '*.ps1' -File -ErrorAction Stop)
        }
        catch {
            return @()
        }
    }
}

function Update-ColorScriptInventory {
    $currentStamp = Get-ColorScriptInventoryDirectoryStamp
    $shouldRefresh = -not $script:ScriptInventoryInitialized

    if (-not $shouldRefresh -and $null -ne $script:ScriptInventoryStamp) {
        if ($currentStamp -ne $script:ScriptInventoryStamp) {
            $shouldRefresh = $true
        }
    }
    elseif (-not $shouldRefresh -and $null -eq $script:ScriptInventoryStamp -and $currentStamp) {
        $shouldRefresh = $true
    }

    if (-not $shouldRefresh) {
        return
    }

    $script:ScriptInventory = @(Get-ColorScriptFileInventory -Path $script:ScriptsPath)
    $script:ScriptInventoryRecords = $null
    $script:ScriptInventoryStamp = $currentStamp
    $script:ScriptInventoryInitialized = $true
}

function Get-ColorScriptInventory {
    param(
        [switch]$Raw
    )

    $rawRequested = $Raw.IsPresent
    $result = Invoke-ModuleSynchronized $script:InventorySyncRoot {
        Update-ColorScriptInventory

        if ($null -eq $script:ScriptInventory) {
            $script:ScriptInventory = @()
        }

        if ($rawRequested) {
            return $script:ScriptInventory
        }

        if ($null -eq $script:ScriptInventoryRecords) {
            $script:ScriptInventoryRecords = @(
                foreach ($file in $script:ScriptInventory) {
                    New-ColorScriptInventoryRecord -File $file
                }
            )
        }

        return $script:ScriptInventoryRecords
    }

    return $result
}

function Get-RandomColorScriptInventoryRecord {
    $result = Invoke-ModuleSynchronized $script:InventorySyncRoot {
        Update-ColorScriptInventory

        if ($null -eq $script:ScriptInventory -or $script:ScriptInventory.Count -eq 0) {
            return $null
        }

        $index = Get-Random -Minimum 0 -Maximum $script:ScriptInventory.Count
        return New-ColorScriptInventoryRecord -File $script:ScriptInventory[$index]
    }

    return $result
}
