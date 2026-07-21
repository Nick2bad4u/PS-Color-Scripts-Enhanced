ConvertFrom-StringData @'
# ColorScripts-Enhanced Localized Messages
# Chinese (zh-CN) - 中文（简体）

# Error Messages
UnableToPrepareCacheDirectory = 无法准备缓存目录“{0}”：{1}
FailedToParseConfigurationFile = 在 '{0}' 解析配置文件失败: {1}。使用默认值。
UnableToResolveCachePath = 无法解析缓存路径“{0}”。
ConfiguredCachePathInvalid = 无法解析配置的缓存路径“{0}”。将使用默认位置。
UnableToResolveOutputPath = 无法解析输出路径“{0}”。
UnableToDetermineConfigurationDirectory = 无法确定 ColorScripts-Enhanced 的配置目录。
ConfigurationRootCouldNotBeResolved = 配置根目录无法解析。
UnableToResolveProfilePath = 无法解析配置文件路径“{0}”。
FailedToExecuteColorscript = 无法执行 colorscript“{0}”：{1}
FailedToBuildCacheForScript = 无法构建 colorscript 缓存。
CacheBuildFailedForScript = 为 {0} 构建缓存失败：{1}
CacheBuildGenericFailure = 缓存构建失败。
CacheOperationWarning = 缓存 '{0}' 时失败：{1}
CacheOperationInitializationFailed = 无法初始化缓存目录：{0}
ScriptAlreadyExists = 脚本“{0}”已存在。使用 -Force 覆盖。
ProfilePathNotDefinedForScope = 未定义作用域“{0}”的配置文件路径。
ScriptPathNotFound = 未找到脚本路径。
ScriptExitedWithCode = 脚本以代码 {0} 退出。
CacheFileNotFound = 未找到缓存文件。
NoChangesApplied = 未应用任何更改。
UnableToRetrieveFileInfo = 无法检索 '{0}' 的文件信息：{1}
UnableToReadCacheInfo = 无法读取 '{0}' 的缓存信息：{1}
ProfileSnippetWriteFailed = 无法将 ColorScripts-Enhanced 配置文件片段写入 '{0}'：{1}
UnableToWriteColorScriptFile = 无法写入 colorscript 文件 '{0}'：{1}
InvalidScriptNameEmpty = Colorscript 名称不能为空或只包含空白字符。
InvalidScriptNameCharacters = Colorscript 名称“{0}”包含无效字符。
InvalidPathValueEmpty = 路径不能为空或只包含空白字符。
InvalidPathValueCharacters = 路径“{0}”包含无效字符。

# Warning Messages
NoColorscriptsFoundMatchingCriteria = 未找到符合指定条件的 colorscripts。
NoScriptsMatchedSpecifiedFilters = 没有脚本符合指定的过滤器。
NoColorscriptsAvailableWithFilters = 使用指定的过滤器没有可用的 colorscripts。
NoColorscriptsFoundInScriptsPath = 在脚本路径“{0}”中未找到 colorscripts。
NoScriptsSelectedForCacheBuild = 没有选择用于缓存构建的脚本。
ScriptNotFound = 未找到脚本：{0}
ColorscriptNotFoundWithFilters = '使用指定的过滤器未找到 colorscript '{0}'。'
CachePathNotFound = 未找到缓存路径：{0}
NoCacheFilesFound = 在 {0} 中未找到缓存文件。
ProfileUpdatesNotSupportedInRemote = 远程会话中不支持配置文件更新。
ScriptSkippedByFilter = 脚本“{0}”不满足指定的筛选条件，将被跳过。
ParallelCacheNotSupported = 并行构建缓存需要 PowerShell 7 或更高版本。将改用顺序执行。

# Status Messages
DisplayingColorscripts = `n正在显示 {0} 个 colorscripts...
CacheBuildSummary = `n缓存构建摘要：
FailedScripts = `n失败的脚本：
TotalScriptsProcessed = `n已处理脚本总数：{0}
DisplayingContinuously = 连续显示（Ctrl+C 停止）`n
FinishedDisplayingAll = 已完成显示全部 {0} 个 colorscripts！
Quitting = `n正在退出...
CurrentIndexOfTotal = [{0}/{1}]
FailedScriptDetails =   - {0}：{1}
MultipleColorscriptsMatched = 多个 colorscripts 与提供的名称模式匹配：{0}。正在显示“{1}”。
StatusCached = 已缓存
StatusSkippedUpToDate = 已跳过（最新）
StatusSkippedNotRequired = 已跳过（无需缓存）
StatusSkippedByUser = 用户跳过
StatusFailed = 失败
StatusUpToDateSkipped = 最新（已跳过）
CacheBuildSummaryFormat = 缓存构建摘要：已处理 {0}，已更新 {1}，已跳过 {2}，失败 {3}
CacheDirectoryFormat = 缓存目录：{0}
CacheClearSummaryFormat = 缓存清理摘要：已删除 {0}，缺失 {1}，已跳过 {2}，试运行 {3}，错误 {4}

# Interactive Messages
PressSpacebarToContinue = 按 [空格键] 继续下一个，[Q] 退出`n
PressSpacebarForNext = 按 [空格键] 下一个，[Q] 退出...

# Success Messages
ProfileSnippetAdded = [OK] 已将 ColorScripts-Enhanced 启动片段添加到 {0}
ProfileAlreadyContainsSnippet = 配置文件已包含 ColorScripts-Enhanced 片段。
ProfileAlreadyImportsModule = 配置文件已导入 ColorScripts-Enhanced。
ModuleLoadedSuccessfully = ColorScripts-Enhanced 模块已成功加载。
RemoteSessionDetected = 检测到远程会话。
ProfileAlreadyConfigured = 配置文件已配置。
ProfileSnippetAddedMessage = 已添加 ColorScripts-Enhanced 配置文件片段。
UnableToOpenEditorForPath = 无法打开 '{0}' 的编辑器：{1}

# Help/Instruction Messages
SpecifyNameToSelectScripts = 当明确禁用 -All 时，指定 -Name 来选择脚本。
SpecifyAllOrNameToClearCache = 指定 -All 或 -Name 来清除缓存条目。
UsePassThruForDetailedResults = 使用 -PassThru 查看详细结果`n

# UI Elements

# Miscellaneous
'@
