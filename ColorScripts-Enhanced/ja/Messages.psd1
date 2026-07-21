ConvertFrom-StringData @'
# ColorScripts-Enhanced Localized Messages
# Japanese (ja) - 日本語

# Error Messages
UnableToPrepareCacheDirectory = キャッシュディレクトリ '{0}' を準備できませんでした: {1}
FailedToParseConfigurationFile = '{0}' で設定ファイルの解析に失敗しました: {1}。デフォルトを使用します。
UnableToResolveCachePath = キャッシュパス '{0}' を解決できませんでした。
ConfiguredCachePathInvalid = 設定されたキャッシュパス '{0}' を解決できませんでした。既定の場所を使用します。
UnableToResolveOutputPath = 出力パス '{0}' を解決できませんでした。
UnableToDetermineConfigurationDirectory = ColorScripts-Enhanced の設定ディレクトリを決定できませんでした。
ConfigurationRootCouldNotBeResolved = 設定ルートを解決できませんでした。
UnableToResolveProfilePath = プロファイルパス '{0}' を解決できませんでした。
FailedToExecuteColorscript = カラースクリプト '{0}' の実行に失敗しました: {1}
FailedToBuildCacheForScript = カラースクリプトのキャッシュを構築できませんでした。
CacheBuildFailedForScript = {0} のキャッシュ構築に失敗しました: {1}
CacheBuildGenericFailure = キャッシュ構築に失敗しました。
CacheOperationWarning = '{0}' のキャッシュ処理に失敗しました: {1}
CacheOperationInitializationFailed = キャッシュディレクトリを初期化できませんでした: {0}
ScriptAlreadyExists = スクリプト '{0}' は既に存在します。上書きするには -Force を使用してください。
ProfilePathNotDefinedForScope = スコープ '{0}' のプロファイルパスが定義されていません。
ScriptPathNotFound = スクリプトパスが見つかりません。
ScriptExitedWithCode = スクリプトがコード {0} で終了しました。
CacheFileNotFound = キャッシュファイルが見つかりません。
NoChangesApplied = 変更が適用されませんでした。
UnableToRetrieveFileInfo = '{0}' のファイル情報を取得できませんでした: {1}
UnableToReadCacheInfo = '{0}' のキャッシュ情報を読み取れませんでした: {1}
ProfileSnippetWriteFailed = ColorScripts-Enhanced プロファイルスニペットを '{0}' に書き込めませんでした: {1}
UnableToWriteColorScriptFile = カラースクリプトファイル '{0}' に書き込めませんでした: {1}
InvalidScriptNameEmpty = カラースクリプト名を空または空白だけにすることはできません。
InvalidScriptNameCharacters = カラースクリプト名 '{0}' に無効な文字が含まれています。
InvalidPathValueEmpty = パスを空または空白だけにすることはできません。
InvalidPathValueCharacters = パス '{0}' に無効な文字が含まれています。

# Warning Messages
NoColorscriptsFoundMatchingCriteria = 指定された条件に一致するカラースクリプトが見つかりません。
NoScriptsMatchedSpecifiedFilters = 指定されたフィルターに一致するスクリプトがありません。
NoColorscriptsAvailableWithFilters = 指定されたフィルターで利用可能なカラースクリプトがありません。
NoColorscriptsFoundInScriptsPath = スクリプトパス '{0}' にカラースクリプトが見つかりません。
NoScriptsSelectedForCacheBuild = キャッシュ構築用に選択されたスクリプトがありません。
ScriptNotFound = スクリプトが見つかりません: {0}
ColorscriptNotFoundWithFilters = 'カラースクリプト '{0}' が指定されたフィルターで見つかりません。'
CachePathNotFound = キャッシュパスが見つかりません: {0}
NoCacheFilesFound = {0} にキャッシュファイルが見つかりません。
ProfileUpdatesNotSupportedInRemote = プロファイルの更新はリモートセッションではサポートされていません。
ScriptSkippedByFilter = スクリプト '{0}' は指定されたフィルターを満たさないためスキップされます。
ParallelCacheNotSupported = キャッシュの並列構築には PowerShell 7 以降が必要です。逐次実行に切り替えます。

# Status Messages
DisplayingColorscripts = `n{0} 個のカラースクリプトを表示しています...
CacheBuildSummary = `nキャッシュ構築サマリー:
FailedScripts = `n失敗したスクリプト:
TotalScriptsProcessed = `n処理されたスクリプトの総数: {0}
DisplayingContinuously = 連続表示中 (停止するには Ctrl+C)`n
FinishedDisplayingAll = {0} 個のカラースクリプトの表示が完了しました！
Quitting = `n終了しています...
CurrentIndexOfTotal = [{0}/{1}]
FailedScriptDetails =   - {0}: {1}
MultipleColorscriptsMatched = 指定された名前パターンに複数のカラースクリプトが一致しました: {0}。'{1}' を表示します。
StatusCached = キャッシュ済み
StatusSkippedUpToDate = スキップ済み (最新)
StatusSkippedNotRequired = スキップ (キャッシュ不要)
StatusSkippedByUser = ユーザーによりスキップ
StatusFailed = 失敗
StatusUpToDateSkipped = 最新 (スキップ済み)
CacheBuildSummaryFormat = キャッシュ構築の概要: 処理 {0}、更新 {1}、スキップ {2}、失敗 {3}
CacheDirectoryFormat = キャッシュディレクトリ: {0}
CacheClearSummaryFormat = キャッシュ削除の概要: 削除 {0}、未検出 {1}、スキップ {2}、ドライラン {3}、エラー {4}

# Interactive Messages
PressSpacebarToContinue = 次に進むには [Spacebar] を押してください、終了するには [Q] を押してください`n
PressSpacebarForNext = 次へ進むには [Spacebar] を押してください、終了するには [Q] を押してください...

# Success Messages
ProfileSnippetAdded = [OK] ColorScripts-Enhanced スタートアップスニペットを {0} に追加しました
ProfileAlreadyContainsSnippet = プロファイルには既に ColorScripts-Enhanced スニペットが含まれています。
ProfileAlreadyImportsModule = プロファイルは既に ColorScripts-Enhanced をインポートしています。
ModuleLoadedSuccessfully = ColorScripts-Enhanced モジュールが正常に読み込まれました。
RemoteSessionDetected = リモートセッションが検出されました。
ProfileAlreadyConfigured = プロファイルは既に設定されています。
ProfileSnippetAddedMessage = ColorScripts-Enhanced プロファイルスニペットが追加されました。
UnableToOpenEditorForPath = '{0}' のエディターを開けませんでした: {1}

# Help/Instruction Messages
SpecifyNameToSelectScripts = -All が明示的に無効化されている場合、スクリプトを選択するには -Name を指定してください。
SpecifyAllOrNameToClearCache = キャッシュエントリをクリアするには -All または -Name を指定してください。
UsePassThruForDetailedResults = 詳細な結果を表示するには -PassThru を使用してください`n

# UI Elements

# Miscellaneous
'@
