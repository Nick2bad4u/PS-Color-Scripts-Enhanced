# ColorScripts-Enhanced Documentation Index

Complete guide to all documentation files in this repository.

## Quick Links

- **Getting Started**: [README.md](../README.md)
- **Quick Reference**: [QUICK_REFERENCE.md](QUICK_REFERENCE.md)
- **Contributing**: [CONTRIBUTING.md](../CONTRIBUTING.md)
- **License**: [LICENSE](../LICENSE)

## User Documentation

### Installation & Setup

| Document                                                              | Description                                                       |
| --------------------------------------------------------------------- | ----------------------------------------------------------------- |
| [README.md](../README.md)                                             | Main project documentation with installation, usage, and examples |
| [ColorScripts-Enhanced/README.md](../ColorScripts-Enhanced/README.md) | Module-specific documentation (identical to main README)          |
| [QUICK_REFERENCE.md](QUICK_REFERENCE.md)                              | Command reference and common usage patterns                       |

### Command Help

All commands have detailed help documentation in `ColorScripts-Enhanced/en-US/`:

| Command                          | Help File                                                                                             |
| -------------------------------- | ----------------------------------------------------------------------------------------------------- |
| `Show-ColorScript`               | [Show-ColorScript.md](../ColorScripts-Enhanced/en-US/Show-ColorScript.md)                             |
| `Get-ColorScriptList`            | [Get-ColorScriptList.md](../ColorScripts-Enhanced/en-US/Get-ColorScriptList.md)                       |
| `New-ColorScriptCache`         | [New-ColorScriptCache.md](../ColorScripts-Enhanced/en-US/New-ColorScriptCache.md)                 |
| `Clear-ColorScriptCache`         | [Clear-ColorScriptCache.md](../ColorScripts-Enhanced/en-US/Clear-ColorScriptCache.md)                 |
| `Add-ColorScriptProfile`         | [Add-ColorScriptProfile.md](../ColorScripts-Enhanced/en-US/Add-ColorScriptProfile.md)                 |
| `Get-ColorScriptConfiguration`   | [Get-ColorScriptConfiguration.md](../ColorScripts-Enhanced/en-US/Get-ColorScriptConfiguration.md)     |
| `Set-ColorScriptConfiguration`   | [Set-ColorScriptConfiguration.md](../ColorScripts-Enhanced/en-US/Set-ColorScriptConfiguration.md)     |
| `Reset-ColorScriptConfiguration` | [Reset-ColorScriptConfiguration.md](../ColorScripts-Enhanced/en-US/Reset-ColorScriptConfiguration.md) |
| `Export-ColorScriptMetadata`     | [Export-ColorScriptMetadata.md](../ColorScripts-Enhanced/en-US/Export-ColorScriptMetadata.md)         |
| `New-ColorScript`                | [New-ColorScript.md](../ColorScripts-Enhanced/en-US/New-ColorScript.md)                               |

**Module Help**: [about_ColorScripts-Enhanced.help.txt](../ColorScripts-Enhanced/en-US/about_ColorScripts-Enhanced.help.txt)

### Technical Guides

| Document                                             | Description                                          |
| ---------------------------------------------------- | ---------------------------------------------------- |
| [ANSI-COLOR-GUIDE.md](ANSI-COLOR-GUIDE.md)           | ANSI escape codes reference and color palette guide  |
| [ANSI-CONVERSION-GUIDE.md](ANSI-CONVERSION-GUIDE.md) | Converting ANSI art files to PowerShell colorscripts |
| [POWERSHELL-VERSIONS.md](POWERSHELL-VERSIONS.md)     | PowerShell version compatibility matrix              |

## Developer Documentation

### Development Workflow

| Document                               | Description                                        |
| -------------------------------------- | -------------------------------------------------- |
| [Development.md](Development.md)       | Local development setup, tooling, and workflows    |
| [TESTING.md](TESTING.md)               | Testing procedures and test suite documentation    |
| [LINTING.md](LINTING.md)               | Code quality standards and linting guide           |
| [NPM_SCRIPTS.md](NPM_SCRIPTS.md)       | Reference for all npm scripts available            |
| [MODULE_SUMMARY.md](MODULE_SUMMARY.md) | Complete module implementation overview            |
| [CONTRIBUTING.md](../CONTRIBUTING.md)  | How to contribute code, scripts, and documentation |

