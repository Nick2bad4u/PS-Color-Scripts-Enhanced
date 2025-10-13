# Publishing Guide

This document describes how to publish the **ColorScripts-Enhanced** PowerShell module to different package galleries.

## Prerequisites

- PowerShell 5.1 or later (PowerShell 7.4 recommended)
- PowerShellGet 2.2+ or PSResourceGet 1.0+
- A GitHub personal access token (PAT) if pushing to GitHub Packages (use Package `read:packages`/`write:packages` scopes)
- API keys for public repositories (PowerShell Gallery / NuGet.org)

## Versioning Strategy

- The module manifest uses a date-based version (`yyyy.MM.dd.HHmm`).
- When publishing a public build, ensure the manifest `ModuleVersion` matches the release tag.
- Update the version automatically using `build.ps1 -Version <value>` or via `Update-ModuleManifest`.

## Automated Publishing (GitHub Actions)

The `.github/workflows/publish.yml` workflow automates the entire publish process:

1. **Build & Test** - Runs ScriptAnalyzer and Pester tests
2. **Package** - Creates the `.nupkg` file
3. **Normalize Metadata** - Embeds README, LICENSE, and icon; sets licenseUrl
4. **Generate Release Notes** - Uses git-cliff to create changelog from commits
5. **Create GitHub Release** - Publishes release with:
   - git-cliff generated changelog in release body
   - `.nupkg` file attached as release asset
   - Automatic version tagging
6. **Publish to Galleries** - Pushes to PowerShell Gallery, NuGet.org, and GitHub Packages

The workflow can be triggered:

- Manually via `workflow_dispatch` with customizable options
- Automatically when tests pass on the main branch

### Manual Trigger Options

When manually triggering the publish workflow, you can control:

- `publishToNuGet` - Publish to NuGet.org (default: true)
- `publishToGitHub` - Publish to GitHub Packages (default: true)
- `versionOverride` - Override the manifest version
- `createRelease` - Create a GitHub release (default: true)

The workflow installs git-cliff automatically and generates release notes for the current version, which are then displayed in the GitHub release.

## PowerShell Gallery / NuGet.org

The PowerShell Gallery is built on top of NuGet feeds. Publishing to the Gallery or to NuGet.org uses the same API key.

```powershell
# Publish to the PowerShell Gallery (NuGet.org)
Publish-Module -Path ./ColorScripts-Enhanced -NuGetApiKey $env:PSGALLERY_API_KEY -Verbose
```

PowerShellGet versions prior to 2.2.6 do not embed README or license assets automatically. When you stage the package locally with `Publish-Module` (for example by targeting a temporary repository), run the metadata normalizer before pushing:

```powershell
pwsh -NoProfile -File ./scripts/Update-NuGetPackageMetadata.ps1 -PackagePath 'C:\path\to\ColorScripts-Enhanced.<version>.nupkg'
dotnet nuget push 'C:\path\to\ColorScripts-Enhanced.<version>.nupkg' --api-key $env:PSGALLERY_API_KEY --source https://www.powershellgallery.com/api/v2/package
```

The GitHub publish workflow runs this script automatically.

> **Note:** NuGet.org expects packages that declare the `MIT` license expression to also expose `https://licenses.nuget.org/MIT` via `licenseUrl`. The normalization script sets this automatically so older NuGet clients render the license correctly.

### Getting an API Key

1. Create an account at <https://www.powershellgallery.com>.
2. Generate an API key from your profile.
3. Store the key securely (e.g., GitHub secret `PSGALLERY_API_KEY`).
4. Ensure `README.md` is present in the module root (`ColorScripts-Enhanced/README.md`). The metadata normalization script bundles this file (along with `LICENSE` and the icon) into the staged `.nupkg` prior to publishing.

### Testing Before Publishing

```powershell
# Verify manifest
Test-ModuleManifest .\ColorScripts-Enhanced\ColorScripts-Enhanced.psd1

# Run automated tests
pwsh -NoProfile -Command "Invoke-Pester -Path ./Tests"

# Run lint (treat warnings as errors)
pwsh -NoProfile -Command "& .\scripts\Lint-Module.ps1" -IncludeTests -TreatWarningsAsErrors

# Apply auto-fixable ScriptAnalyzer rules (optional)
pwsh -NoProfile -Command "& .\scripts\Lint-Module.ps1" -Fix

# Verify Nerd Font glyphs render correctly
Show-ColorScript -Name nerd-font-test
```

