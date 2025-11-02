ConvertFrom-StringData @'
# ColorScripts-Enhanced Localized Messages
# Spanish (es)

# Mensajes de Error
UnableToPrepareCacheDirectory = No se pudo preparar el directorio de caché
FailedToParseConfigurationFile = Error al analizar el archivo de configuración en '{0}': {1}. Usando valores predeterminados.
UnableToResolveCachePath = Unable to resolve cache path '{0}'.
ConfiguredCachePathInvalid = La ruta de caché configurada
UnableToResolveOutputPath = Unable to resolve output path '{0}'.
UnableToDetermineConfigurationDirectory = No se pudo determinar el directorio de configuración para ColorScripts-Enhanced.
ConfigurationRootCouldNotBeResolved = No se pudo resolver la raíz de configuración.
UnableToResolveProfilePath = Unable to resolve profile path '{0}'.
FailedToExecuteColorscript = Error al ejecutar el colorscript
FailedToBuildCacheForScript = Error al construir caché para $($selection.Name).
CacheBuildFailedForScript = Error al construir caché para $($selection.Name): $($cacheResult.StdErr.Trim())
ScriptAlreadyExists = El script ''$targetPath'' ya existe. Use -Force para sobrescribir.
ProfilePathNotDefinedForScope = 'La ruta de perfil para el alcance ''$Scope'' no está definida.'
ScriptPathNotFound = Ruta del script no encontrada.
ScriptExitedWithCode = El script terminó con código {0}.
CacheFileNotFound = Archivo de caché no encontrado.
NoChangesApplied = No se aplicaron cambios.
UnableToRetrieveFileInfo = No se pudo recuperar información del archivo para ''{0}'': {1}
UnableToReadCacheInfo = No se pudo leer información de caché para ''{0}'': {1}

# Mensajes de Advertencia
NoColorscriptsFoundMatchingCriteria = No se encontraron colorscripts que coincidan con los criterios especificados.
NoScriptsMatchedSpecifiedFilters = Ningún script coincide con los filtros especificados.
NoColorscriptsAvailableWithFilters = No hay colorscripts disponibles con los filtros especificados.
NoColorscriptsFoundInScriptsPath = No se encontraron colorscripts en $script:ScriptsPath
NoScriptsSelectedForCacheBuild = No se seleccionaron scripts para la construcción de caché.
ScriptNotFound = Script no encontrado: $pattern
ColorscriptNotFoundWithFilters = 'Colorscript ''{0}'' no encontrado con los filtros especificados.'
CachePathNotFound = Ruta de caché no encontrada: $targetRoot
NoCacheFilesFound = No se encontraron archivos de caché en $targetRoot.
ProfileUpdatesNotSupportedInRemote = Las actualizaciones de perfil no son compatibles en sesiones remotas.
ScriptSkippedByFilter = 'El script ''$skipped'' no satisface los filtros especificados y será omitido.'

# Mensajes de Estado
DisplayingColorscripts = `nMostrando $totalCount colorscripts...
CacheBuildSummary = `nResumen de Construcción de Caché:
FailedScripts = `nScripts fallidos:
TotalScriptsProcessed = `nScripts procesados totales: $totalCount
DisplayingContinuously = Mostrando continuamente (Ctrl+C para detener)`n
FinishedDisplayingAll = ¡Terminado de mostrar todos los $totalCount colorscripts!
Quitting = `nSaliendo...
CurrentIndexOfTotal = [$currentIndex/$totalCount]
FailedScriptDetails =   - $($failure.Name): $($failure.StdErr)
MultipleColorscriptsMatched = Múltiples colorscripts coinciden con los patrones de nombre proporcionados: $($matchedNames -join '', ''). Mostrando ''$($orderedMatches[0].Name)''.
StatusCached = En caché
StatusSkippedUpToDate = Omitido (actualizado)
StatusSkippedByUser = Omitido por usuario
StatusFailed = Fallido
StatusUpToDateSkipped = Actualizado (omitido)

# Mensajes Interactivos
PressSpacebarToContinue = Presione [Barra espaciadora] para continuar al siguiente, [Q] para salir`n
PressSpacebarForNext = Presione [Barra espaciadora] para siguiente, [Q] para salir...

# Mensajes de Éxito
ProfileSnippetAdded = [OK] Fragmento de inicio de ColorScripts-Enhanced agregado a $profilePath
ProfileAlreadyContainsSnippet = El perfil ya contiene el fragmento de ColorScripts-Enhanced.
ProfileAlreadyImportsModule = El perfil ya importa ColorScripts-Enhanced.
ModuleLoadedSuccessfully = Módulo ColorScripts-Enhanced cargado exitosamente.
RemoteSessionDetected = Sesión remota detectada.
ProfileAlreadyConfigured = Perfil ya configurado.
ProfileSnippetAddedMessage = Fragmento de perfil de ColorScripts-Enhanced agregado.

# Mensajes de Ayuda/Instrucción
SpecifyNameToSelectScripts = Especifique -Name para seleccionar scripts cuando -All está explícitamente deshabilitado.
SpecifyAllOrNameToClearCache = Especifique -All o -Name para limpiar entradas de caché.
UsePassThruForDetailedResults = Use -PassThru para ver resultados detallados`n

# Elementos de UI

# Misceláneo
'@
