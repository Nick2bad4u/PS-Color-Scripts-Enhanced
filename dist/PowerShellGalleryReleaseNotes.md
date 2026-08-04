## ✨ What's Changed

- <b>Commit Range: ➡️</b> [`v2026.7...c7fba22`](https://github.com/Nick2bad4u/PS-Color-Scripts-Enhanced/compare/v2026.7.20.2250...c7fba2258f2cba91c866ba48fc63cea7b9bf16a3 "View full commit range on GitHub")

### ✨ Features

- [`d459589`](https://github.com/Nick2bad4u/PS-Color-Scripts-Enhanced/commit/d4595898068671afd31694016d8f91a55b1127f7 "Diff: 4 files, +839 | -0") — ✨ [feat] Add hash-locked ANSI geometry review tools <sub><em>(4 files, +839, -0)</em></sub>

✨ [feat] Generate manifests only from reviewed high-confidence leading-margin and orphan-tail findings, with exact payload hashes and source-row geometry.

✨ [feat] Apply validated crops atomically while preserving presentation rows, ANSI control state, background-colored spaces, and source-fidelity locks.

🧪 [test] Cover reviewed crop selection, coordinate drift, duplicate actions, colored-space protection, payload drift, and passthrough rejection.

- [`def1662`](https://github.com/Nick2bad4u/PS-Color-Scripts-Enhanced/commit/def1662e877244543bc771de2f0751a0465e2534 "Diff: 2 files, +1064 | -0") — ✨ [feat] Add ANSI text review utilities <sub><em>(2 files, +1064, -0)</em></sub>

✨ [feat] Add a resumable, hyperlink-friendly report for ranking converted artwork by visible text content.

🧹 [chore] Add an AST-aware text removal utility that preserves ANSI controls, layout, encoding, and safe backup behavior.

- [`6733659`](https://github.com/Nick2bad4u/PS-Color-Scripts-Enhanced/commit/67336599ff2af606c9986db1014e00205d11c4cd "Diff: 2211 files, +167042 | -163901") — ✨ [feat] Reconcile the complete curated 2004-2026 ANSI archive <sub><em>(2211 files, +167042, -163901)</em></sub>

🎨 [art] Promote 2,404 accepted works as 5,277 faithful scripts, adding 9, removing 37 reviewed supersessions or rejections, and regenerating 2,163 outputs from deterministic authority.

🛠️ [fix] Preserve exact CP437 and iCE rendering, verified split geometry, Lake House's six full-width segments, Darman names, MM-HACKERS2 dimensions, and reviewed LPHT and TV-PHANT boundaries.

🔍 [audit] Synchronize every modern provenance entry with authentic normalized-render hashes while cryptographically preserving all 16,570 historical scripts, provenance blocks, and metadata signatures.

✅ [test] Parse all 5,277 modern scripts, import both complete metadata maps, prove the exact 2,211-path mutation set, and reproduce the staged validation hash after application.

- [`46e21e0`](https://github.com/Nick2bad4u/PS-Color-Scripts-Enhanced/commit/46e21e0470a03565c404ef9d4b9689de60be542d "Diff: 5213 files, +64724 | -45594") — ✨ [feat] Reconcile the complete curated 1990-2003 ANSI archive <sub><em>(5213 files, +64724, -45594)</em></sub>

🎨 [art] Promote 12,860 accepted works as 16,570 faithful scripts, adding 136, removing 96 reviewed supersessions or rejections, and regenerating 4,979 outputs from deterministic authority.

🛠️ [fix] Preserve exact CP437 geometry, iCE colors, margins, blank rows, and source coordinates while omitting fourteen corrupt SAUCE font fields without discarding valid SAUCE metadata.

🔍 [audit] Synchronize provenance and gallery metadata with canonical source, archive, render, and normalized-render hashes; retain 11,455 byte-identical scripts with zero undeclared removals or duplicate collisions.

✅ [test] Verify all 16,570 scripts byte-for-byte, parse every tracked output, import both metadata maps natively, and prove exact staged/tracked coverage after application.

- [`a88eb44`](https://github.com/Nick2bad4u/PS-Color-Scripts-Enhanced/commit/a88eb442d623a31b0687bf1b724dc689ae8eebf4 "Diff: 2187 files, +197552 | -0") — ✨ [feat] Import the complete curated 1995 ANSI archive <sub><em>(2187 files, +197552, -0)</em></sub>

🎨 [art] Add 964 accepted works as 2,185 faithful CP437 scripts, including 787 fully reviewed split originals.

🔍 [audit] Reject thirteen duplicate or content-policy sources and record exact attribution, source coordinates, and normalized render hashes.

✅ [test] Verify 964/964 works, 2,185/2,185 scripts, all thirteen provenance tests, parsing, geometry, duplicate detection, and content-signal review.

- [`c8fc04b`](https://github.com/Nick2bad4u/PS-Color-Scripts-Enhanced/commit/c8fc04b489d0eee77cb2191010428b033c0a353d "Diff: 2094 files, +186711 | -0") — ✨ [feat] Import curated 1994 16colors artwork <sub><em>(2094 files, +186711, -0)</em></sub>

- [`0708d7b`](https://github.com/Nick2bad4u/PS-Color-Scripts-Enhanced/commit/0708d7b0ac24e3ad8117af595dfc016733b20e31 "Diff: 8328 files, +627496 | -0") — ✨ [feat] Import curated 16colors art from 1990-1993 and 1996-1997 <sub><em>(8328 files, +627496, -0)</em></sub>

✨ [feat] Add 8,326 faithfully converted and composition-reviewed ANSI scripts from 7,691 canonical original works, preserving CP437 geometry, iCE colors, colored spaces, margins, and verified split coordinates.

📝 [docs] Synchronize file-scoped 16colors permission provenance, source and render hashes, artist attribution, archive metadata, gallery categories, tags, and descriptions for every imported script.

🧪 [test] Validate exact gallery conversion for all six years, zero merged-corpus duplicate outputs, zero filename conflicts, and all 13 artwork provenance checks.

- [`9eaf51b`](https://github.com/Nick2bad4u/PS-Color-Scripts-Enhanced/commit/9eaf51bb65406e5a99e98ba63cddb5d8647275f5 "Diff: 983 files, +82894 | -245") — ✨ [feat] Curate the 1999 16colors archive <sub><em>(983 files, +82894, -245)</em></sub>

- [`bde0468`](https://github.com/Nick2bad4u/PS-Color-Scripts-Enhanced/commit/bde04686077f130bce1afe8ce4fce965349786cc "Diff: 1441 files, +106856 | -2") — ✨ [feat] Curate the 1998 16colors archive <sub><em>(1441 files, +106856, -2)</em></sub>

- [`f540f00`](https://github.com/Nick2bad4u/PS-Color-Scripts-Enhanced/commit/f540f00ce86fcdf8520dacacf581d41b93bf8ec3 "Diff: 397 files, +30669 | -2") — ✨ [feat] Curate the 2000 16colors archive <sub><em>(397 files, +30669, -2)</em></sub>

✨ [feat] Import 351 reviewed multicolor works as 393 exact terminal-safe scripts, rejecting continuous compositions that could not be split without cropping figures or scenes.

✨ [feat] Preserve CP437, SAUCE, iCE color state, source margins, background-colored spaces, and reviewed source-row boundaries without reflowing or narrowing artwork.

📝 [docs] Add file-scoped artist, group, pack, archive, source, render, encoding, license, and coordinate provenance plus gallery metadata for every emitted script.

🧪 [test] Record narrow reviewed analyzer exceptions and update the static corpus lock to 10,174 scripts with the existing 17 dynamic renderers.

- [`6dcf5e4`](https://github.com/Nick2bad4u/PS-Color-Scripts-Enhanced/commit/6dcf5e42d147ea93a82cfe2a378f71ec00a338fa "Diff: 338 files, +25705 | -2") — ✨ [feat] Curate the 2001 16colors archive <sub><em>(338 files, +25705, -2)</em></sub>

- [`30d8616`](https://github.com/Nick2bad4u/PS-Color-Scripts-Enhanced/commit/30d8616b860cce659a346eb9483b9c98902a74c9 "Diff: 479 files, +39379 | -29") — ✨ [feat] Curate the 2002 16colors archive <sub><em>(479 files, +39379, -29)</em></sub>

✨ [feat] Add 449 accepted ANSI works as 473 exact terminal-cell scripts from 169 packs and 1,285 reviewed candidates.

✨ [feat] Record file-scoped artist, group, pack, archive, hash, encoding, SAUCE, and source-coordinate provenance for every emitted script.

🧹 [chore] Extend the compact archive checkpoint through 2002 and preserve reviewed split and attribution exceptions.

🧪 [test] Lock complete provenance coverage, valid optional SAUCE fields, reviewed geometry, and the 9,447-script corpus total.

- [`df9d983`](https://github.com/Nick2bad4u/PS-Color-Scripts-Enhanced/commit/df9d9835997900ca1e5cc7c8b6b3ce1b1a51e496 "Diff: 184 files, +13633 | -1") — ✨ [feat] Curate the 2003 16colors archive <sub><em>(184 files, +13633, -1)</em></sub>

✨ [feat] Add 182 visually reviewed multicolor ANSI works from 123 packs, preserving their exact CP437 terminal-cell geometry, colors, margins, and source provenance without reflow or splitting.

📝 [docs] Register file-scoped artist, group, pack, archive, source-hash, render-hash, encoding, SAUCE, and permission metadata for every imported script.

🛡️ [fix] Exclude a corpus duplicate and two recognizable third-party-image candidates whose underlying rights are outside the documented artist permission scope.

- [`8bdad26`](https://github.com/Nick2bad4u/PS-Color-Scripts-Enhanced/commit/8bdad261bccc5d465c42d2b7a87d1d457fdccb0e "Diff: 41 files, +2789 | -0") — ✨ [feat] Curate 2006 and 2007 16colors artwork <sub><em>(41 files, +2789, -0)</em></sub>

- [`0b16269`](https://github.com/Nick2bad4u/PS-Color-Scripts-Enhanced/commit/0b16269adbad77a5bd39ff8942f6d9504cc625a0 "Diff: 8 files, +116 | -10") — ✨ [feat] Queue continuous ANSI split families for review <sub><em>(8 files, +116, -10)</em></sub>

✨ [feat] Aggregate dense no-alternative boundaries by split family so reviewers can assess whether every emitted panel stands alone.

🧪 [test] Cover continuous dense artwork without conflating it with avoidable blank-boundary cuts.

📝 [docs] Document the new review signal in both source and packaged developer guides.

- [`cf0056e`](https://github.com/Nick2bad4u/PS-Color-Scripts-Enhanced/commit/cf0056e6db233c783775315b82f89da2de5d1a42 "Diff: 246 files, +20759 | -1") — ✨ [feat] Curate 2004 and 2005 16colors artwork <sub><em>(246 files, +20759, -1)</em></sub>

✨ [feat] Import 92 visually reviewed multicolor originals as 243 exact CP437 and iCE-safe scripts.

📝 [docs] Record file-scoped attribution, archive and render hashes, source coordinates, SAUCE metadata, gallery tags, and descriptions.

🧪 [test] Accept canonical raw fallbacks when the API supplies no ZIP filename and verify the imported provenance contract.

- [`0fd6bca`](https://github.com/Nick2bad4u/PS-Color-Scripts-Enhanced/commit/0fd6bca6eb6b429f20ae65ccd6f3df73448ac223 "Diff: 6 files, +877 | -34") — ✨ [feat] Add ANSI gallery quality review queues <sub><em>(6 files, +877, -34)</em></sub>

✨ [feat] Detect mergeable neighbors, dense split seams, proportional tiny tails, SAUCE height loss, sparse output, low structural or color variety, and suspicious character decoding.

🛠️ [fix] Treat background-colored spaces as visible terminal cells, collapse bright and dark variants into color families, and avoid interpreting valid CP437 glyphs as corruption.

🧹 [chore] Keep reviewed composition-driven split exceptions exact and fail when exception entries become stale or ambiguous.

🧪 [test] Exercise thresholds, colored-space behavior, family aggregation, blank-boundary suggestions, argument validation, and exception matching.

📝 [docs] Document deterministic fidelity checks and collection-wide human review workflows using direct Node commands.

- [`089afbb`](https://github.com/Nick2bad4u/PS-Color-Scripts-Enhanced/commit/089afbb9813c5cd83e54010c60119852d1d574fc "Diff: 252 files, +21334 | -24") — ✨ [feat] Import curated 2008-2011 ANSI archives <sub><em>(252 files, +21334, -24)</em></sub>

✨ [feat] Add 103 accepted 16colors works as 246 exact-cell PowerShell scripts with preserved CP437 geometry, color state, whitespace, source coordinates, hashes, and attribution.

🧹 [chore] Extend the compact archive checkpoint through 2008 and synchronize provenance and gallery metadata for the completed 2008-2011 review tranche.

🧪 [test] Lock the 8,511-script corpus, require the expanded 2008-2026 checkpoint, and document two reviewed derivative-signal false positives.

- [`67cfc30`](https://github.com/Nick2bad4u/PS-Color-Scripts-Enhanced/commit/67cfc3038a028093cd5f33c6ad925270cd886684 "Diff: 906 files, +99432 | -24") — ✨ [feat] Import curated 2012-2016 ANSI archives <sub><em>(906 files, +99432, -24)</em></sub>

✨ [feat] Import 292 accepted multicolor works as 885 cell-exact scripts from 2,115 reviewed 16colors candidates.

🧹 [chore] Synchronize source attribution, terminal geometry, render hashes, metadata, reviewed analyzer exceptions, and the compact 2012-2026 curation checkpoint.

🧪 [test] Validate checkpoint completeness and provenance resolution while locking the expanded 8,265-script static corpus.

📝 [docs] Record the completed archive years, updated collection totals, and the remaining 1990-2011 review backlog.

- [`3c426fa`](https://github.com/Nick2bad4u/PS-Color-Scripts-Enhanced/commit/3c426fa5207e966dfa0ea43b337cdd819f693689 "Diff: 4209 files, +375079 | -537") — ✨ [feat] Import curated 16colors and Roy ANSI archives <sub><em>(4209 files, +375079, -537)</em></sub>

🎨 [feat] Add the reviewed 2017-2026 16colors corpus, expanded Roy and SAC collections, and The Lake House with exact source-row and panel geometry.

✂️ [fix] Rebalance tiny split tails and malformed panel boundaries while preserving authentic blank rows, margins, colored spaces, and terminal dimensions.

⚖️ [fix] Remove low-quality, duplicate, and underlying commercial-art derivatives that are outside the documented permission boundary.

📝 [docs] Record file-scoped attribution, archive hashes, render hashes, SAUCE and iCE details, source coordinates, and Roy FAL-1.3 licensing.

🧪 [test] Lock the 7,380-script corpus, provenance coverage, gallery geometry, duplicate rules, and static output extraction.

- [`28214ba`](https://github.com/Nick2bad4u/PS-Color-Scripts-Enhanced/commit/28214ba3a8bff019fca19cab0ef603e3e1b384aa "Diff: 7 files, +5476 | -1") — ✨ [feat] Add resumable ANSI archive audit tooling <sub><em>(7 files, +5476, -1)</em></sub>

✨ [feat] Inventory 16colors and Roy archives with bounded pagination, caching, retries, offline resume, metadata validation, source and render hashing, and review reports.

🔎 [feat] Add terminal-cell quality analysis for split geometry, blank runs, sparse or plain output, and derivative-attribution review.

🧪 [test] Cover API pagination, retries, filtering, duplicate detection, analysis thresholds, and fail-closed exception drift.

🧹 [chore] Ignore resumable audit caches and expose the developer commands through package scripts.

- [`799d11c`](https://github.com/Nick2bad4u/PS-Color-Scripts-Enhanced/commit/799d11cd6ed1adba849e46fdfc10f77a5df8293a "Diff: 82 files, +2630 | -360") — 🎨 [feat] Curate multicolor ANSI gallery imports <sub><em>(82 files, +2630, -360)</em></sub>

🎨 Add 34 high-quality multicolor works as 39 terminal-friendly scripts from Roy/SAC, Asciiville, Durdraw, and os-ansi; remove eight monochrome or duotone os-ansi imports.

🧩 Split oversized Roy compositions at reviewed row boundaries while preserving source provenance, SAUCE metadata, and rendered geometry.

🔒 Preserve LF/CRLF-sensitive passthrough artwork byte-for-byte and extend conversion tooling with modification provenance and stable split output names.

⚖️ Correct Roy/SAC licensing to file-scoped FAL-1.3, add complete third-party notices, and reject unlicensed, monochrome, duotone, and ambiguous collections.

📚 Update gallery counts, source links, audited future collections, Botany flowering-stage metadata, and corpus documentation.

✅ Verify 609 Pester tests, 28 converter tests, 6 smoke checks, strict analysis of 115 PowerShell files, remark lint, staged source hashes, and diff integrity.

- [`967f5e6`](https://github.com/Nick2bad4u/PS-Color-Scripts-Enhanced/commit/967f5e619084ff953f0873db3c241cc93297ba1a "Diff: 232 files, +22473 | -17161") — ✨ [feat] Modernize module and curate ANSI artwork <sub><em>(232 files, +22473, -17161)</em></sub>

🛡️ Harden trust boundaries, cache policy, path handling, dynamic and static rendering, profile behavior, configuration persistence, and PassThru semantics.

🌍 Rebuild authoritative help for all ten cultures, remove translated-help leakage, localize generated metadata, and enforce structural and semantic parity.

🎨 Add curated Botany, os-ansi, and Roy/SAC artwork with pinned provenance, license notices, source hashes, and byte-exact Botany passthrough.

🧪 Expand converter, provenance, localization, cache, and rendering coverage while synchronizing the current documentation set.

### 🛠️ Bug Fixes

- [`c7fba22`](https://github.com/Nick2bad4u/PS-Color-Scripts-Enhanced/commit/c7fba2258f2cba91c866ba48fc63cea7b9bf16a3 "Diff: 6 files, +135 | -23") — 🛠️ [fix] Make release verification platform-stable <sub><em>(6 files, +135, -23)</em></sub>

🔗 Route PowerShell provenance checks through the shared fail-closed reader without relying on PS7-only data-file parameters.

🌐 Read translated help as strict UTF-8 and normalize line endings before line-anchored assertions.

🧪 Remove filesystem ordering assumptions from random-selection refresh coverage and verify the compatibility adapter.

- [`bb0cbec`](https://github.com/Nick2bad4u/PS-Color-Scripts-Enhanced/commit/bb0cbec23bba5c5010f2fe8440f742f9a145f198 "Diff: 2 files, +39 | -0") — 🛠️ [fix] Preserve hash-locked artwork bytes <sub><em>(2 files, +39, -0)</em></sub>

🧊 Disable Git line-ending conversion for all color scripts and generated provenance evidence.

🧪 Verify effective text attributes for representative scripts and hash-locked metadata files.

- [`4abd270`](https://github.com/Nick2bad4u/PS-Color-Scripts-Enhanced/commit/4abd2705e5cc185ceb20ec2dad8693bb038944d5 "Diff: 2 files, +37 | -0") — 🛠️ [fix] Align release commits with changelog validation <sub><em>(2 files, +37, -0)</em></sub>

🛠️ [fix] Discover exact emoji-formatted release-preparation commits in the current release range and pass their validated SHA-1 values to git-cliff, keeping generated changelog content stable after the final metadata commit.

🧪 [test] Lock the version-shaped commit subject, SHA validation, and explicit git-cliff skip wiring into the repository release tests.

- [`fa4a03f`](https://github.com/Nick2bad4u/PS-Color-Scripts-Enhanced/commit/fa4a03f25cc2fb9c54071c98ed9283f68cb2ed4c "Diff: 2 files, +33 | -0") — 🛠️ [fix] Exclude repository-only docs from module builds <sub><em>(2 files, +33, -0)</em></sub>

🛠️ [fix] Prevent the documentation mirror from copying the 25 MiB artwork web index, its GitHub Pages viewer, or separately published updatable-help CAB and ZIP archives into module/docs.

🧪 [test] Lock the build exclusions to their exact relative paths and prove the publishable module contains none of those repository-only artifacts.

- [`e97b960`](https://github.com/Nick2bad4u/PS-Color-Scripts-Enhanced/commit/e97b9603d399798915f00d20efbd1a3de5417b29 "Diff: 6 files, +62 | -9") — 🛠️ [fix] Preserve CP437 accented ANSI art cells <sub><em>(6 files, +62, -9)</em></sub>

🛠️ [fix] Treat CP437 Ñ and Ç cells as single-width terminal art so safe reviewed redactions do not fail on legacy ANSI rows.

🧹 [chore] Blank the formerly blocked repeated bad-language range using the hash-locked review ledger.

🧪 [test] Add CP437 accented-cell coverage, the one-hundred-sixth review ledger, and synchronized curation totals.

- [`64c34da`](https://github.com/Nick2bad4u/PS-Color-Scripts-Enhanced/commit/64c34daf796018c8468c417bfba40bfa268f8536 "Diff: 6 files, +62 | -9") — 🛠️ [fix] Handle CP437 bullet cells during ANSI redaction <sub><em>(6 files, +62, -9)</em></sub>

🛠️ [fix] Treat the CP437 bullet as a single-cell terminal-art glyph so reviewed column blanking remains geometry-safe on mixed ANSI rows.

🧹 [chore] Blank the remaining separable profanity from the attributed Lazarus artwork without altering its surrounding dollar-sign typography.

🧪 [test] Add bullet fidelity coverage, hash-lock review ledger 100, and synchronize curation totals.

- [`0086eb4`](https://github.com/Nick2bad4u/PS-Color-Scripts-Enhanced/commit/0086eb4c7c1170b094f0cccb78bc051ffd5d4599 "Diff: 6 files, +56 | -9") — 🛠️ [fix] Preserve CP437 smiley cells during redaction <sub><em>(6 files, +56, -9)</em></sub>

🛠️ [fix] Classify CP437 smiley glyphs as protected single-width terminal-art cells so adjacent profanity can be blanked without corrupting the rendered geometry.

🧪 [test] Add CP437-smiley and Ledger 98 regression coverage while removing the previously blocked profanity span.

- [`2d998e8`](https://github.com/Nick2bad4u/PS-Color-Scripts-Enhanced/commit/2d998e81c0aaf4428d30c6930cb586c11be96a35 "Diff: 2 files, +10 | -2") — 🛠️ [fix] Recognize the CP437 not sign as an ANSI cell <sub><em>(2 files, +10, -2)</em></sub>

🛠️ [fix] Treat the CP437 not-sign glyph as one approved terminal-art cell during targeted text blanking.

- The authoritative decoder maps byte 0xAA to U+00AC, so archived rows can now be projected without weakening fail-closed handling for arbitrary Unicode.

🧪 [test] Preserve the not-sign and adjacent box-art cell while blanking only the reviewed text range at constant width.

- [`7acf042`](https://github.com/Nick2bad4u/PS-Color-Scripts-Enhanced/commit/7acf0428aa4fa7a9897bb761b5a59101d1f9b986 "Diff: 2 files, +10 | -2") — 🛠️ [fix] Recognize CP437 guillemets as ANSI cells <sub><em>(2 files, +10, -2)</em></sub>

🛠️ [fix] Treat left and right guillemets as approved single-cell CP437 artwork glyphs during targeted text blanking.

- This preserves menu hotkey framing while keeping ambiguous Unicode glyph handling fail-closed.

🧪 [test] Cover blanking placeholder text beside a guillemet-framed hotkey without changing row geometry.

- [`c45b68f`](https://github.com/Nick2bad4u/PS-Color-Scripts-Enhanced/commit/c45b68f16fbc86b9e47a4f37816e59dfa244aefb "Diff: 2 files, +13 | -2") — 🛠️ [fix] Preserve CP437 symbols during column blanking <sub><em>(2 files, +13, -2)</em></sub>

🛠️ [fix] Classify archived CP437 symbols as single art cells so targeted text removal keeps original ANSI geometry intact.

🧪 [test] Cover mixed CP437 glyphs around multiple blanked column ranges and assert unchanged cell counts.

- [`6edea76`](https://github.com/Nick2bad4u/PS-Color-Scripts-Enhanced/commit/6edea769b7a0d1f8b0b4807a9fa5091dbccc35b0 "Diff: 1 file, +4 | -22") — 🛠️ [fix] Protect ANSI labels in batch 20 review <sub><em>(1 file, +4, -22)</em></sub>

🛠️ [fix] Remove an identity field label and a functional command prompt from the text-blanking ledger.

- Reconcile the ledger summary to 230 safe rows across 48 scripts after full projection review.

- [`a211ff5`](https://github.com/Nick2bad4u/PS-Color-Scripts-Enhanced/commit/a211ff5afeb389ff8a2e2aabdbc93eda5e430bf7 "Diff: 258 files, +7293 | -3086") — 🛠️ [fix] Complete reviewed ANSI content cleanup <sub><em>(258 files, +7293, -3086)</em></sub>

🛠️ [fix] Apply the hash-reviewed contact, promotional-text, policy-retention, and geometry decisions across 240 affected gallery scripts while preserving terminal styling and source order.

⚙️ [refactor] Rebalance 26 split families and 134 outputs with generated-presentation-row exclusion, hash-locked outer trims, visible-content balancing, deterministic source ranges, and fail-closed manifest validation.

🧾 [chore] Synchronize provenance row ranges, curation totals, analysis exceptions, review ledgers, and developer commands with the retained 24,851-script gallery.

🧪 [test] Cover contact evidence, adult-tag retention, geometry actions, provenance boundaries, and rebalancer drift, visibility, style, and conservation invariants.

- [`048cf4d`](https://github.com/Nick2bad4u/PS-Color-Scripts-Enhanced/commit/048cf4d619828d5dd1ea3694b407215d38a70aa8 "Diff: 4 files, +204 | -12") — 🛠️ [fix] Harden ANSI contact content review <sub><em>(4 files, +204, -12)</em></sub>

🛠️ [fix] Exclude date-and-baud false positives, preserve an exact functional Nerd Fonts URL exception, and audit authored source when rendering or literal extraction fails.

🛠️ [fix] Preserve reviewed blank-text and remove-row actions plus normalized category metadata when generating evidence ledgers.

🧪 [test] Cover fallback contact scanning, hash-scoped exceptions, raw action validation, and the corrected leading-row baseline.

- [`87bda96`](https://github.com/Nick2bad4u/PS-Color-Scripts-Enhanced/commit/87bda96caa7276da6bbcd7834658ef94c1570425 "Diff: 12 files, +2108 | -33") — 🛠️ [fix] Harden ANSI content review tooling <sub><em>(12 files, +2108, -33)</em></sub>

🛠️ [fix] Preserve rendered colored spaces, verify hash-backed review evidence, and remove reviewed rows without losing terminal control state.

✨ [feat] Add content, geometry, and policy review-ledger tooling with conservative baseline-aware blank-row cleanup.

🧪 [test] Cover contact false positives, row geometry, stale evidence, removal manifests, and analyzer review signals.

- [`2a576df`](https://github.com/Nick2bad4u/PS-Color-Scripts-Enhanced/commit/2a576dfbdbef55c9020c616cf8f875e3d9880adb "Diff: 23 files, +117 | -49") — 🛠️ [fix] Restore exact passthrough ANSI payloads <sub><em>(23 files, +117, -49)</em></sub>

🛠️ [fix] Rebuild 21 UTF-8 source scripts as byte-preserving PowerShell literals.

- Preserve source line geometry, trailing resets, and original ANSI color transitions.

🔧 [build] Record Passthrough or TerminalEmulation conversion mode in generated metadata.

🧪 [test] Verify conversion-mode markers and exact passthrough execution on PowerShell.

- [`e277773`](https://github.com/Nick2bad4u/PS-Color-Scripts-Enhanced/commit/e27777371d53b8a92319ff68c1d34051d74722df "Diff: 148 files, +7588 | -10939") — 🛠️ [fix] Publish deterministic localized help packages <sub><em>(148 files, +7588, -10939)</em></sub>

🛠️ [fix] Normalize fenced MAML examples, synchronize translated metadata, and publish one canonical HelpInfo plus deterministic ZIP and CAB packages for all ten cultures.

🛠️ [fix] Keep cross-platform help checks fail-closed by validating exact case-sensitive artifact names, preserving only expected CABs when makecab is unavailable, and safely removing stale managed files.

🧪 [test] Validate localized command contracts, package contents, byte stability, stale artifact cleanup, protected output paths, and missing, extra, or mis-cased CAB failures.

- [`d649370`](https://github.com/Nick2bad4u/PS-Color-Scripts-Enhanced/commit/d6493700796da8feb0b6677ba06c9151ed9f4bb1 "Diff: 355 files, +101229 | -13569") — 🛠️ [fix] Finalize ANSI archive fidelity repairs <sub><em>(355 files, +101229, -13569)</em></sub>

🛠️ [fix] Regenerate reviewed ANSI families without reflow, correct source-row metadata, normalize static Write-Host layout, and remove rejected or unsupported gallery entries.

🧹 [chore] Reconcile 37 years of archive decisions into the fail-closed curation checkpoint with complete provenance, exact geometry, visual-review evidence, and reviewed analysis exceptions.

🧪 [test] Cover checkpoint staleness, importable dispositions, DOS EOF detection, SAUCE encoding validation, deterministic color execution, and the 25,121-script corpus contract.

- [`4176797`](https://github.com/Nick2bad4u/PS-Color-Scripts-Enhanced/commit/4176797b74e5cb3d5724676cbef95b7b67e5ec63 "Diff: 10 files, +278 | -121") — 🛠️ [fix] Regenerate Roy ANSI art with exact terminal geometry <sub><em>(10 files, +278, -121)</em></sub>

🛠️ [fix] Re-render the seven Roy/SAC scripts whose emitted payloads changed under the corrected DOS ANSI cursor semantics, including the restored 86th RHCP2 row.

- Preserve the authoritative 126-work, 153-script corpus and its reviewed split boundaries without cropping, reflowing, narrowing, or palette substitution.

📝 [docs] Synchronize corrected full-render hashes, add normalized render hashes for every Roy script, remove three invalid year-zero claims, and mark Roy works sourced through 16colors under the existing FAL-1.3 boundary.

🧪 [test] Require file-scoped Roy provenance to retain valid render hashes and source coordinates.

- [`29ea515`](https://github.com/Nick2bad4u/PS-Color-Scripts-Enhanced/commit/29ea5150fb5dd5f9804f9039e2afe49c63c7ddd8 "Diff: 5 files, +318 | -42") — 🛠️ [fix] Match archival ANSI rendering semantics <sub><em>(5 files, +318, -42)</em></sub>

🛠️ [fix] Align DOS CR, LF, TAB, cursor movement, and right-margin wrapping with libansilove while preserving modern UTF-8 terminal behavior.

🛠️ [fix] Centralize first-SUB logical EOF handling so file conversion, splitting, archive fingerprints, previews, and duplicate analysis ignore post-EOF bytes consistently.

🛠️ [fix] Apply archival terminal semantics to every supported DOS code page instead of CP437 alone.

🧪 [test] Cover full-width control paths, cursor sentinels, non-CP437 CLI conversion, SAUCE and COMNT EOF framing, and archive-buffer hashing.

- [`a3b13b8`](https://github.com/Nick2bad4u/PS-Color-Scripts-Enhanced/commit/a3b13b84d8a0fdf90bd33c8b80809dac1e04942f "Diff: 4 files, +0 | -148") — 🛠️ [fix] Remove duplicate 1993 ICE repack <sub><em>(4 files, +0, -148)</em></sub>

- [`a9fdf50`](https://github.com/Nick2bad4u/PS-Color-Scripts-Enhanced/commit/a9fdf50edf5e43968c693c6b08d56822d5508627 "Diff: 18 files, +37 | -1352") — 🛠️ [fix] Remove duplicate 2016 retrospective artwork <sub><em>(18 files, +37, -1352)</em></sub>

- [`d14563d`](https://github.com/Nick2bad4u/PS-Color-Scripts-Enhanced/commit/d14563d6db4b3b80db8e237964e6d27ac2348b62 "Diff: 2 files, +304 | -14") — 🛠️ [fix] Make imported archive years reproducibly auditable <sub><em>(2 files, +304, -14)</em></sub>

🛠️ [fix] Add repeatable --exclude-existing-manifest support so a finalized archive year can be re-audited without classifying its own checked-in scripts as prior imports.

🔧 [build] Validate manifest uniqueness, nonempty script inventories, exact provenance hashes, legacy source-only provenance, and render-cache exclusions before changing the gallery baseline.

🧪 [test] Cover argument parsing, cache filtering, stale and duplicate manifests, empty manifests, exact hash exclusion, and a real 1990 gallery replay with an unchanged accepted set.

- [`2f2a44b`](https://github.com/Nick2bad4u/PS-Color-Scripts-Enhanced/commit/2f2a44bf9ea53b20b20b112626b484908c67f137 "Diff: 34 files, +66 | -1175") — 🛠️ [fix] Correct the 1999 ANSI curation <sub><em>(34 files, +66, -1175)</em></sub>

🛠️ [fix] Remove 13 scripts from six originals whose continuous or disconnected compositions could not be split into coherent gallery entries.

🧹 [chore] Reconcile the 1999 audit to 670 works and 966 scripts, including provenance, metadata, analyzer exceptions, checkpoint hashes, and mirrored documentation.

🧪 [test] Enforce accepted-source cardinality and lock the corrected 12,578-script static corpus; verify strict lint, exact conversion, duplicate checks, and focused Pester coverage.

- [`6d10f26`](https://github.com/Nick2bad4u/PS-Color-Scripts-Enhanced/commit/6d10f26b4f8a9b52efda97eb0db9492cae2857fb "Diff: 2 files, +119 | -15") — 🛡️ [fix] Detect generated ANSI duplicates <sub><em>(2 files, +119, -15)</em></sub>

- [`8aa46cd`](https://github.com/Nick2bad4u/PS-Color-Scripts-Enhanced/commit/8aa46cd63f31874a36661218d2b157fa88a69e93 "Diff: 61 files, +88 | -68") — 🛠️ [fix] Omit incomplete SAUCE metadata <sub><em>(61 files, +88, -68)</em></sub>

🛠️ [fix] Validate SAUCE calendar dates and positive declared dimensions before emitting generated provenance comments.

🎨 [style] Remove 62 invalid placeholder comments from 59 existing scripts without changing their artwork payloads.

🧪 [test] Cover NUL dates, malformed dates, zero dimensions, and valid leap-day metadata.

- [`97b727d`](https://github.com/Nick2bad4u/PS-Color-Scripts-Enhanced/commit/97b727d67a0658bd4a073f3f790e1672fdd30f1e "Diff: 2 files, +44 | -0") — 🛡️ [fix] Preserve automatic ANSI audit classifications <sub><em>(2 files, +44, -0)</em></sub>

🛡️ [fix] Apply manual review decisions only while a candidate remains pending, so later duplicate, parser, and safety classifications cannot be overwritten by stale acceptance records.

🧪 [test] Cover a previously accepted source that becomes an automatic corpus duplicate and verify the current classification remains authoritative.

- [`0c8b4ca`](https://github.com/Nick2bad4u/PS-Color-Scripts-Enhanced/commit/0c8b4ca64af3a1a4885dd90f1fe57bd8be1155ed "Diff: 2 files, +255 | -7") — 🛡️ [fix] Bind ANSI review decisions to render evidence <sub><em>(2 files, +255, -7)</em></sub>

- [`9be5dd5`](https://github.com/Nick2bad4u/PS-Color-Scripts-Enhanced/commit/9be5dd5df5788d2dcd637bf1285f5c71ebb613ae "Diff: 2 files, +21 | -3") — 🛠️ [fix] Ignore newline-terminated DOS EOF markers <sub><em>(2 files, +21, -3)</em></sub>

🛠️ [fix] Stop rendering CP437 SUB as a stray arrow when it is a terminal DOS EOF marker followed only by CR/LF bytes.

🧪 [test] Preserve intentional blank rows before the marker and cover the newline-terminated archive form.

- [`c5d7972`](https://github.com/Nick2bad4u/PS-Color-Scripts-Enhanced/commit/c5d79726586da729616140edc4060a95d1013d77 "Diff: 2 files, +24 | -5") — 🛠️ [fix] Match DOS ANSI bare-LF rendering <sub><em>(2 files, +24, -5)</em></sub>

- [`33d97a0`](https://github.com/Nick2bad4u/PS-Color-Scripts-Enhanced/commit/33d97a0249333af757cfcf4f4d208d4f23fe2fde "Diff: 9 files, +316 | -64") — 🛠️ [fix] Refine ANSI gallery quality diagnostics <sub><em>(9 files, +316, -64)</em></sub>

🛠️ [fix] Remove the invalid SAUCE-height-loss queue, expose exact per-script identities for reviewed exceptions, and keep split, blank-edge, complexity, palette, ASCII, and decoding signals independent.

🛠️ [fix] Record the visually verified LPHT and UBBS panel boundaries and authentic separator rows so intentional findings stay out of the actionable queue without weakening the checks.

🧪 [test] Verify metadata-only SAUCE padding and distinguish plain ASCII output from correctly decoded CP437 block artwork.

📝 [docs] Map each review concern to its analyzer queue, explain here-string and SAUCE geometry semantics, document attribution overrides, and synchronize the packaged documentation mirrors.

- [`e2b1e8a`](https://github.com/Nick2bad4u/PS-Color-Scripts-Enhanced/commit/e2b1e8a7155e64a069c5f806cd18a5d08ff7c21e "Diff: 10 files, +132 | -57") — 🛠️ [fix] Preserve observed ANSI archive geometry <sub><em>(10 files, +132, -57)</em></sub>

🛠️ [fix] Stop treating SAUCE tInfo2 as a minimum render height during archive auditing, conversion, splitting, and exact verification so unused canvas padding cannot become synthetic blank rows.

🛠️ [fix] Rebuild four reviewed artwork tails from the actual terminal stream and synchronize their source-row coordinates and normalized render hashes.

🛠️ [fix] Persist verified file-scoped artist and group overrides in resumable curation decisions with fail-closed array, name, and duplicate validation.

🧪 [test] Cover metadata-only SAUCE height and malformed attribution overrides; exact raw-source checks pass for every repaired family.

- [`1067229`](https://github.com/Nick2bad4u/PS-Color-Scripts-Enhanced/commit/1067229e8c893d3eea76d24cdfe4c6276d2d2e3e "Diff: 64 files, +1241 | -427") — 🛠️ [fix] Preserve ANSI source geometry across gallery splits <sub><em>(64 files, +1241, -427)</em></sub>

🛠️ [fix] Honor SAUCE-declared canvas height so trailing blank rows, background-colored spaces, margins, and source coordinates survive conversion, archive analysis, and splitting.

🛠️ [fix] Recut UBBS, LPHT, PHANT, Mistletoe, and eleven dense-boundary families at exact composition-aware rows while keeping every source cell and the 50-row gallery limit.

✨ [feat] Add an exact raw-ANSI conversion verifier that checks source identity, terminal-cell styles, panel coverage, and split adjacency without reflowing artwork.

🧪 [test] Cover trailing canvas rows, hostile literal serialization, verifier mismatches, metadata geometry, provenance hashes, duplicate safety, and the 8,513-script corpus.

📝 [docs] Synchronize artwork counts and record the source-fidelity verification requirement.

- [`0a40d09`](https://github.com/Nick2bad4u/PS-Color-Scripts-Enhanced/commit/0a40d096ab1365b96764bfaf5712aeb41465b956 "Diff: 3 files, +992 | -85") — 🛠️ [fix] Preserve exact ANSI geometry across conversion and splits <sub><em>(3 files, +992, -85)</em></sub>

🛠️ [fix] Respect SAUCE width, font and iCE flags, CP437 cells, cursor state, colored spaces, and source-authentic blank rows without palette substitution or trimming.

✂️ [feat] Slice terminal cells by validated row and column ranges while carrying active style state and producing deterministic panel and part names.

🧪 [test] Lock conversion geometry, style state, apostrophes, dimensions, ranges, and render hashes with regression fixtures.

- [`d845035`](https://github.com/Nick2bad4u/PS-Color-Scripts-Enhanced/commit/d845035c3dc5edecdcabe86e9555562e7744ef81 "Diff: 20 files, +68 | -28") — 🐛 [fix] Preserve ANSI artwork leading margins <sub><em>(20 files, +68, -28)</em></sub>

- start terminal-emulated output on the line below Write-Host
- keep passthrough output byte-exact and cover converter and splitter paths
- repair fourteen Roy scripts and ignore display margins in geometry checks
- document the safe multiline literal format

### 🚜 Refactor

- [`98bd9a1`](https://github.com/Nick2bad4u/PS-Color-Scripts-Enhanced/commit/98bd9a1737b556ce9729b3a0184c57b08d95a920 "Diff: 21964 files, +1669500 | -1298784") — 🚜 [refactor] Externalize archival artwork provenance <sub><em>(21964 files, +1669500, -1298784)</em></sub>

🚜 [refactor] Move developer review ledgers and the authoritative artwork provenance map out of the publishable module into audit/.

⚡ [perf] Replace 21,669 duplicated archival headers with compact offline title and artist attribution plus stable per-script details links while preserving every Write-Host payload byte-for-byte.

✨ [feat] Add the shared provenance reader, migration verifier, generated web index and details page, and provenance-backed converter, splitter, audit, geometry, pruning, verification, and rebalance integrations.

🧪 [test] Enforce exact migration hashes, unmapped-script stability, external field reconstruction, URL coverage, license boundaries, generated-record completeness, compact package headers, and terminal geometry.

📝 [docs] Document the external provenance architecture, package boundary, permission evidence, developer commands, and source workflow across root and module documentation.

### 📝 Documentation

- [`4bc5316`](https://github.com/Nick2bad4u/PS-Color-Scripts-Enhanced/commit/4bc531695cb13bcab1074f7e8234ba60eb7f5a7a "Diff: 2 files, +2 | -6") — 📝 [docs] Update source modification details in HW-LOST.ANS script <sub><em>(2 files, +2, -6)</em></sub>

- Clarified the project curation process by specifying the removal of blank rows introduced by redaction.

- Enhanced the description of preserved elements, including ANSI controls, terminal-art glyphs, and source coordinates.
📝 [docs] Revise permission notice in 16colors-discord-permission.txt

- Removed outdated attestation details and emphasized the project's fair use status as a non-commercial, educational, and archival gallery.

- [`a08f3d3`](https://github.com/Nick2bad4u/PS-Color-Scripts-Enhanced/commit/a08f3d3eceec281feee254acf40bd244e021d4b7 "Diff: 15 files, +25 | -19") — 📝 [docs] Synchronize ANSI curation records <sub><em>(15 files, +25, -19)</em></sub>

📝 [docs] Update root and packaged documentation to the retained 24,851-script gallery, 15,083 accepted 16colors works, and 21,524 emitted archive scripts.

🧾 [docs] Document the contact, geometry, and adult-policy evidence ledgers together with the final row-cleanup and rebalancing totals.

🗺️ [docs] Refresh the mirrored roadmap, module summary, conversion guide, documentation index, and review date.

- [`2951e5d`](https://github.com/Nick2bad4u/PS-Color-Scripts-Enhanced/commit/2951e5dec18f272068743624e7a75ac7435ea7f6 "Diff: 19 files, +95 | -58") — 📝 [docs] Synchronize final archive and help documentation <sub><em>(19 files, +95, -58)</em></sub>

📝 [docs] Record the completed 1990-2026 curation totals, 25,121-script gallery size, final provenance model, review evidence, and Roy and 16colors collection boundaries.

📝 [docs] Document checkpoint, gallery, conversion, and help verification commands together with cross-platform CAB behavior and deterministic package maintenance.

📝 [docs] Keep root and mirrored module guides, roadmap, summaries, indexes, README counts, and gallery metadata aligned with the final implementation.

- [`ccb8bda`](https://github.com/Nick2bad4u/PS-Color-Scripts-Enhanced/commit/ccb8bda36a502109174510ec58af15c05991461c "Diff: 2 files, +16 | -0") — 📝 [docs] Document reproducible archive re-audits <sub><em>(2 files, +16, -0)</em></sub>

- [`80aeca1`](https://github.com/Nick2bad4u/PS-Color-Scripts-Enhanced/commit/80aeca1960459742b2c09a24e91b75c8a3813dc8 "Diff: 17 files, +17135 | -57") — 📝 [docs] Complete the 1998-1999 archive checkpoints <sub><em>(17 files, +17135, -57)</em></sub>

- [`03a2eed`](https://github.com/Nick2bad4u/PS-Color-Scripts-Enhanced/commit/03a2eed2bebcce82d84a8e2f8b70c4796ebff48c "Diff: 17 files, +2915 | -50") — 📝 [docs] Complete the 2000 archive checkpoint <sub><em>(17 files, +2915, -50)</em></sub>

📝 [docs] Extend the compact 16colors checkpoint through 2000 with 1,239 packs, 14,623 candidates, 3,674 accepted works, 6,642 emitted scripts, per-year disposition totals, and accepted source hashes.

📝 [docs] Synchronize both documentation trees, gallery counts, roadmap status, package summary, and archive estimates around the 10,174-script collection and the remaining 1990-1999 review.

🧪 [test] Expand checkpoint provenance assertions to the completed 2000-2026 range and its 27 audited years.

- [`cdd4c3e`](https://github.com/Nick2bad4u/PS-Color-Scripts-Enhanced/commit/cdd4c3e00c0f7175545c6f44c784047230b3c983 "Diff: 17 files, +2647 | -48") — 📝 [docs] Complete the 2001 archive checkpoint <sub><em>(17 files, +2647, -48)</em></sub>

- [`8abece0`](https://github.com/Nick2bad4u/PS-Color-Scripts-Enhanced/commit/8abece03b769e717fc061911c359825087e0fd16 "Diff: 15 files, +23 | -23") — 📝 [docs] Complete the 2002 archive checkpoint <sub><em>(15 files, +23, -23)</em></sub>

📝 [docs] Update mirrored guides, source notes, roadmap status, and package summaries for the completed 2002-2026 review.

📝 [docs] Record 857 packs, 12,078 candidates, 3,013 accepted works, 5,915 emitted scripts, and the 1990-2001 remaining scope.

🧹 [chore] Regenerate all documented corpus counts for the 9,447-script module.

- [`af28b80`](https://github.com/Nick2bad4u/PS-Color-Scripts-Enhanced/commit/af28b808ccb743b77bac42fa0b62fda1cc63e98e "Diff: 18 files, +1619 | -53") — 📝 [docs] Complete the 2003 archive checkpoint <sub><em>(18 files, +1619, -53)</em></sub>

📝 [docs] Expand the compact 16colors checkpoint through 2003 and synchronize root and module documentation to 688 packs, 10,793 candidates, 2,564 accepted works, 5,442 emitted scripts, and 8,974 bundled colorscripts.

🧪 [test] Extend completed-year provenance coverage to 2003-2026 and lock the updated static corpus at 8,957 extractable scripts plus 17 explicitly dynamic scripts.

📝 [docs] Record 1990-2002 as the remaining historical review range and retain the API's eight opaque unreturned pack records as an explicit inventory limitation.

- [`82f27e5`](https://github.com/Nick2bad4u/PS-Color-Scripts-Enhanced/commit/82f27e5c4da6c32dc58d3ae7ee4e3b147d568b19 "Diff: 17 files, +1305 | -48") — 📝 [docs] Complete 2004-2007 archive checkpoint <sub><em>(17 files, +1305, -48)</em></sub>

- [`53174b3`](https://github.com/Nick2bad4u/PS-Color-Scripts-Enhanced/commit/53174b3a10a6e5f4af54d244ff16a5d621c93afb "Diff: 11 files, +11 | -11") — 📝 [docs] Synchronize colorscript inventory counts <sub><em>(11 files, +11, -11)</em></sub>

Update the root, packaged, gallery, summary, roadmap, and setup documentation from 8,513 to the current 8,756-script inventory after the 2004–2005 archive imports.

Keep every mirrored generated count marker aligned and verify the Gallery README remains within the PowerShell Gallery size limit.

- [`9baea69`](https://github.com/Nick2bad4u/PS-Color-Scripts-Enhanced/commit/9baea6907670d85f4993b82cc0c275c4681f31ea "Diff: 15 files, +23 | -23") — 📝 [docs] Document the 2008-2011 archive tranche <sub><em>(15 files, +23, -23)</em></sub>

📝 [docs] Update mirrored READMEs, artwork-source guidance, conversion inventory, roadmap scope, and generated documentation counts for the 8,511-script gallery.

📝 [docs] Record the completed 2008-2026 totals of 393 packs, 8,781 candidates, 2,252 imported works, and 4,979 emitted 16colors scripts while retaining the 1990-2007 backlog estimate.

- [`e4aa468`](https://github.com/Nick2bad4u/PS-Color-Scripts-Enhanced/commit/e4aa4683a5215ca79288edf0d93cc9568219be6a "Diff: 19 files, +325 | -205") — 📝 [docs] Document ANSI curation and fidelity workflows <sub><em>(19 files, +325, -205)</em></sub>

📝 [docs] Synchronize root and packaged guidance for the 7,380-script gallery, completed 2017-2026 review window, attribution boundaries, and remaining archive backlog.

💡 [docs] Explain why generated artwork uses non-interpolating multiline literals instead of double-quoted here-strings and why authentic blank rows remain part of source geometry.

🔎 [docs] Document the resumable archive audit, quality analyzer, exact conversion, row and column splitting, and verification commands.

### ⚡ Performance

- [`846278b`](https://github.com/Nick2bad4u/PS-Color-Scripts-Enhanced/commit/846278b2e94096d4af2cc84c99e500541cfe57ea "Diff: 98 files, +1823 | -848") — ⚡ [perf] Restore fast colorscript selection and expose details <sub><em>(98 files, +1823, -848)</em></sub>

⚡ [perf] Cache lightweight inventory records and select random scripts without materializing the full metadata catalog.

✨ [feat] Add Show-ColorScript -ShowInfo output and remove Pokemon filtering while retaining compatibility switches as no-ops.

🚜 [refactor] Remove obsolete Pokemon cache, profile prompt, and selective-cache plumbing.

🧪 [test] Cover the random fast path, compatibility parameters, selective caching, profile defaults, and script-information output.

📝 [docs] Synchronize public docs, ten translated help sets, metadata, counts, and generated help packages.

### 🎨 Styling

- [`fc32985`](https://github.com/Nick2bad4u/PS-Color-Scripts-Enhanced/commit/fc3298523ab5d5b9a1d0f4c1eeba828e9c97ac80 "Diff: 4093 files, +25828 | -18695") — 🎨 [style] Apply reviewed ANSI content cleanup <sub><em>(4093 files, +25828, -18695)</em></sub>

🎨 [style] Remove reviewed contact, promotional, and orphaned footer rows across 4,091 gallery scripts while preserving ANSI controls, colored spaces, and retained source geometry.

🧹 [chore] Record hash-only content and blank-geometry review evidence so every applied redaction remains reproducible without retaining identifying text.

🛠️ [fix] Compact only blank rows introduced by curation and restore source-authored leading margins after removed headings.

- [`40461ef`](https://github.com/Nick2bad4u/PS-Color-Scripts-Enhanced/commit/40461ef7b18414070199445972d9ae20dc339f89 "Diff: 1 file, +1 | -1") — 🎨 [style] Correct ANSI artwork text <sub><em>(1 file, +1, -1)</em></sub>

🎨 [style] Remove the stray text embedded in the BLi 8-94 artwork while preserving its spacing and color controls.

### 🧪 Testing

- [`a64db53`](https://github.com/Nick2bad4u/PS-Color-Scripts-Enhanced/commit/a64db5321a605ce59d57f7e5c7106b99ebb57ffa "Diff: 1 file, +2 | -2") — 🧪 [test] Sync the static corpus count <sub><em>(1 file, +2, -2)</em></sub>

🧪 [test] Reconcile the static-output regression gate with the two exact duplicate scripts intentionally removed in a4bac835f.

- Lock the current 24,822-script corpus, including 24,805 statically available scripts and 17 explicit dynamic-policy entries.

- [`b3c6bb4`](https://github.com/Nick2bad4u/PS-Color-Scripts-Enhanced/commit/b3c6bb470da1f577dfe1e1c9c43bcff92f757e78 "Diff: 1 file, +2 | -2") — 🧪 [test] Synchronize static corpus size <sub><em>(1 file, +2, -2)</em></sub>

🧪 [test] Update the bundled-script regression lock to the current 8,792-script catalog while preserving the explicit 17-script dynamic-render policy.

### 🧹 Chores

- [`a6c59c9`](https://github.com/Nick2bad4u/PS-Color-Scripts-Enhanced/commit/a6c59c96e7555be81a97ba5f7ff91ce6253e751e "Diff: 13 files, +224 | -15") — 🧹 [chore] Blank remaining ANSI bad-language variants <sub><em>(13 files, +224, -15)</em></sub>

🧹 [chore] Replace nine hash-verified residual bad-language ranges with same-style spaces while retaining terminal geometry and artwork.

🧪 [test] Add the one-hundred-fifth review ledger and synchronize curation totals.

- [`b6bb56c`](https://github.com/Nick2bad4u/PS-Color-Scripts-Enhanced/commit/b6bb56c667ff34ac6be52f9ab61fbd8a00b82e3b "Diff: 10 files, +173 | -14") — 🧹 [chore] Blank residual ANSI bad-language cells <sub><em>(10 files, +173, -14)</em></sub>

🧹 [chore] Replace seven hash-verified bad-language cells across six scripts with same-style spaces while preserving terminal art, colors, and layout.

🧪 [test] Add the one-hundred-fourth review ledger and synchronize curation totals.

- [`0fe9ba2`](https://github.com/Nick2bad4u/PS-Color-Scripts-Enhanced/commit/0fe9ba2fe45f090548288254715426ada01cfe0b "Diff: 13 files, +225 | -16") — 🧹 [chore] Blank offensive ANSI labels <sub><em>(13 files, +225, -16)</em></sub>

🧹 [chore] Replace nine hash-verified offensive label ranges with same-style spaces while retaining every surrounding terminal-art and layout cell.

🧪 [test] Add the one-hundred-third review ledger and synchronize curation totals.

- [`ac19645`](https://github.com/Nick2bad4u/PS-Color-Scripts-Enhanced/commit/ac19645f22c7e4f71c71427deb412061e41e22ee "Diff: 12 files, +207 | -19") — 🧹 [chore] Blank obfuscated ANSI profanity <sub><em>(12 files, +207, -19)</em></sub>

🧹 [chore] Replace eight hash-verified obfuscated profanity ranges with same-style spaces while preserving the surrounding ANSI artwork and geometry.

🧪 [test] Add the one-hundred-second review ledger and synchronize curation totals.

- [`7459c7a`](https://github.com/Nick2bad4u/PS-Color-Scripts-Enhanced/commit/7459c7ad7adb46644dfc401ad24eee2ba8eb8904 "Diff: 37 files, +877 | -56") — 🧹 [chore] Blank remaining ANSI bad-language cells <sub><em>(37 files, +877, -56)</em></sub>

🧹 [chore] Replace 41 independently hash-verified bad-language cells across 33 color scripts with same-style spaces, preserving each terminal canvas, artwork glyph, and ANSI color state.

🧪 [test] Record the one-hundred-first review ledger and synchronize curation checkpoint totals.

- [`5785a02`](https://github.com/Nick2bad4u/PS-Color-Scripts-Enhanced/commit/5785a02cf58e62f534f7c44e9ba92aef03bd61da "Diff: 5 files, +48 | -7") — 🧹 [chore] Blank final ANSI profanity fragment <sub><em>(5 files, +48, -7)</em></sub>

🧹 [chore] Replace the one safely separable malformed profanity fragment in the Heat Wave Lost Realms panel with same-style blank cells, preserving adjacent CP437 artwork, terminal geometry, and colors.

🧪 [test] Add the hash-locked ninety-ninth review ledger and synchronize curation checkpoint totals.

- [`06504df`](https://github.com/Nick2bad4u/PS-Color-Scripts-Enhanced/commit/06504df3e396ac84954827d58e5efd7d328948c4 "Diff: 9 files, +230 | -20") — 🧹 [chore] Blank ANSI profanity-bearing labels <sub><em>(9 files, +230, -20)</em></sub>

🧹 [chore] Remove twelve text-only profanity-bearing labels while preserving surrounding terminal art and excluding the ambiguous-width case.

🧪 [test] Add hash-locked Ledger 97 coverage and synchronize curation totals.

- [`19c76e1`](https://github.com/Nick2bad4u/PS-Color-Scripts-Enhanced/commit/19c76e1d022d19e2818b9bdb46a493282398af22 "Diff: 16 files, +305 | -26") — 🧹 [chore] Blank remaining clear ANSI profanity <sub><em>(16 files, +305, -26)</em></sub>

🧹 [chore] Remove thirteen exact profanity spans from twelve archived ANSI works while retaining all surrounding artwork, layout, attribution, and terminal styling.

🧪 [test] Add hash-locked Ledger 96 verification and synchronize audited cleanup totals.

- [`5bd8ac8`](https://github.com/Nick2bad4u/PS-Color-Scripts-Enhanced/commit/5bd8ac892ac4caa2a44d8af20784c00c066bcbe4 "Diff: 12 files, +201 | -19") — 🧹 [chore] Blank ANSI slurs and explicit terms <sub><em>(12 files, +201, -19)</em></sub>

🧹 [chore] Remove eight exact slurs, sexual terms, and profanity spans while retaining the surrounding ANSI artwork, layout, and metadata.

🧪 [test] Add hash-locked Ledger 95 verification and synchronize the curation checkpoint.

- [`99551bb`](https://github.com/Nick2bad4u/PS-Color-Scripts-Enhanced/commit/99551bb6e8a1803d29db2cedd7e3596af1d94f62 "Diff: 12 files, +224 | -18") — 🧹 [chore] Blank additional ANSI profanity <sub><em>(12 files, +224, -18)</em></sub>

🧹 [chore] Remove nine exact profanity spans from eight archived ANSI works while preserving all titles, credits, terminal-art glyphs, geometry, and colors.

🧪 [test] Add hash-locked Ledger 94 coverage and synchronize the audited curation totals.

- [`8a41769`](https://github.com/Nick2bad4u/PS-Color-Scripts-Enhanced/commit/8a41769294e349fcb812601e768f87e88d10c4a0 "Diff: 7 files, +115 | -12") — 🧹 [chore] Blank clear ANSI profanity <sub><em>(7 files, +115, -12)</em></sub>

🧹 [chore] Remove four exact profanity labels from three archived ANSI works while retaining every surrounding title, credit, layout cell, palette, and terminal-art glyph.

🧪 [test] Add hash-locked Ledger 93 coverage and synchronize curation totals for the reviewed profanity spans.

- [`a88970f`](https://github.com/Nick2bad4u/PS-Color-Scripts-Enhanced/commit/a88970f0a3feed22167547a5008cf751a3c1cf1b "Diff: 5 files, +199 | -18") — 🧹 [chore] Blank ANSI contributor commentary <sub><em>(5 files, +199, -18)</em></sub>

🧹 [chore] Remove only the explanatory contributor-process prose from the UC joint while retaining its on-art collaboration credit, palette, layout, and terminal-art glyphs.

🧪 [test] Register hash-locked Ledger 92 and synchronize curation totals for the eleven reviewed source rows.

- [`bca1dab`](https://github.com/Nick2bad4u/PS-Color-Scripts-Enhanced/commit/bca1dab36ccfa81f3291cceb347daf86ffb90495 "Diff: 5 files, +120 | -11") — 🧹 [chore] Blank archived creator contact aside <sub><em>(5 files, +120, -11)</em></sub>

🧹 [chore] Remove the separable creator aside, complete e-mail address, and closing salutation from the Lunatic logo while preserving its frame, title, terminal-art glyphs, layout, and ANSI palette.

🧪 [test] Add the ninety-first hash-locked mixed-text ledger and checkpoint invariants, covering every edited source cell and aggregate curation totals.

- [`dd1f6f2`](https://github.com/Nick2bad4u/PS-Color-Scripts-Enhanced/commit/dd1f6f2281118699410b72cf076f22b784b39512 "Diff: 2 files, +15 | -5") — 🧹 [chore] Synchronize ANSI pseudo-phone checkpoint <sub><em>(2 files, +15, -5)</em></sub>

🧹 [chore] Record the dismal-steel panel cleanup in aggregate curation totals.

🧪 [test] Assert the ninetieth mixed-text review counters.

- [`407f21c`](https://github.com/Nick2bad4u/PS-Color-Scripts-Enhanced/commit/407f21cbbf959338b414c451fd6777161b60ed14 "Diff: 3 files, +15 | -2") — 🧹 [chore] Blank ANSI pseudo-phone and greeting <sub><em>(3 files, +15, -2)</em></sub>

🧹 [chore] Remove the dismal-steel pseudo-phone field and creator greeting while preserving its BBS panel.

🧪 [test] Hash-lock the ninetieth mixed-text review.

- [`9b0fb76`](https://github.com/Nick2bad4u/PS-Color-Scripts-Enhanced/commit/9b0fb76177ea284704c3e2799f219af5b99201a0 "Diff: 2 files, +15 | -5") — 🧹 [chore] Synchronize ANSI reachability checkpoint <sub><em>(2 files, +15, -5)</em></sub>

🧹 [chore] Record the Scythe reachability-aside redaction in aggregate curation totals.

🧪 [test] Assert the eighty-ninth mixed-text review counters.

- [`cae479c`](https://github.com/Nick2bad4u/PS-Color-Scripts-Enhanced/commit/cae479c6d1fec0e67dd355a5bf1c193cc9426978 "Diff: 3 files, +15 | -2") — 🧹 [chore] Blank ANSI reachability aside <sub><em>(3 files, +15, -2)</em></sub>

🧹 [chore] Remove Scythe reachability text while preserving attributed panel framing and artwork.

🧪 [test] Hash-lock the eighty-ninth mixed-text review.

- [`63c8372`](https://github.com/Nick2bad4u/PS-Color-Scripts-Enhanced/commit/63c83725608d8e848ee89ab4b54c83b900ec70b7 "Diff: 2 files, +15 | -5") — 🧹 [chore] Synchronize ANSI access-panel checkpoint <sub><em>(2 files, +15, -5)</em></sub>

🧹 [chore] Record the FiRE access-panel redaction in aggregate curation totals.

🧪 [test] Assert the eighty-eighth mixed-text review counters.

- [`1e25cae`](https://github.com/Nick2bad4u/PS-Color-Scripts-Enhanced/commit/1e25caef2b2def52b245b65745e492c686c97383 "Diff: 3 files, +33 | -5") — 🧹 [chore] Blank ANSI access panel fields <sub><em>(3 files, +33, -5)</em></sub>

🧹 [chore] Remove framed access labels, handle, status, and location fields while preserving the FiRE artwork.

🧪 [test] Hash-lock the eighty-eighth mixed-text review projections.

- [`8861bdf`](https://github.com/Nick2bad4u/PS-Color-Scripts-Enhanced/commit/8861bdf55e3c9be9a94fb59768502d14632aecbf "Diff: 2 files, +15 | -5") — 🧹 [chore] Synchronize duplicated-contact checkpoint <sub><em>(2 files, +15, -5)</em></sub>

🧹 [chore] Record the two-file, eight-row contact-panel redaction in aggregate curation state.

🧪 [test] Assert the eighty-seventh mixed-text review counters.

- [`3997588`](https://github.com/Nick2bad4u/PS-Color-Scripts-Enhanced/commit/3997588dc0ce73f16a4027ea15989c7105d19772 "Diff: 4 files, +49 | -8") — 🧹 [chore] Blank duplicated ANSI contact panel <sub><em>(4 files, +49, -8)</em></sub>

🧹 [chore] Remove the duplicated PRiME Net contact panel through exact terminal-cell redactions while preserving adjacent artwork.

🧪 [test] Hash-lock all eight source-cell projections in the eighty-seventh mixed-text review.

- [`c28bc4d`](https://github.com/Nick2bad4u/PS-Color-Scripts-Enhanced/commit/c28bc4dc9cd8163c8bae0414b3c0f4d2bd74cd85 "Diff: 4 files, +24 | -7") — 🧹 [chore] Complete promotional-block audit trail <sub><em>(4 files, +24, -7)</em></sub>

🧹 [chore] Synchronize the retained-gallery checkpoint with the five-row promotional-block redaction.

🧪 [test] Assert the eighty-sixth mixed-text review counters in the content audit.

📝 [docs] Link the completed review evidence from both artwork-source documents.

- [`e746e8c`](https://github.com/Nick2bad4u/PS-Color-Scripts-Enhanced/commit/e746e8caf3d8ab761684c80d8d2eceb5d92be507 "Diff: 3 files, +40 | -5") — 🧹 [chore] Blank ANSI promotional contact block <sub><em>(3 files, +40, -5)</em></sub>

🧹 [chore] Remove the exact purchase invitation, direct-contact details, and generic originality claim while preserving the framed Lord Jazz artwork and attribution.

🧪 [test] Hash-lock the eighty-sixth mixed-text review against the rendered terminal-cell projections.

- [`d93a600`](https://github.com/Nick2bad4u/PS-Color-Scripts-Enhanced/commit/d93a600384db744ab97ab74b893efa84e9708223 "Diff: 7 files, +85 | -8") — 🧹 [chore] Blank ANSI conversational creator filler <sub><em>(7 files, +85, -8)</em></sub>

🧹 [chore] Remove only the separable nine-cell casual suffix from the Polyester joint-credit caption while retaining its artwork, color state, geometry, and Rippa/Fever attribution.

🧪 [test] Hash-lock the eighty-fifth mixed-text review and synchronize curation checkpoint totals.

📝 [docs] Link the new review evidence from both artwork-source documents.

- [`94d02e4`](https://github.com/Nick2bad4u/PS-Color-Scripts-Enhanced/commit/94d02e4045edfac24e30ed4703f75dc974dc6f6b "Diff: 6 files, +93 | -8") — 🧹 [chore] Complete ANSI production-aside audit trail <sub><em>(6 files, +93, -8)</em></sub>

🧹 [chore] Record the two hash-locked source-cell redactions for the Saga Neo script with fail-closed rationale, review sources, and normalized rendering contracts.

🧪 [test] Cover the eighty-fourth mixed-text review and synchronize retained-gallery checkpoint totals.

📝 [docs] Link the completed review evidence from both artwork-source documents.

- [`7d03f88`](https://github.com/Nick2bad4u/PS-Color-Scripts-Enhanced/commit/7d03f88fa234288cc726dd98882ad75c47350bfb "Diff: 2 files, +3 | -2") — 🧹 [chore] Blank ANSI creator production aside <sub><em>(2 files, +3, -2)</em></sub>

🧹 [chore] Remove two hash-locked creator-commentary spans from the Neo Nacho artwork while preserving every non-target terminal cell and ANSI control.

- [`636c0e1`](https://github.com/Nick2bad4u/PS-Color-Scripts-Enhanced/commit/636c0e1df81fbc969209c2e8e9b79ec9159a1b0c "Diff: 7 files, +87 | -8") — 🧹 [chore] Blank residual ANSI group reaction <sub><em>(7 files, +87, -8)</em></sub>

🧹 [chore] Blank the hash-locked standalone 'rai rules! hahahaha' creator aside from the M7-SIGO rendering while preserving its title, visual art, quotation, signature, palette, ANSI controls, and geometry.

🧪 [test] Add the eighty-third mixed-text ledger assertion and synchronize the curation checkpoint totals.\n
- Verified the exact 17-cell projection, all 117 focused content-audit and residual-ledger tests, and direct script execution.

📝 [docs] Add the new ledger to both artwork-source documentation surfaces and retain the complete scan and disposition rationale in the checkpoint.

- [`5908ad4`](https://github.com/Nick2bad4u/PS-Color-Scripts-Enhanced/commit/5908ad499c0ef9d6b80bb95b1a75d7a141aa306f "Diff: 9 files, +142 | -17") — 🧹 [chore] Blank residual ANSI reaction asides <sub><em>(9 files, +142, -17)</em></sub>

🧹 [chore] Blank three hash-locked isolated creator reaction or separator-filler spans across the bat05, d38-02, and riot-019 imports while retaining dialogue, identity, titles, credits, and artwork-integrated text.\n
- The d38-02 projection becomes a rendered-blank tail; the existing curation rule removes its two terminal blank rows and records the coordinate as intentionally absent.

🧪 [test] Add the eighty-second mixed-text ledger assertion and synchronize aggregate curation totals.\n
- Verified exact row hashes and 17 changed cells, 116 focused audit/ledger tests, 297 conversion tests, six smoke checks, strict lint, Markdown lint, duplicate checks, gallery analysis, content audit, README limits, and package dry run.

📝 [docs] Link the new hash-locked review from both artwork-source documents and record the full retained-versus-removed review rationale in the curation checkpoint.

- [`3e598fb`](https://github.com/Nick2bad4u/PS-Color-Scripts-Enhanced/commit/3e598fb4b101dce748173b8e7bd853067cb7bfb8 "Diff: 13 files, +360 | -29") — 🧹 [chore] Blank residual ANSI creator politeness <sub><em>(13 files, +360, -29)</em></sub>

🧹 [chore] Blank 18 exact row projections across seven scripts, removing 209 cells of historically orphaned creator prose and one generic audience signoff while retaining a mixed-row dedication and every intervening art glyph.

🛡️ [chore] Retain 21 detector rows fail-closed as credits, dedications, functional prompts, titles, dialogue, narrative, slogans, structural lettering, art-integrated words, or ambiguity, and synchronize canonical curation notices on touched sources.

🧪 [test] Hash-lock every projected row and verify all 232 untargeted payload rows remain byte-identical with unchanged ANSI controls, widths, rows, and geometry.

📝 [docs] Advance recent review evidence to Batch 81 and record 49,772 total blanked rows in the checkpoint and mirrored artwork-source documentation.

- [`a9a62ae`](https://github.com/Nick2bad4u/PS-Color-Scripts-Enhanced/commit/a9a62ae18847781e268ebad2b7c7b7027c5a073d "Diff: 8 files, +201 | -16") — 🧹 [chore] Blank residual ANSI creator aside and filler <sub><em>(8 files, +201, -16)</em></sub>

🧹 [chore] Blank seven exact spans across two scripts, removing generic filler after retained artist attribution and a six-row orphaned creator aside whose profane lead-in was already redacted.

🛡️ [chore] Retain five detector rows fail-closed as a BBS slogan, complete authored dialogue, page or menu text, and art-integrated robot-screen lettering.

🧪 [test] Hash-lock 67 changed cells and verify all 63 untargeted payload rows remain byte-identical with unchanged controls, widths, rows, and geometry.

📝 [docs] Advance recent review evidence to Batch 80 and record 49,754 total blanked rows in the checkpoint and mirrored artwork-source documentation.

- [`b93acd8`](https://github.com/Nick2bad4u/PS-Color-Scripts-Enhanced/commit/b93acd81a0aec23493e624b0c58ad2a9bba37301 "Diff: 10 files, +182 | -13") — 🧹 [chore] Blank orphaned ANSI reaction remnants <sub><em>(10 files, +182, -13)</em></sub>

🧹 [chore] Blank four exact reaction and audience-aside fragments whose adjoining creator prose or offensive continuation had already been redacted, preserving all ANSI controls, canvas widths, row coordinates, and unselected cells.

🛡️ [chore] Retain thirteen detector hits fail-closed as titles, attribution, authored dialogue or narrative, captions, jokes, structural lettering, art-integrated words, or ambiguity.

🧪 [test] Hash-lock four source-cell projections and verify 44 changed cells with all 154 untargeted payload rows byte-identical and no row removal or compaction.

📝 [docs] Advance recent evidence to Batch 79 and record 49,747 total blanked rows in both artwork-source documents and the curation checkpoint.

- [`733e7f1`](https://github.com/Nick2bad4u/PS-Color-Scripts-Enhanced/commit/733e7f15082ebd8b98420cfb9f5d9c5310028985 "Diff: 20 files, +530 | -47") — 🧹 [chore] Blank residual ANSI farewells and meta fillers <sub><em>(20 files, +530, -47)</em></sub>

🧹 [chore] Blank 17 exact farewell, metadata-filler, production-caption, and historically orphaned prose spans across fourteen color scripts while preserving every unselected rendered cell and canvas width.

🧹 [chore] Remove 15 newly exposed rendered-blank suffix rows without internal compaction, carrying the final ANSI reset onto the retained separator where required.

🛡️ [chore] Retain 27 detector rows fail-closed as functional menus and fields, titles, identity, attribution, authored dialogue or narrative, slogans, structural lettering, art-integrated words, or ambiguity.

🧪 [test] Hash-lock 161 changed cells, 337 byte-identical untargeted rows, one render-identical reset-carry row, six trimmed evidence coordinates, and the complete post-detector retention set.

📝 [docs] Advance recent review evidence to Batch 78 and record 49,743 blanked rows with 23,971 trailing rendered-blank rows removed.

- [`9f32ed4`](https://github.com/Nick2bad4u/PS-Color-Scripts-Enhanced/commit/9f32ed43b65a5c1d2183fb6cf7e24f9b351b040d "Diff: 16 files, +495 | -28") — 🧹 [chore] Blank residual ANSI casual asides and remnants <sub><em>(16 files, +495, -28)</em></sub>

🧹 [chore] Blank 19 exact casual-aside, anti-copy, signoff, and historically proven orphaned production spans across ten color scripts while preserving ANSI controls, unselected cells, retained widths, and row coordinates.

🛡️ [chore] Retain 60 detector rows fail-closed as functional rules and menus, titles, identity, attribution, dedications, authored dialogue or narrative, slogans, structural lettering, or ambiguity.

🧪 [test] Verify 245 changed cells, 303 byte-identical untargeted payload rows, 19 hash-locked projections, zero row compaction, and 60 exact post-detector retentions.

📝 [docs] Advance recent review evidence to Batch 77 and record 49,726 blanked rows with 23,956 trailing rendered-blank rows removed.

- [`920ca96`](https://github.com/Nick2bad4u/PS-Color-Scripts-Enhanced/commit/920ca96ae4d05cae653a9a9694a526fb6e3d64b4 "Diff: 15 files, +557 | -39") — 🧹 [chore] Blank residual ANSI interjections and remnants <sub><em>(15 files, +557, -39)</em></sub>

🧹 [chore] Blank 24 exact interjection, rhetorical-filler, self-critique, literal-identification, and proven residual production spans across nine color scripts while preserving ANSI controls, unselected cells, retained widths, and internal row coordinates.

🛡️ [chore] Retain 44 detector rows fail-closed as titles, identity, attribution, greetings, authored dialogue or narrative, functional interfaces, slogans, structural lettering, sound effects, ASCII-art glyph substrings, or ambiguity.

🧪 [test] Verify 175 changed cells, 263 byte-identical untargeted retained rows, 24 hash-locked projections, three safe terminal-row trims, and 44 exact post-detector retentions.

📝 [docs] Advance recent review evidence to Batch 76 and record 49,707 blanked rows with 23,956 trailing rendered-blank rows removed.

- [`7a70dc9`](https://github.com/Nick2bad4u/PS-Color-Scripts-Enhanced/commit/7a70dc9915380d037f5f5fe38c19fd703815b507 "Diff: 8 files, +149 | -12") — 🧹 [chore] Blank residual ANSI explanatory asides <sub><em>(8 files, +149, -12)</em></sub>

🧹 [chore] Blank three exact literal-identification and quality-reaction spans across two color scripts while preserving titles, identity, attribution, dedications, dialogue, slogans, structural text, ANSI controls, and retained cells.

🛡️ [chore] Retain thirteen detector rows fail-closed, including a split creation-hiatus phrase whose continuation contains an unsupported ambiguous-width CP437-derived cell.

🧪 [test] Verify 58 changed cells, 75 byte-identical untargeted rows, thirteen documented detector retentions, and synchronized Batch 75 checkpoint totals.

📝 [docs] Advance recent review evidence to Batch 75 and record 49,683 blanked rows with trailing-row totals unchanged.

- [`5317d50`](https://github.com/Nick2bad4u/PS-Color-Scripts-Enhanced/commit/5317d50603179ba7e3be2220cde763942f3af572 "Diff: 13 files, +435 | -35") — 🧹 [chore] Blank residual ANSI opinion chatter <sub><em>(13 files, +435, -35)</em></sub>

🧹 [chore] Blank 17 exact opinion, uncertainty, self-critique, desire, and literal style spans across six color scripts while preserving titles, identity, attribution, dialogue, structure, ANSI controls, and retained cells.

🛠️ [fix] Treat U+00A0 as a known one-cell spacing character for hash-locked column projections without weakening rejection of other ambiguous-width glyphs.

🧪 [test] Verify 167 changed cells, 147 byte-identical retained rows, four rendered-blank terminal rows, 41 documented detector retentions, and synchronized curation totals.

📝 [docs] Advance recent review evidence to Batch 74 and record 49,680 blanked rows plus 23,953 trimmed trailing rows.

- [`27f35ce`](https://github.com/Nick2bad4u/PS-Color-Scripts-Enhanced/commit/27f35ce804f6e0836d9ebcf1ca012dbb84efab9c "Diff: 12 files, +398 | -27") — 🧹 [chore] Blank residual ANSI social chatter <sub><em>(12 files, +398, -27)</em></sub>

🧹 [chore] Blank 17 exact feedback, advertisement, reader-signoff, literal-screen-description, and production-apology row projections across six archived color scripts while preserving titles, BBS identity, attribution, authored narrative, functional interfaces, ANSI controls, geometry, and every untargeted row.

🧪 [test] Add the hash-locked Batch 73 ledger and checkpoint coverage for 52 detector decisions, 46 explicit fail-closed retentions, 139 changed cells, 162 unchanged untargeted rows, and zero removed or compacted rows.

📝 [docs] Refresh mirrored curation evidence links and cumulative totals to 49,663 blanked rows and 15,703 residual mixed-text rows.

- [`27f4cc0`](https://github.com/Nick2bad4u/PS-Color-Scripts-Enhanced/commit/27f4cc0635cef686a94505a1849aea35bd8857ec "Diff: 37 files, +1277 | -70") — 🧹 [chore] Blank residual ANSI creator and reaction chatter <sub><em>(37 files, +1277, -70)</em></sub>

🧹 [chore] Blank 49 exact creator-action, reaction, interjection, audience-signoff, placeholder, usage-note, and production-aside row projections across 30 archived color scripts while preserving titles, identity, attribution, authored narrative, functional interfaces, ANSI controls, geometry, and every untargeted row.

🧪 [test] Add hash-locked Batch 71 and 72 ledgers plus checkpoint coverage for 498 changed cells, 32 explicit fail-closed retentions, and zero removed or compacted rows.

📝 [docs] Refresh mirrored curation evidence links and cumulative totals to 49,646 blanked rows and 15,686 residual mixed-text rows.

- [`15e20bf`](https://github.com/Nick2bad4u/PS-Color-Scripts-Enhanced/commit/15e20bfffcda18026325bb09c9b62177af57ac67 "Diff: 16 files, +505 | -32") — 🧹 [chore] Blank residual ANSI meta captions <sub><em>(16 files, +505, -32)</em></sub>

🧹 [chore] Blank 21 exact literal-caption, creator-aside, old-work-note, and audience-signoff spans across ten archived color scripts while preserving titles, identity, attribution, functional menu commands, ANSI controls, cell widths, and all 239 untargeted rows.

🧪 [test] Add the hash-locked Batch 70 ledger and checkpoint assertions for 230 changed cells, seven explicit fail-closed retentions, and zero removed or compacted rows.

📝 [docs] Refresh mirrored curation evidence links and cumulative totals to 49,597 blanked rows and 15,637 residual mixed-text rows.

- [`35fb478`](https://github.com/Nick2bad4u/PS-Color-Scripts-Enhanced/commit/35fb478896520ca857c3ce1458f7d118d9ef063c "Diff: 8 files, +159 | -13") — 🧹 [chore] Blank residual ANSI self-critique <sub><em>(8 files, +159, -13)</em></sub>

🧹 [chore] Blank four exact boredom and negative self-assessment spans across two archived color scripts while preserving ANSI controls, canvas geometry, structural art, and every untargeted row.

🧪 [test] Add the hash-locked Batch 69 ledger, checkpoint assertions, and official review coverage for 44 changed cells with zero row removals.

📝 [docs] Refresh mirrored curation evidence links and cumulative totals to 49,576 blanked rows and 15,616 residual mixed-text rows.

- [`badc5e2`](https://github.com/Nick2bad4u/PS-Color-Scripts-Enhanced/commit/badc5e2401e9cb06c57947363c02b72c8e9813d4 "Diff: 22 files, +607 | -32") — 🧹 [chore] Blank residual ANSI originality claims <sub><em>(22 files, +607, -32)</em></sub>

🧹 [chore] Blank 19 exact originality, quality, and creation-time spans across 16 archived color scripts while preserving attribution, titles, structural labels, CP437 separators, ANSI controls, canvas width, and every untargeted row.

🧪 [test] Add the hash-locked Batch 68 ledger, checkpoint assertions, independent projection evidence, and official review coverage for 191 changed cells with zero row removals.

📝 [docs] Update both artwork-source documents and the curation checkpoint to report 49,572 total blanked rows and 15,612 residual mixed-text rows.

- [`4090aa7`](https://github.com/Nick2bad4u/PS-Color-Scripts-Enhanced/commit/4090aa70b9945840d75e4d8ba4127887fa287d04 "Diff: 29 files, +1011 | -45") — 🧹 [chore] Blank residual ANSI production chatter <sub><em>(29 files, +1011, -45)</em></sub>

🧹 [chore] Blank 31 exact pricing, originality, anti-copy, line-count, duration, work-time, advertisement, and production-process spans across 23 scripts while preserving ANSI state, cell widths, CP437 separators, and attribution.

🧪 [test] Add the hash-locked Batch 67 ledger and checkpoint assertions for 346 changed cells with zero row removal or compaction.

📝 [docs] Refresh mirrored curation evidence links and cumulative row totals.

- [`f21e4e0`](https://github.com/Nick2bad4u/PS-Color-Scripts-Enhanced/commit/f21e4e07700b3cc2eeffd425adc717a561a0a10a "Diff: 54 files, +1829 | -102") — 🧹 [chore] Blank residual ANSI provenance metadata <sub><em>(54 files, +1829, -102)</em></sub>

🧹 [chore] Blank 63 exact originality, anti-rip, creation-date, completion, line-count, release-time, and production-note spans across 47 scripts while preserving ANSI controls, art cells, colored spaces, widths, and row coordinates; retain two unsafe ambiguous-width rows fail-closed.

🧪 [test] Add the hash-locked Batch 66 ledger, independent replay and checkpoint coverage for 775 changed cells and 1,623 untouched rows, and validate all 24,822 color scripts without execution failures.

📝 [docs] Rotate both artwork-source evidence links and retire two stale derivative-attribution exceptions, reconciling the current analysis ledger to 398 records.

- [`3f8f71c`](https://github.com/Nick2bad4u/PS-Color-Scripts-Enhanced/commit/3f8f71cbfa03fd5d0a41dd3bacd37f4b7719d366 "Diff: 76 files, +3026 | -163") — 🧹 [chore] Blank residual ANSI cue metadata <sub><em>(76 files, +3026, -163)</em></sub>

🧹 [chore] Blank 129 exact greeting-list, request, freebie, date, provenance, and production-note spans across 69 scripts while preserving ANSI controls, art cells, widths, and internal geometry; remove four newly empty terminal rows.

🧪 [test] Add the hash-only Batch 65 ledger, historical supersession coverage, checkpoint totals, and independent replay evidence for 1,437 changed cells and 2,424 untouched rows.

📝 [docs] Link the new review in both artwork-source documents and retire the stale derivative-attribution exception exposed by the cleanup, reconciling the checkpoint to 400 current exceptions.

- [`76d15db`](https://github.com/Nick2bad4u/PS-Color-Scripts-Enhanced/commit/76d15db30f9c38b14fd3fd036ca36e222cf87adb "Diff: 17 files, +649 | -42") — 🧹 [chore] Blank residual ANSI solicitation text <sub><em>(17 files, +649, -42)</em></sub>

🧹 [chore] Replace 27 separable request, contact, freebie, greeting-list, and production-chatter spans across 11 color scripts with style-preserving spaces while retaining every row, column, control sequence, title, attribution, dedication, authored caption, and functional interface.

🧹 [chore] Add the hash-locked Batch 64 ledger for 430 changed terminal cells, record two explicitly deferred recruitment-interface retention supersessions, and advance the content checkpoint to 49,330 blanked rows.

🧪 [test] Replay Batch 64 projections, enforce the two retention supersessions, and synchronize checkpoint assertions without weakening historical hash validation.

📝 [docs] Link the sixty-fourth mixed-text ledger and synchronize both artwork-source summaries with the current curation totals.

🧪 [test] Validate 278 conversion tests, strict PowerShell analysis, all changed-script executions, gallery geometry, duplicate detection, documentation sizing, Markdown lint, independent cell/control preservation, and the npm package dry run.

- [`d30ac3c`](https://github.com/Nick2bad4u/PS-Color-Scripts-Enhanced/commit/d30ac3cfdb215609ddef68d18b69a2bd3049519b "Diff: 32 files, +1033 | -55") — 🧹 [chore] Blank residual ANSI source filenames <sub><em>(32 files, +1033, -55)</em></sub>

🧹 [chore] Replace 41 separable source-filename, timestamp, request, greeting-list, and editor-metadata spans across 26 ANSI scripts with style-preserving spaces while retaining every row, column, and control sequence.

🧹 [chore] Add the hash-locked Batch 63 review ledger, record 580 changed terminal cells, and advance the curation checkpoint to 49,303 blanked rows.

🧪 [test] Replay Batch 63 cell edits, recognize superseded historical rows, and verify the synchronized corpus totals and provenance assertions.

📝 [docs] Synchronize both artwork-source references with the Batch 63 ledger and current curation totals.

🧪 [test] Validate all changed scripts, 277 conversion tests, strict lint, gallery geometry, duplicate detection, documentation generation, Markdown lint, and the npm package dry run.

- [`badf5e2`](https://github.com/Nick2bad4u/PS-Color-Scripts-Enhanced/commit/badf5e28b1e3f0ef44965331ff948b548a16d175 "Diff: 13 files, +394 | -28") — 🧹 [chore] Blank residual ANSI source metadata <sub><em>(13 files, +394, -28)</em></sub>

🧹 [chore] Blank 16 separable source, editor, and BBS metadata spans across seven ANSI scripts while preserving terminal-cell geometry and attribution.

🧹 [chore] Add hash-locked batch 62 evidence and advance the curation checkpoint to 49,262 blanked rows.

🧪 [test] Replay every projected row and assert the new ledger and checkpoint totals.

📝 [docs] Synchronize mirrored artwork-source links and current curation counts.

🧪 [test] Validate focused and conversion tests, strict lint, gallery analysis, duplicate and README checks, remark lint, changed-script execution, and npm dry-run packaging.

- [`8cda6e5`](https://github.com/Nick2bad4u/PS-Color-Scripts-Enhanced/commit/8cda6e5e3e8ff7efd2790ef123c7e1271fa271c6 "Diff: 13 files, +495 | -30") — 🧹 [chore] Blank orphaned ANSI source notes <sub><em>(13 files, +495, -30)</em></sub>

🧹 [chore] Remove 22 exact source-production, editor/shareware, board-promotion, anti-rip, and source-use spans across seven curated ANSI scripts while preserving controls, art cells, authorship, functional labels, captions, signatures, widths, and row geometry.

🧹 [chore] Record the complete 21-row Batch 61 detector review across all 24,801 static scripts, including nine coherent family extensions, eight fail-closed retentions, 266 changed cells, and historical evidence for four partially redacted blocks.

🧪 [test] Extend checkpoint assertions and hash-locked replay coverage for the 49,246-row curated corpus state with no row removal or compaction.

📝 [docs] Link the sixty-first mixed-text evidence from both artwork-source documents.

- [`1717e47`](https://github.com/Nick2bad4u/PS-Color-Scripts-Enhanced/commit/1717e47377c59cc2403f848734bdc5e5476fe7ee "Diff: 33 files, +1599 | -115") — 🧹 [chore] Blank legacy ANSI control tokens <sub><em>(33 files, +1599, -115)</em></sub>

🧹 [chore] Remove 79 exact unexpanded BBS directives, runtime values, and numbered menu-template markers across 27 curated ANSI scripts while preserving controls, art cells, widths, signatures, attribution, and internal row geometry.

🧹 [chore] Record the complete 139-row Batch 60 review, including 60 fail-closed retentions, two ambiguous-width projection vetoes, and four evidence-backed prior-retain supersessions.

🧪 [test] Update checkpoint assertions and hash-locked ledger replay coverage for the 49,224-row curated corpus state and seven exposed terminal rows.

📝 [docs] Link the latest mixed-text evidence from both artwork-source documents.

- [`3b6d30e`](https://github.com/Nick2bad4u/PS-Color-Scripts-Enhanced/commit/3b6d30ec6238c614b4059c83cc927bc26d5a02e9 "Diff: 9 files, +183 | -11") — 🧹 [chore] Blank residual ANSI filler values <sub><em>(9 files, +183, -11)</em></sub>

🧹 [chore] Remove four exact generic sample and filler spans across three curated ANSI scripts while preserving bullets, panel markers, identities, controls, colored spaces, widths, and row geometry.

🧹 [chore] Record the complete 70-row Batch 59 delimiter and filler-vocabulary review, including 66 fail-closed retentions and three evidence-backed prior-retain supersessions.

🧪 [test] Extend checkpoint totals and hash-application coverage for the 49,145-row curated corpus state.

📝 [docs] Link the latest hash-locked review evidence in both artwork-source documents.

- [`a690a34`](https://github.com/Nick2bad4u/PS-Color-Scripts-Enhanced/commit/a690a34c1501e35d21933978b9a171dc54066ea0 "Diff: 13 files, +305 | -19") — 🧹 [chore] Blank delimited ANSI template remnants <sub><em>(13 files, +305, -19)</em></sub>

🧹 [chore] Remove nine exact runtime, value, and production-placeholder spans across seven curated ANSI scripts while preserving functional labels, signatures, controls, art cells, widths, and row geometry.

🧹 [chore] Record the complete 521-row delimiter-family review in Batch 58, including 512 fail-closed retentions and two evidence-backed prior-retain supersessions.

🧪 [test] Update checkpoint assertions and ledger-application coverage for the 49,141-row curated corpus state.

📝 [docs] Link the latest hash-locked evidence in both artwork-source documents.

- [`8b70e68`](https://github.com/Nick2bad4u/PS-Color-Scripts-Enhanced/commit/8b70e689f3f11efe744354c16cb1830e6e852b6e "Diff: 19 files, +1080 | -59") — 🧹 [chore] Blank literal ANSI runtime placeholders <sub><em>(19 files, +1080, -59)</em></sub>

🧹 [chore] Remove 46 unexpanded runtime directives and value tokens from 12 curated ANSI scripts while preserving controls, artwork cells, labels, width, and row geometry.

🧹 [chore] Record the complete 80-row review in the hash-locked Batch 57 ledger, including 34 fail-closed ASCII-art retentions and 32 explicit prior-retain supersessions.

🧪 [test] Update checkpoint assertions and ledger-application coverage for the 49,132-row curated corpus state.

📝 [docs] Link the latest evidence in both artwork-source documents and allow Roy/SAC archival scripts to retain intentional source-cell whitespace.

- [`34e38dd`](https://github.com/Nick2bad4u/PS-Color-Scripts-Enhanced/commit/34e38dd8c0f8b9ddaebf259005c58ea6fa82e001 "Diff: 14 files, +526 | -36") — 🧹 [chore] Blank recurring ANSI template remnants <sub><em>(14 files, +526, -36)</em></sub>

🧹 [chore] Apply 18 hash-locked text projections across eight scripts after exhaustively reviewing 76 exact recurrences of Batch 55 phrases.

- Remove three visible @WAIT@ artifacts, eleven proven greeting-filler repetitions, two production markers, one dummy field, and one filename-description runtime template.

- Retain 58 real filenames, titles, greetings, credits, authored captions, functional labels, structural text, and ambiguous fragments.

- Remove five newly empty terminal rows without compacting internal artwork or changing retained cell geometry.

🧪 [test] Add Batch 56 replay coverage and assert its cumulative row, file, and terminal-removal totals.

- Verify all historical ledgers remain reconciled after the new terminal suffix removals.

📝 [docs] Record the fifty-eighth hash-locked review, 14 explicit prior-retain supersessions, updated cumulative totals, and mirrored latest-evidence links.

- [`57eccb6`](https://github.com/Nick2bad4u/PS-Color-Scripts-Enhanced/commit/57eccb6ded85d2a42e7e4f8d21fcd14fd78b2c50 "Diff: 38 files, +1173 | -60") — 🧹 [chore] Blank gap-separated ANSI text remnants <sub><em>(38 files, +1173, -60)</em></sub>

🧹 [chore] Apply 39 hash-locked text projections across 31 scripts after reviewing all 857 previously undecided rows two to five rows from accepted redactions.

- Retain 826 functional, authored, structural, attributed, or ambiguous detector rows and extend only eight visually proven disposable families.

- Remove eight newly empty terminal rows without compacting internal artwork or changing retained cell geometry.

🛠️ [fix] Protect the CP437 pound sign as a one-cell terminal-art glyph during targeted column projection.

- Preserve ANSI controls, colored spaces, unselected cells, and exact row widths while rejecting destructive art selection.

🧪 [test] Add Batch 55 replay coverage, cumulative checkpoint assertions, pound-sign regression coverage, and explicit accounting for historical coordinates removed with the terminal suffix.

📝 [docs] Record the fifty-seventh hash-locked review, updated cumulative totals, and the latest mirrored evidence links.

- [`6ed9301`](https://github.com/Nick2bad4u/PS-Color-Scripts-Enhanced/commit/6ed9301d0581f8b1f2d08cf72d9b2a552b8497bb "Diff: 62 files, +2346 | -104") — 🧹 [chore] Blank immediate-neighbor ANSI text remnants <sub><em>(62 files, +2346, -104)</em></sub>

🧹 [chore] Remove 85 hash-reviewed placeholder, solicitation, filler, process-commentary, doxxing, and policy-ineligible text rows across 55 ANSI scripts while preserving terminal controls, colored spaces, canvas widths, and internal row geometry.

🧹 [chore] Remove four terminal rows that became fully blank after the exact cell-range redactions, without compacting any internal artwork rows.

🔧 [build] Protect the CP437 half-sign as a terminal-art glyph so ANSI-aware blanking can safely redact adjacent text without altering the art cell.

🧪 [test] Add Batch54 hash replay, supersession and missing-tail accounting, checkpoint assertions, and focused CP437 half-sign coverage.

📝 [docs] Record the 694-row review disposition, 85 accepted projections, 638 retained rows, updated cumulative totals, and current ledger links in both artwork-source documents.

- [`73d7c6c`](https://github.com/Nick2bad4u/PS-Color-Scripts-Enhanced/commit/73d7c6c7faecd1048caa5a804f34b12e02e15017 "Diff: 19 files, +534 | -26") — 🧹 [chore] Blank adjacent ANSI text remnants <sub><em>(19 files, +534, -26)</em></sub>

🧹 [chore] Blank 233 readable text cells across 17 rows in 13 colorscripts while preserving every ANSI control, colored space, source row, canvas width, identity, and attribution cell.

🧹 [chore] Complete repeated gallery, runtime, form-markup, solicitation, and prose-continuation families, with stronger exact-family evidence explicitly accounting for two earlier retain-by-omission decisions.

🧪 [test] Add the hash-only Batch53 ledger, checkpoint totals, and applied-ledger assertions covering all 110 detector decisions, including 97 fail-closed retentions.

📝 [docs] Link the latest review evidence in both artwork-source guides and synchronize the verified 48,944-row content-curation total.

- [`06ae30a`](https://github.com/Nick2bad4u/PS-Color-Scripts-Enhanced/commit/06ae30a2e0c239bd99e121834a419507841924a2 "Diff: 40 files, +1464 | -62") — 🧹 [chore] Blank residual ANSI placeholder families <sub><em>(40 files, +1464, -62)</em></sub>

🧹 [chore] Blank 639 readable text cells across 55 rows in 34 color scripts while preserving ANSI controls, colored spaces, width, source rows, identities, and attribution.

🧹 [chore] Complete the surviving filename.txt and DeathroadOption!@ placeholder families and connected disposable prose fragments, explicitly accounting for 12 superseded retain-by-omission decisions.

🧪 [test] Add the hash-only Batch52 ledger, checkpoint totals, replay coverage, and applied-ledger assertions for all 236 terminal detector decisions.

📝 [docs] Link the new review evidence from both artwork-source documents and record the verified curation results.

- [`9c07da8`](https://github.com/Nick2bad4u/PS-Color-Scripts-Enhanced/commit/9c07da8b8d1586b568110561960e0a8f0266c17d "Diff: 28 files, +745 | -30") — 🧹 [chore] Blank one-sided ANSI prose remnants <sub><em>(28 files, +745, -30)</em></sub>

🧹 [chore] Blank 23 proven prose-family extensions across 22 ANSI scripts while preserving co-located identities, artwork cells, styling, spacing, width, and row coordinates.

🧹 [chore] Record the hash-locked 59-row terminal review, including 36 fail-closed retentions, 51 reconstructed source rows, eight live-context decisions, and 318 verified changed cells.

🧪 [test] Extend checkpoint and ledger assertions for Batch 51; the full 263-test conversion suite, strict lint, gallery analysis, duplicate checks, and changed-script execution all pass.

📝 [docs] Link the new review ledger from both artwork-source documents and synchronize cumulative curation totals.

- [`2481045`](https://github.com/Nick2bad4u/PS-Color-Scripts-Enhanced/commit/2481045d1ac80a9c6fd32301dec6e0b5f7b8022a "Diff: 45 files, +1252 | -47") — 🧹 [chore] Blank bracketed ANSI text remnants <sub><em>(45 files, +1252, -47)</em></sub>

🧹 [chore] Blank 40 orphaned prose, greeting, solicitation, process-commentary, and filler spans across 39 scripts while preserving structural lettering, terminal-art glyphs, ANSI controls, colored spaces, widths, and row coordinates.

🧹 [chore] Add the hash-locked Batch 50 ledger with terminal dispositions for all 130 rows bracketed by earlier accepted redactions, retaining 90 functional, authored, structural, identity, attribution, and ambiguous rows.

🧪 [test] Synchronize curation totals, ledger verification, and mirrored artwork-source documentation; validate 605 changed cells through independent replay, 262 conversion tests, strict lint, gallery analysis, duplicate detection, and execution of every changed script.

- [`2dd4e0b`](https://github.com/Nick2bad4u/PS-Color-Scripts-Enhanced/commit/2dd4e0bbebb7240b03b9c57451f5ab9df81ed3f7 "Diff: 7 files, +109 | -11") — 🧹 [chore] Finish orphaned ANSI prose heads <sub><em>(7 files, +109, -11)</em></sub>

🧹 [chore] Blank the surviving We used and mIRC heads in the Roots slurg artwork after import-preimage reconstruction proved their continuation rows were already removed.

🧪 [test] Add the hash-locked Batch 49 ledger, complete 23-row process-phrase dispositions, projected hashes, checkpoint totals, and regression coverage.

📝 [docs] Advance both artwork-source guides to the latest review and the 48,809-row curation total.

- [`e599bac`](https://github.com/Nick2bad4u/PS-Color-Scripts-Enhanced/commit/e599bac777e16304922d59fad35a303ba8aa5f84 "Diff: 11 files, +299 | -19") — 🧹 [chore] Blank residual ANSI prose families <sub><em>(11 files, +299, -19)</em></sub>

🧹 [chore] Remove ten separable incomplete release, source-process, greeting, and offensive commentary spans across five ANSI scripts while preserving terminal geometry, colors, controls, separators, titles, and attribution.

🧪 [test] Add the hash-locked Batch 48 ledger, complete 72-row detector disposition accounting, exact projected hashes, checkpoint totals, and regression coverage.

📝 [docs] Update both artwork-source guides to reference the latest review and the 48,807-row curation total.

- [`b1216f1`](https://github.com/Nick2bad4u/PS-Color-Scripts-Enhanced/commit/b1216f1e6dc8045c2c885a3d1a7267381ee5a777 "Diff: 8 files, +276 | -21") — 🧹 [chore] Blank attached ANSI placeholder families <sub><em>(8 files, +276, -21)</em></sub>

🧹 [chore] Remove the complete option1-option5 and command0-commandB template families from two archived artworks while preserving colored spaces, ANSI controls, separators, attribution, widths, and row coordinates.

🧹 [chore] Add hash-locked Ledger 47 evidence for 11 exact column projections and explicitly supersede nine omission-based snapshot retentions without overriding tracked semantic decisions.

🧪 [test] Extend ledger replay and checkpoint assertions for 131 changed cells, two scripts, and zero trailing-row changes.

📝 [docs] Update both artwork-source references and cumulative cleanup totals to 48,797 rows.

- [`8eaa715`](https://github.com/Nick2bad4u/PS-Color-Scripts-Enhanced/commit/8eaa715025846a9087111a2aa7b1f43674a424f7 "Diff: 10 files, +246 | -17") — 🧹 [chore] Reconcile 140 residual ANSI placeholder rows <sub><em>(10 files, +246, -17)</em></sub>

🧹 [chore] Blank 84 cells across eight hash-locked rows, completing the xx solace and accepted repeated-command families while removing one cut marker and one incomplete menu placeholder without superseding prior retains.

🧪 [test] Add Ledger 46 replay coverage, acknowledge two extended Ledger 28 projections, and update checkpoint assertions for the four affected scripts.

📝 [docs] Record 48,786 cumulative blanked rows and link the latest mixed-text evidence in both artwork-source guides.

- [`7e77e2b`](https://github.com/Nick2bad4u/PS-Color-Scripts-Enhanced/commit/7e77e2b7416b03a38292f1b798fa37584e24dcd8 "Diff: 18 files, +671 | -43") — 🧹 [chore] Exhaust residual ANSI generic-label report <sub><em>(18 files, +671, -43)</em></sub>

🧹 [chore] Blank 282 hash-locked placeholder and production-counter cells across 30 rows in 12 scripts, including complete kaoz command and option families, while preserving protected titles, identities, attribution, prompts, and ANSI geometry.

🧪 [test] Register Ledger 45, verify all 53 novel detector decisions, and prove terminal coverage for the full 347-coordinate historical report.

📝 [docs] Advance the curation checkpoint to 48,778 blanked rows and synchronize both artwork-source documents with the latest evidence.

- [`d897f21`](https://github.com/Nick2bad4u/PS-Color-Scripts-Enhanced/commit/d897f2122db2e9aa82996e68dd57f0a6b70a7b4e "Diff: 19 files, +1299 | -62") — 🧹 [chore] Blank 52 residual ANSI generic-label rows <sub><em>(19 files, +1299, -62)</em></sub>

🧹 [chore] Remove 193 hash-locked alphabetic menu slots and dummy command or info markers across 13 scripts while preserving attribution, functional prompts, ANSI state, colored spaces, canvas width, and row geometry.

🧪 [test] Add Ledger 44 coverage, reconcile 44 superseded Batch 30 projections, and compare supersession coordinates as the set they represent.

📝 [docs] Advance the curation checkpoint to 48,748 blanked rows and synchronize both artwork-source documents with the latest evidence ledger.

- [`988c3b6`](https://github.com/Nick2bad4u/PS-Color-Scripts-Enhanced/commit/988c3b614c87e9cf5d0666e65a1f325259983883 "Diff: 42 files, +4441 | -287") — 🧹 [chore] Reconcile 261 accepted ANSI placeholder rows <sub><em>(42 files, +4441, -287)</em></sub>

🧹 [chore] Blank the remaining command, option, conference, empty-field, artist-name, and placement placeholders from 36 scripts using hash-locked cell projections.

🧪 [test] Register Batch 43, mark 28 Batch 30 projections superseded, and document zero surviving ASCII text across all 507 prior accepted coordinates.

- [`1cc96d0`](https://github.com/Nick2bad4u/PS-Color-Scripts-Enhanced/commit/1cc96d080fcb4b3635a2de757728026bd5199a7d "Diff: 18 files, +1424 | -98") — 🧹 [chore] Blank 85 generic ANSI placeholders <sub><em>(18 files, +1424, -98)</em></sub>

🧹 [chore] Remove repeated command and option template labels from 12 scripts with 85 hash-locked cell projections, preserving ANSI controls, artwork glyphs, widths, and coordinates.

🧪 [test] Register Batch 42, reconcile two superseded Batch 28 projections, and update curation totals and mirrored source documentation.

- [`a908ce3`](https://github.com/Nick2bad4u/PS-Color-Scripts-Enhanced/commit/a908ce3cf6a56c187e9eca74ff1aa5cd80c6af09 "Diff: 8 files, +110 | -9") — 🧹 [chore] Blank the final ranked prose fragments <sub><em>(8 files, +110, -9)</em></sub>

🧹 [chore] Replace 33 reviewed cells in a filename-like source descriptor and an orphaned production-comment fragment with style-preserving spaces across 2 scripts.

- Retain the other 57 reconciled prose-tail rows as attribution, titles, functional menu or BBS copy, authored captions, identities, or structural text.

🧪 [test] Add the hash-locked Batch 41 ledger, register 2 files and 2 rows in the curation checkpoint, and verify zero trailing-row removal.

📝 [docs] Advance both artwork-source mirrors to the latest three mixed-text review ledgers.

- [`5f98713`](https://github.com/Nick2bad4u/PS-Color-Scripts-Enhanced/commit/5f987139395224db7311ce0c4e49371ce28d6a65 "Diff: 20 files, +722 | -44") — 🧹 [chore] Blank 35 more ANSI prose rows <sub><em>(20 files, +722, -44)</em></sub>

🧹 [chore] Replace 367 reviewed source-process, delivery, placeholder, repeated crude filler, and narrowly offensive text cells with style-preserving spaces across 14 scripts.

- Preserve every unselected glyph, recipient identity, title, signature, attribution, functional interface label, ANSI control, colored space, width, and row coordinate.

🧪 [test] Add the hash-locked Batch 40 ledger, register its 14 files and 35 rows in the curation checkpoint, and advance cumulative blanking totals without trailing-row removal.

📝 [docs] Advance both artwork-source mirrors to the latest three mixed-text review ledgers.

- [`a9835a6`](https://github.com/Nick2bad4u/PS-Color-Scripts-Enhanced/commit/a9835a682ed9d3dc306b3461c0afb02e78f12dc3 "Diff: 12 files, +60 | -31") — 🧹 [chore] Blank 24 more ANSI process-note rows <sub><em>(12 files, +60, -31)</em></sub>

🧹 [chore] Replace 283 reviewed delivery, placement, source-use, design-commentary, modification, and incomplete process-note cells with style-preserving spaces across 7 ANSI scripts.

- Preserve every unselected glyph, ANSI control, colored space, terminal width, row coordinate, title, signature, attribution, and functional interface label.

🧪 [test] Register Batch 39 in the curation checkpoint and assert its 7 files, 24 rows, zero trailing removals, and updated cumulative totals.

📝 [docs] Advance both artwork-source mirrors to the latest three hash-locked mixed-text review ledgers.

- [`93b2976`](https://github.com/Nick2bad4u/PS-Color-Scripts-Enhanced/commit/93b297653bb1bd241f1ea406d0b0d6f433cce116 "Diff: 1 file, +418 | -0") — 🧹 [chore] Record Batch 39 ANSI text review <sub><em>(1 file, +418, -0)</em></sub>

🧹 [chore] Pin 24 exact source-cell blanking decisions across 7 scripts for delivery, placement, source-use, design, modification, and incomplete process notes.

- Preserve raw, rendered, and normalized row hashes with one-based inclusive column ranges so application fails closed if any reviewed source has drifted.

🧪 [test] Confirm the ready ledger parses as JSON and dry-runs against all 7 reviewed scripts with 24 blanked rows and zero failures.

- [`7897f97`](https://github.com/Nick2bad4u/PS-Color-Scripts-Enhanced/commit/7897f975e7b69e2f7ac883f6f4a51ee99cf8f7bc "Diff: 11 files, +317 | -24") — 🧹 [chore] Blank 14 more ANSI source-note rows <sub><em>(11 files, +317, -24)</em></sub>

🧹 [chore] Remove a cut marker, placement annotations, a four-row fit instruction, and a seven-row source-use restriction across five scripts while retaining functional BBS commands and attribution.

🔒 [chore] Add the Batch 38 hash-only ledger with exact preimage and projected-row hashes for all 152 redacted cells.

🧪 [test] Verify the new evidence is fully applied and reconcile checkpoint totals through the fortieth mixed-text review.

📝 [docs] Link the newest review ledger in both artwork-source guides and report 48,289 total blanked rows.

- [`92ac2b2`](https://github.com/Nick2bad4u/PS-Color-Scripts-Enhanced/commit/92ac2b2fb86362d12c936e2ab2a5676d7a92f67c "Diff: 22 files, +577 | -33") — 🧹 [chore] Blank 21 more ANSI placeholder rows <sub><em>(22 files, +577, -33)</em></sub>

🧹 [chore] Remove isolated generic fields, source-production annotations, an ID placeholder, an orphaned shout-out, and incomplete process copy across 16 scripts without changing their terminal geometry.

🔒 [chore] Add the Batch 37 hash-only ledger with exact preimage, projected-row, and one-based column evidence for all 317 redacted cells.

🧪 [test] Verify the new ledger is fully applied and reconcile the checkpoint totals through the thirty-ninth mixed-text review.

📝 [docs] Link the latest curation evidence in both artwork-source guides and report 48,275 total blanked rows.

- [`eddf491`](https://github.com/Nick2bad4u/PS-Color-Scripts-Enhanced/commit/eddf491ea25612cf6be1c66588ad9d329b5c7df4 "Diff: 48 files, +1474 | -68") — 🧹 [chore] Blank 55 more ANSI source-marker rows <sub><em>(48 files, +1474, -68)</em></sub>

🧹 [chore] Remove repeated cut instructions, one generic filler field, and coherent anti-rip or source-use passages across 42 archived scripts.

- Preserve separator brackets and dashes, frame artwork, shared-row attribution, ANSI controls, colored spaces, widths, and source-row geometry.

🔒 [chore] Add Batch 36 hash-locked evidence for 55 targeted rows and 842 changed text cells, backed by an independent ANSI-aware projection replay.

📝 [docs] Advance the content checkpoint and both artwork-source mirrors to 48,254 blanked rows.

🧪 [test] Lock the 42-file Batch 36 ledger totals and verify every reviewed preimage is absent from the retained gallery.

- [`156444e`](https://github.com/Nick2bad4u/PS-Color-Scripts-Enhanced/commit/156444ebca85b91a794fea298d15787c80d8ce57 "Diff: 7 files, +142 | -14") — 🧹 [chore] Blank 5 more ANSI placeholder rows <sub><em>(7 files, +142, -14)</em></sub>

🧹 [chore] Remove the five repeated unfinished menu phrases from the Transmission PC-JASON artwork while preserving CP437 guillemets, hotkeys, ANSI state, frame cells, spacing, and row geometry.

🔒 [chore] Add Batch 35 hash-locked evidence with exact preimage and projected row hashes for all five targeted column ranges.

📝 [docs] Advance the curation checkpoint and both artwork-source mirrors to 48,199 blanked rows.

🧪 [test] Verify the new ledger is fully applied and lock its one-file, five-row checkpoint totals.

- [`6fa8d59`](https://github.com/Nick2bad4u/PS-Color-Scripts-Enhanced/commit/6fa8d594fbe6faea6ab862d604367a0bd40e8086 "Diff: 15 files, +504 | -33") — 🧹 [chore] Blank 24 more ANSI source-note rows <sub><em>(15 files, +504, -33)</em></sub>

🧹 [chore] Remove unfinished-art commentary, drawing-duration and homepage-status notes, a presentation suggestion, orphaned fill-in instructions, and fragments left by earlier partial note cleanup across 9 curated scripts.

🎨 [style] Apply 24 hash-locked one-based column projections covering 231 text cells while preserving every unselected terminal cell, ANSI control, canvas width, row count, artwork glyph, and shared-row signature or attribution.

🧪 [test] Add the Batch 34 replay ledger, one reviewed retain supersession, aggregate checkpoint assertions, and full application coverage for the new evidence.

📝 [docs] Advance mirrored curation totals to 48,194 reviewed rows and link the newest mixed-text evidence ledger.

- [`890b8ec`](https://github.com/Nick2bad4u/PS-Color-Scripts-Enhanced/commit/890b8ec316e4ed1b5d348d2afe4d5e7714e12abd "Diff: 17 files, +882 | -66") — 🧹 [chore] Blank 50 more ANSI process-note rows <sub><em>(17 files, +882, -66)</em></sub>

🧹 [chore] Remove generic empty-panel filler, drawing-process commentary, orphaned anti-rip fragments, and source-use restrictions from 10 curated ANSI scripts.

🎨 [style] Preserve every unselected terminal cell, canvas width, ANSI control sequence, colored background, artwork line, dedication, title, and shared-row attribution including GREAT ZAMBINI and aiOMEN.

🛠️ [fix] Drop the obsolete hq-drag derivative-attribution exception after its temporal source note no longer produces an analyzer finding.

🧪 [test] Add the hash-locked Batch 33 ledger for 50 exact column projections, three reviewed retain supersessions, and synchronized checkpoint assertions.

📝 [docs] Advance mirrored artwork-source totals to 48,170 reviewed rows and link the newest evidence ledger.

- [`f6d1836`](https://github.com/Nick2bad4u/PS-Color-Scripts-Enhanced/commit/f6d183606c50c2d6984304316be0cdfe1d95602b "Diff: 18 files, +727 | -51") — 🧹 [chore] Blank 37 more ANSI production-note rows <sub><em>(18 files, +727, -51)</em></sub>

🧹 [chore] Remove untranslated template filler, unfinished annotations, source-process commentary, possible-use notes, and anti-rip/source-use notes from 12 curated ANSI scripts.

🎨 [style] Preserve artist signatures, dedications, authored dialogue, credits, terminal geometry, control sequences, colored backgrounds, widths, and every non-target cell.

🧪 [test] Add the hash-locked Batch 32 ledger and assertions for all 37 exact column projections across 12 files.

📝 [docs] Advance the curation checkpoint and mirrored artwork-source totals to 48,120 reviewed rows.

- [`5b08699`](https://github.com/Nick2bad4u/PS-Color-Scripts-Enhanced/commit/5b08699ac31cc2a096bc107bbc602aa068096341 "Diff: 16 files, +658 | -56") — 🧹 [chore] Blank 31 more ANSI template rows <sub><em>(16 files, +658, -56)</em></sub>

🎨 [source] Remove placeholder tutorial, template, mock-data, command, and source-use text from 10 ANSI scripts while preserving control sequences, CP437 artwork, colored spaces, and source geometry.

🧩 [fix] Repair the orphaned command-number remnants in the BOM artwork and supersede three earlier isolated retain decisions after reviewing their complete text families.

📚 [metadata] Add mixed-text review ledger 31, advance the curation checkpoint to 48,083 total blanked rows, and synchronize both artwork-source documents.

🧪 [test] Pin the 31 final row projections, record the three intentionally superseded Ledger 28 intermediate projections, and retain exact hash and geometry coverage.

- [`d0f83ad`](https://github.com/Nick2bad4u/PS-Color-Scripts-Enhanced/commit/d0f83ad292c3c7911c983662817b5d4af6dd79f0 "Diff: 101 files, +7013 | -369") — 🧹 [chore] Blank 331 more ANSI placeholder rows <sub><em>(101 files, +7013, -369)</em></sub>

🧹 [chore] Apply exact cell-range redactions across 95 scripts while preserving ANSI controls, CP437 art, colored spaces, canvas widths, and row geometry.

- Blank all twenty generic option placeholders in the FSN spoof menu as one coherent family, including their number signs and numbers, so no punctuation debris remains.

🧹 [chore] Add the hash-locked Batch 30 review ledger and advance the curation checkpoint to 48,052 total blanked rows.

- Record 331 verified projections, zero trailing-row removals, and the focused whole-family adjudication that superseded two preliminary retains.

🧪 [test] Extend checkpoint and residual-review coverage for the thirtieth ledger, exact candidate counts, and fully applied evidence.

📝 [docs] Synchronize both artwork-source guides with the latest ledger links and curation totals.

- [`e404df8`](https://github.com/Nick2bad4u/PS-Color-Scripts-Enhanced/commit/e404df8d34d2ba9efdd1673a6dc0a1f8cc68ab3e "Diff: 227 files, +8819 | -467") — 🧹 [chore] Blank 374 more ANSI placeholder rows <sub><em>(227 files, +8819, -467)</em></sub>

🧹 [chore] Apply the independently reconciled Batch 29 ledger across 221 scripts, using 339 exact-column projections and 35 whole-text projections while preserving ANSI/CP437 geometry and trimming seven newly empty terminal rows.

🧪 [test] Verify the hash-locked ledger, applied rows, missing trimmed coordinates, and synchronized cumulative checkpoint totals.

📝 [docs] Link the twenty-ninth mixed-text ledger from both artwork-source guides.

- [`7f7c9de`](https://github.com/Nick2bad4u/PS-Color-Scripts-Enhanced/commit/7f7c9de3ac37157358af5ca5d2a5c6ab105c26d8 "Diff: 199 files, +6566 | -353") — 🧹 [chore] Blank 249 more ANSI placeholder rows <sub><em>(199 files, +6566, -353)</em></sub>

🧹 [chore] Apply 244 column-specific and five whole-text redactions across 193 archive scripts while preserving ANSI controls, colored cells, widths, and row geometry.

📋 [chore] Add the hash-locked Batch 28 ledger and synchronize the curation checkpoint and mirrored artwork-source totals.

🧪 [test] Verify all 249 reviewed rows are fully applied and record that the batch removes no trailing rows.

- [`47d2d5a`](https://github.com/Nick2bad4u/PS-Color-Scripts-Enhanced/commit/47d2d5a7769d36087da1ca94b95041e78b2c5239 "Diff: 61 files, +1777 | -181") — 🧹 [chore] Blank 81 more ANSI placeholder rows <sub><em>(61 files, +1777, -181)</em></sub>

🧹 [chore] Apply the independently reconciled Batch 27 ledger across 53 scripts, removing vertical filler, generic template copy, cut markers, BBS placeholders, and one dummy field while preserving retained artwork and attribution.

🛠️ [fix] Add fail-closed source-cell column redaction with exact pre/post hashes, ANSI preservation, legacy CP437 0x16 handling, malformed-control rejection, and strict evidence validation.

🧪 [test] Lock all 81 decisions, seven targeted projections, 52 safe terminal-row removals, loader edge cases, gallery totals, and curation checkpoint counts.

📝 [docs] Register the twenty-seventh ledger and document the latest hash-locked review evidence.

- [`3be3130`](https://github.com/Nick2bad4u/PS-Color-Scripts-Enhanced/commit/3be3130d9d5f4a6279351fe4a751078095ed2e84 "Diff: 8 files, +108 | -18") — 🧹 [chore] Blank four more ANSI placeholders <sub><em>(8 files, +108, -18)</em></sub>

🧹 [chore] Remove explicit replace-me copy from two archival colorscripts.

- Blank the vertically stacked put/stuff/here phrase without changing ANSI controls, colors, widths, surrounding art, title, or attribution.

- Remove the terminal room-for-text field and its newly exposed blank spacer from the Roy/SAC script.

🧹 [chore] Add hash-locked ledger 26 and reconcile cumulative row, file, and trailing-row checkpoint totals.

🧪 [test] Verify all four source evidence hashes are applied and lock the pass 25 and pass 26 checkpoint counts.

📝 [docs] Point both artwork-source guides at the latest two mixed-text evidence ledgers.

- [`2a11acc`](https://github.com/Nick2bad4u/PS-Color-Scripts-Enhanced/commit/2a11acc6fa43115359278190156c5dc7f963efd6 "Diff: 8 files, +135 | -22") — 🧹 [chore] Blank 13 repeated X placeholders <sub><em>(8 files, +135, -22)</em></sub>

🧹 [chore] Replace two complete runs of 15- and 16-cell lowercase-X filler fields with width-preserving spaces while retaining ANSI controls, colored backgrounds, panel borders, headings, identities, and attribution.

🧹 [chore] Add the hash-only twenty-fifth residual mixed-text ledger and advance the curation checkpoint to 47,013 total blanked rows and 13,053 residual mixed-text rows.

🧪 [test] Cover the new ledger's two scripts and 13 evidence hashes, and synchronize the aggregate checkpoint assertions.

📝 [docs] Link the latest review evidence from both artwork-source documentation copies.

- [`ff8fc69`](https://github.com/Nick2bad4u/PS-Color-Scripts-Enhanced/commit/ff8fc69f2ecdb37b3a40db2cc3f55a6e5683b61e "Diff: 7 files, +84 | -12") — 🧹 [chore] Blank the final four clustered placeholders <sub><em>(7 files, +84, -12)</em></sub>

🧹 [chore] Apply the twenty-fourth mixed-text ledger to the complete matrix-stuff-goes-here filler phrase while preserving surrounding geometry and Toot attribution.

🧪 [test] Hash-lock all four projections and synchronize the exact 47,000-row content-curation checkpoint.

📝 [docs] Link the latest review ledger from both artwork-source documents.

- [`0e32e11`](https://github.com/Nick2bad4u/PS-Color-Scripts-Enhanced/commit/0e32e11adc0cb64196aec1c69c88fbdf9bea9aaa "Diff: 14 files, +396 | -57") — 🧹 [chore] Blank 46 more ANSI placeholder rows <sub><em>(14 files, +396, -57)</em></sub>

🧹 [chore] Apply the twenty-third mixed-text ledger across eight scripts while preserving ANSI controls, widths, geometry, attribution, functional menus, and complete repeated motifs.

🧪 [test] Hash-lock all 46 accepted projections and synchronize the 46,996-row content-curation checkpoint.

📝 [docs] Link the latest review ledger from both artwork-source documents.

- [`5ebe377`](https://github.com/Nick2bad4u/PS-Color-Scripts-Enhanced/commit/5ebe377c437d9f11a06b24e6230b9a080f3382d5 "Diff: 35 files, +1461 | -222") — 🧹 [chore] Blank 192 more ANSI placeholder rows <sub><em>(35 files, +1461, -222)</em></sub>

🧹 [chore] Apply the twenty-second mixed-text ledger across 29 scripts while preserving ANSI controls, widths, geometry, titles, identities, attribution, functional labels, and authored captions.

🧪 [test] Hash-lock all 192 accepted projections and synchronize the 46,950-row content-curation checkpoint.

📝 [docs] Link the latest review ledger from both artwork-source documents.

- [`f6fe3fc`](https://github.com/Nick2bad4u/PS-Color-Scripts-Enhanced/commit/f6fe3fcbcbe8a08446fd7887f43426e9d6e5445c "Diff: 48 files, +2006 | -303") — 🧹 [chore] Blank 264 more ANSI placeholder rows <sub><em>(48 files, +2006, -303)</em></sub>

🧹 [chore] Apply the twenty-first mixed-text ledger across 42 scripts while preserving ANSI controls, widths, geometry, identities, labels, and functional prompts.

🧪 [test] Lock the 264 applied row hashes and synchronize the content-curation checkpoint totals.

📝 [docs] Update both artwork-source documents to the authoritative 46,758-row cleanup total and latest review evidence.

- [`e7c99a4`](https://github.com/Nick2bad4u/PS-Color-Scripts-Enhanced/commit/e7c99a4b343d83604fe4753a5207c6f180fa05d2 "Diff: 53 files, +298 | -269") — 🧹 [chore] Blank 230 more ANSI placeholder rows <sub><em>(53 files, +298, -269)</em></sub>

🧹 [chore] Apply the twentieth mixed-text ledger across 48 scripts while preserving ANSI controls, widths, geometry, identities, labels, and functional prompts.

🧪 [test] Lock the 230 applied row hashes and synchronize the content-curation checkpoint totals.

📝 [docs] Update both artwork-source documents to the authoritative 46,494-row cleanup total and latest review evidence.

- [`ec25800`](https://github.com/Nick2bad4u/PS-Color-Scripts-Enhanced/commit/ec25800321d5422737d01e26b37b7943c022f2cb "Diff: 1 file, +1571 | -0") — 🧹 [chore] Add batch 20 ANSI text review ledger <sub><em>(1 file, +1571, -0)</em></sub>

🧹 [chore] Record 232 hash-locked text-blanking decisions across 49 color scripts.

- Preserve review categories, normalization policy, and per-row evidence hashes for deterministic application and verification.

- [`d91cb4a`](https://github.com/Nick2bad4u/PS-Color-Scripts-Enhanced/commit/d91cb4ac79b9a7f61cf0d25849bcc5b561cf9304 "Diff: 47 files, +1057 | -139") — 🧹 [chore] Blank 108 more ANSI placeholder rows <sub><em>(47 files, +1057, -139)</em></sub>

🧹 [chore] Remove reviewed command, option, information, and generic filler text from 41 ANSI scripts while preserving every row width, ANSI control sequence, block-art glyph, attribution, and surrounding composition.

🧹 [chore] Add the nineteenth hash-locked mixed-text review ledger and advance the curation checkpoint to 46,264 total blanked rows, including 12,304 residual mixed-text rows.

🧪 [test] Require the new 41-file, 108-row evidence set in the content-audit and residual-cleanup suites.

📝 [docs] Synchronize the root and module artwork-source documentation with the latest reviewed ledger.

- [`9513353`](https://github.com/Nick2bad4u/PS-Color-Scripts-Enhanced/commit/95133536ed564c59a79e7942444606deb20b39b2 "Diff: 26 files, +1034 | -152") — 🧹 [chore] Blank 134 more ANSI placeholder rows <sub><em>(26 files, +1034, -152)</em></sub>

🧹 [chore] Remove generic command, information-field, placement, and work-in-progress filler across 20 color scripts while preserving ANSI controls, colored spaces, geometry, attribution, hotkeys, and structural text.

🔒 [chore] Add the 134-row hash-locked review ledger and advance the curation checkpoint to 46,156 total blanked rows with zero pass-18 compaction or trailing-row removal.

🧪 [test] Register pass 18 in the content audits and link its evidence from both artwork-source documents.

- [`370fc9b`](https://github.com/Nick2bad4u/PS-Color-Scripts-Enhanced/commit/370fc9bef07625fa715e03f3cab7f42f8f28ed7d "Diff: 39 files, +1548 | -224") — 🧹 [chore] Blank 202 more ANSI placeholder rows <sub><em>(39 files, +1548, -224)</em></sub>

🧹 [chore] Remove generic command, option, statistics, login-field, and write-here placeholders from 33 colorscripts while retaining ANSI controls, colored spaces, structural glyphs, attribution, captions, hotkeys, and source geometry.

🧪 [test] Add the 202-row hash-locked review ledger, synchronize curation checkpoint totals and artwork-source links, and cover the seventeenth ledger in regression tests.

- [`ee9b15c`](https://github.com/Nick2bad4u/PS-Color-Scripts-Enhanced/commit/ee9b15c8e159b9830ddb892fe27b7025f7aaa7f4 "Diff: 42 files, +1137 | -155") — 🧹 [chore] Blank 129 more ANSI text rows <sub><em>(42 files, +1137, -155)</em></sub>

🧹 [chore] Remove reviewed placeholder copy, repeated filler, crude filler, and unfinished layout instructions from 36 ANSI scripts.

- Preserve canvas geometry, ANSI controls, background colors, source ordering, titles, attribution, BBS facts, meaningful UI labels, thematic captions, separators, and structural ASCII art.

🧹 [chore] Add the sixteenth hash-locked mixed-text review ledger and synchronize the curation checkpoint at 45,820 total blanked rows.

- Record 129 evidence rows with SHA-256 source proofs and zero trailing-row removals.

🧪 [test] Verify the new ledger remains hash-only, fully applied, and represented by the checkpoint totals.

📝 [docs] Link the new review evidence and update both artwork-source documents with the current curation count.

- [`a24c412`](https://github.com/Nick2bad4u/PS-Color-Scripts-Enhanced/commit/a24c4127624f0c376706d3198dd4bc22df2b6496 "Diff: 19 files, +362 | -39") — 🧹 [chore] Blank 27 more ANSI text rows <sub><em>(19 files, +362, -39)</em></sub>

🧹 [chore] Remove hash-locked junk commentary, hostile prose, crude asides, release chatter, and generic placeholders across 12 artwork scripts.

- Preserve source row geometry, ANSI controls, colored backgrounds, titles, attribution, and surrounding structural art.

- Complete five previously partial prose removals after a second full-context audit.

🧪 [test] Add the fourteenth and fifteenth mixed-text review ledgers and verify all 27 decisions replay exactly from the committed sources.

- Reconcile checkpoint totals and pass-level assertions to 45,691 blanked rows.

📝 [docs] Link both review ledgers and synchronize the curation totals in the root and module artwork-source documentation.

- [`524a665`](https://github.com/Nick2bad4u/PS-Color-Scripts-Enhanced/commit/524a665837efca51f00e6d9eddb660b1bb6e9da4 "Diff: 48 files, +667 | -65") — 🧹 [chore] Blank 44 more ANSI text rows <sub><em>(48 files, +667, -65)</em></sub>

🧹 [chore] Remove 44 manually reviewed prose, dialogue, caption, and placeholder rows across 42 ANSI scripts.

- Preserve controls, geometry, attribution, titles, service facts, interface labels, memorial text, and repeated structural typography.

- Retain 795 of 839 reviewed lower-ranked candidates when removal would affect source identity or artwork composition.

🧹 [chore] Add the hash-locked thirteenth mixed-text ledger and advance cumulative curation totals to 45,664 blanked rows.

- Record zero compaction, trailing-row removal, script deletion, metadata change, or provenance reclassification.

🧪 [test] Extend checkpoint and ledger verification for the 42-script batch.

- Validate exact replay, every changed script, all review snapshots, 217 conversion tests, strict lint, and normalized whole-work uniqueness.

📝 [docs] Link ledger 13 and synchronize the cumulative reviewed-row total across both artwork-source guides.

- [`62c4147`](https://github.com/Nick2bad4u/PS-Color-Scripts-Enhanced/commit/62c414756307bc3246716452b46579d7fbb65a7c "Diff: 82 files, +1201 | -110") — 🧹 [chore] Blank 87 more ANSI text rows <sub><em>(82 files, +1201, -110)</em></sub>

🧹 [chore] Remove 87 manually reviewed prose, dialogue, caption, and placeholder rows across 76 ANSI scripts.

- Preserve ANSI controls, background geometry, source dimensions, attribution, titles, interface labels, and structural text texture.

- Retain 840 of 927 reviewed detector candidates when their text is source-significant, structural, or uncertain.

🧹 [chore] Add the hash-locked twelfth mixed-text ledger and advance cumulative curation totals to 45,620 blanked rows.

- Record the batch as 76 modified scripts with zero compaction, trailing-row removal, deletion, or provenance reclassification.

🧪 [test] Extend content and residual-ledger assertions for the new 87-row review.

- Verify exact replay from HEAD, execute every changed script, and cover accepted-manifest, snapshot, checkpoint, geometry, and normalized-render invariants.

📝 [docs] Link the twelfth mixed-text ledger and synchronize the reviewed-row total in both artwork-source guides.

- [`a4bac83`](https://github.com/Nick2bad4u/PS-Color-Scripts-Enhanced/commit/a4bac835fc08bbf3f3b66a168e30d48688e3d6fa "Diff: 196 files, +3011 | -507") — 🧹 [chore] Blank 227 more ANSI text rows <sub><em>(196 files, +3011, -507)</em></sub>

🧹 [chore] Remove 227 manually reviewed prose rows across 170 ANSI scripts while preserving control sequences, whitespace geometry, and non-text art glyphs.

- Trim nine newly exposed trailing blank rows without reflowing or narrowing artwork.

- Record every transformation in the hash-locked batch 11 review ledger.

🧹 [chore] Remove two exact post-curation duplicate works and retain the preferred archive copies.

- Synchronize script metadata, artwork provenance, archive dispositions, gallery totals, and the retired stale analysis exception.

🧪 [test] Extend residual-cleanup and provenance coverage for the new ledger, trailing-row evidence, and intentionally removed duplicate scripts.

- Verify 227 exact transformations, 170 modified scripts, duplicate-render equality, and reconciled corpus counts.

📝 [docs] Update mirrored gallery, conversion, artwork-source, roadmap, module-summary, and package counts for 24,822 scripts.

- Document cumulative totals of 45,533 blanked rows, 23,860 trailing rows removed, and 299 removed scripts.

- [`3f90921`](https://github.com/Nick2bad4u/PS-Color-Scripts-Enhanced/commit/3f909216935eed1f3a54cf3d28cf5638d618dd65 "Diff: 51 files, +807 | -78") — 🧹 [chore] Blank 62 more ANSI text rows <sub><em>(51 files, +807, -78)</em></sub>

🧹 [chore] Remove reviewed prose, placeholder commands, menu labels, and captions from 50 archived ANSI scripts while preserving row width, controls, colored spaces, backgrounds, and terminal-art geometry.

🧹 [chore] Refresh affected source-modification notes so they accurately describe the text-redaction and fidelity-preservation policy.

🧪 [test] Add the tenth hash-locked review ledger with 62 row-level evidence hashes and category dispositions for deterministic verification and auditability.

- [`c24611c`](https://github.com/Nick2bad4u/PS-Color-Scripts-Enhanced/commit/c24611c944a925401dc1ef6f7e710c5a6099c6a2 "Diff: 140 files, +2470 | -264") — 🧹 [chore] Blank 207 additional ANSI text rows <sub><em>(140 files, +2470, -264)</em></sub>

🧹 [chore] Apply the ninth hash-locked residual mixed-text ledger across 134 curated scripts.

- Preserve ANSI controls, row geometry, colored spaces, source coordinates, attribution, titles, identities, and structural lettering while removing separable prose, captions, generic menu fields, and placeholders.

🧪 [test] Verify all 207 evidence rows remain hash-only, fully applied, letter-free, and represented in the cumulative curation checkpoint.

📝 [docs] Record the 45,244-row cumulative cleanup total and link the new ledger from both artwork-source documentation mirrors.

- [`920f0f9`](https://github.com/Nick2bad4u/PS-Color-Scripts-Enhanced/commit/920f0f948416d832037b0d6169b5e8a1c5b8819a "Diff: 792 files, +13246 | -1401") — 🧹 [chore] Blank another 1,082 ANSI text rows <sub><em>(792 files, +13246, -1401)</em></sub>

🧹 [chore] Apply the eighth supplemental hash-locked review ledger across 785 scripts.

- Classify all 4,743 ranked residual candidates, 267 dense-file candidates, adjacent prose blocks, and 25 converted-art text candidates.

- Preserve ANSI controls, colored cells, geometry, structural typography, titles, dates, identities, and artist or group attribution.

- Remove six newly empty terminal rows without compacting, narrowing, or reflowing surviving artwork.

🧹 [chore] Reconcile four superseded interface-row retentions.

- Keep all seven surviving retention hashes valid and preserve the three reviewed interface files.

- Leave analyzer exceptions and the 22 severe geometry retention decisions unchanged.

🧪 [test] Verify every new evidence hash and expected trailing-row removal.

- Cover the new ledger totals, retained-row count, cumulative checkpoint values, and full-gallery contact invariants.

📝 [docs] Raise the curation totals to 45,037 blanked rows and 23,851 trailing rows.

- Record the tenth chronological text review in the checkpoint and both artwork-source guides.

- [`b2e5774`](https://github.com/Nick2bad4u/PS-Color-Scripts-Enhanced/commit/b2e57744cb19da0570419436ea16ae5e021de084 "Diff: 1383 files, +23096 | -2476") — 🧹 [chore] Blank another 1,897 ANSI text rows <sub><em>(1383 files, +23096, -2476)</em></sub>

🧹 [chore] Apply the seventh supplemental hash-locked review ledger across 1,376 ANSI scripts.

- Preserve ANSI controls, colored cells, source geometry, structural lettering, and ambiguous typographic art.

- Remove one newly empty terminal row without compacting or narrowing surviving artwork.

🧪 [test] Verify every reviewed coordinate and refreshed gallery invariant.

- Add ledger coverage for unique files, evidence hashes, redacted rows, and the expected trailing-row removal.

- Reconcile the sole analyzer exception invalidated by the newly blanked prose.

📝 [docs] Raise the content-curation totals to 43,955 blanked rows and 23,845 trailing rows.

- Record the ninth chronological mixed-text pass in the checkpoint and both artwork-source guides.

- [`33ce189`](https://github.com/Nick2bad4u/PS-Color-Scripts-Enhanced/commit/33ce189c7bda8e2c1091e95b125c54f05903f12c "Diff: 1284 files, +22583 | -2551") — 🧹 [chore] Blank another 1,943 ANSI text rows <sub><em>(1284 files, +22583, -2551)</em></sub>

🧹 [chore] Remove reviewed prose, lyrics, labels, greetings, credits, signatures, BBS and menu copy, poems, commentary, and placeholders from 1,276 artwork scripts while preserving terminal styling, structural lettering, and source geometry.

🧹 [chore] Record every decision in a sixth hash-only mixed-text ledger, remove five newly obsolete derivative-attribution exceptions, supersede one interface-panel retention row, and reconcile five newly empty terminal rows.

📝 [docs] Raise the documented cumulative totals to 42,058 blanked text rows and 23,844 removed trailing rows in both artwork-source documents and the content-curation checkpoint.

🧪 [test] Verify exact payload redaction, ledger and retention totals, current severe geometry coverage, live exception coverage, all changed-script execution, conversion behavior, lint, gallery analysis, duplicates, documentation, and package contents.

- [`1208d82`](https://github.com/Nick2bad4u/PS-Color-Scripts-Enhanced/commit/1208d8254dc85bf103d6c686389b7a3c27a90406 "Diff: 679 files, +13588 | -1631") — 🧹 [chore] Blank another 1,298 ANSI text rows <sub><em>(679 files, +13588, -1631)</em></sub>

🧹 [chore] Remove reviewed prose, lyrics, labels, greetings, credits, signatures, BBS and menu text, poems, commentary, and placeholder copy from 671 artwork scripts while preserving styling, terminal-art glyphs, and source geometry.

🧹 [chore] Record all 1,298 decisions in a fifth hash-only mixed-text ledger, reconcile seven newly empty tail rows, and remove four obsolete derivative-attribution exceptions.

🧹 [chore] Retain the newly empty Circe new-user table and its source-authored closing border as an intentional hash-locked geometry decision instead of cropping or reflowing it.

🧪 [test] Verify ledger evidence, exact payload redaction, severe geometry coverage, exception reconciliation, cumulative totals, and synchronized documentation.

- [`e7dc446`](https://github.com/Nick2bad4u/PS-Color-Scripts-Enhanced/commit/e7dc446dc697e01c08d2605b24a5924af2d5cb8e "Diff: 717 files, +13991 | -1687") — 🧹 [chore] Blank another 1,311 ANSI text rows <sub><em>(717 files, +13991, -1687)</em></sub>

🧹 [chore] Remove reviewed prose, lyrics, labels, greetings, credits, signatures, BBS information, and placeholder copy from 709 artwork scripts while preserving their canvas width, styling, and retained composition.

🧹 [chore] Record all 1,311 row decisions in a fourth hash-only mixed-text ledger and reconcile five newly empty trailing rows, one superseded retention, and three obsolete analysis exceptions.

🧪 [test] Verify the ledger evidence, redacted payload rows, trailing-row cases, current exception count, and cumulative curation totals.

📝 [docs] Synchronize both artwork-source references and the curation checkpoint at 38,817 blanked text rows and 23,832 removed trailing rows.

- [`a8b241c`](https://github.com/Nick2bad4u/PS-Color-Scripts-Enhanced/commit/a8b241cba8378841f6fabac0247d7e3ae98bcdef "Diff: 761 files, +14335 | -1737") — 🧹 [chore] Blank another 1,303 ANSI text rows <sub><em>(761 files, +14335, -1737)</em></sub>

🧹 [chore] Apply hash-locked prose, labels, credits, signatures, commentary, board information, and placeholder redactions across 753 scripts.

- Preserve ANSI controls, art glyphs, backgrounds, and canvas width while trimming only 44 newly empty terminal rows.

🧹 [chore] Reconcile four stale derivative-attribution exceptions and refresh the one affected authentic-geometry retention hash.

🧪 [test] Add third-pass ledger integrity checks and verify exact row application, terminal trimming, and cumulative checkpoint totals.

📝 [docs] Record 37,506 cumulative blanked rows, 23,827 trailing rows removed, and the third mixed-text evidence ledger.

- [`0c85ac7`](https://github.com/Nick2bad4u/PS-Color-Scripts-Enhanced/commit/0c85ac7ce0ad57370074950c7ee71bdc36400e46 "Diff: 762 files, +16485 | -2192") — 🧹 [chore] Blank another 1,629 ANSI text rows <sub><em>(762 files, +16485, -2192)</em></sub>

🧹 [chore] Apply a second hash-locked mixed-text review across 755 scripts, covering prose, captions, greetings, dedications, credits, signatures, BBS information, and placeholder copy.

- Preserve terminal controls, colored backgrounds, art glyphs, canvas columns, source-fidelity locks, repeated structural lettering, and large typographic art; remove only 23 terminal rows made empty by the reviewed redactions.

🧪 [test] Verify the complete ledger, exact row hashes, post-redaction letter removal, terminal-row trimming, gallery execution, and synchronized curation totals.

📝 [docs] Record the 36,203-row cumulative cleanup total and remove five analysis exceptions whose trigger prose no longer exists.

- [`61d55aa`](https://github.com/Nick2bad4u/PS-Color-Scripts-Enhanced/commit/61d55aa322760595f526296f409fc3fa54f5fe31 "Diff: 83 files, +4462 | -677") — 🧹 [chore] Blank residual mixed ANSI prose <sub><em>(83 files, +4462, -677)</em></sub>

🎨 [style] Blank 614 reviewed rows across 77 16colors scripts while preserving ANSI controls, colored spaces, line art, shading, and repeated text textures; remove one newly empty terminal row.

🧹 [chore] Record hash-only evidence for essays, greetings, BBS advertising, affiliation lists, release commentary, and narrative text.

🧪 [test] Verify every reviewed hash is gone, retained target rows contain no letters, and checkpoint totals match the curated gallery.

📝 [docs] Raise curation totals to 34,574 blanked rows and 23,760 trailing rows removed in both source documentation copies.

- [`43a2c5b`](https://github.com/Nick2bad4u/PS-Color-Scripts-Enhanced/commit/43a2c5bb4f796523ae6f0215d554b3abf94d2bc8 "Diff: 112 files, +2184 | -2785") — 🧹 [chore] Complete residual ANSI gallery curation <sub><em>(112 files, +2184, -2785)</em></sub>

🧹 [chore] Remove 27 promotional scripts across eight works and redact 154 reviewed contact or promotional rows while preserving 18 art-only context rows.

🎨 [style] Crop 77 safe leading blank rows from 12 compact logos without changing visible cells.

🛠️ [fix] Detect FidoNet endpoints and isolated obfuscated phone numbers, and prune family exceptions only when all split siblings are removed.

🧪 [test] Add hash-based residual review coverage and refresh provenance, static-output, and pruning expectations.

📝 [docs] Synchronize provenance, archive checkpoints, gallery counts, and mirrored documentation for the 24,824-script corpus.

- [`b2e1b97`](https://github.com/Nick2bad4u/PS-Color-Scripts-Enhanced/commit/b2e1b970ad3f1b9834502dab5c9d1b4213f79861 "Diff: 8 files, +793 | -8") — 🧹 [chore] Lock reviewed ANSI geometry retentions <sub><em>(8 files, +793, -8)</em></sub>

🧹 [chore] Record all 21 preview-backed authentic-composition decisions with exact script hashes, analyzer metrics, source coordinates, canonical URLs, observed features, and retention rationales.

🧪 [test] Scan the complete gallery for new or drifted severe geometry signals and fail closed on hash, provenance, metric, or checkpoint mismatches.

📝 [docs] Reconcile the curation checkpoint and mirrored artwork-source and roadmap documentation, and register the verifier in the conversion test suite.

- [`fa3bec5`](https://github.com/Nick2bad4u/PS-Color-Scripts-Enhanced/commit/fa3bec587824c605fa1dd2cb61d287482b225b96 "Diff: 197 files, +3400 | -434") — 🧹 [chore] Remove reviewed ANSI contact details <sub><em>(197 files, +3400, -434)</em></sub>

🧹 [chore] Blank 228 reviewed contact or identifying-text rows across 196 imported artworks while preserving ANSI controls, colored spaces, retained glyphs, and source coordinates.

🧹 [chore] Compact only blank rows created by redaction and remove newly empty trailing rows where the reviewed cleanup made them redundant.

📝 [docs] Record hash-only, file-scoped evidence and supplemental review decisions without retaining the removed contact values.

- [`0321f3a`](https://github.com/Nick2bad4u/PS-Color-Scripts-Enhanced/commit/0321f3a87a4c6d909e8937c97b1d41ba9ab9a83e "Diff: 50 files, +534 | -4357") — 🧹 [chore] Remove reviewed adult ANSI works <sub><em>(50 files, +534, -4357)</em></sub>

🧹 [chore] Remove 46 emitted scripts representing 21 works confirmed by official archive tags and manual review to contain explicit adult content.

📝 [docs] Add the reviewed removal manifest with canonical source URLs and archive tags for an auditable disposition record.

🛠️ [fix] Synchronize archive counts, provenance, and gallery metadata with the retained 24,851-script corpus.

- [`0cac422`](https://github.com/Nick2bad4u/PS-Color-Scripts-Enhanced/commit/0cac422bce42c5079d9dbb575d2428d4ebcbdb95 "Diff: 3 files, +844 | -36") — 🧹 [chore] Checkpoint ANSI content review tooling <sub><em>(3 files, +844, -36)</em></sub>

✨ [feat] Add rendered-cell blank-run analysis, contact detection, reviewed-row redaction, and source-fidelity locks.

🔧 [build] Add a dry-run-first applier for exact review evidence, baseline blank-hole compaction, and atomic writes.

🧪 [test] Checkpoint partial content-audit coverage while the remaining geometry regression and bulk review application stay pending.

- [`380994c`](https://github.com/Nick2bad4u/PS-Color-Scripts-Enhanced/commit/380994ce8eb7261e9d77e45a60bd88aa29fbb4cc "Diff: 40 files, +352 | -1535") — 🧹 [chore] Remove post-curation duplicate ANSI renders <sub><em>(40 files, +352, -1535)</em></sub>

🧹 [chore] Delete 17 scripts whose retained terminal render duplicates another curated source.

- Reclassify their archive sources as rejected-duplicate-render without corrupting absent per-year counters.

🔧 [build] Add an explicit prune disposition option with fail-closed checkpoint validation.

📝 [docs] Synchronize provenance, metadata, curation totals, gallery counts, and mirrored documentation.

🧪 [test] Cover custom prune dispositions and lock the retained corpus counts.

- [`b7916f4`](https://github.com/Nick2bad4u/PS-Color-Scripts-Enhanced/commit/b7916f45e84e907356a9325037fda86ed1ad13ff "Diff: 294 files, +748 | -6876") — 🧹 [chore] Checkpoint ANSI content curation follow-up <sub><em>(294 files, +748, -6876)</em></sub>

🧹 [chore] Remove remaining policy-ineligible text rows and incomplete multipart works, then synchronize archive dispositions, provenance, metadata, and reviewed analysis exceptions.

🛠️ [fix] Expand exact policy-term detection with false-positive guards and detect split families whose first surviving source row begins after row one.

🧪 [test] Add regression coverage for policy matching, leading split gaps, content checkpoint integrity, and the retained gallery totals.

📝 [docs] Record the content-curation checkpoint and update the gallery and archive counts across mirrored documentation.

- [`7a63e61`](https://github.com/Nick2bad4u/PS-Color-Scripts-Enhanced/commit/7a63e6107434739ed6ac914f87f4ba81de3d37aa "Diff: 11232 files, +37843 | -71673") — 🧹 [chore] Curate imported ANSI archive content <sub><em>(11232 files, +37843, -71673)</em></sub>

🛠️ [fix] Remove standalone written text, policy-ineligible display cells, and trailing rendered-blank rows from imported ANSI artwork while preserving retained controls, art glyphs, and canvas geometry.

🧹 [chore] Prune empty and low-quality scripts and synchronize the script metadata, provenance registry, archive checkpoint, and analysis exceptions.

🧪 [test] Add reusable content-audit and registry-safe pruning tools with fixture coverage, and register them in the conversion test suite.

- [`4458d13`](https://github.com/Nick2bad4u/PS-Color-Scripts-Enhanced/commit/4458d13aba1cac649374478c9e1943483563208d "Diff: 21 files, +28 | -325") — 🗑️ [chore] Remove fragmented Retroverse ANSI import <sub><em>(21 files, +28, -325)</em></sub>

🗑️ [chore] Remove the three non-standalone zii-RETR portrait fragments from the random gallery while retaining the source as a reviewed composition rejection.

📝 [docs] Synchronize archive checkpoint, provenance, metadata, and collection counts after the removal.

- [`33d07b1`](https://github.com/Nick2bad4u/PS-Color-Scripts-Enhanced/commit/33d07b172d64d1afa0d0a6f8fbfecf1995c75a65 "Diff: 4 files, +14 | -0") — 🧹 [chore] Record the 16colors API inventory gap <sub><em>(4 files, +14, -0)</em></sub>

🧹 [chore] Preserve the canonical API's 5,487 reported, 5,479 enumerated, and eight unreturned pack counts in the consolidated checkpoint.

🧪 [test] Lock the inventory arithmetic so future scans cannot silently erase or misstate the upstream discrepancy.

📝 [docs] Clarify that completed-year coverage includes every returned pack record while the eight opaque records remain unassignable and uninspectable.

### 👷 CI/CD

- [`5699563`](https://github.com/Nick2bad4u/PS-Color-Scripts-Enhanced/commit/5699563bde805ea4323365de86e83acdea669494 "Diff: 1 file, +90 | -152") — 👷 [ci] Modernize pull request labeler rules <sub><em>(1 file, +90, -152)</em></sub>

👷 [ci] Replace unsupported title and body matchers with head-branch expressions that follow the repository's type/description branch convention.

👷 [ci] Preserve changed-file labels for CI, configuration, dependencies, documentation, rules, and tests while adding safeguards for label count and oversized pull requests.

- [`8586827`](https://github.com/Nick2bad4u/PS-Color-Scripts-Enhanced/commit/8586827c4332db5fda0e1b7c785e64d3f65ab176 "Diff: 3 files, +12 | -3") — 👷 [ci] Enforce ANSI and help verification gates <sub><em>(3 files, +12, -3)</em></sub>

👷 [ci] Expose fail-closed archive checkpoint, gallery analysis, conversion verification, and deterministic help checks through stable npm entrypoints.

👷 [ci] Run the exhaustive gallery integrity scan once on the Ubuntu ANSI-conversion job and last in opt-in strict verification to avoid tripling its corpus cost.

🧪 [test] Lock the non-mutating verification contract and include checkpoint validation in the aggregate Node test suite.

### 📦 Dependencies

- [`418b62a`](https://github.com/Nick2bad4u/PS-Color-Scripts-Enhanced/commit/418b62af9439dffa7ef8ceaaed9fa02b9b8c0613 "Diff: 1 file, +9 | -9") — Merge remote-tracking branch 'refs/remotes/origin/main' <sub><em>(1 file, +9, -9)</em></sub>

* refs/remotes/origin/main:
  ⬆️ [build] Update fast-uri
  ⬆️ [build] Update dependabot_all-a846e8a06a dependencies

- [`06d1c3f`](https://github.com/Nick2bad4u/PS-Color-Scripts-Enhanced/commit/06d1c3f008f408c4afd2fc4d5df87ed053d5dd53 "Diff: 1 file, +3 | -3") — ⬆️ [build] Update fast-uri <sub><em>(1 file, +3, -3)</em></sub>

- [`d0b6088`](https://github.com/Nick2bad4u/PS-Color-Scripts-Enhanced/commit/d0b6088f54dd63b6cb003f0efc5255cc21e49a77 "Diff: 1 file, +6 | -6") — ⬆️ [build] Update dependabot_all-a846e8a06a dependencies <sub><em>(1 file, +6, -6)</em></sub>

### 🛡️ Security

- [`843ac10`](https://github.com/Nick2bad4u/PS-Color-Scripts-Enhanced/commit/843ac108904b8ba87f1fa3dfb8a4ec8663fa2e73 "Diff: 8 files, +206 | -43") — 🛠️ [fix] Make legacy provenance hashes cross-platform <sub><em>(8 files, +206, -43)</em></sub>

🔐 [fix] Canonicalize only CRLF pairs before hashing 3,153 unmapped legacy scripts, and upgrade migration evidence to fail-closed schema 2.

🧪 [test] Cover checkout line endings, lone CR bytes, schema validation, inventory changes, and content drift across the 340-test conversion suite.

🛡️ [security] Replace brittle line fingerprints with an exact two-value Gitleaks allowlist for known SHA-256 false positives.

📝 [docs] Document the checkout-stable hash invariant in root and packaged artwork guidance.

- [`fd1cc6d`](https://github.com/Nick2bad4u/PS-Color-Scripts-Enhanced/commit/fd1cc6d2fd86ac66641227790e5efa2a47f5d65f "Diff: 1 file, +4 | -0") — 🛡️ [fix] Baseline provenance hash false positives <sub><em>(1 file, +4, -0)</em></sub>

🔐 [security] Ignore only the exact history and directory fingerprints for two SHA-256 values misclassified as JFrog identity tokens.

✅ [test] Verify both Gitleaks git-history and directory scans pass without suppressing future findings in the audit ledger.

- [`52631d2`](https://github.com/Nick2bad4u/PS-Color-Scripts-Enhanced/commit/52631d21f65149f48952aacabe7abf42af28416c "Diff: 12 files, +4159 | -6150") — 🔧 [build] Refresh release and verification tooling <sub><em>(12 files, +4159, -6150)</em></sub>

🔧 [build] Align the repository and GitHub Actions with Node.js 26.5.1, current formatter, lint, changelog, security, and archive-development dependencies, and the synchronized lockfile.

👷 [ci] Refresh immutable action pins and the PlatyPS 1.0.3 help-build tool while preserving the existing validation, packaging, release, Pages, and automation behavior.

🧪 [test] Wire compact provenance migration and web-index checks into normal and strict verification, and include the shared provenance-reader suite in conversion tests.

🧹 [chore] Add the combined dependency/action refresh command and normalize workflow YAML formatting.

## ⭐ Contributors
Thanks to anyone who has 🧑‍💻 [contributed](https://github.com/Nick2bad4u/PS-Color-Scripts-Enhanced/graphs/contributors).

*This changelog was automatically generated with ⛰️ [git-cliff](https://github.com/orhun/git-cliff).*
