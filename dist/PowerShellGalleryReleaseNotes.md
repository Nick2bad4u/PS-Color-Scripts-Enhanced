## [2025.10.30.533] - 2025-10-30


[[e315754](https://github.com/Nick2bad4u/PS-Color-Scripts-Enhanced/commit/e315754d5b149215d19be0bacfa42908eeca26eb)...
[e315754](https://github.com/Nick2bad4u/PS-Color-Scripts-Enhanced/commit/e315754d5b149215d19be0bacfa42908eeca26eb)]
([compare](https://github.com/Nick2bad4u/PS-Color-Scripts-Enhanced/compare/e315754d5b149215d19be0bacfa42908eeca26eb...e315754d5b149215d19be0bacfa42908eeca26eb))


### ≡ƒ¢á∩╕Å GitHub Actions

- ≡ƒÜ£ [refactor] Rename Build-ColorScriptCache ΓåÆ New-ColorScriptCache, add Update-ColorScriptCache alias and propagate changes

 - Γ£¿ [feat] Introduce New-ColorScriptCache as the public cmdlet (rename of Build-ColorScriptCache) and register alias Update-ColorScriptCache; bump module manifest version/date and export aliases.
 - ≡ƒÜ£ [refactor] Replace Build-ColorScriptCache references across the codebase ([ColorScripts-Enhanced](https://github.com/Nick2bad4u/PS-Color-Scripts-Enhanced).psm1/psd1, scripts/, tests/, build tooling, generated help, README and docs/), adding New-ColorScriptCache usages and help pages.
 - ≡ƒ¢á∩╕Å [fix] Add ConvertFrom-JsonToHashtable helper for PowerShell 5.1 compatibility and switch JSON cache parsing to use it; normalize Set-Content invocation when writing JSON caches.
 - ≡ƒº¬ [test] Update Pester tests to assert New-ColorScriptCache export and behavior; adapt test calls and expectations accordingly.
 - ≡ƒº╣ [chore] Add .coverage tooling and documentation (.coverage/README.md, .gitignore, DebugCoverageTests.ps1, ShowCoverageSummary.ps1, metadata-cache-test.ps1), add context7.json, and adjust repo config (.gitignore, .mega-linter.yml) and generated dist/release notes.
 - ≡ƒô¥ [docs] Add en-US New-ColorScriptCache help file, update help XML and all docs/examples to reference the new command name.
 - ≡ƒÄ¿ [style] Minor content fixes (httpΓåÆhttps in assets, "TODO List" ΓåÆ "Improvements List") and refresh generated HelpInfo UICultureVersion.

Signed-off-by: Nick2bad4u <20943337+Nick2bad4u@users.noreply.github.com> [`(e315754)`](https://github.com/Nick2bad4u/PS-Color-Scripts-Enhanced/commit/e315754d5b149215d19be0bacfa42908eeca26eb)






## Contributors
Thanks to all the [contributors](https://github.com/Nick2bad4u/PS-Color-Scripts-Enhanced/graphs/contributors) for their hard work!
## License
This project is licensed under the [MIT License](https://github.com/Nick2bad4u/PS-Color-Scripts-Enhanced/blob/main/LICENSE)
*This changelog was automatically generated with [git-cliff](https://github.com/orhun/git-cliff).*

