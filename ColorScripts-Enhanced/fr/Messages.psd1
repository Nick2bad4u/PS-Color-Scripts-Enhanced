ConvertFrom-StringData @'
# ColorScripts-Enhanced Localized Messages
# Français (fr-FR)

# Error Messages
UnableToPrepareCacheDirectory = Impossible de préparer le répertoire de cache '{0}' : {1}
FailedToParseConfigurationFile = Échec de l'analyse du fichier de configuration à '{0}': {1}. Utilisation des valeurs par défaut.
UnableToResolveCachePath = Impossible de résoudre le chemin du cache '{0}'.
ConfiguredCachePathInvalid = Impossible de résoudre le chemin du cache configuré '{0}'. Les emplacements par défaut seront utilisés.
UnableToResolveOutputPath = Impossible de résoudre le chemin de sortie '{0}'.
UnableToDetermineConfigurationDirectory = Impossible de déterminer le répertoire de configuration pour ColorScripts-Enhanced.
ConfigurationRootCouldNotBeResolved = 'La racine de configuration n'a pas pu être résolue.'
UnableToResolveProfilePath = Impossible de résoudre le chemin du profil '{0}'.
FailedToExecuteColorscript = Échec de l'exécution du colorscript '{0}': {1}
FailedToBuildCacheForScript = Impossible de créer le cache des colorscripts.
CacheBuildFailedForScript = La construction du cache a échoué pour {0} : {1}
CacheBuildGenericFailure = Échec de la construction du cache.
CacheOperationWarning = Échec de la mise en cache de '{0}' : {1}
CacheOperationInitializationFailed = Impossible d'initialiser le répertoire de cache : {0}
ScriptAlreadyExists = Le script '{0}' existe déjà. Utilisez -Force pour le remplacer.
ProfilePathNotDefinedForScope = Le chemin du profil pour l'étendue '{0}' n'est pas défini.
ScriptPathNotFound = Chemin du script introuvable.
ScriptExitedWithCode = 'Le script s'est terminé avec le code {0}.'
CacheFileNotFound = Fichier de cache introuvable.
NoChangesApplied = Aucune modification appliquée.
UnableToRetrieveFileInfo = Impossible de récupérer les informations du fichier pour '{0}': {1}
UnableToReadCacheInfo = Impossible de lire les informations du cache pour '{0}': {1}
ProfileSnippetWriteFailed = Impossible d'écrire l'extrait de profil ColorScripts-Enhanced vers '{0}' : {1}
UnableToWriteColorScriptFile = Impossible d'écrire le fichier colorscript '{0}' : {1}
InvalidScriptNameEmpty = Le nom du colorscript ne peut pas être vide ni composé uniquement d'espaces.
InvalidScriptNameCharacters = Le nom du colorscript '{0}' contient des caractères non valides.
InvalidPathValueEmpty = Le chemin ne peut pas être vide ni composé uniquement d'espaces.
InvalidPathValueCharacters = Le chemin '{0}' contient des caractères non valides.

# Warning Messages
NoColorscriptsFoundMatchingCriteria = Aucun colorscript trouvé correspondant aux critères spécifiés.
NoScriptsMatchedSpecifiedFilters = Aucun script ne correspond aux filtres spécifiés.
NoColorscriptsAvailableWithFilters = Aucun colorscript disponible avec les filtres spécifiés.
NoColorscriptsFoundInScriptsPath = Aucun colorscript trouvé dans le chemin de scripts '{0}'.
NoScriptsSelectedForCacheBuild = Aucun script sélectionné pour la construction du cache.
ScriptNotFound = Script introuvable : {0}
ColorscriptNotFoundWithFilters = 'Colorscript '{0}' introuvable avec les filtres spécifiés.'
CachePathNotFound = Chemin du cache introuvable : {0}
NoCacheFilesFound = Aucun fichier de cache trouvé dans {0}.
ProfileUpdatesNotSupportedInRemote = Les mises à jour du profil ne sont pas prises en charge dans les sessions distantes.
ScriptSkippedByFilter = Le script '{0}' ne satisfait pas les filtres spécifiés et sera ignoré.
ParallelCacheNotSupported = La création du cache en parallèle nécessite PowerShell 7 ou version ultérieure. L'exécution séquentielle sera utilisée.

# Status Messages
DisplayingColorscripts = `nAffichage de {0} colorscripts...
CacheBuildSummary = `nRésumé de la construction du cache:
FailedScripts = `nScripts échoués:
TotalScriptsProcessed = `nNombre total de scripts traités : {0}
DisplayingContinuously = Affichage continu (Ctrl+C pour arrêter)`n
FinishedDisplayingAll = Affichage des {0} colorscripts terminé !
Quitting = `nQuitter...
CurrentIndexOfTotal = [{0}/{1}]
FailedScriptDetails =   - {0} : {1}
MultipleColorscriptsMatched = Plusieurs colorscripts correspondent aux modèles de nom fournis : {0}. Affichage de '{1}'.
StatusCached = Mis en cache
StatusSkippedUpToDate = Ignoré (à jour)
StatusSkippedNotRequired = Ignoré (mise en cache inutile)
StatusSkippedByUser = 'Ignoré par l'utilisateur'
StatusFailed = Échoué
StatusUpToDateSkipped = À jour (ignoré)
CacheBuildSummaryFormat = Résumé de la création du cache : traités {0}, mis à jour {1}, ignorés {2}, en échec {3}
CacheDirectoryFormat = Répertoire du cache : {0}
CacheClearSummaryFormat = Résumé du nettoyage du cache : supprimés {0}, absents {1}, ignorés {2}, simulation {3}, erreurs {4}

# Interactive Messages
PressSpacebarToContinue = Appuyez sur [Espace] pour continuer au suivant, [Q] pour quitter`n
PressSpacebarForNext = Appuyez sur [Espace] pour le suivant, [Q] pour quitter...

# Success Messages
ProfileSnippetAdded = '[OK] Ajouté l'extrait de démarrage ColorScripts-Enhanced à {0}'
ProfileAlreadyContainsSnippet = 'Le profil contient déjà l'extrait ColorScripts-Enhanced.'
ProfileAlreadyImportsModule = Le profil importe déjà ColorScripts-Enhanced.
ModuleLoadedSuccessfully = Module ColorScripts-Enhanced chargé avec succès.
RemoteSessionDetected = Session distante détectée.
ProfileAlreadyConfigured = Profil déjà configuré.
ProfileSnippetAddedMessage = Extrait de profil ColorScripts-Enhanced ajouté.
UnableToOpenEditorForPath = Impossible d'ouvrir l'éditeur pour '{0}' : {1}

# Help/Instruction Messages
SpecifyNameToSelectScripts = Spécifiez -Name pour sélectionner les scripts lorsque -All est explicitement désactivé.
SpecifyAllOrNameToClearCache = Spécifiez -All ou -Name pour effacer les entrées du cache.
UsePassThruForDetailedResults = Utilisez -PassThru pour voir les résultats détaillés`n

# UI Elements

# Miscellaneous
'@
