ConvertFrom-StringData @'
# ColorScripts-Enhanced Localized Messages
# German (de) - Deutsch

# Error Messages
UnableToPrepareCacheDirectory = Cache-Verzeichnis '{0}' konnte nicht vorbereitet werden: {1}
FailedToParseConfigurationFile = Fehler beim Parsen der Konfigurationsdatei unter '{0}': {1}. Verwende Standardeinstellungen.
UnableToResolveCachePath = Cache-Pfad '{0}' konnte nicht aufgelöst werden.
ConfiguredCachePathInvalid = Konfigurierter Cache-Pfad '{0}' konnte nicht aufgelöst werden. Standardpfade werden verwendet.
UnableToResolveOutputPath = Ausgabepfad '{0}' konnte nicht aufgelöst werden.
UnableToDetermineConfigurationDirectory = Konfigurationsverzeichnis für ColorScripts-Enhanced konnte nicht bestimmt werden.
ConfigurationRootCouldNotBeResolved = Konfigurationsstamm konnte nicht aufgelöst werden.
UnableToResolveProfilePath = Profilpfad '{0}' konnte nicht aufgelöst werden.
FailedToExecuteColorscript = Colorscript '{0}' konnte nicht ausgeführt werden: {1}
FailedToBuildCacheForScript = Der Colorscript-Cache konnte nicht erstellt werden.
CacheBuildFailedForScript = Cache-Erstellung für {0} fehlgeschlagen: {1}
CacheBuildGenericFailure = Cache-Erstellung fehlgeschlagen.
CacheOperationWarning = Fehler beim Zwischenspeichern von '{0}': {1}
CacheOperationInitializationFailed = Cache-Verzeichnis konnte nicht initialisiert werden: {0}
ScriptAlreadyExists = Script '{0}' existiert bereits. Verwenden Sie -Force zum Überschreiben.
ProfilePathNotDefinedForScope = Profilpfad für Bereich '{0}' ist nicht definiert.
ScriptPathNotFound = Script-Pfad nicht gefunden.
ScriptExitedWithCode = Script wurde mit Code {0} beendet.
CacheFileNotFound = Cache-Datei nicht gefunden.
NoChangesApplied = Keine Änderungen angewendet.
UnableToRetrieveFileInfo = Dateiinformationen für '{0}' konnten nicht abgerufen werden: {1}
UnableToReadCacheInfo = Cache-Informationen für '{0}' konnten nicht gelesen werden: {1}
ProfileSnippetWriteFailed = ColorScripts-Enhanced Profil-Snippet konnte nicht nach '{0}' geschrieben werden: {1}
UnableToWriteColorScriptFile = Colorscript-Datei '{0}' konnte nicht geschrieben werden: {1}
InvalidScriptNameEmpty = Der Colorscript-Name darf nicht leer sein oder nur aus Leerzeichen bestehen.
InvalidScriptNameCharacters = Colorscript-Name '{0}' enthält ungültige Zeichen.
InvalidPathValueEmpty = Der Pfad darf nicht leer sein oder nur aus Leerzeichen bestehen.
InvalidPathValueCharacters = Pfad '{0}' enthält ungültige Zeichen.

# Warning Messages
NoColorscriptsFoundMatchingCriteria = Keine Colorscripts gefunden, die den angegebenen Kriterien entsprechen.
NoScriptsMatchedSpecifiedFilters = Keine Scripts entsprachen den angegebenen Filtern.
NoColorscriptsAvailableWithFilters = Keine Colorscripts verfügbar mit den angegebenen Filtern.
NoColorscriptsFoundInScriptsPath = Keine Colorscripts im Script-Pfad '{0}' gefunden.
NoScriptsSelectedForCacheBuild = Keine Scripts für Cache-Erstellung ausgewählt.
ScriptNotFound = Script nicht gefunden: {0}
ColorscriptNotFoundWithFilters = 'Colorscript '{0}' nicht gefunden mit den angegebenen Filtern.'
CachePathNotFound = Cache-Pfad nicht gefunden: {0}
NoCacheFilesFound = Keine Cache-Dateien unter {0} gefunden.
ProfileUpdatesNotSupportedInRemote = Profil-Updates werden in Remote-Sitzungen nicht unterstützt.
ScriptSkippedByFilter = Script '{0}' erfüllt die angegebenen Filter nicht und wird übersprungen.
ParallelCacheNotSupported = Die parallele Cache-Erstellung erfordert PowerShell 7 oder höher. Es wird auf sequenzielle Ausführung zurückgegriffen.

# Status Messages
DisplayingColorscripts = `nZeige {0} Colorscripts an...
CacheBuildSummary = `nCache-Erstellungsübersicht:
FailedScripts = `nFehlgeschlagene Scripts:
TotalScriptsProcessed = `nInsgesamt verarbeitete Scripts: {0}
DisplayingContinuously = Kontinuierliche Anzeige (Strg+C zum Stoppen)`n
FinishedDisplayingAll = Alle {0} Colorscripts wurden angezeigt!
Quitting = `nBeende...
CurrentIndexOfTotal = [{0}/{1}]
FailedScriptDetails =   - {0}: {1}
MultipleColorscriptsMatched = Mehrere Colorscripts entsprechen den angegebenen Namensmustern: {0}. '{1}' wird angezeigt.
StatusCached = Im Cache
StatusSkippedUpToDate = Übersprungen (aktuell)
StatusSkippedNotRequired = Übersprungen (Caching nicht erforderlich)
StatusSkippedByUser = Vom Benutzer übersprungen
StatusFailed = Fehlgeschlagen
StatusUpToDateSkipped = Aktuell (übersprungen)
CacheBuildSummaryFormat = Cache-Erstellungsübersicht: Verarbeitet {0}, aktualisiert {1}, übersprungen {2}, fehlgeschlagen {3}
CacheDirectoryFormat = Cache-Verzeichnis: {0}
CacheClearSummaryFormat = Cache-Bereinigungsübersicht: Entfernt {0}, nicht gefunden {1}, übersprungen {2}, Testlauf {3}, Fehler {4}

# Interactive Messages
PressSpacebarToContinue = Drücken Sie [Leertaste] um fortzufahren, [Q] zum Beenden`n
PressSpacebarForNext = Drücken Sie [Leertaste] für nächsten, [Q] zum Beenden...

# Success Messages
ProfileSnippetAdded = [OK] ColorScripts-Enhanced Startup-Snippet zu {0} hinzugefügt
ProfileAlreadyContainsSnippet = Profil enthält bereits ColorScripts-Enhanced Snippet.
ProfileAlreadyImportsModule = Profil importiert bereits ColorScripts-Enhanced.
ModuleLoadedSuccessfully = ColorScripts-Enhanced Modul erfolgreich geladen.
RemoteSessionDetected = Remote-Sitzung erkannt.
ProfileAlreadyConfigured = Profil bereits konfiguriert.
ProfileSnippetAddedMessage = ColorScripts-Enhanced Profil-Snippet hinzugefügt.
UnableToOpenEditorForPath = Editor konnte für '{0}' nicht geöffnet werden: {1}

# Help/Instruction Messages
SpecifyNameToSelectScripts = Geben Sie -Name an, um Scripts auszuwählen, wenn -All explizit deaktiviert ist.
SpecifyAllOrNameToClearCache = Geben Sie -All oder -Name an, um Cache-Einträge zu löschen.
UsePassThruForDetailedResults = Verwenden Sie -PassThru, um detaillierte Ergebnisse zu sehen`n

# UI Elements

# Miscellaneous
'@
