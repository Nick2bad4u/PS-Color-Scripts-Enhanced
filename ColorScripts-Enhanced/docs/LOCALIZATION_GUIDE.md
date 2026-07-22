# Localization Guide

ColorScripts-Enhanced ships localized runtime messages and external command help for 10 cultures:

`de`, `en-US`, `es`, `fr`, `it`, `ja`, `nl`, `pt`, `ru`, and `zh-CN`.

Localization is maintained, not “finished.” Every public command, parameter, example, and user-facing message can change with the module and must remain synchronized across all cultures.

## Localized Assets

Each culture directory under `ColorScripts-Enhanced/` contains:

- `Messages.psd1` for runtime messages;
- one Markdown help topic for each public command;
- `about_ColorScripts-Enhanced.help.txt` for conceptual help;
- `ColorScripts-Enhanced-help.xml`, generated from that culture's Markdown topics; and
- `ColorScripts-Enhanced-help.xml.HelpInfo.xml`, whose module version must match the manifest.

`en-US` is the authoritative source for help structure and the final fallback for runtime messages. Translated topics may localize prose, but command names, parameter names, accepted values, output properties, examples, and links must describe the same implementation.

## Runtime Message Resolution

The module builds a fallback chain from the current UI culture and its parent cultures, then falls back to `en-US` and embedded English defaults. The exact loading implementation lives in `ColorScripts-Enhanced.psm1` and the localization helpers under `ColorScripts-Enhanced/Private/`.

`COLOR_SCRIPTS_ENHANCED_LOCALIZATION_MODE` controls resource loading:

| Value      | Behavior                                                        |
| ---------- | --------------------------------------------------------------- |
| `auto`     | Uses the module's normal optimized selection logic              |
| `full`     | Forces loading localized `Messages.psd1` resources from disk    |
| `embedded` | Uses the embedded English defaults without reading resource files |

`COLOR_SCRIPTS_ENHANCED_PREFER_EMBEDDED_MESSAGES` remains a compatibility switch. New automation should use `COLOR_SCRIPTS_ENHANCED_LOCALIZATION_MODE`. `COLOR_SCRIPTS_ENHANCED_FORCE_LOCALIZATION` is also retained for compatibility with full-file loading.

Every `Messages.psd1` file must contain the same keys as `en-US/Messages.psd1`. The values can differ, but placeholder indices such as `{0}` and `{1}` must remain compatible with the English source.

## Updating a Runtime Message

1. Add or update the semantic key in `ColorScripts-Enhanced/en-US/Messages.psd1`.
2. Update the embedded English default with the same key in `ColorScripts-Enhanced.psm1`.
3. Update that key in all nine translated resource files.
4. Preserve all composite-format placeholders and their meanings.
5. Run the localization and module tests.

`scripts/Extract-LocalizableStrings.ps1` can help discover literal strings, but it is not a complete source-of-truth generator. Review its output manually; semantic keys and runtime use still require deliberate edits.

## Updating Command Help

The Markdown files are the editable source. The MAML XML is generated output.

1. Confirm the real public command metadata and behavior from `ColorScripts-Enhanced/Public/`, the manifest, and tests.
2. Update the matching `en-US/<Command>.md` topic.
3. Apply the same structural and factual change to every translated Markdown topic. Do not translate command names, parameter names, property names, environment-variable names, or literal accepted values.
4. Preserve each topic's single canonical **Online Version** link.
5. Regenerate all MAML and HelpInfo files:

   ```powershell
   npm run build:help
   ```

6. Review the diff. A help build should not silently erase translated prose.

The repository uses Microsoft.PowerShell.PlatyPS to import each Markdown topic explicitly and export culture-specific MAML. Run the pinned version used by the build and publish workflows when reproducibility matters.

## Adding a Culture

Use a PowerShell-supported culture name and add a directory under `ColorScripts-Enhanced/`.

1. Copy the `en-US` runtime and Markdown sources as the structural baseline.
2. Translate user-facing prose without changing keys, syntax, identifiers, or placeholders.
3. Add a localized `about_ColorScripts-Enhanced.help.txt` topic.
4. Run `npm run build:help` to generate the culture's MAML and HelpInfo files.
5. Add the culture to localization/help tests that enumerate supported directories.
6. Test both the exact culture and a regional child culture when parent fallback is expected.

Do not advertise a culture as complete while substantial English prose remains. Mixed-language help is functionally usable, but it should be reported honestly as partial translation.

## Validation

```powershell
# Regenerate Markdown metadata, MAML, and HelpInfo.
npm run build:help

# Run the repository's module and localization tests.
npm run test:pester

# Validate Markdown formatting and links.
npm run markdown:check
```

Also inspect imported help in a clean process:

```powershell
$env:COLOR_SCRIPTS_ENHANCED_LOCALIZATION_MODE = 'full'
Import-Module ./ColorScripts-Enhanced/ColorScripts-Enhanced.psd1 -Force
Get-Help Show-ColorScript -Full
Get-Help about_ColorScripts-Enhanced
```

For a non-English check, start a process with the intended UI culture or use the repository's localization tests. Changing only `[cultureinfo]::CurrentCulture` after module import does not reproduce startup resource resolution.

## Review Checklist

- [ ] Runtime message keys match `en-US` exactly.
- [ ] Composite-format placeholders match the English source.
- [ ] All 10 public commands have one Markdown and one generated MAML topic per culture.
- [ ] Syntax and parameter metadata match the exported commands.
- [ ] Help examples invoke real parameter sets and describe real output objects.
- [ ] HelpInfo versions match `ModuleVersion`.
- [ ] Each topic has one canonical online link.
- [ ] Translated prose was reviewed by a fluent speaker or explicitly labeled as partial.
