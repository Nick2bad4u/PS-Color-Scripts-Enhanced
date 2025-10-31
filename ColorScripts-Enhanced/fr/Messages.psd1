ConvertFrom-StringData @'
# ColorScripts-Enhanced Localized Messages
# Français (fr-FR)

# Error Messages
UnableToPrepareCacheDirectory = 'Impossible de préparer le répertoire de cache '
FailedToParseConfigurationFile = 'Échec de l''analyse du fichier de configuration à '
UnableToResolveCachePath = 'Impossible de résoudre le chemin du cache '
ConfiguredCachePathInvalid = 'Le chemin du cache configuré '
UnableToResolveOutputPath = 'Impossible de résoudre le chemin de sortie '
UnableToDetermineConfigurationDirectory = 'Impossible de déterminer le répertoire de configuration pour ColorScripts-Enhanced.'
ConfigurationRootCouldNotBeResolved = 'La racine de configuration n''a pas pu être résolue.'
UnableToResolveProfilePath = 'Impossible de résoudre le chemin du profil '
FailedToExecuteColorscript = 'Échec de l''exécution du colorscript '
FailedToBuildCacheForScript = 'Échec de la construction du cache pour $($selection.Name).'
CacheBuildFailedForScript = 'La construction du cache a échoué pour $($selection.Name): $($cacheResult.StdErr.Trim())'
ScriptAlreadyExists = 'Le script ''$targetPath'' existe déjà. Utilisez -Force pour écraser.'
ProfilePathNotDefinedForScope = 'Le chemin du profil pour la portée ''$Scope'' n''est pas défini.'
ScriptPathNotFound = 'Chemin du script introuvable.'
ScriptExitedWithCode = 'Le script s''est terminé avec le code {0}.'
CacheFileNotFound = 'Fichier de cache introuvable.'
NoChangesApplied = 'Aucune modification appliquée.'
UnableToRetrieveFileInfo = 'Impossible de récupérer les informations du fichier pour ''{0}'': {1}'
UnableToReadCacheInfo = 'Impossible de lire les informations du cache pour ''{0}'': {1}'

# Warning Messages
NoColorscriptsFoundMatchingCriteria = 'Aucun colorscript trouvé correspondant aux critères spécifiés.'
NoScriptsMatchedSpecifiedFilters = 'Aucun script ne correspond aux filtres spécifiés.'
NoColorscriptsAvailableWithFilters = 'Aucun colorscript disponible avec les filtres spécifiés.'
NoColorscriptsFoundInScriptsPath = 'Aucun colorscript trouvé dans $script:ScriptsPath'
NoScriptsSelectedForCacheBuild = 'Aucun script sélectionné pour la construction du cache.'
ScriptNotFound = 'Script introuvable: $pattern'
ColorscriptNotFoundWithFilters = 'Colorscript ''{0}'' introuvable avec les filtres spécifiés.'
CachePathNotFound = 'Chemin du cache introuvable: $targetRoot'
NoCacheFilesFound = 'Aucun fichier de cache trouvé à $targetRoot.'
ProfileUpdatesNotSupportedInRemote = 'Les mises à jour du profil ne sont pas prises en charge dans les sessions distantes.'
ScriptSkippedByFilter = 'Le script ''$skipped'' ne satisfait pas les filtres spécifiés et sera ignoré.'

# Status Messages
DisplayingColorscripts = '`nAffichage de $totalCount colorscripts...'
CacheBuildSummary = '`nRésumé de la construction du cache:'
FailedScripts = '`nScripts échoués:'
TotalScriptsProcessed = '`nTotal des scripts traités: $totalCount'
DisplayingContinuously = 'Affichage continu (Ctrl+C pour arrêter)`n'
FinishedDisplayingAll = 'Affichage terminé de tous les $totalCount colorscripts!'
Quitting = '`nQuitter...'
CurrentIndexOfTotal = '[$currentIndex/$totalCount] '
FailedScriptDetails = '  - $($failure.Name): $($failure.StdErr)'
MultipleColorscriptsMatched = 'Plusieurs colorscripts correspondent aux modèles de nom fournis: $($matchedNames -join '', ''). Affichage de ''$($orderedMatches[0].Name)''.'
StatusCached = 'Mis en cache'
StatusSkippedUpToDate = 'Ignoré (à jour)'
StatusSkippedByUser = 'Ignoré par l''utilisateur'
StatusFailed = 'Échoué'
StatusUpToDateSkipped = 'À jour (ignoré)'

# Interactive Messages
PressSpacebarToContinue = 'Appuyez sur [Espace] pour continuer au suivant, [Q] pour quitter`n'
PressSpacebarForNext = 'Appuyez sur [Espace] pour le suivant, [Q] pour quitter...'

# Success Messages
ProfileSnippetAdded = '[OK] Ajouté l''extrait de démarrage ColorScripts-Enhanced à $profilePath'
ProfileAlreadyContainsSnippet = 'Le profil contient déjà l''extrait ColorScripts-Enhanced.'
ProfileAlreadyImportsModule = 'Le profil importe déjà ColorScripts-Enhanced.'
ModuleLoadedSuccessfully = 'Module ColorScripts-Enhanced chargé avec succès.'
RemoteSessionDetected = 'Session distante détectée.'
ProfileAlreadyConfigured = 'Profil déjà configuré.'
ProfileSnippetAddedMessage = 'Extrait de profil ColorScripts-Enhanced ajouté.'

# Help/Instruction Messages
SpecifyNameToSelectScripts = 'Spécifiez -Name pour sélectionner les scripts lorsque -All est explicitement désactivé.'
SpecifyAllOrNameToClearCache = 'Spécifiez -All ou -Name pour effacer les entrées du cache.'
UsePassThruForDetailedResults = 'Utilisez -PassThru pour voir les résultats détaillés`n'

# UI Elements

# Miscellaneous
'@
