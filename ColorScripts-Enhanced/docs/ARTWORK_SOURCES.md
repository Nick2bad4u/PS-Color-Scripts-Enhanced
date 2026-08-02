# Artwork Sources and Provenance

ColorScripts-Enhanced combines project-authored renderers with curated third-party ANSI and ASCII art. Source availability does not by itself grant redistribution rights, so imports are reviewed for licensing, provenance, duplication, encoding, dimensions, and rendering behavior before conversion.

## Current Provenance Records

New curated imports are recorded in [ArtworkProvenance.psd1](../../ColorScripts-Enhanced/ArtworkProvenance.psd1). The data file maps each imported script to its source collection and records pinned source revisions or archive hashes, source and rendered hashes, encoding, conversion mode, attribution, SAUCE details, and source coordinates for split works.

The corresponding third-party notices are:

- [botany ISC notice](../../ColorScripts-Enhanced/ThirdPartyNotices/botany-ISC.txt)
- [os-ansi ISC notice](../../ColorScripts-Enhanced/ThirdPartyNotices/os-ansi-ISC.txt)
- [Asciiville MIT notice](../../ColorScripts-Enhanced/ThirdPartyNotices/asciiville-MIT.txt)
- [Durdraw BSD-3-Clause notice](../../ColorScripts-Enhanced/ThirdPartyNotices/durdraw-BSD-3-Clause.txt)
- [16colors artist-authorized permission notice](../../ColorScripts-Enhanced/ThirdPartyNotices/16colors-discord-permission.txt)
- [Roy/SAC FAL-1.3 notice](../../ColorScripts-Enhanced/ThirdPartyNotices/roy-sac-FAL-1.3.txt)

The older catalog predates this per-file registry. Missing historical provenance must not be replaced with guesses.

## Collections to Browse

### botany

