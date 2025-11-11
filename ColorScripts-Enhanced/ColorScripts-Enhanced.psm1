
#Requires -Version 5.1

# ColorScripts-Enhanced Module
# High-performance colorscripts with intelligent caching

# Module state
$script:ModuleRoot = $null
$script:ScriptsPath = $null
$script:MetadataPath = $null
$script:MetadataCache = $null
$script:MetadataLastWriteTime = $null
$script:Utf8NoBomEncoding = New-Object System.Text.UTF8Encoding($false)
$script:CacheDir = $null
$script:CacheInitialized = $false
$script:ScriptInventory = $null
$script:ScriptInventoryStamp = $null
$script:ScriptInventoryInitialized = $false
$script:ScriptInventoryRecords = $null
$script:ConfigurationRoot = $null
$script:ConfigurationPath = $null
$script:ConfigurationData = $null
$script:ConfigurationInitialized = $false
$script:LocalizationInitialized = $false
$script:LocalizationDetails = $null
$script:Messages = $null
$script:ShouldProcessOverride = $null
$script:DefaultConfiguration = @{
    Cache   = @{
        Path = $null
    }
    Startup = @{
        AutoShowOnImport = $false
        ProfileAutoShow  = $true
        DefaultScript    = $null
    }
}

$script:IsWindows = $IsWindows
$script:IsMacOS = $IsMacOS
$script:PowerShellMajorVersion = $PSVersionTable.PSVersion.Major

$traceSetting = $env:COLOR_SCRIPTS_ENHANCED_TRACE
$script:ModuleTraceEnabled = $false
$script:ModuleTraceUseVerbose = $false
$script:ModuleTraceUseDebug = $false
$script:ModuleTraceUseFile = $false
$script:ModuleTraceFile = $null
$script:ModuleTraceWriteFailureNotified = $false

