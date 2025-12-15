## [2025.12.15.1707] - 2025-12-15


[[ae15c97](https://github.com/Nick2bad4u/PS-Color-Scripts-Enhanced/commit/ae15c97423e180fdbbdd93e482f04371a13e2404)...
[efff7d3](https://github.com/Nick2bad4u/PS-Color-Scripts-Enhanced/commit/efff7d34b3d9072df1ea78f4545edc1bc986ce53)]
([compare](https://github.com/Nick2bad4u/PS-Color-Scripts-Enhanced/compare/ae15c97423e180fdbbdd93e482f04371a13e2404...efff7d34b3d9072df1ea78f4545edc1bc986ce53))


### 💼 Other

- 🔧 [build] Update module version and localization info

 - 🔧 Update ModuleVersion to '2025.12.15.1153' in [ColorScripts-Enhanced](https://github.com/Nick2bad4u/PS-Color-Scripts-Enhanced).psd1
 - 📝 Update ReleaseNotes to reflect changes in version 2025.12.15.1153
 - 🛠️ Enhance error handling in Get-ColorScriptsConfigurationRoot with verbose messages for cached configuration root validation
 - 🛠️ Improve error handling in Initialize-CacheDirectory with detailed trace for cache metadata stamp comparison failures
 - 🛠️ Add verbose logging in Initialize-ColorScriptsLocalization for explicit root localization import failures
 - 🌍 Update HelpInfo.xml files for multiple languages to reflect the new version '2025.12.15.1153'

Signed-off-by: Nick2bad4u <20943337+Nick2bad4u@users.noreply.github.com> [`(efff7d3)`](https://github.com/Nick2bad4u/PS-Color-Scripts-Enhanced/commit/efff7d34b3d9072df1ea78f4545edc1bc986ce53)


- ✨ [feat] Enhance cache metadata management and script inventory retrieval

 - 📝 Add Write-CacheMetadataFile function to manage cache metadata files without purging cache entries.
 - 🔧 Update Initialize-CacheDirectory to refresh metadata marker based on cache entries' timestamps.
 - ⚡ Improve Get-ColorScriptInventory by introducing a new internal function to retrieve script files more reliably.
 - 🛠️ Modify Get-ColorScriptsConfigurationRoot to allow non-destructive validation and prevent cache directory creation if not needed.
 - 🔄 Update New-ColorScriptCache and Show-ColorScript to ensure cache metadata is updated after cache operations.
 - 🧪 Add tests to ensure cache entries are preserved during validation and that metadata files are correctly created and updated.
 - 🌍 Update localization help files for multiple languages to reflect the latest version.

Signed-off-by: Nick2bad4u <20943337+Nick2bad4u@users.noreply.github.com> [`(ae15c97)`](https://github.com/Nick2bad4u/PS-Color-Scripts-Enhanced/commit/ae15c97423e180fdbbdd93e482f04371a13e2404)






## Contributors
Thanks to all the [contributors](https://github.com/Nick2bad4u/PS-Color-Scripts-Enhanced/graphs/contributors) for their hard work!
## License
This project is licensed under the [Unlicense License](https://github.com/Nick2bad4u/PS-Color-Scripts-Enhanced/blob/main/LICENSE)
*This changelog was automatically generated with [git-cliff](https://github.com/orhun/git-cliff).*

