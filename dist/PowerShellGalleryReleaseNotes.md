## [2025.10.31.16] - 2025-10-31


[[70f6e40](https://github.com/Nick2bad4u/PS-Color-Scripts-Enhanced/commit/70f6e40580910b939d691d4e1bc32a7b0fc66aca)...
[70f6e40](https://github.com/Nick2bad4u/PS-Color-Scripts-Enhanced/commit/70f6e40580910b939d691d4e1bc32a7b0fc66aca)]
([compare](https://github.com/Nick2bad4u/PS-Color-Scripts-Enhanced/compare/70f6e40580910b939d691d4e1bc32a7b0fc66aca...70f6e40580910b939d691d4e1bc32a7b0fc66aca))


### ≡ƒ¢á∩╕Å GitHub Actions

- ≡ƒæ╖ [ci] Standardize CI test reporting to JUnit (testResults.junit.xml) and run coverage via npm
 - ≡ƒº¬ [test] Update scripts/Test-Coverage.ps1 to emit JUnit test results at testResults.junit.xml and set TestResult.OutputFormat = 'JUnitXml'
 - ≡ƒæ╖ [ci] Replace inline Invoke-Pester steps with npm run test:coverage -- -CI in .github/workflows/test.yml; update upload-artifact and Codecov test-results to use testResults.junit.xml
 - ≡ƒô¥ [docs] Add CODECOV_JUNIT_SETUP.md and update NPM_SCRIPTS.md and TESTING.md to reference testResults.junit.xml and JUnit export workflow
 - ≡ƒº╣ [chore] Update .gitignore to include common test placeholders and new test artifact filenames (testResults.junit.xml / testResults.xml)
 - ≡ƒº╣ [chore] [dependency] Update ModuleVersion and HelpInfo UICultureVersion to 2025.10.30.2007 and refresh manifest ReleaseNotes; reset generated dist release notes to Unreleased

Signed-off-by: Nick2bad4u <20943337+Nick2bad4u@users.noreply.github.com> [`(70f6e40)`](https://github.com/Nick2bad4u/PS-Color-Scripts-Enhanced/commit/70f6e40580910b939d691d4e1bc32a7b0fc66aca)






## [2025.10.30.2037] - 2025-10-30


[[8ff260a](https://github.com/Nick2bad4u/PS-Color-Scripts-Enhanced/commit/8ff260a704cc48f71efa9b34cdacb7c7a537440a)...
[8ff260a](https://github.com/Nick2bad4u/PS-Color-Scripts-Enhanced/commit/8ff260a704cc48f71efa9b34cdacb7c7a537440a)]
([compare](https://github.com/Nick2bad4u/PS-Color-Scripts-Enhanced/compare/8ff260a704cc48f71efa9b34cdacb7c7a537440a...8ff260a704cc48f71efa9b34cdacb7c7a537440a))


### ≡ƒÆ╝ Other

- ≡ƒô¥ [docs] Comprehensive documentation overhaul, regenerate help, bump module manifest & refresh build metadata

 - ≡ƒô¥ [docs] Expand and modernize documentation across docs/ and module help (CONTRIBUTING.md, Development.md, TESTING.md, QUICK_REFERENCE.md, NPM_SCRIPTS.md, Publishing.md, ROADMAP.md, MODULE_SUMMARY.md, etc.): add "Advanced Usage" sections, best practices, troubleshooting, CI/CD & publishing guidance, performance benchmarking, terminal compatibility, and dozens of runnable examples.
 - Γ£¿ [feat] Add summary & status artifacts to capture the work: DOCUMENTATION_ENHANCEMENT_COMPLETE.md, DOCUMENTATION_EXPANSION_SUMMARY.md, DOCUMENTATION_INDEX.md, DOCUMENTATION_STATUS_REPORT.md, HELP_ENHANCEMENTS_SUMMARY.md.
 - ≡ƒÜ£ [refactor] Propagate cmdlet naming / usage updates across docs and generated help: update references and examples to New-ColorScriptCache / Update-ColorScriptCache and refresh many en-US cmdlet help files (Add-ColorScriptProfile, Clear-ColorScriptCache, Export-ColorScriptMetadata, Get-ColorScriptConfiguration, Get-ColorScriptList, New-ColorScript, New-ColorScriptCache, Reset-ColorScriptConfiguration, Show-ColorScript).
 - ≡ƒº╣ [chore] [dependency] Update module manifest ModuleVersion to 2025.10.30.1631 and update ReleaseNotes block and HelpInfo UICultureVersion to reflect the new build.
 - ≡ƒæ╖ [ci] Regenerate help XML and refresh distribution release notes (dist/LatestReleaseNotes.md, dist/PowerShellGalleryReleaseNotes.md) so published help and changelogs match the expanded documentation and command updates.
 - ≡ƒ¢á∩╕Å [fix] Update build tooling and manifest generation (scripts/build.ps1): improve module description, include mascot & command overview, export Update-ColorScriptCache alias, normalize JSON/cache handling and apply minor link/content corrections.
 - ≡ƒº¬ [test] Improve testing documentation and npm script docs: document Pester workflows, coverage commands, verify sequences and CI matrix; add example test patterns and verification steps for local CI simulation.
 - ≡ƒÄ¿ [style] Polish wording, add quick-start snippets and cross-links, include "Last Updated" stamps and UX-oriented improvements across help pages for clearer developer & user guidance.

Signed-off-by: Nick2bad4u <20943337+Nick2bad4u@users.noreply.github.com> [`(8ff260a)`](https://github.com/Nick2bad4u/PS-Color-Scripts-Enhanced/commit/8ff260a704cc48f71efa9b34cdacb7c7a537440a)






## Contributors
Thanks to all the [contributors](https://github.com/Nick2bad4u/PS-Color-Scripts-Enhanced/graphs/contributors) for their hard work!
## License
This project is licensed under the [MIT License](https://github.com/Nick2bad4u/PS-Color-Scripts-Enhanced/blob/main/LICENSE)
*This changelog was automatically generated with [git-cliff](https://github.com/orhun/git-cliff).*

