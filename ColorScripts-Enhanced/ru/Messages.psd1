ConvertFrom-StringData @'
# ColorScripts-Enhanced Localized Messages
# Russian (ru) - Русский

# Error Messages
UnableToPrepareCacheDirectory = 'Не удалось подготовить каталог кэша '
FailedToParseConfigurationFile = 'Не удалось разобрать файл конфигурации в '
UnableToResolveCachePath = 'Не удалось разрешить путь кэша '
ConfiguredCachePathInvalid = 'Настроенный путь кэша '
UnableToResolveOutputPath = 'Не удалось разрешить выходной путь '
UnableToDetermineConfigurationDirectory = 'Не удалось определить каталог конфигурации для ColorScripts-Enhanced.'
ConfigurationRootCouldNotBeResolved = 'Корень конфигурации не удалось разрешить.'
UnableToResolveProfilePath = 'Не удалось разрешить путь профиля '
FailedToExecuteColorscript = 'Не удалось выполнить colorscript '
FailedToBuildCacheForScript = 'Не удалось создать кэш для $($selection.Name).'
CacheBuildFailedForScript = 'Создание кэша не удалось для $($selection.Name): $($cacheResult.StdErr.Trim())'
ScriptAlreadyExists = 'Скрипт ''$targetPath'' уже существует. Используйте -Force для перезаписи.'
ProfilePathNotDefinedForScope = 'Путь профиля для области ''$Scope'' не определен.'
ScriptPathNotFound = 'Путь скрипта не найден.'
ScriptExitedWithCode = 'Скрипт завершился с кодом {0}.'
CacheFileNotFound = 'Файл кэша не найден.'
NoChangesApplied = 'Изменения не применены.'
UnableToRetrieveFileInfo = 'Не удалось получить информацию о файле ''{0}'': {1}'
UnableToReadCacheInfo = 'Не удалось прочитать информацию о кэше для ''{0}'': {1}'

# Warning Messages
NoColorscriptsFoundMatchingCriteria = 'Не найдено colorscripts, соответствующих указанным критериям.'
NoScriptsMatchedSpecifiedFilters = 'Ни один скрипт не соответствует указанным фильтрам.'
NoColorscriptsAvailableWithFilters = 'Нет доступных colorscripts с указанными фильтрами.'
NoColorscriptsFoundInScriptsPath = 'Colorscripts не найдены в $script:ScriptsPath'
NoScriptsSelectedForCacheBuild = 'Ни один скрипт не выбран для создания кэша.'
ScriptNotFound = 'Скрипт не найден: $pattern'
ColorscriptNotFoundWithFilters = 'Colorscript ''{0}'' не найден с указанными фильтрами.'
CachePathNotFound = 'Путь кэша не найден: $targetRoot'
NoCacheFilesFound = 'Файлы кэша не найдены в $targetRoot.'
ProfileUpdatesNotSupportedInRemote = 'Обновления профиля не поддерживаются в удаленных сессиях.'
ScriptSkippedByFilter = 'Скрипт ''$skipped'' не удовлетворяет указанным фильтрам и будет пропущен.'

# Status Messages
DisplayingColorscripts = '`nОтображение $totalCount colorscripts...'
CacheBuildSummary = '`nСводка создания кэша:'
FailedScripts = '`nНеудачные скрипты:'
TotalScriptsProcessed = '`nВсего обработано скриптов: $totalCount'
DisplayingContinuously = 'Отображение непрерывно (Ctrl+C для остановки)`n'
FinishedDisplayingAll = 'Завершено отображение всех $totalCount colorscripts!'
Quitting = '`nВыход...'
CurrentIndexOfTotal = '[$currentIndex/$totalCount] '
FailedScriptDetails = '  - $($failure.Name): $($failure.StdErr)'
MultipleColorscriptsMatched = 'Несколько colorscripts соответствуют предоставленному шаблону имени: $($matchedNames -join '', ''). Отображение ''$($orderedMatches[0].Name)''.'
StatusCached = 'Кэшировано'
StatusSkippedUpToDate = 'Пропущено (актуально)'
StatusSkippedByUser = 'Пропущено пользователем'
StatusFailed = 'Не удалось'
StatusUpToDateSkipped = 'Актуально (пропущено)'

# Interactive Messages
PressSpacebarToContinue = 'Нажмите [Пробел] для продолжения к следующему, [Q] для выхода`n'
PressSpacebarForNext = 'Нажмите [Пробел] для следующего, [Q] для выхода...'

# Success Messages
ProfileSnippetAdded = '[OK] Добавлен фрагмент запуска ColorScripts-Enhanced в $profilePath'
ProfileAlreadyContainsSnippet = 'Профиль уже содержит фрагмент ColorScripts-Enhanced.'
ProfileAlreadyImportsModule = 'Профиль уже импортирует ColorScripts-Enhanced.'
ModuleLoadedSuccessfully = 'Модуль ColorScripts-Enhanced успешно загружен.'
RemoteSessionDetected = 'Обнаружена удаленная сессия.'
ProfileAlreadyConfigured = 'Профиль уже настроен.'
ProfileSnippetAddedMessage = 'Фрагмент профиля ColorScripts-Enhanced добавлен.'

# Help/Instruction Messages
SpecifyNameToSelectScripts = 'Укажите -Name для выбора скриптов, когда -All явно отключен.'
SpecifyAllOrNameToClearCache = 'Укажите -All или -Name для очистки записей кэша.'
UsePassThruForDetailedResults = 'Используйте -PassThru для просмотра подробных результатов`n'

# UI Elements

# Miscellaneous
'@
