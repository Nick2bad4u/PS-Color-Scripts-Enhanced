#!/usr/bin/env node
"use strict";
// @ts-check

const fs = require("node:fs");
const path = require("node:path");
const iconv = require("iconv-lite");
const { DEFAULT_PROVENANCE_PATH } = require("./ArtworkProvenance.js");
const {
    buildGeneratedArtworkEntry,
    prepareGeneratedArtworkProvenance,
    readGeneratedArtworkTemplate,
    writeGeneratedArtworkTransaction,
} = require("./GeneratedArtworkProvenance.js");
const {
    readAnsiFile,
    convertAnsiToPs1,
    sanitizeName,
    validateSourceMetadataValue,
    validateSourceUrl,
    buildSourceMetadataHeader,
    buildPowerShellOutput,
    writePowerShellFile,
    usesDosAnsiSemantics,
    MAX_INPUT_BYTES,
    MAX_TERMINAL_COLUMNS,
} = require("./Convert-AnsiToColorScript.js");

const DEFAULT_OUTPUT_DIR = path.join(
    __dirname,
    "..",
    "ColorScripts-Enhanced",
    "Scripts"
);

/**
 * @typedef {Object} SplitOptions
 *
 * @property {string} outputDir
 * @property {string | null} outputBase
 * @property {number | null} columns
 * @property {ColumnRange[]} columnRanges
 * @property {number[]} heights
 * @property {number[]} breaks
 * @property {boolean} autoDetect
 * @property {number} gap
 * @property {number} minSegment
 * @property {"ps1" | "ansi"} format
 * @property {boolean} dryRun
 * @property {boolean} stripSpaceBackground
 * @property {"auto" | "ansi" | "ps1"} inputFormat
 * @property {number | null} segmentEvery
 * @property {"cp437" | "utf8" | null} encoding
 * @property {boolean} force
 * @property {string} provenancePath
 * @property {string | null} provenanceRecordPath
 * @property {{
 *     url: string | null;
 *     revision: string | null;
 *     sha256: string | null;
 *     license: string | null;
 *     attribution: string | null;
 *     modification: string | null;
 * }} sourceProvenance
 */

/**
 * @typedef {Object} ColumnRange
 *
 * @property {number} start Zero-based inclusive start column.
 * @property {number} end Zero-based inclusive end column.
 */

/**
 * @typedef {Object} Chunk
 *
 * @property {number} start
 * @property {number} end
 * @property {string[]} lines
 */

/**
 * @param {string} value
 *
 * @returns {number[]}
 */
function parseNumberList(value) {
    if (!value) {
        return [];
    }
    return value
        .split(",")
        .map((token) => Number.parseInt(token.trim(), 10))
        .filter((num) => !Number.isNaN(num) && num > 0);
}

/**
 * Parse one-based inclusive column ranges and reject ambiguous or overlapping
 * panel definitions.
 *
 * @param {string} value
 *
 * @returns {ColumnRange[]}
 */
function parseColumnRanges(value) {
    if (!value) {
        throw new Error("Column ranges cannot be empty.");
    }

    const ranges = value.split(",").map((token) => {
        const match = /^(\d+)-(\d+)$/u.exec(token.trim());
        if (!match) {
            throw new Error(
                `Invalid column range '${token}'. Use one-based inclusive ranges such as 1-80,81-160.`
            );
        }
        const start = Number.parseInt(match[1], 10);
        const end = Number.parseInt(match[2], 10);
        if (
            !Number.isSafeInteger(start) ||
            !Number.isSafeInteger(end) ||
            start < 1 ||
            end < start ||
            end > MAX_TERMINAL_COLUMNS
        ) {
            throw new RangeError(
                `Column ranges must be within 1-${MAX_TERMINAL_COLUMNS}, with each start no greater than its end.`
            );
        }
        return { start: start - 1, end: end - 1 };
    });

    ranges.forEach((range, index) => {
        const previous = ranges[index - 1];
        if (previous && range.start <= previous.end) {
            throw new Error(
                "Column ranges must be ordered and must not overlap."
            );
        }
    });
    return ranges;
}

