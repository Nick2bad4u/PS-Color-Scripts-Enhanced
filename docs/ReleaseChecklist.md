# Release Checklist

Use this checklist to produce a production-ready release of **ColorScripts-Enhanced**.

## 1. Pre-flight Checks

- [ ] Review `CHANGELOG.md` and ensure the latest changes are documented.
- [ ] Update `RELEASENOTES.md` with new features and fixes.
- [ ] Confirm `README.md`, `QUICKSTART.md`, and `QUICKREFERENCE.md` reflect the latest behavior.
- [ ] Verify module metadata (`ColorScripts-Enhanced.psd1`) including `ModuleVersion`, `ReleaseNotes`, and `Tags`.
- [ ] Ensure help files are up to date (`Build-Help.ps1`).

## 2. Quality Gates

- [ ] Run `pwsh -NoProfile -Command "& .\Test-Module.ps1"` and ensure all tests pass.
- [ ] Run `Invoke-Pester -Path ./Tests` for additional assurance.
- [ ] Run `pwsh -NoProfile -Command "& .\Lint-Module.ps1" -IncludeTests -TreatWarningsAsErrors` and resolve findings.
- [ ] (Optional) Run `pwsh -NoProfile -Command "& .\Lint-Module.ps1" -Fix` to apply auto-fixable ScriptAnalyzer rules.
- [ ] Spot-check a selection of colorscripts in Windows Terminal / Powershell 7 (include glyph-heavy scripts like `nerd-font-test`).
- [ ] Validate caching performance (optional) using `Build-ColorScriptCache -Name <script>`.

## 3. Versioning

- [ ] Determine release version (semantic or date-based `yyyy.MM.dd.HHmm`).
- [ ] Update the manifest version via `build.ps1 -Version <version>`.
- [ ] Commit and push the version bump (`git commit -am "chore: release <version>"`).

## 4. GitHub Release

- [ ] Tag the commit (`git tag v<version>` and `git push origin v<version>`).
- [ ] Create a GitHub Release with:
  - Title: `v<version>`
  - Body: Highlights, changelog excerpt, upgrade notes
  - Assets: Optional test artifacts or sample outputs
- [ ] Trigger the **Publish** workflow (release event automatically triggers publish job).

## 5. Post-publish Validation

- [ ] Verify module availability on PowerShell Gallery (`Find-Module ColorScripts-Enhanced`).
- [ ] Install from the gallery on a clean environment.
- [ ] Update any dependent repositories or profile scripts if necessary.
- [ ] Announce the release (README badge, social media, etc.).

## 6. Housekeeping

- [ ] Close related GitHub issues and mark the version milestone complete.
- [ ] Update roadmap / TODO items for next iteration.
- [ ] Archive build artifacts if required by governance policies.
