ConvertFrom-StringData @'
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
