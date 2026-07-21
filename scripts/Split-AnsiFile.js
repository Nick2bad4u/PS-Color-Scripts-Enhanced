#!/usr/bin/env node
"use strict";
// @ts-check

const fs = require("fs");
const path = require("path");
const iconv = require("iconv-lite");
const {
    readAnsiFile,
    convertAnsiToPs1,
    sanitizeName,
    buildSourceMetadataHeader,
    buildPowerShellOutput,
    writePowerShellFile,
    MAX_INPUT_BYTES,
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
 * @property {number | null} columns
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
        .map((token) => parseInt(token.trim(), 10))
        .filter((num) => !Number.isNaN(num) && num > 0);
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
        columns: null,
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
        } else if (arg.startsWith("--columns=")) {
            const value = parseInt(arg.split("=")[1], 10);
            if (!Number.isNaN(value) && value > 0) {
                options.columns = value;
            }
        } else if (arg.startsWith("--heights=")) {
            options.heights = parseNumberList(arg.split("=")[1]);
        } else if (arg.startsWith("--breaks=")) {
            options.breaks = parseNumberList(arg.split("=")[1]);
        } else if (arg === "--auto") {
            options.autoDetect = true;
        } else if (arg.startsWith("--gap=")) {
            const value = parseInt(arg.split("=")[1], 10);
            if (!Number.isNaN(value) && value > 0) {
                options.gap = value;
            }
        } else if (arg.startsWith("--min-segment=")) {
            const value = parseInt(arg.split("=")[1], 10);
            if (!Number.isNaN(value) && value > 0) {
                options.minSegment = value;
            }
        } else if (arg.startsWith("--every=")) {
            const value = parseInt(arg.split("=")[1], 10);
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
        } else if (
            arg === "--encoding=cp437" ||
            arg === "--encoding=437"
        ) {
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
            .replace(/''/g, "'")
            .replace(/\r\n?/g, "\n")
            .split("\n");
    }

    // Continue to accept colorscripts generated by older releases.
    const legacyHereStringPattern = /Write-Host\s+@"\r?\n([\s\S]*?)\r?\n"@/m;
    const legacyMatch = legacyHereStringPattern.exec(text);
    if (legacyMatch) {
        return legacyMatch[1].replace(/\r\n?/g, "\n").split("\n");
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

    let accumulated = 0;
    if (options.heights.length > 0) {
        options.heights.forEach((segmentHeight) => {
            accumulated += segmentHeight;
            if (accumulated > 0 && accumulated < totalLines) {
                breaks.add(accumulated);
            }
        });
    }

    options.breaks
        .filter((value) => value > 0 && value < totalLines)
        .forEach((value) => breaks.add(value));

    if (options.segmentEvery && options.segmentEvery > 0) {
        for (
            let position = options.segmentEvery;
            position < totalLines;
            position += options.segmentEvery
        ) {
            breaks.add(position);
        }
    }

    if (options.autoDetect && Array.isArray(lines)) {
        let runLength = 0;
        for (let index = 0; index < lines.length; index += 1) {
            const content = lines[index] || "";
            const isBlank = content.trim().length === 0;
            if (isBlank) {
                runLength += 1;
            } else {
                if (
                    runLength >= options.gap &&
                    index >= options.minSegment &&
                    index < totalLines - options.minSegment
                ) {
                    breaks.add(index);
                }
                runLength = 0;
            }
        }
    }

    const sorted = [...breaks].sort((a, b) => a - b);
    return sorted;
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
    const hasReset = /\x1b\[0m\s*$/.test(content);
    if (hasReset) {
        return content;
    }
    return `${content}${content.endsWith("\n") ? "" : "\n"}\u001b[0m`;
}

/**
 * @param {string} outputPath
 * @param {Chunk} chunk
 * @param {{ sourceName: string; sourceEncoding?: string; sauce?: object | null }} baseInfo
 *
 * @returns {void}
 */
function writeChunkPs1(outputPath, chunk, baseInfo) {
    const joined = chunk.lines.join("\n");
    const normalized = ensureTrailingReset(joined);
    const header = [
        buildSourceMetadataHeader(
            baseInfo.sourceName,
            baseInfo.sourceEncoding || "unknown",
            baseInfo.sauce || null
        ).trimEnd(),
        `# Lines: ${chunk.start + 1}-${chunk.end}`,
        `# Generated: ${new Date().toISOString()}`,
    ].join("\n");
    const body = `${header}\n\n${buildPowerShellOutput(normalized)}`;
    writePowerShellFile(outputPath, body);
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
            "  --format=ps1|ansi          Output format (default: ps1)"
        );
        console.error(
            "  --columns=<n>              Override SAUCE column width (ANSI input only)"
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

    /** @type {string[]} */
    let lines;
    let sauce = null;
    const sourceEncoding = options.encoding ||
        (inputFormat === "ansi" ? "cp437" : "utf8");

    if (inputFormat === "ps1") {
        if (options.stripSpaceBackground) {
            console.warn(
                "Warning: --strip-space-bg has no effect when splitting a PowerShell script input."
            );
        }
        lines = extractLinesFromPs1(ansiPath);
    } else {
        const ansiFile = readAnsiFile(ansiPath, sourceEncoding);
        const content = ansiFile.content;
        sauce = ansiFile.sauce;
        const columns =
            options.columns || (sauce && sauce.tInfo1 ? sauce.tInfo1 : null);

        const terminalOptions = {
            columns: columns || undefined,
            stripSpaceBackground: options.stripSpaceBackground,
            iceColors: Boolean(sauce && (sauce.flags & 1)),
        };

        const converted = convertAnsiToPs1(content, terminalOptions);
        lines = converted.lines;
    }

    const breakpoints = determineBreaks(lines.length, options, lines);
    const chunks = splitLines(lines, breakpoints);

    if (chunks.length === 0) {
        console.error("No content generated.");
        process.exit(1);
    }

    const baseName = sanitizeName(
        path.basename(ansiPath, path.extname(ansiPath))
    );
    if (!baseName) {
        throw new Error(
            `Input filename cannot form a safe colorscript name: ${path.basename(ansiPath)}`
        );
    }
    const outputDir = path.resolve(options.outputDir);

    console.log(`Input file : ${ansiPath}`);
    console.log(`Input mode : ${inputFormat.toUpperCase()}`);
    console.log(`Total lines: ${lines.length}`);
    console.log("Chunks:");
    describeChunks(chunks).forEach((line) => console.log(line));

    if (options.dryRun) {
        console.log("Dry run complete; no files written.");
        return;
    }

    const outputPaths = chunks.map((unusedChunk, index) => {
        const extension = options.format === "ansi" ? "ans" : "ps1";
        return path.join(
            outputDir,
            formatChunkName(baseName, index, extension)
        );
    });
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

    chunks.forEach((chunk, index) => {
        const outputPath = outputPaths[index];

        if (options.format === "ansi") {
            writeChunkAnsi(outputPath, chunk, sourceEncoding);
        } else {
            writeChunkPs1(outputPath, chunk, {
                sourceName: path.basename(ansiPath),
                sourceEncoding,
                sauce,
            });
        }
        console.log(`  → ${outputPath}`);
    });

    console.log("Split complete.");
}

if (require.main === module) {
    main();
}

module.exports = {
    parseArguments,
    extractLinesFromPs1,
    determineBreaks,
    splitLines,
    ensureTrailingReset,
    writeChunkPs1,
    writeChunkAnsi,
    main,
};
