# Project Roadmap

The roadmap highlights short-, medium-, and long-term priorities for ColorScripts-Enhanced. Priorities may change as community feedback comes in. If you would like to help with an item, please open an issue or discussion first so we can coordinate.

## Near Term (Next Release)

- Automate gallery publishing notes via `cliff` and changelog validation
- Expand metadata for ANSI scripts (category, tags) to improve filtered listings
- Add smoke-test coverage for PowerShell 7.5 preview builds in CI
- Ship bundled examples for the ANSI conversion utilities

## Mid Term (1-2 Releases)

- Provide module configuration file support (store defaults for cache path, startup behavior)
- Expose JSON export of script metadata for external tools
- Offer `New-ColorScript` scaffolding helper to bootstrap new ANSI art scripts
- Integrate markdown-link-check into CI to catch broken documentation links

## Long Term

- Publish a VS Code extension that surfaces random colorscripts in the terminal panel
- Explore animated (frame-based) colorscript support with caching
- Release curated packs (e.g., "Classic ANSI", "Modern Logos") that can be installed separately
- Investigate cross-repo synchronization with upstream DistroTube/ps-color-scripts projects

## Completed Highlights

- Cross-platform module structure with caching (Windows, macOS, Linux)
- Automated dependency and supply-chain scanning workflows (Dependabot, osv-scanner, Gitleaks, Trufflehog)
- Script count automation (`Get-ColorScriptCount.ps1` and `Update-DocumentationCounts.ps1`)

## How to Participate

- Look for issues tagged `good first issue` or `help wanted`
- Propose enhancements via feature requests with clear user stories
- Join release coordination by checking the [Release Checklist](https://github.com/Nick2bad4u/ps-color-scripts-enhanced/blob/main/docs/ReleaseChecklist.md)
- If you're interested in owning a roadmap item, comment on the corresponding issue or open a new one describing your plan

We review the roadmap during each release cycle and adjust priorities based on user impact, maintenance effort, and community interest.