/**
 * @param {string[]} argv
 *
 * @returns {{ options: SplitOptions; positional: string[] }}
 */
function parseArguments(argv) {
    /** @type {SplitOptions} */
    const options = {
        outputDir: DEFAULT_OUTPUT_DIR,
        outputBase: null,
        columns: null,
        columnRanges: [],
        heights: [],
        breaks: [],
        autoDetect: false,
        gap: 4,
        minSegment: 60,
        format: "ps1",
        dryRun: false,
        stripSpaceBackground: false,
        inputFormat: "auto",
        segmentEvery: null,
        encoding: null,
        force: false,
        provenancePath: DEFAULT_PROVENANCE_PATH,
        provenanceRecordPath: null,
        sourceProvenance: {
            url: null,
            revision: null,
            sha256: null,
            license: null,
            attribution: null,
            modification: null,
        },
    };
    /** @type {string[]} */
    const positional = [];

    let optionsEnded = false;
    argv.forEach((arg) => {
        if (!optionsEnded && arg === "--") {
            optionsEnded = true;
            return;
        }
        if (optionsEnded) {
            positional.push(arg);
            return;
        }
        if (arg.startsWith("--output-dir=")) {
            options.outputDir = path.resolve(arg.split("=")[1]);
        } else if (arg.startsWith("--output-base=")) {
            const outputBase = sanitizeName(arg.slice("--output-base=".length));
            if (!outputBase) {
                throw new Error(
                    "Output base must contain at least one safe filename character."
                );
            }
            options.outputBase = outputBase;
        } else if (arg.startsWith("--columns=")) {
            const value = Number.parseInt(arg.split("=")[1], 10);
            if (!Number.isNaN(value) && value > 0) {
                options.columns = value;
            }
        } else if (arg.startsWith("--column-ranges=")) {
            options.columnRanges = parseColumnRanges(
                arg.slice("--column-ranges=".length)
            );
        } else if (arg.startsWith("--heights=")) {
            options.heights = parseNumberList(arg.split("=")[1]);
        } else if (arg.startsWith("--breaks=")) {
            options.breaks = parseNumberList(arg.split("=")[1]);
        } else if (arg === "--auto") {
            options.autoDetect = true;
        } else if (arg.startsWith("--gap=")) {
            const value = Number.parseInt(arg.split("=")[1], 10);
            if (!Number.isNaN(value) && value > 0) {
                options.gap = value;
            }
        } else if (arg.startsWith("--min-segment=")) {
            const value = Number.parseInt(arg.split("=")[1], 10);
            if (!Number.isNaN(value) && value > 0) {
                options.minSegment = value;
            }
        } else if (arg.startsWith("--every=")) {
            const value = Number.parseInt(arg.split("=")[1], 10);
            if (!Number.isNaN(value) && value > 0) {
                options.segmentEvery = value;
            }
        } else if (arg === "--format=ps1" || arg === "--ps1") {
            options.format = "ps1";
        } else if (arg === "--format=ansi" || arg === "--ansi") {
            options.format = "ansi";
        } else if (arg === "--input=ps1" || arg === "--from-ps1") {
            options.inputFormat = "ps1";
        } else if (arg === "--input=ansi") {
            options.inputFormat = "ansi";
        } else if (arg === "--encoding=cp437" || arg === "--encoding=437") {
            options.encoding = "cp437";
        } else if (
            arg === "--encoding=utf8" ||
            arg === "--encoding=utf-8" ||
            arg === "--utf8"
        ) {
            options.encoding = "utf8";
        } else if (arg === "--dry-run") {
            options.dryRun = true;
        } else if (
            arg === "--strip-space-bg" ||
            arg === "--strip-space-background"
        ) {
            options.stripSpaceBackground = true;
        } else if (arg === "--keep-space-bg") {
            options.stripSpaceBackground = false;
        } else if (arg === "--force") {
            options.force = true;
        } else if (arg.startsWith("--provenance-record=")) {
            options.provenanceRecordPath = path.resolve(
                arg.slice("--provenance-record=".length)
            );
        } else if (arg.startsWith("--provenance-path=")) {
            options.provenancePath = path.resolve(
                arg.slice("--provenance-path=".length)
            );
        } else if (arg.startsWith("--source-url=")) {
            options.sourceProvenance.url = validateSourceUrl(
                arg.slice("--source-url=".length)
            );
        } else if (arg.startsWith("--source-revision=")) {
            options.sourceProvenance.revision = validateSourceMetadataValue(
                arg.slice("--source-revision=".length),
                "Source revision",
                256
            );
        } else if (arg.startsWith("--source-sha256=")) {
            const value = arg.slice("--source-sha256=".length);
            if (!/^[a-f\d]{64}$/iu.test(value)) {
                throw new Error(
                    "Source SHA-256 must contain exactly 64 hexadecimal characters."
                );
            }
            options.sourceProvenance.sha256 = value.toLowerCase();
        } else if (arg.startsWith("--source-license=")) {
            options.sourceProvenance.license = validateSourceMetadataValue(
                arg.slice("--source-license=".length),
                "Source license",
                256
            );
        } else if (arg.startsWith("--source-attribution=")) {
            options.sourceProvenance.attribution = validateSourceMetadataValue(
                arg.slice("--source-attribution=".length),
                "Source attribution",
                1024
            );
        } else if (arg.startsWith("--source-modification=")) {
            options.sourceProvenance.modification = validateSourceMetadataValue(
                arg.slice("--source-modification=".length),
                "Source modification",
                1024
            );
        } else if (arg.startsWith("--")) {
            throw new Error(`Unknown option: ${arg}`);
        } else {
            positional.push(arg);
        }
    });

    return { options, positional };
}

