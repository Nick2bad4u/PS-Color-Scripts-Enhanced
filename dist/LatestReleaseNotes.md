<!-- markdownlint-disable -->
<!-- eslint-disable markdown/no-missing-label-refs -->
# Changelog

All notable changes to this project will be documented in this file.

## [Unreleased]


[[1b64861](https://github.com/Nick2bad4u/PS-Color-Scripts-Enhanced/commit/1b6486183ff5bd8b1677fd58c92b25b9fba5a2c5)...
[2f649f1](https://github.com/Nick2bad4u/PS-Color-Scripts-Enhanced/commit/2f649f1ef999d4fc52a857b9f4dcf3306c9e1f95)]
([compare](https://github.com/Nick2bad4u/PS-Color-Scripts-Enhanced/compare/1b6486183ff5bd8b1677fd58c92b25b9fba5a2c5...2f649f1ef999d4fc52a857b9f4dcf3306c9e1f95))


### 💼 Other

- ✨ [feat] Enhance [ColorScripts-Enhanced](https://github.com/Nick2bad4u/PS-Color-Scripts-Enhanced) PowerShell Module
 - 📝 Update README.md to credit original developers and add download/version badges
 - 📝 Revise documentation to reflect the increase in colorscripts from 498 to 3156
 - ⚡ Improve caching functionality to include Pokémon scripts with new parameters
 - 🛠️ Modify Add-ColorScriptProfile function to support new options for including/excluding Pokémon scripts
 - 🧪 Add tests for new functionality in Add-ColorScriptProfile, ensuring proper handling of Pokémon scripts
 - 📝 Update release notes for version 2025.12.4.134, summarizing recent changes and dependency updates
 - 🎨 Refactor build scripts to improve documentation copying and link adjustments
 - 🧹 Clean up development documentation to reflect accurate colorscript counts and improve clarity

Signed-off-by: Nick2bad4u <20943337+Nick2bad4u@users.noreply.github.com> [`(2f649f1)`](https://github.com/Nick2bad4u/PS-Color-Scripts-Enhanced/commit/2f649f1ef999d4fc52a857b9f4dcf3306c9e1f95)


- ⭐[feat] add 2500 pokemon colorscripts

Signed-off-by: Nick2bad4u <20943337+Nick2bad4u@users.noreply.github.com> [`(ca8e7d0)`](https://github.com/Nick2bad4u/PS-Color-Scripts-Enhanced/commit/ca8e7d084a0a369c1ebce3520e4a56970f1579ce)


- ✨ [feat] Enhance Show-ColorScript functionality
 - 🆕 Add -ExcludeCategory and -ExcludePokemon parameters to Show-ColorScript for improved filtering options
 - 📝 Update documentation in multiple languages to reflect new parameters and usage examples
 - 📜 Add new examples demonstrating the use of -ExcludePokemon and -ExcludeCategory in Show-ColorScript
 - 📝 Revise help text for parameters to include descriptions for -ExcludeCategory and -ExcludePokemon

📝 [docs] Update module summary and quick reference
 - 📖 Include usage of -ExcludePokemon in module summary and quick reference documentation

🛠️ [fix] Introduce Add-PokemonNames script
 - 🆕 Create a new script to append Pokémon names to existing Pokémon color scripts
 - 🎨 Implement color extraction from existing script content for visual consistency
 - 📜 Add detailed comments and examples for clarity on script usage and parameters

Signed-off-by: Nick2bad4u <20943337+Nick2bad4u@users.noreply.github.com> [`(1fca9b5)`](https://github.com/Nick2bad4u/PS-Color-Scripts-Enhanced/commit/1fca9b57b0bdea680e103cf11ea05ba1cf0c2ffa)


- ⭐[feat] add 2500 pokemon colorscripts

Signed-off-by: Nick2bad4u <20943337+Nick2bad4u@users.noreply.github.com> [`(42e9e12)`](https://github.com/Nick2bad4u/PS-Color-Scripts-Enhanced/commit/42e9e12e188c92699b96c503d3360317097befab)


- ⭐[feat] add 2500 pokemon colorscripts

Signed-off-by: Nick2bad4u <20943337+Nick2bad4u@users.noreply.github.com> [`(6bed0f7)`](https://github.com/Nick2bad4u/PS-Color-Scripts-Enhanced/commit/6bed0f7740d4442324d74ed8eb3492050a591ddc)


- 📝 [docs] Revise README.md for clarity and structure
 - Update project description to emphasize performance and cross-platform support
 - Remove outdated badge sections and consolidate into a single badge area
 - Enhance feature list with clearer formatting and improved descriptions
 - Streamline quick start instructions for better usability
 - Add detailed sections for troubleshooting and requirements
 - Include credits for original authors and sources of ANSI art

Signed-off-by: Nick2bad4u <20943337+Nick2bad4u@users.noreply.github.com> [`(f3d439a)`](https://github.com/Nick2bad4u/PS-Color-Scripts-Enhanced/commit/f3d439ae555406e0e0e9f8dd8d6b370e2d5a4462)


- ⭐[feat] add 2500 pokemon colorscripts

Signed-off-by: Nick2bad4u <20943337+Nick2bad4u@users.noreply.github.com> [`(a3763a7)`](https://github.com/Nick2bad4u/PS-Color-Scripts-Enhanced/commit/a3763a7d67cda5cdf28264e20de43dbadb290db3)


- ✨ [feat] Enhance ANSI to ColorScript conversion with encoding options
 - Add support for UTF-8 encoding in Convert-AnsiToColorScript scripts
 - Introduce passthrough mode for direct content wrapping
 - Update parameters in Convert-AnsiToColorScript-Advanced.ps1 for encoding and passthrough
 - Modify argument parsing in Convert-AnsiToColorScript.js to handle encoding and passthrough flags
 - Improve documentation with examples for new features

Signed-off-by: Nick2bad4u <20943337+Nick2bad4u@users.noreply.github.com> [`(8de4279)`](https://github.com/Nick2bad4u/PS-Color-Scripts-Enhanced/commit/8de427953b850fd52ac1fd142785df5efe20969b)


- 🛠️ [fix] Update package.json for linting and testing improvements
 - 🔧 Removed redundant "test:linux" script definition
 - ✨ Added new linting scripts for remark:
   - "lint:remark" for linting markdown files with remark
   - "lint:remark:fix" for fixing linting issues in markdown files
 - 📦 Updated devDependencies:
   - Added "@double-great/remark-lint-alt-text" for alt text linting
   - Included various remark plugins for enhanced markdown linting capabilities
   - Ensured compatibility with existing markdown files by updating remark and related packages

Signed-off-by: Nick2bad4u <20943337+Nick2bad4u@users.noreply.github.com> [`(f887a5f)`](https://github.com/Nick2bad4u/PS-Color-Scripts-Enhanced/commit/f887a5f2b218e42afa2956186c66b7a5948895f8)


- 🔧 [build] Update dependencies and enhance PowerShell formatting options
 - 🔧 Update `markdown-link-check` from `^3.14.1` to `^3.14.2`
 - 🔧 Update `prettier-plugin-powershell` from `^2.0.6` to `^2.0.11`
 - ✨ Add new PowerShell formatting options:
   - `powershellBlankLineAfterParam`: true
   - `powershellBlankLinesBetweenFunctions`: 1
   - `powershellBraceStyle`: "1tbs"
   - `powershellIndentSize`: 4
   - `powershellIndentStyle`: "spaces"
   - `powershellKeywordCase`: "preserve"
   - `powershellLineWidth`: 120
   - `powershellPreferSingleQuote`: false
   - `powershellPreset`: "invoke-formatter"
   - `powershellRewriteWriteHost`: false
   - `powershellTrailingComma`: "none"

Signed-off-by: Nick2bad4u <20943337+Nick2bad4u@users.noreply.github.com> [`(9d61bc1)`](https://github.com/Nick2bad4u/PS-Color-Scripts-Enhanced/commit/9d61bc1f6f8cbc04b110717d377b95592534f710)


- ✨ [feat] Enhance [ColorScripts-Enhanced](https://github.com/Nick2bad4u/PS-Color-Scripts-Enhanced) module with improved caching and error handling
 - 📝 Update Portuguese and Russian translations in Messages.psd1 for better clarity and consistency
 - 📝 Add new messages for cache operation failures and initialization issues in Messages.psd1
 - 📝 Introduce new parameters in New-ColorScriptCache and Clear-ColorScriptCache cmdlets for better user control
 - 📝 Document new parameters (-Quiet, -NoAnsiOutput, -PassThru) in New-ColorScriptCache and Clear-ColorScriptCache markdown files
 - 🛠️ Modify existing tests to validate new warning messages for cache failures
 - 📝 Update QUICK_REFERENCE.md to reflect new cmdlet parameters and usage

Signed-off-by: Nick2bad4u <20943337+Nick2bad4u@users.noreply.github.com> [`(838de33)`](https://github.com/Nick2bad4u/PS-Color-Scripts-Enhanced/commit/838de3387931d3dd5c86fa4707e7cb8417522bfd)


- 🔧 [build] Update prettier-plugin-powershell to version 2.0.6

 - Upgraded the `prettier-plugin-powershell` dependency from version 2.0.1 to 2.0.6
 - This update may include bug fixes, performance improvements, and new features that enhance the formatting capabilities for PowerShell scripts
 - Ensures compatibility with the latest standards and practices in PowerShell formatting

Signed-off-by: Nick2bad4u <20943337+Nick2bad4u@users.noreply.github.com> [`(1b64861)`](https://github.com/Nick2bad4u/PS-Color-Scripts-Enhanced/commit/1b6486183ff5bd8b1677fd58c92b25b9fba5a2c5)






## Contributors
Thanks to all the [contributors](https://github.com/Nick2bad4u/PS-Color-Scripts-Enhanced/graphs/contributors) for their hard work!
## License
This project is licensed under the [MIT License](https://github.com/Nick2bad4u/PS-Color-Scripts-Enhanced/blob/main/LICENSE)
*This changelog was automatically generated with [git-cliff](https://github.com/orhun/git-cliff).*

