function Initialize-ColorScriptsLocalization {
    param(
        [string[]]$CandidateRoots,
        [string[]]$CultureFallbackOverride,
        [switch]$UseDefaultCandidates
    )

    $null = $CandidateRoots
    $null = $CultureFallbackOverride
    $useDefaultCandidatesFlag = $UseDefaultCandidates.IsPresent

    return Invoke-ModuleSynchronized $script:LocalizationSyncRoot {
        if ($script:LocalizationInitialized -and $script:Messages -and -not $CandidateRoots -and -not $CultureFallbackOverride) {
            if (-not $script:LocalizationDetails) {
                $script:LocalizationDetails = [pscustomobject]@{
                    LocalizedDataLoaded = $true
                    ModuleRoot          = $script:ModuleRoot
                    SearchedPaths       = @()
                    Source              = 'Import-LocalizedData'
                    FilePath            = $null
                }
            }

            return $script:LocalizationDetails
        }

        $localizationMode = if ($script:LocalizationMode) { $script:LocalizationMode } else { 'Auto' }
        $preferredCulture = $null
        if ($CultureFallbackOverride -and $CultureFallbackOverride.Count -gt 0) {
            $preferredCulture = $CultureFallbackOverride[0]
        }
        else {
            try {
                $preferredCulture = [System.Globalization.CultureInfo]::CurrentUICulture.Name
            }
            catch {
                $preferredCulture = $null
            }
        }

        $preferEmbeddedDefaults = $false
        if ($localizationMode -eq 'Embedded') {
            $preferEmbeddedDefaults = $true
        }
        elseif ($localizationMode -eq 'Auto' -and $useDefaultCandidatesFlag) {
            if ([string]::IsNullOrWhiteSpace($preferredCulture) -or $preferredCulture.StartsWith('en', [System.StringComparison]::OrdinalIgnoreCase)) {
                $preferEmbeddedDefaults = $true
            }
        }

        $preferredCultureDisplay = if ($preferredCulture) { $preferredCulture } else { 'n/a' }

        $uniqueCandidates = New-Object System.Collections.Generic.List[string]
        if ($CandidateRoots) {
            foreach ($candidate in $CandidateRoots) {
                if ([string]::IsNullOrWhiteSpace($candidate)) { continue }
                if (-not $uniqueCandidates.Contains($candidate)) {
                    $null = $uniqueCandidates.Add($candidate)
                }
            }
        }

        if (-not $uniqueCandidates.Count) {
            if ($script:ModuleRoot) {
                $null = $uniqueCandidates.Add($script:ModuleRoot)
            }
            elseif ($PSScriptRoot) {
                $null = $uniqueCandidates.Add($PSScriptRoot)
            }
        }

        $searchedPaths = New-Object System.Collections.Generic.List[string]
        $candidatePaths = New-Object System.Collections.Generic.List[string]

        foreach ($candidate in $uniqueCandidates) {
            if ([string]::IsNullOrWhiteSpace($candidate)) { continue }
            Write-ModuleTrace ("Evaluating localization candidate: {0}" -f $candidate)

            $candidatePath = $candidate
            try {
                $resolvedCandidate = Resolve-Path -LiteralPath $candidate -ErrorAction Stop
                if ($resolvedCandidate) {
                    $candidatePath = $resolvedCandidate.ProviderPath
                }
            }
            catch {
                Write-ModuleTrace ("Localization candidate resolution failed for '{0}': {1}" -f $candidate, $_.Exception.Message)
            }

            if ([System.IO.Directory]::Exists($candidatePath) -or (Test-Path -LiteralPath $candidatePath -PathType Container)) {
                if (-not $candidatePaths.Contains($candidatePath)) {
                    [void]$candidatePaths.Add($candidatePath)
                }
            }
        }

        if (-not $candidatePaths.Count) {
            Write-ModuleTrace 'No localization candidate paths resolved; falling back to module root discovery.'
            $fallbackRoot = $null
            if ($PSScriptRoot -and (Test-Path -LiteralPath $PSScriptRoot -PathType Container)) {
                try {
                    $fallbackRoot = (Resolve-Path -LiteralPath $PSScriptRoot -ErrorAction Stop).ProviderPath
                }
                catch {
                    $fallbackRoot = $PSScriptRoot
                }
            }
            elseif ($script:ModuleRoot) {
                $fallbackRoot = $script:ModuleRoot
            }

            if ($fallbackRoot) {
                [void]$candidatePaths.Add($fallbackRoot)
            }
        }

        if (-not $candidatePaths.Count) {
            throw [System.InvalidOperationException]::new('Unable to resolve a module root for localization resources.')
        }

        if ($preferEmbeddedDefaults) {
            $cultureSearchOrder = New-Object System.Collections.Generic.List[string]
            if ($CultureFallbackOverride -and $CultureFallbackOverride.Count -gt 0) {
                foreach ($cultureName in $CultureFallbackOverride) {
                    if ([string]::IsNullOrWhiteSpace($cultureName)) { continue }
                    if (-not $cultureSearchOrder.Contains($cultureName)) {
                        $null = $cultureSearchOrder.Add($cultureName)
                    }
                }
            }
            elseif (-not [string]::IsNullOrWhiteSpace($preferredCulture)) {
                try {
                    $cultureInfo = [System.Globalization.CultureInfo]::GetCultureInfo($preferredCulture)
                }
                catch {
                    $cultureInfo = $null
                }

                while ($cultureInfo -and $cultureInfo.Name -and -not [string]::IsNullOrWhiteSpace($cultureInfo.Name)) {
                    if (-not $cultureSearchOrder.Contains($cultureInfo.Name)) {
                        $null = $cultureSearchOrder.Add($cultureInfo.Name)
                    }

                    if (-not $cultureInfo.Parent -or $cultureInfo.Parent.Name -eq $cultureInfo.Name) {
                        break
                    }

                    $cultureInfo = $cultureInfo.Parent
                }
            }

            foreach ($fallbackCulture in @('en-US', 'en')) {
                if (-not [string]::IsNullOrWhiteSpace($fallbackCulture) -and -not $cultureSearchOrder.Contains($fallbackCulture)) {
                    $null = $cultureSearchOrder.Add($fallbackCulture)
                }
            }

            $localizedResourceExists = $false
            foreach ($candidatePath in $candidatePaths) {
                if ([string]::IsNullOrWhiteSpace($candidatePath)) { continue }

                $probePaths = New-Object System.Collections.Generic.List[string]
                $null = $probePaths.Add((Join-Path -Path $candidatePath -ChildPath 'Messages.psd1'))

                foreach ($cultureName in $cultureSearchOrder) {
                    $cultureProbe = Join-Path -Path $candidatePath -ChildPath $cultureName
                    $null = $probePaths.Add((Join-Path -Path $cultureProbe -ChildPath 'Messages.psd1'))
                }

                foreach ($probe in ($probePaths | Select-Object -Unique)) {
                    try {
                        if (Test-Path -LiteralPath $probe -PathType Leaf) {
                            $localizedResourceExists = $true
                            break
                        }
                    }
                    catch {
                        continue
                    }
                }

                if ($localizedResourceExists) { break }
            }

            if (-not $localizedResourceExists) {
                $moduleRootCandidate = $null
                if ($candidatePaths.Count -gt 0) {
                    $moduleRootCandidate = $candidatePaths[0]
                }

                if (-not $moduleRootCandidate -and $script:ModuleRoot) {
                    $moduleRootCandidate = $script:ModuleRoot
                }
                elseif (-not $moduleRootCandidate -and $PSScriptRoot) {
                    try {
                        $moduleRootCandidate = (Resolve-Path -LiteralPath $PSScriptRoot -ErrorAction Stop).ProviderPath
                    }
                    catch {
                        $moduleRootCandidate = $PSScriptRoot
                    }
                }

                $script:ModuleRoot = $moduleRootCandidate
                $script:Messages = if ($script:EmbeddedDefaultMessages) { $script:EmbeddedDefaultMessages.Clone() } else { @{} }
                $script:LocalizationInitialized = $true
                $script:LocalizationDetails = [pscustomobject]@{
                    LocalizedDataLoaded = $false
                    ModuleRoot          = $moduleRootCandidate
                    SearchedPaths       = $candidatePaths.ToArray()
                    Source              = 'EmbeddedDefaults'
                    FilePath            = $null
                }

                Write-ModuleTrace ("Localization using embedded defaults (mode: {0}, culture: {1})" -f $localizationMode, $preferredCultureDisplay)
                return $script:LocalizationDetails
            }

            Write-ModuleTrace ("Embedded localization preference skipped; culture resources detected for {0}" -f $preferredCultureDisplay)
        }

        $importSucceeded = $false
        $selectedRoot = $null
        $source = 'Import-LocalizedData'
        $filePath = $null

        foreach ($candidatePath in $candidatePaths) {
            if ([string]::IsNullOrWhiteSpace($candidatePath)) { continue }
            $selectedRoot = $candidatePath
            $null = $searchedPaths.Add($candidatePath)

            $importParams = @{ BaseDirectory = $candidatePath }
            if ($CultureFallbackOverride -and $CultureFallbackOverride.Count -gt 0) {
                $importParams['FallbackUICulture'] = $CultureFallbackOverride
            }

            try {
                $importResult = Import-LocalizedMessagesFromFile @importParams
                if ($importResult -and $importResult.Messages) {
                    $messages = $importResult.Messages
                    $source = if ($importResult.Source) { $importResult.Source } else { 'Import-LocalizedData' }
                    $filePath = if ($importResult.FilePath) { $importResult.FilePath } else { $null }

                    $script:Messages = $messages
                    $script:ModuleRoot = $candidatePath
                    $script:LocalizationInitialized = $true
                    $script:LocalizationDetails = [pscustomobject]@{
                        LocalizedDataLoaded = $true
                        ModuleRoot          = $candidatePath
                        SearchedPaths       = $searchedPaths.ToArray()
                        Source              = $source
                        FilePath            = $filePath
                    }

                    if ($filePath) {
                        Write-ModuleTrace ("Localization resolved via {0} from {1} (file {2})" -f $source, $candidatePath, $filePath)
                    }
                    else {
                        Write-ModuleTrace ("Localization resolved via {0} from {1}" -f $source, $candidatePath)
                    }

                    $importSucceeded = $true
                    break
                }
            }
            catch {
                Write-ModuleTrace ("Localization import failure for '{0}': {1}" -f $candidatePath, $_.Exception.Message)
            }
        }

        if (-not $importSucceeded) {
            $effectiveRoot = $selectedRoot
            if (-not $effectiveRoot -and $candidatePaths.Count -gt 0) {
                $effectiveRoot = $candidatePaths[0]
            }
            if (-not $effectiveRoot -and $PSScriptRoot -and (Test-Path -LiteralPath $PSScriptRoot -PathType Container)) {
                try {
                    $effectiveRoot = (Resolve-Path -LiteralPath $PSScriptRoot -ErrorAction Stop).ProviderPath
                }
                catch {
                    $effectiveRoot = $PSScriptRoot
                }
            }
            elseif (-not $effectiveRoot -and $script:ModuleRoot) {
                $effectiveRoot = $script:ModuleRoot
            }

            $script:ModuleRoot = $effectiveRoot
            $script:Messages = if ($script:EmbeddedDefaultMessages) { $script:EmbeddedDefaultMessages.Clone() } else { @{} }
            $script:LocalizationInitialized = $true
            $script:LocalizationDetails = [pscustomobject]@{
                LocalizedDataLoaded = $false
                ModuleRoot          = $effectiveRoot
                SearchedPaths       = $searchedPaths.ToArray()
                Source              = 'EmbeddedDefaults'
                FilePath            = $null
            }

            Write-Warning 'Localization resources were not found. Falling back to built-in English messages.'
        }

        return $script:LocalizationDetails
    }
}