### Release & Publishing

| Document                                   | Description                                                      |
| ------------------------------------------ | ---------------------------------------------------------------- |
| [Publishing.md](Publishing.md)             | Publishing to PowerShell Gallery, NuGet.org, and GitHub Packages |
| [ReleaseChecklist.md](ReleaseChecklist.md) | Step-by-step release checklist with git-cliff integration        |
| [CHANGELOG.md](../CHANGELOG.md)            | Complete project changelog                                       |

### Project Management

| Document                           | Description                                     |
| ---------------------------------- | ----------------------------------------------- |
| [ROADMAP.md](ROADMAP.md)           | Project roadmap and planned features            |
| [SUPPORT.md](SUPPORT.md)           | Support channels and response time expectations |
| [CONTRIBUTORS.md](CONTRIBUTORS.md) | List of project contributors                    |
| [todo.md](../todo.md)              | Development tasks and action items              |

## Repository Policies

| Document                                    | Description                                 |
| ------------------------------------------- | ------------------------------------------- |
| [CODE_OF_CONDUCT.md](../CODE_OF_CONDUCT.md) | Community code of conduct                   |
| [SECURITY.md](../SECURITY.md)               | Security policy and vulnerability reporting |
| [LICENSE](../LICENSE)                       | MIT License terms                           |

## Configuration Files

| File                                                              | Purpose                                          |
| ----------------------------------------------------------------- | ------------------------------------------------ |
| [cliff.toml](../cliff.toml)                                       | git-cliff configuration for changelog generation |
| [PSScriptAnalyzerSettings.psd1](../PSScriptAnalyzerSettings.psd1) | ScriptAnalyzer rules and settings                |
| [package.json](../package.json)                                   | npm scripts and Node.js dependencies             |
| [.github/workflows/](../.github/workflows/)                       | GitHub Actions CI/CD workflows                   |

## Example Files

| Location                                                         | Description                                              |
| ---------------------------------------------------------------- | -------------------------------------------------------- |
| [docs/examples/ansi-conversion/](./examples/ansi-conversion/)    | ANSI art conversion examples and samples                 |
| [assets/ansi-files/](../assets/ansi-files/)                      | Source ANSI art files for conversion                     |
| [docs/oversized-colorscripts/](../assets/oversized-colorscripts) | Large colorscripts that don't fit in main Scripts folder |

## Special Setup Guides

| Document                                   | Description                              |
| ------------------------------------------ | ---------------------------------------- |
| [MEGALINTER-SETUP.md](MEGALINTER-SETUP.md) | MegaLinter configuration and usage guide |

## Need Help?

### Using PowerShell Help System

PowerShell uses the `Get-Help` cmdlet instead of traditional `--help` flags:

```powershell
# Get basic help
Get-Help Show-ColorScript

# Get detailed help with examples
Get-Help Show-ColorScript -Full

# Get only examples
Get-Help Show-ColorScript -Examples

# Get help for a specific parameter
Get-Help Show-ColorScript -Parameter Name

# Module help
Get-Help about_ColorScripts-Enhanced

# List all help topics
Get-Help *ColorScript*
```

**Note**: Traditional CLI flags like `Show-ColorScript --help`, `-h`, or `-?` will not work. Use `Get-Help` instead.

### Other Resources

- **Quick answers**: [QUICK_REFERENCE.md](QUICK_REFERENCE.md)
- **Issues**: [GitHub Issues](https://github.com/Nick2bad4u/ps-color-scripts-enhanced/issues)
- **Support**: [SUPPORT.md](SUPPORT.md)

## Version Information

- **Module Version**: 2025.10.13.1537
- **Colorscripts**: 245+
- **Functions**: 10
- **PowerShell**: 5.1+ and 7.0+
- **Platforms**: Windows, macOS, Linux

---

_Last updated: October 13, 2025_
