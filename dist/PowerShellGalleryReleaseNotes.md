## [2025.10.27.140] - 2025-10-27


[[4c31328](https://github.com/Nick2bad4u/PS-Color-Scripts-Enhanced/commit/4c31328284fd37cc44d1b32ca48987b5d5856673)...
[9c540a3](https://github.com/Nick2bad4u/PS-Color-Scripts-Enhanced/commit/9c540a311d0477eacde81515f9aa375b276f5201)]
([compare](https://github.com/Nick2bad4u/PS-Color-Scripts-Enhanced/compare/4c31328284fd37cc44d1b32ca48987b5d5856673...9c540a311d0477eacde81515f9aa375b276f5201))


### ≡ƒ¢á∩╕Å GitHub Actions

- Update publish.yml [`(d60c0a6)`](https://github.com/Nick2bad4u/PS-Color-Scripts-Enhanced/commit/d60c0a66fa042998b2c6aa077b4dad1167e3f28f)


- Update publish.yml [`(f52f875)`](https://github.com/Nick2bad4u/PS-Color-Scripts-Enhanced/commit/f52f87540cf966ade61eb5f3715c05495090b66e)


- ≡ƒº╣ [chore] No-op: no changes detected in provided diff
 - ≡ƒº╣ [chore] Inspected .github/workflows/publish.yml ΓÇö no modifications
 - ≡ƒº╣ [chore] Inspected [ColorScripts-Enhanced](https://github.com/Nick2bad4u/PS-Color-Scripts-Enhanced)/[ColorScripts-Enhanced](https://github.com/Nick2bad4u/PS-Color-Scripts-Enhanced).psd1 ΓÇö no modifications
 - ≡ƒæ╖ [ci] No CI, packaging, manifest, or release updates required; nothing to publish

Signed-off-by: Nick2bad4u <20943337+Nick2bad4u@users.noreply.github.com> [`(5f5b6b4)`](https://github.com/Nick2bad4u/PS-Color-Scripts-Enhanced/commit/5f5b6b41a9b5c0f7477b7c475572d540566283c5)


- ≡ƒæ╖ [ci] Enhance publish workflow and update docs

This commit introduces several improvements to the CI/CD pipeline, project documentation, and license.

*   ≡ƒæ╖ [ci] Refines the `publish.yml` GitHub Actions workflow.
    *   Improves build validation logic by checking for the module manifest's existence and validity directly within the build step.
    *   Removes the less reliable check on `$LASTEXITCODE`, preventing false negatives and ensuring a valid module is built before proceeding.

*   ≡ƒô¥ [docs] Updates the `README.md` with significant enhancements.
    *   Adds a new project mascot image for better visual appeal.
    *   Integrates a Codecov badge to display test coverage status.
    *   Includes a new "Testing" section with detailed instructions on running Pester tests and generating coverage reports.

*   ≡ƒô¥ [docs] Changes the project license from MIT to The Unlicense.
    *   Updates the `LICENSE` badge and the "License" section in the `README.md` to reflect this change.

*   ≡ƒº╣ [chore] [dependency] Updates the module version to `2025.10.26.1439`.
    *   Updates the module manifest (`.psd1`) and release notes with the new version number.

Signed-off-by: Nick2bad4u <20943337+Nick2bad4u@users.noreply.github.com> [`(4c8d39e)`](https://github.com/Nick2bad4u/PS-Color-Scripts-Enhanced/commit/4c8d39efb04f43603dabd5cfdeb22eb2b3203dde)


- Γ£¿ [feat] Add code coverage reporting with Codecov

Γ£¿ [feat] Adds comprehensive code coverage reporting to the project. This enhances quality assurance by tracking the percentage of code executed during tests.

≡ƒæ╖ [ci] Updates the `test.yml` workflow to:
-   Enable Pester's code coverage feature during test runs for both PowerShell 5.1 and pwsh.
-   Generate coverage reports in `JaCoCo` XML format.
-   Upload these reports to Codecov using the `codecov/codecov-action` for analysis and badge generation.

≡ƒº¬ [test] Introduces a new PowerShell script `scripts/Test-Coverage.ps1` to streamline local testing:
-   Runs Pester tests with coverage analysis.
-   Displays a detailed coverage summary in the console.
-   Enforces a minimum coverage threshold to maintain code quality.
-   Includes an option to generate and open a local HTML coverage report using `ReportGenerator`.

≡ƒöº [build] Adds new npm scripts for convenience:
-   `npm run test:coverage` to execute the coverage script.
-   `npm run test:coverage:report` to generate the HTML report.

≡ƒô¥ [docs] Updates `README.md` to:
-   Add the new Codecov badge.
-   Include a new "Testing" section detailing how to run tests and generate coverage reports.
-   Add a project mascot image.

≡ƒº╣ [chore] Modifies `.gitignore` to exclude generated test results and coverage report files.

Signed-off-by: Nick2bad4u <20943337+Nick2bad4u@users.noreply.github.com> [`(3bfb155)`](https://github.com/Nick2bad4u/PS-Color-Scripts-Enhanced/commit/3bfb155d519bb925234dd1bc3d0dc6e92ee90b4a)



### ≡ƒÆ╝ Other

- ≡ƒ¢á∩╕Å [fix] Improve path handling and test reliability

This update introduces several fixes and enhancements to improve robustness, especially around path resolution and test execution.

*   **Source Code Changes**
    *   ≡ƒ¢á∩╕Å [fix] Strengthens cache path resolution by adding error handling for `[System.IO.Path]::IsPathRooted`. This prevents crashes when processing paths with invalid characters, returning `null` instead.

*   **Testing and Build Changes**
    *   ≡ƒº¬ [test] Updates tests to be more resilient and accurate.
        -   Improves test state management by using `try...finally` blocks to correctly restore environment and global variables, ensuring test isolation.
        -   Refines assertions to be more specific, particularly for cache path and text emission tests, to correctly reflect behavior under different conditions (like output redirection).
        -   Corrects a potential issue in a test by ensuring a `Where-Object` result is always treated as an array.
    *   ≡ƒæ╖ [ci] Enhances the module test script (`Test-Module.ps1`).
        -   Introduces a helper function to reliably retrieve the module's cache directory, even if it hasn't been initialized yet.
        -   Skips the PSScriptAnalyzer test with a warning if the module is not installed, preventing script failure in environments without it.
    *   ≡ƒº╣ [chore] [dependency] Updates the module version and updates related help files.

Signed-off-by: Nick2bad4u <20943337+Nick2bad4u@users.noreply.github.com> [`(9c540a3)`](https://github.com/Nick2bad4u/PS-Color-Scripts-Enhanced/commit/9c540a311d0477eacde81515f9aa375b276f5201)


- ≡ƒô¥ [docs] Overhaul and enhance cmdlet documentation

This commit introduces a comprehensive overhaul of the external help documentation (Markdown and XML files) for all major cmdlets, alongside several code refinements and feature enhancements.

### Documentation (`≡ƒô¥ [docs]`)

-   **Complete Rewrite**: The help content for `Add-ColorScriptProfile`, `Build-ColorScriptCache`, `Clear-ColorScriptCache`, and other cmdlets has been completely rewritten for clarity, accuracy, and detail.
-   **Richer Examples**: Adds more diverse and practical examples for each cmdlet, including pipeline usage and combinations of parameters.
-   **Improved Descriptions**: Parameter descriptions, notes, and cmdlet summaries are expanded to better explain the "why" behind features, their behavior, and best practices.
-   **Standardization**: Ensures consistent formatting, structure, and tone across all help files, including updating the MAML XML to reflect the Markdown changes.

### Refactoring & Fixes (`≡ƒÜ£ [refactor]`)

-   **Lazy Initialization**: The cache directory is no longer initialized on module import. Instead, it's created lazily on the first call to a function that requires it, improving module load times.
-   **Code Simplification**:
    -   Refactors `Save-ColorScriptConfiguration` to remove a redundant variable, simplifying the logic for checking existing configuration content.
    -   Fixes a potential divide-by-zero error in `Build-ColorScriptCache`'s progress calculation when processing an empty set of scripts.

### Build & Metadata (`≡ƒöº [build]`)

-   **Build Output**: Modifies `.gitignore` to explicitly include the `dist` directory, ensuring it's available for packaging and distribution workflows.
-   **Version [dependency] Update**: Increments the module version and updates the description to reflect the new total count of 498 colorscripts.

Signed-off-by: Nick2bad4u <20943337+Nick2bad4u@users.noreply.github.com> [`(bb5f0e6)`](https://github.com/Nick2bad4u/PS-Color-Scripts-Enhanced/commit/bb5f0e6cbde9b1f276f6d9b7a12744cf75d62be0)


- ≡ƒº╣ [chore] [dependency] Update version, update docs, and apply formatting

≡ƒöº [build] [dependency] Updates the module version to `2025.10.26.1403`.
 - Updates the version in the module manifest (`.psd1`) file.
 - Aligns the version number in the release notes.

≡ƒô¥ [docs] Removes the empty `## ALIASES` section from all cmdlet help files for a cleaner, more consistent documentation experience.

≡ƒÄ¿ [style] Applies minor code formatting in the `Show-ColorScript` function.
 - Adjusts brace style and line spacing for improved readability without changing logic.

Signed-off-by: Nick2bad4u <20943337+Nick2bad4u@users.noreply.github.com> [`(061fcda)`](https://github.com/Nick2bad4u/PS-Color-Scripts-Enhanced/commit/061fcda7de75f3806993da05895f457a4ab4bd31)


- ≡ƒô¥ [docs] Regenerate and enhance PlatyPS help documentation

This commit overhauls the module's help documentation by regenerating all markdown files using a newer version of PlatyPS. It also introduces a new build script for managing and publishing help content.

≡ƒô¥ [docs] **Help File Regeneration**
- Updates all cmdlet markdown help files (`.md`) to a new, more detailed PlatyPS schema (`2024-05-01`).
- Enriches parameter documentation with full YAML definitions, including type, default values, parameter sets, and positions.
- Adds `HelpUri` to the frontmatter of each help file, pointing to the project's GitHub repository for better discoverability.
- Updates the module manifest (`.psd1`) to point `HelpInfoURI` to a new GitHub Pages site, enabling updatable help via `Update-Help`.

≡ƒöº [build] **New Help Build Process**
- Introduces a new `Build-Help.ps1` script to automate the generation of MAML XML files from the updated markdown.
- The script now runs PlatyPS cmdlets in an isolated PowerShell process to ensure compatibility and avoid module conflicts.
- Adds logic to publish help content to the `docs` directory for GitHub Pages deployment.

≡ƒÄ¿ [style] **Minor Code Formatting**
- Adjusts brace style in a `foreach` loop within `Show-ColorScript` for consistency. This is a non-functional, cosmetic change.

Signed-off-by: Nick2bad4u <20943337+Nick2bad4u@users.noreply.github.com> [`(4c31328)`](https://github.com/Nick2bad4u/PS-Color-Scripts-Enhanced/commit/4c31328284fd37cc44d1b32ca48987b5d5856673)






## Contributors
Thanks to all the [contributors](https://github.com/Nick2bad4u/PS-Color-Scripts-Enhanced/graphs/contributors) for their hard work!
## License
This project is licensed under the [MIT License](https://github.com/Nick2bad4u/PS-Color-Scripts-Enhanced/blob/main/LICENSE)
*This changelog was automatically generated with [git-cliff](https://github.com/orhun/git-cliff).*