/**
 * @param {string} filePath
 *
 * @returns {string[]}
 */
function extractLinesFromPs1(filePath) {
    if (fs.statSync(filePath).size > MAX_INPUT_BYTES) {
        throw new RangeError(
            `PowerShell input exceeds the ${MAX_INPUT_BYTES}-byte safety limit.`
        );
    }
    const text = fs.readFileSync(filePath, "utf8");
    const safeLiteralPattern = /Write-Host\s+'((?:[^']|'')*)'/m;
    const safeLiteralMatch = safeLiteralPattern.exec(text);
    if (safeLiteralMatch) {
        return safeLiteralMatch[1]
            .replaceAll("''", "'")
            .replaceAll(/\r\n?/g, "\n")
            .split("\n");
    }

    const safeHereStringPattern = /Write-Host\s+@'\r?\n([\s\S]*?)\r?\n'@/m;
    const safeHereStringMatch = safeHereStringPattern.exec(text);
    if (safeHereStringMatch) {
        return safeHereStringMatch[1].replaceAll(/\r\n?/g, "\n").split("\n");
    }

    // Continue to accept colorscripts generated by older releases.
    const legacyHereStringPattern = /Write-Host\s+@"\r?\n([\s\S]*?)\r?\n"@/m;
    const legacyMatch = legacyHereStringPattern.exec(text);
    if (legacyMatch) {
        return legacyMatch[1].replaceAll(/\r\n?/g, "\n").split("\n");
    }

    throw new Error(
        `Unable to locate a supported Write-Host literal in ${filePath}.`
    );
}

/**
 * @param {number} totalLines
 * @param {SplitOptions} options
 * @param {string[]} lines
 *
 * @returns {number[]}
 */
function determineBreaks(totalLines, options, lines) {
    const breaks = new Set();

    addHeightBreaks(breaks, options.heights, totalLines);
    for (const value of options.breaks) {
        if (value > 0 && value < totalLines) breaks.add(value);
    }
    addPeriodicBreaks(breaks, options.segmentEvery, totalLines);
    if (options.autoDetect && Array.isArray(lines)) {
        addDetectedBlankBreaks(breaks, lines, totalLines, options);
    }

    return [...breaks].sort((a, b) => a - b);
}

/**
 * @param {Set<number>} breaks
 * @param {number[]} heights
 * @param {number} totalLines
 */
function addHeightBreaks(breaks, heights, totalLines) {
    let accumulated = 0;
    for (const segmentHeight of heights) {
        accumulated += segmentHeight;
        if (accumulated > 0 && accumulated < totalLines) {
            breaks.add(accumulated);
        }
    }
}

