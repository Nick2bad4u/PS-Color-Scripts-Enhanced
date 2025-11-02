<!-- markdownlint-disable -->
<!-- eslint-disable markdown/no-missing-label-refs -->
# Changelog

All notable changes to this project will be documented in this file.

## [2025.11.2.1947] - 2025-11-02


[[6ded0ac](https://github.com/Nick2bad4u/PS-Color-Scripts-Enhanced/commit/6ded0ac9b35d2e030b72ed9b1f2bc5344c6743bf)...
[6ded0ac](https://github.com/Nick2bad4u/PS-Color-Scripts-Enhanced/commit/6ded0ac9b35d2e030b72ed9b1f2bc5344c6743bf)]
([compare](https://github.com/Nick2bad4u/PS-Color-Scripts-Enhanced/compare/6ded0ac9b35d2e030b72ed9b1f2bc5344c6743bf...6ded0ac9b35d2e030b72ed9b1f2bc5344c6743bf))


### ≡ƒÆ╝ Other

- ≡ƒÜ£ [refactor] Stabilize module-root resolution and localization loading
 - ≡ƒ¢á∩╕Å [fix] Add Get-Module -ListAvailable (ModuleBase) and respect COLOR_SCRIPTS_ENHANCED_MODULE_ROOT env var as fallback candidates so localized resources resolve from the intended module location
 - ≡ƒô¥ [docs] Add detailed import/debug tracing to a temp cs-module-root-debug.log (captures ModuleInfo, PSScriptRoot, candidate enumeration, found/not-found paths, Import-LocalizedData successes and failures) to aid diagnosis
 - ≡ƒöº [build] [dependency] Update ModuleVersion 2025.11.02.1436 and update ReleaseNotes; sync UICultureVersion entries in localized HelpInfo.xml files
 - ≡ƒº¬ [test] Set and restore COLOR_SCRIPTS_ENHANCED_MODULE_ROOT in tests to force imports from the repo module path and reduce environment-specific flakiness

Signed-off-by: Nick2bad4u <20943337+Nick2bad4u@users.noreply.github.com> [`(6ded0ac)`](https://github.com/Nick2bad4u/PS-Color-Scripts-Enhanced/commit/6ded0ac9b35d2e030b72ed9b1f2bc5344c6743bf)






## Contributors
Thanks to all the [contributors](https://github.com/Nick2bad4u/PS-Color-Scripts-Enhanced/graphs/contributors) for their hard work!
## License
This project is licensed under the [MIT License](https://github.com/Nick2bad4u/PS-Color-Scripts-Enhanced/blob/main/LICENSE)
*This changelog was automatically generated with [git-cliff](https://github.com/orhun/git-cliff).*

