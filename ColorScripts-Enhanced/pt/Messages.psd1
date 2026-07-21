ConvertFrom-StringData @'
# ColorScripts-Enhanced Localized Messages
# Portuguese (pt) - Português

# Error Messages
UnableToPrepareCacheDirectory = Não foi possível preparar o diretório de cache '{0}': {1}
FailedToParseConfigurationFile = Falha ao analisar o arquivo de configuração em '{0}': {1}. Usando padrões.
UnableToResolveCachePath = Não foi possível resolver o caminho do cache '{0}'.
ConfiguredCachePathInvalid = Não foi possível resolver o caminho de cache configurado '{0}'. Os locais padrão serão usados.
UnableToResolveOutputPath = Não foi possível resolver o caminho de saída '{0}'.
UnableToDetermineConfigurationDirectory = Não foi possível determinar o diretório de configuração para ColorScripts-Enhanced.
ConfigurationRootCouldNotBeResolved = A raiz da configuração não pôde ser resolvida.
UnableToResolveProfilePath = Não foi possível resolver o caminho do perfil '{0}'.
FailedToExecuteColorscript = Falha ao executar o colorscript '{0}': {1}
FailedToBuildCacheForScript = Falha ao criar o cache de colorscripts.
CacheBuildFailedForScript = Criação de cache falhou para {0}: {1}
CacheBuildGenericFailure = Falha na criação do cache.
CacheOperationWarning = Falha ao armazenar em cache '{0}': {1}
CacheOperationInitializationFailed = Não foi possível inicializar o diretório de cache: {0}
ScriptAlreadyExists = O script '{0}' já existe. Use -Force para sobrescrevê-lo.
ProfilePathNotDefinedForScope = O caminho do perfil para o escopo '{0}' não está definido.
ScriptPathNotFound = Caminho do script não encontrado.
ScriptExitedWithCode = Script terminou com código {0}.
CacheFileNotFound = Arquivo de cache não encontrado.
NoChangesApplied = Nenhuma alteração aplicada.
UnableToRetrieveFileInfo = Não foi possível recuperar informações do arquivo '{0}': {1}
UnableToReadCacheInfo = Não foi possível ler informações do cache para '{0}': {1}
ProfileSnippetWriteFailed = Não foi possível gravar o snippet de perfil ColorScripts-Enhanced em '{0}': {1}
UnableToWriteColorScriptFile = Não foi possível gravar o arquivo de colorscript '{0}': {1}
InvalidScriptNameEmpty = O nome do colorscript não pode estar vazio nem conter apenas espaços.
InvalidScriptNameCharacters = O nome do colorscript '{0}' contém caracteres inválidos.
InvalidPathValueEmpty = O caminho não pode estar vazio nem conter apenas espaços.
InvalidPathValueCharacters = O caminho '{0}' contém caracteres inválidos.

# Warning Messages
NoColorscriptsFoundMatchingCriteria = Nenhum colorscript encontrado correspondendo aos critérios especificados.
NoScriptsMatchedSpecifiedFilters = Nenhum script correspondeu aos filtros especificados.
NoColorscriptsAvailableWithFilters = Nenhum colorscript disponível com os filtros especificados.
NoColorscriptsFoundInScriptsPath = Nenhum colorscript encontrado no caminho de scripts '{0}'.
NoScriptsSelectedForCacheBuild = Nenhum script selecionado para criação de cache.
ScriptNotFound = Script não encontrado: {0}
ColorscriptNotFoundWithFilters = 'Colorscript '{0}' não encontrado com os filtros especificados.'
CachePathNotFound = Caminho do cache não encontrado: {0}
NoCacheFilesFound = Nenhum arquivo de cache encontrado em {0}.
ProfileUpdatesNotSupportedInRemote = Atualizações de perfil não são suportadas em sessões remotas.
ScriptSkippedByFilter = O script '{0}' não satisfaz os filtros especificados e será ignorado.
ParallelCacheNotSupported = A criação de cache em paralelo requer PowerShell 7 ou posterior. A execução sequencial será usada.

# Status Messages
DisplayingColorscripts = `nExibindo {0} colorscripts...
CacheBuildSummary = `nResumo da Criação de Cache:
FailedScripts = `nScripts com falha:
TotalScriptsProcessed = `nTotal de scripts processados: {0}
DisplayingContinuously = Exibindo continuamente (Ctrl+C para parar)`n
FinishedDisplayingAll = A exibição dos {0} colorscripts foi concluída!
Quitting = `nSaindo...
CurrentIndexOfTotal = [{0}/{1}]
FailedScriptDetails =   - {0}: {1}
MultipleColorscriptsMatched = Vários colorscripts corresponderam aos padrões de nome fornecidos: {0}. Exibindo '{1}'.
StatusCached = Em cache
StatusSkippedUpToDate = Ignorado (atualizado)
StatusSkippedNotRequired = Ignorado (cache desnecessário)
StatusSkippedByUser = Ignorado pelo usuário
StatusFailed = Falhou
StatusUpToDateSkipped = Atualizado (ignorado)
CacheBuildSummaryFormat = Resumo da criação do cache: processados {0}, atualizados {1}, ignorados {2}, falhas {3}
CacheDirectoryFormat = Diretório do cache: {0}
CacheClearSummaryFormat = Resumo da limpeza do cache: removidos {0}, ausentes {1}, ignorados {2}, simulação {3}, erros {4}

# Interactive Messages
PressSpacebarToContinue = Pressione [Espaço] para continuar para o próximo, [Q] para sair`n
PressSpacebarForNext = Pressione [Espaço] para próximo, [Q] para sair...

# Success Messages
ProfileSnippetAdded = [OK] Adicionado snippet de inicialização ColorScripts-Enhanced ao {0}
ProfileAlreadyContainsSnippet = Perfil já contém snippet ColorScripts-Enhanced.
ProfileAlreadyImportsModule = Perfil já importa ColorScripts-Enhanced.
ModuleLoadedSuccessfully = Módulo ColorScripts-Enhanced carregado com sucesso.
RemoteSessionDetected = Sessão remota detectada.
ProfileAlreadyConfigured = Perfil já configurado.
ProfileSnippetAddedMessage = Snippet de perfil ColorScripts-Enhanced adicionado.
UnableToOpenEditorForPath = Não foi possível abrir o editor para '{0}': {1}

# Help/Instruction Messages
SpecifyNameToSelectScripts = Especifique -Name para selecionar scripts quando -All estiver explicitamente desabilitado.
SpecifyAllOrNameToClearCache = Especifique -All ou -Name para limpar entradas de cache.
UsePassThruForDetailedResults = Use -PassThru para ver resultados detalhados`n

# UI Elements

# Miscellaneous
'@
