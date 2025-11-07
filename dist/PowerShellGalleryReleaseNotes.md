## [2025.11.7.803] - 2025-11-07


[[ed4c182](https://github.com/Nick2bad4u/PS-Color-Scripts-Enhanced/commit/ed4c18269d262fa1ff2658a6dfe1f318597513f3)...
[1376dd6](https://github.com/Nick2bad4u/PS-Color-Scripts-Enhanced/commit/1376dd62675cd1b8e3a0d5bfeb27dbf4008e9d35)]
([compare](https://github.com/Nick2bad4u/PS-Color-Scripts-Enhanced/compare/ed4c18269d262fa1ff2658a6dfe1f318597513f3...1376dd62675cd1b8e3a0d5bfeb27dbf4008e9d35))


### ≡ƒÆ╝ Other

- Γ£¿ [feat] Update module version and help info for localization improvements
 - Update module version to '2025.11.07.0137' in manifest and help files
 - Enhance caching system with OS-wide cache in AppData
 - Improve progress reporting in New-ColorScriptCache function for better user feedback
 - Ensure no background runspace pools remain before analyzer runs to avoid errors

Signed-off-by: Nick2bad4u <20943337+Nick2bad4u@users.noreply.github.com> [`(1376dd6)`](https://github.com/Nick2bad4u/PS-Color-Scripts-Enhanced/commit/1376dd62675cd1b8e3a0d5bfeb27dbf4008e9d35)


- Γ£¿ [feat] Enhance cache building with multi-threading support
 - ≡ƒô¥ Added documentation for the new `-Parallel` switch in `New-ColorScriptCache` to enable parallel cache builds on multi-core systems.
 - ≡ƒ¢á∩╕Å Implemented the `-Threads` parameter (alias for `-ThrottleLimit`) to control the number of concurrent workers during cache builds.
 - ΓÜí Improved performance by allowing cache builds to run in parallel, defaulting to the number of logical processors if `-Threads` is not specified.
 - ≡ƒô¥ Updated help files in multiple languages to reflect the new features and version updates.
 - ≡ƒº¬ Added tests to verify the functionality of the new parallel cache building feature, ensuring it returns correct metadata for successful and failed cache operations.
 - ≡ƒº¬ Included tests for the `-Parallel` and `-Threads` parameters to confirm they work as expected.

Signed-off-by: Nick2bad4u <20943337+Nick2bad4u@users.noreply.github.com> [`(3541e61)`](https://github.com/Nick2bad4u/PS-Color-Scripts-Enhanced/commit/3541e614d7283bc9cfee95cd1d1bf01a751cd20f)


- Γ£¿ [feat] Add console-preferred ANSI informational output and extend Write-ColorScriptInformation API
 - ≡ƒ¢á∩╕Å Add new parameters to Write-ColorScriptInformation: -NoAnsiOutput, -PreferConsole, -Color and implement robust output-selection logic
 - ≡ƒºá Detect COLOR_SCRIPTS_ENHANCED_FORCE_ANSI environment variable (case-insensitive true/1/yes/force/ansi/color) to force ANSI rendering when requested
 - ΓÜí Prefer console rendering by calling Write-RenderedText when PreferConsole is set or when console is not redirected (safe Test-ConsoleOutputRedirected check inside try/catch)
 - ≡ƒÄ¿ Provide ConsoleColor fallback: parse -Color to System.ConsoleColor, set [Console]::ForegroundColor, write sanitized output via script:ConsoleWriteDelegate, ensure trailing newline when needed, and restore original color in finally (errors are swallowed and traced)
 - ≡ƒº╛ Sanitize informational output with Remove-ColorScriptAnsiSequence for the information stream; if -NoAnsiOutput is present emit raw/plain output
 - ≡ƒöü When output was written to the console, set InformationAction = 'SilentlyContinue'; otherwise use 'Continue' and Write-Information -Tags 'ColorScripts'

Γ£¿ [feat] Propagate output-preference flags through public cmdlets
 - ≡ƒ¢á∩╕Å Update Clear-ColorScriptCache and New-ColorScriptCache to pass -PreferConsole and -Color 'Cyan' for summary segments so ANSI summaries can render to console when appropriate
 - ≡ƒ¢á∩╕Å Update Show-ColorScript to compute $preferConsoleOutput = -not $NoAnsiOutput and consistently pass -NoAnsiOutput, -PreferConsole and -Color to all informational calls (displaying, mode, progress, divider, prompts, finished)
 - ΓÜí Behavioral result: richer ANSI informational summaries in hosts that strip escape sequences while still honoring -NoAnsiOutput for plain-text needs

≡ƒô¥ [docs] Document FORCE_ANSI usage
 - ≡ƒô¥ Add Development.md guidance for COLOR_SCRIPTS_ENHANCED_FORCE_ANSI=1 to force ANSI informational summaries in hosts that strip escape sequences; clarify that commands still honor -NoAnsiOutput

≡ƒöº [build] [dependency] Update module/help stamps and release header
 - ≡ƒöº [dependency] Update ModuleVersion in [ColorScripts-Enhanced](https://github.com/Nick2bad4u/PS-Color-Scripts-Enhanced).psd1 to 2025.11.06.1527 and update the ReleaseNotes header to match
 - ≡ƒöº Sync localized HelpInfo UICultureVersion stamps (en-US, de, es, fr, it, ja, nl, pt, ru) to 2025.11.06.1527

≡ƒº¬ [test] Expand mocks and add coverage for new output paths
 - ≡ƒº¬ Update existing Mock for Write-ColorScriptInformation in AdditionalCoverage tests to accept (Message, [switch]Quiet, [switch]NoAnsiOutput, [switch]PreferConsole, [string]Color)
 - ≡ƒº¬ Add InternalCoverage tests that verify:
   - Γ£à prefer-console path invokes Write-RenderedText once and writes sanitized info with InformationAction 'SilentlyContinue'
   - Γ£à NoAnsiOutput path does not call Write-RenderedText and emits plain text via Write-Information with InformationAction 'Continue'

Signed-off-by: Nick2bad4u <20943337+Nick2bad4u@users.noreply.github.com> [`(ed4c182)`](https://github.com/Nick2bad4u/PS-Color-Scripts-Enhanced/commit/ed4c18269d262fa1ff2658a6dfe1f318597513f3)






## Contributors
Thanks to all the [contributors](https://github.com/Nick2bad4u/PS-Color-Scripts-Enhanced/graphs/contributors) for their hard work!
## License
This project is licensed under the [MIT License](https://github.com/Nick2bad4u/PS-Color-Scripts-Enhanced/blob/main/LICENSE)
*This changelog was automatically generated with [git-cliff](https://github.com/orhun/git-cliff).*

