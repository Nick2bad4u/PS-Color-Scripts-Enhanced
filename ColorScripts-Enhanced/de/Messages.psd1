ConvertFrom-StringData @'
# ColorScripts-Enhanced Localized Messages
# German (de) - Deutsch

# Error Messages
UnableToPrepareCacheDirectory = Cache-Verzeichnis konnte nicht vorbereitet werden
FailedToParseConfigurationFile = Fehler beim Parsen der Konfigurationsdatei unter '{0}': {1}. Verwende Standardeinstellungen.
UnableToResolveCachePath = Unable to resolve cache path '{0}'.
ConfiguredCachePathInvalid = Konfigurierter Cache-Pfad
UnableToResolveOutputPath = Unable to resolve output path '{0}'.
UnableToDetermineConfigurationDirectory = Konfigurationsverzeichnis für ColorScripts-Enhanced konnte nicht bestimmt werden.
ConfigurationRootCouldNotBeResolved = Konfigurationsstamm konnte nicht aufgelöst werden.
UnableToResolveProfilePath = Unable to resolve profile path '{0}'.
FailedToExecuteColorscript = Colorscript konnte nicht ausgeführt werden
FailedToBuildCacheForScript = Cache für $($selection.Name) konnte nicht erstellt werden.
CacheBuildFailedForScript = Cache-Erstellung für $($selection.Name) fehlgeschlagen: $($cacheResult.StdErr.Trim())
ScriptAlreadyExists = Script ''$targetPath'' existiert bereits. Verwenden Sie -Force zum Überschreiben.
ProfilePathNotDefinedForScope = 'Profilpfad für Bereich ''$Scope'' ist nicht definiert.'
ScriptPathNotFound = Script-Pfad nicht gefunden.
ScriptExitedWithCode = Script wurde mit Code {0} beendet.
CacheFileNotFound = Cache-Datei nicht gefunden.
NoChangesApplied = Keine Änderungen angewendet.
UnableToRetrieveFileInfo = Dateiinformationen für ''{0}'' konnten nicht abgerufen werden: {1}
UnableToReadCacheInfo = Cache-Informationen für ''{0}'' konnten nicht gelesen werden: {1}

# Warning Messages
NoColorscriptsFoundMatchingCriteria = Keine Colorscripts gefunden, die den angegebenen Kriterien entsprechen.
NoScriptsMatchedSpecifiedFilters = Keine Scripts entsprachen den angegebenen Filtern.
NoColorscriptsAvailableWithFilters = Keine Colorscripts verfügbar mit den angegebenen Filtern.
NoColorscriptsFoundInScriptsPath = Keine Colorscripts gefunden in $script:ScriptsPath
NoScriptsSelectedForCacheBuild = Keine Scripts für Cache-Erstellung ausgewählt.
ScriptNotFound = Script nicht gefunden: $pattern
ColorscriptNotFoundWithFilters = 'Colorscript ''{0}'' nicht gefunden mit den angegebenen Filtern.'
CachePathNotFound = Cache-Pfad nicht gefunden: $targetRoot
NoCacheFilesFound = Keine Cache-Dateien gefunden unter $targetRoot.
ProfileUpdatesNotSupportedInRemote = Profil-Updates werden in Remote-Sitzungen nicht unterstützt.
ScriptSkippedByFilter = 'Script ''$skipped'' erfüllt die angegebenen Filter nicht und wird übersprungen.'

# Status Messages
DisplayingColorscripts = `nZeige $totalCount Colorscripts an...
CacheBuildSummary = `nCache-Erstellungsübersicht:
FailedScripts = `nFehlgeschlagene Scripts:
TotalScriptsProcessed = `nInsgesamt verarbeitete Scripts: $totalCount
DisplayingContinuously = Kontinuierliche Anzeige (Strg+C zum Stoppen)`n
FinishedDisplayingAll = Alle $totalCount Colorscripts wurden angezeigt!
Quitting = `nBeende...
CurrentIndexOfTotal = [$currentIndex/$totalCount]
FailedScriptDetails =   - $($failure.Name): $($failure.StdErr)
MultipleColorscriptsMatched = Mehrere Colorscripts entsprachen den bereitgestellten Namensmustern: $($matchedNames -join '', ''). Zeige ''$($orderedMatches[0].Name)'' an.
StatusCached = Im Cache
StatusSkippedUpToDate = Übersprungen (aktuell)
StatusSkippedByUser = Vom Benutzer übersprungen
StatusFailed = Fehlgeschlagen
StatusUpToDateSkipped = Aktuell (übersprungen)

# Interactive Messages
PressSpacebarToContinue = Drücken Sie [Leertaste] um fortzufahren, [Q] zum Beenden`n
PressSpacebarForNext = Drücken Sie [Leertaste] für nächsten, [Q] zum Beenden...

# Success Messages
ProfileSnippetAdded = [OK] ColorScripts-Enhanced Startup-Snippet zu $profilePath hinzugefügt
ProfileAlreadyContainsSnippet = Profil enthält bereits ColorScripts-Enhanced Snippet.
ProfileAlreadyImportsModule = Profil importiert bereits ColorScripts-Enhanced.
ModuleLoadedSuccessfully = ColorScripts-Enhanced Modul erfolgreich geladen.
RemoteSessionDetected = Remote-Sitzung erkannt.
ProfileAlreadyConfigured = Profil bereits konfiguriert.
ProfileSnippetAddedMessage = ColorScripts-Enhanced Profil-Snippet hinzugefügt.

# Help/Instruction Messages
SpecifyNameToSelectScripts = Geben Sie -Name an, um Scripts auszuwählen, wenn -All explizit deaktiviert ist.
SpecifyAllOrNameToClearCache = Geben Sie -All oder -Name an, um Cache-Einträge zu löschen.
UsePassThruForDetailedResults = Verwenden Sie -PassThru, um detaillierte Ergebnisse zu sehen`n

# UI Elements

# Miscellaneous
'@
