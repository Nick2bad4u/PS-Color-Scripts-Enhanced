<!-- markdownlint-disable -->
<!-- eslint-disable markdown/no-missing-label-refs -->
# Changelog

All notable changes to this project will be documented in this file.

## [2025.10.13.1850] - 2025-10-13


[[eb4efa2](https://github.com/Nick2bad4u/PS-Color-Scripts-Enhanced/commit/eb4efa219f6e1c9c9845df8150d88b08843d58af)...
[eb4efa2](https://github.com/Nick2bad4u/PS-Color-Scripts-Enhanced/commit/eb4efa219f6e1c9c9845df8150d88b08843d58af)]
([compare](https://github.com/Nick2bad4u/PS-Color-Scripts-Enhanced/compare/eb4efa219f6e1c9c9845df8150d88b08843d58af...eb4efa219f6e1c9c9845df8150d88b08843d58af))


### ≡ƒÆ╝ Other

- Γ£¿ [feat] Enhances ANSI art and updates module

Updates module version and improves ANSI art rendering in welcome scripts.

- ≡ƒÄ¿ Enhances ANSI art rendering in `welcome-Bears2.ps1`:
  - Reduces `$repeatCount` from 6 to 3, likely optimizing the visual layout.
  - Introduces a second row of bears with a shifted color palette (`($repeat + 3) % $colors.Count`), adding visual variety. ≡ƒÉ╗≡ƒîê
- ≡ƒÄ¿ Improves ANSI art generation in `welcome-cats.ps1`:
  - Introduces a loop to generate two rows of cats. ≡ƒÉ▒
  - Modifies color selection to create a different color pattern for each row.
  - Uses `$boldon` to make the cats bold.
- ≡ƒº╣ Updates module manifest:
  - [dependency] Updates `ModuleVersion` from `'2025.10.13.1043'` to `'2025.10.13.1447'`, reflecting code changes ≡ƒöó
  - Updates the corresponding `ReleaseNotes` in the module manifest.
- ≡ƒô¥ Adds new scripts and updates documentation:
  - Introduces `Format-ColorScripts.ps1` to format PowerShell scripts using `Invoke-Formatter`, improving code consistency. Γ£ì∩╕Å
  - Updates `package.json` to include a command for formatting scripts: `"scripts:format": "pwsh -NoProfile -File ./scripts/Format-ColorScripts.ps1"`. ΓÜÖ∩╕Å
  - Updates `Development.md` with documentation for the new script conversion options and the format script. ≡ƒôû
- ≡ƒæ╖ Updates dependencies:
  - Upgrades `markdown-link-check` from `3.12.2` to `3.14.1` in `package.json` and `package-lock.json`, likely to address bugs or improve link checking functionality. ≡ƒöù

Signed-off-by: Nick2bad4u <20943337+Nick2bad4u@users.noreply.github.com> [`(eb4efa2)`](https://github.com/Nick2bad4u/PS-Color-Scripts-Enhanced/commit/eb4efa219f6e1c9c9845df8150d88b08843d58af)






## Contributors
Thanks to all the [contributors](https://github.com/Nick2bad4u/PS-Color-Scripts-Enhanced/graphs/contributors) for their hard work!
## License
This project is licensed under the [MIT License](https://github.com/Nick2bad4u/PS-Color-Scripts-Enhanced/blob/main/LICENSE)
*This changelog was automatically generated with [git-cliff](https://github.com/orhun/git-cliff).*

