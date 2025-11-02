ConvertFrom-StringData @'
# ColorScripts-Enhanced Localized Messages
# Japanese (ja) - 日本語

# Error Messages
UnableToPrepareCacheDirectory = キャッシュディレクトリの準備ができませんでした
FailedToParseConfigurationFile = '{0}' で設定ファイルの解析に失敗しました: {1}。デフォルトを使用します。
UnableToResolveCachePath = Unable to resolve cache path '{0}'.
ConfiguredCachePathInvalid = 設定されたキャッシュパスが無効です
UnableToResolveOutputPath = Unable to resolve output path '{0}'.
UnableToDetermineConfigurationDirectory = ColorScripts-Enhanced の設定ディレクトリを決定できませんでした。
ConfigurationRootCouldNotBeResolved = 設定ルートを解決できませんでした。
UnableToResolveProfilePath = Unable to resolve profile path '{0}'.
FailedToExecuteColorscript = カラースクリプトの実行に失敗しました
FailedToBuildCacheForScript = $($selection.Name) のキャッシュ構築に失敗しました。
CacheBuildFailedForScript = $($selection.Name) のキャッシュ構築に失敗しました: $($cacheResult.StdErr.Trim())
ScriptAlreadyExists = スクリプト ''$targetPath'' は既に存在します。上書きするには -Force を使用してください。
ProfilePathNotDefinedForScope = 'スコープ ''$Scope'' のプロファイルパスが定義されていません。'
ScriptPathNotFound = スクリプトパスが見つかりません。
ScriptExitedWithCode = スクリプトがコード {0} で終了しました。
CacheFileNotFound = キャッシュファイルが見つかりません。
NoChangesApplied = 変更が適用されませんでした。
UnableToRetrieveFileInfo = ''{0}'' のファイル情報を取得できませんでした: {1}
UnableToReadCacheInfo = ''{0}'' のキャッシュ情報を読み取れませんでした: {1}

# Warning Messages
NoColorscriptsFoundMatchingCriteria = 指定された条件に一致するカラースクリプトが見つかりません。
NoScriptsMatchedSpecifiedFilters = 指定されたフィルターに一致するスクリプトがありません。
NoColorscriptsAvailableWithFilters = 指定されたフィルターで利用可能なカラースクリプトがありません。
NoColorscriptsFoundInScriptsPath = $script:ScriptsPath にカラースクリプトが見つかりません
NoScriptsSelectedForCacheBuild = キャッシュ構築用に選択されたスクリプトがありません。
ScriptNotFound = スクリプトが見つかりません: $pattern
ColorscriptNotFoundWithFilters = 'カラースクリプト ''{0}'' が指定されたフィルターで見つかりません。'
CachePathNotFound = キャッシュパスが見つかりません: $targetRoot
NoCacheFilesFound = $targetRoot にキャッシュファイルが見つかりません。
ProfileUpdatesNotSupportedInRemote = プロファイルの更新はリモートセッションではサポートされていません。
ScriptSkippedByFilter = 'スクリプト ''$skipped'' は指定されたフィルターを満たさないためスキップされます。'

# Status Messages
DisplayingColorscripts = `n$totalCount 個のカラースクリプトを表示しています...
CacheBuildSummary = `nキャッシュ構築サマリー:
FailedScripts = `n失敗したスクリプト:
TotalScriptsProcessed = `n処理されたスクリプトの総数: $totalCount
DisplayingContinuously = 連続表示中 (停止するには Ctrl+C)`n
FinishedDisplayingAll = $totalCount 個のすべてのカラースクリプトの表示が完了しました！
Quitting = `n終了しています...
CurrentIndexOfTotal = [$currentIndex/$totalCount]
FailedScriptDetails =   - $($failure.Name): $($failure.StdErr)
MultipleColorscriptsMatched = 指定された名前パターンに複数のカラースクリプトが一致しました: $($matchedNames -join '', '')。''$($orderedMatches[0].Name)'' を表示します。
StatusCached = キャッシュ済み
StatusSkippedUpToDate = スキップ済み (最新)
StatusSkippedByUser = ユーザーによりスキップ
StatusFailed = 失敗
StatusUpToDateSkipped = 最新 (スキップ済み)

# Interactive Messages
PressSpacebarToContinue = 次に進むには [Spacebar] を押してください、終了するには [Q] を押してください`n
PressSpacebarForNext = 次へ進むには [Spacebar] を押してください、終了するには [Q] を押してください...

# Success Messages
ProfileSnippetAdded = [OK] ColorScripts-Enhanced スタートアップスニペットを $profilePath に追加しました
ProfileAlreadyContainsSnippet = プロファイルには既に ColorScripts-Enhanced スニペットが含まれています。
ProfileAlreadyImportsModule = プロファイルは既に ColorScripts-Enhanced をインポートしています。
ModuleLoadedSuccessfully = ColorScripts-Enhanced モジュールが正常に読み込まれました。
RemoteSessionDetected = リモートセッションが検出されました。
ProfileAlreadyConfigured = プロファイルは既に設定されています。
ProfileSnippetAddedMessage = ColorScripts-Enhanced プロファイルスニペットが追加されました。

# Help/Instruction Messages
SpecifyNameToSelectScripts = -All が明示的に無効化されている場合、スクリプトを選択するには -Name を指定してください。
SpecifyAllOrNameToClearCache = キャッシュエントリをクリアするには -All または -Name を指定してください。
UsePassThruForDetailedResults = 詳細な結果を表示するには -PassThru を使用してください`n

# UI Elements

# Miscellaneous
'@
