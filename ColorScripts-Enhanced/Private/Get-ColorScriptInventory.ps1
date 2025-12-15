function Get-ColorScriptInventory {
    param(
        [switch]$Raw
    )

    $null = $Raw

    $result = Invoke-ModuleSynchronized $script:InventorySyncRoot {
        $getScriptFiles = {
            param(
                [Parameter(Mandatory)]
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
                    return @(Get-ChildItem -Path $Path -Filter '*.ps1' -File -ErrorAction Stop)
                }
                catch {
                    return @()
                }
            }
        }

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

        $shouldRefresh = -not $script:ScriptInventoryInitialized
        if (-not $shouldRefresh -and $null -ne $script:ScriptInventoryStamp) {
            if ($currentStamp -ne $script:ScriptInventoryStamp) {
                $shouldRefresh = $true
            }
        }
        elseif (-not $shouldRefresh -and $null -eq $script:ScriptInventoryStamp -and $currentStamp) {
            $shouldRefresh = $true
        }

        $scriptFiles = $null

        if (-not $shouldRefresh -and $script:ScriptInventoryInitialized -and $currentStamp -eq $script:ScriptInventoryStamp) {
            $inventoryContainsNonFileInfo = $false
            if ($script:ScriptInventory) {
                foreach ($item in $script:ScriptInventory) {
                    if ($item -isnot [System.IO.FileInfo]) {
                        $inventoryContainsNonFileInfo = $true
                        break
                    }
                }
            }

            if (-not $inventoryContainsNonFileInfo) {
                $probeFiles = & $getScriptFiles $script:ScriptsPath

                $cachedCount = if ($script:ScriptInventory) { $script:ScriptInventory.Count } else { 0 }
                if ($probeFiles.Count -ne $cachedCount) {
                    $shouldRefresh = $true
                    $scriptFiles = $probeFiles
                }
            }
        }

        if ($shouldRefresh) {
            if (-not $scriptFiles) {
                $scriptFiles = & $getScriptFiles $script:ScriptsPath
            }

            $script:ScriptInventory = @($scriptFiles)
            $script:ScriptInventoryRecords = @(
                foreach ($file in $scriptFiles) {
                    [pscustomobject]@{
                        Name        = $file.BaseName
                        Path        = $file.FullName
                        Category    = $null
                        Categories  = @()
                        Tags        = @()
                        Description = $null
                        Metadata    = $null
                    }
                }
            )
            $script:ScriptInventoryStamp = $currentStamp
            $script:ScriptInventoryInitialized = $true
        }

        if (-not $script:ScriptInventory) {
            $script:ScriptInventory = @()
        }

        if (-not $script:ScriptInventoryRecords) {
            $script:ScriptInventoryRecords = @(
                foreach ($file in $script:ScriptInventory) {
                    [pscustomobject]@{
                        Name        = $file.BaseName
                        Path        = $file.FullName
                        Category    = $null
                        Categories  = @()
                        Tags        = @()
                        Description = $null
                        Metadata    = $null
                    }
                }
            )
        }

        if ($Raw) {
            return $script:ScriptInventory
        }

        return $script:ScriptInventoryRecords
    }

    return $result
}
