ConvertFrom-StringData @'
# ColorScripts-Enhanced Localized Messages
# Russian (ru) - Русский

# Error Messages
UnableToPrepareCacheDirectory = Не удалось подготовить каталог кэша '{0}': {1}
FailedToParseConfigurationFile = Не удалось разобрать файл конфигурации в '{0}': {1}. Используются значения по умолчанию.
UnableToResolveCachePath = Не удалось разрешить путь кэша '{0}'.
ConfiguredCachePathInvalid = Не удалось разрешить настроенный путь кэша '{0}'. Будут использованы расположения по умолчанию.
UnableToResolveOutputPath = Не удалось разрешить путь вывода '{0}'.
UnableToDetermineConfigurationDirectory = Не удалось определить каталог конфигурации для ColorScripts-Enhanced.
ConfigurationRootCouldNotBeResolved = Корень конфигурации не удалось разрешить.
UnableToResolveProfilePath = Не удалось разрешить путь профиля '{0}'.
FailedToExecuteColorscript = Не удалось выполнить colorscript '{0}': {1}
FailedToBuildCacheForScript = Не удалось создать кэш colorscript.
CacheBuildFailedForScript = Создать кэш для {0} не удалось: {1}
CacheBuildGenericFailure = Создание кэша не удалось.
CacheOperationWarning = Не удалось закэшировать '{0}': {1}
CacheOperationInitializationFailed = Не удалось инициализировать каталог кэша: {0}
ScriptAlreadyExists = Скрипт '{0}' уже существует. Используйте -Force для перезаписи.
ProfilePathNotDefinedForScope = Путь профиля для области '{0}' не определен.
ScriptPathNotFound = Путь скрипта не найден.
ScriptExitedWithCode = Скрипт завершился с кодом {0}.
CacheFileNotFound = Файл кэша не найден.
NoChangesApplied = Изменения не применены.
UnableToRetrieveFileInfo = Не удалось получить информацию о файле '{0}': {1}
UnableToReadCacheInfo = Не удалось прочитать информацию о кэше для '{0}': {1}
ProfileSnippetWriteFailed = Не удалось записать фрагмент профиля ColorScripts-Enhanced в '{0}': {1}
UnableToWriteColorScriptFile = Не удалось записать файл colorscript '{0}': {1}
InvalidScriptNameEmpty = Имя colorscript не может быть пустым или состоять только из пробелов.
InvalidScriptNameCharacters = Имя colorscript '{0}' содержит недопустимые символы.
InvalidPathValueEmpty = Путь не может быть пустым или состоять только из пробелов.
InvalidPathValueCharacters = Путь '{0}' содержит недопустимые символы.

# Warning Messages
NoColorscriptsFoundMatchingCriteria = Не найдено colorscripts, соответствующих указанным критериям.
NoScriptsMatchedSpecifiedFilters = Ни один скрипт не соответствует указанным фильтрам.
NoColorscriptsAvailableWithFilters = Нет доступных colorscripts с указанными фильтрами.
NoColorscriptsFoundInScriptsPath = Colorscripts не найдены в пути скриптов '{0}'.
NoScriptsSelectedForCacheBuild = Ни один скрипт не выбран для создания кэша.
ScriptNotFound = Скрипт не найден: {0}
ColorscriptNotFoundWithFilters = 'Colorscript '{0}' не найден с указанными фильтрами.'
CachePathNotFound = Путь кэша не найден: {0}
NoCacheFilesFound = Файлы кэша не найдены в {0}.
ProfileUpdatesNotSupportedInRemote = Обновления профиля не поддерживаются в удаленных сессиях.
ScriptSkippedByFilter = Скрипт '{0}' не удовлетворяет указанным фильтрам и будет пропущен.
ParallelCacheNotSupported = Параллельное создание кэша требует PowerShell 7 или более поздней версии. Будет использовано последовательное выполнение.

# Status Messages
DisplayingColorscripts = `nОтображение {0} colorscripts...
CacheBuildSummary = `nСводка создания кэша:
FailedScripts = `nНеудачные скрипты:
TotalScriptsProcessed = `nВсего обработано скриптов: {0}
DisplayingContinuously = Отображение непрерывно (Ctrl+C для остановки)`n
FinishedDisplayingAll = Завершено отображение всех {0} colorscripts!
Quitting = `nВыход...
CurrentIndexOfTotal = [{0}/{1}]
FailedScriptDetails =   - {0}: {1}
MultipleColorscriptsMatched = Несколько colorscripts соответствуют указанным шаблонам имени: {0}. Отображается '{1}'.
StatusCached = Кэшировано
StatusSkippedUpToDate = Пропущено (актуально)
StatusSkippedNotRequired = Пропущено (кэширование не требуется)
StatusSkippedByUser = Пропущено пользователем
StatusFailed = Не удалось
StatusUpToDateSkipped = Актуально (пропущено)
CacheBuildSummaryFormat = Итоги создания кэша: обработано {0}, обновлено {1}, пропущено {2}, с ошибками {3}
CacheDirectoryFormat = Каталог кэша: {0}
CacheClearSummaryFormat = Итоги очистки кэша: удалено {0}, отсутствует {1}, пропущено {2}, пробный запуск {3}, ошибок {4}

# Interactive Messages
PressSpacebarToContinue = Нажмите [Пробел] для продолжения к следующему, [Q] для выхода`n
PressSpacebarForNext = Нажмите [Пробел] для следующего, [Q] для выхода...

# Success Messages
ProfileSnippetAdded = [OK] Добавлен фрагмент запуска ColorScripts-Enhanced в {0}
ProfileAlreadyContainsSnippet = Профиль уже содержит фрагмент ColorScripts-Enhanced.
ProfileAlreadyImportsModule = Профиль уже импортирует ColorScripts-Enhanced.
ModuleLoadedSuccessfully = Модуль ColorScripts-Enhanced успешно загружен.
RemoteSessionDetected = Обнаружена удаленная сессия.
ProfileAlreadyConfigured = Профиль уже настроен.
ProfileSnippetAddedMessage = Фрагмент профиля ColorScripts-Enhanced добавлен.
UnableToOpenEditorForPath = Не удалось открыть редактор для '{0}': {1}

# Help/Instruction Messages
SpecifyNameToSelectScripts = Укажите -Name для выбора скриптов, когда -All явно отключен.
SpecifyAllOrNameToClearCache = Укажите -All или -Name для очистки записей кэша.
UsePassThruForDetailedResults = Используйте -PassThru для просмотра подробных результатов`n

# UI Elements

# Miscellaneous
'@
