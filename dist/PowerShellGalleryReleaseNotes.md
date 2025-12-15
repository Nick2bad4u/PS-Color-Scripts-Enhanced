## [Unreleased]


[[ae15c97](https://github.com/Nick2bad4u/PS-Color-Scripts-Enhanced/commit/ae15c97423e180fdbbdd93e482f04371a13e2404)...
[ae15c97](https://github.com/Nick2bad4u/PS-Color-Scripts-Enhanced/commit/ae15c97423e180fdbbdd93e482f04371a13e2404)]
([compare](https://github.com/Nick2bad4u/PS-Color-Scripts-Enhanced/compare/ae15c97423e180fdbbdd93e482f04371a13e2404...ae15c97423e180fdbbdd93e482f04371a13e2404))


### 💼 Other

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
This project is licensed under the [MIT License](https://github.com/Nick2bad4u/PS-Color-Scripts-Enhanced/blob/main/LICENSE)
*This changelog was automatically generated with [git-cliff](https://github.com/orhun/git-cliff).*

