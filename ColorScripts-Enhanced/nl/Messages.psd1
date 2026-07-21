ConvertFrom-StringData @'
# ColorScripts-Enhanced Localized Messages
# Dutch (nl) - Nederlands

# Error Messages
UnableToPrepareCacheDirectory = Kan cachemap '{0}' niet voorbereiden: {1}
FailedToParseConfigurationFile = Fout bij het parseren van het configuratiebestand op '{0}': {1}. Standaardwaarden worden gebruikt.
UnableToResolveCachePath = Kan cachepad '{0}' niet herleiden.
ConfiguredCachePathInvalid = Kan het geconfigureerde cachepad '{0}' niet herleiden. De standaardlocaties worden gebruikt.
UnableToResolveOutputPath = Kan uitvoerpad '{0}' niet herleiden.
UnableToDetermineConfigurationDirectory = Kan configuratiemap voor ColorScripts-Enhanced niet bepalen.
ConfigurationRootCouldNotBeResolved = Configuratiewortel kon niet worden opgelost.
UnableToResolveProfilePath = Kan profielpad '{0}' niet herleiden.
FailedToExecuteColorscript = Kan colorscript '{0}' niet uitvoeren: {1}
FailedToBuildCacheForScript = Kan de colorscriptcache niet maken.
CacheBuildFailedForScript = Cache maken mislukt voor {0}: {1}
CacheBuildGenericFailure = Cache maken mislukt.
CacheOperationWarning = Cachen van '{0}' is mislukt: {1}
CacheOperationInitializationFailed = Cachemap kon niet worden geïnitialiseerd: {0}
ScriptAlreadyExists = Script '{0}' bestaat al. Gebruik -Force om het te overschrijven.
ProfilePathNotDefinedForScope = Profielpad voor bereik '{0}' is niet gedefinieerd.
ScriptPathNotFound = Scriptpad niet gevonden.
ScriptExitedWithCode = Script eindigde met code {0}.
CacheFileNotFound = Cachebestand niet gevonden.
NoChangesApplied = Geen wijzigingen toegepast.
UnableToRetrieveFileInfo = Kan bestandsinfo niet ophalen voor '{0}': {1}
UnableToReadCacheInfo = Kan cacheinfo niet lezen voor '{0}': {1}
ProfileSnippetWriteFailed = ColorScripts-Enhanced-profielsnippet kon niet naar '{0}' worden geschreven: {1}
UnableToWriteColorScriptFile = Colorscript-bestand '{0}' kon niet worden geschreven: {1}
InvalidScriptNameEmpty = De colorscriptnaam mag niet leeg zijn of alleen uit witruimte bestaan.
InvalidScriptNameCharacters = Colorscriptnaam '{0}' bevat ongeldige tekens.
InvalidPathValueEmpty = Het pad mag niet leeg zijn of alleen uit witruimte bestaan.
InvalidPathValueCharacters = Pad '{0}' bevat ongeldige tekens.

# Warning Messages
NoColorscriptsFoundMatchingCriteria = Geen colorscripts gevonden die overeenkomen met de opgegeven criteria.
NoScriptsMatchedSpecifiedFilters = Geen scripts kwamen overeen met de opgegeven filters.
NoColorscriptsAvailableWithFilters = Geen colorscripts beschikbaar met de opgegeven filters.
NoColorscriptsFoundInScriptsPath = Geen colorscripts gevonden in scriptpad '{0}'.
NoScriptsSelectedForCacheBuild = Geen scripts geselecteerd voor cache maken.
ScriptNotFound = Script niet gevonden: {0}
ColorscriptNotFoundWithFilters = 'Colorscript '{0}' niet gevonden met de opgegeven filters.'
CachePathNotFound = Cachepad niet gevonden: {0}
NoCacheFilesFound = Geen cachebestanden gevonden in {0}.
ProfileUpdatesNotSupportedInRemote = Profielupdates worden niet ondersteund in externe sessies.
ScriptSkippedByFilter = Script '{0}' voldoet niet aan de opgegeven filters en wordt overgeslagen.
ParallelCacheNotSupported = Parallelle cacheopbouw vereist PowerShell 7 of hoger. Er wordt teruggevallen op sequentiële uitvoering.

# Status Messages
DisplayingColorscripts = `n{0} colorscripts weergeven...
CacheBuildSummary = `nCache Bouw Samenvatting:
FailedScripts = `nMislukte scripts:
TotalScriptsProcessed = `nTotaal scripts verwerkt: {0}
DisplayingContinuously = Continu weergeven (Ctrl+C om te stoppen)`n
FinishedDisplayingAll = Klaar met weergeven van alle {0} colorscripts!
Quitting = `nAfsluiten...
CurrentIndexOfTotal = [{0}/{1}]
FailedScriptDetails =   - {0}: {1}
MultipleColorscriptsMatched = Meerdere colorscripts kwamen overeen met de opgegeven naampatronen: {0}. '{1}' wordt weergegeven.
StatusCached = Gecached
StatusSkippedUpToDate = Overgeslagen (bijgewerkt)
StatusSkippedNotRequired = Overgeslagen (cache niet nodig)
StatusSkippedByUser = Overgeslagen door gebruiker
StatusFailed = Mislukt
StatusUpToDateSkipped = Bijgewerkt (overgeslagen)
CacheBuildSummaryFormat = Samenvatting cacheopbouw: verwerkt {0}, bijgewerkt {1}, overgeslagen {2}, mislukt {3}
CacheDirectoryFormat = Cachemap: {0}
CacheClearSummaryFormat = Samenvatting cache wissen: verwijderd {0}, ontbrekend {1}, overgeslagen {2}, simulatie {3}, fouten {4}

# Interactive Messages
PressSpacebarToContinue = Druk [Spatiebalk] om door te gaan naar volgende, [Q] om af te sluiten`n
PressSpacebarForNext = Druk [Spatiebalk] voor volgende, [Q] om af te sluiten...

# Success Messages
ProfileSnippetAdded = [OK] ColorScripts-Enhanced opstartsnippet toegevoegd aan {0}
ProfileAlreadyContainsSnippet = Profiel bevat al ColorScripts-Enhanced snippet.
ProfileAlreadyImportsModule = Profiel importeert al ColorScripts-Enhanced.
ModuleLoadedSuccessfully = ColorScripts-Enhanced module succesvol geladen.
RemoteSessionDetected = Externe sessie gedetecteerd.
ProfileAlreadyConfigured = Profiel al geconfigureerd.
ProfileSnippetAddedMessage = ColorScripts-Enhanced profiel snippet toegevoegd.
UnableToOpenEditorForPath = Kon editor niet openen voor '{0}': {1}

# Help/Instruction Messages
SpecifyNameToSelectScripts = Geef -Name op om scripts te selecteren wanneer -All expliciet is uitgeschakeld.
SpecifyAllOrNameToClearCache = Geef -All of -Name op om cachevermeldingen te wissen.
UsePassThruForDetailedResults = Gebruik -PassThru voor gedetailleerde resultaten`n

# UI Elements

# Miscellaneous
'@
