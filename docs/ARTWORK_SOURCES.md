# Artwork Sources and Provenance

ColorScripts-Enhanced combines project-authored renderers with curated third-party ANSI and ASCII art. Source availability does not by itself grant redistribution rights, so imports are reviewed for licensing, provenance, duplication, encoding, dimensions, and rendering behavior before conversion.

## Current Provenance Records

New curated imports are recorded in [ArtworkProvenance.psd1](../ColorScripts-Enhanced/ArtworkProvenance.psd1). The data file maps each imported script to its source collection and records pinned source revisions or archive hashes, source-file hashes, encoding, and conversion mode.

The corresponding third-party notices are:

- [botany ISC notice](../ColorScripts-Enhanced/ThirdPartyNotices/botany-ISC.txt)
- [os-ansi ISC notice](../ColorScripts-Enhanced/ThirdPartyNotices/os-ansi-ISC.txt)
- [Roy/SAC public-domain evidence](../ColorScripts-Enhanced/ThirdPartyNotices/roy-sac-public-domain.txt)

The older catalog predates this per-file registry. Missing historical provenance must not be replaced with guesses.

## Collections to Browse

### botany

- Repository: <https://github.com/jifunks/botany>
- Pinned art tree: <https://github.com/jifunks/botany/tree/2802121ed8268df1b69584167a14d4c690aaea35/art>
- Pinned archive: <https://github.com/jifunks/botany/archive/2802121ed8268df1b69584167a14d4c690aaea35.zip>
- License: [ISC](https://github.com/jifunks/botany/blob/2802121ed8268df1b69584167a14d4c690aaea35/LICENSE)
- Reviewed inventory: 72 `.ansi` files and 74 related art assets
- Current import: 17 mature stage-three plants

botany is a terminal plant-growing application with compact ANSI plant artwork. All 72 ANSI files fit within 120 columns by 50 rows and rendered cleanly. The import selects 17 visually distinct mature plants; the other 55 are primarily growth/death/mutation stages or redundant variants and remain available for later curation. These files are already sequential ANSI streams, so conversion preserves their original SGR sequences and CRLF geometry in passthrough mode instead of flattening them through the terminal emulator.

### os-ansi

- Canonical repository: <https://codeberg.org/NNB/os-ansi>
- Pinned canonical archive: <https://codeberg.org/NNB/os-ansi/archive/64449ace20798a2149eeb527e5cd16428f0b45e5.zip>
- GitHub mirror: <https://github.com/info-mono/os-ansi>
- Pinned mirror tree: <https://github.com/info-mono/os-ansi/tree/64449ace20798a2149eeb527e5cd16428f0b45e5>
- Major upstream art credit: [jschx/ufetch](https://gitlab.com/jschx/ufetch)
- License: [ISC](https://github.com/info-mono/os-ansi/blob/64449ace20798a2149eeb527e5cd16428f0b45e5/LICENSE)
- Reviewed inventory: 36 operating-system logo streams
- Current import: 8 files

This collection focuses on operating-system logo ANSI art. Eight logos that added clear catalog value were imported; the other 28 were deferred because they duplicate or closely match existing scripts, carry little identifying detail, or need more curation. The files are positioned ANSI streams whose line-feed behavior is significant, so they use a passthrough conversion path instead of terminal-emulator reconstruction. The provenance record retains both the collection source and its upstream credit where applicable.

### Roy/SAC ANSI gallery

- Gallery: <https://www.roysac.com/roy_ansishow.html>
- Downloadable archive: <https://www.roysac.com/images/galleries/ZIP/Roy_ANSI.ZIP>
- Public-domain statement: <https://www.roysac.com/blog/2006/07/important-decision-made-regarding-my-text-art/>
- Follow-up licensing discussion: <https://www.roysac.com/blog/2008/08/copyleft-vs-public-domain/>
- Reviewed archive SHA-256: `8598a9432b4feb86c4e79552795b407b9d7c576fb6f25e9828d6143f1c7b35bc`
- Reviewed inventory: 183 `.ANS` files and 2 `.BIN` files
- Current import: 5 Roy-authored works selected from 183 reviewed

This is traditional CP437/SAUCE BBS-scene artwork. Five pieces were imported after bounded terminal rendering and duplicate checks; 31 pieces exceed the current 50-row curation limit, while 147 usable BBS/logo pieces remain candidates for selective review. Only Roy-authored works covered by Roy's public-domain statements were imported. The separate Roy/SAC gallery containing work by other artists is not treated as licensed by those statements and is intentionally excluded.

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

### Asciiville

- Repository: <https://github.com/doctorfree/Asciiville>
- Reviewed art tree: <https://github.com/doctorfree/Asciiville/tree/49f6289d511033b8ded1bd8d38f60c4bc5fd0301/art>
- Pinned archive: <https://github.com/doctorfree/Asciiville/archive/49f6289d511033b8ded1bd8d38f60c4bc5fd0301.zip>
- Project license: [MIT](https://github.com/doctorfree/Asciiville/blob/49f6289d511033b8ded1bd8d38f60c4bc5fd0301/LICENSE)
- Artwork licensing guidance: [ASCII Art Online](https://github.com/doctorfree/Asciiville/blob/49f6289d511033b8ded1bd8d38f60c4bc5fd0301/README.md#ascii-art-online)
- Reviewed inventory: 946 `.asc` files under `art/`

Asciiville is a rich browsing source, but the repository's MIT software license is not a blanket license for every artwork. Its own guidance says individual galleries include separate restrictions, including noncommercial and use-related terms. Imports therefore require a per-gallery and, where necessary, per-file rights map before conversion.

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