## Secrets & Environment Variables

| Purpose                                | Local Var                                        | GitHub Secret                         |
| -------------------------------------- | ------------------------------------------------ | ------------------------------------- |
| PowerShell Gallery / NuGet.org API key | `$env:PSGALLERY_API_KEY` or `$env:NUGET_API_KEY` | `PSGALLERY_API_KEY` / `NUGET_API_KEY` |
| GitHub Packages PAT                    | `$env:PACKAGES_TOKEN`                            | `PACKAGES_TOKEN`                      |

## GitHub Packages (Optional)

GitHub Packages provides a private or public NuGet feed.

```powershell
$owner = 'Nick2bad4u'
$source = "https://nuget.pkg.github.com/$owner/index.json"
Register-PSRepository -Name GitHub -SourceLocation $source -PublishLocation $source -InstallationPolicy Trusted -PackageManagementProvider NuGet
Publish-Module -Path ./ColorScripts-Enhanced -NuGetApiKey $env:PACKAGES_TOKEN -Repository GitHub

> **Tip:** When you stage the package locally before pushing to GitHub Packages, run `Update-NuGetPackageMetadata.ps1` against the resulting `.nupkg` so the README, license, and icon are embedded.
```

### Installing from GitHub Packages

```powershell
$source = "https://nuget.pkg.github.com/Nick2bad4u/index.json"
Register-PSRepository -Name ColorScriptsEnhanced-GitHub -SourceLocation $source -InstallationPolicy Trusted -PackageManagementProvider NuGet
Install-Module -Name ColorScripts-Enhanced -Repository ColorScriptsEnhanced-GitHub
```

## Azure Artifacts / Private Feeds

For enterprise environments you can host the module in Azure Artifacts or any NuGet-compatible feed:

```powershell
Register-PSRepository -Name MyCompanyFeed -SourceLocation 'https://pkgs.dev.azure.com/<org>/<project>/_packaging/<feed>/nuget/v2' -InstallationPolicy Trusted -Credential (Get-Credential)
Publish-Module -Path ./ColorScripts-Enhanced -Repository MyCompanyFeed

> **Tip:** Normalize staged packages with `Update-NuGetPackageMetadata.ps1` before pushing them to your private feed to ensure gallery-friendly metadata.
```

## Release Workflow Summary

1. Refresh release notes with `npm run release:notes` (PowerShell Gallery snippet) and sync the changelog with `npm run release:verify` (requires `git-cliff`).
2. Update the changelog (`CHANGELOG.md`) and release notes (`RELEASENOTES.md`) if additional polish is needed.
3. Run `Test-Module.ps1` locally (includes lint step).
4. Run `Lint-Module.ps1 -IncludeTests -TreatWarningsAsErrors` if not already covered.
5. Commit and push changes.
6. Create a GitHub release with tag matching the manifest version (e.g., `v2025.10.09.1700`).
7. Trigger the **Publish** GitHub Actions workflow via release or manual dispatch.
8. Confirm module availability in the target gallery.

## Troubleshooting

- **Version conflict**: Increment `ModuleVersion` if a package with the same version exists.
- **Authentication failure**: Regenerate API token and check secrets configuration.
- **Missing dependencies**: Ensure PowerShellGet/PSResourceGet is updated on host machine.
- **Changelog mismatch**: Always update documentation before publishing.

## Related Automation

- `.github/workflows/test.yml` — Continuous integration tests for every commit/pull request.
- `.github/workflows/publish.yml` — Manual/release publishing pipeline.
- `build.ps1` — Local build helper script.

## Additional Resources

- PowerShell Gallery Publishing Docs: <https://learn.microsoft.com/en-us/powershell/gallery/how-to/publishing-packages/publishing-a-package?view=powershellget-3.x>
- PSResourceGet Guide: <https://learn.microsoft.com/en-us/powershell/gallery/overview?view=powershellget-3.x>
- GitHub Packages with PowerShell: <https://docs.github.com/en/packages/working-with-a-github-packages-registry/working-with-the-nuget-registry>
