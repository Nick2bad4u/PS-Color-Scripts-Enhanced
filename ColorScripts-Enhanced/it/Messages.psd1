ConvertFrom-StringData @'
# ColorScripts-Enhanced Localized Messages
# Italian (it) - Italiano

# Error Messages
UnableToPrepareCacheDirectory = Impossibile preparare la directory cache
FailedToParseConfigurationFile = Impossibile analizzare il file di configurazione in '{0}': {1}. Utilizzo dei valori predefiniti.
UnableToResolveCachePath = Unable to resolve cache path '{0}'.
ConfiguredCachePathInvalid = Percorso cache configurato non valido
UnableToResolveOutputPath = Unable to resolve output path '{0}'.
UnableToDetermineConfigurationDirectory = Impossibile determinare la directory di configurazione per ColorScripts-Enhanced.
ConfigurationRootCouldNotBeResolved = Impossibile risolvere la radice della configurazione.
UnableToResolveProfilePath = Unable to resolve profile path '{0}'.
FailedToExecuteColorscript = Impossibile eseguire il colorscript
FailedToBuildCacheForScript = Impossibile creare la cache per $($selection.Name).
CacheBuildFailedForScript = Creazione della cache non riuscita per {0}: {1}
CacheBuildGenericFailure = Creazione della cache non riuscita.
CacheOperationWarning = Impossibile memorizzare nella cache '{0}': {1}
CacheOperationInitializationFailed = Impossibile inizializzare la directory della cache: {0}
ScriptAlreadyExists = Lo script ''$targetPath'' esiste già. Usa -Force per sovrascrivere.
ProfilePathNotDefinedForScope = 'Il percorso del profilo per l''ambito ''$Scope'' non è definito.'
ScriptPathNotFound = Percorso script non trovato.
ScriptExitedWithCode = Lo script è terminato con codice {0}.
CacheFileNotFound = File cache non trovato.
NoChangesApplied = Nessuna modifica applicata.
UnableToRetrieveFileInfo = Impossibile recuperare le informazioni del file per ''{0}'': {1}
UnableToReadCacheInfo = Impossibile leggere le informazioni cache per ''{0}'': {1}
ProfileSnippetWriteFailed = Impossibile scrivere lo snippet di profilo ColorScripts-Enhanced in '{0}': {1}
UnableToWriteColorScriptFile = Impossibile scrivere il file colorscript '{0}': {1}
InvalidScriptNameEmpty = Color script name cannot be empty or whitespace.
InvalidScriptNameCharacters = Color script name '{0}' contains invalid characters.
InvalidPathValueEmpty = Path value cannot be empty or whitespace.
InvalidPathValueCharacters = Path '{0}' contains invalid characters.

# Warning Messages
NoColorscriptsFoundMatchingCriteria = Nessun colorscript trovato che corrisponda ai criteri specificati.
NoScriptsMatchedSpecifiedFilters = Nessuno script corrisponde ai filtri specificati.
NoColorscriptsAvailableWithFilters = Nessun colorscript disponibile con i filtri specificati.
NoColorscriptsFoundInScriptsPath = Nessun colorscript trovato in $script:ScriptsPath
NoScriptsSelectedForCacheBuild = Nessuno script selezionato per la creazione della cache.
ScriptNotFound = Script non trovato: $pattern
ColorscriptNotFoundWithFilters = 'Colorscript ''{0}'' non trovato con i filtri specificati.'
CachePathNotFound = Percorso cache non trovato: $targetRoot
NoCacheFilesFound = Nessun file cache trovato in $targetRoot.
ProfileUpdatesNotSupportedInRemote = Gli aggiornamenti del profilo non sono supportati nelle sessioni remote.
ScriptSkippedByFilter = 'Lo script ''$skipped'' non soddisfa i filtri specificati e verrà saltato.'

# Status Messages
DisplayingColorscripts = `nVisualizzazione di $totalCount colorscript...
CacheBuildSummary = `nRiepilogo creazione cache:
FailedScripts = `nScript falliti:
TotalScriptsProcessed = `nTotale script elaborati: $totalCount
DisplayingContinuously = Visualizzazione continua (premi Ctrl+C per interrompere)`n
FinishedDisplayingAll = Visualizzazione completata di tutti i $totalCount colorscript!
Quitting = `nUscita in corso...
CurrentIndexOfTotal = [$currentIndex/$totalCount]
FailedScriptDetails =   - $($failure.Name): $($failure.StdErr)
MultipleColorscriptsMatched = Più colorscript corrispondono al pattern del nome fornito: $($matchedNames -join '', ''). Visualizzazione di ''$($orderedMatches[0].Name)''.
StatusCached = In cache
StatusSkippedUpToDate = Saltato (aggiornato)
StatusSkippedByUser = 'Saltato dall''utente'
StatusFailed = Fallito
StatusUpToDateSkipped = Aggiornato (saltato)
CacheBuildSummaryFormat = Cache build summary: Processed {0}, Updated {1}, Skipped {2}, Failed {3}
CacheClearSummaryFormat = Cache clear summary: Removed {0}, Missing {1}, Skipped {2}, DryRun {3}, Errors {4}

# Interactive Messages
PressSpacebarToContinue = Premi [Barra spaziatrice] per continuare al successivo, [Q] per uscire`n
PressSpacebarForNext = Premi [Barra spaziatrice] per il successivo, [Q] per uscire...

# Success Messages
ProfileSnippetAdded = [OK] Aggiunto snippet di avvio ColorScripts-Enhanced a {0}
ProfileAlreadyContainsSnippet = Il profilo contiene già lo snippet ColorScripts-Enhanced.
ProfileAlreadyImportsModule = Il profilo importa già ColorScripts-Enhanced.
ModuleLoadedSuccessfully = Modulo ColorScripts-Enhanced caricato correttamente.
RemoteSessionDetected = Sessione remota rilevata.
ProfileAlreadyConfigured = Profilo già configurato.
ProfileSnippetAddedMessage = Snippet profilo ColorScripts-Enhanced aggiunto.
UnableToOpenEditorForPath = Impossibile aprire l'editor per '{0}': {1}

# Help/Instruction Messages
SpecifyNameToSelectScripts = Specifica -Name per selezionare script quando -All è disabilitato esplicitamente.
SpecifyAllOrNameToClearCache = Specifica -All o -Name per cancellare le voci cache.
UsePassThruForDetailedResults = Usa -PassThru per vedere risultati dettagliati`n

# UI Elements

# Miscellaneous
'@
