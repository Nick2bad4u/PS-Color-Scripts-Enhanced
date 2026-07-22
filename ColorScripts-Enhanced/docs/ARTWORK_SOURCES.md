# Artwork Sources and Provenance

ColorScripts-Enhanced combines project-authored renderers with curated third-party ANSI and ASCII art. Source availability does not by itself grant redistribution rights, so imports are reviewed for licensing, provenance, duplication, encoding, dimensions, and rendering behavior before conversion.

## Current Provenance Records

New curated imports are recorded in [ArtworkProvenance.psd1](../../ColorScripts-Enhanced/ArtworkProvenance.psd1). The data file maps each imported script to its source collection and records pinned source revisions or archive hashes, source-file hashes, encoding, and conversion mode.

The corresponding third-party notices are:

- [botany ISC notice](../../ColorScripts-Enhanced/ThirdPartyNotices/botany-ISC.txt)
- [os-ansi ISC notice](../../ColorScripts-Enhanced/ThirdPartyNotices/os-ansi-ISC.txt)
- [Asciiville MIT notice](../../ColorScripts-Enhanced/ThirdPartyNotices/asciiville-MIT.txt)
- [Durdraw BSD-3-Clause notice](../../ColorScripts-Enhanced/ThirdPartyNotices/durdraw-BSD-3-Clause.txt)
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

### Roy/SAC ANSI gallery

- Gallery: <https://www.roysac.com/roy_ansishow.html>
- Downloadable archive: <https://www.roysac.com/images/galleries/ZIP/Roy_ANSI.ZIP>
- 2006 public-domain statement: <https://www.roysac.com/blog/2006/07/important-decision-made-regarding-my-text-art/>
- 2008 Free Art License change: <https://www.roysac.com/blog/2008/08/copyleft-vs-public-domain/>
- Official FAL-1.3 text: <https://artlibre.org/licence/lal/en/>
- SAC pack browser: <https://16colo.rs/group/sac>
- Reviewed archive SHA-256: `8598a9432b4feb86c4e79552795b407b9d7c576fb6f25e9828d6143f1c7b35bc`
- Reviewed inventory: 183 files in Roy's archive plus 45 indexed SAC packs
- Current import: 35 Roy-authored works represented by 40 scripts

This is traditional CP437/SAUCE BBS-scene artwork. Five works came from Roy's standalone archive and 30 more were selected from SHA-256-pinned SAC pack archives after preview, multicolor, provenance, duplicate, and geometry review. Two 122-row works are split into three 39-44-row parts, and one 65-row work is split into two parts at a blank boundary. Every Roy script is independently licensed under FAL-1.3, names Roy/SAC (Carsten Cumbrowski), links its exact source, records the source hash and archive hash, and describes the conversion. This deliberately follows Roy's stricter 2008 copyleft statement even though his 2006 and current gallery language says public domain. Approximately 348 works by other SAC artists are excluded because Roy's statements do not license their art.

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

- [Blocktronics artpacks](https://github.com/blocktronics/artpacks): pack display/release permission is not a collection-wide derivative and redistribution grant.
- [Mistigris](https://mistigris.org/): its [pack terms](https://16colo.rs/pack/mist0625/LICENSE.TXT) limit use, prohibit sale/promotion, and require artist contact for other uses.
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
4. Deduplicate against both source ANSI assets and converted scripts.
5. Decode traditional DOS/BBS art using its real encoding, usually CP437.
6. Validate terminal dimensions and split only where visual composition remains coherent.
7. Convert deterministically, add metadata, and run corpus/conversion/rendering tests.
8. Do not claim that an archive, mirror, or gallery relicensed an individual artist's work.

See [ANSI-CONVERSION-GUIDE.md](ANSI-CONVERSION-GUIDE.md) for the technical conversion workflow.
