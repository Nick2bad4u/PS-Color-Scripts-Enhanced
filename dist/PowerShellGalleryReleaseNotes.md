## [2025.11.6.819] - 2025-11-06


[[f8c860b](https://github.com/Nick2bad4u/PS-Color-Scripts-Enhanced/commit/f8c860b175742b74ff7309a2f66ff65a7d2f75a6)...
[f8c860b](https://github.com/Nick2bad4u/PS-Color-Scripts-Enhanced/commit/f8c860b175742b74ff7309a2f66ff65a7d2f75a6)]
([compare](https://github.com/Nick2bad4u/PS-Color-Scripts-Enhanced/compare/f8c860b175742b74ff7309a2f66ff65a7d2f75a6...f8c860b175742b74ff7309a2f66ff65a7d2f75a6))


### ≡ƒÆ╝ Other

- Γ£¿ [feat] Add localization-mode selection, on-demand cache validation docs, localized cache-summary rendering, module/help bumps, and tooling updates

- Γ£¿ [feat] Runtime localization mode & env parsing
 - Γ£¿ [ColorScripts-Enhanced](https://github.com/Nick2bad4u/PS-Color-Scripts-Enhanced).psm1: introduce $script:LocalizationMode and parse COLOR_SCRIPTS_ENHANCED_LOCALIZATION_MODE (supports 'auto', 'full', 'embedded'); honor legacy toggles COLOR_SCRIPTS_ENHANCED_FORCE_LOCALIZATION and COLOR_SCRIPTS_ENHANCED_PREFER_EMBEDDED_MESSAGES.
 - Γ£¿ [ColorScripts-Enhanced](https://github.com/Nick2bad4u/PS-Color-Scripts-Enhanced).psm1: pass -UseDefaultCandidates to Initialize-ColorScriptsLocalization to enable the new fallback behavior when importing localization resources.

- Γ£¿ [feat] Embedded-defaults preference & PSD1 probing
 - Γ£¿ Private/Initialize-ColorScriptsLocalization.ps1: add -UseDefaultCandidates switch and $useDefaultCandidatesFlag; compute preferredCulture from CurrentUICulture and implement preferEmbeddedDefaults logic for 'Embedded' and 'Auto'+UseDefaultCandidates flows.
 - Γ£¿ Private/Initialize-ColorScriptsLocalization.ps1: probe candidatePaths for Messages.psd1 (preferred culture chain + fallback en-US/en) and, when no localized resources exist and embedded defaults are preferred, set $script:Messages to the embedded defaults and populate LocalizationDetails.Source = 'EmbeddedDefaults' (with trace output).

- ≡ƒ¢á∩╕Å [fix] Localize and ANSI-color cache summaries
 - ≡ƒ¢á∩╕Å Public/New-ColorScriptCache.ps1 & Public/Clear-ColorScriptCache.ps1: read format strings from $script:Messages.CacheBuildSummaryFormat and CacheClearSummaryFormat (with sane fallbacks), format summary values, build an ANSI-colored summary segment via New-ColorScriptAnsiText (-Color 'Cyan') and pass that segment to Write-ColorScriptInformation for consistent, localizable output.

- ≡ƒô¥ [docs] Document -ValidateCache and localization modes
 - ≡ƒô¥ README.md, docs/Development.md, docs/MODULE_SUMMARY.md: add usage and guidance for forcing cache validation and for the new localization modes; recommend COLOR_SCRIPTS_ENHANCED_LOCALIZATION_MODE over legacy toggles.
 - ≡ƒô¥ en-US/Show-ColorScript.md & en-US help XML: add -ValidateCache parameter docs and guidance to force metadata validation before rendering; show examples and environment-variable usage (COLOR_SCRIPTS_ENHANCED_VALIDATE_CACHE).

- ≡ƒº╣ [chore] Add cache-summary message keys to localized resources
 - ≡ƒº╣ en-US + localized Messages.psd1 (de, es, fr, it, ja, nl, pt, ru, zh-CN): add CacheBuildSummaryFormat and CacheClearSummaryFormat entries so cache summaries can be localized/overridden via PSD1 files.

- ≡ƒöº [build] [dependency] Update module manifest and localized help stamps; regenerate release artifacts
 - ≡ƒöº [ColorScripts-Enhanced](https://github.com/Nick2bad4u/PS-Color-Scripts-Enhanced).psd1: bump ModuleVersion => '2025.11.06.0250' and update Generated on stamp.
 - ≡ƒöº localized HelpInfo.xml files (en-US, de, es, fr, it, ja, nl, pt, ru, zh-CN): synchronize UICultureVersion => '2025.11.06.0250'.
 - ≡ƒöº dist/LatestReleaseNotes.md & dist/PowerShellGalleryReleaseNotes.md: regenerate release headers/content to reflect the changes.

- ≡ƒöº [build] Formatting/tooling: add PowerShell Prettier plugin
 - ≡ƒöº .prettierrc: enable "prettier-plugin-powershell" in the plugin list.
 - ≡ƒöº package.json & package-lock.json: bump prettier-plugin-powershell to ^1.0.5 and update lockfile metadata.

- ≡ƒº¬ [test] Align tests with signature changes
 - ≡ƒº¬ Tests/[ColorScripts-Enhanced](https://github.com/Nick2bad4u/PS-Color-Scripts-Enhanced).ModuleImportCoverage.Tests.ps1: update Initialize-ColorScriptsLocalization stubs to accept [switch]$UseDefaultCandidates and null-assign it to keep test stubs compatible with the new signature.

- ≡ƒº╣ [chore] Minor wiring & consistency
 - ≡ƒº╣ Ensure module import uses the new -UseDefaultCandidates flag so the embedded-defaults preference path is exercised during import initialization.

Signed-off-by: Nick2bad4u <20943337+Nick2bad4u@users.noreply.github.com> [`(f8c860b)`](https://github.com/Nick2bad4u/PS-Color-Scripts-Enhanced/commit/f8c860b175742b74ff7309a2f66ff65a7d2f75a6)






## Contributors
Thanks to all the [contributors](https://github.com/Nick2bad4u/PS-Color-Scripts-Enhanced/graphs/contributors) for their hard work!
## License
This project is licensed under the [MIT License](https://github.com/Nick2bad4u/PS-Color-Scripts-Enhanced/blob/main/LICENSE)
*This changelog was automatically generated with [git-cliff](https://github.com/orhun/git-cliff).*

