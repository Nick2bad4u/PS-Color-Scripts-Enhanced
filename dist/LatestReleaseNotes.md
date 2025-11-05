<!-- markdownlint-disable -->
<!-- eslint-disable markdown/no-missing-label-refs -->
# Changelog

All notable changes to this project will be documented in this file.

## [2025.11.5.841] - 2025-11-05


[[6748e32](https://github.com/Nick2bad4u/PS-Color-Scripts-Enhanced/commit/6748e321e71c73758ec528d81588d909d938341a)...
[240264c](https://github.com/Nick2bad4u/PS-Color-Scripts-Enhanced/commit/240264c1014812c5d52bca327d1932788634c21e)]
([compare](https://github.com/Nick2bad4u/PS-Color-Scripts-Enhanced/compare/6748e321e71c73758ec528d81588d909d938341a...240264c1014812c5d52bca327d1932788634c21e))


### ≡ƒÆ╝ Other

- ≡ƒ¢á∩╕Å [fix] Harden localized message import and enforce dictionary results
 - ≡ƒº╛ Private/Import-LocalizedMessagesFromFile.ps1: validate Import-LocalizedData output and treat non-IDictionary returns as null (trace and fallback).
 - ≡ƒº» Private/Import-LocalizedMessagesFromFile.ps1: validate Import-PowerShellDataFile output and Write-ModuleTrace + throw InvalidOperationException when the result is not a dictionary (clear failure diagnostics).

≡ƒÜ£ [refactor] Simplify and correct script-name invalid-character handling
 - ΓÖ╗∩╕Å Private/Test-ColorScriptNameValue.ps1: replace raw invalid-char array with System.Collections.Generic.List[char] populated from [System.IO.Path]::GetInvalidFileNameChars().
 - Γ£é∩╕Å Remove wildcard chars ('*','?') from the invalid list when $AllowWildcard is true; otherwise detect wildcard characters explicitly and invoke the centralized throw.
 - ≡ƒº░ Centralize throw logic in a $throwInvalidCharacter scriptblock and format error messages with the provided name parameter for accurate context.

≡ƒöº [build] [dependency] Update ModuleVersion and sync help UICultureVersion stamps
 - ≡ƒö╝ [ColorScripts-Enhanced](https://github.com/Nick2bad4u/PS-Color-Scripts-Enhanced).psd1: ModuleVersion -> '2025.11.05.0244' and update ReleaseNotes header version.
 - ≡ƒîÉ Localized help files: sync SupportedUICultureVersion -> '2025.11.05.0244' across de, en-US, es, fr, it, ja, nl, pt, ru, zh-CN HelpInfo.xml files.

≡ƒº¬ [test] Make CI detection deterministic and skip tests reliably
 - ≡ƒº¡ Tests/[ColorScripts-Enhanced](https://github.com/Nick2bad4u/PS-Color-Scripts-Enhanced).AdditionalCoverage.Tests.ps1 & Tests/[ColorScripts-Enhanced](https://github.com/Nick2bad4u/PS-Color-Scripts-Enhanced).CoverageCompletion.Tests.ps1: add $script:IsCIEnvironment boolean computed from $env:CI (recognizes 'true','1','yes').
 - ≡ƒÜ½ Replace -Skip:($env:CI) with -Skip:$script:IsCIEnvironment on affected It tests to ensure consistent skipping behavior in CI environments.

Signed-off-by: Nick2bad4u <20943337+Nick2bad4u@users.noreply.github.com> [`(240264c)`](https://github.com/Nick2bad4u/PS-Color-Scripts-Enhanced/commit/240264c1014812c5d52bca327d1932788634c21e)


- ≡ƒöº [build] [dependency] Update ModuleVersion 2025.11.05.0039 and sync manifest/help UICultureVersion stamps
 - ≡ƒöº [build] Update ModuleVersion in [ColorScripts-Enhanced](https://github.com/Nick2bad4u/PS-Color-Scripts-Enhanced).psd1 from '2025.11.04.1949' ΓåÆ '2025.11.05.0039'
 - ≡ƒô¥ [docs] Update 'Generated on' timestamp in [ColorScripts-Enhanced](https://github.com/Nick2bad4u/PS-Color-Scripts-Enhanced).psd1 to 11/5/2025
 - ≡ƒô¥ [docs] Update ReleaseNotes header version string to 'Version 2025.11.05.0039' in the manifest
 - ≡ƒº╣ [chore] Synchronize SupportedUICulture UICultureVersion in localized HelpInfo XML files (de, en-US, es, fr, it, ja, nl, pt, ru, zh-CN) to 2025.11.05.0039
 - ≡ƒº╣ [chore] Keep manifest and localized help metadata consistent to ensure correct packaging/publishing and help consumption

Signed-off-by: Nick2bad4u <20943337+Nick2bad4u@users.noreply.github.com> [`(2f3b734)`](https://github.com/Nick2bad4u/PS-Color-Scripts-Enhanced/commit/2f3b734f3d50cb9109ad5acb68399c582e83317a)


- ≡ƒÜ£ [refactor] Modularize private implementation and add robust helpers for ANSI, caching, metadata, errors and localization

Γ£¿ [feat] Add ANSI utilities for colored text handling
 - Get-ColorScriptAnsiSequence: map common color names to ANSI sequences
 - New-ColorScriptAnsiText: wrap text with ANSI sequences and honor -NoAnsiOutput
 - Remove-ColorScriptAnsiSequence: compiled/cached regex ($script:AnsiStripRegex) to strip ANSI sequences

Γ£¿ [feat] Add JSON/hashtable compatibility helpers
 - ConvertFrom-JsonToHashtable: cross-version ConvertFrom-Json wrapper (uses -AsHashtable on PS6+)
 - ConvertTo-HashtableInternal: normalize PSCustomObject / enumerable structures into plain hashtables/arrays (PS5 fallback) for deterministic merging and caching

Γ£¿ [feat] Add structured error creation & consistent throwing
 - New-ColorScriptErrorRecord: build rich ErrorRecord (Message, ErrorId, Category, TargetObject, RecommendedAction, Exception wrapping)
 - Invoke-ColorScriptError: throw or ThrowTerminatingError via PSCmdlet using the constructed ErrorRecord

Γ£¿ [feat] Add process execution and cache build/read helpers
 - Invoke-ColorScriptProcess: execute colorscripts; supports fast in-process execution when -ForCache and preserves isolated UTF-8 child-process path for display
 - Build-ScriptCache: produce cache file from script execution, preserve timestamps, return detailed result object
 - Get-CachedOutput: read cached output safely via delegates and validate freshness vs script last-write
 - Initialize-CacheDirectory: resolve cache location candidates (env/config/OS), create directories with failure callbacks and fall back to temp

Γ£¿ [feat] Add metadata and inventory management
 - Get-ColorScriptInventory: file discovery and inventory caching with timestamp checks and raw/record modes
 - Get-ColorScriptMetadataTableInternal / Get-ColorScriptMetadataTable: build metadata dictionary from Messages.psd1 and merge auto-categories; support fast JSON metadata cache (metadata.cache.json)
 - Get-ColorScriptEntry & Select-RecordsByName: expose normalized script entries, name/category/tag filtering and pattern matching
 - Add $script:DefaultAutoCategoryRules default rules to enable auto-categorization when metadata lacks rules

≡ƒÜ£ [refactor] Split monolithic PrivateFunctions.ps1 into many focused files
 - Removed huge PrivateFunctions.ps1 and moved each helper into its own file for clarity, testability and DI via delegates
 - Initialize-SystemDelegateState centralizes filesystem/console delegates used by many helpers (enables injection & mocking)

Γ£¿ [feat] Improve configuration & localization flows
 - Get-ColorScriptsConfigurationRoot / Initialize-Configuration / Save-ColorScriptConfiguration / Get-ConfigurationDataInternal: robust cross-OS config root resolution, config.json load/merge/save with default fallback
 - Resolve-LocalizedMessagesFile / Import-LocalizedMessagesFromFile / Initialize-ColorScriptsLocalization: localized message discovery via Import-LocalizedData with Import-PowerShellDataFile fallback, candidate root probing, and embedded fallback defaults

Γ£¿ [feat] Add general utilities and safe IO helpers
 - Resolve-CachePath, Resolve-PreferredDirectory, Resolve-PreferredDirectoryCandidate: portable path resolution and directory creation with callbacks
 - Invoke-ModuleSynchronized: Monitor-based synchronization helper
 - Invoke-ShouldProcess: central ShouldProcess evaluation hook
 - Invoke-WithUtf8Encoding: temporarily set console encoding to UTF-8 for blocks and restore safely
 - Invoke-FileWriteAllText, Get/Set FileLastWriteTime(utc): small wrappers for file I/O and timestamp preservation used by cache build

Γ£¿ [feat] Add validation, matching & output helpers
 - Test-ColorScriptNameValue / Test-ColorScriptPathValue: validation functions that throw ValidationMetadataException with localized messages (used in ValidateScript blocks)
 - New-NameMatcherSet: build wildcard/exact matcher objects used by Select-RecordsByName
 - Test-ColorScriptTextEmission: determine if cmdlets should emit text vs return values
 - Write-RenderedText & Write-ColorScriptInformation: consistent render path with NoAnsiOutput support and Write-Information tagging ('ColorScripts'); Write-RenderedText falls back to pipeline output on console IO errors

≡ƒöº [build] Update BeastMode agent descriptor
 - .github/agents/BeastMode.agent.md: adjust tools list ordering and add 'memory' to agent toolset

≡ƒº╣ [chore] Clean up and prepare for testing
 - Consolidated many helpers into individual files to improve unit testing granularity and dependency injection points
 - Deleted legacy combined PrivateFunctions.ps1 to avoid duplication and simplify CI/test targets

Notes:
 - Primary goal: break down a large monolithic private implementation into composable, testable pieces and introduce robust utilities for ANSI handling, cross-version JSON -> hashtable conversion, deterministic metadata caching, standardized errors, safe cache IO and localization discovery.
 - Behavior preserved: where needed the child-process execution and output encoding behavior are retained for display scenarios; a fast in-process path was added specifically to speed cache building while keeping parity.
Signed-off-by: Nick2bad4u <20943337+Nick2bad4u@users.noreply.github.com> [`(db05644)`](https://github.com/Nick2bad4u/PS-Color-Scripts-Enhanced/commit/db0564420ee38891d8a83a7b88699569d86c285a)


- ≡ƒöº [build] [dependency] Update ModuleVersion 2025.11.04.1949, update manifest timestamp and exported aliases
 - Γ£¿ Update [ColorScripts-Enhanced](https://github.com/Nick2bad4u/PS-Color-Scripts-Enhanced).psd1: set ModuleVersion='2025.11.04.1949' and Generated on to 11/4/2025
 - Γ£¿ Sync ReleaseNotes header inside the manifest to the new ModuleVersion
 - ≡ƒöº Add Build-ColorScriptCache to AliasesToExport in the build manifest generation and final manifest output
 - ≡ƒöº Normalize Author field usage in build manifest generation script

≡ƒô¥ [docs] Sync localized help metadata and refresh release artifacts
 - ≡ƒº╛ Update SupportedUICultureVersion in localized HelpInfo.xml files (de, en-US, es, fr, it, ja, nl, pt, ru, zh-CN) to match the ModuleVersion
 - ≡ƒô¥ Refresh dist/LatestReleaseNotes.md and dist/PowerShellGalleryReleaseNotes.md to reflect the localization loader/refactor and version bump

≡ƒº¬ [test] Align tests with new info/warning flows and CI-friendly skipping
 - ≡ƒº¬ Replace Write-Host mocks with Write-Information mocks and adjust captured payload handling (MessageData)
 - ≡ƒº¬ Add/adjust Write-Warning mocks and assertions to validate new warning message formats
 - ≡ƒº¬ Make several previously-skipped specs conditional via -Skip:($env:CI) so they run locally but skip in CI

Signed-off-by: Nick2bad4u <20943337+Nick2bad4u@users.noreply.github.com> [`(ffefde0)`](https://github.com/Nick2bad4u/PS-Color-Scripts-Enhanced/commit/ffefde0a8e6bb96e5ae53ca04343ba0479abb241)


- ≡ƒÜ£ [refactor] Rework core private helpers, localization and caching flows
 - Introduce Resolve-LocalizedMessagesFile: robust, culture-aware discovery for Messages.psd1 (case-insensitive dir matching, culture fallback, safe resolution) and integrate into Import-LocalizedMessagesFromFile.
 - Rework Import-LocalizedMessagesFromFile / Initialize-ColorScriptsLocalization to probe multiple candidate roots, attempt per-candidate imports, select the first successful localized file, populate $script:LocalizationDetails (LocalizedDataLoaded/ModuleRoot/SearchedPaths/Source/FilePath) and gracefully fall back to embedded defaults with improved Write-ModuleTrace messages.
 - Consolidate synchronization and delegate usage (Invoke-ModuleSynchronized + delegates) to make path/IO behaviors more testable and resilient.
 - Preserve previous private helper snapshot under scripts/original-PrivateFunctions.ps1 for reference.

Γ£¿ [feat] Harden path resolution, cache & inventory behavior
 - Resolve-CachePath: safer tilde (~) expansion via GetUserProfilePathDelegate with fallbacks to $HOME, validate drive qualifiers, and return $null for unresolved/invalid roots to avoid surprising IO operations.
 - Initialize-CacheDirectory / Get-CachedOutput: initialize cache directory on demand, return consistent pscustomobject for missing/invalid state, and avoid throwing where not actionable.
 - Get-ColorScriptInventory: avoid unnecessary full refreshes by detecting non-file entries in the cached inventory, probe file counts as a lightweight check, and preserve ScriptInventoryRecords / -Raw semantics.
 - Invoke-ColorScriptProcess (fast in-process path): switch working directory using Get-Location -PSProvider FileSystem, capture all output streams with *>&1 for accurate cached output, and ensure working directory is restored.
 - Allow Invoke-FileWriteAllText to accept empty content (AllowEmptyString) for explicit empty-file writes.

≡ƒ¢á∩╕Å [fix] Improve public cmdlets: profile handling, scaffolding and cache UX
 - Add-ColorScriptProfile: detect remote hosts (PSSenderInfo) and avoid unsupported remote updates; robustly resolve PROFILE variants (PSObject / CurrentUserAllHosts), use Resolve-CachePath / session-based path fallbacks, honor configuration defaults, add SkipStartupScript and structured return {Path,Changed,Message}, and surface localized errors when resolution fails.
 - New-ColorScript: add a 'Scaffold' ParameterSet, rename DestinationΓåÆOutputPath, add Force/GenerateMetadataSnippet/Category/Tag support, produce a scaffold file + optional metadata guidance, call Reset-ScriptInventoryCache after creation, use ShouldProcess and return a structured metadata object on success.
 - New-ColorScriptCache (alias Build-ColorScriptCache): add alias and default parameter set, accept pipeline input and accumulate Name patterns, normalize selection via Select-RecordsByName, metadata-driven selection (Category/Tag), progress reporting, consistent structured result records (Status/Message/ExitCode/StdOut/StdErr) and human-readable summary via Write-ColorScriptInformation; better handling for PassThru.
 - Clear-ColorScriptCache: complete rewrite to support Name/Category/Tag/Path/All/DryRun/PassThru with pipeline-friendly name collection, pattern vs metadata matching, per-file Invoke-ShouldProcess checks, explicit status states (Removed/Missing/DryRun/Skipped/Errors), and a summarized informational output when not returning PassThru.

≡ƒöº [build] Module manifest & export list updates
 - Add 'Build-ColorScriptCache' to [ColorScripts-Enhanced](https://github.com/Nick2bad4u/PS-Color-Scripts-Enhanced).psd1 AliasesToExport and to Export-ModuleMember -Alias in the module file so the new alias is exported consistently.

≡ƒº¬ [test] Add import coverage tests and preserve original helpers
 - Add comprehensive Tests/[ColorScripts-Enhanced](https://github.com/Nick2bad4u/PS-Color-Scripts-Enhanced).ModuleImportCoverage.Tests.ps1 to validate trace configuration parsing, trace-file preparation/fallback, module-root discovery, and robust import behavior when Private/Public folders are unavailable.
 - Add scripts/original-PrivateFunctions.ps1 to keep a snapshot of the prior private implementation for easier review/debugging.
 - Remove stale test-output.txt.

≡ƒº╣ [chore] Formatting, completions and small cleanups
 - Tidy argument-completer scriptblocks and indentation (Get-ColorScriptList, Show-ColorScript) to improve readability and avoid subtle completion bugs; remove duplicate NoAnsiOutput assignments in Show-ColorScript.
 - Minor trailing-newline / whitespace fixes added to multiple public files (Export-ColorScriptMetadata, Get-ColorScriptConfiguration, Reset-ColorScriptConfiguration, Set-ColorScriptConfiguration).
 - Small message / error-id clarifications and more consistent use of structured result objects across public cmdlets to improve downstream automation and tests.

Signed-off-by: Nick2bad4u <20943337+Nick2bad4u@users.noreply.github.com> [`(0a8139f)`](https://github.com/Nick2bad4u/PS-Color-Scripts-Enhanced/commit/0a8139f92754288796333db41f3d1683cc783b0d)


- Rollback-Refactor-1

Signed-off-by: Nick2bad4u <20943337+Nick2bad4u@users.noreply.github.com> [`(9d9505d)`](https://github.com/Nick2bad4u/PS-Color-Scripts-Enhanced/commit/9d9505d75d57b3af3860dd0ce806b05e64792953)


- On main: Γ£¿ [feat] Add ANSI helpers, JSON->Hashtable fallback and info writer; thread NoAnsiOutput/Quiet through rendering - Γ£¿ Add ConvertTo-HashtableInternal to normalize PSCustomObject / enumerable structures and simplify ConvertFrom-JsonToHashtable (PS5 fallback) for consistent hashtable results - Γ£¿ Introduce ANSI utilities: - Get-ColorScriptAnsiSequence: map named colors to ANSI sequences - New-ColorScriptAnsiText: wrap text with color sequences and honor -NoAnsiOutput - Remove-ColorScriptAnsiSequence: compiled regex to strip ANSI sequences (cached in $script:AnsiStripRegex) - Γ£¿ Add Write-ColorScriptInformation to emit informational text via Write-Information (tagged 'ColorScripts') and honor a Quiet switch - Γ£¿ Extend Write-RenderedText to accept -NoAnsiOutput and strip ANSI sequences when requested; propagate NoAnsiOutput through Invoke-WithUtf8Encoding call sites≡ƒÜ£ [refactor] Standardize structured error creation and emissions - ≡ƒÜ£ Add New-ColorScriptErrorRecord helper to build rich ErrorRecord objects (Message/ErrorId/Category/TargetObject/RecommendedAction/Exception handling) - ≡ƒÜ£ Add Invoke-ColorScriptError to throw or ThrowTerminatingError($PSCmdlet) with constructed ErrorRecord - ≡ƒÜ£ Replace many direct throw calls with Invoke-ColorScriptError across the module (standardized ErrorId tokens and ErrorCategory values for predictable error handling)Γ£¿ [feat] Add validation helpers and stronger parameter validation/metadata - Γ£¿ Add Test-ColorScriptNameValue and Test-ColorScriptPathValue validation helpers (throw ValidationMetadataException with localized messages) - Γ£¿ Apply ValidateScript({ Test-ColorScriptPathValue ... }) / ValidateScript({ Test-ColorScriptNameValue ... }) to multiple parameters (Invoke-FileWriteAllText, Get-ColorScriptEntry, Get-ColorScriptList, New-ColorScriptCache, Clear-ColorScriptCache, New-ColorScript, Add-ColorScriptProfile, Export-ColorScriptMetadata, Set-ColorScriptConfiguration, etc.) - Γ£¿ Add [OutputType(...)] annotations to several public cmdlets for better metadataΓ£¿ [feat] Improve Show-ColorScript list/display flow and output options - Γ£¿ Add -Quiet and -NoAnsiOutput (alias NoColor) switches to Show-ColorScript and Get-ColorScriptList; thread flags into list and rendering code paths - Γ£¿ Replace Console Write-Host usage with Write-ColorScriptInformation and colored segments built by New-ColorScriptAnsiText; preserve prompt behavior for WaitForInput while allowing Quiet to suppress other info - Γ£¿ Ensure rendered text is written via Invoke-WithUtf8Encoding with NoAnsiOutput forwarded, and strip ANSI from informational table output when requestedΓ£¿ [feat] Make Export-ColorScriptMetadata respectful of ShouldProcess and safer for file ops - Γ£¿ Add SupportsShouldProcess/ConfirmImpact and ValidateScript for export cmdlet - Γ£¿ Resolve output path via Resolve-CachePath and call Invoke-ShouldProcess for both export target and creation of export directory; defer or return early when user declines or -WhatIf is in effect - Γ£¿ Consistently use structured Invoke-ColorScriptError for invalid resolution scenarios≡ƒº╣ [chore] Add localized validation message keys across locales - ≡ƒº╣ Add message keys: InvalidScriptNameEmpty, InvalidScriptNameCharacters, InvalidPathValueEmpty, InvalidPathValueCharacters to en-US and localized resource files (de, es, fr, it, ja, nl, pt, ru, zh-CN) for validator error text≡ƒº¬ [test] Update and expand tests to cover new helpers and structured behaviors - ≡ƒº¬ Update mocks to exercise new Write-RenderedText signature and Write-ColorScriptInformation usage (AdditionalCoverage / CoverageCompletion / CoverageExpansion / InternalCoverage changes) - ≡ƒº¬ Add tests for ConvertFrom-JsonToHashtable and ConvertTo-HashtableInternal PSCustomObject conversion - ≡ƒº¬ Add tests for ANSI wrapping/stripping, New-ColorScriptAnsiText behavior and Write-ColorScriptInformation Quiet handling - ≡ƒº¬ Add/modify assertions to expect structured ErrorRecord FullyQualifiedErrorId and CategoryInfo.Category for many failure paths (examples: ColorScriptsEnhanced.InvalidOutputPath, ColorScriptsEnhanced.InvalidCachePath, ColorScriptsEnhanced.InvalidProfilePath, ColorScriptsEnhanced.ProfilePathUndefined, ColorScriptsEnhanced.CacheBuildFailed, ColorScriptsEnhanced.ScriptExecutionFailed, ColorScriptsEnhanced.CacheSelectionMissing, ColorScriptsEnhanced.CacheClearSelectionMissing, ColorScriptsEnhanced.ConfigurationRootUnavailable, ColorScriptsEnhanced.ScriptAlreadyExists) - ≡ƒº¬ Add coverage for Export-ColorScriptMetadata ShouldProcess/WhatIf and deferred directory-creation behavior, and for Show-ColorScript Quiet / NoAnsiOutput wiring (including prompt behavior)Signed-off-by: Nick2bad4u <20943337+Nick2bad4u@users.noreply.github.com>

Signed-off-by: Nick2bad4u <20943337+Nick2bad4u@users.noreply.github.com> [`(95e03c5)`](https://github.com/Nick2bad4u/PS-Color-Scripts-Enhanced/commit/95e03c58257e997b96f9539cf904baa8fa6560f9)


- Γ£¿ [feat] Add configurable module tracing and Write-ModuleTrace helper - Introduce COLOR_SCRIPTS_ENHANCED_TRACE parsing and module-scoped trace flags ($script:ModuleTraceEnabled, UseVerbose, UseDebug, UseFile, ModuleTraceFile) - Support tokens: boolean (1/true/yes/on), verbose, debug, file, path:<path> and treat absolute paths as file targets; default file placed in temp when requested - Create trace directory when needed and gracefully disable file tracing on directory/write failures; notify only once on write failure - Add Write-ModuleTrace to emit Write-Debug/Write-Verbose and append UTF-8 messages to the configured trace file≡ƒÜ£ [refactor] Replace ad-hoc debug Out-File logging with structured tracing - Replace scattered Out-File debug/debug-temp writes used during module-root discovery and localization init with Write-ModuleTrace calls - Consolidate startup/import trace messages so they respect configured trace modes and file output≡ƒº¬ [test] Add tests for module trace configuration and file output - Preserve and restore COLOR_SCRIPTS_ENHANCED_TRACE in test fixtures - Add tests validating verbose mode, debug+file mode (writes to specified path), and absolute-path handling; assert trace file contentsSigned-off-by: Nick2bad4u <20943337+Nick2bad4u@users.noreply.github.com>

Signed-off-by: Nick2bad4u <20943337+Nick2bad4u@users.noreply.github.com> [`(069b5c2)`](https://github.com/Nick2bad4u/PS-Color-Scripts-Enhanced/commit/069b5c25950b4ca2f6ddd179f3c98f184febd979)


- ≡ƒô¥ [docs] Add BeastMode agent and a suite of automated prompts for repo maintenance

 - Γ£¿ [feat] Add .github/agents/BeastMode.agent.md ΓÇö BeastMode agent definition with rules, workflow, toolset and handoffs to orchestrate automated tasks (consistency checks, test coverage, TODO triage, continuation, review)
 - ≡ƒô¥ [docs] Add .github/PROMPTS/Consistency-Check.prompt.md ΓÇö detailed consistency audit prompt (structural alignment, data flow, logic uniformity, interface cohesion, prioritization and remediation roadmap)
 - ≡ƒº¬ [test] Add .github/PROMPTS/Generate-100%-Test-Coverage.prompt.md ΓÇö step-by-step Pester coverage plan and success criteria (guidance on InModuleScope, mocks, edge cases, and achieving ΓëÑ94% coverage)
 - ≡ƒô¥ [docs] Add .github/PROMPTS/Add-ToDo.prompt.md ΓÇö TODO creation and management prompt to populate and maintain repo-root TODO.md with actionable items
 - ≡ƒô¥ [docs] Add .github/PROMPTS/Continue.prompt.md ΓÇö continuation prompt to resume and systematically progress TODO items with validation and testing steps
 - ≡ƒô¥ [docs] Add .github/PROMPTS/Review.prompt.md ΓÇö final-review prompt to run linters/tests, validate best practices, and close or update TODOs
 - ≡ƒô¥ [docs] Add .github/copilot-commit-message-instructions.md ΓÇö contributor commit-message guidelines to standardize emoji/tag format and formatting conventions

Signed-off-by: Nick2bad4u <20943337+Nick2bad4u@users.noreply.github.com> [`(0bc79aa)`](https://github.com/Nick2bad4u/PS-Color-Scripts-Enhanced/commit/0bc79aaa3843e987aaa85fa1386b839d13df9025)


- ≡ƒº╣ [chore] Remove local todo.md and ignore it
 - ≡ƒº╣ [chore] Delete todo.md from repository (personal task list)
 - ≡ƒº╣ [chore] Update .gitignore to ignore todo.md and prevent accidental commits of local notes

Signed-off-by: Nick2bad4u <20943337+Nick2bad4u@users.noreply.github.com> [`(6748e32)`](https://github.com/Nick2bad4u/PS-Color-Scripts-Enhanced/commit/6748e321e71c73758ec528d81588d909d938341a)






## Contributors
Thanks to all the [contributors](https://github.com/Nick2bad4u/PS-Color-Scripts-Enhanced/graphs/contributors) for their hard work!
## License
This project is licensed under the [MIT License](https://github.com/Nick2bad4u/PS-Color-Scripts-Enhanced/blob/main/LICENSE)
*This changelog was automatically generated with [git-cliff](https://github.com/orhun/git-cliff).*

