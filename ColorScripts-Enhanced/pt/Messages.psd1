ConvertFrom-StringData @'
# ColorScripts-Enhanced Localized Messages
# Portuguese (pt) - Português

# Error Messages
UnableToPrepareCacheDirectory = Não foi possível preparar o diretório de cache 
FailedToParseConfigurationFile = Falha ao analisar o arquivo de configuração em '{0}': {1}. Usando padrões.
UnableToResolveCachePath = Unable to resolve cache path '{0}'.
ConfiguredCachePathInvalid = Caminho de cache configurado 
UnableToResolveOutputPath = Unable to resolve output path '{0}'.
UnableToDetermineConfigurationDirectory = Não foi possível determinar o diretório de configuração para ColorScripts-Enhanced.
ConfigurationRootCouldNotBeResolved = A raiz da configuração não pôde ser resolvida.
UnableToResolveProfilePath = Unable to resolve profile path '{0}'.
FailedToExecuteColorscript = Falha ao executar o colorscript 
FailedToBuildCacheForScript = Falha ao criar cache para $($selection.Name).
CacheBuildFailedForScript = Criação de cache falhou para $($selection.Name): $($cacheResult.StdErr.Trim())
ScriptAlreadyExists = Script ''$targetPath'' já existe. Use -Force para sobrescrever.
ProfilePathNotDefinedForScope = 'Caminho do perfil para o escopo ''$Scope'' não está definido.'
ScriptPathNotFound = Caminho do script não encontrado.
ScriptExitedWithCode = Script terminou com código {0}.
CacheFileNotFound = Arquivo de cache não encontrado.
NoChangesApplied = Nenhuma alteração aplicada.
UnableToRetrieveFileInfo = Não foi possível recuperar informações do arquivo ''{0}'': {1}
UnableToReadCacheInfo = Não foi possível ler informações do cache para ''{0}'': {1}

# Warning Messages
NoColorscriptsFoundMatchingCriteria = Nenhum colorscript encontrado correspondendo aos critérios especificados.
NoScriptsMatchedSpecifiedFilters = Nenhum script correspondeu aos filtros especificados.
NoColorscriptsAvailableWithFilters = Nenhum colorscript disponível com os filtros especificados.
NoColorscriptsFoundInScriptsPath = Nenhum colorscript encontrado em $script:ScriptsPath
NoScriptsSelectedForCacheBuild = Nenhum script selecionado para criação de cache.
ScriptNotFound = Script não encontrado: $pattern
ColorscriptNotFoundWithFilters = 'Colorscript ''{0}'' não encontrado com os filtros especificados.'
CachePathNotFound = Caminho do cache não encontrado: $targetRoot
NoCacheFilesFound = Nenhum arquivo de cache encontrado em $targetRoot.
ProfileUpdatesNotSupportedInRemote = Atualizações de perfil não são suportadas em sessões remotas.
ScriptSkippedByFilter = 'Script ''$skipped'' não satisfaz os filtros especificados e será ignorado.'

# Status Messages
DisplayingColorscripts = `nExibindo $totalCount colorscripts...
CacheBuildSummary = `nResumo da Criação de Cache:
FailedScripts = `nScripts com falha:
TotalScriptsProcessed = `nTotal de scripts processados: $totalCount
DisplayingContinuously = Exibindo continuamente (Ctrl+C para parar)`n
FinishedDisplayingAll = Terminou de exibir todos os $totalCount colorscripts!
Quitting = `nSaindo...
CurrentIndexOfTotal = [$currentIndex/$totalCount] 
FailedScriptDetails =   - $($failure.Name): $($failure.StdErr)
MultipleColorscriptsMatched = Múltiplos colorscripts corresponderam ao padrão de nome fornecido: $($matchedNames -join '', ''). Exibindo ''$($orderedMatches[0].Name)''.
StatusCached = Em cache
StatusSkippedUpToDate = Ignorado (atualizado)
StatusSkippedByUser = Ignorado pelo usuário
StatusFailed = Falhou
StatusUpToDateSkipped = Atualizado (ignorado)

# Interactive Messages
PressSpacebarToContinue = Pressione [Espaço] para continuar para o próximo, [Q] para sair`n
PressSpacebarForNext = Pressione [Espaço] para próximo, [Q] para sair...

# Success Messages
ProfileSnippetAdded = [OK] Adicionado snippet de inicialização ColorScripts-Enhanced ao $profilePath
ProfileAlreadyContainsSnippet = Perfil já contém snippet ColorScripts-Enhanced.
ProfileAlreadyImportsModule = Perfil já importa ColorScripts-Enhanced.
ModuleLoadedSuccessfully = Módulo ColorScripts-Enhanced carregado com sucesso.
RemoteSessionDetected = Sessão remota detectada.
ProfileAlreadyConfigured = Perfil já configurado.
ProfileSnippetAddedMessage = Snippet de perfil ColorScripts-Enhanced adicionado.

# Help/Instruction Messages
SpecifyNameToSelectScripts = Especifique -Name para selecionar scripts quando -All estiver explicitamente desabilitado.
SpecifyAllOrNameToClearCache = Especifique -All ou -Name para limpar entradas de cache.
UsePassThruForDetailedResults = Use -PassThru para ver resultados detalhados`n

# UI Elements

# Miscellaneous
'@
