ConvertFrom-StringData @'
# ColorScripts-Enhanced Localized Messages
# Italian (it) - Italiano

# Error Messages
UnableToPrepareCacheDirectory = Impossibile preparare la directory della cache '{0}': {1}
FailedToParseConfigurationFile = Impossibile analizzare il file di configurazione in '{0}': {1}. Utilizzo dei valori predefiniti.
UnableToResolveCachePath = Impossibile risolvere il percorso della cache '{0}'.
ConfiguredCachePathInvalid = Impossibile risolvere il percorso della cache configurato '{0}'. Verranno usati i percorsi predefiniti.
UnableToResolveOutputPath = Impossibile risolvere il percorso di output '{0}'.
UnableToDetermineConfigurationDirectory = Impossibile determinare la directory di configurazione per ColorScripts-Enhanced.
ConfigurationRootCouldNotBeResolved = Impossibile risolvere la radice della configurazione.
UnableToResolveProfilePath = Impossibile risolvere il percorso del profilo '{0}'.
FailedToExecuteColorscript = Impossibile eseguire il colorscript '{0}': {1}
FailedToBuildCacheForScript = Impossibile creare la cache dei colorscript.
CacheBuildFailedForScript = Creazione della cache non riuscita per {0}: {1}
CacheBuildGenericFailure = Creazione della cache non riuscita.
CacheOperationWarning = Impossibile memorizzare nella cache '{0}': {1}
CacheOperationInitializationFailed = Impossibile inizializzare la directory della cache: {0}
ScriptAlreadyExists = Lo script '{0}' esiste già. Usa -Force per sovrascriverlo.
ProfilePathNotDefinedForScope = Il percorso del profilo per l'ambito '{0}' non è definito.
ScriptPathNotFound = Percorso script non trovato.
ScriptExitedWithCode = Lo script è terminato con codice {0}.
CacheFileNotFound = File cache non trovato.
NoChangesApplied = Nessuna modifica applicata.
UnableToRetrieveFileInfo = Impossibile recuperare le informazioni del file per '{0}': {1}
UnableToReadCacheInfo = Impossibile leggere le informazioni cache per '{0}': {1}
ProfileSnippetWriteFailed = Impossibile scrivere lo snippet di profilo ColorScripts-Enhanced in '{0}': {1}
UnableToWriteColorScriptFile = Impossibile scrivere il file colorscript '{0}': {1}
InvalidScriptNameEmpty = Il nome del colorscript non può essere vuoto o contenere solo spazi.
InvalidScriptNameCharacters = Il nome del colorscript '{0}' contiene caratteri non validi.
InvalidPathValueEmpty = Il percorso non può essere vuoto o contenere solo spazi.
InvalidPathValueCharacters = Il percorso '{0}' contiene caratteri non validi.

# Warning Messages
NoColorscriptsFoundMatchingCriteria = Nessun colorscript trovato che corrisponda ai criteri specificati.
NoScriptsMatchedSpecifiedFilters = Nessuno script corrisponde ai filtri specificati.
NoColorscriptsAvailableWithFilters = Nessun colorscript disponibile con i filtri specificati.
NoColorscriptsFoundInScriptsPath = Nessun colorscript trovato nel percorso degli script '{0}'.
NoScriptsSelectedForCacheBuild = Nessuno script selezionato per la creazione della cache.
ScriptNotFound = Script non trovato: {0}
ColorscriptNotFoundWithFilters = 'Colorscript '{0}' non trovato con i filtri specificati.'
CachePathNotFound = Percorso della cache non trovato: {0}
NoCacheFilesFound = Nessun file di cache trovato in {0}.
ProfileUpdatesNotSupportedInRemote = Gli aggiornamenti del profilo non sono supportati nelle sessioni remote.
ScriptSkippedByFilter = Lo script '{0}' non soddisfa i filtri specificati e verrà ignorato.
ParallelCacheNotSupported = La creazione parallela della cache richiede PowerShell 7 o versioni successive. Verrà usata l'esecuzione sequenziale.

# Status Messages
DisplayingColorscripts = `nVisualizzazione di {0} colorscript...
CacheBuildSummary = `nRiepilogo creazione cache:
FailedScripts = `nScript falliti:
TotalScriptsProcessed = `nTotale script elaborati: {0}
DisplayingContinuously = Visualizzazione continua (premi Ctrl+C per interrompere)`n
FinishedDisplayingAll = Visualizzazione completata di tutti i {0} colorscript!
Quitting = `nUscita in corso...
CurrentIndexOfTotal = [{0}/{1}]
FailedScriptDetails =   - {0}: {1}
MultipleColorscriptsMatched = Più colorscript corrispondono ai pattern di nome forniti: {0}. Verrà visualizzato '{1}'.
StatusCached = In cache
StatusSkippedUpToDate = Saltato (aggiornato)
StatusSkippedNotRequired = Ignorato (cache non necessaria)
StatusSkippedByUser = 'Saltato dall'utente'
StatusFailed = Fallito
StatusUpToDateSkipped = Aggiornato (saltato)
CacheBuildSummaryFormat = Riepilogo creazione cache: elaborati {0}, aggiornati {1}, ignorati {2}, non riusciti {3}
CacheDirectoryFormat = Directory della cache: {0}
CacheClearSummaryFormat = Riepilogo pulizia cache: rimossi {0}, mancanti {1}, ignorati {2}, simulati {3}, errori {4}

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
