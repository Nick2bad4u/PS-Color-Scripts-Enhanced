# Publishing Guide

This guide documents the repository's current release pipeline for **ColorScripts-Enhanced**. The PowerShell Gallery is the primary destination; NuGet.org is optional. The workflow does not publish to GitHub Packages.

## Release Contract

- The manifest uses a four-part date-based version: `yyyy.MM.dd.HHmm`.
- A release tag must be exactly `v<ModuleVersion>` and point to the commit being published.
- Published package versions are immutable. Increment the manifest version before publishing another build.
- The package is built from `ColorScripts-Enhanced/`, normalized to include its README, license, and icon, and attached to the GitHub release.

The current manifest version is <!-- COLOR_MODULE_VERSION -->`2026.7.20.2250`<!-- /COLOR_MODULE_VERSION -->.

## Automated Publishing

`.github/workflows/publish.yml` is the source of truth. It can be invoked by:

- publishing a GitHub release;
- a manual `workflow_dispatch`; or
- another workflow through `workflow_call`.

The workflow:

1. installs the pinned PowerShell and Node.js tooling;
2. builds the module and runs release-note, verification, conversion, coverage, ScriptAnalyzer, and Pester checks;
3. verifies that the requested version and release tag match the built manifest;
4. creates and normalizes a `.nupkg` package;
5. generates release notes with git-cliff;
6. creates or updates the GitHub release when requested;
7. publishes to the PowerShell Gallery when `PSGALLERYAPIKEY` is available; and
8. optionally publishes to NuGet.org when `NUGETAPIKEY` is available and `publishToNuGet` is not `false`.

### Manual Inputs

| Input              | Default | Effect                                      |
| ------------------ | ------- | ------------------------------------------- |
| `publishToNuGet`   | `true`  | Enables the optional NuGet.org publish step |
| `versionOverride`  | empty   | Overrides the version passed to `build.ps1` |
| `createRelease`    | `true`  | Creates or updates the GitHub release       |

The workflow does not define a `publishToGitHub` input or push to GitHub Packages.

### Required Secrets

| Secret            | Purpose                                                    |
| ----------------- | ---------------------------------------------------------- |
| `PSGALLERYAPIKEY` | Publishes the normalized package to PowerShell Gallery     |
| `NUGETAPIKEY`     | Publishes the same package to NuGet.org when enabled       |

Both are optional for reusable-workflow calls. A missing key causes its corresponding publish step to skip; it does not turn validation into a failure.

### Manual Dispatch

```powershell
# Validate, package, create the release, and publish where keys are configured.
gh workflow run publish.yml --ref main

# Skip NuGet.org and use an explicit module version.
gh workflow run publish.yml --ref main `
    -f publishToNuGet=false `
    -f createRelease=true `
    -f versionOverride='2026.7.20.2250'

gh run list --workflow=publish.yml
```

Do not supply a version override that differs from the intended release tag. The workflow rejects mismatches.

## Local Pre-Publish Validation

From the repository root:

```powershell
Test-ModuleManifest -Path ./ColorScripts-Enhanced/ColorScripts-Enhanced.psd1
npm ci
npm run verify
npm run test
npm run lint
npm run release:verify
```

`npm run build` is the aggregate build and release-readiness command. It performs generated-file updates, so review the resulting diff before committing it.

To inspect command exports after validation:

```powershell
Remove-Module ColorScripts-Enhanced -Force -ErrorAction SilentlyContinue
Import-Module ./ColorScripts-Enhanced/ColorScripts-Enhanced.psd1 -Force
Get-Command -Module ColorScripts-Enhanced | Sort-Object Name
```

## Local Packaging and Publishing

The supported release path is the GitHub workflow. If local publishing is necessary, use a temporary PowerShell repository to create the package, then run the same metadata normalizer used in CI before pushing it.

```powershell
$stagingPath = Join-Path $env:TEMP 'ColorScripts-Enhanced-packages'
New-Item -ItemType Directory -Path $stagingPath -Force | Out-Null

Register-PSRepository `
    -Name LocalModuleStaging `
    -SourceLocation $stagingPath `
    -PublishLocation $stagingPath `
    -InstallationPolicy Trusted

try {
    Publish-Module `
        -Path ./ColorScripts-Enhanced `
        -Repository LocalModuleStaging `
        -NuGetApiKey LocalRepositoryKey
}
finally {
    Unregister-PSRepository -Name LocalModuleStaging -ErrorAction SilentlyContinue
}

$package = Get-ChildItem -LiteralPath $stagingPath -Filter '*.nupkg' |
    Sort-Object LastWriteTimeUtc -Descending |
    Select-Object -First 1

pwsh -NoProfile -File ./scripts/Update-NuGetPackageMetadata.ps1 `
    -PackagePath $package.FullName
```

Push the normalized package only after inspecting it:

```powershell
dotnet nuget push $package.FullName `
    --api-key $env:PSGALLERYAPIKEY `
    --source https://www.powershellgallery.com/api/v2/package `
    --skip-duplicate

# Optional second destination.
dotnet nuget push $package.FullName `
    --api-key $env:NUGETAPIKEY `
    --source https://api.nuget.org/v3/index.json `
    --skip-duplicate
```

Avoid converting a secure string back to plaintext in managed memory merely to pass an API key. Prefer a short-lived environment variable supplied by the local secret manager or CI environment.

## Release Checklist

- [ ] The worktree contains only intentional release changes.
- [ ] `ModuleVersion` is the version being released.
- [ ] `npm run verify`, `npm run test`, `npm run lint`, and `npm run release:verify` pass.
- [ ] Generated help, documentation counts, changelog, and release notes are current.
- [ ] A `v<ModuleVersion>` tag does not already exist for another commit.
- [ ] Repository secrets use the exact names `PSGALLERYAPIKEY` and `NUGETAPIKEY`.
- [ ] The GitHub release contains the normalized `.nupkg` asset.
- [ ] The new version is visible in each selected public gallery.

## Post-Publish Verification

```powershell
Find-Module -Name ColorScripts-Enhanced -Repository PSGallery |
    Select-Object Name, Version, PublishedDate

$testInstallRoot = Join-Path $env:TEMP 'ColorScripts-Enhanced-install-test'
Save-Module -Name ColorScripts-Enhanced -Repository PSGallery -Path $testInstallRoot
```

Use an isolated PowerShell process or module path for installation checks so an already imported development checkout cannot mask a packaging problem.

## Troubleshooting

- **Version rejected:** confirm the value parses as `[version]`. Four-part date versions such as `2026.7.20.2250` are valid.
- **Release tag mismatch:** the tag without its leading `v` must exactly equal the built manifest version and resolve to the published commit.
- **Duplicate package:** increment `ModuleVersion`; gallery versions cannot be replaced.
- **Publish step skipped:** verify the exact secret name and that the API key is visible to the invoking workflow.
- **Package metadata missing:** run `scripts/Update-NuGetPackageMetadata.ps1` against the staged package before pushing.
- **Release notes mismatch:** fetch tags and run `npm run release:verify`; release notes use git-cliff's `--current` range.

## References

- [PowerShell Gallery package publishing](https://learn.microsoft.com/powershell/gallery/how-to/publishing-packages/publishing-a-package)
- [PowerShell repositories](https://learn.microsoft.com/powershell/gallery/how-to/working-with-local-psrepositories)
- [NuGet push command](https://learn.microsoft.com/nuget/reference/cli-reference/cli-ref-push)
