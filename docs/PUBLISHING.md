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

> **Note:** NuGet.org expects packages that declare the `Unlicense` license expression to also expose `https://licenses.nuget.org/Unlicense` via `licenseUrl`. The normalization script sets this automatically so older NuGet clients render the license correctly.

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

## Pre-Publishing Checklist

- [ ] All tests pass (`npm run verify`)
- [ ] Linting clean (`npm run lint`)
- [ ] Documentation updated
- [ ] Version bumped (`.psd1` manifest)
- [ ] CHANGELOG.md updated
- [ ] Release notes generated
- [ ] Tested locally on Windows/Mac/Linux

## Local Publishing Workflow

### Step 1: Validate Package

```powershell
# Test manifest
Test-ModuleManifest -Path ColorScripts-Enhanced/ColorScripts-Enhanced.psd1

# Verify module loads
Remove-Module ColorScripts-Enhanced -Force -ErrorAction SilentlyContinue
Import-Module ./ColorScripts-Enhanced/ColorScripts-Enhanced.psd1 -Verbose

# Check all commands export
Get-Command -Module ColorScripts-Enhanced | Select-Object Name
```

### Step 2: Create Package

```powershell
# Using automatic publish workflow (recommended)
# Trigger via GitHub Actions interface or:
gh workflow run publish.yml --ref main

# Manual packaging (optional)
Compress-Archive -Path "./ColorScripts-Enhanced" -DestinationPath "./dist/ColorScripts-Enhanced-v1.0.0.zip"
```

### Step 3: Test Package Installation

```powershell
# PowerShell Gallery (simulate)
Save-Module -Name ColorScripts-Enhanced -Path "./test-install"

# Test load
Import-Module "./test-install/ColorScripts-Enhanced"

# Verify functionality
Show-ColorScript -Name bars
Get-ColorScriptList
```

## Publishing to Different Galleries

### PowerShell Gallery (Primary)

```powershell
# Publish via GitHub Actions (automatic)
# OR manually if needed:

$nugetApiKey = Read-Host "Enter NuGet API key" -AsSecureString
$nugetApiKeyPlain = [System.Runtime.InteropServices.Marshal]::PtrToStringAuto(
    [System.Runtime.InteropServices.Marshal]::SecureStringToCoTaskMemUnicode($nugetApiKey)
)

Publish-Module -Path "./ColorScripts-Enhanced" `
    -NuGetApiKey $nugetApiKeyPlain `
    -Repository PSGallery
```

## Verification

```powershell
# Should appear in PowerShell Gallery after 5-10 minutes
Find-Module -Name ColorScripts-Enhanced
```

### NuGet.org

```powershell
# Publish directly to NuGet
dotnet nuget push "./dist/ColorScripts-Enhanced.*.nupkg" `
    -k $nugetApiKey `
    -s https://api.nuget.org/v3/index.json
```

### GitHub Packages

```powershell
# Register GitHub package source
$owner = 'Nick2bad4u'
$source = "https://nuget.pkg.github.com/$owner/index.json"

Register-PSRepository -Name ColorScriptsEnhanced-GitHub `
    -SourceLocation $source `
    -PublishLocation $source `
    -InstallationPolicy Trusted

# Publish
Publish-Module -Path "./ColorScripts-Enhanced" `
    -Repository ColorScriptsEnhanced-GitHub `
    -NuGetApiKey $githubToken
```

## Automated Publishing Workflow

### GitHub Actions Execution

The `.github/workflows/publish.yml` workflow:

1. **Validates** - Runs smoke tests and linting
2. **Builds** - Creates .nupkg package
3. **Normalizes** - Embeds README, LICENSE, icon
4. **Generates** - Creates changelog using git-cliff
5. **Releases** - Creates GitHub release with changelog
6. **Publishes** - Pushes to configured galleries

### Manual Workflow Trigger

```powershell
# Via GitHub CLI
gh workflow run publish.yml

# With options
gh workflow run publish.yml `
    -f publishToNuGet=true `
    -f publishToGitHub=true `
    -f createRelease=true `
    -f versionOverride="2025.10.30.1200"

# Check status
gh run list --workflow=publish.yml
```

## Versioning Strategy (2)

### Date-Based Versioning

Format: `yyyy.MM.dd.HHmm`

Example: `2025.10.30.1247`

```powershell
# Generate version automatically
$version = (Get-Date -Format "yyyy.MM.dd.HHmm")
Write-Host "Version: $version"
```

### Updating Version

```powershell
# Method 1: Direct update
$manifestPath = "./ColorScripts-Enhanced/ColorScripts-Enhanced.psd1"
$version = "2025.10.30.1247"

Update-ModuleManifest -Path $manifestPath -ModuleVersion $version

# Method 2: Via build script
.\scripts\build.ps1 -Version $version
```

## Release Notes Generation

### Using git-cliff

```powershell
# Generate release notes for latest version
npx git-cliff --unreleased

# Generate for specific version
npx git-cliff --tag v2025.10.30

# Generate full changelog
npx git-cliff --latest > CHANGELOG.md

# Validate changelog
npm run release:verify
```

## Post-Publishing Tasks

### Verification (2)

```powershell
# Wait 5-10 minutes for gallery sync

# Check PowerShell Gallery
Find-Module -Name ColorScripts-Enhanced | Select-Object Version

# Test installation
Install-Module -Name ColorScripts-Enhanced -Force -Verbose

# Verify functionality
Import-Module ColorScripts-Enhanced
Show-ColorScript
```

### Announcement

- [ ] Update GitHub releases page
- [ ] Post to PowerShell community forums
- [ ] Update project website
- [ ] Announce on social media (optional)
- [ ] Update documentation links

## Troubleshooting Publication

### Publish Fails

**Issue**: Module won't publish to gallery

```powershell
# Check manifest syntax
Test-ModuleManifest -Path ./ColorScripts-Enhanced/ColorScripts-Enhanced.psd1

# Validate version format
# Should be: Major.Minor.Patch or date-based (2025.10.30)
# NOT: year.month.day.minute with too many parts

# Correct format if needed
Update-ModuleManifest -Path ./ColorScripts-Enhanced/ColorScripts-Enhanced.psd1 `
    -ModuleVersion "2025.10.30"
```

**Issue**: "Already published" error

```powershell
# Increment version and retry
Update-ModuleManifest -Path ./ColorScripts-Enhanced/ColorScripts-Enhanced.psd1 `
    -ModuleVersion "2025.10.31"
```

## Monitoring After Release

### Track Downloads

```powershell
# Check PowerShell Gallery stats
# https://www.powershellgallery.com/packages/ColorScripts-Enhanced

# Track downloads programmatically
$info = Invoke-RestMethod -Uri "https://www.powershellgallery.com/api/v2/Packages?`$filter=Id eq 'ColorScripts-Enhanced'" -ErrorAction SilentlyContinue
$info.Entry | Select-Object Title, Version, @{N='Downloads'; E={$_.Properties.DownloadCount}}
```

### Track Issues

```powershell
# Monitor GitHub issues for post-release problems
gh issue list --label "v2025.10.30" --state open

# Track bug reports
gh issue list --label "bug" --state open
```

## Additional Resources

- PowerShell Gallery Publishing Docs: <https://learn.microsoft.com/en-us/powershell/gallery/how-to/publishing-packages/publishing-a-package?view=powershellget-3.x>
- PSResourceGet Guide: <https://learn.microsoft.com/en-us/powershell/gallery/overview?view=powershellget-3.x>
- GitHub Packages with PowerShell: <https://docs.github.com/en/packages/working-with-a-github-packages-registry/working-with-the-nuget-registry>
