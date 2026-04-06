# ColorScripts-Enhanced PowerShell Module

> **Credits:** This project owes its existence to the foundational work of two developers. The beautiful ANSI art scripts were originally created and/or sourced by Derek Taylor (DistroTube) in his project [shell-color-scripts](https://gitlab.com/dwt1/shell-color-scripts). The collection was then ported to PowerShell by Scott McKendry as [ps-color-scripts](https://github.com/scottmckendry/ps-color-scripts). `ColorScripts-Enhanced` builds upon their efforts by introducing a high-performance caching system, PowerShell Cross-Platform support on Linux and Mac, an expanded command set, and a formal module structure.

<!-- Download & Version Badges -->

[![PowerShell Gallery Version.](https://img.shields.io/powershellgallery/v/ColorScripts-Enhanced?logo=powershell\&label=PSGallery)](https://www.powershellgallery.com/packages/ColorScripts-Enhanced)
[![PowerShell Gallery Downloads.](https://img.shields.io/powershellgallery/dt/ColorScripts-Enhanced?logo=powershell\&label=Downloads)](https://www.powershellgallery.com/packages/ColorScripts-Enhanced)
[![NuGet Version.](https://img.shields.io/nuget/v/ColorScripts-Enhanced?logo=nuget\&label=NuGet)](https://www.nuget.org/packages/ColorScripts-Enhanced/)
[![NuGet Downloads.](https://img.shields.io/nuget/dt/ColorScripts-Enhanced?logo=nuget\&label=Downloads)](https://www.nuget.org/packages/ColorScripts-Enhanced/)
[![GitHub Release.](https://img.shields.io/github/v/release/Nick2bad4u/ps-color-scripts-enhanced?logo=github\&label=Release)](https://github.com/Nick2bad4u/ps-color-scripts-enhanced/releases/latest)

<!-- CI/CD & Quality Badges -->

[![Tests.](https://github.com/Nick2bad4u/ps-color-scripts-enhanced/actions/workflows/test.yml/badge.svg)](https://github.com/Nick2bad4u/ps-color-scripts-enhanced/actions/workflows/test.yml)
[![codecov.](https://codecov.io/gh/Nick2bad4u/PS-Color-Scripts-Enhanced/branch/main/graph/badge.svg?token=9qPuQCcXen)](https://codecov.io/gh/Nick2bad4u/PS-Color-Scripts-Enhanced)
[![Publish.](https://github.com/Nick2bad4u/ps-color-scripts-enhanced/actions/workflows/publish.yml/badge.svg)](https://github.com/Nick2bad4u/ps-color-scripts-enhanced/actions/workflows/publish.yml)
[![OpenSSF Scorecard.](https://api.scorecard.dev/projects/github.com/Nick2bad4u/PS-Color-Scripts-Enhanced/badge)](https://scorecard.dev/viewer/?uri=github.com/Nick2bad4u/PS-Color-Scripts-Enhanced)
[![Dependency Review.](https://github.com/Nick2bad4u/PS-Color-Scripts-Enhanced/actions/workflows/dependency-review.yml/badge.svg)](https://github.com/Nick2bad4u/PS-Color-Scripts-Enhanced/actions/workflows/dependency-review.yml)
[![Ask DeepWiki.](https://deepwiki.com/badge.svg)](https://deepwiki.com/Nick2bad4u/PS-Color-Scripts-Enhanced)

<!-- Platform & Compatibility -->

[![Platform.](https://img.shields.io/badge/Platform-Windows%20%7C%20macOS%20%7C%20Linux-blue?logo=windows-terminal)](https://github.com/Nick2bad4u/ps-color-scripts-enhanced)
[![PowerShell.](https://img.shields.io/badge/PowerShell-5.1%2B%20%7C%207.0%2B-blue.svg?logo=powershell)](https://github.com/PowerShell/PowerShell)
[![Code Size.](https://img.shields.io/github/languages/code-size/Nick2bad4u/ps-color-scripts-enhanced?logo=github)](https://github.com/Nick2bad4u/ps-color-scripts-enhanced)
[![Repo Stars.](https://img.shields.io/github/stars/Nick2bad4u/ps-color-scripts-enhanced?style=social)](https://github.com/Nick2bad4u/ps-color-scripts-enhanced/stargazers)

<!-- License & Contributing -->

[![License: UnLicense.](https://img.shields.io/badge/License-UnLicense-yellow.svg)](LICENSE)
[![PRs Welcome.](https://img.shields.io/badge/PRs-welcome-brightgreen.svg)](CONTRIBUTING.md)

A high-performance PowerShell module for displaying beautiful ANSI colorscripts in your terminal with intelligent caching for 6-19x faster load times.

<p align="center">
  <img src="assets/ColorScripts-Mascot-Dark.jpeg" alt="ColorScripts mascot" width="60%" />
</p>

![Examples.](https://raw.githubusercontent.com/Nick2bad4u/PS-Color-Scripts-Enhanced/refs/heads/main/assets/ColorScript-example-1.png)

## ✨ Features

- 🎨 **<!-- COLOR_SCRIPT_COUNT_PLUS -->3156+<!-- /COLOR_SCRIPT_COUNT_PLUS --> Colorscripts** — Fractals, patterns, characters, nature scenes, and more
- ⚡ **6-19x Faster** — Intelligent caching drops load times to 5-20ms
- 🌐 **Cross-Platform** — Works on Windows, macOS, and Linux
- ⚙️ **Configurable** — Persist cache location, startup behavior, and defaults
- 🖌️ **500+ Custom Made Colorscripts** — Exclusive original designs
- 🐾 **2500~ Pokémon ColorScripts** — Opt-in Pokémon-themed colorscripts
  * Note: Pokémon art is filtered by default to keep load times fast. Opt in with `-IncludePokemon` on relevant commands.
- 🌍 **10 Languages** — English, German, Spanish, French, Italian, Japanese, Dutch, Portuguese, Russian, Chinese
- 🧩 **Easy to Use** — Simple commands with tab completion
- 🗄️ **Centralized Cache** — OS-wide in `AppData/ColorScripts-Enhanced/cache`
- 🔄 **Auto-Update** — Cache invalidates automatically when scripts change
- 📚 **Complete Help** — Full comment-based help for all commands

## 🚀 Quick Start

```powershell
# Install from PowerShell Gallery
Install-Module -Name ColorScripts-Enhanced -Scope CurrentUser

# Import and display a random colorscript
Import-Module ColorScripts-Enhanced
Show-ColorScript

# Add to your profile (optional - shows colorscript on every terminal open)
Add-ColorScriptProfile
```

> Requires PowerShell 5.1+. PowerShell 7+ recommended for best performance.

## 📖 Basic Usage

```powershell
# Show a random colorscript
Show-ColorScript
scs                          # shorthand alias

# Show a specific colorscript
Show-ColorScript -Name "mandelbrot-zoom"
scs pikachu

# List all available colorscripts
Show-ColorScript -List
Get-ColorScriptList

# Filter by category
Get-ColorScriptList -Category Patterns
Get-ColorScriptList -Tag Recommended

# Include Pokémon scripts (opt-in)
Show-ColorScript -IncludePokemon
```

## ⚡ Boost Performance with Caching

```powershell
# Build cache for all scripts (recommended after install)
New-ColorScriptCache

# Rebuild cache if scripts seem stale
New-ColorScriptCache -Force

# Include Pokémon scripts when building the cache
New-ColorScriptCache -IncludePokemon

# Clear cache if needed
Clear-ColorScriptCache -All
```

## 🎨 Examples

**Add a colorscript to your terminal startup:**

```powershell
# Option 1: Use the built-in helper
Add-ColorScriptProfile

# Option 2: Manually edit your profile
notepad $PROFILE
# Add these lines:
Import-Module ColorScripts-Enhanced
Show-ColorScript

# Option 3: Always include Pokémon art
Add-ColorScriptProfile -IncludePokemon -SkipPokemonPrompt

# Pokémon are opt-in by default
- The module filters Pokémon colorscripts by default to keep startup lean.
- Opt in with `-IncludePokemon` on `Show-ColorScript`, `New-ColorScriptCache`, or `Add-ColorScriptProfile`.
- Direct Pokémon names always work (e.g., `Show-ColorScript -Name Pikachu`) even without `-IncludePokemon`.

# Tip: If Pokémon are filtered by default, specifying a Pokémon script by name still works (e.g., `Show-ColorScript -Name Pikachu`).
```

**Create a custom alias:**

```powershell
Set-Alias -Name cs -Value Show-ColorScript
```

## 🔧 Commands Reference

| Command | Alias | Description |
|---------|-------|-------------|
| `Show-ColorScript` | `scs` | Display a colorscript (random or by name) |
| `Get-ColorScriptList` | — | List available colorscripts |
| `New-ColorScriptCache` | — | Build cache for faster performance |
| `Clear-ColorScriptCache` | — | Remove cached files |
| `Add-ColorScriptProfile` | — | Add module to your PowerShell profile |

**Get help for any command:**

```powershell
Get-Help Show-ColorScript -Examples
```

## 🔤 Nerd Font Support

Some colorscripts use special glyphs that require a [Nerd Font](https://www.nerdfonts.com/). If you see boxes instead of icons:

1. Download a Nerd Font (e.g., CascadiaCode, FiraCode, JetBrainsMono)
2. Install the font and set it as your terminal font
3. Test with: `Show-ColorScript -Name nerd-font-test`

## 🐛 Troubleshooting

**Colorscript not displaying correctly?**
```powershell
Show-ColorScript -Name "scriptname" -NoCache
```

**Cache seems stale?**
```powershell
New-ColorScriptCache -Force
```

**Module not found?**
```powershell
Get-Module ColorScripts-Enhanced -ListAvailable
```

## 📋 Requirements

- **PowerShell:** 5.1+ (7+ recommended)
- **OS:** Windows 10/11, macOS 10.13+, or Linux
- **Terminal:** Any ANSI-capable terminal (Windows Terminal, VS Code, iTerm2, etc.)

---

## 📚 More Information

<details>
<summary><b>📖 User Documentation</b></summary>

- [Quick Reference Guide](docs/QUICK_REFERENCE.md)
- [ANSI Color Guide](docs/ANSI-COLOR-GUIDE.md)
- [Module Summary](docs/MODULE_SUMMARY.md)
- [Changelog](CHANGELOG.md)

</details>

<details>
<summary><b>🛠️ Developer Documentation</b></summary>

- [Development Guide](docs/DEVELOPMENT.md)
- [Testing Guide](docs/TESTING.md)
- [Linting Guide](docs/LINTING.md)
- [npm Scripts Reference](docs/NPM_SCRIPTS.md)
- [Publishing Guide](docs/PUBLISHING.md)
- [Release Checklist](docs/RELEASE_CHECKLIST.md)
- [ANSI Conversion Guide](docs/ANSI-CONVERSION-GUIDE.md)

</details>

<details>
<summary><b>🤝 Contributing & Community</b></summary>

- [Contributing Guidelines](CONTRIBUTING.md)
- [Code of Conduct](CODE_OF_CONDUCT.md)
- [Security Policy](SECURITY.md)
- [Support Policy](docs/SUPPORT.md)
- [Project Roadmap](docs/ROADMAP.md)

</details>

<details>
<summary><b>🔄 CI/CD & Quality</b></summary>

[![Tests.](https://github.com/Nick2bad4u/ps-color-scripts-enhanced/actions/workflows/test.yml/badge.svg)](https://github.com/Nick2bad4u/ps-color-scripts-enhanced/actions/workflows/test.yml)
[![Codecov.](https://codecov.io/gh/Nick2bad4u/PS-Color-Scripts-Enhanced/branch/main/graph/badge.svg)](https://codecov.io/gh/Nick2bad4u/PS-Color-Scripts-Enhanced)
[![OpenSSF Scorecard.](https://api.scorecard.dev/projects/github.com/Nick2bad4u/PS-Color-Scripts-Enhanced/badge)](https://scorecard.dev/viewer/?uri=github.com/Nick2bad4u/PS-Color-Scripts-Enhanced)

- [Test Workflow](.github/workflows/test.yml)
- [Publish Workflow](.github/workflows/publish.yml)

</details>

---

## 🙏 Credits

Built upon the work of:
- [Derek Taylor (DistroTube)](https://gitlab.com/dwt1/shell-color-scripts) — Original shell-color-scripts
- [Scott McKendry](https://github.com/scottmckendry/ps-color-scripts) — PowerShell port

ANSI art sourced from [16colo.rs](https://16colo.rs/), [ArtScene](http://artscene.textfiles.com/artpacks/), [r/ANSIart](https://www.reddit.com/r/ANSIart/), [Pokemon-Colorscripts](https://gitlab.com/phoneybadger/pokemon-colorscripts), and more artists.

## 📄 License

[Unlicense](LICENSE) — Public domain. Do whatever you want with it.

---

**Enjoy the colors!** 🌈✨

## Contributors ✨

<!-- ALL-CONTRIBUTORS-BADGE:START - Do not remove or modify this section -->
[![All Contributors.](https://img.shields.io/badge/all_contributors-5-orange.svg?style=flat-square)](#contributors-)
<!-- ALL-CONTRIBUTORS-BADGE:END -->

Thanks goes to these wonderful people ([emoji key](https://allcontributors.org/docs/en/emoji-key)):

<!-- ALL-CONTRIBUTORS-LIST:START - Do not remove or modify this section -->
<!-- prettier-ignore-start -->
<!-- markdownlint-disable -->
<table>
  <tbody>
    <tr>
      <td align="center" valign="top" width="25%"><a href="https://github.com/Nick2bad4u"><img src="https://avatars.githubusercontent.com/u/20943337?v=4?s=80" width="80px;" alt="Nick2bad4u"/><br /><sub><b>Nick2bad4u</b></sub></a><br /><a href="https://github.com/Nick2bad4u/ps-color-scripts-enhanced/issues?q=author%3ANick2bad4u" title="Bug reports">🐛</a> <a href="https://github.com/Nick2bad4u/ps-color-scripts-enhanced/commits?author=Nick2bad4u" title="Code">💻</a> <a href="https://github.com/Nick2bad4u/ps-color-scripts-enhanced/commits?author=Nick2bad4u" title="Documentation">📖</a> <a href="#ideas-Nick2bad4u" title="Ideas, Planning, & Feedback">🤔</a> <a href="#infra-Nick2bad4u" title="Infrastructure (Hosting, Build-Tools, etc)">🚇</a> <a href="#maintenance-Nick2bad4u" title="Maintenance">🚧</a> <a href="https://github.com/Nick2bad4u/ps-color-scripts-enhanced/pulls?q=is%3Apr+reviewed-by%3ANick2bad4u" title="Reviewed Pull Requests">👀</a> <a href="https://github.com/Nick2bad4u/ps-color-scripts-enhanced/commits?author=Nick2bad4u" title="Tests">⚠️</a> <a href="#tool-Nick2bad4u" title="Tools">🔧</a></td>
      <td align="center" valign="top" width="25%"><a href="https://scottmckendry.tech/"><img src="https://avatars.githubusercontent.com/u/39483124?v=4?s=80" width="80px;" alt="Scott McKendry"/><br /><sub><b>Scott McKendry</b></sub></a><br /><a href="https://github.com/Nick2bad4u/ps-color-scripts-enhanced/issues?q=author%3Ascottmckendry" title="Bug reports">🐛</a> <a href="https://github.com/Nick2bad4u/ps-color-scripts-enhanced/commits?author=scottmckendry" title="Code">💻</a> <a href="#design-scottmckendry" title="Design">🎨</a> <a href="https://github.com/Nick2bad4u/ps-color-scripts-enhanced/commits?author=scottmckendry" title="Documentation">📖</a> <a href="#example-scottmckendry" title="Examples">💡</a> <a href="#infra-scottmckendry" title="Infrastructure (Hosting, Build-Tools, etc)">🚇</a> <a href="#maintenance-scottmckendry" title="Maintenance">🚧</a> <a href="#platform-scottmckendry" title="Packaging/porting to new platform">📦</a> <a href="#plugin-scottmckendry" title="Plugin/utility libraries">🔌</a> <a href="https://github.com/Nick2bad4u/ps-color-scripts-enhanced/pulls?q=is%3Apr+reviewed-by%3Ascottmckendry" title="Reviewed Pull Requests">👀</a> <a href="#tutorial-scottmckendry" title="Tutorials">✅</a></td>
      <td align="center" valign="top" width="25%"><a href="https://snyk.io/"><img src="https://avatars.githubusercontent.com/u/19733683?v=4?s=80" width="80px;" alt="Snyk bot"/><br /><sub><b>Snyk bot</b></sub></a><br /><a href="#security-snyk-bot" title="Security">🛡️</a> <a href="#infra-snyk-bot" title="Infrastructure (Hosting, Build-Tools, etc)">🚇</a> <a href="#maintenance-snyk-bot" title="Maintenance">🚧</a> <a href="https://github.com/Nick2bad4u/ps-color-scripts-enhanced/pulls?q=is%3Apr+reviewed-by%3Asnyk-bot" title="Reviewed Pull Requests">👀</a></td>
      <td align="center" valign="top" width="25%"><a href="https://www.stepsecurity.io/"><img src="https://avatars.githubusercontent.com/u/89328645?v=4?s=80" width="80px;" alt="StepSecurity Bot"/><br /><sub><b>StepSecurity Bot</b></sub></a><br /><a href="#security-step-security-bot" title="Security">🛡️</a> <a href="#infra-step-security-bot" title="Infrastructure (Hosting, Build-Tools, etc)">🚇</a> <a href="#maintenance-step-security-bot" title="Maintenance">🚧</a></td>
    </tr>
    <tr>
      <td align="center" valign="top" width="25%"><a href="https://github.com/apps/dependabot"><img src="https://avatars.githubusercontent.com/in/29110?v=4?s=80" width="80px;" alt="dependabot[bot]"/><br /><sub><b>dependabot[bot]</b></sub></a><br /><a href="#infra-dependabot[bot]" title="Infrastructure (Hosting, Build-Tools, etc)">🚇</a> <a href="#security-dependabot[bot]" title="Security">🛡️</a></td>
    </tr>
  </tbody>
</table>

<!-- markdownlint-restore -->
<!-- prettier-ignore-end -->

<!-- ALL-CONTRIBUTORS-LIST:END -->

This project follows the [all-contributors](https://github.com/all-contributors/all-contributors) specification. Contributions of any kind welcome!
