## [2025.11.6.352] - 2025-11-06


[[4deea4a](https://github.com/Nick2bad4u/PS-Color-Scripts-Enhanced/commit/4deea4ab51544020576ac95418b98be43a4472c9)...
[4deea4a](https://github.com/Nick2bad4u/PS-Color-Scripts-Enhanced/commit/4deea4ab51544020576ac95418b98be43a4472c9)]
([compare](https://github.com/Nick2bad4u/PS-Color-Scripts-Enhanced/compare/4deea4ab51544020576ac95418b98be43a4472c9...4deea4ab51544020576ac95418b98be43a4472c9))


### ≡ƒÆ╝ Other

- Γ£¿ [feat] Add cache-format upgrade workflow, manual validation override, and Show-ColorScript -ValidateCache
 - Γ£¿ Private/Ensure-CacheFormatVersion.ps1: add Set-CacheValidationOverride to let callers force cache validation; setting the override resets $script:CacheValidationPerformed so initialization will re-run validation.
 - Γ£¿ Private/Ensure-CacheFormatVersion.ps1: extend Update-CacheFormatVersion to accept -MetadataFileName and write metadata using [int]$script:CacheFormatVersion (Version, ModuleVersion, UpdatedUtc).
 - Γ£¿ Private/Ensure-CacheFormatVersion.ps1: implement purge of obsolete cache-metadata*.json files (remove files whose name != current MetadataFileName) with robust try/catch and Write-Verbose diagnostics to avoid breaking init on IO/parse failures.

≡ƒÜ£ [refactor] Integrate cache validation into initialization and add env override
 - ≡ƒÜ£ Private/Initialize-CacheDirectory.ps1: standardize metadata filename to 'cache-metadata-v{0}.json' and pass that name into Update-CacheFormatVersion.
 - ≡ƒÜ£ Private/Initialize-CacheDirectory.ps1: add support for COLOR_SCRIPTS_ENHANCED_VALIDATE_CACHE (accepts 1/true/yes) to force validation via environment.
 - ≡ƒÜ£ Private/Initialize-CacheDirectory.ps1: only run validation when forced (env), when manual override is set, or when validation hasn't been performed and the metadata file is missing; set $script:CacheValidationPerformed = $true after validation and clear the manual override. Apply same logic to the fallback resolution path.

Γ£¿ [feat] Public Show-ColorScript: add -ValidateCache switch
 - Γ£¿ Public/Show-ColorScript.ps1: add .PARAMETER ValidateCache documentation and new [switch]$ValidateCache parameter.
 - Γ£¿ Public/Show-ColorScript.ps1: when -ValidateCache is supplied call Set-CacheValidationOverride -Value $true so callers can force cache rebuild/validation before rendering.

≡ƒöº [build] [dependency] Update module version and release notes header
 - ≡ƒöº [ColorScripts-Enhanced](https://github.com/Nick2bad4u/PS-Color-Scripts-Enhanced)/[ColorScripts-Enhanced](https://github.com/Nick2bad4u/PS-Color-Scripts-Enhanced).psd1: bump ModuleVersion => '2025.11.05.2125' and update embedded ReleaseNotes header to match the new stamp.

≡ƒô¥ [docs] Sync localized help UICultureVersion stamps
 - ≡ƒô¥ Update localized HelpInfo.xml files (en-US, de, es, fr, it, ja, nl, pt, ru, zh-CN) to the new UICultureVersion stamp to keep manifest/help metadata consistent with the module bump.

≡ƒº¬ [test] Initialize cache-validation state in tests
 - ≡ƒº¬ Tests/*: reset $script:CacheValidationPerformed = $false and $script:CacheValidationManualOverride = $false in test setup fixtures (CoverageExpansion, InternalCoverage, TargetedCoverage) so tests run with deterministic cache-validation state.

≡ƒô¥ [docs] Regenerate packaged release artifacts
 - ≡ƒô¥ dist/LatestReleaseNotes.md & dist/PowerShellGalleryReleaseNotes.md: regenerate release notes header/content to reflect the cache-format workflow, validation changes and module/help version bumps.

Signed-off-by: Nick2bad4u <20943337+Nick2bad4u@users.noreply.github.com> [`(4deea4a)`](https://github.com/Nick2bad4u/PS-Color-Scripts-Enhanced/commit/4deea4ab51544020576ac95418b98be43a4472c9)






## Contributors
Thanks to all the [contributors](https://github.com/Nick2bad4u/PS-Color-Scripts-Enhanced/graphs/contributors) for their hard work!
## License
This project is licensed under the [MIT License](https://github.com/Nick2bad4u/PS-Color-Scripts-Enhanced/blob/main/LICENSE)
*This changelog was automatically generated with [git-cliff](https://github.com/orhun/git-cliff).*

