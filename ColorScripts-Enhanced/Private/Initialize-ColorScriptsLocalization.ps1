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

        # Performance fast-path:
        # In Auto mode we prefer embedded defaults for English cultures; probing the disk to detect
        # localization resources adds measurable import-time overhead and provides little value.
        # Only Full mode should force loading Messages.psd1 from disk.
        $explicitCandidateRootsProvided = $null -ne $CandidateRoots -and $CandidateRoots.Count -gt 0

        # Deterministic explicit-root import:
        # When callers explicitly provide CandidateRoots, they typically expect that Messages.psd1
        # placed directly under those roots will be honored. Import-LocalizedData supports that
        # layout, but other module state (or earlier tests) can cause the broader discovery path
        # to fall back unexpectedly. If the root file exists, load it directly.
        if ($explicitCandidateRootsProvided) {
            foreach ($explicitRoot in $CandidateRoots) {
                if ([string]::IsNullOrWhiteSpace($explicitRoot)) {
                    continue
                }

                $resolvedExplicitRoot = $explicitRoot
                try {
                    $resolvedExplicitRoot = (Resolve-Path -LiteralPath $explicitRoot -ErrorAction Stop).ProviderPath
                }
                catch {
                    $resolvedExplicitRoot = $explicitRoot
                }

                try {
                    $rootProbe = Join-Path -Path $resolvedExplicitRoot -ChildPath 'Messages.psd1'
                }
                catch {
                    $rootProbe = $null
                }

                if (-not $rootProbe) {
                    continue
                }

                if (Test-Path -LiteralPath $rootProbe -PathType Leaf) {
                    try {
                        $directMessages = Import-LocalizedData -BaseDirectory $resolvedExplicitRoot -FileName 'Messages.psd1' -ErrorAction Stop
                        if ($directMessages -and $directMessages -is [System.Collections.IDictionary]) {
                            $script:Messages = $directMessages
                            $script:ModuleRoot = $resolvedExplicitRoot
                            $script:LocalizationInitialized = $true
                            $script:LocalizationDetails = [pscustomobject]@{
                                LocalizedDataLoaded = $true
                                ModuleRoot          = $resolvedExplicitRoot
                                SearchedPaths       = @($resolvedExplicitRoot)
                                Source              = 'Import-LocalizedData'
                                FilePath            = $rootProbe
                            }

                            Write-ModuleTrace ("Localization loaded from explicit root via Import-LocalizedData: {0}" -f $resolvedExplicitRoot)
                            return $script:LocalizationDetails
                        }
                    }
                    catch {
                        # Fall back to the regular discovery/import logic
                    }
                }
            }
        }

        if ($preferEmbeddedDefaults -and $localizationMode -ne 'Full' -and -not $explicitCandidateRootsProvided) {
            $moduleRootCandidate = $null
            if ($CandidateRoots -and $CandidateRoots.Count -gt 0) {
                foreach ($candidate in $CandidateRoots) {
                    if (-not [string]::IsNullOrWhiteSpace($candidate)) {
                        $moduleRootCandidate = $candidate
                        break
                    }
                }
            }

            if (-not $moduleRootCandidate -and $script:ModuleRoot) {
                $moduleRootCandidate = $script:ModuleRoot
            }
            elseif (-not $moduleRootCandidate -and $PSScriptRoot) {
                $moduleRootCandidate = $PSScriptRoot
            }

            if ($moduleRootCandidate) {
                try {
                    $moduleRootCandidate = (Resolve-Path -LiteralPath $moduleRootCandidate -ErrorAction Stop).ProviderPath
                }
                catch {
                    # Keep original path
                }
            }

            $script:ModuleRoot = $moduleRootCandidate
            $script:Messages = if ($script:EmbeddedDefaultMessages) { $script:EmbeddedDefaultMessages.Clone() } else { @{} }
            $script:LocalizationInitialized = $true
            $script:LocalizationDetails = [pscustomobject]@{
                LocalizedDataLoaded = $false
                ModuleRoot          = $moduleRootCandidate
                SearchedPaths       = if ($moduleRootCandidate) { @($moduleRootCandidate) } else { @() }
                Source              = 'EmbeddedDefaults'
                FilePath            = $null
            }

            Write-ModuleTrace ("Localization fast-path using embedded defaults (mode: {0}, culture: {1})" -f $localizationMode, $preferredCultureDisplay)
            return $script:LocalizationDetails
        }

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

        # Note: Embedded default localization handling is already performed above (fast-path).

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
