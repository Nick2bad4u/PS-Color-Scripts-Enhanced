ConvertFrom-StringData @'
# ColorScripts-Enhanced Localized Messages
# Spanish (es)

# Mensajes de Error
UnableToPrepareCacheDirectory = No se pudo preparar el directorio de caché '{0}': {1}
FailedToParseConfigurationFile = Error al analizar el archivo de configuración en '{0}': {1}. Usando valores predeterminados.
UnableToResolveCachePath = No se pudo resolver la ruta de caché '{0}'.
ConfiguredCachePathInvalid = No se pudo resolver la ruta de caché configurada '{0}'. Se usarán las ubicaciones predeterminadas.
UnableToResolveOutputPath = No se pudo resolver la ruta de salida '{0}'.
UnableToDetermineConfigurationDirectory = No se pudo determinar el directorio de configuración para ColorScripts-Enhanced.
ConfigurationRootCouldNotBeResolved = No se pudo resolver la raíz de configuración.
UnableToResolveProfilePath = No se pudo resolver la ruta del perfil '{0}'.
FailedToExecuteColorscript = No se pudo ejecutar el colorscript '{0}': {1}
FailedToBuildCacheForScript = No se pudo crear la caché de colorscripts.
CacheBuildFailedForScript = Error al construir caché para {0}: {1}
CacheBuildGenericFailure = Error al construir el caché.
CacheOperationWarning = Error al almacenar en caché '{0}': {1}
CacheOperationInitializationFailed = No se pudo inicializar el directorio de caché: {0}
ScriptAlreadyExists = El script '{0}' ya existe. Use -Force para sobrescribirlo.
ProfilePathNotDefinedForScope = La ruta del perfil para el ámbito '{0}' no está definida.
ScriptPathNotFound = Ruta del script no encontrada.
ScriptExitedWithCode = El script terminó con código {0}.
CacheFileNotFound = Archivo de caché no encontrado.
NoChangesApplied = No se aplicaron cambios.
UnableToRetrieveFileInfo = No se pudo recuperar información del archivo para '{0}': {1}
UnableToReadCacheInfo = No se pudo leer información de caché para '{0}': {1}
ProfileSnippetWriteFailed = No se pudo escribir el fragmento de perfil de ColorScripts-Enhanced en '{0}': {1}
UnableToWriteColorScriptFile = No se pudo escribir el archivo de colorscript '{0}': {1}
InvalidScriptNameEmpty = El nombre del colorscript no puede estar vacío ni contener solo espacios.
InvalidScriptNameCharacters = El nombre del colorscript '{0}' contiene caracteres no válidos.
InvalidPathValueEmpty = La ruta no puede estar vacía ni contener solo espacios.
InvalidPathValueCharacters = La ruta '{0}' contiene caracteres no válidos.

# Mensajes de Advertencia
NoColorscriptsFoundMatchingCriteria = No se encontraron colorscripts que coincidan con los criterios especificados.
NoScriptsMatchedSpecifiedFilters = Ningún script coincide con los filtros especificados.
NoColorscriptsAvailableWithFilters = No hay colorscripts disponibles con los filtros especificados.
NoColorscriptsFoundInScriptsPath = No se encontraron colorscripts en la ruta de scripts '{0}'.
NoScriptsSelectedForCacheBuild = No se seleccionaron scripts para la construcción de caché.
ScriptNotFound = Script no encontrado: {0}
ColorscriptNotFoundWithFilters = 'Colorscript '{0}' no encontrado con los filtros especificados.'
CachePathNotFound = Ruta de caché no encontrada: {0}
NoCacheFilesFound = No se encontraron archivos de caché en {0}.
ProfileUpdatesNotSupportedInRemote = Las actualizaciones de perfil no son compatibles en sesiones remotas.
ScriptSkippedByFilter = El script '{0}' no satisface los filtros especificados y se omitirá.
ParallelCacheNotSupported = La creación de caché en paralelo requiere PowerShell 7 o posterior. Se usará la ejecución secuencial.

# Mensajes de Estado
DisplayingColorscripts = `nMostrando {0} colorscripts...
CacheBuildSummary = `nResumen de Construcción de Caché:
FailedScripts = `nScripts fallidos:
TotalScriptsProcessed = `nTotal de scripts procesados: {0}
DisplayingContinuously = Mostrando continuamente (Ctrl+C para detener)`n
FinishedDisplayingAll = Se terminaron de mostrar los {0} colorscripts.
Quitting = `nSaliendo...
CurrentIndexOfTotal = [{0}/{1}]
FailedScriptDetails =   - {0}: {1}
MultipleColorscriptsMatched = Varios colorscripts coinciden con los patrones de nombre indicados: {0}. Se mostrará '{1}'.
StatusCached = En caché
StatusSkippedUpToDate = Omitido (actualizado)
StatusSkippedNotRequired = Omitido (no requiere caché)
StatusSkippedByUser = Omitido por usuario
StatusFailed = Fallido
StatusUpToDateSkipped = Actualizado (omitido)
CacheBuildSummaryFormat = Resumen de creación de caché: procesados {0}, actualizados {1}, omitidos {2}, con errores {3}
CacheDirectoryFormat = Directorio de caché: {0}
CacheClearSummaryFormat = Resumen de limpieza de caché: eliminados {0}, ausentes {1}, omitidos {2}, simulados {3}, errores {4}

# Mensajes Interactivos
PressSpacebarToContinue = Presione [Barra espaciadora] para continuar al siguiente, [Q] para salir`n
PressSpacebarForNext = Presione [Barra espaciadora] para siguiente, [Q] para salir...

# Mensajes de Éxito
ProfileSnippetAdded = [OK] Fragmento de inicio de ColorScripts-Enhanced agregado a {0}
ProfileAlreadyContainsSnippet = El perfil ya contiene el fragmento de ColorScripts-Enhanced.
ProfileAlreadyImportsModule = El perfil ya importa ColorScripts-Enhanced.
ModuleLoadedSuccessfully = Módulo ColorScripts-Enhanced cargado exitosamente.
RemoteSessionDetected = Sesión remota detectada.
ProfileAlreadyConfigured = Perfil ya configurado.
ProfileSnippetAddedMessage = Fragmento de perfil de ColorScripts-Enhanced agregado.
UnableToOpenEditorForPath = No se pudo abrir el editor para '{0}': {1}

# Mensajes de Ayuda/Instrucción
SpecifyNameToSelectScripts = Especifique -Name para seleccionar scripts cuando -All está explícitamente deshabilitado.
SpecifyAllOrNameToClearCache = Especifique -All o -Name para limpiar entradas de caché.
UsePassThruForDetailedResults = Use -PassThru para ver resultados detallados`n

# Elementos de UI

# Misceláneo
'@