- Repository: <https://github.com/jifunks/botany>
- Pinned art tree: <https://github.com/jifunks/botany/tree/2802121ed8268df1b69584167a14d4c690aaea35/art>
- Pinned archive: <https://github.com/jifunks/botany/archive/2802121ed8268df1b69584167a14d4c690aaea35.zip>
- License: [ISC](https://github.com/jifunks/botany/blob/2802121ed8268df1b69584167a14d4c690aaea35/LICENSE)
- Reviewed inventory: 72 `.ansi` files and 74 related art assets
- Current import: 17 flowering final-stage (`*3.ansi`) plants

botany is a terminal plant-growing application with compact ANSI plant artwork. All 72 ANSI files fit within 120 columns by 50 rows and rendered cleanly. The import selects 17 visually distinct flowering final-stage files; the other 55 are primarily earlier growth, seed-bearing, death, mutation, or redundant variants. These files are already sequential ANSI streams, so conversion preserves their original SGR sequences and CRLF geometry byte-for-byte in passthrough mode instead of flattening them through the terminal emulator. A source-hash regression test prevents later conversion or line-ending changes from altering their colors or spacing.

### os-ansi

- Canonical repository: <https://codeberg.org/NNB/os-ansi>
- Pinned canonical archive: <https://codeberg.org/NNB/os-ansi/archive/64449ace20798a2149eeb527e5cd16428f0b45e5.zip>
- GitHub mirror: <https://github.com/info-mono/os-ansi>
- Pinned mirror tree: <https://github.com/info-mono/os-ansi/tree/64449ace20798a2149eeb527e5cd16428f0b45e5>
- Major upstream art credit: [jschx/ufetch](https://gitlab.com/jschx/ufetch)
- License: [ISC](https://github.com/info-mono/os-ansi/blob/64449ace20798a2149eeb527e5cd16428f0b45e5/LICENSE)
- Reviewed inventory: 36 operating-system logo streams
- Current import: 2 genuinely multicolor files

This collection focuses on operating-system logo ANSI art. Only the five-color macOS and four-color CentOS logos meet the required multicolor threshold after every source was compared with the full rendered catalog. The other 34 files use no more than two explicit hues and are rejected as monochrome or duotone. The accepted files are LF-only ANSI streams whose line-feed behavior is significant, so they use byte-preserving passthrough conversion and protected Git attributes instead of terminal-emulator reconstruction or Windows line-ending conversion.

### Asciiville

- Repository: <https://github.com/doctorfree/Asciiville>
- Pinned art tree: <https://github.com/doctorfree/Asciiville/tree/49f6289d511033b8ded1bd8d38f60c4bc5fd0301/art>
- Imported source: <https://github.com/doctorfree/Asciiville/blob/49f6289d511033b8ded1bd8d38f60c4bc5fd0301/art/asciiville.asc>
- Pinned archive: <https://github.com/doctorfree/Asciiville/archive/49f6289d511033b8ded1bd8d38f60c4bc5fd0301.zip>
- License record: <https://github.com/doctorfree/Asciiville/blob/49f6289d511033b8ded1bd8d38f60c4bc5fd0301/copyright>
- Reviewed inventory: 946 `.asc` files, including 697 multicolor files
- Current import: 1 project-authored rainbow wordmark

Only Ronald Record's compact 67-by-4 Asciiville wordmark has a sufficiently clear authorship and MIT license chain. It uses nine visible 256-color foregrounds and is preserved as an LF-only passthrough stream. The other galleries are not bulk-imported: 686 multicolor files are roughly 400-500 rows tall, and most are conversions of externally sourced Flickr, Wallhaven, vintage, or otherwise undocumented images. The `Vintage` directory also has conflicting public-domain and noncommercial notices. A project license on the conversion does not prove rights to relicense the underlying image.

### Durdraw

- Gallery: <https://github.com/durdraw/durdraw#gallery>
- Pinned examples: <https://github.com/durdraw/durdraw/tree/cf63d7445c00c5db1ee2dd28df8325649045b803/examples>
- Imported ANSI source: <https://github.com/durdraw/durdraw/blob/cf63d7445c00c5db1ee2dd28df8325649045b803/examples/indyz-kali.utf8.ans>
- Pinned archive: <https://github.com/durdraw/durdraw/archive/cf63d7445c00c5db1ee2dd28df8325649045b803.zip>
- License: [BSD-3-Clause](https://github.com/durdraw/durdraw/blob/cf63d7445c00c5db1ee2dd28df8325649045b803/LICENSE)
- Current import: 1 native 80-by-32 UTF-8 ANSI stream

The native `indyz-kali.utf8.ans` example contains 2,481 SGR sequences across exactly 32 rows and is preserved byte-for-byte instead of being reconstructed at the wrong 61-row geometry. Durdraw's richer `.dur` examples remain future candidates because they require a frame-, timing-, glyph-, and palette-aware parser.

### 16colors artist-authorized archive imports

- Archive browser: <https://16colo.rs/>
- Canonical API: <https://api.16colo.rs/>
- API documentation: <https://16colo.rs/api/>
- Archive rights policy: <https://16colo.rs/faq/>
- Permission evidence: [maintainer attestation](../../ColorScripts-Enhanced/ThirdPartyNotices/16colors-discord-permission.txt)
- Compact audit checkpoint: [AnsiArchiveCurationCheckpoint.json](../AnsiArchiveCurationCheckpoint.json)
- Content-curation checkpoint: [AnsiContentCurationCheckpoint.json](../AnsiContentCurationCheckpoint.json)
- Hash-locked review evidence: [content](../AnsiContentReviewLedger.json), [contact follow-up](../AnsiContactFollowupReviewLedger.json), [independent contact-prompt follow-up](../AnsiContactShadowReviewLedger.json), [residual content and advertisement review](../AnsiResidualContentReviewLedger.json), [first mixed prose and BBS text review](../AnsiResidualMixedTextReviewLedger.json), [second mixed-text review](../AnsiResidualMixedTextReviewLedger2.json), [third mixed-text review](../AnsiResidualMixedTextReviewLedger3.json), [fourth mixed-text review](../AnsiResidualMixedTextReviewLedger4.json), [fifth mixed-text review](../AnsiResidualMixedTextReviewLedger5.json), [sixth mixed-text review](../AnsiResidualMixedTextReviewLedger6.json), [seventh mixed-text review](../AnsiResidualMixedTextReviewLedger7.json), [eighth mixed-text review](../AnsiResidualMixedTextReviewLedger8.json), [ninth mixed-text review](../AnsiResidualMixedTextReviewLedger9.json), [tenth mixed-text review](../AnsiResidualMixedTextReviewLedger10.json), [eleventh mixed-text review](../AnsiResidualMixedTextReviewLedger11.json), [twelfth mixed-text review](../AnsiResidualMixedTextReviewLedger12.json), [thirteenth mixed-text review](../AnsiResidualMixedTextReviewLedger13.json), [fourteenth mixed-text review](../AnsiResidualMixedTextReviewLedger14.json), [fifteenth mixed-text review](../AnsiResidualMixedTextReviewLedger15.json), [sixteenth mixed-text review](../AnsiResidualMixedTextReviewLedger16.json), [seventeenth mixed-text review](../AnsiResidualMixedTextReviewLedger17.json), [blank-geometry removals](../AnsiBlankGeometryReviewLedger.json), [high-confidence geometry actions](../AnsiGeometryReviewManifest.json), [residual compact-logo geometry actions](../AnsiResidualGeometryReviewManifest.json), and [authentic-composition geometry retentions](../AnsiGeometryRetentionReviewLedger.json)
- Recent hash-locked mixed-text evidence: [seventy-first mixed-text review](../AnsiResidualMixedTextReviewLedger71.json), [seventy-second mixed-text review](../AnsiResidualMixedTextReviewLedger72.json), and [seventy-third mixed-text review](../AnsiResidualMixedTextReviewLedger73.json)
- Adult-policy decisions: [removed works](../AnsiPolicyRemovalManifest.json) and [adult-tagged works retained after preview review](../AnsiPolicyRetentionReviewLedger.json)
- Accepted source formats: `.ANS` and `.ICE`
- Current named import: [The Lake House](https://16colo.rs/pack/mist0624/ZII-LAHO.ANS) by Zeus II of Mistigris, represented by six contiguous scripts
- Review status: 1990-2026 review-complete, with every accepted work imported

The archive remains a browsing and preservation service; public availability is not treated as a license. For this project, the maintainer attested on 2026-07-22 that artists, rightsholders, or an explicitly authorized representative granted project-specific permission to redistribute and convert artwork from the 16colors and Roy/SAC sites with attribution. This does not relicense the archive for unrelated uses.

The resumable `npm run ansi:audit -- --source=all` workflow enumerates the canonical pack API and Roy download inventory, caches raw candidates and previews under ignored `temp/`, fingerprints source bytes and rendered terminal cells, rejects monochrome and duotone output, and writes an interactive review sheet. A candidate is imported only after general-audience, artistic-quality, composition, terminal-safety, duplicate, and attribution review. The normal gallery limits are 120 columns and 50 rows per script. Tall art is kept in contiguous source-row order; wide art is split only at coherent panel boundaries and is otherwise rejected. Source margins and background-colored spaces remain intact except where the tracked post-import content audit blanks standalone writing, readable prose embedded in framed panels, or policy-ineligible display cells and removes rendered-blank rows after the final retained artwork row. Explicit `Passthrough` conversion markers protect byte-preserved sources from those mutations.

The 1990-2026 review is complete and its retained works are in the module. Across those 37 archive years, the audit enumerated 5,479 packs and reviewed 64,929 `.ANS` or `.ICE` candidates. Post-import content, adult-policy, quality, source-continuity, and duplicate-render curation leaves 15,073 accepted works represented by 21,495 scripts. The content checkpoint records 49,663 reviewed text, contact, or policy rows blanked without narrowing their canvases; 23,949 trailing rendered-blank rows removed after restoring 34 source-significant passthrough rows; 8,610 rows compacted only after curation made them blank; 62 explicitly reviewed rows removed; and 767 high-confidence geometry rows removed. The geometry total includes 26 rebalanced families represented by 134 scripts, with 69 generated presentation rows discarded separately from source-row accounting. It also records 299 empty, low-quality, source-incomplete, duplicate-render, adult-policy, or principally promotional scripts removed. The archive checkpoint records each year's inventory fingerprint and disposition totals, one source/hash entry per retained original work, and exact-source duplicates already represented elsewhere in the gallery.

The API inventory currently reports 5,487 packs but returns 5,479 records. Live refreshes through 2026-07-24 reproduced the same eight-record gap at both 500- and 250-record page sizes. Those unreturned records provide no pack name, year, or file metadata to inspect; the checkpoint retains all three counts explicitly. A completed-year claim therefore means every pack record the canonical API actually returned for that year was audited, not that the project inferred or silently skipped the eight opaque records.

The Lake House is decoded from CP437 at its declared 80-column width without background stripping. Its 200 populated terminal rows are preserved as `1-40`, `41-80`, `81-112`, `113-144`, `145-176`, and `177-200`; the first three scripts form the continuous landscape and the final three preserve its BBS menu panels.

### Roy/SAC ANSI gallery

- Gallery: <https://www.roysac.com/roy_ansishow.html>
- Official download index: <https://www.roysac.com/roy-sac_downloads_links.html>
- Downloadable archive: <https://www.roysac.com/images/galleries/ZIP/Roy_ANSI.ZIP>
- 2006 public-domain statement: <https://www.roysac.com/blog/2006/07/important-decision-made-regarding-my-text-art/>
- 2008 Free Art License change: <https://www.roysac.com/blog/2008/08/copyleft-vs-public-domain/>
- Official FAL-1.3 text: <https://artlibre.org/licence/lal/en/>
- SAC pack browser: <https://16colo.rs/group/sac>
- Reviewed archive SHA-256: `8598a9432b4feb86c4e79552795b407b9d7c576fb6f25e9828d6143f1c7b35bc`
- Dedicated archive inventory: 183 `.ANS` files and 2 unsupported `.BIN` files in `Roy_ANSI.ZIP`; 161 `.ANS` files in `Roy_EarlyANSI.ZIP`
- Download inventory: 62 official archives audited; 44 yielded `.ANS` candidates
- Live 16colors Roy inventory: 381 `.ANS` files, 235 unique after deduplication, and no pending decisions
- Current import: 126 unique Roy-authored works represented by 153 scripts

This is traditional CP437/SAUCE BBS-scene artwork. The collection comprises 84 works represented by 104 scripts from the dedicated archive review, 35 normalized legacy works represented by 40 scripts, and 7 additional Roy-authored works from 16colors represented by 9 scripts. The live 16colors Roy queue closed with seven accepts and two rejects. The two `.BIN` files are outside this curation plan's supported `.ANS`/`.ICE` formats and were not converted.

Every Roy-authored script remains independently licensed under FAL-1.3, names Roy/SAC (Carsten Cumbrowski), links its exact source, records the available source and archive hashes, and describes the conversion. This includes Roy works discovered through 16colors; they are not moved into the permission-based `16colors-permitted` collection. This deliberately follows Roy's stricter 2008 copyleft statement even though his 2006 and current gallery language says public domain. Other artists represented in SAC packs are evaluated under the separate artist-authorized permission attestation and never relabeled as Roy-authored or FAL-1.3 work.

## Future Candidates Requiring a Dedicated Renderer

### HyFetch

- Repository: <https://github.com/hykilpikonna/hyfetch>
- Reviewed logo tree: <https://github.com/hykilpikonna/hyfetch/tree/84876b61aa08c063393cac5caa2b046412616718/hyfetch/data/distros>
- Pinned archive: <https://github.com/hykilpikonna/hyfetch/archive/84876b61aa08c063393cac5caa2b046412616718.zip>
- License: [MIT](https://github.com/hykilpikonna/hyfetch/blob/84876b61aa08c063393cac5caa2b046412616718/LICENSE.md)
- Reviewed inventory: 570 distinct `.ascii` templates

HyFetch is the largest promising next source, but its files are parameterized palette templates containing tokens such as `${c1}` rather than finished ANSI streams. Importing them correctly requires a palette-aware renderer, rendered-output deduplication, a bundled license notice, and review of distribution-logo attribution or trademark concerns.

### Fastfetch

- Repository: <https://github.com/fastfetch-cli/fastfetch>
- Reviewed logo tree: <https://github.com/fastfetch-cli/fastfetch/tree/dda39f0c6712788ecf257a987ac5630f878d92ce/src/logo/ascii>
- Pinned archive: <https://github.com/fastfetch-cli/fastfetch/archive/dda39f0c6712788ecf257a987ac5630f878d92ce.zip>
- License: [MIT](https://github.com/fastfetch-cli/fastfetch/blob/dda39f0c6712788ecf257a987ac5630f878d92ce/LICENSE)
- Reviewed inventory: 528 templates

Fastfetch is another large operating-system logo source with similar template, palette, rendered-duplicate, attribution, and trademark concerns. It should share the HyFetch renderer and review pipeline instead of being flattened by the general ANSI converter.

### Durdraw animated examples

- Visual gallery: <https://github.com/durdraw/durdraw#gallery>
- Raw examples: <https://github.com/durdraw/durdraw/tree/cf63d7445c00c5db1ee2dd28df8325649045b803/examples>
- Pinned archive: <https://github.com/durdraw/durdraw/archive/cf63d7445c00c5db1ee2dd28df8325649045b803.zip>
- Format specification: <https://github.com/durdraw/durdraw/blob/cf63d7445c00c5db1ee2dd28df8325649045b803/durformat.md>
- License: [BSD-3-Clause](https://github.com/durdraw/durdraw/blob/cf63d7445c00c5db1ee2dd28df8325649045b803/LICENSE)
- Reviewed inventory: 14 `.dur` animations/static canvases, one ANSI file, and one plain ASCII file

Durdraw is the strongest next animated collection. `indyz-space-shaman.dur`, `indyz-xmas.dur`, `indyz-dopehax-256.dur`, and `cm-eye.dur` are 79-87 columns by 23-26 rows with 5-16 frames and rich palettes. The native `indyz-kali.utf8.ans` stream is already imported. The `.dur` files are compressed JSON with per-cell colors, frames, and timing; a correct importer must parse that format rather than rasterizing GIF previews. Character/meme pieces such as the Doge examples should be excluded.

### Cataclysm: Dark Days Ahead ASCII-art data

- Collection: <https://github.com/CleverRaven/Cataclysm-DDA/tree/98ca78de883b1402a985d4261cfa3378ddf56cad/data/json/ascii_art>
- Pinned archive: <https://github.com/CleverRaven/Cataclysm-DDA/archive/98ca78de883b1402a985d4261cfa3378ddf56cad.zip>
- Representative raw file: <https://raw.githubusercontent.com/CleverRaven/Cataclysm-DDA/98ca78de883b1402a985d4261cfa3378ddf56cad/data/json/ascii_art/generic_ascii.json>
- License: [CC BY-SA 3.0](https://github.com/CleverRaven/Cataclysm-DDA/blob/98ca78de883b1402a985d4261cfa3378ddf56cad/LICENSE.txt)
- Reviewed inventory: 427 records in 58 JSON files; 65 records use at least four declared colors

This is the largest cleanly licensed additional collection. Strong generic candidates include `umbrella` (41x30, 6 colors), `electrohack` (36x14, 8), `paint_can_plastic` and `paint_can_steel` (14x11, 12 each), `aquarium_small` (32x9, 4), `manual_first_aid` (41x34, 4), and `textbook_chemistry` (41x35, 4). The JSON uses semantic `<color_name>` tags, so conversion needs a documented tag-to-ANSI map. Any imported file must remain separately licensed and attributed under CC BY-SA 3.0.

### Nuru sample images

- Repository and format: <https://github.com/domsson/nuru>
- Sample collection: <https://github.com/domsson/nuru/tree/0cb3d08971e8a76d02636c50eaf1a04f87f4ccf7/nui>
- Interactive viewer: <https://domsson.github.io/nuru-web/>
- Pinned archive: <https://github.com/domsson/nuru/archive/0cb3d08971e8a76d02636c50eaf1a04f87f4ccf7.zip>
- License: [CC0-1.0](https://github.com/domsson/nuru/blob/0cb3d08971e8a76d02636c50eaf1a04f87f4ccf7/LICENSE)
- Reviewed inventory: 15 `.nui` files

The art-like candidates are `house` (9x4, 5 colors), `togglebit` (14x7, 7), `nuru-cat` (64x11, 15), `nuru-dot-net` (63x5, 5), and `nuru` (78x12, 8). CC0 makes the rights boundary simple, but `.nui` is a binary glyph/palette format and requires a native parser. Screenshots are not acceptable conversion sources.

### PowerShell Paint

- Repository and gallery: <https://github.com/ShaunLawrie/PwshPaint>
- Raw images: <https://github.com/ShaunLawrie/PwshPaint/tree/a0cd969c466c6147eab56a9e3024ae199aadfdb1/PwshPaint/Images>
- Pinned archive: <https://github.com/ShaunLawrie/PwshPaint/archive/a0cd969c466c6147eab56a9e3024ae199aadfdb1.zip>
- License: [MIT](https://github.com/ShaunLawrie/PwshPaint/blob/a0cd969c466c6147eab56a9e3024ae199aadfdb1/LICENSE.md)
- Reviewed inventory: 7 RGB JSON pixel images

`spiral` (12x12, 16 colors), `snake` (28x28, 7), and `heart` (28x28, 3) are plausible generic imports. The Pokemon, Clippy, and branded `pwshcorn` pieces are excluded. A future RGB-cell importer must document its aspect policy; if half-blocks compact vertical pixels, it must not also compact the horizontal axis.

### Procedural and generator sources

- [Bash Screensavers gallery](https://github.com/attogram/bash-screensavers/blob/4c3a4fc76fc8e073ca0f41bdea93c70ad1b6d6df/gallery/README.md) and [MIT license](https://github.com/attogram/bash-screensavers/blob/4c3a4fc76fc8e073ca0f41bdea93c70ad1b6d6df/LICENSE): `fireworks`, `tunnel`, `stars`, `alpha`, `pipes`, and `rain` are candidates for native PowerShell ports, not arbitrary static-frame captures.
- [Bit ANSI fonts](https://github.com/paulilaaso/bit/tree/07c7c1c74396d0cfbc54b694f26d6308b93d509d/ansifonts/fonts) and [MIT repository license](https://github.com/paulilaaso/bit/blob/07c7c1c74396d0cfbc54b694f26d6308b93d509d/LICENSE): 125 bitmap fonts are useful generator inputs. Limit initial use to the 76 fonts explicitly marked CC0, OFL-1.1, 0BSD, or MIT; reject 36 ambiguous `CC-4.0` labels and defer GPL fonts.
- [Candy Box 2 ASCII collection](https://github.com/candybox2/candybox2.github.io/tree/master/ascii) and [CC BY-SA 3.0 terms](https://candybox2.github.io/ascii_art.html): 297 cleanly licensed but monochrome files would require original editorial color design, so they are lower priority than native multicolor sources.
- [Wikimedia Commons ANSI-art category](https://commons.wikimedia.org/wiki/Category:ANSI_art): only 15 raster files with mixed per-file licenses. Treat each description page separately and prefer recoverable original ANSI streams over lossy screenshot conversion.

## Collections Rejected for Redistribution

- [Blocktronics artpacks](https://github.com/blocktronics/artpacks) outside the covered 16colors archive workflow: pack display/release permission is not by itself a collection-wide derivative and redistribution grant.
- [Mistigris](https://mistigris.org/) material obtained outside the covered 16colors archive workflow: individual pack terms still apply unless the work is covered by the recorded artist-authorized project permission.
- [Arttime](https://github.com/poetaman/arttime): `LICENSE_ART` limits collected artwork to personal, noncommercial use.
- [NNB/ansi](https://codeberg.org/NNB/ansi): the project says material was gathered from Reddit, Joan Stark, ASCII-art sites, and other sources; the repository license cannot establish rights to those works.
- [ANSI art tutorials](https://github.com/xero/ansi-art-tutorials): the MIT wrapper does not relicense the separately credited scene artwork.
- [PhMajerus/ANSI-art](https://github.com/PhMajerus/ANSI-art): raw ANSI files but no license.
- [ASCII Art Archive](https://www.asciiart.eu/terms-of-use): personal, noncommercial terms and anti-scraping restrictions.
- [Asciiquarium](https://github.com/cmatsuoka/asciiquarium): GPL covers the program, but its art includes Joan Stark work and pieces of unknown origin.
- Character-oriented collections involving Pokemon, Mario, Kirby, film characters, or similar properties remain unsuitable merely because their repository wrapper uses a permissive license.

## Existing Upstream Collections

These remain useful for browsing and historical context:

- [shell-color-scripts](https://gitlab.com/dwt1/shell-color-scripts) — original shell collection
- [ps-color-scripts](https://github.com/scottmckendry/ps-color-scripts) — original PowerShell port
- [Pokemon-Colorscripts](https://gitlab.com/phoneybadger/pokemon-colorscripts) — Pokémon terminal art
- [16colo.rs](https://16colo.rs/) — large scene-art archive and browser
- [ArtScene archive](http://artscene.textfiles.com/artpacks/) — historical art packs
- [textfiles.com art directory](http://artscene.textfiles.com/) — broader scene-art index
- [NNB ANSI collection](https://codeberg.org/NNB/ansi) — broader sibling collection to `os-ansi`

Archive access is not a blanket license. Review the actual pack/file terms and author attribution before importing anything.

## Import Requirements

For every new third-party import:

1. Record the canonical source URL and a pinned revision or archive hash.
2. Record the source file path/hash, encoding, artist or pack attribution, and applicable license or permission.
3. Preserve the exact license or evidence in `ColorScripts-Enhanced/ThirdPartyNotices/`.
4. Deduplicate against both source ANSI assets and normalized rendered terminal-cell fingerprints.
5. Decode traditional DOS/BBS art using its real encoding, usually CP437.
6. Preserve SAUCE geometry, iCE state, colored spaces, margins, and blank rows; validate terminal dimensions and split only where visual composition remains coherent.
7. Compare the generated scripts with the raw source using `npm run ansi:verify-conversion -- --source=<file> --prefix=<script-prefix>`; exact terminal-cell and coordinate coverage must match.
8. Add metadata and run corpus, conversion, rendering, documentation, and packaging tests.
9. Do not claim that an archive, mirror, or gallery relicensed an individual artist's work.

See [ANSI-CONVERSION-GUIDE.md](ANSI-CONVERSION-GUIDE.md) for the technical conversion workflow.
