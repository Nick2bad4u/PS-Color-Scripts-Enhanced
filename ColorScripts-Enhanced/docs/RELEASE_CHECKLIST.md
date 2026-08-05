# Release Checklist

Use this checklist with [PUBLISHING.md](PUBLISHING.md). The workflow file remains the executable source of truth.

## Preflight

- [ ] Confirm the worktree contains only intentional release changes.
- [ ] Confirm `ColorScripts-Enhanced/ColorScripts-Enhanced.psd1` has the intended four-part `yyyy.MM.dd.HHmm` version.
- [ ] Run `npm run docs:update-counts` and `npm run build:help`; review generated diffs.
- [ ] Refresh `CHANGELOG.md` and `dist/` release-note artifacts where required.
- [ ] Run `npm run release:verify` with current tags available.

## Quality Gates

- [ ] `npm run verify:strict`
- [ ] `npm test`
- [ ] `npm run test:coverage`
- [ ] `npm run markdown:check`
- [ ] `npm run readme:check:strict`
- [ ] Spot-check static, dynamic, glyph-heavy, Pokémon, and cache-policy-selected scripts.
- [ ] Review `git diff --check` and the final staged diff.

`npm test` runs ANSI-conversion tests, the custom module harness, and Pester. It is not only a smoke test.

## Tag and Workflow Contract

- [ ] The release tag is exactly `v<ModuleVersion>`.
- [ ] The tag resolves to the exact commit being released.
- [ ] That version/tag does not already identify another published package.
- [ ] The repository secret uses the exact name `PSGALLERYAPIKEY`.
- [ ] The NuGet.org trusted-publishing policy targets `Nick2bad4u/PS-Color-Scripts-Enhanced`, `publish.yml`, and no Environment value.
- [ ] Manual dispatch inputs are correct: `publishToNuGet`, `versionOverride`, and `createRelease`.

The Publish workflow runs for a published GitHub release, manual dispatch, or `workflow_call`. It does not trigger merely because a tag was pushed, and it does not publish to GitHub Packages.

## Publish Verification

- [ ] The workflow built and normalized one `.nupkg`.
- [ ] The GitHub release has the expected tag, release notes, commit, and package asset.
- [ ] The package is visible on PowerShell Gallery.
- [ ] NuGet.org contains the version only when that optional publish was enabled.
- [ ] Save/install the Gallery package in an isolated location and import it in a clean process.
- [ ] Verify all 10 commands, aliases, localized help, representative rendering, configuration, and cache behavior from the installed package.

## Housekeeping

- [ ] Close or update related issues and milestones.
- [ ] Update roadmap/status documentation only where the release actually changed it.
- [ ] Retain required release evidence and artifacts.
