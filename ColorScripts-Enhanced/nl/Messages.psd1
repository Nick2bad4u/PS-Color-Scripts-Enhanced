ConvertFrom-StringData @'
# ColorScripts-Enhanced Localized Messages
# Dutch (nl) - Nederlands

# Error Messages
UnableToPrepareCacheDirectory = 'Kan cachemap niet voorbereiden '
FailedToParseConfigurationFile = 'Kan configuratiebestand niet parseren in '
UnableToResolveCachePath = 'Kan cachepad niet oplossen '
ConfiguredCachePathInvalid = 'Geconfigureerd cachepad '
UnableToResolveOutputPath = 'Kan uitvoerpad niet oplossen '
UnableToDetermineConfigurationDirectory = 'Kan configuratiemap voor ColorScripts-Enhanced niet bepalen.'
ConfigurationRootCouldNotBeResolved = 'Configuratiewortel kon niet worden opgelost.'
UnableToResolveProfilePath = 'Kan profielpad niet oplossen '
FailedToExecuteColorscript = 'Kan colorscript niet uitvoeren '
FailedToBuildCacheForScript = 'Kan cache niet maken voor $($selection.Name).'
CacheBuildFailedForScript = 'Cache maken mislukt voor $($selection.Name): $($cacheResult.StdErr.Trim())'
ScriptAlreadyExists = 'Script ''$targetPath'' bestaat al. Gebruik -Force om te overschrijven.'
ProfilePathNotDefinedForScope = 'Profielpad voor scope ''$Scope'' is niet gedefinieerd.'
ScriptPathNotFound = 'Scriptpad niet gevonden.'
ScriptExitedWithCode = 'Script eindigde met code {0}.'
CacheFileNotFound = 'Cachebestand niet gevonden.'
NoChangesApplied = 'Geen wijzigingen toegepast.'
UnableToRetrieveFileInfo = 'Kan bestandsinfo niet ophalen voor ''{0}'': {1}'
UnableToReadCacheInfo = 'Kan cacheinfo niet lezen voor ''{0}'': {1}'

# Warning Messages
NoColorscriptsFoundMatchingCriteria = 'Geen colorscripts gevonden die overeenkomen met de opgegeven criteria.'
NoScriptsMatchedSpecifiedFilters = 'Geen scripts kwamen overeen met de opgegeven filters.'
NoColorscriptsAvailableWithFilters = 'Geen colorscripts beschikbaar met de opgegeven filters.'
NoColorscriptsFoundInScriptsPath = 'Geen colorscripts gevonden in $script:ScriptsPath'
NoScriptsSelectedForCacheBuild = 'Geen scripts geselecteerd voor cache maken.'
ScriptNotFound = 'Script niet gevonden: $pattern'
ColorscriptNotFoundWithFilters = 'Colorscript ''{0}'' niet gevonden met de opgegeven filters.'
CachePathNotFound = 'Cachepad niet gevonden: $targetRoot'
NoCacheFilesFound = 'Geen cachebestanden gevonden in $targetRoot.'
ProfileUpdatesNotSupportedInRemote = 'Profielupdates worden niet ondersteund in externe sessies.'
ScriptSkippedByFilter = 'Script ''$skipped'' voldoet niet aan de opgegeven filters en wordt overgeslagen.'

# Status Messages
DisplayingColorscripts = '`n$($totalCount) colorscripts weergeven...'
CacheBuildSummary = '`nCache Bouw Samenvatting:'
FailedScripts = '`nMislukte scripts:'
TotalScriptsProcessed = '`nTotaal scripts verwerkt: $totalCount'
DisplayingContinuously = 'Continu weergeven (Ctrl+C om te stoppen)`n'
FinishedDisplayingAll = 'Klaar met weergeven van alle $totalCount colorscripts!'
Quitting = '`nAfsluiten...'
CurrentIndexOfTotal = '[$currentIndex/$totalCount] '
FailedScriptDetails = '  - $($failure.Name): $($failure.StdErr)'
MultipleColorscriptsMatched = 'Meerdere colorscripts kwamen overeen met het opgegeven naam patroon: $($matchedNames -join '', ''). Weergeven van ''$($orderedMatches[0].Name)''.'
StatusCached = 'Gecached'
StatusSkippedUpToDate = 'Overgeslagen (bijgewerkt)'
StatusSkippedByUser = 'Overgeslagen door gebruiker'
StatusFailed = 'Mislukt'
StatusUpToDateSkipped = 'Bijgewerkt (overgeslagen)'

# Interactive Messages
PressSpacebarToContinue = 'Druk [Spatiebalk] om door te gaan naar volgende, [Q] om af te sluiten`n'
PressSpacebarForNext = 'Druk [Spatiebalk] voor volgende, [Q] om af te sluiten...'

# Success Messages
ProfileSnippetAdded = '[OK] ColorScripts-Enhanced opstartsnippet toegevoegd aan $profilePath'
ProfileAlreadyContainsSnippet = 'Profiel bevat al ColorScripts-Enhanced snippet.'
ProfileAlreadyImportsModule = 'Profiel importeert al ColorScripts-Enhanced.'
ModuleLoadedSuccessfully = 'ColorScripts-Enhanced module succesvol geladen.'
RemoteSessionDetected = 'Externe sessie gedetecteerd.'
ProfileAlreadyConfigured = 'Profiel al geconfigureerd.'
ProfileSnippetAddedMessage = 'ColorScripts-Enhanced profiel snippet toegevoegd.'

# Help/Instruction Messages
SpecifyNameToSelectScripts = 'Geef -Name op om scripts te selecteren wanneer -All expliciet is uitgeschakeld.'
SpecifyAllOrNameToClearCache = 'Geef -All of -Name op om cachevermeldingen te wissen.'
UsePassThruForDetailedResults = 'Gebruik -PassThru voor gedetailleerde resultaten`n'

# UI Elements

# Miscellaneous
'@
