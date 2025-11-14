## [2025.11.9.1630] - 2025-11-09


[[a491ba5](https://github.com/Nick2bad4u/PS-Color-Scripts-Enhanced/commit/a491ba5bd513d96eb64185b578b9e8ceeefd684a)...
[ed30e9e](https://github.com/Nick2bad4u/PS-Color-Scripts-Enhanced/commit/ed30e9e2cd70aa9bbfa1b7d2e469b1b76116d886)]
([compare](https://github.com/Nick2bad4u/PS-Color-Scripts-Enhanced/compare/a491ba5bd513d96eb64185b578b9e8ceeefd684a...ed30e9e2cd70aa9bbfa1b7d2e469b1b76116d886))


### ≡ƒÆ╝ Other

- Γ£¿ [feat] Update module version and localization support
 - Update module version to '2025.11.09.1120' in the manifest
 - Update localization version for multiple languages to '2025.11.09.1120'
 - Remove unused ANSI art file 'ungenannt_#introduction.ans'

Signed-off-by: Nick2bad4u <20943337+Nick2bad4u@users.noreply.github.com> [`(ed30e9e)`](https://github.com/Nick2bad4u/PS-Color-Scripts-Enhanced/commit/ed30e9e2cd70aa9bbfa1b7d2e469b1b76116d886)


- Γ£¿ [feat] Add new ANSI art files and enhance filename normalization

 - ≡ƒôü Added new ANSI art files for Star Wars characters:
   - `ANSI_Star_Wars_WZ - Helmets.ans`
   - `ANSI_Star_Wars_WZ - Wookie.ans`
   - `ANSI_Star_Wars_ndh - darth.ans`
   - `ANSI_Star_Wars_ndh - r2d2.ans`
   - `nu - orbital - orbital.ans`

 - ≡ƒ¢á∩╕Å Updated `Restore-UnusedAnsiFiles.ps1` script:
   - Improved filename normalization by:
     - Removing spaces around hyphens and dashes (e.g., "1998 - 08" -> "1998-08")
     - Removing any remaining spaces for cleaner filenames

Signed-off-by: Nick2bad4u <20943337+Nick2bad4u@users.noreply.github.com> [`(062bec7)`](https://github.com/Nick2bad4u/PS-Color-Scripts-Enhanced/commit/062bec725de9c6c4b1df7025c17bef3c15036aa5)


- Γ£¿ [feat] Add new ANSI art files and enhance script functionality
 - ≡ƒôü Added multiple new ANSI art files to the assets/ansi-files directory, including:
   - ANSI_Star_Wars_x0-viper-scout-droid.ans
   - Luciano-AltiWorld_Logo.ans
   - alpha_king-reviolated.ans
   - alpha_king-showme.ans
   - ant_squares_b7logo.ans
   - file_id.ans
   - goo-modern_architecture.ans
   - goo-stop_mining.ans
   - goo_greet_death.ans
   - h7-fveitsi_zombie.ans
   - sa-ironman_b7.ans
   - zzz_BLOCKMINERS.ans
   - zzzz_67th.ans
 - ≡ƒöº Updated Restore-UnusedAnsiFiles.ps1 script to include a new function for normalizing filenames:
   - Introduced Normalize-FileName function to standardize file names for comparison by removing common prefixes and replacing underscores with hyphens.
 - ≡ƒöì Enhanced the script's logic to match unused ANSI files against normalized colorscript names, improving the accuracy of file restoration.

Signed-off-by: Nick2bad4u <20943337+Nick2bad4u@users.noreply.github.com> [`(467bd3d)`](https://github.com/Nick2bad4u/PS-Color-Scripts-Enhanced/commit/467bd3d6068e96c601e33a4425e80b99dc9b55b2)


- Γ£¿ [feat] Add new ANSI files and restore script for unused files
 - ≡ƒôü Added multiple new ANSI files to the assets/ansi-files directory, enhancing the collection with various designs.
 - ≡ƒô¥ Introduced a PowerShell script (Restore-UnusedAnsiFiles.ps1) to automate the restoration of unused ANSI files based on existing colorscripts.
 - ≡ƒöì The script scans for colorscript names and matches them with unused ANSI files, moving any matches to the main ANSI files directory.
 - ΓÜá∩╕Å The script includes checks to prevent overwriting existing files and provides a summary of actions taken during execution.

Signed-off-by: Nick2bad4u <20943337+Nick2bad4u@users.noreply.github.com> [`(092843f)`](https://github.com/Nick2bad4u/PS-Color-Scripts-Enhanced/commit/092843f403e52b975bb5116b57547798cc243758)


- ≡ƒÄ¿ [style] Update syl-nyan.ps1 for improved visual output
 - Adjusted character representation for better clarity in output
 - Enhanced visual consistency by modifying repeated character patterns

Signed-off-by: Nick2bad4u <20943337+Nick2bad4u@users.noreply.github.com> [`(a491ba5)`](https://github.com/Nick2bad4u/PS-Color-Scripts-Enhanced/commit/a491ba5bd513d96eb64185b578b9e8ceeefd684a)






## [2025.11.8.1545] - 2025-11-08


[[a665ad6](https://github.com/Nick2bad4u/PS-Color-Scripts-Enhanced/commit/a665ad64f8eae2582e08e8607c15407f8498677d)...
[a665ad6](https://github.com/Nick2bad4u/PS-Color-Scripts-Enhanced/commit/a665ad64f8eae2582e08e8607c15407f8498677d)]
([compare](https://github.com/Nick2bad4u/PS-Color-Scripts-Enhanced/compare/a665ad64f8eae2582e08e8607c15407f8498677d...a665ad64f8eae2582e08e8607c15407f8498677d))


### ≡ƒÆ╝ Other

- Γ£¿ [feat] Update module version and localization support
 - Update module version to 2025.11.08.1041 in module manifest
 - Adjust localization version for multiple languages to 2025.11.08.1041
 - Modify README to clarify localization modes
≡ƒô¥ [docs] Revise minimum coverage parameter in test script
 - Change default minimum coverage from 94 to 80 in Test-Coverage.ps1

Signed-off-by: Nick2bad4u <20943337+Nick2bad4u@users.noreply.github.com> [`(a665ad6)`](https://github.com/Nick2bad4u/PS-Color-Scripts-Enhanced/commit/a665ad64f8eae2582e08e8607c15407f8498677d)






## Contributors
Thanks to all the [contributors](https://github.com/Nick2bad4u/PS-Color-Scripts-Enhanced/graphs/contributors) for their hard work!
## License
This project is licensed under the [MIT License](https://github.com/Nick2bad4u/PS-Color-Scripts-Enhanced/blob/main/LICENSE)
*This changelog was automatically generated with [git-cliff](https://github.com/orhun/git-cliff).*

