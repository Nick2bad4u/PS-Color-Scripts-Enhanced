#Requires -Version 5.1

# ColorScripts-Enhanced Module
# High-performance colorscripts with intelligent caching

# Module variables
$script:ModuleRoot = $null
$script:ScriptsPath = $null
$script:MetadataPath = $null
$script:MetadataCache = $null
$script:MetadataLastWriteTime = $null
$script:PowerShellExecutable = $null
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
            '^(?i)(1|true|yes|on)$' {
                $script:ModuleTraceUseVerbose = $true
                continue
            }
            '^(?i)verbose$' {
                $script:ModuleTraceUseVerbose = $true
                continue
            }
            '^(?i)debug$' {
                $script:ModuleTraceUseDebug = $true
                continue
            }
            '^(?i)file$' {
                $script:ModuleTraceUseFile = $true
                continue
            }
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
        $traceDirectory = $null
        try {
            $traceDirectory = Split-Path -Path $script:ModuleTraceFile -Parent
            if ($traceDirectory -and -not (Test-Path -LiteralPath $traceDirectory)) {
                New-Item -ItemType Directory -Path $traceDirectory -Force | Out-Null
            }
        }
        catch {
            $script:ModuleTraceUseFile = $false
            if ($traceDirectory) {
                Write-Verbose ("Unable to prepare trace directory '{0}': {1}" -f $traceDirectory, $_.Exception.Message)
            }
        }
    }
}