if (-not [string]::IsNullOrWhiteSpace($traceSetting)) {
    $script:ModuleTraceEnabled = $true
    $tokens = ($traceSetting -split '[,;]') | ForEach-Object { $_.Trim() } | Where-Object { $_ }
    if (-not $tokens) {
        $tokens = @($traceSetting.Trim())
    }

    foreach ($token in $tokens) {
        switch -Regex ($token) {
            '^(?i)(1|true|yes|on)$' { $script:ModuleTraceUseVerbose = $true; continue }
            '^(?i)verbose$' { $script:ModuleTraceUseVerbose = $true; continue }
            '^(?i)debug$' { $script:ModuleTraceUseDebug = $true; continue }
            '^(?i)file$' { $script:ModuleTraceUseFile = $true; continue }
            '^(?i)path:(?<path>.+)$' {
                $script:ModuleTraceUseFile = $true
                if (-not [string]::IsNullOrWhiteSpace($Matches['path'])) {
                    $script:ModuleTraceFile = $Matches['path']
                }
                continue
            }
            default {
                $resolvedPath = $null
                try {
                    $resolvedPath = [System.IO.Path]::GetFullPath($token)
                }
                catch {
                    $resolvedPath = $null
                }

                if ($resolvedPath -and ($token.Contains('\') -or $token.Contains('/') -or $token -match '^[A-Za-z]:')) {
                    $script:ModuleTraceUseFile = $true
                    $script:ModuleTraceFile = $resolvedPath
                }
                else {
                    $script:ModuleTraceUseVerbose = $true
                }
            }
        }
    }
}

if ($script:ModuleTraceEnabled) {
    if (-not ($script:ModuleTraceUseVerbose -or $script:ModuleTraceUseDebug -or $script:ModuleTraceUseFile)) {
        $script:ModuleTraceUseVerbose = $true
    }

    if ($script:ModuleTraceUseFile -and -not $script:ModuleTraceFile) {
        $script:ModuleTraceFile = Join-Path -Path ([System.IO.Path]::GetTempPath()) -ChildPath 'cs-module-root-debug.log'
    }

    if ($script:ModuleTraceUseFile -and $script:ModuleTraceFile) {
        try {
            $traceDirectory = Split-Path -Path $script:ModuleTraceFile -Parent
            if ($traceDirectory -and -not (Test-Path -LiteralPath $traceDirectory)) {
                New-Item -Path $traceDirectory -ItemType Directory -Force | Out-Null
            }
        }
        catch {
            $script:ModuleTraceUseFile = $false
            Write-Verbose ("Unable to prepare trace directory '{0}': {1}" -f $script:ModuleTraceFile, $_.Exception.Message)
        }
    }
}

function Write-ModuleTrace {
    param(
        [Parameter(Mandatory)]
        [string]$Message
    )

    if (-not $script:ModuleTraceEnabled) {
        return
    }

    if ($script:ModuleTraceUseDebug) {
        Write-Debug $Message
    }

    if ($script:ModuleTraceUseVerbose) {
        Write-Verbose $Message
    }

    if ($script:ModuleTraceUseFile -and $script:ModuleTraceFile) {
        try {
            $Message | Out-File -FilePath $script:ModuleTraceFile -Encoding utf8 -Append
        }
        catch {
            if (-not $script:ModuleTraceWriteFailureNotified) {
                $script:ModuleTraceWriteFailureNotified = $true
                Write-Verbose ("Trace logging to '{0}' failed: {1}" -f $script:ModuleTraceFile, $_.Exception.Message)
            }
        }
    }
}

Write-ModuleTrace ('--- Import begin: {0} ---' -f (Get-Date -Format o))

$moduleInfo = $ExecutionContext.SessionState.Module
$moduleRootCandidates = @()

if ($moduleInfo) {
    if ($moduleInfo.ModuleBase) {
        $moduleRootCandidates += $moduleInfo.ModuleBase
    }

    if ($moduleInfo.Path) {
        $moduleRootCandidates += (Split-Path -Path $moduleInfo.Path -Parent)
    }
}

if ($PSScriptRoot) {
    $moduleRootCandidates += $PSScriptRoot
}

$availableModule = Get-Module -ListAvailable -Name 'ColorScripts-Enhanced' | Select-Object -First 1
if ($availableModule -and $availableModule.ModuleBase) {
    $moduleRootCandidates += $availableModule.ModuleBase
}

$environmentRoot = $env:COLOR_SCRIPTS_ENHANCED_MODULE_ROOT
if ($environmentRoot) {
    $moduleRootCandidates += $environmentRoot
}

Write-ModuleTrace ('Initial module root candidates: {0}' -f ($moduleRootCandidates -join ';'))

$resolvedCandidates = @()
foreach ($candidate in $moduleRootCandidates) {
    if ([string]::IsNullOrWhiteSpace($candidate)) { continue }
    try {
        $resolvedCandidate = (Resolve-Path -LiteralPath $candidate -ErrorAction Stop).ProviderPath
        if ($resolvedCandidate -and ($resolvedCandidates -notcontains $resolvedCandidate)) {
            $resolvedCandidates += $resolvedCandidate
        }
    }
    catch {
        continue
    }
}

$moduleRootCandidates = $resolvedCandidates
Write-ModuleTrace ('Resolved module root candidates: {0}' -f ($moduleRootCandidates -join ';'))

$cultureFallback = @()
try {
    $currentCulture = [System.Globalization.CultureInfo]::CurrentUICulture
}
catch {
    $currentCulture = $null
}

while ($currentCulture -and $currentCulture.Name -and -not ($cultureFallback -contains $currentCulture.Name)) {
    $cultureFallback += $currentCulture.Name
    if ($currentCulture.Parent -and $currentCulture.Parent.Name -and $currentCulture.Parent.Name -ne $currentCulture.Name) {
        $currentCulture = $currentCulture.Parent
    }
    else {
        break
    }
}

$cultureFallback += 'en-US'
$cultureFallback += 'en'
$cultureFallback = $cultureFallback | Where-Object { -not [string]::IsNullOrWhiteSpace($_) } | Select-Object -Unique

$script:LocalizationMode = 'Auto'
$localizationModeEnv = $env:COLOR_SCRIPTS_ENHANCED_LOCALIZATION_MODE
if (-not [string]::IsNullOrWhiteSpace($localizationModeEnv)) {
    switch -Regex ($localizationModeEnv.Trim()) {
        '^(?i)(embedded|defaults?)$' { $script:LocalizationMode = 'Embedded'; break }
        '^(?i)(full|files?|load|disk)$' { $script:LocalizationMode = 'Full'; break }
        '^(?i)(auto)$' { $script:LocalizationMode = 'Auto'; break }
        default { $script:LocalizationMode = 'Auto' }
    }
}
elseif ($env:COLOR_SCRIPTS_ENHANCED_FORCE_LOCALIZATION -match '^(?i)(1|true|yes|full)$') {
    $script:LocalizationMode = 'Full'
}
elseif ($env:COLOR_SCRIPTS_ENHANCED_PREFER_EMBEDDED_MESSAGES -match '^(?i)(1|true|yes|embedded)$') {
    $script:LocalizationMode = 'Embedded'
}

$script:EmbeddedDefaultMessages = ConvertFrom-StringData @'
# ColorScripts-Enhanced Localized Messages
# English (en-US) - Default Language

# Error Messages
UnableToPrepareCacheDirectory = Unable to prepare cache directory '{0}': {1}
FailedToParseConfigurationFile = Failed to parse configuration file at '{0}': {1}. Using defaults.
UnableToResolveCachePath = Unable to resolve cache path '{0}'.
ConfiguredCachePathInvalid = Configured cache path '{0}' could not be resolved. Falling back to default locations.
UnableToResolveOutputPath = Unable to resolve output path '{0}'.
UnableToDetermineConfigurationDirectory = Unable to determine configuration directory for ColorScripts-Enhanced.
ConfigurationRootCouldNotBeResolved = Configuration root could not be resolved.
UnableToResolveProfilePath = Unable to resolve profile path '{0}'.
FailedToExecuteColorscript = Failed to execute colorscript '{0}': {1}
FailedToBuildCacheForScript = Failed to build cache for $($selection.Name).
CacheBuildFailedForScript = Cache build failed for {0}: {1}
ScriptAlreadyExists = Script '{0}' already exists. Use -Force to overwrite.
ProfilePathNotDefinedForScope = Profile path for scope '{0}' is not defined.
ScriptPathNotFound = Script path not found.
ScriptExitedWithCode = Script exited with code {0}.
CacheFileNotFound = Cache file not found.
NoChangesApplied = No changes applied.
UnableToRetrieveFileInfo = Unable to retrieve file info for '{0}': {1}
UnableToReadCacheInfo = Unable to read cache info for '{0}': {1}

# Warning Messages
NoColorscriptsFoundMatchingCriteria = No colorscripts found matching the specified criteria.
NoScriptsMatchedSpecifiedFilters = No scripts matched the specified filters.
NoColorscriptsAvailableWithFilters = No colorscripts available with the specified filters.
NoColorscriptsFoundInScriptsPath = No colorscripts found in $script:ScriptsPath
NoScriptsSelectedForCacheBuild = No scripts selected for cache build.
ScriptNotFound = Script not found: {0}
ColorscriptNotFoundWithFilters = Colorscript '{0}' not found with the specified filters.
CachePathNotFound = Cache path not found: {0}
NoCacheFilesFound = No cache files found at {0}.
ProfileUpdatesNotSupportedInRemote = Profile updates are not supported in remote sessions.
ScriptSkippedByFilter = Script '{0}' does not satisfy the specified filters and will be skipped.

# Status Messages
DisplayingColorscripts = `nDisplaying $totalCount colorscripts...
CacheBuildSummary = `nCache Build Summary:
FailedScripts = `nFailed scripts:
TotalScriptsProcessed = `nTotal scripts processed: $totalCount
DisplayingContinuously = Displaying continuously (Ctrl+C to stop)`n
FinishedDisplayingAll = Finished displaying all $totalCount colorscripts!
Quitting = `nQuitting...
CurrentIndexOfTotal = [$currentIndex/$totalCount]
FailedScriptDetails =   - $($failure.Name): $($failure.StdErr)
MultipleColorscriptsMatched = Multiple colorscripts matched the provided name pattern(s): {0}. Displaying '{1}'.
StatusCached = Cached
StatusSkippedUpToDate = Skipped (up-to-date)
StatusSkippedByUser = Skipped by user
StatusFailed = Failed
StatusUpToDateSkipped = Up-to-date (skipped)
CacheBuildSummaryFormat = Cache build summary: Processed {0}, Updated {1}, Skipped {2}, Failed {3}
CacheClearSummaryFormat = Cache clear summary: Removed {0}, Missing {1}, Skipped {2}, DryRun {3}, Errors {4}

# Interactive Messages
PressSpacebarToContinue = Press [Spacebar] to continue to next, [Q] to quit`n
PressSpacebarForNext = Press [Spacebar] for next, [Q] to quit...

# Success Messages
ProfileSnippetAdded = [OK] Added ColorScripts-Enhanced startup snippet to {0}
ProfileAlreadyContainsSnippet = Profile already contains ColorScripts-Enhanced snippet.
ProfileAlreadyImportsModule = Profile already imports ColorScripts-Enhanced.
ModuleLoadedSuccessfully = ColorScripts-Enhanced module loaded successfully.
RemoteSessionDetected = Remote session detected.
ProfileAlreadyConfigured = Profile already configured.
ProfileSnippetAddedMessage = ColorScripts-Enhanced profile snippet added.

# Help/Instruction Messages
SpecifyNameToSelectScripts = Specify -Name to select scripts when -All is explicitly disabled.
SpecifyAllOrNameToClearCache = Specify -All or -Name to clear cache entries.
UsePassThruForDetailedResults = Use -PassThru to see detailed results`n

# Miscellaneous
'@

if (-not $script:LocalizationSyncRoot) { $script:LocalizationSyncRoot = New-Object System.Object }
if (-not $script:ConfigurationSyncRoot) { $script:ConfigurationSyncRoot = New-Object System.Object }
if (-not $script:CacheSyncRoot) { $script:CacheSyncRoot = New-Object System.Object }
if (-not $script:MetadataSyncRoot) { $script:MetadataSyncRoot = New-Object System.Object }
if (-not $script:InventorySyncRoot) { $script:InventorySyncRoot = New-Object System.Object }
if (-not $script:DelegateSyncRoot) { $script:DelegateSyncRoot = New-Object System.Object }

$privateDirectory = Join-Path -Path $PSScriptRoot -ChildPath 'Private'
if (Test-Path -LiteralPath $privateDirectory) {
    Get-ChildItem -Path $privateDirectory -Filter '*.ps1' -File | Sort-Object Name | ForEach-Object {
        Write-ModuleTrace ('Loading private script: {0}' -f $_.Name)
        . $_.FullName
    }
}
else {
    Write-ModuleTrace ("Private script directory '{0}' was not found." -f $privateDirectory)
}

$localizationResult = Initialize-ColorScriptsLocalization -CandidateRoots ($moduleRootCandidates | Select-Object -Unique) -CultureFallbackOverride $cultureFallback -UseDefaultCandidates
if ($localizationResult -and $localizationResult.ModuleRoot) {
    $script:ModuleRoot = $localizationResult.ModuleRoot
}
elseif (-not $script:ModuleRoot) {
    if ($PSScriptRoot) {
        $script:ModuleRoot = $PSScriptRoot
    }
    elseif ($moduleInfo -and $moduleInfo.ModuleBase) {
        $script:ModuleRoot = $moduleInfo.ModuleBase
    }
}

if ($script:ModuleRoot) {
    try {
        $resolvedRoot = (Resolve-Path -LiteralPath $script:ModuleRoot -ErrorAction Stop).ProviderPath
        if ($resolvedRoot) {
            $script:ModuleRoot = $resolvedRoot
        }
    }
    catch {
        Write-ModuleTrace ('Resolve-Path for module root failed: {0}' -f $_.Exception.Message)
    }

    $script:ScriptsPath = Join-Path -Path $script:ModuleRoot -ChildPath 'Scripts'
    $script:MetadataPath = Join-Path -Path $script:ModuleRoot -ChildPath 'ScriptMetadata.psd1'
    Write-ModuleTrace ('Module root finalized at {0}' -f $script:ModuleRoot)
}
else {
    Write-ModuleTrace 'Module root could not be determined; relative operations may fail.'
}

$publicDirectory = Join-Path -Path $PSScriptRoot -ChildPath 'Public'
if (Test-Path -LiteralPath $publicDirectory) {
    Get-ChildItem -Path $publicDirectory -Filter '*.ps1' -File | Sort-Object Name | ForEach-Object {
        Write-ModuleTrace ('Loading public script: {0}' -f $_.Name)
        . $_.FullName
    }
}
else {
    Write-ModuleTrace ("Public script directory '{0}' was not found; exported functions may be unavailable." -f $publicDirectory)
}

Initialize-SystemDelegateState

Export-ModuleMember -Function @(
    'Show-ColorScript',
    'Get-ColorScriptList',
    'New-ColorScriptCache',
    'Clear-ColorScriptCache',
    'Add-ColorScriptProfile',
    'Get-ColorScriptConfiguration',
    'Set-ColorScriptConfiguration',
    'Reset-ColorScriptConfiguration',
    'Export-ColorScriptMetadata',
    'New-ColorScript'
) -Alias @('scs', 'Update-ColorScriptCache', 'Build-ColorScriptCache')

if ($script:Messages -and $script:Messages.ContainsKey('ModuleLoadedSuccessfully')) {
    Write-Verbose $script:Messages.ModuleLoadedSuccessfully
}
else {
    Write-Verbose 'ColorScripts-Enhanced module loaded successfully.'
}

try {
    Invoke-ColorScriptsStartup
}
catch {
    Write-ModuleTrace ('Startup invocation failure: {0}' -f $_.Exception.Message)
    Write-Verbose ('Auto-show on import skipped: {0}' -f $_.Exception.Message)
}

Write-ModuleTrace ('--- Import complete: {0} ---' -f (Get-Date -Format o))