/**
 * @param {Set<number>} breaks
 * @param {number | null} interval
 * @param {number} totalLines
 */
function addPeriodicBreaks(breaks, interval, totalLines) {
    if (!interval || interval < 1) return;
    for (let position = interval; position < totalLines; position += interval) {
        breaks.add(position);
    }
}

/**
 * @param {Set<number>} breaks
 * @param {string[]} lines
 * @param {number} totalLines
 * @param {SplitOptions} options
 */
function addDetectedBlankBreaks(breaks, lines, totalLines, options) {
    let runLength = 0;
    for (let index = 0; index < lines.length; index += 1) {
        const isBlank = (lines[index] || "").trim().length === 0;
        if (isBlank) {
            runLength += 1;
            continue;
        }
        const isUsableBoundary =
            runLength >= options.gap &&
            index >= options.minSegment &&
            index < totalLines - options.minSegment;
        if (isUsableBoundary) breaks.add(index);
        runLength = 0;
    }
}

/**
 * Choose the minimum number of row breaks needed to keep every part within the
 * requested height. The optimizer considers the full work at once, preventing a
 * locally attractive blank-row cut from leaving a tiny final part.
 *
 * Preferred breakpoints are normally the rows immediately after visible blank
 * rows or reviewed compositional transitions. They receive a bounded scoring
 * preference, but balance and the hard maximum remain authoritative.
 *
 * @param {number} totalLines
 * @param {number} [maxRows]
 * @param {number[]} [preferredBreakpoints]
 *
 * @returns {number[]}
 */
function chooseBalancedBreaks(
    totalLines,
    maxRows = 50,
    preferredBreakpoints = []
) {
    if (
        !Number.isSafeInteger(totalLines) ||
        !Number.isSafeInteger(maxRows) ||
        totalLines < 1 ||
        maxRows < 1
    ) {
        throw new RangeError(
            "Balanced splitting requires positive safe-integer row counts."
        );
    }
    if (!Array.isArray(preferredBreakpoints)) {
        throw new TypeError("Preferred breakpoints must be an array.");
    }
    const preferred = new Set();
    for (const breakpoint of preferredBreakpoints) {
        if (
            !Number.isSafeInteger(breakpoint) ||
            breakpoint < 1 ||
            breakpoint >= totalLines
        ) {
            throw new RangeError(
                "Preferred breakpoints must be safe integers within the artwork."
            );
        }
        preferred.add(breakpoint);
    }

    const partCount = Math.ceil(totalLines / maxRows);
    if (partCount === 1) {
        return [];
    }

    const targetRows = totalLines / partCount;
    const minimumRows = Math.max(1, Math.floor(targetRows * 0.6));
    const nonPreferredPenalty = totalLines ** 2;

    /** @type {Map<number, { cost: number; breaks: number[] }>} */
    let states = new Map([[0, { cost: 0, breaks: [] }]]);
    for (let segment = 1; segment <= partCount; segment += 1) {
        const remainingSegments = partCount - segment;
        /** @type {Map<number, { cost: number; breaks: number[] }>} */
        const nextStates = new Map();

        for (const [previousEnd, state] of states) {
            const minimumLength = Math.max(
                minimumRows,
                totalLines - previousEnd - remainingSegments * maxRows
            );
            const maximumLength = Math.min(
                maxRows,
                totalLines - previousEnd - remainingSegments * minimumRows
            );

            for (
                let length = minimumLength;
                length <= maximumLength;
                length += 1
            ) {
                const end = previousEnd + length;
                const isFinal = remainingSegments === 0;
                if (
                    (isFinal && end !== totalLines) ||
                    (!isFinal && end >= totalLines)
                ) {
                    continue;
                }

                const scaledDeviation = length * partCount - totalLines;
                const cost =
                    state.cost +
                    8 * scaledDeviation ** 2 +
                    (isFinal || preferred.has(end) ? 0 : nonPreferredPenalty);
                const breaks = isFinal ? state.breaks : [...state.breaks, end];
                const existing = nextStates.get(end);
                if (
                    !existing ||
                    cost < existing.cost ||
                    (cost === existing.cost && winsTie(breaks, existing.breaks))
                ) {
                    nextStates.set(end, { cost, breaks });
                }
            }
        }
        states = nextStates;
    }

    const result = states.get(totalLines);
    if (!result) {
        throw new Error(
            "Unable to produce a balanced split within the requested row limit."
        );
    }
    return result.breaks;
}