function Write-ModuleTrace {
    param(
        [Parameter(Mandatory)][string]$Message
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

# Determine the actual module root so that localized resources resolve correctly
$moduleInfo = $ExecutionContext.SessionState.Module
$moduleRootCandidates = @()
Write-ModuleTrace ("--- Import begin: {0} ---" -f (Get-Date -Format o))
if ($moduleInfo) {
    Write-ModuleTrace ("ModuleInfo.ModuleBase = {0}" -f $moduleInfo.ModuleBase)
    Write-ModuleTrace ("ModuleInfo.Path = {0}" -f $moduleInfo.Path)
}
else {
    Write-ModuleTrace 'ModuleInfo.ModuleBase = <null>'
    Write-ModuleTrace 'ModuleInfo.Path = <null>'
}
Write-ModuleTrace ("PSScriptRoot = {0}" -f $PSScriptRoot)

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
    Write-ModuleTrace ("ListAvailable ModuleBase = {0}" -f $availableModule.ModuleBase)
}

$environmentModuleRoot = $env:COLOR_SCRIPTS_ENHANCED_MODULE_ROOT
if ($environmentModuleRoot) {
    $moduleRootCandidates += $environmentModuleRoot
    Write-ModuleTrace ("Environment module root = {0}" -f $environmentModuleRoot)
}

Write-ModuleTrace ("Initial candidates: {0}" -f ($moduleRootCandidates -join ';'))

$resolvedCandidates = @()
foreach ($candidate in $moduleRootCandidates) {
    if (-not $candidate) {
        continue
    }

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
Write-ModuleTrace ("Resolved candidates: {0}" -f ($moduleRootCandidates -join ';'))

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
$cultureFallbackClean = @()
foreach ($cultureName in $cultureFallback) {
    if (-not $cultureName) {
        continue
    }

    if ([string]::IsNullOrWhiteSpace($cultureName)) {
        continue
    }

    if ($cultureFallbackClean -notcontains $cultureName) {
        $cultureFallbackClean += $cultureName
    }
}

$cultureFallback = $cultureFallbackClean

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

# Interactive Messages
PressSpacebarToContinue = Press [Spacebar] to continue to next, [Q] to quit`n
PressSpacebarForNext = Press [Spacebar] for next, [Q] to quit...

# Success Messages
ProfileSnippetAdded = [OK] Added ColorScripts-Enhanced startup snippet to $profilePath
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

# UI Elements

# Miscellaneous
'@

function Resolve-LocalizedMessagesFile {
    param(
        [Parameter(Mandatory)][string]$BaseDirectory,
        [Parameter(Mandatory)][string[]]$CultureFallback
    )

    $messagesFileName = 'Messages.psd1'

    $directoryEntries = Get-ChildItem -LiteralPath $BaseDirectory -Directory -ErrorAction SilentlyContinue
    if (-not $directoryEntries) {
        $directoryEntries = @()
    }

    foreach ($cultureName in $CultureFallback) {
        if ([string]::IsNullOrWhiteSpace($cultureName)) {
            continue
        }

        $resolvedDirectory = $null
        $directCulturePath = Join-Path -Path $BaseDirectory -ChildPath $cultureName

        if (Test-Path -LiteralPath $directCulturePath -PathType Container) {
            $resolvedResult = Resolve-Path -LiteralPath $directCulturePath -ErrorAction SilentlyContinue
            if ($resolvedResult) {
                $resolvedDirectory = $resolvedResult.ProviderPath
            }
            else {
                $resolvedDirectory = $directCulturePath
            }
        }

        if (-not $resolvedDirectory) {
            $matchingDirectory = $null
            foreach ($entry in $directoryEntries) {
                if ($entry.Name.Equals($cultureName, [System.StringComparison]::OrdinalIgnoreCase)) {
                    $matchingDirectory = $entry.FullName
                    break
                }
            }

            if ($matchingDirectory) {
                $resolvedDirectory = $matchingDirectory
            }
        }

        if (-not $resolvedDirectory) {
            continue
        }

        $candidateFile = Join-Path -Path $resolvedDirectory -ChildPath $messagesFileName

        if (-not (Test-Path -LiteralPath $candidateFile -PathType Leaf)) {
            $filesInDirectory = Get-ChildItem -LiteralPath $resolvedDirectory -File -ErrorAction SilentlyContinue
            if (-not $filesInDirectory) {
                $filesInDirectory = @()
            }

            $candidateFile = $null
            foreach ($fileEntry in $filesInDirectory) {
                if ($fileEntry.Name.Equals($messagesFileName, [System.StringComparison]::OrdinalIgnoreCase)) {
                    $candidateFile = $fileEntry.FullName
                    break
                }
            }
        }

        if ($candidateFile -and (Test-Path -LiteralPath $candidateFile -PathType Leaf)) {
            $resolvedFile = $candidateFile
            $resolvedFilePath = Resolve-Path -LiteralPath $candidateFile -ErrorAction SilentlyContinue
            if ($resolvedFilePath) {
                $resolvedFile = $resolvedFilePath.ProviderPath
            }

            return [pscustomobject]@{
                FilePath    = $resolvedFile
                CultureName = $cultureName
            }
        }
    }

    $rootFile = Join-Path -Path $BaseDirectory -ChildPath $messagesFileName

    if (-not (Test-Path -LiteralPath $rootFile -PathType Leaf)) {
        $rootFiles = Get-ChildItem -LiteralPath $BaseDirectory -File -ErrorAction SilentlyContinue
        if (-not $rootFiles) {
            $rootFiles = @()
        }

        $rootFile = $null
        foreach ($fileEntry in $rootFiles) {
            if ($fileEntry.Name.Equals($messagesFileName, [System.StringComparison]::OrdinalIgnoreCase)) {
                $rootFile = $fileEntry.FullName
                break
            }
        }
    }

    if ($rootFile -and (Test-Path -LiteralPath $rootFile -PathType Leaf)) {
        $resolvedRootFile = $rootFile
        $resolvedRootResult = Resolve-Path -LiteralPath $rootFile -ErrorAction SilentlyContinue
        if ($resolvedRootResult) {
            $resolvedRootFile = $resolvedRootResult.ProviderPath
        }

        return [pscustomobject]@{
            FilePath    = $resolvedRootFile
            CultureName = $null
        }
    }

    return $null
}

function Import-LocalizedMessagesFromFile {
    param(
        [Parameter(Mandatory)][string]$FilePath
    )

    if (-not (Test-Path -LiteralPath $FilePath -PathType Leaf)) {
        throw [System.IO.FileNotFoundException]::new("Localization file '$FilePath' was not found.")
    }

    $rawContent = Get-Content -LiteralPath $FilePath -Raw -Encoding UTF8 -ErrorAction Stop

    $messagesBody = $null
    $match = [System.Text.RegularExpressions.Regex]::Match(
        $rawContent,
        "ConvertFrom-StringData\s*@'(?<body>.*)'@",
        [System.Text.RegularExpressions.RegexOptions]::Singleline
    )

    if ($match.Success) {
        $messagesBody = $match.Groups['body'].Value
    }

    if ($messagesBody) {
        $script:Messages = ConvertFrom-StringData -StringData $messagesBody
        return
    }

    $data = Import-PowerShellDataFile -Path $FilePath
    if ($data -isnot [hashtable]) {
        throw [System.InvalidOperationException]::new("Localization file '$FilePath' did not return a hashtable.")
    }

    $script:Messages = $data
}

function Initialize-ColorScriptsLocalization {
    param(
        [Parameter()][string[]]$CandidateRoots,
        [Parameter()][string[]]$CultureFallbackOverride
    )

    $pathsToEvaluate = @()
    if ($CandidateRoots) {
        $pathsToEvaluate = $CandidateRoots
    }

    $fallbackCultures = if ($CultureFallbackOverride) { $CultureFallbackOverride } else { $cultureFallback }

    $script:Messages = $null
    $localizedDataLoaded = $false
    $searchedPaths = @()

    foreach ($candidatePath in $pathsToEvaluate) {
        $searchedPaths += $candidatePath
        Write-ModuleTrace ("Evaluating candidate: {0}" -f $candidatePath)

        $resolvedLocalization = Resolve-LocalizedMessagesFile -BaseDirectory $candidatePath -CultureFallback $fallbackCultures

        if (-not $resolvedLocalization) {
            Write-ModuleTrace ("No localized data found under {0}" -f $candidatePath)
            continue
        }

        $importSucceeded = $true
        try {
            Import-LocalizedMessagesFromFile -FilePath $resolvedLocalization.FilePath
        }
        catch {
            $importSucceeded = $false
            Write-ModuleTrace ("Localization import failed for {0}: {1}" -f $candidatePath, $_.Exception.Message)
        }

        if (-not $importSucceeded) {
            continue
        }

        $script:ModuleRoot = $candidatePath
        $localizedDataLoaded = $true

        $logMessage = "Resolved localization using file: $($resolvedLocalization.FilePath)"
        if ($resolvedLocalization.CultureName) {
            $logMessage += " (culture: $($resolvedLocalization.CultureName))"
        }

        Write-ModuleTrace $logMessage
        Write-ModuleTrace ("Localization loaded from {0} (method: direct-file)" -f $candidatePath)
        break
    }

    if (-not $localizedDataLoaded) {
        $searchedDescription = if ($searchedPaths) { ($searchedPaths -join ', ') } else { '<none>' }
        Write-ModuleTrace ("Localization fallback engaged. Searched paths: {0}" -f $searchedDescription)

        $fallbackRoot = $searchedPaths | Where-Object { Test-Path -LiteralPath $_ -PathType Container } | Select-Object -First 1
        if (-not $fallbackRoot) {
            $resolvedRoot = Resolve-Path -LiteralPath $PSScriptRoot -ErrorAction SilentlyContinue
            if ($resolvedRoot) {
                $fallbackRoot = $resolvedRoot.ProviderPath
            }
            else {
                $fallbackRoot = $PSScriptRoot
            }
        }

        $script:ModuleRoot = $fallbackRoot
        $script:Messages = $script:EmbeddedDefaultMessages.Clone()
        Write-Warning "Localization resources were not found. Falling back to built-in English messages."
    }

    [pscustomobject]@{
        LocalizedDataLoaded = $localizedDataLoaded
        SearchedPaths       = $searchedPaths
        ModuleRoot          = $script:ModuleRoot
    }
}

$null = Initialize-ColorScriptsLocalization -CandidateRoots ($moduleRootCandidates | Select-Object -Unique)

$script:ScriptsPath = Join-Path -Path $script:ModuleRoot -ChildPath "Scripts"
$script:MetadataPath = Join-Path -Path $script:ModuleRoot -ChildPath "ScriptMetadata.psd1"

function ConvertTo-HashtableInternal {
    param([Parameter(ValueFromPipeline)]$InputObject)

    process {
        if ($null -eq $InputObject) {
            return $null
        }

        if ($InputObject -is [System.Collections.IEnumerable] -and $InputObject -isnot [string]) {
            $collection = @()
            foreach ($item in $InputObject) {
                $collection += ConvertTo-HashtableInternal $item
            }
            return $collection
        }

        if ($InputObject -is [PSCustomObject]) {
            $hash = @{}
            foreach ($property in $InputObject.PSObject.Properties) {
                $hash[$property.Name] = ConvertTo-HashtableInternal $property.Value
            }
            return $hash
        }

        return $InputObject
    }
}

function ConvertFrom-JsonToHashtable {
    <#
    .SYNOPSIS
        Converts JSON to a hashtable, compatible with PowerShell 5.1 and 7+
    .DESCRIPTION
        PowerShell 5.1 doesn't support -AsHashtable parameter on ConvertFrom-Json.
        This function provides a compatible conversion method for all PowerShell versions.
    #>
    param(
        [Parameter(Mandatory, ValueFromPipeline)]
        [AllowEmptyString()]
        [string]$InputObject
    )

    process {
        if ([string]::IsNullOrWhiteSpace($InputObject)) {
            return $null
        }

        # PowerShell 6.0+ supports -AsHashtable natively
        if ($PSVersionTable.PSVersion.Major -ge 6) {
            return ConvertFrom-Json -InputObject $InputObject -AsHashtable
        }

        $obj = ConvertFrom-Json -InputObject $InputObject
        return ConvertTo-HashtableInternal $obj
    }
}

function Get-ColorScriptAnsiSequence {
    param([string]$Color)

    if ([string]::IsNullOrWhiteSpace($Color)) {
        return $null
    }

    switch ($Color.ToLowerInvariant()) {
        'cyan' { return "${([char]27)}[36m" }
        'yellow' { return "${([char]27)}[33m" }
        'green' { return "${([char]27)}[32m" }
        'magenta' { return "${([char]27)}[35m" }
        'darkgray' { return "${([char]27)}[90m" }
        'red' { return "${([char]27)}[31m" }
        'blue' { return "${([char]27)}[34m" }
        default { return $null }
    }
}

function New-ColorScriptAnsiText {
    param(
        [AllowNull()][string]$Text,
        [string]$Color,
        [switch]$NoAnsiOutput
    )

    $resolvedText = if ($null -ne $Text) { [string]$Text } else { '' }

    if ($NoAnsiOutput) {
        return $resolvedText
    }

    $sequence = Get-ColorScriptAnsiSequence -Color $Color
    if (-not $sequence) {
        return $resolvedText
    }

    return "${sequence}${resolvedText}${([char]27)}[0m"
}

function Remove-ColorScriptAnsiSequence {
    param([AllowNull()][string]$Text)

    if ($null -eq $Text) {
        return $Text
    }

    if (-not $script:AnsiStripRegex) {
        $pattern = "${([char]27)}\[[0-9;]*[A-Za-z]"
        $script:AnsiStripRegex = [System.Text.RegularExpressions.Regex]::new(
            $pattern,
            [System.Text.RegularExpressions.RegexOptions]::Compiled
        )
    }

    return $script:AnsiStripRegex.Replace([string]$Text, '')
}

function Write-ColorScriptInformation {
    param(
        [AllowNull()][string]$Message,
        [switch]$Quiet
    )

    if ($Quiet) {
        return
    }

    $output = if ($null -ne $Message) { [string]$Message } else { '' }
    Write-Information -MessageData $output -InformationAction Continue -Tags 'ColorScripts'
}

function Initialize-SystemDelegateState {
    if (-not $script:GetUserProfilePathDelegate) {
        $script:GetUserProfilePathDelegate = { [System.Environment]::GetFolderPath('UserProfile') }
    }

    if (-not $script:IsPathRootedDelegate) {
        $script:IsPathRootedDelegate = {
            param([string]$Path)
            [System.IO.Path]::IsPathRooted($Path)
        }
    }

    if (-not $script:GetFullPathDelegate) {
        $script:GetFullPathDelegate = {
            param([string]$Path)
            [System.IO.Path]::GetFullPath($Path)
        }
    }

    if (-not $script:GetCurrentDirectoryDelegate) {
        $script:GetCurrentDirectoryDelegate = {
            [System.IO.Directory]::GetCurrentDirectory()
        }
    }

    if (-not $script:GetCurrentProviderPathDelegate) {
        $script:GetCurrentProviderPathDelegate = {
            $ExecutionContext.SessionState.Path.CurrentFileSystemLocation.ProviderPath
        }
    }

    if (-not $script:DirectoryGetLastWriteTimeUtcDelegate) {
        $script:DirectoryGetLastWriteTimeUtcDelegate = {
            param([string]$Path)
            [System.IO.Directory]::GetLastWriteTimeUtc($Path)
        }
    }

    if (-not $script:FileExistsDelegate) {
        $script:FileExistsDelegate = {
            param([string]$Path)
            [System.IO.File]::Exists($Path)
        }
    }

    if (-not $script:FileGetLastWriteTimeUtcDelegate) {
        $script:FileGetLastWriteTimeUtcDelegate = {
            param([string]$Path)
            [System.IO.File]::GetLastWriteTimeUtc($Path)
        }
    }

    if (-not $script:FileReadAllTextDelegate) {
        $script:FileReadAllTextDelegate = {
            param([string]$Path, [System.Text.Encoding]$Encoding)
            [System.IO.File]::ReadAllText($Path, $Encoding)
        }
    }

    if (-not $script:GetCurrentProcessDelegate) {
        $script:GetCurrentProcessDelegate = {
            [System.Diagnostics.Process]::GetCurrentProcess()
        }
    }

    if (-not $script:IsOutputRedirectedDelegate) {
        $script:IsOutputRedirectedDelegate = { [Console]::IsOutputRedirected }
    }

    if (-not $script:GetConsoleOutputEncodingDelegate) {
        $script:GetConsoleOutputEncodingDelegate = { [Console]::OutputEncoding }
    }

    if (-not $script:SetConsoleOutputEncodingDelegate) {
        $script:SetConsoleOutputEncodingDelegate = {
            param([System.Text.Encoding]$Encoding)
            [Console]::OutputEncoding = $Encoding
        }
    }

    if (-not $script:ConsoleWriteDelegate) {
        $script:ConsoleWriteDelegate = {
            param([string]$Text)
            [Console]::Write($Text)
        }
    }

    if (-not $script:CreateDirectoryDelegate) {
        $script:CreateDirectoryDelegate = {
            param([string]$Path)
            [System.IO.Directory]::CreateDirectory($Path)
        }
    }
}

Initialize-SystemDelegateState

function Invoke-ShouldProcess {
    [CmdletBinding(SupportsShouldProcess = $true)]
    param(
        [System.Management.Automation.PSCmdlet]$Cmdlet,
        [object]$Target,
        [string]$Action
    )

    if ($script:ShouldProcessEvaluator -is [scriptblock]) {
        return & $script:ShouldProcessEvaluator $Cmdlet $Target $Action
    }

    if ($script:ShouldProcessOverride -is [scriptblock]) {
        return & $script:ShouldProcessOverride $Cmdlet $Target $Action
    }

    return $Cmdlet.ShouldProcess($Target, $Action)
}

function Invoke-FileWriteAllText {
    param(
        [Parameter(Mandatory)]
        [ValidateScript({ Test-ColorScriptPathValue $_ })]
        [string]$Path,
        [Parameter(Mandatory)]
        [string]$Content,
        [Parameter(Mandatory)]
        [System.Text.Encoding]$Encoding
    )

    [System.IO.File]::WriteAllText($Path, $Content, $Encoding)
}

function Get-FileLastWriteTimeUtc {
    param([Parameter(Mandatory)][string]$Path)
    [System.IO.File]::GetLastWriteTimeUtc($Path)
}

function Set-FileLastWriteTimeUtc {
    param(
        [Parameter(Mandatory)][string]$Path,
        [Parameter(Mandatory)][datetime]$Timestamp
    )

    [System.IO.File]::SetLastWriteTimeUtc($Path, $Timestamp)
}

function Get-FileLastWriteTime {
    param([Parameter(Mandatory)][string]$Path)
    [System.IO.File]::GetLastWriteTime($Path)
}

function Set-FileLastWriteTime {
    param(
        [Parameter(Mandatory)][string]$Path,
        [Parameter(Mandatory)][datetime]$Timestamp
    )

    [System.IO.File]::SetLastWriteTime($Path, $Timestamp)
}

function Copy-ColorScriptHashtable {
    param([System.Collections.IDictionary]$Source)

    if (-not $Source) {
        return @{}
    }

    $clone = @{}
    foreach ($key in $Source.Keys) {
        $value = $Source[$key]
        switch ($true) {
            { $value -is [System.Collections.IDictionary] } {
                $clone[$key] = Copy-ColorScriptHashtable $value
                break
            }
            { $value -is [System.Array] } {
                $clone[$key] = $value.Clone()
                break
            }
            { $value -is [System.ICloneable] -and $value -isnot [string] } {
                $clone[$key] = $value.Clone()
                break
            }
            { $value -is [System.Collections.IEnumerable] -and $value -isnot [string] } {
                $buffer = New-Object System.Collections.Generic.List[object]
                foreach ($item in $value) {
                    $null = $buffer.Add($item)
                }
                $clone[$key] = $buffer.ToArray()
                break
            }
            default {
                $clone[$key] = $value
            }
        }
    }

    return $clone
}

function Merge-ColorScriptConfiguration {
    param(
        [System.Collections.IDictionary]$Base,
        [System.Collections.IDictionary]$Override
    )

    if (-not $Override) {
        return Copy-ColorScriptHashtable $Base
    }

    $result = Copy-ColorScriptHashtable $Base
    foreach ($key in $Override.Keys) {
        $overrideValue = $Override[$key]
        if ($result.ContainsKey($key)) {
            $baseValue = $result[$key]
            if ($baseValue -is [System.Collections.IDictionary] -and $overrideValue -is [System.Collections.IDictionary]) {
                $result[$key] = Merge-ColorScriptConfiguration $baseValue $overrideValue
                continue
            }
        }

        switch ($true) {
            { $overrideValue -is [System.Collections.IDictionary] } {
                $result[$key] = Copy-ColorScriptHashtable $overrideValue
                break
            }
            { $overrideValue -is [System.Array] } {
                $result[$key] = $overrideValue.Clone()
                break
            }
            { $overrideValue -is [System.ICloneable] -and $overrideValue -isnot [string] } {
                $result[$key] = $overrideValue.Clone()
                break
            }
            { $overrideValue -is [System.Collections.IEnumerable] -and $overrideValue -isnot [string] } {
                $buffer = New-Object System.Collections.Generic.List[object]
                foreach ($item in $overrideValue) {
                    $null = $buffer.Add($item)
                }
                $result[$key] = $buffer.ToArray()
                break
            }
            default {
                $result[$key] = $overrideValue
            }
        }
    }

    return $result
}

function Show-ColorScriptHelp {
    <#
    .SYNOPSIS
    Displays colorized help output for a command.
    #>
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSAvoidUsingWriteHost', '', Justification = 'Write-Host is intentionally used for colored help output to the console.')]
    param(
        [Parameter(Mandatory)]
        [string]$CommandName
    )

    # Get the help content
    $helpContent = Get-Help $CommandName -Full | Out-String

    # Split into lines for colorization
    $lines = $helpContent -split "`n"

    foreach ($line in $lines) {
        if ($line -match '^NAME$|^SYNOPSIS$|^SYNTAX$|^DESCRIPTION$|^PARAMETERS$|^EXAMPLES$|^INPUTS$|^OUTPUTS$|^NOTES$|^RELATED LINKS$') {
            # Section headers in cyan
            Write-Host $line -ForegroundColor Cyan
        }
        elseif ($line -match '^\s+-\w+') {
            # Parameter names in yellow
            Write-Host $line -ForegroundColor Yellow
        }
        elseif ($line -match '^\s+--') {
            # Example commands in green
            Write-Host $line -ForegroundColor Green
        }
        elseif ($line -match 'EXAMPLE \d+') {
            # Example headers in magenta
            Write-Host $line -ForegroundColor Magenta
        }
        elseif ($line -match '^\s+Required\?|^\s+Position\?|^\s+Default value|^\s+Accept pipeline input\?|^\s+Accept wildcard characters\?') {
            # Parameter metadata in dark gray
            Write-Host $line -ForegroundColor DarkGray
        }
        else {
            # Regular text
            Write-Host $line
        }
    }
}

function Get-ColorScriptsConfigurationRoot {
    if ($script:ConfigurationRoot) {
        return $script:ConfigurationRoot
    }

    $candidates = @()

    $overrideRoot = $env:COLOR_SCRIPTS_ENHANCED_CONFIG_ROOT
    if (-not [string]::IsNullOrWhiteSpace($overrideRoot)) {
        $candidates += $overrideRoot
    }

    if ($script:IsWindows -or $PSVersionTable.PSVersion.Major -le 5) {
        if ($env:APPDATA) {
            $candidates += (Join-Path -Path $env:APPDATA -ChildPath 'ColorScripts-Enhanced')
        }
    }
    elseif ($script:IsMacOS) {
        $macBase = Join-Path -Path $HOME -ChildPath 'Library'
        $macBase = Join-Path -Path $macBase -ChildPath 'Application Support'
        $candidates += (Join-Path -Path $macBase -ChildPath 'ColorScripts-Enhanced')
    }
    else {
        $xdgConfig = if ($env:XDG_CONFIG_HOME) { $env:XDG_CONFIG_HOME } else { Join-Path -Path $HOME -ChildPath '.config' }
        if (-not [string]::IsNullOrWhiteSpace($xdgConfig)) {
            $candidates += (Join-Path -Path $xdgConfig -ChildPath 'ColorScripts-Enhanced')
        }
    }

    if ($candidates.Count -eq 0) {
        $candidates = @([System.IO.Path]::Combine([System.IO.Path]::GetTempPath(), 'ColorScripts-Enhanced'))
    }

    foreach ($candidate in $candidates) {
        if ([string]::IsNullOrWhiteSpace($candidate)) { continue }
        $resolved = Resolve-CachePath -Path $candidate
        if (-not $resolved) { continue }

        try {
            if (-not (Test-Path -LiteralPath $resolved)) {
                (& $script:CreateDirectoryDelegate $resolved) | Out-Null
            }
            $script:ConfigurationRoot = $resolved
            return $script:ConfigurationRoot
        }
        catch {
            Write-Verbose "Unable to prepare configuration directory '$resolved': $($_.Exception.Message)"
        }
    }

    Invoke-ColorScriptError -Message $script:Messages.UnableToDetermineConfigurationDirectory -ErrorId 'ColorScriptsEnhanced.ConfigurationRootUnavailable' -Category ([System.Management.Automation.ErrorCategory]::ResourceUnavailable)
}

function Save-ColorScriptConfiguration {
    param(
        [hashtable]$Configuration,
        [string]$ExistingContent,
        [switch]$Force
    )

    $configRoot = Get-ColorScriptsConfigurationRoot
    if (-not $configRoot) {
        Invoke-ColorScriptError -Message $script:Messages.ConfigurationRootCouldNotBeResolved -ErrorId 'ColorScriptsEnhanced.ConfigurationRootNotResolved' -Category ([System.Management.Automation.ErrorCategory]::ResourceUnavailable)
    }

    $script:ConfigurationPath = Join-Path -Path $configRoot -ChildPath 'config.json'
    $json = $Configuration | ConvertTo-Json -Depth 6
    $normalizedNew = $json.TrimEnd("`r", "`n")

    if (-not $Force) {
        if (-not $ExistingContent -and (Test-Path -LiteralPath $script:ConfigurationPath)) {
            try {
                $ExistingContent = Get-Content -LiteralPath $script:ConfigurationPath -Raw -ErrorAction Stop
            }
            catch {
                $ExistingContent = $null
            }
        }

        if ($ExistingContent) {
            $normalizedExisting = $ExistingContent.TrimEnd("`r", "`n")
            if ($normalizedExisting -eq $normalizedNew) {
                return
            }
        }
        elseif (-not (Test-Path -LiteralPath $script:ConfigurationPath)) {
            # Nothing to compare against and no destination file. Continue to write defaults.
        }
        else {
            # File exists but contained only whitespace or was unreadable; continue with write.
        }
    }

    Set-Content -Path $script:ConfigurationPath -Value ($json + [Environment]::NewLine) -Encoding UTF8
}

function Initialize-Configuration {
    if ($script:ConfigurationInitialized -and $script:ConfigurationData) {
        return
    }

    $configRoot = Get-ColorScriptsConfigurationRoot
    $script:ConfigurationPath = Join-Path -Path $configRoot -ChildPath 'config.json'

    $existing = $null
    $raw = $null
    $forceSave = $false
    $configExists = Test-Path -LiteralPath $script:ConfigurationPath

    if ($configExists) {
        try {
            $raw = Get-Content -LiteralPath $script:ConfigurationPath -Raw -ErrorAction Stop
            if (-not [string]::IsNullOrWhiteSpace($raw)) {
                $existing = ConvertFrom-JsonToHashtable -InputObject $raw
            }
            else {
                $raw = $null
            }
        }
        catch {
            Write-Warning ($script:Messages.FailedToParseConfigurationFile -f $script:ConfigurationPath, $_.Exception.Message)
            $forceSave = $true
            $raw = $null
        }
    }

    $script:ConfigurationData = Merge-ColorScriptConfiguration $script:DefaultConfiguration $existing

    if ($forceSave -or -not $configExists) {
        Save-ColorScriptConfiguration -Configuration $script:ConfigurationData -ExistingContent $raw -Force:$forceSave
    }

    $script:ConfigurationInitialized = $true
}

function Get-ConfigurationDataInternal {
    Initialize-Configuration
    return $script:ConfigurationData
}

function Get-ColorScriptConfiguration {
    <#
    .EXTERNALHELP ColorScripts-Enhanced-help.xml
    #>
    [OutputType([hashtable])]
    [CmdletBinding(HelpUri = 'https://nick2bad4u.github.io/PS-Color-Scripts-Enhanced/docs/help-redirect.html?cmdlet=Get-ColorScriptConfiguration')]
    param(
        [Alias('help')]
        [switch]$h
    )

    if ($h) {
        Show-ColorScriptHelp -CommandName 'Get-ColorScriptConfiguration'
        return
    }

    $data = Copy-ColorScriptHashtable (Get-ConfigurationDataInternal)
    return $data
}

function Set-ColorScriptConfiguration {
    <#
    .EXTERNALHELP ColorScripts-Enhanced-help.xml
    #>
    [OutputType([hashtable])]
    [CmdletBinding(SupportsShouldProcess = $true, HelpUri = 'https://nick2bad4u.github.io/PS-Color-Scripts-Enhanced/docs/help-redirect.html?cmdlet=Set-ColorScriptConfiguration')]
    param(
        [Alias('help')]
        [switch]$h,

        [Nullable[bool]]$AutoShowOnImport,
        [Nullable[bool]]$ProfileAutoShow,
        [ValidateScript({ Test-ColorScriptPathValue $_ -AllowEmpty })]
        [string]$CachePath,
        [ValidateScript({ Test-ColorScriptNameValue $_ -AllowEmpty })]
        [string]$DefaultScript,
        [switch]$PassThru
    )

    if ($h) {
        Show-ColorScriptHelp -CommandName 'Set-ColorScriptConfiguration'
        return
    }

    $data = Get-ConfigurationDataInternal

    if ($PSBoundParameters.ContainsKey('AutoShowOnImport')) {
        $data.Startup.AutoShowOnImport = [bool]$AutoShowOnImport
    }

    if ($PSBoundParameters.ContainsKey('ProfileAutoShow')) {
        $data.Startup.ProfileAutoShow = [bool]$ProfileAutoShow
    }

    if ($PSBoundParameters.ContainsKey('CachePath')) {
        if ([string]::IsNullOrWhiteSpace($CachePath)) {
            $data.Cache.Path = $null
        }
        else {
            $resolvedCache = Resolve-CachePath -Path $CachePath
            if (-not $resolvedCache) {
                Invoke-ColorScriptError -Message ($script:Messages.UnableToResolveCachePath -f $CachePath) -ErrorId 'ColorScriptsEnhanced.InvalidCachePath' -Category ([System.Management.Automation.ErrorCategory]::InvalidArgument) -TargetObject $CachePath -Cmdlet $PSCmdlet
            }

            if (-not (Test-Path -LiteralPath $resolvedCache)) {
                New-Item -ItemType Directory -Path $resolvedCache -Force | Out-Null
            }

            $data.Cache.Path = $resolvedCache
        }

        $script:CacheInitialized = $false
        $script:CacheDir = $null
    }

    if ($PSBoundParameters.ContainsKey('DefaultScript')) {
        if ([string]::IsNullOrWhiteSpace($DefaultScript)) {
            $data.Startup.DefaultScript = $null
        }
        else {
            $data.Startup.DefaultScript = [string]$DefaultScript
        }
    }

    $configRoot = Get-ColorScriptsConfigurationRoot
    $configPath = Join-Path -Path $configRoot -ChildPath 'config.json'

    if ($PSCmdlet.ShouldProcess($configPath, 'Update ColorScripts-Enhanced configuration')) {
        Save-ColorScriptConfiguration -Configuration $data -Force
    }

    if ($PassThru) {
        return Get-ColorScriptConfiguration
    }
}

function Reset-ColorScriptConfiguration {
    <#
    .EXTERNALHELP ColorScripts-Enhanced-help.xml
    #>
    [OutputType([hashtable])]
    [CmdletBinding(SupportsShouldProcess = $true, HelpUri = 'https://nick2bad4u.github.io/PS-Color-Scripts-Enhanced/docs/help-redirect.html?cmdlet=Reset-ColorScriptConfiguration')]
    param(
        [Alias('help')]
        [switch]$h,

        [switch]$PassThru
    )

    if ($h) {
        Show-ColorScriptHelp -CommandName 'Reset-ColorScriptConfiguration'
        return
    }

    $configRoot = Get-ColorScriptsConfigurationRoot
    $configPath = Join-Path -Path $configRoot -ChildPath 'config.json'

    if ($PSCmdlet.ShouldProcess($configPath, 'Reset ColorScripts-Enhanced configuration')) {
        $script:ConfigurationData = Copy-ColorScriptHashtable $script:DefaultConfiguration
        Save-ColorScriptConfiguration -Configuration $script:ConfigurationData -Force
        $script:CacheInitialized = $false
        $script:CacheDir = $null
    }

    if ($PassThru) {
        return Get-ColorScriptConfiguration
    }
}

$script:DefaultAutoCategoryRules = @(
    [pscustomobject]@{
        Category = 'System'
        Tags     = @('System', 'Utility')
        Patterns = @(
            '^(00default|alpha)$',
            '^ansi-palette$',
            '^awk-rgb-test$',
            '^colortest(-slim)?$',
            '^colorbars$',
            '^colorview$',
            '^colorwheel$',
            '^(A{6}|O{6})$',
            '^nerd-font-(glyphs|test)$',
            '^rgb-spectrum$',
            '^RGB-Wave(-Shifted)?$',
            '^spectrum(-flames)?$',
            '^terminal-benchmark$',
            '^text-styles$',
            '^unicode-showcase$',
            '^gradient-test$'
        )
    },
    [pscustomobject]@{
        Category = 'TerminalThemes'
        Tags     = @('Terminal', 'Theme')
        Patterns = @('^terminal($|-.*)')
    },
    [pscustomobject]@{
        Category = 'Logos'
        Tags     = @('Logo')
        Patterns = @('arch', 'debian', 'manjaro', 'kaisen', 'tux', 'xmonad', 'suckless', 'android', 'apple', 'windows', 'ubuntu', 'pinguco', 'crunchbang', 'amiga')
    },
    [pscustomobject]@{
        Category = 'Gaming'
        Tags     = @('Gaming', 'PopCulture')
        Patterns = @('doom', 'pacman', 'space-invaders', 'tiefighter', 'rally-x', 'tanks', 'guns', 'pukeskull', 'rupees', 'unowns', 'jangofett', 'darthvader')
    },
    [pscustomobject]@{
        Category = 'ASCIIArt'
        Tags     = @('ASCIIArt')
        Patterns = @('cats', 'crabs', 'crowns', 'elfman', 'faces', '^hearts[0-9]*$', 'kevin-woods', 'monster', '^mouseface', 'pinguco', '^thebat', 'thisisfine', '^welcome-', 'ghosts', 'bears', 'hedgehogs', '^tvs$', 'pukeskull')
    },
    [pscustomobject]@{
        Category = 'Physics'
        Tags     = @('Physics')
        Patterns = @('boids', 'cyclone', 'domain', '\bdla\b', '\bdna\b', 'lightning', 'nbody', 'particle', 'perlin', 'plasma', 'sandpile', '\bsdf\b', 'solar-system', 'verlet', 'waveform', 'wavelet', 'wave-interference', 'wave-pattern', 'vector-streams', 'vortex', 'orbit', 'field', 'life', 'langton', 'electrostatic')
    },
    [pscustomobject]@{
        Category = 'Nature'
        Tags     = @('Nature')
        Patterns = @('aurora', 'nebula', 'galaxy', 'forest', 'crystal', 'fern', 'dunes', 'twilight', 'starlit', 'cloud', 'horizon', 'cosmic', 'enchanted')
    },
    [pscustomobject]@{
        Category = 'Mathematical'
        Tags     = @('Mathematical')
        Patterns = @('apollonian', 'barnsley', 'binary-tree', 'clifford', 'fourier', 'fractal', 'hilbert', 'koch', 'lissajous', 'mandelbrot', 'newton', 'penrose', 'pythagorean', 'quasicrystal', 'rossler', 'sierpinski', 'circle-packing', 'lorenz', 'julia', 'lsystem', 'voronoi', 'iso-cubes')
    },
    [pscustomobject]@{
        Category = 'Artistic'
        Tags     = @('Artistic')
        Patterns = @('braid', 'chromatic', 'chrono', 'city', 'ember', 'kaleidoscope', 'mandala', 'mosaic', 'prismatic', 'midnight', 'illumina', 'inkblot', 'pixel', 'sunburst', 'fade', 'starlit', 'twilight', 'rainbow', 'matrix')
    },
    [pscustomobject]@{
        Category = 'Patterns'
        Tags     = @('Pattern')
        Patterns = @('bars?', 'block', 'blok', 'grid', 'maze', 'spiral', 'wave', 'zigzag', 'tile', 'lattice', 'hex', 'ring', 'polygon', 'prism', 'tessell', 'iso', 'quasicrystal', 'rail', 'pane', 'truchet', 'pattern', 'panes', 'rails', 'circle', 'square', 'triangles', 'gradient', 'voronoi', 'radial', '^six$')
    }
)

#region Helper Functions

function Test-ColorScriptNameValue {
    param(
        [Parameter(Mandatory, Position = 0)]
        [object]$Value,
        [switch]$AllowWildcard,
        [switch]$AllowEmpty
    )

    $stringValue = [string]$Value

    if ([string]::IsNullOrWhiteSpace($stringValue)) {
        if ($AllowEmpty) {
            return $true
        }

        $message = if ($script:Messages -and $script:Messages.ContainsKey('InvalidScriptNameEmpty')) {
            $script:Messages.InvalidScriptNameEmpty
        }
        else {
            'Color script name cannot be empty or whitespace.'
        }

        throw [System.Management.Automation.ValidationMetadataException]::new($message)
    }

    $invalidCharacters = [System.IO.Path]::GetInvalidFileNameChars()
    if ($AllowWildcard) {
        $invalidCharacters = [char[]]($invalidCharacters | Where-Object { $_ -ne '*' -and $_ -ne '?' })
    }

    if ($stringValue.IndexOfAny([char[]]$invalidCharacters) -ge 0) {
        $characterMessage = if ($script:Messages -and $script:Messages.ContainsKey('InvalidScriptNameCharacters')) {
            $script:Messages.InvalidScriptNameCharacters -f $stringValue
        }
        else {
            "Color script name '$stringValue' contains invalid characters."
        }

        throw [System.Management.Automation.ValidationMetadataException]::new($characterMessage)
    }

    return $true
}

function Test-ColorScriptPathValue {
    param(
        [Parameter(Mandatory, Position = 0)]
        [object]$Value,
        [switch]$AllowEmpty
    )

    $stringValue = [string]$Value

    if ([string]::IsNullOrWhiteSpace($stringValue)) {
        if ($AllowEmpty) {
            return $true
        }

        $emptyMessage = if ($script:Messages -and $script:Messages.ContainsKey('InvalidPathValueEmpty')) {
            $script:Messages.InvalidPathValueEmpty
        }
        else {
            'Path value cannot be empty or whitespace.'
        }

        throw [System.Management.Automation.ValidationMetadataException]::new($emptyMessage)
    }

    $invalidCharacters = [char[]][System.IO.Path]::GetInvalidPathChars()

    if ($stringValue.IndexOfAny($invalidCharacters) -ge 0) {
        $characterMessage = if ($script:Messages -and $script:Messages.ContainsKey('InvalidPathValueCharacters')) {
            $script:Messages.InvalidPathValueCharacters -f $stringValue
        }
        else {
            "Path '$stringValue' contains invalid characters."
        }

        throw [System.Management.Automation.ValidationMetadataException]::new($characterMessage)
    }

    return $true
}

function New-ColorScriptErrorRecord {
    param(
        [Parameter(Mandatory)]
        [string]$Message,

        [Parameter()]
        [string]$ErrorId = 'ColorScriptsEnhanced.RuntimeError',

        [Parameter()]
        [System.Management.Automation.ErrorCategory]$Category = [System.Management.Automation.ErrorCategory]::InvalidOperation,

        [Parameter()]
        [object]$TargetObject,

        [Parameter()]
        [System.Exception]$Exception,

        [Parameter()]
        [string]$RecommendedAction
    )

    if (-not [string]::IsNullOrWhiteSpace($Message)) {
        $effectiveMessage = $Message
    }
    elseif ($Exception) {
        $effectiveMessage = $Exception.Message
    }
    else {
        $effectiveMessage = 'An error occurred within ColorScripts-Enhanced.'
    }

    if (-not $Exception) {
        $Exception = [System.Management.Automation.RuntimeException]::new($effectiveMessage)
    }
    elseif ($effectiveMessage -and $Exception.Message -ne $effectiveMessage) {
        $Exception = [System.Management.Automation.RuntimeException]::new($effectiveMessage, $Exception)
    }

    $errorRecord = [System.Management.Automation.ErrorRecord]::new($Exception, $ErrorId, $Category, $TargetObject)

    if (-not $errorRecord.ErrorDetails) {
        $errorRecord.ErrorDetails = [System.Management.Automation.ErrorDetails]::new($effectiveMessage)
    }
    elseif ($effectiveMessage -and [string]::IsNullOrWhiteSpace($errorRecord.ErrorDetails.Message)) {
        $errorRecord.ErrorDetails.Message = $effectiveMessage
    }

    if ($RecommendedAction) {
        if (-not $errorRecord.ErrorDetails) {
            $errorRecord.ErrorDetails = [System.Management.Automation.ErrorDetails]::new($effectiveMessage)
        }
        $errorRecord.ErrorDetails.RecommendedAction = $RecommendedAction
    }

    return $errorRecord
}

function Invoke-ColorScriptError {
    param(
        [Parameter(Mandatory)]
        [string]$Message,

        [Parameter()]
        [string]$ErrorId = 'ColorScriptsEnhanced.RuntimeError',

        [Parameter()]
        [System.Management.Automation.ErrorCategory]$Category = [System.Management.Automation.ErrorCategory]::InvalidOperation,

        [Parameter()]
        [object]$TargetObject,

        [Parameter()]
        [System.Exception]$Exception,

        [Parameter()]
        [string]$RecommendedAction,

        [Parameter()]
        [System.Management.Automation.PSCmdlet]$Cmdlet
    )

    $errorRecord = New-ColorScriptErrorRecord -Message $Message -ErrorId $ErrorId -Category $Category -TargetObject $TargetObject -Exception $Exception -RecommendedAction $RecommendedAction

    if ($Cmdlet) {
        $Cmdlet.ThrowTerminatingError($errorRecord)
    }
    else {
        throw $errorRecord
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

    if ($expanded -and $expanded.StartsWith('~')) {
        $homeDirectory = & $script:GetUserProfilePathDelegate
        if (-not $homeDirectory) {
            $homeDirectory = $HOME
        }

        if ($homeDirectory) {
            if ($expanded.Length -eq 1) {
                $expanded = $homeDirectory
            }
            elseif ($expanded.Length -gt 1 -and ($expanded[1] -eq '/' -or $expanded[1] -eq '\')) {
                $relativeSegment = $expanded.Substring(2)
                $expanded = if ($relativeSegment) {
                    Join-Path -Path $homeDirectory -ChildPath $relativeSegment
                }
                else {
                    $homeDirectory
                }
            }
        }
    }

    $candidate = $expanded

    $qualifier = $null
    try {
        $qualifier = Split-Path -Path $expanded -Qualifier -ErrorAction Stop
    }
    catch {
        $qualifier = $null
    }

    if ($qualifier -and $qualifier -notlike '\\*') {
        $driveName = $qualifier.TrimEnd(':', '\')
        if (-not (Get-PSDrive -Name $driveName -ErrorAction SilentlyContinue)) {
            return $null
        }
    }

    $isRooted = $false
    try {
        $isRooted = & $script:IsPathRootedDelegate $expanded
    }
    catch {
        Write-Verbose "Unable to evaluate rooted state for cache path '$expanded': $($_.Exception.Message)"
        return $null
    }

    if (-not $isRooted) {
        $basePath = $null

        try {
            $basePath = & $script:GetCurrentProviderPathDelegate
        }
        catch {
            $basePath = $null
        }

        if (-not $basePath) {
            try {
                $basePath = & $script:GetCurrentDirectoryDelegate
            }
            catch {
                $basePath = $null
            }
        }

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

function Reset-ScriptInventoryCache {
    $script:ScriptInventory = $null
    $script:ScriptInventoryStamp = $null
    $script:ScriptInventoryInitialized = $false
    $script:ScriptInventoryRecords = $null
}

function Get-ColorScriptInventory {
    param(
        [switch]$Raw
    )

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
        # We previously had no stamp (directory missing). If it now exists, refresh once.
        $shouldRefresh = $true
    }

    if ($shouldRefresh) {
        $scriptFiles = @()
        try {
            $scriptFiles = Get-ChildItem -Path $script:ScriptsPath -Filter "*.ps1" -File -ErrorAction Stop
        }
        catch {
            $scriptFiles = @()
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

    if ($Raw) {
        return $script:ScriptInventory
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

    return $script:ScriptInventoryRecords
}

function Test-ColorScriptTextEmission {
    param(
        [bool]$ReturnText,
        [bool]$PassThru,
        [int]$PipelineLength,
        [System.Collections.IDictionary]$BoundParameters
    )

    $isRedirected = $false
    try {
        if ($script:IsOutputRedirectedDelegate) {
            $isRedirected = & $script:IsOutputRedirectedDelegate
        }
        else {
            $isRedirected = [Console]::IsOutputRedirected
        }
    }
    catch {
        $isRedirected = $false
    }

    if ($ReturnText) {
        return $true
    }

    if ($PassThru) {
        return $isRedirected
    }

    if ($PipelineLength -gt 1) {
        return $true
    }

    if ($BoundParameters -and ($BoundParameters.ContainsKey('OutVariable') -or $BoundParameters.ContainsKey('PipelineVariable'))) {
        return $true
    }

    if ($PipelineLength -gt 0) {
        return $isRedirected
    }

    return $isRedirected
}

function Get-PowerShellExecutable {
    if (-not $script:PowerShellExecutable) {
        $candidate = Get-Command -Name pwsh -ErrorAction SilentlyContinue
        if ($candidate -and $candidate.Path) {
            $script:PowerShellExecutable = $candidate.Path
        }
        else {
            try {
                $process = & $script:GetCurrentProcessDelegate
                $module = if ($process) { $process.MainModule } else { $null }
                if ($module -and $module.FileName) {
                    $script:PowerShellExecutable = $module.FileName
                }
                else {
                    throw [System.InvalidOperationException]::new('Process module unavailable.')
                }
            }
            catch {
                $script:PowerShellExecutable = [System.Environment]::GetCommandLineArgs()[0]
            }
        }
    }

    return $script:PowerShellExecutable
}

function Invoke-WithUtf8Encoding {
    param(
        [scriptblock]$ScriptBlock,
        [object[]]$Arguments
    )

    $originalEncoding = $null
    $encodingChanged = $false

    if (-not (& $script:IsOutputRedirectedDelegate)) {
        try {
            $originalEncoding = & $script:GetConsoleOutputEncodingDelegate
            if ($originalEncoding -and $originalEncoding.WebName -ne 'utf-8') {
                & $script:SetConsoleOutputEncodingDelegate ([System.Text.Encoding]::UTF8)
                $encodingChanged = $true
            }
        }
        catch [System.IO.IOException] {
            $originalEncoding = $null
            $encodingChanged = $false
            Write-Verbose 'Console handle unavailable; skipping OutputEncoding change.'
        }
    }

    try {
        if ($Arguments) {
            return & $ScriptBlock @Arguments
        }

        return & $ScriptBlock
    }
    finally {
        if ($encodingChanged -and $originalEncoding) {
            try {
                & $script:SetConsoleOutputEncodingDelegate $originalEncoding
            }
            catch [System.IO.IOException] {
                Write-Verbose 'Console handle unavailable; unable to restore OutputEncoding.'
            }
        }
    }
}


function Write-RenderedText {
    param(
        [AllowNull()]
        [string]$Text,
        [switch]$NoAnsiOutput
    )

    $outputText = if ($null -ne $Text) { [string]$Text } else { '' }

    if ($NoAnsiOutput) {
        $outputText = Remove-ColorScriptAnsiSequence -Text $outputText
    }

    try {
        & $script:ConsoleWriteDelegate $outputText

        $requiresNewLine = $true
        if ($outputText) {
            $requiresNewLine = -not $outputText.EndsWith("`n")
        }

        if ($requiresNewLine) {
            & $script:ConsoleWriteDelegate ([Environment]::NewLine)
        }
    }
    catch [System.IO.IOException] {
        Write-Verbose 'Console handle unavailable during cached render; writing rendered text to the pipeline.'
        Write-Output $outputText
    }
}


function Initialize-CacheDirectory {
    if ($script:CacheInitialized -and $script:CacheDir) {
        return
    }

    Initialize-Configuration

    $overrideCacheRoot = $env:COLOR_SCRIPTS_ENHANCED_CACHE_PATH
    $resolvedOverride = $null

    if ($overrideCacheRoot) {
        $resolvedOverride = Resolve-CachePath -Path $overrideCacheRoot
        if (-not $resolvedOverride) {
            Write-Verbose "Ignoring COLOR_SCRIPTS_ENHANCED_CACHE_PATH override '$overrideCacheRoot' because the path could not be resolved."
        }
    }

    $candidatePaths = @()

    if ($resolvedOverride) {
        $candidatePaths += $resolvedOverride
    }

    $configData = $script:ConfigurationData
    if ($configData -and $configData.Cache -and $configData.Cache.Path) {
        $configuredPath = Resolve-CachePath -Path $configData.Cache.Path
        if ($configuredPath) {
            $candidatePaths += $configuredPath
        }
        else {
            Write-Warning ($script:Messages.ConfiguredCachePathInvalid -f $configData.Cache.Path)
        }
    }

    if ($script:IsWindows -or $PSVersionTable.PSVersion.Major -le 5) {
        if ($env:APPDATA) {
            $windowsBase = Join-Path -Path $env:APPDATA -ChildPath 'ColorScripts-Enhanced'
            $candidatePaths += (Join-Path -Path $windowsBase -ChildPath 'cache')
        }
    }
    elseif ($script:IsMacOS) {
        $macBase = Join-Path -Path $HOME -ChildPath 'Library'
        $macBase = Join-Path -Path $macBase -ChildPath 'Application Support'
        $macBase = Join-Path -Path $macBase -ChildPath 'ColorScripts-Enhanced'
        $candidatePaths += (Join-Path -Path $macBase -ChildPath 'cache')
    }
    else {
        $xdgCache = if ($env:XDG_CACHE_HOME) { $env:XDG_CACHE_HOME } else { Join-Path -Path $HOME -ChildPath '.cache' }
        if ($xdgCache) {
            $candidatePaths += (Join-Path -Path $xdgCache -ChildPath 'ColorScripts-Enhanced')
        }
    }

    $candidatePaths = $candidatePaths | Where-Object { -not [string]::IsNullOrWhiteSpace($_) }

    foreach ($candidate in $candidatePaths) {
        $target = Resolve-CachePath -Path $candidate
        if (-not $target) {
            Write-Verbose "Skipping cache candidate '$candidate' because it could not be resolved."
            continue
        }

        try {
            if (-not (Test-Path -LiteralPath $target)) {
                New-Item -ItemType Directory -Path $target -Force -ErrorAction Stop | Out-Null
            }

            try {
                $resolvedPhysicalPath = (Resolve-Path -LiteralPath $target -ErrorAction Stop).ProviderPath
            }
            catch {
                $resolvedPhysicalPath = $target
            }

            $script:CacheDir = $resolvedPhysicalPath
            $script:CacheInitialized = $true
            return
        }
        catch {
            Write-Warning ($script:Messages.UnableToPrepareCacheDirectory -f $target, $_.Exception.Message)
        }
    }

    $fallback = Join-Path -Path ([System.IO.Path]::GetTempPath()) -ChildPath 'ColorScripts-Enhanced'
    if (-not (Test-Path -LiteralPath $fallback)) {
        New-Item -ItemType Directory -Path $fallback -Force -ErrorAction Stop | Out-Null
    }

    try {
        $resolvedFallback = (Resolve-Path -LiteralPath $fallback -ErrorAction Stop).ProviderPath
    }
    catch {
        $resolvedFallback = $fallback
    }

    $script:CacheDir = $resolvedFallback
    $script:CacheInitialized = $true
}

# Cache directory is initialized lazily by public functions when needed

function New-NameMatcherSet {
    param(
        [string[]]$Patterns
    )

    $matchers = New-Object 'System.Collections.Generic.List[object]'

    if (-not $Patterns) {
        return $matchers.ToArray()
    }

    foreach ($pattern in $Patterns) {
        if ([string]::IsNullOrWhiteSpace($pattern)) {
            continue
        }

        $hasWildcard = [System.Management.Automation.WildcardPattern]::ContainsWildcardCharacters($pattern)
        if ($hasWildcard) {
            $wildcard = New-Object System.Management.Automation.WildcardPattern ($pattern, [System.Management.Automation.WildcardOptions]::IgnoreCase)
            $null = $matchers.Add(
                [pscustomobject]@{
                    Pattern    = $pattern
                    Matcher    = $wildcard
                    IsWildcard = $true
                    Matched    = $false
                    Matches    = New-Object 'System.Collections.Generic.List[string]'
                }
            )
        }
        else {
            $null = $matchers.Add(
                [pscustomobject]@{
                    Pattern    = $pattern
                    Matcher    = $pattern
                    IsWildcard = $false
                    Matched    = $false
                    Matches    = New-Object 'System.Collections.Generic.List[string]'
                }
            )
        }
    }

    return $matchers.ToArray()
}

function Select-RecordsByName {
    param(
        [Parameter(Mandatory)]
        [System.Collections.IEnumerable]$Records,

        [string[]]$Name
    )

    $recordList = New-Object 'System.Collections.Generic.List[object]'
    foreach ($record in $Records) {
        $null = $recordList.Add($record)
    }

    $selectedNames = New-Object 'System.Collections.Generic.HashSet[string]' ([System.StringComparer]::OrdinalIgnoreCase)

    if (-not $Name -or $Name.Count -eq 0) {
        return [pscustomobject]@{
            Records         = $recordList.ToArray()
            MissingPatterns = @()
        }
    }

    $matchers = New-NameMatcherSet -Patterns $Name
    if (-not $matchers -or $matchers.Count -eq 0) {
        return [pscustomobject]@{
            Records         = @()
            MissingPatterns = @()
        }
    }

    $selected = New-Object 'System.Collections.Generic.List[object]'

    foreach ($record in $recordList) {
        if (-not ($record.PSObject.Properties.Name -contains 'Name')) {
            continue
        }

        $candidateName = [string]$record.Name
        $recordMatched = $false

        foreach ($matcher in $matchers) {
            $isMatch = if ($matcher.IsWildcard) {
                $matcher.Matcher.IsMatch($candidateName)
            }
            else {
                [System.String]::Equals($candidateName, [string]$matcher.Matcher, [System.StringComparison]::OrdinalIgnoreCase)
            }

            if ($isMatch) {
                $matcher.Matched = $true
                if (-not $matcher.Matches.Contains($candidateName)) {
                    $null = $matcher.Matches.Add($candidateName)
                }
                $recordMatched = $true
            }
        }

        if ($recordMatched) {
            if ($selectedNames.Add($candidateName)) {
                $null = $selected.Add($record)
            }
        }
    }

    $missing = $matchers | Where-Object { -not $_.Matched } | ForEach-Object { $_.Pattern }

    $matchMap = $matchers | ForEach-Object {
        [pscustomobject]@{
            Pattern    = $_.Pattern
            IsWildcard = $_.IsWildcard
            Matched    = $_.Matched
            Matches    = $_.Matches.ToArray()
        }
    }

    return [pscustomobject]@{
        Records         = $selected.ToArray()
        MissingPatterns = [string[]]$missing
        MatchMap        = $matchMap
    }
}

function Get-ColorScriptMetadataTable {
    $currentTimestamp = $null
    if (Test-Path $script:MetadataPath) {
        try {
            $currentTimestamp = (Get-Item -LiteralPath $script:MetadataPath).LastWriteTimeUtc
        }
        catch {
            Write-Verbose "Unable to determine metadata timestamp: $($_.Exception.Message)"
        }
    }

    # Return in-memory cache if available and current
    if ($script:MetadataCache -and $script:MetadataLastWriteTime -and $currentTimestamp -eq $script:MetadataLastWriteTime) {
        return $script:MetadataCache
    }

    # Try to load from binary cache file for faster subsequent loads
    $binaryCachePath = $null
    if ($script:CacheInitialized -and $script:CacheDir) {
        $binaryCachePath = Join-Path -Path $script:CacheDir -ChildPath 'metadata.cache.json'

        if ($binaryCachePath -and (Test-Path -LiteralPath $binaryCachePath)) {
            try {
                $cacheFileInfo = Get-Item -LiteralPath $binaryCachePath -ErrorAction Stop
                if ($cacheFileInfo.LastWriteTimeUtc -ge $currentTimestamp) {
                    # JSON cache is current, load it
                    $jsonData = Get-Content -LiteralPath $binaryCachePath -Raw -ErrorAction Stop
                    $cachedHash = ConvertFrom-JsonToHashtable -InputObject $jsonData

                    # Convert back to proper dictionary
                    $loadedStore = New-Object 'System.Collections.Generic.Dictionary[string, object]' ([System.StringComparer]::OrdinalIgnoreCase)
                    foreach ($key in $cachedHash.Keys) {
                        $loadedStore[$key] = $cachedHash[$key]
                    }

                    $script:MetadataCache = $loadedStore
                    $script:MetadataLastWriteTime = $currentTimestamp
                    Write-Verbose "Loaded metadata from JSON cache (fast path)"
                    return $script:MetadataCache
                }
            }
            catch {
                Write-Verbose "JSON metadata cache load failed, will rebuild: $($_.Exception.Message)"
            }
        }
    }

    $store = New-Object 'System.Collections.Generic.Dictionary[string, object]' ([System.StringComparer]::OrdinalIgnoreCase)

    $mergeUnique = {
        param(
            [string[]]$existing,
            [string[]]$additional
        )

        $set = New-Object 'System.Collections.Generic.HashSet[string]' ([System.StringComparer]::OrdinalIgnoreCase)
        $list = New-Object 'System.Collections.Generic.List[string]'

        if ($existing) {
            foreach ($value in $existing) {
                if ([string]::IsNullOrWhiteSpace($value)) { continue }
                if ($set.Add($value)) { $null = $list.Add($value) }
            }
        }

        if ($additional) {
            foreach ($value in $additional) {
                if ([string]::IsNullOrWhiteSpace($value)) { continue }
                if ($set.Add($value)) { $null = $list.Add($value) }
            }
        }

        return $list.ToArray()
    }

    $data = $null

    if (Test-Path $script:MetadataPath) {
        $data = Import-PowerShellDataFile -Path $script:MetadataPath

        if ($data -is [hashtable]) {
            $internal = New-Object 'System.Collections.Generic.Dictionary[string, hashtable]' ([System.StringComparer]::OrdinalIgnoreCase)

            $ensureEntry = {
                param($map, $name)

                if (-not $map.ContainsKey($name)) {
                    $map[$name] = @{
                        Category    = $null
                        Categories  = New-Object 'System.Collections.Generic.List[string]'
                        Tags        = New-Object 'System.Collections.Generic.HashSet[string]' ([System.StringComparer]::OrdinalIgnoreCase)
                        Description = $null
                    }
                }

                return $map[$name]
            }

            if ($data.Categories -is [hashtable]) {
                foreach ($categoryName in $data.Categories.Keys) {
                    $scriptsForCategory = $data.Categories[$categoryName]
                    foreach ($scriptName in $scriptsForCategory) {
                        $entry = & $ensureEntry $internal $scriptName
                        if (-not $entry.Categories.Contains($categoryName)) {
                            $null = $entry.Categories.Add($categoryName)
                        }
                        if (-not $entry.Tags.Contains("Category:$categoryName")) {
                            $null = $entry.Tags.Add("Category:$categoryName")
                        }
                        if (-not $entry.Category) {
                            $entry.Category = $categoryName
                        }
                    }
                }
            }

            if ($data.Difficulty -is [hashtable]) {
                foreach ($difficultyLevel in $data.Difficulty.Keys) {
                    foreach ($scriptName in $data.Difficulty[$difficultyLevel]) {
                        $entry = & $ensureEntry $internal $scriptName
                        $tag = "Difficulty:$difficultyLevel"
                        if (-not $entry.Tags.Contains($tag)) {
                            $null = $entry.Tags.Add($tag)
                        }
                    }
                }
            }

            if ($data.Complexity -is [hashtable]) {
                foreach ($complexityLevel in $data.Complexity.Keys) {
                    foreach ($scriptName in $data.Complexity[$complexityLevel]) {
                        $entry = & $ensureEntry $internal $scriptName
                        $tag = "Complexity:$complexityLevel"
                        if (-not $entry.Tags.Contains($tag)) {
                            $null = $entry.Tags.Add($tag)
                        }
                    }
                }
            }

            if ($data.Recommended -is [System.Collections.IEnumerable]) {
                foreach ($scriptName in $data.Recommended) {
                    $entry = & $ensureEntry $internal $scriptName
                    if (-not $entry.Tags.Contains('Recommended')) {
                        $null = $entry.Tags.Add('Recommended')
                    }
                }
            }

            if ($data.Tags -is [hashtable]) {
                foreach ($taggedScript in $data.Tags.Keys) {
                    $entry = & $ensureEntry $internal $taggedScript
                    $tagsForScript = $data.Tags[$taggedScript]

                    if ($tagsForScript -is [System.Collections.IEnumerable] -and $tagsForScript -isnot [string]) {
                        foreach ($tagValue in $tagsForScript) {
                            $tagText = [string]$tagValue
                            if (-not [string]::IsNullOrWhiteSpace($tagText) -and -not $entry.Tags.Contains($tagText)) {
                                $null = $entry.Tags.Add($tagText)
                            }
                        }
                    }
                    elseif ($tagsForScript) {
                        $tagText = [string]$tagsForScript
                        if (-not [string]::IsNullOrWhiteSpace($tagText) -and -not $entry.Tags.Contains($tagText)) {
                            $null = $entry.Tags.Add($tagText)
                        }
                    }
                }
            }

            if ($data.Descriptions -is [hashtable]) {
                foreach ($describedScript in $data.Descriptions.Keys) {
                    $entry = & $ensureEntry $internal $describedScript
                    $descriptionText = $data.Descriptions[$describedScript]
                    if ($null -ne $descriptionText -and -not [string]::IsNullOrWhiteSpace([string]$descriptionText)) {
                        $entry.Description = [string]$descriptionText
                    }
                }
            }

            foreach ($key in $internal.Keys) {
                $value = $internal[$key]
                $categoryValue = if ($value.Category) { $value.Category } else { 'Uncategorized' }

                $categoriesValue = @()
                if ($value.Categories -is [System.Collections.IEnumerable] -and $value.Categories -isnot [string]) {
                    $categoriesValue = @($value.Categories | ForEach-Object { [string]$_ })
                }
                elseif ($value.Categories) {
                    $categoriesValue = @([string]$value.Categories)
                }

                $tagsValue = @()
                if ($value.Tags -is [System.Collections.IEnumerable] -and $value.Tags -isnot [string]) {
                    $tagsValue = @($value.Tags | ForEach-Object { [string]$_ })
                }
                elseif ($value.Tags) {
                    $tagsValue = @([string]$value.Tags)
                }

                $store[$key] = [pscustomobject]@{
                    Category    = $categoryValue
                    Categories  = $categoriesValue
                    Tags        = $tagsValue
                    Description = $value.Description
                }
            }
        }
    }

    $autoRules = @()

    if ($data -is [hashtable] -and $data.ContainsKey('AutoCategories') -and $data.AutoCategories -is [System.Collections.IEnumerable]) {
        foreach ($rule in $data.AutoCategories) {
            $categoryName = $rule.Category
            if ([string]::IsNullOrWhiteSpace($categoryName)) {
                continue
            }

            $patterns = @()
            if ($rule.Patterns -is [System.Collections.IEnumerable]) {
                foreach ($pattern in $rule.Patterns) {
                    $patternValue = [string]$pattern
                    if (-not [string]::IsNullOrWhiteSpace($patternValue)) {
                        $patterns += $patternValue
                    }
                }
            }
            elseif ($rule.Patterns) {
                $patternValue = [string]$rule.Patterns
                if (-not [string]::IsNullOrWhiteSpace($patternValue)) {
                    $patterns += $patternValue
                }
            }

            if ($patterns.Count -eq 0) {
                continue
            }

            $tags = @()
            if ($rule.Tags -is [System.Collections.IEnumerable]) {
                foreach ($tag in $rule.Tags) {
                    $tagValue = [string]$tag
                    if (-not [string]::IsNullOrWhiteSpace($tagValue)) {
                        $tags += $tagValue
                    }
                }
            }
            elseif ($rule.Tags) {
                $tagValue = [string]$rule.Tags
                if (-not [string]::IsNullOrWhiteSpace($tagValue)) {
                    $tags += $tagValue
                }
            }

            $autoRules += [pscustomobject]@{
                Category = [string]$categoryName
                Patterns = $patterns
                Tags     = $tags
            }
        }
    }

    if ($autoRules.Count -eq 0) {
        $autoRules = $script:DefaultAutoCategoryRules
    }

    $resolveAutoCategory = {
        param([string]$Name)

        $matchedCategories = New-Object 'System.Collections.Generic.List[string]'
        $matchedTags = New-Object 'System.Collections.Generic.List[string]'

        foreach ($rule in $autoRules) {
            $patterns = @()
            if ($rule.Patterns -is [System.Collections.IEnumerable]) {
                $patterns = $rule.Patterns
            }
            elseif ($rule.Patterns) {
                $patterns = @($rule.Patterns)
            }

            foreach ($pattern in $patterns) {
                $patternValue = [string]$pattern
                if ([string]::IsNullOrWhiteSpace($patternValue)) { continue }
                if ([System.Text.RegularExpressions.Regex]::IsMatch($Name, $patternValue, [System.Text.RegularExpressions.RegexOptions]::IgnoreCase)) {
                    if (-not $matchedCategories.Contains($rule.Category)) {
                        $null = $matchedCategories.Add([string]$rule.Category)
                    }

                    if ($rule.Tags -is [System.Collections.IEnumerable]) {
                        foreach ($tag in $rule.Tags) {
                            $tagValue = [string]$tag
                            if (-not [string]::IsNullOrWhiteSpace($tagValue) -and -not $matchedTags.Contains($tagValue)) {
                                $null = $matchedTags.Add($tagValue)
                            }
                        }
                    }
                    elseif ($rule.Tags) {
                        $tagValue = [string]$rule.Tags
                        if (-not [string]::IsNullOrWhiteSpace($tagValue) -and -not $matchedTags.Contains($tagValue)) {
                            $null = $matchedTags.Add($tagValue)
                        }
                    }

                    break
                }
            }
        }

        if ($matchedCategories.Count -eq 0) {
            $null = $matchedCategories.Add('Abstract')
        }

        [pscustomobject]@{
            Categories = [string[]]$matchedCategories.ToArray()
            Tags       = [string[]]$matchedTags.ToArray()
        }
    }

    $scripts = Get-ColorScriptInventory -Raw

    foreach ($scriptFile in $scripts) {
        $name = $scriptFile.BaseName
        $entryExists = $store.ContainsKey($name)
        $existingEntry = if ($entryExists) {
            $store[$name]
        }
        else {
            [pscustomobject]@{
                Category    = 'Uncategorized'
                Categories  = @()
                Tags        = @()
                Description = $null
            }
        }

        $needsAuto = -not $entryExists -or [string]::IsNullOrWhiteSpace($existingEntry.Category) -or $existingEntry.Category -eq 'Uncategorized'

        if ($needsAuto) {
            $autoInfo = & $resolveAutoCategory $name
            $autoCategories = if ($autoInfo.Categories) { [string[]]$autoInfo.Categories } else { @('Abstract') }
            $autoTags = if ($autoInfo.Tags) { [string[]]$autoInfo.Tags } else { @() }

            $baseCategories = @()
            if ($existingEntry.Category -and $existingEntry.Category -ne 'Uncategorized') {
                $baseCategories += [string]$existingEntry.Category
            }
            if ($existingEntry.Categories) {
                foreach ($cat in [string[]]$existingEntry.Categories) {
                    if (-not [string]::IsNullOrWhiteSpace($cat) -and $cat -ne 'Uncategorized') {
                        $baseCategories += $cat
                    }
                }
            }

            $categories = [string[]](& $mergeUnique $baseCategories $autoCategories)
            if (-not $categories -or $categories.Length -eq 0) {
                $categories = @('Abstract')
            }

            $newCategory = if ($existingEntry.Category -and $existingEntry.Category -ne 'Uncategorized') { [string]$existingEntry.Category } else { $categories[0] }

            $existingTags = @()
            if ($existingEntry.Tags) {
                $existingTags = [string[]]$existingEntry.Tags
            }

            $autoTagList = @()
            if ($autoTags) { $autoTagList += $autoTags }
            $autoTagList += ($categories | ForEach-Object { "Category:$($_)" })
            $autoTagList += 'AutoCategorized'

            $tags = [string[]](& $mergeUnique $existingTags $autoTagList)

            $store[$name] = [pscustomobject]@{
                Category    = $newCategory
                Categories  = $categories
                Tags        = $tags
                Description = $existingEntry.Description
            }
        }
    }

    foreach ($key in @($store.Keys)) {
        $entry = $store[$key]

        $baseCategories = @()
        if ($entry.Category -and $entry.Category -ne 'Uncategorized') {
            $baseCategories += [string]$entry.Category
        }
        if ($entry.Categories) {
            foreach ($cat in [string[]]$entry.Categories) {
                if (-not [string]::IsNullOrWhiteSpace($cat)) {
                    $baseCategories += $cat
                }
            }
        }

        if (-not $baseCategories -or $baseCategories.Count -eq 0) {
            $baseCategories = @('Abstract')
        }

        $categories = [string[]](& $mergeUnique @() $baseCategories)
        if (-not $categories -or $categories.Length -eq 0) {
            $categories = @('Abstract')
        }

        $existingTags = @()
        if ($entry.Tags) {
            $existingTags = [string[]]$entry.Tags
        }

        $categoryTags = $categories | ForEach-Object { "Category:$($_)" }
        $tags = [string[]](& $mergeUnique $existingTags $categoryTags)

        $store[$key] = [pscustomobject]@{
            Category    = $categories[0]
            Categories  = $categories
            Tags        = $tags
            Description = $entry.Description
        }
    }

    $script:MetadataCache = $store
    $script:MetadataLastWriteTime = $currentTimestamp

    # Save JSON cache for faster subsequent loads
    if ($binaryCachePath) {
        try {
            $jsonData = $store | ConvertTo-Json -Depth 10 -Compress
            Set-Content -Path $binaryCachePath -Value $jsonData -Encoding UTF8 -ErrorAction Stop
            Write-Verbose "Saved metadata to JSON cache for faster future loads"
        }
        catch {
            Write-Verbose "Failed to save JSON metadata cache: $($_.Exception.Message)"
        }
    }

    return $script:MetadataCache
}

function Get-ColorScriptEntry {
    param(
        [SupportsWildcards()]
        [ValidateScript({ Test-ColorScriptNameValue $_ -AllowWildcard })]
        [string[]]$Name,
        [string[]]$Category,
        [string[]]$Tag
    )

    $metadata = Get-ColorScriptMetadataTable
    $scripts = Get-ColorScriptInventory -Raw

    $records = foreach ($script in $scripts) {
        $entry = if ($metadata.ContainsKey($script.BaseName)) { $metadata[$script.BaseName] } else { $null }

        if (-not $entry) {
            $entry = [pscustomobject]@{
                Category    = 'Abstract'
                Categories  = @('Abstract')
                Tags        = @('Category:Abstract', 'AutoCategorized')
                Description = $null
            }
        }

        $categoryValue = if ($entry.PSObject.Properties.Name -contains 'Category' -and $entry.Category) { [string]$entry.Category } else { 'Abstract' }
        $categoriesValue = if ($entry.PSObject.Properties.Name -contains 'Categories') { [string[]]$entry.Categories } else { @() }
        if (-not $categoriesValue -or $categoriesValue.Count -eq 0) {
            $categoriesValue = @($categoryValue)
        }

        $tagsValue = if ($entry.PSObject.Properties.Name -contains 'Tags') { [string[]]$entry.Tags } else { @() }
        if (-not $tagsValue -or $tagsValue.Count -eq 0) {
            $tagsValue = @("Category:$categoryValue")
        }
        $descriptionValue = if ($entry.PSObject.Properties.Name -contains 'Description') { [string]$entry.Description } else { $null }

        [pscustomobject]@{
            Name        = $script.BaseName
            Path        = $script.FullName
            Category    = $categoryValue
            Categories  = $categoriesValue
            Tags        = $tagsValue
            Description = $descriptionValue
            Metadata    = $entry
        }
    }

    if ($Name) {
        $selection = Select-RecordsByName -Records $records -Name $Name
        $records = $selection.Records
    }

    if ($Category) {
        $categorySet = $Category | ForEach-Object { $_.ToLowerInvariant() }
        $records = $records | Where-Object {
            $recordCategories = @($_.Category) + $_.Categories
            $recordCategories = $recordCategories | Where-Object { $_ } | ForEach-Object { $_.ToLowerInvariant() }
            $match = $false
            foreach ($categoryValue in $recordCategories) {
                if ($categorySet -contains $categoryValue) {
                    $match = $true
                    break
                }
            }
            $match
        }
    }

    if ($Tag) {
        $tagSet = $Tag | ForEach-Object { $_.ToLowerInvariant() }
        $records = $records | Where-Object {
            $recordTags = $_.Tags | ForEach-Object { $_.ToLowerInvariant() }
            $match = $false
            foreach ($tagValue in $recordTags) {
                if ($tagSet -contains $tagValue) {
                    $match = $true
                    break
                }
            }
            $match
        }
    }

    return [pscustomobject[]]$records
}

function Get-CachedOutput {
    <#
    .SYNOPSIS
        Retrieves cached output for a colorscript if available and valid.

    .DESCRIPTION
        Returns a structured object that indicates whether a cache entry is available for the supplied
        script path together with the cached text content when the cache is current. No console output is emitted.

    .OUTPUTS
        PSCustomObject with the following properties:
            Available      - Indicates whether the cache entry was used.
            CacheFile      - Full path to the cache file.
            Content        - Cached ANSI text when Available is $true, otherwise an empty string.
            LastWriteTime  - Last write time (UTC) of the cache file when Available is $true.
    #>
    [CmdletBinding()]
    [OutputType([pscustomobject])]
    param(
        [Parameter(Mandatory)]
        [string]$ScriptPath
    )

    # Fast path: Use .NET File methods to avoid PowerShell cmdlet overhead
    try {
        if (-not (& $script:FileExistsDelegate $ScriptPath)) {
            return [pscustomobject]@{
                Available     = $false
                CacheFile     = $null
                Content       = ''
                LastWriteTime = $null
            }
        }
    }
    catch {
        return [pscustomobject]@{
            Available     = $false
            CacheFile     = $null
            Content       = ''
            LastWriteTime = $null
        }
    }

    $scriptName = [System.IO.Path]::GetFileNameWithoutExtension($ScriptPath)
    $cacheFile = Join-Path $script:CacheDir "$scriptName.cache"

    try {
        if (-not (& $script:FileExistsDelegate $cacheFile)) {
            return [pscustomobject]@{
                Available     = $false
                CacheFile     = $cacheFile
                Content       = ''
                LastWriteTime = $null
            }
        }

        # Use direct .NET file time comparison for better performance
        $scriptLastWrite = & $script:FileGetLastWriteTimeUtcDelegate $ScriptPath
        $cacheLastWrite = & $script:FileGetLastWriteTimeUtcDelegate $cacheFile

        if ($scriptLastWrite -gt $cacheLastWrite) {
            return [pscustomobject]@{
                Available     = $false
                CacheFile     = $cacheFile
                Content       = ''
                LastWriteTime = $cacheLastWrite
            }
        }

        $content = & $script:FileReadAllTextDelegate $cacheFile $script:Utf8NoBomEncoding

        return [pscustomobject]@{
            Available     = $true
            CacheFile     = $cacheFile
            Content       = $content
            LastWriteTime = $cacheLastWrite
        }
    }
    catch {
        Write-Verbose "Cache read error for $ScriptPath : $($_.Exception.Message)"
        return [pscustomobject]@{
            Available     = $false
            CacheFile     = $cacheFile
            Content       = ''
            LastWriteTime = $null
        }
    }
}

function Invoke-ColorScriptProcess {
    <#
    .SYNOPSIS
        Executes a colorscript in an isolated process and captures its output.
    #>
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)]
        [string]$ScriptPath
    )

    $scriptName = [System.IO.Path]::GetFileNameWithoutExtension($ScriptPath)

    $result = [pscustomobject]@{
        ScriptName = $scriptName
        StdOut     = ''
        StdErr     = ''
        ExitCode   = $null
        Success    = $false
    }

    if (-not (Test-Path -LiteralPath $ScriptPath)) {
        $result.StdErr = $script:Messages.ScriptPathNotFound
        return $result
    }

    $executable = Get-PowerShellExecutable
    $scriptDirectory = [System.IO.Path]::GetDirectoryName($ScriptPath)
    $process = $null

    try {
        $startInfo = New-Object System.Diagnostics.ProcessStartInfo
        $startInfo.FileName = $executable

        $escapedScriptPath = $ScriptPath.Replace("'", "''")
        $escapedScriptDir = if ($scriptDirectory) { $scriptDirectory.Replace("'", "''") } else { $null }
        $commandBuilder = New-Object System.Text.StringBuilder
        $null = $commandBuilder.Append("[Console]::OutputEncoding = [System.Text.Encoding]::UTF8; ")
        if ($escapedScriptDir) {
            $null = $commandBuilder.Append("Set-Location -LiteralPath '$escapedScriptDir'; ")
        }
        $null = $commandBuilder.Append("& ([ScriptBlock]::Create([System.IO.File]::ReadAllText('$escapedScriptPath', [System.Text.Encoding]::UTF8)))")

        $encodedCommand = $commandBuilder.ToString()
        $startInfo.Arguments = "-NoProfile -NonInteractive -Command `"$encodedCommand`""
        $startInfo.UseShellExecute = $false
        $startInfo.RedirectStandardOutput = $true
        $startInfo.RedirectStandardError = $true
        $startInfo.StandardOutputEncoding = [System.Text.Encoding]::UTF8
        $startInfo.StandardErrorEncoding = [System.Text.Encoding]::UTF8

        if ($scriptDirectory) {
            $startInfo.WorkingDirectory = $scriptDirectory
        }

        $process = New-Object System.Diagnostics.Process
        $process.StartInfo = $startInfo
        $null = $process.Start()

        $output = $process.StandardOutput.ReadToEnd()
        $errorOutput = $process.StandardError.ReadToEnd()
        $process.WaitForExit()

        $result.ExitCode = $process.ExitCode
        $result.StdOut = $output
        $result.StdErr = $errorOutput
        $result.Success = ($process.ExitCode -eq 0)
    }
    catch {
        $result.StdErr = $_.Exception.Message
    }
    finally {
        if ($process) {
            $process.Dispose()
        }
    }

    return $result
}

function Build-ScriptCache {
    <#
    .SYNOPSIS
        Builds cache for a specific colorscript.

        The full path to the colorscript file.
    #>
    [CmdletBinding()]
    [OutputType([pscustomobject])]
    param(
        [Parameter(Mandatory)]
        [string]$ScriptPath
    )

    $scriptName = [System.IO.Path]::GetFileNameWithoutExtension($ScriptPath)
    $cacheFile = Join-Path $script:CacheDir "$scriptName.cache"

    $result = [pscustomobject]@{
        ScriptName = $scriptName
        CacheFile  = $cacheFile
        Success    = $false
        ExitCode   = $null
        StdOut     = ''
        StdErr     = ''
    }

    # Use .NET File.Exists for faster check
    if (-not [System.IO.File]::Exists($ScriptPath)) {
        $result.StdErr = $script:Messages.ScriptPathNotFound
        return $result
    }

    $execution = Invoke-ColorScriptProcess -ScriptPath $ScriptPath
    $result.ExitCode = $execution.ExitCode
    $result.StdOut = $execution.StdOut
    $result.StdErr = $execution.StdErr

    if ($execution.Success) {
        try {
            Invoke-FileWriteAllText -Path $cacheFile -Content $execution.StdOut -Encoding $script:Utf8NoBomEncoding

            # Use .NET methods directly for better performance
            try {
                $scriptLastWrite = Get-FileLastWriteTimeUtc -Path $ScriptPath
                Set-FileLastWriteTimeUtc -Path $cacheFile -Timestamp $scriptLastWrite
            }
            catch {
                # Fallback if UTC methods fail
                $scriptLastWrite = Get-FileLastWriteTime -Path $ScriptPath
                Set-FileLastWriteTime -Path $cacheFile -Timestamp $scriptLastWrite
            }
            $result.Success = $true
        }
        catch {
            $result.StdErr = $_.Exception.Message
        }
    }
    elseif (-not $result.StdErr) {
        $result.StdErr = ($script:Messages.ScriptExitedWithCode -f $execution.ExitCode)
    }

    return $result
}

#endregion

#region Public Functions

function Show-ColorScript {
    <#
    .SYNOPSIS
        Displays a colorscript with automatic caching.

    .LINK
        https://nick2bad4u.github.io/PS-Color-Scripts-Enhanced/docs/help-redirect.html?cmdlet=Show-ColorScript

    .DESCRIPTION
        Shows a beautiful ANSI colorscript in your terminal. If no name is specified,
        displays a random script. Uses intelligent caching for 6-19x faster performance.
        Name values accept wildcards; when multiple scripts match the provided pattern, the first
        alphabetical match is displayed and can be inspected with -PassThru.

        Use -All to cycle through all colorscripts in alphabetical order.
        Combine with -WaitForInput to pause between each script (press spacebar to continue).

    .PARAMETER Name
        The name of the colorscript to display (without .ps1 extension). Supports wildcards for partial matches.

    .PARAMETER List
        Lists all available colorscripts.

    .PARAMETER Random
        Display a random colorscript (default behavior).

    .PARAMETER All
        Cycle through all available colorscripts in alphabetical order.

    .PARAMETER WaitForInput
        When used with -All, pause after each colorscript and wait for spacebar to continue.
        Press 'q' to quit early.

    .PARAMETER NoCache
        Bypass cache and execute script directly.
    .PARAMETER Category
        Filter the available script set by one or more categories before selection occurs.
    .PARAMETER Tag
        Filter the available script set by tag metadata (case-insensitive).
    .PARAMETER PassThru
        Return the selected script metadata in addition to rendering output.
    .PARAMETER ReturnText
        Emit the rendered colorscript as pipeline output instead of writing directly to the console.
    .PARAMETER Quiet
        Suppress informational messaging emitted to the information stream while still rendering script output.
    .PARAMETER NoAnsiOutput
        Disable ANSI color codes in informational messages and rendered script text for plain-text environments.

    .EXAMPLE
        Show-ColorScript
        Displays a random colorscript.

    .EXAMPLE
        Show-ColorScript -Name "mandelbrot-zoom"
        Displays the mandelbrot-zoom colorscript.

    .EXAMPLE
        Show-ColorScript -Name "aurora-*"
        Displays the first colorscript (alphabetically) whose name matches the wildcard.

    .EXAMPLE
        Show-ColorScript -List
        Lists all available colorscripts.

    .EXAMPLE
        scs hearts
        Uses the alias to display the hearts colorscript.

    .EXAMPLE
        Show-ColorScript -All
        Displays all colorscripts in alphabetical order continuously.

    .EXAMPLE
        Show-ColorScript -All -WaitForInput
        Displays all colorscripts one at a time, waiting for spacebar press between each.

    .EXAMPLE
        Show-ColorScript -All -Category Nature -WaitForInput
        Cycles through all nature-themed colorscripts with manual progression.
    #>
    [OutputType([pscustomobject], ParameterSetName = 'List')]
    [OutputType([pscustomobject], ParameterSetName = 'Named')]
    [OutputType([pscustomobject], ParameterSetName = 'Random')]
    [OutputType([string], ParameterSetName = 'Named')]
    [OutputType([string], ParameterSetName = 'Random')]
    [CmdletBinding(DefaultParameterSetName = 'Random', HelpUri = 'https://nick2bad4u.github.io/PS-Color-Scripts-Enhanced/docs/help-redirect.html?cmdlet=Show-ColorScript')]
    [Alias('scs')]
    param(
        [Parameter(ParameterSetName = 'Help')]
        [Alias('help')]
        [switch]$h,

        [Parameter(ParameterSetName = 'Named', Position = 0)]
        [SupportsWildcards()]
        [ValidateScript({ Test-ColorScriptNameValue $_ -AllowWildcard })]
        [string]$Name,

        [Parameter(ParameterSetName = 'List')]
        [switch]$List,

        [Parameter(ParameterSetName = 'Random')]
        [switch]$Random,

        [Parameter(ParameterSetName = 'All')]
        [switch]$All,

        [Parameter(ParameterSetName = 'All')]
        [switch]$WaitForInput,

        [Parameter()]
        [switch]$NoCache,

        [Parameter()]
        [string[]]$Category,

        [Parameter()]
        [string[]]$Tag,

        [Parameter(ParameterSetName = 'Named')]
        [Parameter(ParameterSetName = 'Random')]
        [switch]$PassThru,

        [Parameter()]
        [Alias('AsString')]
        [switch]$ReturnText,

        [Parameter()]
        [switch]$Quiet,

        [Parameter()]
        [Alias('NoColor')]
        [switch]$NoAnsiOutput
    )

    # Handle help request
    if ($h) {
        Show-ColorScriptHelp -CommandName 'Show-ColorScript'
        return
    }

    $quietRequested = $Quiet.IsPresent
    $noAnsiRequested = $NoAnsiOutput.IsPresent
    $noAnsiRequested = $NoAnsiOutput.IsPresent
    $noAnsiRequested = $NoAnsiOutput.IsPresent

    # Handle list request
    if ($List) {
        $listParams = @{}
        if ($Category) { $listParams.Category = $Category }
        if ($Tag) { $listParams.Tag = $Tag }
        if ($quietRequested) { $listParams.Quiet = $true }
        if ($noAnsiRequested) { $listParams.NoAnsiOutput = $true }
        Get-ColorScriptList @listParams
        return
    }

    # Handle -All parameter to cycle through all colorscripts
    if ($All) {
        # Get all colorscripts (with optional filters)
        $needsMetadata = ($Category -and $Category.Count -gt 0) -or ($Tag -and $Tag.Count -gt 0)
        $allScripts = if ($needsMetadata) {
            Get-ColorScriptEntry -Category $Category -Tag $Tag
        }
        else {
            Get-ColorScriptInventory
        }

        if (-not $allScripts -or $allScripts.Count -eq 0) {
            Write-Warning $script:Messages.NoColorscriptsFoundMatchingCriteria
            return
        }

        # Sort alphabetically
        $sortedScripts = $allScripts | Sort-Object Name
        $totalCount = $sortedScripts.Count
        $currentIndex = 0

        $displayingMessage = New-ColorScriptAnsiText -Text ($script:Messages.DisplayingColorscripts -f $totalCount) -Color 'Cyan' -NoAnsiOutput:$noAnsiRequested
        Write-ColorScriptInformation -Message $displayingMessage -Quiet:$quietRequested

        $modeMessage = if ($WaitForInput) { $script:Messages.PressSpacebarToContinue } else { $script:Messages.DisplayingContinuously }
        $modeQuiet = if ($WaitForInput) { $false } else { $quietRequested }
        $modeSegment = New-ColorScriptAnsiText -Text $modeMessage -Color 'Yellow' -NoAnsiOutput:$noAnsiRequested
        Write-ColorScriptInformation -Message $modeSegment -Quiet:$modeQuiet

        foreach ($script in $sortedScripts) {
            $currentIndex++

            # Clear screen and show progress
            Clear-Host
            $progressSegment = New-ColorScriptAnsiText -Text ($script:Messages.CurrentIndexOfTotal -f $currentIndex, $totalCount) -Color 'Green' -NoAnsiOutput:$noAnsiRequested
            $scriptNameSegment = New-ColorScriptAnsiText -Text $script.Name -Color 'Cyan' -NoAnsiOutput:$noAnsiRequested
            Write-ColorScriptInformation -Message ("$progressSegment $scriptNameSegment") -Quiet:$quietRequested

            $dividerSegment = New-ColorScriptAnsiText -Text ("=" * 60) -Color 'DarkGray' -NoAnsiOutput:$noAnsiRequested
            Write-ColorScriptInformation -Message $dividerSegment -Quiet:$quietRequested
            Write-ColorScriptInformation -Message '' -Quiet:$quietRequested

            # Display the colorscript
            $renderedOutput = $null
            if (-not $NoCache) {
                Initialize-CacheDirectory
                $cacheState = Get-CachedOutput -ScriptPath $script.Path
                if ($cacheState.Available) {
                    $renderedOutput = $cacheState.Content
                }
                else {
                    $cacheResult = Build-ScriptCache -ScriptPath $script.Path
                    $renderedOutput = $cacheResult.StdOut
                }
            }
            else {
                $executionResult = Invoke-ColorScriptProcess -ScriptPath $script.Path
                $renderedOutput = $executionResult.StdOut
            }

            if ($renderedOutput) {
                Invoke-WithUtf8Encoding -ScriptBlock {
                    param($text, $noAnsiOutput)
                    Write-RenderedText -Text $text -NoAnsiOutput:$noAnsiOutput
                } -Arguments @($renderedOutput, $noAnsiRequested)
            }

            # Wait for input if requested
            if ($WaitForInput -and $currentIndex -lt $totalCount) {
                Write-ColorScriptInformation -Message '' -Quiet:$quietRequested
                $promptMessage = New-ColorScriptAnsiText -Text $script:Messages.PressSpacebarForNext -Color 'Yellow' -NoAnsiOutput:$noAnsiRequested
                Write-ColorScriptInformation -Message $promptMessage -Quiet:$false

                $continueLoop = $true
                while ($continueLoop) {
                    $key = $Host.UI.RawUI.ReadKey('NoEcho,IncludeKeyDown')
                    if ($key.VirtualKeyCode -eq 32) {
                        # Spacebar
                        $continueLoop = $false
                    }
                    elseif ($key.Character -eq 'q' -or $key.Character -eq 'Q') {
                        $quitMessage = New-ColorScriptAnsiText -Text $script:Messages.Quitting -Color 'Yellow' -NoAnsiOutput:$noAnsiRequested
                        Write-ColorScriptInformation -Message $quitMessage -Quiet:$false
                        return
                    }
                }
                Write-ColorScriptInformation -Message '' -Quiet:$quietRequested
            }
            elseif (-not $WaitForInput -and $currentIndex -lt $totalCount) {
                # Small delay between scripts when auto-advancing
                Start-Sleep -Milliseconds 100
            }
        }

        Write-ColorScriptInformation -Message '' -Quiet:$quietRequested
        $completeMessage = New-ColorScriptAnsiText -Text ($script:Messages.FinishedDisplayingAll -f $totalCount) -Color 'Green' -NoAnsiOutput:$noAnsiRequested
        Write-ColorScriptInformation -Message $completeMessage -Quiet:$quietRequested
        return
    }

    # Optimization: Skip metadata loading if no filters are specified
    # This dramatically improves performance for simple Show-ColorScript calls
    $needsMetadata = ($Category -and $Category.Count -gt 0) -or ($Tag -and $Tag.Count -gt 0) -or $PassThru.IsPresent

    $records = if ($needsMetadata) {
        Get-ColorScriptEntry -Category $Category -Tag $Tag
    }
    else {
        # Fast path: reuse cached file inventory to avoid repeated allocations
        Get-ColorScriptInventory
    }

    if (-not $records -or $records.Count -eq 0) {
        Write-Warning ($script:Messages.NoColorscriptsFoundInScriptsPath -f $script:ScriptsPath)
        return
    }

    if ($Name) {
        $selectionResult = Select-RecordsByName -Records $records -Name $Name
        foreach ($pattern in $selectionResult.MissingPatterns) {
            Write-Warning ($script:Messages.ColorscriptNotFoundWithFilters -f $pattern)
        }

        $records = $selectionResult.Records
        if (-not $records -or $records.Count -eq 0) {
            return
        }
    }

    $useRandom = $Random -or $PSCmdlet.ParameterSetName -eq 'Random'

    $selection = $null

    if ($Name) {
        $orderedMatches = $records | Sort-Object Name
        if ($orderedMatches.Count -gt 1) {
            $matchedNames = $orderedMatches | Select-Object -ExpandProperty Name
            Write-Verbose ($script:Messages.MultipleColorscriptsMatched -f ($matchedNames -join ', '), $orderedMatches[0].Name)
        }
        $selection = $orderedMatches | Select-Object -First 1
    }
    elseif ($useRandom) {
        $rng = [System.Random]::new()
        $index = $rng.Next($records.Count)
        $selection = $records[$index]
    }
    else {
        $selection = $records | Select-Object -First 1
    }

    $renderedOutput = $null

    if (-not $NoCache) {
        # Lazy initialization: only initialize cache when actually needed
        Initialize-CacheDirectory

        $cacheState = Get-CachedOutput -ScriptPath $selection.Path
        if ($cacheState.Available) {
            $renderedOutput = $cacheState.Content
        }
        else {
            $cacheResult = Build-ScriptCache -ScriptPath $selection.Path
            if (-not $cacheResult.Success) {
                if ($cacheResult.StdErr) {
                    Write-Warning ($script:Messages.CacheBuildFailedForScript -f $selection.Name, $cacheResult.StdErr.Trim())
                }

                if ([string]::IsNullOrEmpty($cacheResult.StdOut)) {
                    Invoke-ColorScriptError -Message $script:Messages.FailedToBuildCacheForScript -ErrorId 'ColorScriptsEnhanced.CacheBuildFailed' -Category ([System.Management.Automation.ErrorCategory]::InvalidOperation) -TargetObject $selection.Name -Cmdlet $PSCmdlet
                }

                $renderedOutput = $cacheResult.StdOut
            }
            else {
                $renderedOutput = $cacheResult.StdOut
            }
        }
    }
    else {
        $executionResult = Invoke-ColorScriptProcess -ScriptPath $selection.Path
        if (-not $executionResult.Success) {
            $errorMessage = if ($executionResult.StdErr) { $executionResult.StdErr.Trim() } else { "Script exited with code $($executionResult.ExitCode)." }
            Invoke-ColorScriptError -Message ($script:Messages.FailedToExecuteColorscript -f $selection.Name, $errorMessage) -ErrorId 'ColorScriptsEnhanced.ScriptExecutionFailed' -Category ([System.Management.Automation.ErrorCategory]::InvalidOperation) -TargetObject $selection.Name -Cmdlet $PSCmdlet
        }

        $renderedOutput = $executionResult.StdOut
    }

    if ($null -eq $renderedOutput) {
        $renderedOutput = ''
    }

    $boundParameters = $PSCmdlet.MyInvocation.BoundParameters
    $pipelineLength = $PSCmdlet.MyInvocation.PipelineLength
    $shouldEmitText = Test-ColorScriptTextEmission -ReturnText:$ReturnText.IsPresent -PassThru:$PassThru.IsPresent -PipelineLength $pipelineLength -BoundParameters $boundParameters

    Invoke-WithUtf8Encoding -ScriptBlock {
        param($text, $emitText, $noAnsiOutput)

        if ($emitText) {
            Write-Output $text
            return
        }

        Write-RenderedText -Text $text -NoAnsiOutput:$noAnsiOutput
    } -Arguments @($renderedOutput, $shouldEmitText, $noAnsiRequested)

    if ($PassThru) {
        return $selection
    }
}

<#
.SYNOPSIS
Returns metadata-rich information about available color scripts.
.DESCRIPTION
Loads script metadata and optionally filters by category or tag before returning structured objects or displaying a table view.
.PARAMETER AsObject
return raw record objects instead of rendering a formatted table.
.PARAMETER Detailed
Include tag and description columns when emitting the formatted table view.
.PARAMETER Name
Filter the colorscript list by one or more names. Wildcards are supported and unmatched patterns generate warnings.
.PARAMETER Category
Filter the list to scripts belonging to one or more categories (case-insensitive).
.PARAMETER Tag
Filter the list to scripts containing one or more metadata tags (case-insensitive).
.PARAMETER Quiet
Suppress the formatted table output while still returning objects when requested.
.PARAMETER NoAnsiOutput
Strip ANSI color sequences from formatted output when emitting the table view.
#>
function Get-ColorScriptList {
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSUseOutputTypeCorrectly', '', Justification = 'Structured list is emitted for pipeline consumption.')]
    [OutputType([pscustomobject])]
    [CmdletBinding(HelpUri = 'https://nick2bad4u.github.io/PS-Color-Scripts-Enhanced/docs/help-redirect.html?cmdlet=Get-ColorScriptList')]
    param(
        [Alias('help')]
        [switch]$h,

        [switch]$AsObject,
        [switch]$Detailed,
        [SupportsWildcards()]
        [ValidateScript({ Test-ColorScriptNameValue $_ -AllowWildcard })]
        [string[]]$Name,
        [string[]]$Category,
        [string[]]$Tag,
        [switch]$Quiet,
        [switch]$NoAnsiOutput
    )

    if ($h) {
        Show-ColorScriptHelp -CommandName 'Get-ColorScriptList'
        return
    }

    $quietRequested = $Quiet.IsPresent

    $records = Get-ColorScriptEntry -Category $Category -Tag $Tag | Sort-Object Name

    if ($Name) {
        $selection = Select-RecordsByName -Records $records -Name $Name
        foreach ($pattern in $selection.MissingPatterns) {
            Write-Warning ($script:Messages.ScriptNotFound -f $pattern)
        }

        $records = $selection.Records
    }

    if (-not $records) {
        Write-Warning $script:Messages.NoColorscriptsAvailableWithFilters
        return [System.Object[]]@()
    }

    if (-not $AsObject) {
        $table = if ($Detailed) {
            $records | Select-Object Name, Category, @{ Name = 'Tags'; Expression = { $_.Tags -join ', ' } }, Description
        }
        else {
            $records | Select-Object Name, Category
        }

        if (-not $quietRequested) {
            $tableOutput = $table | Format-Table -AutoSize | Out-String
            if ($NoAnsiOutput) {
                $tableOutput = Remove-ColorScriptAnsiSequence -Text $tableOutput
            }
            Write-ColorScriptInformation -Message $tableOutput -Quiet:$false
        }
    }

    return $records
}

function Export-ColorScriptMetadata {
    <#
    .SYNOPSIS
    Export the module's colorscript metadata as structured objects or JSON.
    .DESCRIPTION
    Retrieves metadata for each colorscript, including categories and tags, and optionally augments it with
    file system and cache information. The result can be written to a JSON file for consumption by external
    tooling or returned directly to the pipeline.
    .PARAMETER Path
    Destination file path for the JSON output. When omitted, objects are emitted to the pipeline.
    .PARAMETER IncludeFileInfo
    Attach file system information (full path, file size, and last write time) for each colorscript.
    .PARAMETER IncludeCacheInfo
    Attach cache metadata including the cache location, whether a cache file exists, and its timestamp.
    .PARAMETER PassThru
    Return the in-memory objects even when writing to a file.
    .LINK
    https://nick2bad4u.github.io/PS-Color-Scripts-Enhanced/docs/help-redirect.html?cmdlet=Export-ColorScriptMetadata
    #>
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSUseSingularNouns', '', Justification = 'Metadata is a collective noun representing the exported dataset.')]
    [OutputType([pscustomobject])]
    [CmdletBinding(SupportsShouldProcess = $true, ConfirmImpact = 'Medium', HelpUri = 'https://nick2bad4u.github.io/PS-Color-Scripts-Enhanced/docs/help-redirect.html?cmdlet=Export-ColorScriptMetadata')]
    param(
        [Alias('help')]
        [switch]$h,

        [Parameter()]
        [ValidateScript({ Test-ColorScriptPathValue $_ })]
        [string]$Path,

        [Parameter()]
        [switch]$IncludeFileInfo,

        [Parameter()]
        [switch]$IncludeCacheInfo,

        [Parameter()]
        [switch]$PassThru
    )

    if ($h) {
        Show-ColorScriptHelp -CommandName 'Export-ColorScriptMetadata'
        return
    }

    $records = Get-ColorScriptEntry | Sort-Object Name
    Initialize-CacheDirectory

    $payload = @()

    foreach ($record in $records) {
        $entry = [ordered]@{
            Name        = $record.Name
            Category    = $record.Category
            Categories  = [string[]]$record.Categories
            Tags        = [string[]]$record.Tags
            Description = $record.Description
        }

        if ($IncludeFileInfo) {
            try {
                $fileInfo = Get-Item -LiteralPath $record.Path -ErrorAction Stop
                $entry['ScriptPath'] = $fileInfo.FullName
                $entry['ScriptSizeBytes'] = [int64]$fileInfo.Length
                $entry['ScriptLastWriteTimeUtc'] = $fileInfo.LastWriteTimeUtc
            }
            catch {
                $entry['ScriptPath'] = $record.Path
                $entry['ScriptSizeBytes'] = $null
                $entry['ScriptLastWriteTimeUtc'] = $null
                Write-Verbose ($script:Messages.UnableToRetrieveFileInfo -f $record.Name, $_.Exception.Message)
            }
        }

        if ($IncludeCacheInfo) {
            $cacheFile = if ($script:CacheDir) { Join-Path -Path $script:CacheDir -ChildPath "$($record.Name).cache" } else { $null }
            $cacheExists = $false
            $cacheTimestamp = $null

            if ($cacheFile -and (Test-Path -LiteralPath $cacheFile)) {
                $cacheExists = $true
                try {
                    $cacheInfo = Get-Item -LiteralPath $cacheFile -ErrorAction Stop
                    $cacheTimestamp = $cacheInfo.LastWriteTimeUtc
                }
                catch {
                    Write-Verbose ($script:Messages.UnableToReadCacheInfo -f $record.Name, $_.Exception.Message)
                }
            }

            $entry['CachePath'] = $cacheFile
            $entry['CacheExists'] = $cacheExists
            $entry['CacheLastWriteTimeUtc'] = $cacheTimestamp
        }

        $payload += [pscustomobject]$entry
    }

    if ($Path) {
        $resolvedPath = Resolve-CachePath -Path $Path
        if (-not $resolvedPath) {
            Invoke-ColorScriptError -Message ($script:Messages.UnableToResolveOutputPath -f $Path) -ErrorId 'ColorScriptsEnhanced.InvalidOutputPath' -Category ([System.Management.Automation.ErrorCategory]::InvalidArgument) -TargetObject $Path -Cmdlet $PSCmdlet
        }

        if (-not (Invoke-ShouldProcess -Cmdlet $PSCmdlet -Target $resolvedPath -Action 'Export colorscript metadata')) {
            if ($PassThru) {
                return $payload
            }

            return
        }

        $outputDirectory = Split-Path -Path $resolvedPath -Parent
        $directoryReady = $true

        if ($outputDirectory -and -not (Test-Path -LiteralPath $outputDirectory)) {
            $directoryReady = Invoke-ShouldProcess -Cmdlet $PSCmdlet -Target $outputDirectory -Action 'Create export directory'

            if ($directoryReady) {
                New-Item -ItemType Directory -Path $outputDirectory -Force | Out-Null
            }
        }

        if (-not $directoryReady) {
            if ($PassThru) {
                return $payload
            }

            return
        }

        $json = $payload | ConvertTo-Json -Depth 6
        Set-Content -Path $resolvedPath -Value ($json + [Environment]::NewLine) -Encoding UTF8

        if ($PassThru) {
            return $payload
        }

        return
    }

    return $payload
}

<#
.SYNOPSIS
Builds or refreshes the cache for one or more color scripts.
.DESCRIPTION
Uses cached path resolution to execute color scripts and persist their output, honoring Force, WhatIf, and ShouldProcess semantics.
 Accepts wildcard patterns so multiple scripts can be cached with a single command or streamed from the pipeline.
.PARAMETER Name
One or more colorscript names to cache. Supports wildcard patterns and pipeline input.
.PARAMETER All
Cache every available script. When omitted and no names are supplied, all scripts are cached by default.
.PARAMETER Force
Rebuild caches even when the existing cache file is newer than the script source.
.PARAMETER PassThru
Return detailed result objects for each cache operation. By default, only a summary is displayed.
.PARAMETER Category
Limit the selection to scripts that belong to the specified category (case-insensitive). Multiple values are treated as an OR filter.
.PARAMETER Tag
Limit the selection to scripts containing the specified metadata tags (case-insensitive). Multiple values are treated as an OR filter.
#>
function New-ColorScriptCache {
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSUseOutputTypeCorrectly', '', Justification = 'Returns structured pipeline records for each cache operation.')]
    [OutputType([pscustomobject])]
    [CmdletBinding(SupportsShouldProcess = $true, ConfirmImpact = 'Medium', HelpUri = 'https://nick2bad4u.github.io/PS-Color-Scripts-Enhanced/docs/help-redirect.html?cmdlet=New-ColorScriptCache')]
    [Alias('Update-ColorScriptCache')]
    param(
        [Parameter(ParameterSetName = 'Help')]
        [Alias('help')]
        [switch]$h,

        [Parameter(ValueFromPipeline, ValueFromPipelineByPropertyName)]
        [SupportsWildcards()]
        [ValidateScript({ Test-ColorScriptNameValue $_ -AllowWildcard })]
        [string[]]$Name,

        [Parameter()]
        [switch]$All,

        [Parameter()]
        [switch]$Force,

        [Parameter()]
        [switch]$PassThru,

        [Parameter()]
        [string[]]$Category,

        [Parameter()]
        [string[]]$Tag
    )

    begin {
        $helpRequested = $false
        if ($h) {
            Show-ColorScriptHelp -CommandName 'New-ColorScriptCache'
            $helpRequested = $true
            return
        }

        $collectedNames = New-Object 'System.Collections.Generic.List[string]'
    }

    process {
        if ($helpRequested) { return }

        if ($Name) {
            foreach ($value in $Name) {
                if (-not [string]::IsNullOrWhiteSpace($value)) {
                    $null = $collectedNames.Add($value)
                }
            }
        }
    }

    end {
        if ($helpRequested) { return }
        $records = @()
        $selectedNames = $collectedNames.ToArray()
        $allExplicitlyDisabled = $PSBoundParameters.ContainsKey('All') -and -not $All
        $filteredRecords = Get-ColorScriptEntry -Category $Category -Tag $Tag

        if ($selectedNames.Count -gt 0) {
            $selection = Select-RecordsByName -Records $filteredRecords -Name $selectedNames
            foreach ($pattern in $selection.MissingPatterns) {
                Write-Warning ($script:Messages.ScriptNotFound -f $pattern)
            }
            $records = $selection.Records
        }
        elseif ($allExplicitlyDisabled) {
            Invoke-ColorScriptError -Message $script:Messages.SpecifyNameToSelectScripts -ErrorId 'ColorScriptsEnhanced.CacheSelectionMissing' -Category ([System.Management.Automation.ErrorCategory]::InvalidOperation) -Cmdlet $PSCmdlet
        }
        else {
            $records = $filteredRecords
        }

        if ($records -is [System.Collections.IEnumerable]) {
            $records = @($records | Where-Object { $_ })
        }
        elseif ($null -eq $records) {
            $records = @()
        }
        else {
            $records = @($records)
        }

        $recordCount = ($records | Measure-Object).Count

        if ($recordCount -eq 0) {
            Write-Warning $script:Messages.NoScriptsSelectedForCacheBuild
            return [System.Management.Automation.PSCustomObject[]]@()
        }

        # Lazy initialization: only initialize cache when building
        Initialize-CacheDirectory

        if (-not (Invoke-ShouldProcess -Cmdlet $PSCmdlet -Target $script:CacheDir -Action "Build cache for $recordCount script(s)")) {
            return [System.Management.Automation.PSCustomObject[]]@()
        }

        $results = @()
        $totalCount = $recordCount
        $progressActivity = 'Building ColorScripts cache'

        for ($index = 0; $index -lt $totalCount; $index++) {
            $record = $records[$index]
            $scriptName = [string]$record.Name
            $cacheFile = Join-Path $script:CacheDir "$scriptName.cache"
            $percentComplete = [int](($index / [double]$totalCount) * 100)
            $statusMessage = "Processing {0}/{1}: {2}" -f ($index + 1), $totalCount, $scriptName
            Write-Progress -Id 1 -Activity $progressActivity -Status $statusMessage -PercentComplete $percentComplete -CurrentOperation $scriptName

            $entry = $null
            $resultStatus = 'Updated'

            if (-not $Force -and (Test-Path -LiteralPath $cacheFile)) {
                $scriptItem = Get-Item -LiteralPath $record.Path
                $cacheItem = Get-Item -LiteralPath $cacheFile
                if ($cacheItem.LastWriteTimeUtc -ge $scriptItem.LastWriteTimeUtc) {
                    $resultStatus = 'SkippedUpToDate'
                    $entry = [pscustomobject]@{
                        Name      = $scriptName
                        Status    = $resultStatus
                        CacheFile = $cacheFile
                        ExitCode  = 0
                        StdOut    = ''
                        StdErr    = ''
                    }
                }
            }

            if (-not $entry) {
                if (-not (Invoke-ShouldProcess -Cmdlet $PSCmdlet -Target $scriptName -Action 'Build cache')) {
                    $resultStatus = 'SkippedByUser'
                    $entry = [pscustomobject]@{
                        Name      = $scriptName
                        Status    = $resultStatus
                        CacheFile = $cacheFile
                        ExitCode  = $null
                        StdOut    = ''
                        StdErr    = ''
                    }
                }
                else {
                    $buildResult = Build-ScriptCache -ScriptPath $record.Path
                    $resultStatus = if ($buildResult.Success) { 'Updated' } else { 'Failed' }

                    if (-not $buildResult.Success -and $buildResult.StdErr) {
                        Write-Warning ($script:Messages.CacheBuildFailedForScript -f $selection.Name, $buildResult.StdErr.Trim())
                    }

                    $entry = [pscustomobject]@{
                        Name      = $scriptName
                        Status    = $resultStatus
                        CacheFile = $buildResult.CacheFile
                        ExitCode  = $buildResult.ExitCode
                        StdOut    = $buildResult.StdOut
                        StdErr    = $buildResult.StdErr
                    }
                }
            }

            $results += $entry

            $completionPercent = if ($totalCount -gt 0) { [int]((($index + 1) / [double]$totalCount) * 100) } else { 0 }
            $statusSuffix = $resultStatus
            switch ($resultStatus) {
                'Updated' { $statusSuffix = $script:Messages.StatusCached }
                'SkippedUpToDate' { $statusSuffix = $script:Messages.StatusSkippedUpToDate }
                'SkippedByUser' { $statusSuffix = $script:Messages.StatusSkippedByUser }
                'Failed' { $statusSuffix = $script:Messages.StatusFailed }
            }

            $completionMessage = "{0}/{1}: {2} - {3}" -f ($index + 1), $totalCount, $scriptName, $statusSuffix
            Write-Progress -Id 1 -Activity $progressActivity -Status $completionMessage -PercentComplete $completionPercent -CurrentOperation $scriptName
        }

        Write-Progress -Id 1 -Activity $progressActivity -Completed

        # Display summary if not using PassThru and there are results
        if (-not $PassThru -and $totalCount -gt 0) {
            $summary = $results | Group-Object -Property Status | ForEach-Object {
                [pscustomobject]@{
                    Status = $_.Name
                    Count  = $_.Count
                }
            }

            Write-Host $script:Messages.CacheBuildSummary -ForegroundColor Cyan
            Write-Host ("=" * 40) -ForegroundColor Cyan

            foreach ($item in $summary) {
                $color = switch ($item.Status) {
                    'Updated' { 'Green' }
                    'SkippedUpToDate' { 'Yellow' }
                    'Failed' { 'Red' }
                    'SkippedByUser' { 'Gray' }
                    default { 'White' }
                }
                $statusText = switch ($item.Status) {
                    'SkippedUpToDate' { $script:Messages.StatusUpToDateSkipped }
                    'Failed' { $script:Messages.StatusFailed }
                    'SkippedByUser' { $script:Messages.StatusSkippedByUser }
                    default { $item.Status }
                }
                Write-Host ("  {0,-25} {1}" -f $statusText, $item.Count) -ForegroundColor $color
            }

            $failed = $results | Where-Object { $_.Status -eq 'Failed' }
            if ($failed) {
                Write-Host $script:Messages.FailedScripts -ForegroundColor Red
                foreach ($failure in $failed) {
                    Write-Host ($script:Messages.FailedScriptDetails -f $failure.Name, $failure.StdErr) -ForegroundColor Red
                }
            }

            Write-Host ($script:Messages.TotalScriptsProcessed -f $totalCount) -ForegroundColor Cyan
            Write-Host $script:Messages.UsePassThruForDetailedResults -ForegroundColor Gray
        }

        if ($PassThru) {
            return [pscustomobject[]]$results
        }

        return
    }
}

<#
.SYNOPSIS
Removes color script cache files with optional dry-run support.
.DESCRIPTION
Clears cached script output for specific scripts or the entire cache directory while providing structured, scriptable results.
 Supports wildcard name patterns for batch operations while reporting unmatched patterns.
.PARAMETER Name
Names or wildcard patterns identifying cache files to remove. Accepts pipeline input and property binding.
.PARAMETER All
Remove every cache file in the target directory.
.PARAMETER Path
Alternate cache directory to operate against.
.PARAMETER DryRun
Preview removal actions without deleting files.
.PARAMETER Category
Filter the target scripts by category before evaluating cache entries.
.PARAMETER Tag
Filter the target scripts by metadata tag before evaluating cache entries.
#>
function Clear-ColorScriptCache {
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSUseOutputTypeCorrectly', '', Justification = 'Returns structured pipeline records for each cache entry.')]
    [OutputType([pscustomobject])]
    [CmdletBinding(SupportsShouldProcess = $true, ConfirmImpact = 'Medium', HelpUri = 'https://nick2bad4u.github.io/PS-Color-Scripts-Enhanced/docs/help-redirect.html?cmdlet=Clear-ColorScriptCache')]
    param(
        [Parameter(ParameterSetName = 'Help')]
        [Alias('help')]
        [switch]$h,

        [Parameter(ValueFromPipeline, ValueFromPipelineByPropertyName)]
        [SupportsWildcards()]
        [string[]]$Name,

        [Parameter()]
        [switch]$All,

        [Parameter()]
        [ValidateScript({ Test-ColorScriptPathValue $_ })]
        [string]$Path,

        [Parameter()]
        [switch]$DryRun,

        [Parameter()]
        [string[]]$Category,

        [Parameter()]
        [string[]]$Tag
    )

    begin {
        $helpRequested = $false
        if ($h) {
            Show-ColorScriptHelp -CommandName 'Clear-ColorScriptCache'
            $helpRequested = $true
            return
        }

        $collectedNames = New-Object 'System.Collections.Generic.List[string]'
    }

    process {
        if ($helpRequested) { return }

        if ($Name) {
            foreach ($value in $Name) {
                if (-not [string]::IsNullOrWhiteSpace($value)) {
                    $null = $collectedNames.Add($value)
                }
            }
        }
    }

    end {
        if ($helpRequested) { return }
        $filtersSpecified = ($Category -and $Category.Count -gt 0) -or ($Tag -and $Tag.Count -gt 0)

        $nameSet = New-Object 'System.Collections.Generic.HashSet[string]' ([System.StringComparer]::OrdinalIgnoreCase)
        foreach ($value in $collectedNames) {
            if (-not [string]::IsNullOrWhiteSpace($value)) {
                $null = $nameSet.Add($value)
            }
        }

        $filteredRecords = if ($filtersSpecified) { Get-ColorScriptEntry -Category $Category -Tag $Tag } else { @() }

        if ($filtersSpecified) {
            $filteredNameSet = New-Object 'System.Collections.Generic.HashSet[string]' ([System.StringComparer]::OrdinalIgnoreCase)
            foreach ($record in $filteredRecords) {
                if ($record -and $record.Name) {
                    $null = $filteredNameSet.Add($record.Name)
                }
            }

            if ($All -and $nameSet.Count -eq 0 -and $filteredNameSet.Count -gt 0) {
                foreach ($name in $filteredNameSet) {
                    $null = $nameSet.Add($name)
                }
            }
            elseif ($nameSet.Count -eq 0) {
                foreach ($name in $filteredNameSet) {
                    $null = $nameSet.Add($name)
                }
            }
            else {
                $skippedByFilter = New-Object 'System.Collections.Generic.List[string]'
                $namesSnapshot = @($nameSet)
                foreach ($name in $namesSnapshot) {
                    if (-not $filteredNameSet.Contains($name)) {
                        $null = $nameSet.Remove($name)
                        $null = $skippedByFilter.Add($name)
                    }
                }

                foreach ($skipped in $skippedByFilter) {
                    Write-Warning ($script:Messages.ScriptSkippedByFilter -f $skipped)
                }
            }
        }

        $selectedNames = @($nameSet)
        $operateOnAll = $All -and -not $filtersSpecified -and $selectedNames.Count -eq 0

        if (-not $operateOnAll -and $selectedNames.Count -eq 0) {
            if ($filtersSpecified) {
                Write-Warning $script:Messages.NoScriptsMatchedSpecifiedFilters
                return [pscustomobject[]]@()
            }

            Invoke-ColorScriptError -Message $script:Messages.SpecifyAllOrNameToClearCache -ErrorId 'ColorScriptsEnhanced.CacheClearSelectionMissing' -Category ([System.Management.Automation.ErrorCategory]::InvalidOperation) -Cmdlet $PSCmdlet
        }

        # Lazy initialization: only initialize cache when clearing
        Initialize-CacheDirectory

        $targetRoot = if ($Path) { $Path } else { $script:CacheDir }

        try {
            $targetRoot = (Resolve-Path -LiteralPath $targetRoot -ErrorAction Stop).ProviderPath
        }
        catch {
            Write-Warning ($script:Messages.CachePathNotFound -f $targetRoot)
            return [pscustomobject[]]@()
        }

        $results = @()

        if ($selectedNames.Count -gt 0) {
            $cacheFiles = Get-ChildItem -LiteralPath $targetRoot -File -ErrorAction SilentlyContinue |
                Where-Object { $_.Extension -eq '.cache' }
            $cacheRecords = @()
            if ($cacheFiles) {
                foreach ($file in $cacheFiles) {
                    $cacheRecords += [pscustomobject]@{
                        Name      = [System.IO.Path]::GetFileNameWithoutExtension($file.Name)
                        CacheFile = $file.FullName
                    }
                }
            }

            $selection = Select-RecordsByName -Records $cacheRecords -Name $selectedNames
            $recordIndex = @{}
            foreach ($entry in $selection.Records) {
                $key = $entry.Name.ToLowerInvariant()
                if (-not $recordIndex.ContainsKey($key)) {
                    $recordIndex[$key] = $entry
                }
            }

            $processedNames = New-Object 'System.Collections.Generic.HashSet[string]' ([System.StringComparer]::OrdinalIgnoreCase)

            foreach ($patternInfo in $selection.MatchMap) {
                if (-not $patternInfo.Matched) {
                    $results += [pscustomobject]@{
                        Name      = $patternInfo.Pattern
                        CacheFile = Join-Path -Path $targetRoot -ChildPath ("{0}.cache" -f $patternInfo.Pattern)
                        Status    = 'Missing'
                        Message   = $script:Messages.CacheFileNotFound
                    }
                    continue
                }

                foreach ($matchedName in $patternInfo.Matches) {
                    if (-not $processedNames.Add($matchedName)) {
                        continue
                    }

                    $lookupKey = $matchedName.ToLowerInvariant()
                    $entry = if ($recordIndex.ContainsKey($lookupKey)) { $recordIndex[$lookupKey] } else { $null }

                    if (-not $entry) {
                        $results += [pscustomobject]@{
                            Name      = $matchedName
                            CacheFile = Join-Path -Path $targetRoot -ChildPath ("{0}.cache" -f $matchedName)
                            Status    = 'Missing'
                            Message   = $script:Messages.CacheFileNotFound
                        }
                        continue
                    }

                    $cacheFile = $entry.CacheFile

                    if (-not (Test-Path -LiteralPath $cacheFile)) {
                        $results += [pscustomobject]@{
                            Name      = $matchedName
                            CacheFile = $cacheFile
                            Status    = 'Missing'
                            Message   = $script:Messages.CacheFileNotFound
                        }
                        continue
                    }

                    if (-not (Invoke-ShouldProcess -Cmdlet $PSCmdlet -Target $cacheFile -Action 'Clear cache')) {
                        $results += [pscustomobject]@{
                            Name      = $matchedName
                            CacheFile = $cacheFile
                            Status    = 'SkippedByUser'
                            Message   = ''
                        }
                        continue
                    }

                    if ($DryRun) {
                        $results += [pscustomobject]@{
                            Name      = $matchedName
                            CacheFile = $cacheFile
                            Status    = 'DryRun'
                            Message   = $script:Messages.NoChangesApplied
                        }
                        continue
                    }

                    try {
                        Remove-Item -LiteralPath $cacheFile -Force -ErrorAction Stop
                        $results += [pscustomobject]@{
                            Name      = $matchedName
                            CacheFile = $cacheFile
                            Status    = 'Removed'
                            Message   = ''
                        }
                    }
                    catch {
                        $results += [pscustomobject]@{
                            Name      = $matchedName
                            CacheFile = $cacheFile
                            Status    = 'Error'
                            Message   = $_.Exception.Message
                        }
                    }
                }
            }
        }
        else {
            $cacheFiles = Get-ChildItem -LiteralPath $targetRoot -File -ErrorAction SilentlyContinue |
                Where-Object { $_.Extension -eq '.cache' }
            if (-not $cacheFiles) {
                Write-Warning ($script:Messages.NoCacheFilesFound -f $targetRoot)
                return [System.Management.Automation.PSCustomObject[]]@()
            }

            if (-not (Invoke-ShouldProcess -Cmdlet $PSCmdlet -Target $targetRoot -Action "Clear $($cacheFiles.Count) cache file(s)")) {
                return [System.Management.Automation.PSCustomObject[]]@()
            }

            foreach ($file in $cacheFiles) {
                if ($DryRun) {
                    $results += [pscustomobject]@{
                        Name      = [System.IO.Path]::GetFileNameWithoutExtension($file.Name)
                        CacheFile = $file.FullName
                        Status    = 'DryRun'
                        Message   = $script:Messages.NoChangesApplied
                    }
                    continue
                }

                try {
                    Remove-Item -LiteralPath $file.FullName -Force -ErrorAction Stop
                    $results += [pscustomobject]@{
                        Name      = [System.IO.Path]::GetFileNameWithoutExtension($file.Name)
                        CacheFile = $file.FullName
                        Status    = 'Removed'
                        Message   = ''
                    }
                }
                catch {
                    $results += [pscustomobject]@{
                        Name      = [System.IO.Path]::GetFileNameWithoutExtension($file.Name)
                        CacheFile = $file.FullName
                        Status    = 'Error'
                        Message   = $_.Exception.Message
                    }
                }
            }
        }

        return [pscustomobject[]]$results
    }
}

function New-ColorScript {
    <#
    .SYNOPSIS
    Scaffold a new colorscript file with a ready-to-edit template.
    .DESCRIPTION
    Creates a PowerShell colorscript skeleton in the target directory (defaulting to the module's Scripts folder).
    Optionally emits guidance for updating ScriptMetadata.psd1 with category and tag suggestions.
    .PARAMETER Name
    Name of the new colorscript. A `.ps1` extension is appended automatically.
    .PARAMETER OutputPath
    Destination directory for the new script. Defaults to the module's Scripts directory.
    .PARAMETER Force
    Overwrite an existing file with the same name.
    .PARAMETER Category
    Suggested primary category for metadata guidance.
    .PARAMETER Tag
    Suggested metadata tags for the new script.
    .PARAMETER GenerateMetadataSnippet
    Emit a guidance snippet describing how to update ScriptMetadata.psd1.
    .LINK
    https://nick2bad4u.github.io/PS-Color-Scripts-Enhanced/docs/help-redirect.html?cmdlet=New-ColorScript
    #>
    [OutputType([pscustomobject])]
    [CmdletBinding(SupportsShouldProcess = $true, HelpUri = 'https://nick2bad4u.github.io/PS-Color-Scripts-Enhanced/docs/help-redirect.html?cmdlet=New-ColorScript')]
    param(
        [Alias('help')]
        [switch]$h,

        [Parameter(Mandatory)]
        [ValidatePattern('^[a-zA-Z0-9][a-zA-Z0-9_-]*$')]
        [string]$Name,

        [Parameter()]
        [ValidateScript({ Test-ColorScriptPathValue $_ })]
        [string]$OutputPath,

        [Parameter()]
        [switch]$Force,

        [Parameter()]
        [string]$Category,

        [Parameter()]
        [string[]]$Tag,

        [Parameter()]
        [switch]$GenerateMetadataSnippet
    )

    if ($h) {
        Show-ColorScriptHelp -CommandName 'New-ColorScript'
        return
    }

    $targetDirectory = $script:ScriptsPath
    if ($PSBoundParameters.ContainsKey('OutputPath')) {
        $resolvedOutput = Resolve-CachePath -Path $OutputPath
        if (-not $resolvedOutput) {
            Invoke-ColorScriptError -Message ($script:Messages.UnableToResolveOutputPath -f $OutputPath) -ErrorId 'ColorScriptsEnhanced.InvalidOutputPath' -Category ([System.Management.Automation.ErrorCategory]::InvalidArgument) -TargetObject $OutputPath -Cmdlet $PSCmdlet
        }
        $targetDirectory = $resolvedOutput
    }

    if (-not (Test-Path -LiteralPath $targetDirectory)) {
        New-Item -ItemType Directory -Path $targetDirectory -Force | Out-Null
    }

    $targetPath = Join-Path -Path $targetDirectory -ChildPath ("{0}.ps1" -f $Name)

    if ((Test-Path -LiteralPath $targetPath) -and -not $Force) {
        Invoke-ColorScriptError -Message ($script:Messages.ScriptAlreadyExists -f $targetPath) -ErrorId 'ColorScriptsEnhanced.ScriptAlreadyExists' -Category ([System.Management.Automation.ErrorCategory]::ResourceExists) -TargetObject $targetPath -Cmdlet $PSCmdlet
    }

    $template = @'
# __NAME__ colorscript
param()

$esc = [char]27
$ansiLines = @(
    "$esc[38;2;255;145;0mReplace this array with your ANSI art for '__NAME__'.",
    "$esc[0mAdd additional lines as needed."
)

foreach ($line in $ansiLines) {
    Write-Host $line
}
'@

    $template = $template.Replace('__NAME__', $Name)

    if ($PSCmdlet.ShouldProcess($targetPath, 'Create colorscript skeleton')) {
        [System.IO.File]::WriteAllText($targetPath, $template, $script:Utf8NoBomEncoding)
    }

    $metadataSnippet = $null
    if ($GenerateMetadataSnippet) {
        $categoryHint = if (-not [string]::IsNullOrWhiteSpace($Category)) { $Category } else { 'YourCategory' }
        $tagList = @($Tag | Where-Object { -not [string]::IsNullOrWhiteSpace($_) })
        if (-not $tagList) {
            $tagList = @('Custom')
        }

        $formattedTags = ($tagList | ForEach-Object { "'$_'" }) -join ', '
        $metadataSnippet = @"
# ScriptMetadata.psd1 guidance for '$Name'
#
# Categories:
#     '$categoryHint' = @(
#         # ...existing entries...
#         '$Name'
#     )
#
# Tags:
#     '$Name' = @($formattedTags)
"@
    }

    $result = [pscustomobject]@{
        Name               = $Name
        Path               = $targetPath
        CategorySuggestion = if ($Category) { $Category } else { $null }
        TagSuggestion      = if ($Tag) { [string[]]$Tag } else { @() }
        MetadataGuidance   = $metadataSnippet
    }

    if ($metadataSnippet) {
        Write-Verbose "Metadata guidance for '$Name':`n$metadataSnippet"
    }

    Reset-ScriptInventoryCache

    return $result
}

function Add-ColorScriptProfile {
    <#
    .EXTERNALHELP ColorScripts-Enhanced-help.xml
    #>
    [OutputType([pscustomobject])]
    [CmdletBinding(SupportsShouldProcess = $true, HelpUri = 'https://nick2bad4u.github.io/PS-Color-Scripts-Enhanced/docs/help-redirect.html?cmdlet=Add-ColorScriptProfile')]
    param(
        [Alias('help')]
        [switch]$h,

        [Parameter()]
        [ValidateSet('CurrentUserAllHosts', 'CurrentUserCurrentHost', 'AllUsersAllHosts', 'AllUsersCurrentHost')]
        [string]$Scope = 'CurrentUserAllHosts',

        [Parameter()]
        [ValidateScript({ Test-ColorScriptPathValue $_ })]
        [string]$Path,

        [Parameter()]
        [switch]$SkipStartupScript,

        [Parameter()]
        [switch]$Force
    )

    if ($h) {
        Show-ColorScriptHelp -CommandName 'Add-ColorScriptProfile'
        return
    }

    if ($null -ne $PSSenderInfo) {
        Write-Warning $script:Messages.ProfileUpdatesNotSupportedInRemote
        return [pscustomobject]@{
            Path    = $null
            Changed = $false
            Message = $script:Messages.RemoteSessionDetected
        }
    }

    $configuration = $null
    try {
        $configuration = Get-ColorScriptConfiguration
    }
    catch {
        Write-Verbose "Configuration unavailable: $($_.Exception.Message)"
    }

    $autoShow = $true
    $defaultStartupScript = $null

    if ($configuration -and $configuration.Startup) {
        if ($configuration.Startup.ContainsKey('ProfileAutoShow')) {
            $autoShow = [bool]$configuration.Startup.ProfileAutoShow
        }

        if ($configuration.Startup.ContainsKey('DefaultScript')) {
            $defaultStartupScript = $configuration.Startup.DefaultScript
        }
    }

    if ($PSBoundParameters.ContainsKey('SkipStartupScript')) {
        $autoShow = -not $SkipStartupScript.IsPresent
    }

    if ($PSBoundParameters.ContainsKey('Path')) {
        $profilePath = Resolve-CachePath -Path $Path
        if (-not $profilePath) {
            Invoke-ColorScriptError -Message ($script:Messages.UnableToResolveProfilePath -f $Path) -ErrorId 'ColorScriptsEnhanced.InvalidProfilePath' -Category ([System.Management.Automation.ErrorCategory]::InvalidArgument) -TargetObject $Path -Cmdlet $PSCmdlet
        }
    }
    else {
        $profilePath = $PROFILE.$Scope
        if ([string]::IsNullOrWhiteSpace($profilePath)) {
            Invoke-ColorScriptError -Message ($script:Messages.ProfilePathNotDefinedForScope -f $Scope) -ErrorId 'ColorScriptsEnhanced.ProfilePathUndefined' -Category ([System.Management.Automation.ErrorCategory]::ObjectNotFound) -TargetObject $Scope -Cmdlet $PSCmdlet
        }

        $resolvedProfile = Resolve-CachePath -Path $profilePath
        if ($resolvedProfile) {
            $profilePath = $resolvedProfile
        }
        elseif (-not [System.IO.Path]::IsPathRooted($profilePath)) {
            $profilePath = [System.IO.Path]::GetFullPath((Join-Path (Get-Location) $profilePath))
        }
    }

    $profileDirectory = Split-Path -Parent $profilePath
    if (-not (Test-Path $profileDirectory)) {
        New-Item -ItemType Directory -Path $profileDirectory -Force | Out-Null
    }

    $existingContent = ''
    if (Test-Path -LiteralPath $profilePath) {
        $existingContent = Get-Content -LiteralPath $profilePath -Raw
    }

    $newline = if ($existingContent -match "`r`n") {
        "`r`n"
    }
    elseif ($existingContent -match "`n") {
        "`n"
    }
    else {
        [Environment]::NewLine
    }
    $timestamp = (Get-Date).ToString('u')
    $snippetLines = @(
        "# Added by ColorScripts-Enhanced on $timestamp",
        'Import-Module ColorScripts-Enhanced'
    )

    if ($autoShow) {
        if (-not [string]::IsNullOrWhiteSpace($defaultStartupScript)) {
            $safeName = $defaultStartupScript -replace "'", "''"
            $snippetLines += "Show-ColorScript -Name '$safeName'"
        }
        else {
            $snippetLines += 'Show-ColorScript'
        }
    }

    $snippet = ($snippetLines -join $newline)
    $updatedContent = $existingContent

    $pattern = '(?ms)^# Added by ColorScripts-Enhanced.*?(?:\r?\n){2}'
    if ($updatedContent -match $pattern) {
        if (-not $Force) {
            Write-Verbose $script:Messages.ProfileAlreadyContainsSnippet
            return [pscustomobject]@{
                Path    = $profilePath
                Changed = $false
                Message = $script:Messages.ProfileAlreadyConfigured
            }
        }

        $updatedContent = [System.Text.RegularExpressions.Regex]::Replace($updatedContent, $pattern, '', 'MultiLine')
    }

    $importPattern = '(?mi)^\s*Import-Module\s+ColorScripts-Enhanced\b.*$'

    if (-not $Force -and $existingContent -match $importPattern) {
        Write-Verbose $script:Messages.ProfileAlreadyImportsModule
        return [pscustomobject]@{
            Path    = $profilePath
            Changed = $false
            Message = $script:Messages.ProfileAlreadyConfigured
        }
    }

    if ($Force) {
        $updatedContent = [System.Text.RegularExpressions.Regex]::Replace($updatedContent, $importPattern + '(?:\r?\n)?', '', 'Multiline')
        $showPattern = '(?mi)^\s*(Show-ColorScript|scs)\b.*(?:\r?\n)?'
        $updatedContent = [System.Text.RegularExpressions.Regex]::Replace($updatedContent, $showPattern, '', 'Multiline')
    }

    if ($PSCmdlet.ShouldProcess($profilePath, 'Add ColorScripts-Enhanced profile snippet')) {
        $trimmedExisting = $updatedContent.TrimEnd()
        if ($trimmedExisting) {
            $updatedContent = $trimmedExisting + $newline + $newline + $snippet
        }
        else {
            $updatedContent = $snippet
        }

        [System.IO.File]::WriteAllText($profilePath, $updatedContent + $newline, $script:Utf8NoBomEncoding)

        Write-Host ($script:Messages.ProfileSnippetAdded -f $profilePath) -ForegroundColor Green

        return [pscustomobject]@{
            Path    = $profilePath
            Changed = $true
            Message = $script:Messages.ProfileSnippetAddedMessage
        }
    }
}

# Internal helper to check if console output is redirected (testable wrapper)
function Test-ConsoleOutputRedirected {
    try {
        return (& $script:IsOutputRedirectedDelegate)
    }
    catch {
        return $false
    }
}

# Internal helper to honor startup preferences post-import
function Invoke-ColorScriptsStartup {
    try {
        $autoShowOverride = $env:COLOR_SCRIPTS_ENHANCED_AUTOSHOW_ON_IMPORT
        $overrideEnabled = $false
        if ($autoShowOverride) {
            $overrideEnabled = $autoShowOverride -match '^(1|true|yes)$'
            if (-not $overrideEnabled) {
                return
            }
        }

        $outputRedirected = $false
        try {
            $outputRedirected = Test-ConsoleOutputRedirected
        }
        catch {
            $outputRedirected = $false
        }

        if (-not $overrideEnabled) {
            if ($env:CI -eq 'true' -or $env:GITHUB_ACTIONS -eq 'true') {
                return
            }

            if ($Host.Name -eq 'ServerRemoteHost') {
                return
            }

            if ($outputRedirected) {
                return
            }
        }
        elseif ($outputRedirected) {
            Write-Verbose 'Console output is redirected; skipping auto-show despite override.'
            return
        }

        $configRoot = $null
        try {
            $configRoot = Get-ColorScriptsConfigurationRoot
        }
        catch {
            Write-Verbose "Unable to locate configuration root: $($_.Exception.Message)"
            if (-not $overrideEnabled) {
                return
            }
        }

        $configPath = if ($configRoot) { Join-Path -Path $configRoot -ChildPath 'config.json' } else { $null }
        if (-not $overrideEnabled -and $configPath -and -not (Test-Path -LiteralPath $configPath)) {
            return
        }

        # Only load configuration if we know auto-show might be enabled
        $configuration = Get-ConfigurationDataInternal
        if (-not $configuration.Startup.AutoShowOnImport -and -not $overrideEnabled) {
            return
        }

        $defaultScript = if ($configuration.Startup.ContainsKey('DefaultScript')) { $configuration.Startup.DefaultScript } else { $null }

        if (-not [string]::IsNullOrWhiteSpace($defaultScript)) {
            Show-ColorScript -Name $defaultScript -ErrorAction SilentlyContinue | Out-Null
        }
        else {
            Show-ColorScript -ErrorAction SilentlyContinue | Out-Null
        }
    }
    catch {
        Write-Verbose "Auto-show on import skipped: $($_.Exception.Message)"
    }
}

#endregion

# Export module members
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
) -Alias @('scs', 'Update-ColorScriptCache')

# Module initialization - cache and configuration are lazily loaded when first needed
Write-Verbose $script:Messages.ModuleLoadedSuccessfully
Invoke-ColorScriptsStartup
