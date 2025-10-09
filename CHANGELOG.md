# Changelog

All notable changes to ColorScripts-Enhanced will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project uses date-based versioning: `YYYY.MM.DD.BuildNumber`.

## 2025.10.09.1633 - 2025-10-09

### Added

- `Add-ColorScriptProfile` helper cmdlet for safe profile integration
- `Lint-Module.ps1` convenience script to run ScriptAnalyzer locally
- Extended Pester coverage for profile helper and lint checks
- Quick Start / Quick Reference updates for new command and install flow
- Cross-platform Nerd Font installation guidance for glyph-heavy scripts

### Changed

- README and module summary now lead with PowerShell Gallery installation instructions
- `Install.ps1` reuses the new helper and supports `-SkipStartupScript`
- `Test-Module.ps1` runs ScriptAnalyzer and validates profile snippets
- Publishing and development docs reference new lint pipeline and secrets
- `Lint-Module.ps1` now supports an optional `-Fix` pass before verification

### Fixed

- Ensured manual install guidance aligns with exported commands
- Updated automation docs with current secret names used by GitHub Actions

## 2025.10.09.1625 - 2025-10-09

### Added

- Comprehensive comment-based help for all functions
- External help in markdown format (MAML-compatible)
- `about_ColorScripts-Enhanced` help topic
- Individual cmdlet help files:
  - Show-ColorScript.md
  - Get-ColorScriptList.md
  - Build-ColorScriptCache.md
  - Clear-ColorScriptCache.md
- CONTRIBUTING.md with contributor guidelines
- RELEASENOTES.md with detailed version history
- Test-Module.ps1 for automated testing
- Build-Help.ps1 for help XML generation
- ScriptMetadata.psd1 with script categorization
- HelpInfoURI in module manifest
- Support for `Get-Help` with `-Full`, `-Detailed`, `-Examples`
- Support for `-WhatIf` and `-Confirm` in Clear-ColorScriptCache
- Proper parameter sets for all commands
- Pipeline input support where applicable

### Changed

- Enhanced module manifest with complete metadata
- Improved function documentation
- Updated all functions to follow PowerShell best practices
- Standardized error handling across all functions

### Fixed

- Help content now displays correctly with Get-Help
- Module metadata complies with PowerShell Gallery standards
- All exported functions properly documented

## 2025.10.09 - 2025-10-09

### Added

- OS-wide caching system in AppData
- Centralized cache location
- 6-19x performance improvement
- 185+ colorscripts included
- Automatic cache validation
- UTF-8 encoding support
- New colorscripts:
  - color-morphing.ps1
  - rainbow-spiral.ps1
  - dev-workspace.ps1
  - music-studio.ps1
  - game-setup.ps1
  - cloud-services.ps1
  - data-science.ps1
  - design-studio.ps1
  - network-tools.ps1
  - productivity-suite.ps1
  - security-tools.ps1
  - mobile-dev.ps1

### Changed

- Cache directory moved to AppData
- Improved cache file naming
- Enhanced script selection algorithm
- Better error messages

### Removed

- Animated scripts that would loop on startup:
  - matrix-rain.ps1
  - fire-effect.ps1
  - bouncing-balls.ps1
  - particle-explosion.ps1

## 2025.10.08 - 2025-10-08

### Added

- Initial public release
- Basic colorscript display functionality
- Random script selection
- Script listing capability
- Initial caching implementation
- 150+ colorscripts
- Module manifest
- Basic documentation

### Features

- Show-ColorScript command
- Get-ColorScriptList command
- Build-ColorScriptCache command
- Clear-ColorScriptCache command
- Alias 'scs' for Show-ColorScript

## Unreleased

### Planned

- Script categories filtering
- Favorite scripts management
- Custom colorscript import
- Script search functionality
- Theme support
- Web-based script browser
- Interactive colorscripts
- Community script repository
- Script editor integration

---

## Legend

- `Added` - New features
- `Changed` - Changes in existing functionality
- `Deprecated` - Soon-to-be removed features
- `Removed` - Removed features
- `Fixed` - Bug fixes
- `Security` - Security fixes