/**
 * Prefer larger earlier segments when two complete plans have exactly the same
 * score. This matches the conventional even split where remainder rows are
 * assigned from the first part onward.
 *
 * @param {number[]} candidate
 * @param {number[]} current
 *
 * @returns {boolean}
 */
function winsTie(candidate, current) {
    for (let index = 0; index < candidate.length; index += 1) {
        if (candidate[index] !== current[index]) {
            return candidate[index] > current[index];
        }
    }
    return false;
}

/**
 * @param {string[]} lines
 * @param {number[]} breakpoints
 *
 * @returns {Chunk[]}
 */
function splitLines(lines, breakpoints) {
    /** @type {Chunk[]} */
    const chunks = [];
    let start = 0;
    const sortedBreaks = [...breakpoints, lines.length];

    sortedBreaks.forEach((end) => {
        if (end <= start) {
            return;
        }
        const slice = lines.slice(start, end);
        chunks.push({ start, end, lines: slice });
        start = end;
    });

    return chunks;
}

/**
 * @param {string} content
 *
 * @returns {string}
 */
function ensureTrailingReset(content) {
    if (content.trimEnd().endsWith("\u001b[0m")) {
        return content;
    }
    let bodyEnd = content.length;
    while (bodyEnd > 0 && content[bodyEnd - 1] === "\n") {
        bodyEnd -= 1;
        if (bodyEnd > 0 && content[bodyEnd - 1] === "\r") {
            bodyEnd -= 1;
        }
    }
    const trailingLineBreaks = content.slice(bodyEnd);
    const body = trailingLineBreaks ? content.slice(0, bodyEnd) : content;
    return `${body}\u001b[0m${trailingLineBreaks}`;
}

/**
 * @param {Chunk} chunk
 * @param {{
 *     sourceName: string;
 *     sourceEncoding?: string;
 *     sauce?: object | null;
 *     sourceProvenance?: {
 *         url?: string | null;
 *         revision?: string | null;
 *         sha256?: string | null;
 *         license?: string | null;
 *         attribution?: string | null;
 *         modification?: string | null;
 *     };
 *     sourceColumns?: string | null;
 *     compactHeader?: string | null;
 * }} baseInfo
 *
 * @returns {string}
 */
function buildChunkPs1(chunk, baseInfo) {
    const joined = chunk.lines.join("\n");
    const normalized = ensureTrailingReset(joined);
    if (baseInfo.compactHeader) {
        return `${baseInfo.compactHeader}\n\n${buildPowerShellOutput(normalized, { startOnNewLine: true })}`;
    }
    const header = [
        buildSourceMetadataHeader(
            baseInfo.sourceName,
            baseInfo.sourceEncoding || "unknown",
            baseInfo.sauce || null,
            baseInfo.sourceProvenance || {}
        ).trimEnd(),
        `# Lines: ${chunk.start + 1}-${chunk.end}`,
    ].join("\n");
    const coordinateHeader = baseInfo.sourceColumns
        ? `${header}\n# Columns: ${baseInfo.sourceColumns}`
        : header;
    return `${coordinateHeader}\n\n${buildPowerShellOutput(normalized, { startOnNewLine: true })}`;
}

/**
 * @param {string} outputPath
 * @param {Chunk} chunk
 * @param {{
 *     sourceName: string;
 *     sourceEncoding?: string;
 *     sauce?: object | null;
 *     sourceProvenance?: {
 *         url?: string | null;
 *         revision?: string | null;
 *         sha256?: string | null;
 *         license?: string | null;
 *         attribution?: string | null;
 *         modification?: string | null;
 *     };
 *     sourceColumns?: string | null;
 *     compactHeader?: string | null;
 * }} baseInfo
 *
 * @returns {void}
 */
function writeChunkPs1(outputPath, chunk, baseInfo) {
    writePowerShellFile(outputPath, buildChunkPs1(chunk, baseInfo));
}

