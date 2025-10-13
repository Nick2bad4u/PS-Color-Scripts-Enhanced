# Project Roadmap

The roadmap highlights short-, medium-, and long-term priorities for ColorScripts-Enhanced. Priorities may change as community feedback comes in. If you would like to help with an item, please open an issue or discussion first so we can coordinate.

## Near Term (Next Release)

- Open slot for community-driven enhancements—drop suggestions in Discussions or Issues.

## Mid Term (1-2 Releases)

- Expand script descriptions to cover the remaining catalog for richer search experiences.
- Investigate live previews for the ANSI conversion utilities (side-by-side ANSI + PowerShell output).
- Evaluate adding VS Code tasks to streamline conversion workflows and cache maintenance.

## Long Term

- Publish a VS Code extension that surfaces random colorscripts in the terminal panel
- Explore animated (frame-based) colorscript support with caching
- Release curated packs (e.g., "Classic ANSI", "Modern Logos") that can be installed separately
- Investigate cross-repo synchronization with upstream DistroTube/ps-color-scripts projects

## Completed Highlights

- Cross-platform module structure with caching (Windows, macOS, Linux)
- Automated dependency and supply-chain scanning workflows (Dependabot, osv-scanner, Gitleaks, Trufflehog)
- Script count automation (`Get-ColorScriptCount.ps1` and `Update-DocumentationCounts.ps1`)
- Release-note automation via git-cliff scripts and CHANGELOG validation
- Configuration persistence, metadata export cmdlet, scaffolding helper, and expanded metadata tags/descriptions
- Markdown link checking in CI alongside PowerShell 7.5 preview smoke testing
- Bundled ANSI conversion examples to accelerate onboarding

## How to Participate

- Look for issues tagged `good first issue` or `help wanted`
- Propose enhancements via feature requests with clear user stories
- Join release coordination by checking the [Release Checklist](https://github.com/Nick2bad4u/ps-color-scripts-enhanced/blob/main/docs/ReleaseChecklist.md)
- If you're interested in owning a roadmap item, comment on the corresponding issue or open a new one describing your plan

We review the roadmap during each release cycle and adjust priorities based on user impact, maintenance effort, and community interest.
