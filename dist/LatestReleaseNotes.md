<!-- markdownlint-disable -->
<!-- eslint-disable markdown/no-missing-label-refs -->
# Changelog

All notable changes to this project will be documented in this file.

## [2025.10.13.2034] - 2025-10-13


[[e5d4669](https://github.com/Nick2bad4u/PS-Color-Scripts-Enhanced/commit/e5d4669dc992d55b20d275f2ffb443d5d399e59b)...
[3198789](https://github.com/Nick2bad4u/PS-Color-Scripts-Enhanced/commit/31987895229400a204e2cfa6c4566e63f6f445cb)]
([compare](https://github.com/Nick2bad4u/PS-Color-Scripts-Enhanced/compare/e5d4669dc992d55b20d275f2ffb443d5d399e59b...31987895229400a204e2cfa6c4566e63f6f445cb))


### ≡ƒ¢á∩╕Å GitHub Actions

- Γ£¿ [feat] Enhance module with documentation and automation

Updates the module with documentation improvements, automation enhancements, and code refinements.

 - ≡ƒô¥ [docs] Updates documentation by:
   - Adds a documentation index for easy navigation ≡ƒº¡.
   - Includes `Get-Help` examples in `README.md` and `[ColorScripts-Enhanced](https://github.com/Nick2bad4u/PS-Color-Scripts-Enhanced)/README.md` to assist users.
   - Updates `MODULE_SUMMARY.md` with current module details.
   - Refreshes `QUICK_REFERENCE.md` with current version information.
   - Enhances `Publishing.md` with automation details for GitHub Actions.
   - Refines `ReleaseChecklist.md` to align with current release processes.

 - ≡ƒæ╖ [ci] Enhances CI/CD by:
   - Updates `publish.yml` to use a specific `git-cliff` version for release note generation.

 - ≡ƒ¢á∩╕Å [fix] Corrects code by:
   - Fixes the default reviewer in `.github/CODEOWNERS`.
   - Increments the module version in `[ColorScripts-Enhanced](https://github.com/Nick2bad4u/PS-Color-Scripts-Enhanced).psd1` and updates corresponding release notes.

 - ΓÜí [perf] Improves performance by:
   - Enhances caching system with OS-wide cache in AppData, yielding 6-19x performance improvement.

 - ≡ƒº╣ [chore] Updates dependencies:
   - Upgrades `markdown-link-check` from `3.12.2` to `3.14.1` in `package.json` and `package-lock.json`, likely to address bugs or improve link checking functionality.

Signed-off-by: Nick2bad4u <20943337+Nick2bad4u@users.noreply.github.com> [`(307dccf)`](https://github.com/Nick2bad4u/PS-Color-Scripts-Enhanced/commit/307dccf7f51736892d11363685a885a8b1e7c519)



### ≡ƒÆ╝ Other

- ≡ƒæ╖ [ci] Improve git-cliff installation in publish workflow
 - Replace fixed-exe lookup with a recursive search (Get-ChildItem -Recurse) so git-cliff.exe can be found in nested archive directories
 - Emit directory listing on failure and throw a clear error when exe is missing
 - Use the exe's parent folder (binPath) when prepending to PATH and persist the updated PATH to GITHUB_ENV; log the discovered exe path and verify --version

≡ƒº╣ [chore] Tidy Invoke-MarkdownLinkCheck.ps1 and ensure provided paths are filtered
 - Add a blank line after the EXAMPLE block for readability
 - Normalize/respect provided Paths and filter out node_modules and the script file itself to avoid self-checks and irrelevant files

Signed-off-by: Nick2bad4u <20943337+Nick2bad4u@users.noreply.github.com> [`(3198789)`](https://github.com/Nick2bad4u/PS-Color-Scripts-Enhanced/commit/31987895229400a204e2cfa6c4566e63f6f445cb)


- ≡ƒæ╖ [ci] Simplify git-cliff installation in publish workflow
 - Replace runtime GitHub API release lookup with a pinned download URL (v2.10.1) to avoid API auth/rate issues and speed up CI
 - Remove custom request headers and UseBasicParsing; use a straightforward Invoke-WebRequest to fetch the ZIP
 - Tweak comment and behavior: add git-cliff to PATH for the session and still export PATH to GITHUB_ENV (no claim about persisting)
 - Preserve extraction and validation steps (fail if git-cliff.exe is missing)
 - Note: pins git-cliff version; update URL when upgrading the tool

Signed-off-by: Nick2bad4u <20943337+Nick2bad4u@users.noreply.github.com> [`(d1b4bd2)`](https://github.com/Nick2bad4u/PS-Color-Scripts-Enhanced/commit/d1b4bd2d45b610a43ae0dedf3e2fd6d7adb92ffd)


- ≡ƒô¥ [docs] Tidy documentation tables, refresh publishing links, and normalize link-check config
 - ≡ƒô¥ [docs] Reformat docs/DOCUMENTATION_INDEX.md tables for consistent column alignment and improved readability
 - ≡ƒô¥ [docs] Update docs/Publishing.md external references to canonical Microsoft and GitHub URLs and add minor spacing adjustments for clarity
 - ≡ƒº╣ [chore] Normalize .markdown-link-check.json formatting (remove stray blank line, compact arrays/objects) for consistent JSON style

Signed-off-by: Nick2bad4u <20943337+Nick2bad4u@users.noreply.github.com> [`(ebe748e)`](https://github.com/Nick2bad4u/PS-Color-Scripts-Enhanced/commit/ebe748e8f0ad4d3aeb84df5081c5e2355fe50618)


- ≡ƒô¥ [docs] Update PowerShell Module Best Practices link in docs/Development.md

 - Replace outdated Learn link with canonical Publishing Guide URL to improve accuracy and link stability
 - Aligns Development guide with repository documentation conventions

Signed-off-by: Nick2bad4u <20943337+Nick2bad4u@users.noreply.github.com> [`(e30a3fa)`](https://github.com/Nick2bad4u/PS-Color-Scripts-Enhanced/commit/e30a3fa5adf0666165f3c5c9f003aa1a876e3b30)


- ≡ƒº╣ [chore] Consolidate markdown link-check config, bump module version, and fix README link

≡ƒöº [build] Update .markdown-link-check.json
 - Consolidated and expanded ignorePatterns (imgur, local/127.0.0.1, file://, changelog, reddit, discord, deps, mailto, etc.) to reduce false positives
 - Expanded aliveStatusCodes to include common redirects (301, 302, 303, 307, 308) and added fallbackRetryDelay
 - Added richer httpHeaders (Accept-Encoding + User-Agent) and target URLs (github.com, api.github.com, raw.githubusercontent.com) to improve link-check reliability

≡ƒöº [build] [dependency] Update module version and release notes in [ColorScripts-Enhanced](https://github.com/Nick2bad4u/PS-Color-Scripts-Enhanced).psd1
 - ModuleVersion updated to '2025.10.13.1600'
 - ReleaseNotes header updated to match new version

≡ƒô¥ [docs] Fix GitHub URL for Scott McKendry's ps-color-scripts
 - Corrected link casing/path in README.md and [ColorScripts-Enhanced](https://github.com/Nick2bad4u/PS-Color-Scripts-Enhanced)/README.md (github.com/scottmckendry/ps-color-scripts)

Signed-off-by: Nick2bad4u <20943337+Nick2bad4u@users.noreply.github.com> [`(6f9997c)`](https://github.com/Nick2bad4u/PS-Color-Scripts-Enhanced/commit/6f9997ce960d3052fe803d70a89fe55e3caef19a)



### ≡ƒ¢í∩╕Å Security

- ≡ƒæ╖ [ci] Streamlines CI workflows and release process

- ≡ƒæ╖ [ci] Removes scheduled triggers from multiple workflows.
   -  This change centralizes scheduling to a dedicated system, improving maintainability and predictability.
   -  Workflows affected: `git-sizer.yml`, `gitleaks.yml`, `osv-scanner.yml`, `repo-stats.yml`, `scorecards.yml`, and `security-devops.yml`.
- ≡ƒæ╖ [ci] Enhances the release workflow in `publish.yml` to use `git-cliff` for generating release notes.
   -  ≡ƒ¢á∩╕Å Installs `git-cliff` in the workflow using PowerShell to download, extract, and add it to the PATH. ≡ƒôª
   -  Γ£¿ Implements a release notes generation step that uses a PowerShell script (`Generate-ReleaseNotes.ps1`) to create release notes based on whether the tag exists or not. ≡ƒô¥
   -  If no release notes are generated, a fallback is used. ΓÜá∩╕Å
   -  ≡ƒô¥ Writes the generated release notes to a file for use in the GitHub Release. ≡ƒôñ
   -  ΓÖ╗∩╕Å Updates the `ncipollo/release-action` to include the generated release notes and package artifacts. ≡ƒôª
   -  Γ£à Adds `allowUpdates: true` and `updateOnlyUnreleased: false` to the release action to allow updating existing releases. ≡ƒöä
- ΓÅ¬ [ci] Removes the original GitHub Release creation step, as it is replaced by the new implementation. ≡ƒùæ∩╕Å

Signed-off-by: Nick2bad4u <20943337+Nick2bad4u@users.noreply.github.com> [`(2a33e8b)`](https://github.com/Nick2bad4u/PS-Color-Scripts-Enhanced/commit/2a33e8ba2627c5a063e89f277e6beda730b02e82)


- ≡ƒô¥ [docs] Updates module description and README

Updates the module description in both the module manifest and the README file to provide a more comprehensive overview of the module's features and capabilities.

 - ≡ƒô¥ [docs] Expands module description
  - Γ₧ò Includes a detailed list of features such as the number of colorscripts, caching system, OS-wide cache, API, configuration options, auto-update, centralized storage, and cross-platform compatibility
  - ≡ƒöù Adds a link to the full documentation on GitHub
 - ≡ƒô¥ [docs] Updates README file
  - Γ₧ò Adds a more comprehensive description of what the module does, including its features and benefits Γ£¿
  - ≡ƒöä Refactors the layout and format of the README file to improve readability and visual appeal ≡ƒÄ¿
  - ≡ƒô¥ [docs] Updates the testing and linting sections to provide more clarity and detail ≡ƒº¬
  - Γ₧ò Adds links to the documentation, support policy, code of conduct, security policy, and project roadmap ≡ƒöù
  - ≡ƒô¥ [docs] Adds a section on ANSI art sources, giving credit to the original creators ≡ƒºæΓÇì≡ƒÄ¿
 - ≡ƒº¬ [test] Updates tests to match newlines cross platform
 - ≡ƒöº [build] Updates build script to match module description

Signed-off-by: Nick2bad4u <20943337+Nick2bad4u@users.noreply.github.com> [`(e5d4669)`](https://github.com/Nick2bad4u/PS-Color-Scripts-Enhanced/commit/e5d4669dc992d55b20d275f2ffb443d5d399e59b)






## Contributors
Thanks to all the [contributors](https://github.com/Nick2bad4u/PS-Color-Scripts-Enhanced/graphs/contributors) for their hard work!
## License
This project is licensed under the [MIT License](https://github.com/Nick2bad4u/PS-Color-Scripts-Enhanced/blob/main/LICENSE)
*This changelog was automatically generated with [git-cliff](https://github.com/orhun/git-cliff).*