/**
 * @param {string} outputPath
 * @param {Chunk} chunk
 *
 * @returns {void}
 */
function writeChunkAnsi(outputPath, chunk, encoding = "utf8") {
    const joined = chunk.lines.join("\n");
    const normalized = ensureTrailingReset(joined);
    if (encoding === "cp437") {
        fs.writeFileSync(outputPath, iconv.encode(normalized, "cp437"));
    } else {
        fs.writeFileSync(outputPath, normalized, "utf8");
    }
}

/**
 * @param {string} baseName
 * @param {number} index
 * @param {string} extension
 *
 * @returns {string}
 */
function formatChunkName(baseName, index, extension) {
    const suffix = String(index + 1).padStart(2, "0");
    return `${baseName}-part${suffix}.${extension}`;
}

/**
 * @param {string} baseName
 * @param {number} panelIndex
 * @param {number} partIndex
 * @param {number} partCount
 * @param {string} extension
 *
 * @returns {string}
 */
function formatPanelChunkName(
    baseName,
    panelIndex,
    partIndex,
    partCount,
    extension
) {
    const panelSuffix = String(panelIndex + 1).padStart(2, "0");
    if (partCount === 1) {
        return `${baseName}-panel${panelSuffix}.${extension}`;
    }
    const partSuffix = String(partIndex + 1).padStart(2, "0");
    return `${baseName}-panel${panelSuffix}-part${partSuffix}.${extension}`;
}

/**
 * @param {Chunk[]} chunks
 *
 * @returns {string[]}
 */
function describeChunks(chunks) {
    return chunks.map(
        (chunk, index) =>
            `  [${String(index + 1).padStart(2, "0")}] rows ${chunk.start + 1}–${chunk.end} (${chunk.end - chunk.start})`
    );
}

/**
 * @param {string[]} [argv]
 *
 * @returns {void}
 */
