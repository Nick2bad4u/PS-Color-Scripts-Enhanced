## [2025.10.25.536] - 2025-10-25


[[a9938ef](https://github.com/Nick2bad4u/PS-Color-Scripts-Enhanced/commit/a9938ef01c2933a44dff7b838deb3694780ad41a)...
[0d48754](https://github.com/Nick2bad4u/PS-Color-Scripts-Enhanced/commit/0d48754e9a2918878de6c7b28a1235f052ff9add)]
([compare](https://github.com/Nick2bad4u/PS-Color-Scripts-Enhanced/compare/a9938ef01c2933a44dff7b838deb3694780ad41a...0d48754e9a2918878de6c7b28a1235f052ff9add))


### ≡ƒÆ╝ Other

- Γ£¿ [feat] Expand colorscript collection to 498 and add slideshow functionality

≡ƒÄ¿ **Colorscript Collection Expansion**
 - Increases available colorscripts from 327 to 498 (52% growth) ≡ƒôÜ
 - Updates all documentation and metadata references across README files and module manifest
 - Reflects new collection size in cache documentation (~4.9MB for 498 scripts)

≡ƒÄ¼ **New Show-ColorScript Slideshow Capability**
 - Adds `-All` parameter to cycle through all colorscripts in alphabetical order ≡ƒöä
 - Introduces `-WaitForInput` flag for manual progression with spacebar between each script ΓÅ╕∩╕Å
 - Supports 'q' key to exit slideshow early for better user control
 - Works seamlessly with existing `-Category` filter for themed slideshows
 - Updates XML help documentation with three new usage examples demonstrating slideshow features

≡ƒôª **Build Tooling Enhancement**
 - Adds `git-cliff` dependency (v2.10.1) to package.json for automated changelog generation
 - Installs supporting dependencies: `execa`, `figures`, `get-stream`, `human-signals`, `is-plain-obj`, `is-stream`, `is-unicode-supported`, `npm-run-path`, `pretty-ms`, `cross-spawn`, and platform-specific git-cliff binaries ≡ƒö¿

≡ƒòÉ **Version & Timestamp Updates**
 - [dependency] Updates module version from 2025.10.20.1440 to 2025.10.25.0124
 - Updates generated timestamp in manifest to reflect latest build date

Enables richer user interaction for exploring the expanded colorscript library while maintaining backward compatibility with existing cmdlet usage.

Signed-off-by: Nick2bad4u <20943337+Nick2bad4u@users.noreply.github.com> [`(0d48754)`](https://github.com/Nick2bad4u/PS-Color-Scripts-Enhanced/commit/0d48754e9a2918878de6c7b28a1235f052ff9add)


- Γ£¿ [feat] Add -All and -WaitForInput parameters to cycle through colorscripts

Introduces new functionality to display all available colorscripts sequentially with optional manual control ≡ƒÄ¼

**Core Features:**
- Adds `-All` parameter to cycle through all colorscripts in alphabetical order
- Adds `-WaitForInput` parameter to pause between each script and wait for spacebar input
- Supports 'q' key to quit early when cycling through scripts
- Integrates with existing `-Category` and `-Tag` filters to show subset of scripts
- Displays progress counter showing current script number and total count

**Implementation Details:**
- Creates new 'All' parameter set in Show-ColorScript function ≡ƒôé
- Implements dual-mode progression: continuous auto-advance with slight delay, or manual spacebar-controlled stepping ΓÅ»∩╕Å
- Retrieves filtered script list using Get-ColorScriptEntry or Get-ColorScriptInventory depending on filter presence
- Respects existing `-NoCache` flag during cycling to allow cache bypass if needed
- Renders each script using standard rendering pipeline (cache-aware when possible)
- Shows user-friendly prompts indicating available controls (spacebar/q keys) ≡ƒÄ«

**UI/UX Enhancements:**
- Clears screen before each script display for clean presentation
- Shows formatted progress indicator with cyan/green color coding
- Displays helpful instructions based on mode (auto or manual)
- Provides visual feedback during spacebar input prompt

**Documentation Updates:**
- Updates help documentation with new parameter descriptions
- Adds three new usage examples showing different cycling scenarios ≡ƒôÜ
- Documents parameter sets and accepted values
- Explains keyboard controls for interactive mode

**File Housekeeping:**
- Removes trailing blank lines from 60+ colorscript files to maintain consistency ≡ƒº╣
- Cleans up whitespace in unused and oversized ANSI art files

**Script Analysis Tool Enhancement:**
- Extends Analyze-UnusedAnsiFiles.ps1 with new filtering capabilities
- Adds `-ExcludeRegularAscii` flag to filter out text-only files without extended ASCII art
- Adds `-AsciiCharLimit` parameter to exclude text-heavy files (artist info, copyright notices)
- Implements character counting helper to distinguish art vs. text content
- Provides better categorization in analysis results distinguishing between oversized, ASCII-only, and error files

Signed-off-by: Nick2bad4u <20943337+Nick2bad4u@users.noreply.github.com> [`(3a0713e)`](https://github.com/Nick2bad4u/PS-Color-Scripts-Enhanced/commit/3a0713e570de4ca89ebaae9d9ef3abe3896a1207)


- Γ£¿ [feat] Add ANSI file analysis and display utilities for terminal size optimization

Introduces two new PowerShell utilities to enhance ANSI art file management and discovery:

**Analyze-UnusedAnsiFiles.ps1** ≡ƒôè
- Scans unused ANSI files to identify those fitting standard terminal dimensions (Γëñ120 columns, Γëñ50 lines)
- Implements CP437 encoding support for proper DOS/OEM character rendering
- Strips SAUCE metadata (a standard container format for ANSI art) to extract embedded dimension hints
- Calculates actual terminal dimensions by:
  - Removing ANSI escape sequences from line content
  - Parsing cursor positioning commands to infer layout
  - Detecting single-line wrapped content and estimating height
- Provides flexible output options: CSV export, file copying, or automated PowerShell script conversion
- Generates detailed reports with size distribution analysis and error handling
- Enables batch conversion of suitable files to PowerShell ColorScript format

**Show-AscFile.ps1** ≡ƒÄ¿
- Displays ASCII/ANSI art files with proper encoding (CP437)
- Handles both raw and gzip-compressed files transparently
- Clears screen before rendering for clean presentation

Both utilities support the workflow of curating and converting legacy ANSI art assets into modern PowerShell color scripts, automating the discovery of viable candidates based on terminal compatibility constraints.

Signed-off-by: Nick2bad4u <20943337+Nick2bad4u@users.noreply.github.com> [`(a9938ef)`](https://github.com/Nick2bad4u/PS-Color-Scripts-Enhanced/commit/a9938ef01c2933a44dff7b838deb3694780ad41a)






## Contributors
Thanks to all the [contributors](https://github.com/Nick2bad4u/PS-Color-Scripts-Enhanced/graphs/contributors) for their hard work!
## License
This project is licensed under the [MIT License](https://github.com/Nick2bad4u/PS-Color-Scripts-Enhanced/blob/main/LICENSE)
*This changelog was automatically generated with [git-cliff](https://github.com/orhun/git-cliff).*

