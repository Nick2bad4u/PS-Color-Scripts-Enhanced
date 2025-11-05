<!-- markdownlint-disable -->
<!-- eslint-disable markdown/no-missing-label-refs -->
# Changelog

All notable changes to this project will be documented in this file.

## [2025.11.2.2244] - 2025-11-02


[[81844d2](https://github.com/Nick2bad4u/PS-Color-Scripts-Enhanced/commit/81844d2c6c419288b48fb36831872b53e53f37ca)...
[81844d2](https://github.com/Nick2bad4u/PS-Color-Scripts-Enhanced/commit/81844d2c6c419288b48fb36831872b53e53f37ca)]
([compare](https://github.com/Nick2bad4u/PS-Color-Scripts-Enhanced/compare/81844d2c6c419288b48fb36831872b53e53f37ca...81844d2c6c419288b48fb36831872b53e53f37ca))


### ≡ƒÆ╝ Other

- ≡ƒÜ£ [refactor] Stabilize module-root discovery and implement robust localization loader

 - ≡ƒÜ£ [refactor] Add Resolve-LocalizedMessagesFile, Import-LocalizedMessagesFromFile and Initialize-ColorScriptsLocalization to reliably locate and import Messages.psd1 (culture-folder enumeration, case-insensitive matching, ProviderPath resolution, root fallback).
 - Γ£¿ [feat] Embed default English messages ($script:EmbeddedDefaultMessages) and fall back gracefully when no localized resources are found; preserve ModuleRoot and emit a warning when falling back.
 - ≡ƒ¢á∩╕Å [fix] Harden module import tracing and null handling for $moduleInfo; write detailed cs-module-root-debug.log entries for ModuleInfo, PSScriptRoot, candidate evaluation and localization import outcomes.
 - ≡ƒº¬ [test] Add comprehensive "Localization resolution" unit tests (culture enumeration, root fallback, ConvertFrom-StringData payload import, Import-PowerShellDataFile import, error-recovery path) and initialize localization in test setup; record module root in-module scope for deterministic imports.
 - ≡ƒöº [build] [dependency] Update ModuleVersion 2025.11.02.1734 and synchronize ReleaseNotes and HelpInfo UICultureVersion entries across localized HelpInfo.xml files.
 - ≡ƒô¥ [docs] Refresh dist release notes and PowerShellGallery metadata to reflect the localization refactor and version bump.

Signed-off-by: Nick2bad4u <20943337+Nick2bad4u@users.noreply.github.com> [`(81844d2)`](https://github.com/Nick2bad4u/PS-Color-Scripts-Enhanced/commit/81844d2c6c419288b48fb36831872b53e53f37ca)






## Contributors
Thanks to all the [contributors](https://github.com/Nick2bad4u/PS-Color-Scripts-Enhanced/graphs/contributors) for their hard work!
## License
This project is licensed under the [MIT License](https://github.com/Nick2bad4u/PS-Color-Scripts-Enhanced/blob/main/LICENSE)
*This changelog was automatically generated with [git-cliff](https://github.com/orhun/git-cliff).*

