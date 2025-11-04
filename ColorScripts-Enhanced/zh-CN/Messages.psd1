ConvertFrom-StringData @'
# ColorScripts-Enhanced Localized Messages
# Chinese (zh-CN) - 中文（简体）

# Error Messages
UnableToPrepareCacheDirectory = 无法准备缓存目录
FailedToParseConfigurationFile = 在 '{0}' 解析配置文件失败: {1}。使用默认值。
UnableToResolveCachePath = Unable to resolve cache path '{0}'.
ConfiguredCachePathInvalid = 配置的缓存路径
UnableToResolveOutputPath = Unable to resolve output path '{0}'.
UnableToDetermineConfigurationDirectory = 无法确定 ColorScripts-Enhanced 的配置目录。
ConfigurationRootCouldNotBeResolved = 配置根目录无法解析。
UnableToResolveProfilePath = Unable to resolve profile path '{0}'.
FailedToExecuteColorscript = 无法执行 colorscript
FailedToBuildCacheForScript = 无法为 $($selection.Name) 构建缓存。
CacheBuildFailedForScript = 为 $($selection.Name) 构建缓存失败：$($cacheResult.StdErr.Trim())
ScriptAlreadyExists = 脚本 ''$targetPath'' 已存在。使用 -Force 覆盖。
ProfilePathNotDefinedForScope = '作用域 ''$Scope'' 的配置文件路径未定义。'
ScriptPathNotFound = 未找到脚本路径。
ScriptExitedWithCode = 脚本以代码 {0} 退出。
CacheFileNotFound = 未找到缓存文件。
NoChangesApplied = 未应用任何更改。
UnableToRetrieveFileInfo = 无法检索 ''{0}'' 的文件信息：{1}
UnableToReadCacheInfo = 无法读取 ''{0}'' 的缓存信息：{1}
InvalidScriptNameEmpty = Color script name cannot be empty or whitespace.
InvalidScriptNameCharacters = Color script name '{0}' contains invalid characters.
InvalidPathValueEmpty = Path value cannot be empty or whitespace.
InvalidPathValueCharacters = Path '{0}' contains invalid characters.

# Warning Messages
NoColorscriptsFoundMatchingCriteria = 未找到符合指定条件的 colorscripts。
NoScriptsMatchedSpecifiedFilters = 没有脚本符合指定的过滤器。
NoColorscriptsAvailableWithFilters = 使用指定的过滤器没有可用的 colorscripts。
NoColorscriptsFoundInScriptsPath = 在 $script:ScriptsPath 中未找到 colorscripts
NoScriptsSelectedForCacheBuild = 没有选择用于缓存构建的脚本。
ScriptNotFound = 未找到脚本：$pattern
ColorscriptNotFoundWithFilters = '使用指定的过滤器未找到 colorscript ''{0}''。'
CachePathNotFound = 未找到缓存路径：$targetRoot
NoCacheFilesFound = 在 $targetRoot 处未找到缓存文件。
ProfileUpdatesNotSupportedInRemote = 远程会话中不支持配置文件更新。
ScriptSkippedByFilter = '脚本 ''$skipped'' 不满足指定的过滤器，将被跳过。'

# Status Messages
DisplayingColorscripts = `n正在显示 $totalCount 个 colorscripts...
CacheBuildSummary = `n缓存构建摘要：
FailedScripts = `n失败的脚本：
TotalScriptsProcessed = `n总共处理的脚本：$totalCount
DisplayingContinuously = 连续显示（Ctrl+C 停止）`n
FinishedDisplayingAll = 已完成显示所有 $totalCount 个 colorscripts！
Quitting = `n正在退出...
CurrentIndexOfTotal = [$currentIndex/$totalCount]
FailedScriptDetails =   - $($failure.Name)：$($failure.StdErr)
MultipleColorscriptsMatched = 多个 colorscripts 与提供的名称模式匹配：$($matchedNames -join ''，'')。正在显示 ''$($orderedMatches[0].Name)''。
StatusCached = 已缓存
StatusSkippedUpToDate = 已跳过（最新）
StatusSkippedByUser = 用户跳过
StatusFailed = 失败
StatusUpToDateSkipped = 最新（已跳过）

# Interactive Messages
PressSpacebarToContinue = 按 [空格键] 继续下一个，[Q] 退出`n
PressSpacebarForNext = 按 [空格键] 下一个，[Q] 退出...

# Success Messages
ProfileSnippetAdded = [OK] 已将 ColorScripts-Enhanced 启动片段添加到 $profilePath
ProfileAlreadyContainsSnippet = 配置文件已包含 ColorScripts-Enhanced 片段。
ProfileAlreadyImportsModule = 配置文件已导入 ColorScripts-Enhanced。
ModuleLoadedSuccessfully = ColorScripts-Enhanced 模块已成功加载。
RemoteSessionDetected = 检测到远程会话。
ProfileAlreadyConfigured = 配置文件已配置。
ProfileSnippetAddedMessage = 已添加 ColorScripts-Enhanced 配置文件片段。

# Help/Instruction Messages
SpecifyNameToSelectScripts = 当明确禁用 -All 时，指定 -Name 来选择脚本。
SpecifyAllOrNameToClearCache = 指定 -All 或 -Name 来清除缓存条目。
UsePassThruForDetailedResults = 使用 -PassThru 查看详细结果`n

# UI Elements

# Miscellaneous
'@
