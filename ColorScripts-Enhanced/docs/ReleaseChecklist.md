# Release Checklist

Use this checklist to produce a production-ready release of **ColorScripts-Enhanced**.

## 1. Pre-flight Checks

- [ ] Review `CHANGELOG.md` and ensure the latest changes are documented.
- [ ] Generate release notes with git-cliff: `npm run release:notes:latest`
- [ ] Verify release notes align with git-cliff output: `npm run release:verify`
- [ ] Confirm `README.md` and documentation reflect the latest behavior.
- [ ] Verify module metadata (`ColorScripts-Enhanced.psd1`) including `ModuleVersion` and `Description`.
- [ ] Ensure help files are up to date and run `npm run docs:update-counts` to sync markers.

## 2. Quality Gates

- [ ] Run `npm run verify` (strict linting + markdown checks + all tests).
- [ ] Alternatively run individual checks:
  - [ ] `npm test` - Smoke tests with ScriptAnalyzer
  - [ ] `npm run test:pester` - Full Pester test suite
  - [ ] `npm run lint:strict` - ScriptAnalyzer with warnings as errors
  - [ ] `npm run markdown:check` - Validate all markdown links
- [ ] (Optional) Run `npm run lint:fix` to apply auto-fixable ScriptAnalyzer rules.
- [ ] Spot-check a selection of colorscripts (include glyph-heavy scripts like `nerd-font-test`).
- [ ] Validate caching performance using `New-ColorScriptCache` and verify load times.

## 3. Versioning

- [ ] Determine release version (semantic or date-based `yyyy.MM.dd.HHmm`).
- [ ] Update the manifest version via `build.ps1 -Version <version>`.
- [ ] Commit and push the version bump (`git commit -am "chore: release <version>"`).

## 4. GitHub Release & Publishing

- [ ] Tag the commit (`git tag v<version>` and `git push origin v<version>`).
- [ ] Trigger the **Publish** workflow manually via GitHub Actions or let it auto-trigger on tag push.
- [ ] The workflow will automatically:
  - [ ] Build and test the module
  - [ ] Package the `.nupkg` file
  - [ ] Generate release notes with git-cliff
  - [ ] Create GitHub Release with changelog and package attached
  - [ ] Publish to PowerShell Gallery
  - [ ] Publish to NuGet.org (if enabled)
  - [ ] Publish to GitHub Packages (if enabled)
- [ ] Verify the GitHub Release shows:
  - [ ] git-cliff generated changelog in the release body
  - [ ] `.nupkg` file attached as a release asset
  - [ ] Correct version tag

## 5. Post-publish Validation

- [ ] Verify module availability on PowerShell Gallery (`Find-Module ColorScripts-Enhanced`).
- [ ] Install from the gallery on a clean environment.
- [ ] Update any dependent repositories or profile scripts if necessary.
- [ ] Announce the release (README badge, social media, etc.).

## 6. Housekeeping

- [ ] Close related GitHub issues and mark the version milestone complete.
- [ ] Update roadmap / TODO items for next iteration.
- [ ] Archive build artifacts if required by governance policies.
