## [2025.11.6.19] - 2025-11-06


[[e25ac30](https://github.com/Nick2bad4u/PS-Color-Scripts-Enhanced/commit/e25ac308ede6877d256931d1758b64d8fd1f381c)...
[e25ac30](https://github.com/Nick2bad4u/PS-Color-Scripts-Enhanced/commit/e25ac308ede6877d256931d1758b64d8fd1f381c)]
([compare](https://github.com/Nick2bad4u/PS-Color-Scripts-Enhanced/compare/e25ac308ede6877d256931d1758b64d8fd1f381c...e25ac308ede6877d256931d1758b64d8fd1f381c))


### ≡ƒÆ╝ Other

- ≡ƒ¢á∩╕Å [fix] Add cache-format upgrade workflow, unify colorscript execution, and bump module/help versions

Γ£¿ [feat] Add Ensure-CacheFormatVersion.ps1
 - ≡ƒº⌐ Implements Update-CacheFormatVersion to manage cache-metadata.json (Version, ModuleVersion, UpdatedUtc) and purge existing *.cache files when the format version changes.
 - ΓÜá∩╕Å Includes robust error handling and Write-Verbose diagnostics to avoid breaking initialization on IO/parse failures.

≡ƒÜ£ [refactor] Integrate cache-format upgrade into initialization
 - ≡ƒöü Call Update-CacheFormatVersion from Initialize-CacheDirectory immediately after resolving/creating the cache directory (both primary resolution and fallback) so caches are validated/upgraded and stale .cache files are removed automatically.

≡ƒÜ£ [refactor] Unify colorscript execution to isolated process
 - ≡ƒûÑ∩╕Å Remove the fast in-process execution path and always spawn an isolated PowerShell process to preserve ANSI sequences and console rendering fidelity.
 - ≡ƒº¡ When running for cache builds (ForCache), set child env var COLOR_SCRIPTS_ENHANCED_CACHE_BUILD='1' so the subprocess can detect cache-build context; fail-safe verbose handling if env cannot be written.

≡ƒöº [build] [dependency] Update ModuleVersion and update ReleaseNotes
 - ≡ƒöó Update ModuleVersion to '2025.11.05.1912' in the module manifest and adjust the ReleaseNotes header to the new stamp.

≡ƒô¥ [docs] Sync localized HelpInfo UICultureVersion stamps
 - ≡ƒîÉ Update SupportedUICultures / UICultureVersion for localized HelpInfo.xml files (en-US, de, es, fr, it, ja, nl, pt, ru, zh-CN) to match the new module stamp.

≡ƒº¬ [test] Update tests to initialize cache directory and pass explicit cache path
 - ≡ƒöÄ Tests now call Initialize-CacheDirectory inside module scope to retrieve $script:CacheDir and pass the explicit testCachePath into test blocks, ensuring tests operate on the real cache location and not an assumed variable.

Signed-off-by: Nick2bad4u <20943337+Nick2bad4u@users.noreply.github.com> [`(e25ac30)`](https://github.com/Nick2bad4u/PS-Color-Scripts-Enhanced/commit/e25ac308ede6877d256931d1758b64d8fd1f381c)






## [2025.11.5.2155] - 2025-11-05


[[3493565](https://github.com/Nick2bad4u/PS-Color-Scripts-Enhanced/commit/3493565c56ef825fe5c4ed7cf25603e0141637b7)...
[35c5457](https://github.com/Nick2bad4u/PS-Color-Scripts-Enhanced/commit/35c545788bf9d6908d9fbe0f478a60a3f6edfd00)]
([compare](https://github.com/Nick2bad4u/PS-Color-Scripts-Enhanced/compare/3493565c56ef825fe5c4ed7cf25603e0141637b7...35c545788bf9d6908d9fbe0f478a60a3f6edfd00))


### ≡ƒ¢á∩╕Å GitHub Actions

- ≡ƒÜ£ [refactor] Large-scale docs localization + ANSI conversion scripts overhaul + tooling updates

 - ≡ƒº¬ Improved encoding support: use iconv decode(cp437) for legacy ANSI files and return both content and sauce metadata.
 - Γ£¿ Better return shapes: convertAnsiToPs1 now returns { lines, warnings, terminal } for programmatic consumption; main() gives clearer status and exits non-zero on fatal errors.
 - ≡ƒöü Consistent style & exports: standardized function exports (TerminalEmulator, readAnsiFile, convertAnsiToPs1, parseArguments, sanitizeName, main, createDefaultAttrs, stripSauce) and applied consistent formatting/whitespace for readability.

≡ƒÜ£ [refactor] Split-AnsiFile.js ΓÇö CLI splitting utility hardened & modernized
 - ≡ƒöº Reworked CLI parsing into typed SplitOptions with JSDoc and solid defaults (DEFAULT_OUTPUT_DIR).
 - ≡ƒöº Implemented robust segmentation pipeline: extractLinesFromPs1(), determineBreaks(), splitLines(), ensureTrailingReset(), plus chunk-writing helpers writeChunkPs1/writeChunkAnsi.
 - ≡ƒöº Added features: --heights (cumulative), --breaks (absolute), --every (regular chunking), --auto (blank-line gap detection with gap/minSegment thresholds), --dry-run and --strip-space-bg; improved user-facing error/help output.
 - ≡ƒöº Now uses the conversion utilities (readAnsiFile/convertAnsiToPs1) and produces consistent part files (sanitized names, padded suffixes) and safe writes.

≡ƒæ╖ [ci] Tooling & formatting additions (package.json & package-lock)
 - ≡ƒöº Added Prettier + an array of Prettier plugins to devDependencies: prettier, prettier-plugin-powershell, prettier-plugin-ini, prettier-plugin-jsdoc, prettier-plugin-multiline-arrays, prettier-plugin-packagejson, prettier-plugin-merge, prettier-plugin-sql, prettier-plugin-sort-json, prettier-plugin-tailwindcss, and helper plugins (prettier-plugin-interpolated-html-tags, @awmottaz/prettier-plugin-void-html, prettier-plugin-properties).
 - ≡ƒöº Updated package-lock.json to reflect new plugin dependency graph and included supporting libs (micromark/mdast ecosystem, json5, luxon, etc.) for the new formatting toolchain.
 - ΓÜÖ∩╕Å Rationale: unify code style across JS/Markdown/PowerShell and enable safe automated formatting in CI pipelines.

≡ƒô¥ [docs] Massive localization & help content hygiene (pt / ru / zh-CN + others)
 - Γ£ì∩╕Å Standardized many localized Markdown help pages under [ColorScripts-Enhanced](https://github.com/Nick2bad4u/PS-Color-Scripts-Enhanced)/{pt,ru,zh-CN}: added blank-line separations, improved examples, clarified descriptions, expanded Best Practices and Advanced Usage sections where missing.
 - Γ£ì∩╕Å Escaped wildcard characters in docs (changed "*" to "\*") in multiple languages to avoid unintended Markdown rendering and to make parameter docs literal and copy-paste safe.
 - Γ£ì∩╕Å Normalized parameter YAML fragments: standardized keys (DontShow, AcceptedValues, HelpMessage) and consistent formatting (HelpMessage: ""), added small blank lines for readability.
 - Γ£ì∩╕Å Inserted several translated refinements and extra sample snippets for configuration, caching and profile installation workflows.

≡ƒô¥ [docs] HelpInfo and generated help XML updates
 - Γ£ì∩╕Å [dependency] Updateed UICultureVersion timestamps in HelpInfo.xml files for pt/ru/zh-CN to reflect documentation refresh (2025.11.05.1608 ΓåÆ 2025.11.05.1615).
 - Γ£ì∩╕Å Reflowed long description paragraphs in the module help XMLs to improve readability and to separate lists into distinct maml:para blocks.

≡ƒô¥ [docs] Documentation index & summary artifacts updated
 - Γ£ì∩╕Å Updated DOCUMENTATION_EXPANSION_SUMMARY.md, DOCUMENTATION_INDEX.md, DOCUMENTATION_STATUS_REPORT.md, HELP_ENHANCEMENTS_SUMMARY.md and related artifacts: reflowed tables, aligned columns, improved metrics and "Last Updated" formatting (converted trailing bullets to underscored metadata).
 - Γ£ì∩╕Å README.md: small table alignment fixes and clarified Get-Help -Online behavior wording.

Γ£¿ [feat] help-redirect.html ΓÇö rewrite for robust language detection & redirects
 - Γ£¿ Normalized doctype and modernized HTML head; improved language mapping and browser language probing (navigator.languages fallback), better supportedCultures mapping and safe redirect to localized markdown pages on GitHub.
 - ≡ƒô¥ UI improvements: spinner, friendly message, and explicit "Detected language" feedback prior to redirect.

≡ƒº╣ [chore] CI/config formatting and docs support fixes
 - ≡ƒº╣ _config.yml: normalized plugin list indentation for Jekyll site config.
 - ≡ƒº╣ codecov.yml: comment spacing & inline comment normalizations; minor whitespace cleanups in ignored paths to reduce diff noise.
 - ≡ƒº╣ Updated multiple docs (Development.md, CODECOV_JUNIT_SETUP.md, NPM_SCRIPTS.md, Publishing.md, QUICK_REFERENCE.md) to fix table alignment, wording, and code-block formatting.

≡ƒô¥ [docs] micro-fixes & release artifacts
 - Γ£ì∩╕Å Cleaned dist release notes templates (dist/LatestReleaseNotes.md, dist/PowerShellGalleryReleaseNotes.md): removed empty placeholders, reflowed contributor/license blocks and ensured git-cliff footer note is present.
 - Γ£ì∩╕Å Minor localized help adjustments: consistent quoting, added minor explanatory text and small example expansions across many command docs (Get-ColorScriptList, Show-ColorScript, New-ColorScript, New-ColorScriptCache, Clear-ColorScriptCache, etc.).

≡ƒº¬ [test] Validation notes and guardrails
 - ≡ƒöì Conversion & split scripts now emit warnings array for conversion anomalies (parser/CSI/ESC warnings). CLI surfaces top warnings and summarizes them for troubleshooting.
 - ≡ƒöü Conversion pipeline improved to return programmatic values enabling unit-style verification in future tests.

Notes / Impact
 - ≡ƒöö Primary focus: stabilise and modernize the ANSI ΓåÆ PowerShell conversion pipeline and make CLI splitting deterministic and extensible.
 - ≡ƒº╛ Secondary focus: large documentation/localization cleanup for better UX and consistent help output across supported locales.
 - ΓÜá∩╕Å Backwards compatibility: conversion CLI options were extended; calling scripts that relied on older export names should adapt to the exported function names (convertAnsiToPs1/readAnsiFile/etc.). Review calling points if external automation used prior private exports.
 - Γ£à This commit bundles code + doc + tooling changes because they are tightly coupled: new formatting toolchain ensures consistent style for the refactored JS and the regenerated help content.

Files / areas touched (non-exhaustive)
 - src/scripts: Convert-AnsiToColorScript.js (major), Split-AnsiFile.js (major)
 - package.json & package-lock.json (prettier + plugins)
 - docs/ & docs/*.md (many updates), docs/help-redirect.html (rewrite)
 - [ColorScripts-Enhanced](https://github.com/Nick2bad4u/PS-Color-Scripts-Enhanced)/{pt,ru,zh-CN}/**/*.md and help.xml (localized docs & UICultureVersion bumps)
 - dist/*.md (release notes)
 - README.md, _config.yml, codecov.yml, various DOCUMENTATION_*.md and HELP_ENHANCEMENTS_SUMMARY.md

ΓÇö End of changes

Signed-off-by: Nick2bad4u <20943337+Nick2bad4u@users.noreply.github.com> [`(35c5457)`](https://github.com/Nick2bad4u/PS-Color-Scripts-Enhanced/commit/35c545788bf9d6908d9fbe0f478a60a3f6edfd00)



### ≡ƒÆ╝ Other

- ≡ƒöº [build] [dependency] Update ModuleVersion 2025.11.05.1608 and sync localized Help UICultureVersion stamps
 - ≡ƒöº Update [ColorScripts-Enhanced](https://github.com/Nick2bad4u/PS-Color-Scripts-Enhanced).psd1: set ModuleVersion = '2025.11.05.1608' and update ReleaseNotes header to match
 - ≡ƒöº Sync SupportedUICultures/UICultureVersion => '2025.11.05.1608' in localized HelpInfo.xml files (de, en-US, es, fr, it, ja, nl, pt, ru, zh-CN)

≡ƒº¬ [test] Skip Linux CI for flaky import-fallback test
 - ≡ƒº¬ Tests/[ColorScripts-Enhanced](https://github.com/Nick2bad4u/PS-Color-Scripts-Enhanced).InternalCoverage.Tests.ps1: add -Skip:($IsLinux -and $env:CI) to It "continues to next candidate when import fails and succeeds on fallback" to avoid intermittent failures on Linux CI

Signed-off-by: Nick2bad4u <20943337+Nick2bad4u@users.noreply.github.com> [`(3493565)`](https://github.com/Nick2bad4u/PS-Color-Scripts-Enhanced/commit/3493565c56ef825fe5c4ed7cf25603e0141637b7)






## [2025.11.5.2004] - 2025-11-05


[[e218e6f](https://github.com/Nick2bad4u/PS-Color-Scripts-Enhanced/commit/e218e6ffdfa86b55262e0b533f919290f1966066)...
[e218e6f](https://github.com/Nick2bad4u/PS-Color-Scripts-Enhanced/commit/e218e6ffdfa86b55262e0b533f919290f1966066)]
([compare](https://github.com/Nick2bad4u/PS-Color-Scripts-Enhanced/compare/e218e6ffdfa86b55262e0b533f919290f1966066...e218e6ffdfa86b55262e0b533f919290f1966066))


### ≡ƒÆ╝ Other

- ≡ƒ¢á∩╕Å [fix] Preserve IDictionary semantics in ConvertTo-HashtableInternal

 - ≡ƒ¢á∩╕Å Private/ConvertTo-HashtableInternal.ps1: add an explicit branch that detects System.Collections.IDictionary before the IEnumerable branch. Enumerate via GetEnumerator() and recursively convert each entry.Value with ConvertTo-HashtableInternal to produce a plain hashtable keyed by the original dictionary keys.
 - ≡ƒ¢á∩╕Å Rationale: prevents dictionary-like objects from being treated as generic IEnumerable and flattened into arrays during JSON/PSCustomObject normalization, preserving key/value structure for deterministic merging, caching and metadata paths.

≡ƒöº [build] [dependency] Update ModuleVersion 2025.11.05.1448 and sync localized help UICultureVersion stamps

 - ≡ƒöº [ColorScripts-Enhanced](https://github.com/Nick2bad4u/PS-Color-Scripts-Enhanced)/[ColorScripts-Enhanced](https://github.com/Nick2bad4u/PS-Color-Scripts-Enhanced).psd1: ModuleVersion -> '2025.11.05.1448' and update ReleaseNotes header to match.
 - ≡ƒöº Localized help: update SupportedUICulture UICultureVersion -> '2025.11.05.1448' for de, en-US, es, fr, it, ja, nl, pt, ru, zh-CN HelpInfo.xml files to keep manifest/help metadata consistent.

≡ƒº╣ [chore] Reset packaged changelog artifacts to Unreleased

 - ≡ƒº╣ dist/LatestReleaseNotes.md & dist/PowerShellGalleryReleaseNotes.md: replace generated release content with a clean "## [Unreleased]" header to clear packaged changelog artifacts for the next release.

Signed-off-by: Nick2bad4u <20943337+Nick2bad4u@users.noreply.github.com> [`(e218e6f)`](https://github.com/Nick2bad4u/PS-Color-Scripts-Enhanced/commit/e218e6ffdfa86b55262e0b533f919290f1966066)






## [2025.11.5.1717] - 2025-11-05


[[d46ecc4](https://github.com/Nick2bad4u/PS-Color-Scripts-Enhanced/commit/d46ecc47d8bea09dff9f9bc74fd8804fa7344ed3)...
[fdd2435](https://github.com/Nick2bad4u/PS-Color-Scripts-Enhanced/commit/fdd2435709b0d0b4965a812e92734d7202948d9a)]
([compare](https://github.com/Nick2bad4u/PS-Color-Scripts-Enhanced/compare/d46ecc47d8bea09dff9f9bc74fd8804fa7344ed3...fdd2435709b0d0b4965a812e92734d7202948d9a))


### ≡ƒÆ╝ Other

- ≡ƒöº [build] [dependency] Update ModuleVersion 2025.11.05.1155 and sync localized Help UICultureVersion stamps

- ≡ƒöº PSD1: update ModuleVersion in [ColorScripts-Enhanced](https://github.com/Nick2bad4u/PS-Color-Scripts-Enhanced).psd1 from '2025.11.05.1122' ΓåÆ '2025.11.05.1155'
 - ≡ƒöº Update ReleaseNotes header to match new ModuleVersion

- ≡ƒöº HelpInfo: sync SupportedUICultureVersion to '2025.11.05.1155' across localized help files (de, en-US, es, fr, it, ja, nl, pt, ru, zh-CN)
 - ≡ƒöº Ensure manifest and localized help metadata remain consistent for packaging, docs and tooling

Signed-off-by: Nick2bad4u <20943337+Nick2bad4u@users.noreply.github.com> [`(fdd2435)`](https://github.com/Nick2bad4u/PS-Color-Scripts-Enhanced/commit/fdd2435709b0d0b4965a812e92734d7202948d9a)


- ≡ƒ¢á∩╕Å [fix] Harden localized message import and enforce dictionary results

 - ≡ƒ¢á∩╕Å [fix] Private/Import-LocalizedMessagesFromFile.ps1: when Import-LocalizedData returns a non-IDictionary result, attempt conversion via ConvertTo-HashtableInternal instead of silently discarding the payload; add Write-ModuleTrace diagnostics for conversion attempts, failures and exceptions and fall back to $null only when conversion fails.
 - ≡ƒ¢á∩╕Å [fix] Private/Import-LocalizedMessagesFromFile.ps1: for the Import-PowerShellDataFile fallback, try ConvertTo-HashtableInternal on non-IDictionary results, write trace output on exceptions and either adopt the converted IDictionary or throw a clear InvalidOperationException (preserving inner exception on conversion errors). Ensures callers receive a dictionary or a deterministic failure.
 - ≡ƒ¢á∩╕Å [fix] Public/Add-ColorScriptProfile.ps1: add cross-platform validation to reject Windows drive-letter rooted paths on non-Windows hosts; invoke Invoke-ColorScriptError with the localized UnableToResolveProfilePath message and proper ErrorCategory/ErrorId to surface a localized, structured error instead of proceeding with an invalid profile path.

 - ≡ƒöº [build] [ColorScripts-Enhanced](https://github.com/Nick2bad4u/PS-Color-Scripts-Enhanced).psd1: bump ModuleVersion -> '2025.11.05.1122' and update the ReleaseNotes header version to match the manifest change (keeps packaging/publishing metadata consistent).

 - ≡ƒöº [build] Localized help: synchronize SupportedUICulture UICultureVersion -> '2025.11.05.1122' across localized HelpInfo.xml files (de, en-US, es, fr, it, ja, nl, pt, ru, zh-CN) so help metadata matches the manifest.

 - ≡ƒô¥ [docs] Documentation & package metadata: update docs (DOCUMENTATION_INDEX.md, MODULE_SUMMARY.md, QUICK_REFERENCE.md and related doc copies) to reflect the expanded colorscript count (498+), update "Last updated" / "Documentation Updated" timestamps to November 5, 2025, and adjust ModuleVersion references in documentation; update package.json description to advertise 498+ colorscripts.

 - ≡ƒº╣ [chore] Distribution artifacts: refresh dist/LatestReleaseNotes.md and dist/PowerShellGalleryReleaseNotes.md to include the localization hardening, manifest/help sync and other release notes and to set the release header for this publish.

Signed-off-by: Nick2bad4u <20943337+Nick2bad4u@users.noreply.github.com> [`(d46ecc4)`](https://github.com/Nick2bad4u/PS-Color-Scripts-Enhanced/commit/d46ecc47d8bea09dff9f9bc74fd8804fa7344ed3)






## Contributors
Thanks to all the [contributors](https://github.com/Nick2bad4u/PS-Color-Scripts-Enhanced/graphs/contributors) for their hard work!
## License
This project is licensed under the [MIT License](https://github.com/Nick2bad4u/PS-Color-Scripts-Enhanced/blob/main/LICENSE)
*This changelog was automatically generated with [git-cliff](https://github.com/orhun/git-cliff).*

