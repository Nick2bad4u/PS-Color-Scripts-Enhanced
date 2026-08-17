function Resolve-InitializedLocalizationDetailRecord {
    [CmdletBinding()]
    [OutputType([pscustomobject])]
    param()

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

function Get-ColorScriptsPreferredCulture {
    [CmdletBinding()]
    [OutputType([string])]
    param(
        [string[]]$CultureFallbackOverride
    )

    if ($CultureFallbackOverride -and $CultureFallbackOverride.Count -gt 0) {
        return $CultureFallbackOverride[0]
    }

    try {
        return [System.Globalization.CultureInfo]::CurrentUICulture.Name
    }
    catch {
        return $null
    }
}

function Test-EmbeddedLocalizationPreferred {
    [CmdletBinding()]
    [OutputType([bool])]
    param(
        [Parameter(Mandatory)][string]$LocalizationMode,
        [Parameter()][AllowNull()][AllowEmptyString()][string]$PreferredCulture,
        [switch]$UseDefaultCandidates
    )

    if ($LocalizationMode -eq 'Embedded') {
        return $true
    }

    if ($LocalizationMode -ne 'Auto' -or -not $UseDefaultCandidates) {
        return $false
    }

    return [string]::IsNullOrWhiteSpace($PreferredCulture) -or
        $PreferredCulture.StartsWith('en', [System.StringComparison]::OrdinalIgnoreCase)
}

function Use-ColorScriptsLocalizationState {
    [CmdletBinding()]
    [OutputType([pscustomobject])]
    param(
        [Parameter()][AllowNull()][object]$Messages,
        [Parameter()][AllowNull()][object]$ModuleRoot,
        [Parameter(Mandatory)][bool]$LocalizedDataLoaded,
        [Parameter(Mandatory)][AllowEmptyCollection()][string[]]$SearchedPath,
        [Parameter(Mandatory)][string]$Source,
        [Parameter()][AllowNull()][object]$FilePath
    )

    $script:Messages = $Messages
    $script:ModuleRoot = $ModuleRoot
    $script:LocalizationInitialized = $true
    $script:LocalizationDetails = [pscustomobject]@{
        LocalizedDataLoaded = $LocalizedDataLoaded
        ModuleRoot          = $ModuleRoot
        SearchedPaths       = $SearchedPath
        Source              = $Source
        FilePath            = $FilePath
    }

    return $script:LocalizationDetails
}

function Resolve-LocalizationRootPath {
    [CmdletBinding()]
    [OutputType([string])]
    param(
        [Parameter(Mandatory)][string]$Root,
        [Parameter(Mandatory)][string]$FailureContext
    )

    try {
        return (Resolve-Path -LiteralPath $Root -ErrorAction Stop).ProviderPath
    }
    catch {
        Write-ModuleTrace ("{0} for '{1}': {2}" -f $FailureContext, $Root, $_.Exception.Message)
        return $Root
    }
}

function Import-ExplicitLocalizationRoot {
    [CmdletBinding()]
    [OutputType([pscustomobject])]
    param(
        [Parameter(Mandatory)][AllowEmptyString()][string]$Root
    )

    if ([string]::IsNullOrWhiteSpace($Root)) {
        return $null
    }

    $resolvedRoot = Resolve-LocalizationRootPath -Root $Root -FailureContext 'Explicit root localization resolution failed'
    try {
        $rootProbe = Join-Path -Path $resolvedRoot -ChildPath 'Messages.psd1'
    }
    catch {
        return $null
    }

    if (-not (Test-Path -LiteralPath $rootProbe -PathType Leaf)) {
        return $null
    }

    try {
        $messages = Import-LocalizedData -BaseDirectory $resolvedRoot -FileName 'Messages.psd1' -ErrorAction Stop
        if (-not $messages -or $messages -isnot [System.Collections.IDictionary]) {
            return $null
        }

        $details = Use-ColorScriptsLocalizationState -Messages $messages -ModuleRoot $resolvedRoot -LocalizedDataLoaded $true -SearchedPath @($resolvedRoot) -Source 'Import-LocalizedData' -FilePath $rootProbe
        Write-ModuleTrace ("Localization loaded from explicit root via Import-LocalizedData: {0}" -f $resolvedRoot)
        return $details
    }
    catch {
        Write-ModuleTrace ("Explicit root localization import failed for '{0}': {1}" -f $resolvedRoot, $_.Exception.Message)
        return $null
    }
}

function Find-ExplicitLocalizationDetailRecord {
    [CmdletBinding()]
    [OutputType([pscustomobject])]
    param(
        [Parameter(Mandatory)][AllowEmptyCollection()][string[]]$CandidateRoot
    )

    foreach ($root in $CandidateRoot) {
        $details = Import-ExplicitLocalizationRoot -Root $root
        if ($details) {
            return $details
        }
    }

    return $null
}

function Get-EmbeddedLocalizationRoot {
    [CmdletBinding()]
    [OutputType([string])]
    param(
        [string[]]$CandidateRoot
    )

    $moduleRootCandidate = $null
    foreach ($candidate in @($CandidateRoot)) {
        if (-not [string]::IsNullOrWhiteSpace($candidate)) {
            $moduleRootCandidate = $candidate
            break
        }
    }

    if (-not $moduleRootCandidate -and $script:ModuleRoot) {
        $moduleRootCandidate = $script:ModuleRoot
    }
    elseif (-not $moduleRootCandidate -and $PSScriptRoot) {
        $moduleRootCandidate = $PSScriptRoot
    }

    if (-not $moduleRootCandidate) {
        return $null
    }

    return Resolve-LocalizationRootPath -Root $moduleRootCandidate -FailureContext 'Embedded defaults module root resolution failed'
}

function Use-EmbeddedLocalizationDefaultState {
    [CmdletBinding()]
    [OutputType([pscustomobject])]
    param(
        [Parameter()][AllowNull()][object]$ModuleRoot,
        [Parameter(Mandatory)][AllowEmptyCollection()][string[]]$SearchedPath
    )

    $messages = if ($script:EmbeddedDefaultMessages) { $script:EmbeddedDefaultMessages.Clone() } else { @{} }
    return Use-ColorScriptsLocalizationState -Messages $messages -ModuleRoot $ModuleRoot -LocalizedDataLoaded $false -SearchedPath $SearchedPath -Source 'EmbeddedDefaults' -FilePath $null
}

function Get-LocalizationCandidateRoot {
    [CmdletBinding()]
    [OutputType([string[]])]
    param(
        [string[]]$CandidateRoot
    )

    $uniqueCandidates = New-Object System.Collections.Generic.List[string]
    foreach ($candidate in @($CandidateRoot)) {
        if ([string]::IsNullOrWhiteSpace($candidate) -or $uniqueCandidates.Contains($candidate)) {
            continue
        }
        $null = $uniqueCandidates.Add($candidate)
    }

    if ($uniqueCandidates.Count -eq 0) {
        if ($script:ModuleRoot) {
            $null = $uniqueCandidates.Add($script:ModuleRoot)
        }
        elseif ($PSScriptRoot) {
            $null = $uniqueCandidates.Add($PSScriptRoot)
        }
    }

    return $uniqueCandidates.ToArray()
}

function Resolve-LocalizationCandidateDirectory {
    [CmdletBinding()]
    [OutputType([string])]
    param(
        [Parameter(Mandatory)][string]$Candidate
    )

    Write-ModuleTrace ("Evaluating localization candidate: {0}" -f $Candidate)
    $candidatePath = Resolve-LocalizationRootPath -Root $Candidate -FailureContext 'Localization candidate resolution failed'
    if ([System.IO.Directory]::Exists($candidatePath) -or
        (Test-Path -LiteralPath $candidatePath -PathType Container)) {
        return $candidatePath
    }

    return $null
}

function Resolve-LocalizationFallbackRoot {
    [CmdletBinding()]
    [OutputType([string])]
    param()

    if ($PSScriptRoot -and (Test-Path -LiteralPath $PSScriptRoot -PathType Container)) {
        return Resolve-LocalizationRootPath -Root $PSScriptRoot -FailureContext 'Localization fallback root resolution failed'
    }

    if ($script:ModuleRoot) {
        return $script:ModuleRoot
    }

    return $null
}

function Get-LocalizationCandidatePath {
    [CmdletBinding()]
    [OutputType([string[]])]
    param(
        [string[]]$CandidateRoot
    )

    $candidatePaths = New-Object System.Collections.Generic.List[string]
    foreach ($candidate in @(Get-LocalizationCandidateRoot -CandidateRoot $CandidateRoot)) {
        $candidatePath = Resolve-LocalizationCandidateDirectory -Candidate $candidate
        if ($candidatePath -and -not $candidatePaths.Contains($candidatePath)) {
            [void]$candidatePaths.Add($candidatePath)
        }
    }

    if ($candidatePaths.Count -eq 0) {
        Write-ModuleTrace 'No localization candidate paths resolved; falling back to module root discovery.'
        $fallbackRoot = Resolve-LocalizationFallbackRoot
        if ($fallbackRoot) {
            [void]$candidatePaths.Add($fallbackRoot)
        }
    }

    if ($candidatePaths.Count -eq 0) {
        throw [System.InvalidOperationException]::new('Unable to resolve a module root for localization resources.')
    }

    return $candidatePaths.ToArray()
}

function Import-LocalizationCandidate {
    [CmdletBinding()]
    [OutputType([pscustomobject])]
    param(
        [Parameter(Mandatory)][string]$CandidatePath,
        [string[]]$CultureFallbackOverride,
        [Parameter(Mandatory)]
        [AllowEmptyCollection()]
        [System.Collections.Generic.List[string]]$SearchedPath
    )

    $null = $SearchedPath.Add($CandidatePath)
    $importParams = @{ BaseDirectory = $CandidatePath }
    if ($CultureFallbackOverride -and $CultureFallbackOverride.Count -gt 0) {
        $importParams['FallbackUICulture'] = $CultureFallbackOverride
    }

    try {
        $importResult = Import-LocalizedMessagesFromFile @importParams
        if (-not $importResult -or -not $importResult.Messages) {
            return $null
        }

        $source = if ($importResult.Source) { $importResult.Source } else { 'Import-LocalizedData' }
        $filePath = if ($importResult.FilePath) { $importResult.FilePath } else { $null }
        $details = Use-ColorScriptsLocalizationState -Messages $importResult.Messages -ModuleRoot $CandidatePath -LocalizedDataLoaded $true -SearchedPath $SearchedPath.ToArray() -Source $source -FilePath $filePath
        if ($filePath) {
            Write-ModuleTrace ("Localization resolved via {0} from {1} (file {2})" -f $source, $CandidatePath, $filePath)
        }
        else {
            Write-ModuleTrace ("Localization resolved via {0} from {1}" -f $source, $CandidatePath)
        }

        return $details
    }
    catch {
        Write-ModuleTrace ("Localization import failure for '{0}': {1}" -f $CandidatePath, $_.Exception.Message)
        return $null
    }
}

function Find-LocalizationImport {
    [CmdletBinding()]
    [OutputType([pscustomobject])]
    param(
        [Parameter(Mandatory)][AllowEmptyCollection()][string[]]$CandidatePath,
        [string[]]$CultureFallbackOverride
    )

    $searchedPaths = New-Object System.Collections.Generic.List[string]
    $selectedRoot = $null
    foreach ($currentPath in $CandidatePath) {
        if ([string]::IsNullOrWhiteSpace($currentPath)) {
            continue
        }

        $selectedRoot = $currentPath
        $details = Import-LocalizationCandidate -CandidatePath $currentPath -CultureFallbackOverride $CultureFallbackOverride -SearchedPath $searchedPaths
        if ($details) {
            return [pscustomobject]@{
                Details      = $details
                SelectedRoot = $selectedRoot
                SearchedPath = $searchedPaths.ToArray()
            }
        }
    }

    return [pscustomobject]@{
        Details      = $null
        SelectedRoot = $selectedRoot
        SearchedPath = $searchedPaths.ToArray()
    }
}

function Get-LocalizationFailureRoot {
    [CmdletBinding()]
    [OutputType([string])]
    param(
        [Parameter()][AllowNull()][object]$SelectedRoot,
        [Parameter(Mandatory)][AllowEmptyCollection()][string[]]$CandidatePath
    )

    if ($SelectedRoot) {
        return $SelectedRoot
    }

    if ($CandidatePath.Count -gt 0) {
        return $CandidatePath[0]
    }

    return Resolve-LocalizationFallbackRoot
}

function Test-LocalizationStateReusable {
    [CmdletBinding()]
    [OutputType([bool])]
    param(
        [string[]]$CandidateRoot,
        [string[]]$CultureFallbackOverride
    )

    return $script:LocalizationInitialized -and
        $script:Messages -and
        -not $CandidateRoot -and
        -not $CultureFallbackOverride
}

function Test-EmbeddedLocalizationFastPath {
    [CmdletBinding()]
    [OutputType([bool])]
    param(
        [Parameter(Mandatory)][bool]$Preferred,
        [Parameter(Mandatory)][string]$LocalizationMode,
        [Parameter(Mandatory)][bool]$ExplicitRootsProvided
    )

    return $Preferred -and $LocalizationMode -ne 'Full' -and -not $ExplicitRootsProvided
}

function Use-EmbeddedLocalizationFastPath {
    [CmdletBinding()]
    [OutputType([pscustomobject])]
    param(
        [string[]]$CandidateRoot,
        [Parameter()][AllowNull()][AllowEmptyString()][string]$PreferredCulture,
        [Parameter(Mandatory)][string]$LocalizationMode
    )

    $moduleRoot = Get-EmbeddedLocalizationRoot -CandidateRoot $CandidateRoot
    $searchedPath = if ($moduleRoot) { @($moduleRoot) } else { @() }
    $details = Use-EmbeddedLocalizationDefaultState -ModuleRoot $moduleRoot -SearchedPath $searchedPath
    $cultureDisplay = if ($PreferredCulture) { $PreferredCulture } else { 'n/a' }
    Write-ModuleTrace ("Localization fast-path using embedded defaults (mode: {0}, culture: {1})" -f $LocalizationMode, $cultureDisplay)
    return $details
}

function Initialize-ColorScriptsLocalizationCore {
    [CmdletBinding()]
    [OutputType([pscustomobject])]
    param(
        [string[]]$CandidateRoot,
        [string[]]$CultureFallbackOverride,
        [switch]$UseDefaultCandidates
    )

    if (Test-LocalizationStateReusable -CandidateRoot $CandidateRoot -CultureFallbackOverride $CultureFallbackOverride) {
        return Resolve-InitializedLocalizationDetailRecord
    }

    $localizationMode = if ($script:LocalizationMode) { $script:LocalizationMode } else { 'Auto' }
    $preferredCulture = Get-ColorScriptsPreferredCulture -CultureFallbackOverride $CultureFallbackOverride
    $preferEmbeddedDefaults = Test-EmbeddedLocalizationPreferred -LocalizationMode $localizationMode -PreferredCulture $preferredCulture -UseDefaultCandidates:$UseDefaultCandidates
    $explicitRootsProvided = $null -ne $CandidateRoot -and $CandidateRoot.Count -gt 0

    if ($explicitRootsProvided) {
        $explicitDetails = Find-ExplicitLocalizationDetailRecord -CandidateRoot $CandidateRoot
        if ($explicitDetails) {
            return $explicitDetails
        }
    }

    $useEmbeddedFastPath = Test-EmbeddedLocalizationFastPath -Preferred $preferEmbeddedDefaults -LocalizationMode $localizationMode -ExplicitRootsProvided $explicitRootsProvided
    if ($useEmbeddedFastPath) {
        return Use-EmbeddedLocalizationFastPath -CandidateRoot $CandidateRoot -PreferredCulture $preferredCulture -LocalizationMode $localizationMode
    }

    $candidatePaths = @(Get-LocalizationCandidatePath -CandidateRoot $CandidateRoot)
    $import = Find-LocalizationImport -CandidatePath $candidatePaths -CultureFallbackOverride $CultureFallbackOverride
    if ($import.Details) {
        return $import.Details
    }

    $effectiveRoot = Get-LocalizationFailureRoot -SelectedRoot $import.SelectedRoot -CandidatePath $candidatePaths
    $details = Use-EmbeddedLocalizationDefaultState -ModuleRoot $effectiveRoot -SearchedPath $import.SearchedPath
    Write-Warning 'Localization resources were not found. Falling back to built-in English messages.'
    return $details
}

function Initialize-ColorScriptsLocalization {
    param(
        [string[]]$CandidateRoots,
        [string[]]$CultureFallbackOverride,
        [switch]$UseDefaultCandidates
    )

    # Capture parameters outside the synchronized scriptblock so ScriptAnalyzer and Windows
    # PowerShell agree that the values are intentionally closed over.
    $candidateRootList = $CandidateRoots
    $cultureFallbackList = $CultureFallbackOverride
    $useDefaultCandidatesFlag = $UseDefaultCandidates.IsPresent

    return Invoke-ModuleSynchronized $script:LocalizationSyncRoot {
        Initialize-ColorScriptsLocalizationCore -CandidateRoot $candidateRootList -CultureFallbackOverride $cultureFallbackList -UseDefaultCandidates:$useDefaultCandidatesFlag
    }
}