function main(argv = process.argv.slice(2)) {
    const { options, positional } = parseArguments(argv);
    if (positional.length === 0) {
        console.error(
            "Usage: node scripts/Split-AnsiFile.js [options] <ansi-file>"
        );
        console.error("Options:");
        console.error(
            "  --output-dir=<path>        Where to place the generated files (default: module scripts dir)"
        );
        console.error(
            "  --output-base=<name>       Override the generated part filename prefix"
        );
        console.error(
            "  --format=ps1|ansi          Output format (default: ps1)"
        );
        console.error(
            "  --columns=<n>              Override SAUCE column width (ANSI input only)"
        );
        console.error(
            "  --column-ranges=1-80,...   Emit logical panels from one-based inclusive cell ranges (ANSI input only)"
        );
        console.error(
            "  --strip-space-bg           Clear background color on plain spaces (ANSI input only)"
        );
        console.error(
            "  --heights=h1,h2,...        Segment heights (cumulative)"
        );
        console.error(
            "  --every=<n>                Split after every <n> lines"
        );
        console.error(
            "  --breaks=b1,b2,...         Absolute row breakpoints (1-based)"
        );
        console.error(
            "  --auto                     Enable automatic break detection"
        );
        console.error(
            "  --gap=<n>                  Consecutive blank lines to trigger auto break (default: 4)"
        );
        console.error(
            "  --min-segment=<n>          Minimum lines before/after auto break (default: 60)"
        );
        console.error(
            "  --input=ansi|ps1           Force input interpretation (default: auto)"
        );
        console.error(
            "  --encoding=cp437|utf8      Input and ANSI-output encoding (default: cp437 for ANSI input, utf8 for PS1 input)"
        );
        console.error(
            "  --dry-run                  Report planned splits without writing files"
        );
        console.error(
            "  --force                    Replace existing output files"
        );
        console.error(
            "  --source-url=<url>         Embed the original artwork URL in each part"
        );
        console.error(
            "  --source-revision=<id>     Embed the source revision or archive identifier"
        );
        console.error(
            "  --source-sha256=<hash>     Embed the original artwork SHA-256"
        );
        console.error(
            "  --source-license=<id>      Embed the source license identifier"
        );
        console.error(
            "  --source-attribution=<text> Embed source attribution in each part"
        );
        console.error(
            "  --source-modification=<text> Describe source modifications in each part"
        );
        console.error(
            "  --provenance-record=<json> Emit compact headers and upsert complete external records"
        );
        console.error(
            "  --provenance-path=<psd1>   Override the authoritative provenance data file"
        );
        process.exit(1);
    }

    const ansiPath = path.resolve(positional[0]);
    if (!fs.existsSync(ansiPath)) {
        console.error(`Input file not found: ${ansiPath}`);
        process.exit(1);
    }

    const ext = path.extname(ansiPath).toLowerCase();
    let inputFormat = options.inputFormat;
    if (inputFormat === "auto") {
        inputFormat = ext === ".ps1" ? "ps1" : "ansi";
    }
    const provenanceTemplate = options.provenanceRecordPath
        ? readGeneratedArtworkTemplate(options.provenanceRecordPath)
        : null;
    if (provenanceTemplate) {
        if (inputFormat !== "ansi" || options.format !== "ps1") {
            throw new Error(
                "--provenance-record requires ANSI/ICE input and PowerShell output."
            );
        }
        if (
            Object.values(options.sourceProvenance).some(
                (value) => value !== null
            )
        ) {
            throw new Error(
                "--provenance-record cannot be combined with legacy --source-* header options. Put those values in the JSON record."
            );
        }
    }

    /** @type {string[][]} */
    let panels;
    let sauce = null;
    let fullSourceColumns = null;
    const sourceEncoding =
        options.encoding || (inputFormat === "ansi" ? "cp437" : "utf8");

    if (inputFormat === "ps1") {
        if (options.columnRanges.length > 0) {
            throw new Error(
                "--column-ranges requires ANSI or ICE input so panels can be sliced from terminal cells."
            );
        }
        if (options.stripSpaceBackground) {
            console.warn(
                "Warning: --strip-space-bg has no effect when splitting a PowerShell script input."
            );
        }
        panels = [extractLinesFromPs1(ansiPath)];
    } else {
        const ansiFile = readAnsiFile(ansiPath, sourceEncoding);
        const content = ansiFile.content;
        sauce = ansiFile.sauce;
        const columns = options.columns || sauce?.tInfo1 || null;
        fullSourceColumns = columns || 80;

        const terminalOptions = {
            columns: columns || undefined,
            stripSpaceBackground: options.stripSpaceBackground,
            iceColors: Boolean(sauce?.flags & 1),
            dosAnsi: usesDosAnsiSemantics(sourceEncoding),
        };

        const converted = convertAnsiToPs1(content, terminalOptions);
        if (options.columnRanges.length > 0) {
            converted.terminal.recalculateBounds();
            if (
                options.columnRanges.at(-1).end >
                Math.max(
                    converted.terminal.maxCol,
                    converted.terminal.columns - 1
                )
            ) {
                throw new RangeError(
                    "A requested column range extends beyond the declared or rendered terminal width."
                );
            }
            panels = options.columnRanges.map((range) =>
                converted.terminal.buildLines(range)
            );
        } else {
            panels = [converted.lines];
        }
    }

    const panelChunks = panels.map((panelLines, panelIndex) => {
        const breakpoints = determineBreaks(
            panelLines.length,
            options,
            panelLines
        );
        return {
            panelIndex,
            range: options.columnRanges[panelIndex] || null,
            chunks: splitLines(panelLines, breakpoints),
        };
    });
    const chunks = panelChunks.flatMap((panel) => panel.chunks);

    if (chunks.length === 0) {
        console.error("No content generated.");
        process.exit(1);
    }

    const baseName =
        options.outputBase ||
        sanitizeName(path.basename(ansiPath, path.extname(ansiPath)));
    if (!baseName) {
        throw new Error(
            `Input filename cannot form a safe colorscript name: ${path.basename(ansiPath)}`
        );
    }
    const outputDir = path.resolve(options.outputDir);

    console.log(`Input file : ${ansiPath}`);
    console.log(`Input mode : ${inputFormat.toUpperCase()}`);
    console.log(`Total lines: ${panels[0].length}`);
    panelChunks.forEach((panel) => {
        if (panel.range) {
            console.log(
                `Panel ${panel.panelIndex + 1}: columns ${panel.range.start + 1}-${panel.range.end + 1}`
            );
        } else {
            console.log("Chunks:");
        }
        describeChunks(panel.chunks).forEach((line) => console.log(line));
    });

    if (options.dryRun) {
        console.log("Dry run complete; no files written.");
        return;
    }

    const extension = options.format === "ansi" ? "ans" : "ps1";
    const outputs = panelChunks.flatMap((panel) =>
        panel.chunks.map((chunk, partIndex) => ({
            chunk,
            range: panel.range,
            outputPath: path.join(
                outputDir,
                panel.range
                    ? formatPanelChunkName(
                          baseName,
                          panel.panelIndex,
                          partIndex,
                          panel.chunks.length,
                          extension
                      )
                    : formatChunkName(baseName, partIndex, extension)
            ),
        }))
    );
    const outputPaths = outputs.map((output) => output.outputPath);
    if (!options.force) {
        const existingOutput = outputPaths.find((outputPath) =>
            fs.existsSync(outputPath)
        );
        if (existingOutput) {
            throw new Error(
                `Output file already exists: ${existingOutput}. Use --force to replace it.`
            );
        }
    }
    if (!fs.existsSync(outputDir)) {
        fs.mkdirSync(outputDir, { recursive: true });
    }

    if (provenanceTemplate) {
        const sourceBuffer = fs.readFileSync(ansiPath);
        const entries = new Map();
        for (const { chunk, range, outputPath } of outputs) {
            const scriptName = path.basename(outputPath, ".ps1");
            const sourceColumns = range
                ? `${range.start + 1}-${range.end + 1}`
                : `1-${fullSourceColumns || 80}`;
            entries.set(
                scriptName,
                buildGeneratedArtworkEntry({
                    conversionMode: "TerminalEmulation",
                    name: scriptName,
                    sauce,
                    sourceBuffer,
                    sourceColumns,
                    sourceEncoding,
                    sourceName: ansiPath,
                    sourceRows: `${chunk.start + 1}-${chunk.end}`,
                    template: provenanceTemplate,
                })
            );
        }
        const prepared = prepareGeneratedArtworkProvenance(
            options.provenancePath,
            entries
        );
        const scripts = new Map();
        for (const { chunk, range, outputPath } of outputs) {
            const scriptName = path.basename(outputPath, ".ps1");
            scripts.set(
                path.resolve(outputPath),
                buildChunkPs1(chunk, {
                    compactHeader: prepared.headers.get(scriptName),
                    sauce,
                    sourceColumns: range
                        ? `${range.start + 1}-${range.end + 1}`
                        : `1-${fullSourceColumns || 80}`,
                    sourceEncoding,
                    sourceName: path.basename(ansiPath),
                })
            );
        }
        writeGeneratedArtworkTransaction(
            options.provenancePath,
            prepared.provenanceSource,
            scripts
        );
    } else {
        outputs.forEach(({ chunk, range, outputPath }) => {
            if (options.format === "ansi") {
                writeChunkAnsi(outputPath, chunk, sourceEncoding);
            } else {
                let sourceColumns = null;
                if (range) {
                    sourceColumns = `${range.start + 1}-${range.end + 1}`;
                } else if (fullSourceColumns) {
                    sourceColumns = `1-${fullSourceColumns}`;
                }
                writeChunkPs1(outputPath, chunk, {
                    sourceName: path.basename(ansiPath),
                    sourceEncoding,
                    sauce,
                    sourceProvenance: options.sourceProvenance,
                    sourceColumns,
                });
            }
        });
    }
    outputs.forEach(({ outputPath }) => console.log(`  → ${outputPath}`));

    console.log("Split complete.");
}

if (require.main === module) {
    main();
}

module.exports = {
    parseArguments,
    parseColumnRanges,
    extractLinesFromPs1,
    determineBreaks,
    chooseBalancedBreaks,
    splitLines,
    ensureTrailingReset,
    buildChunkPs1,
    writeChunkPs1,
    writeChunkAnsi,
    formatPanelChunkName,
    main,
};
