#!/usr/bin/env node
"use strict";

const fs = require("node:fs");
const path = require("node:path");
const iconv = require("iconv-lite");
const AnsiParser = require("node-ansiparser");
const { DEFAULT_PROVENANCE_PATH } = require("./ArtworkProvenance.js");
const {
    buildGeneratedArtworkEntry,
    prepareGeneratedArtworkProvenance,
    readGeneratedArtworkTemplate,
    writeGeneratedArtworkTransaction,
} = require("./GeneratedArtworkProvenance.js");

const ESC = "\x1b";
const DEFAULT_COLUMNS = 80;
const MAX_INPUT_BYTES = 32 * 1024 * 1024;
// These limits sit above the largest checked-in ANSI asset (1450x4641) while
// preventing hostile cursor coordinates from driving billion-element loops.
const MAX_TERMINAL_COLUMNS = 2048;
const MAX_TERMINAL_ROWS = 8192;
const MAX_TERMINAL_CELLS = 2_000_000;
const MAX_CSI_PARAMETER = 10_000;
// iconv-lite deliberately preserves ASCII C0 controls when decoding CP437,
// but DOS text-mode art uses most of those byte values as visible glyphs.
// Keep only the bytes interpreted structurally by the ANSI renderer. This
// matches the official 16colors/Ansilove preview behavior while emitting safe
// Unicode instead of terminal control characters in generated scripts.
const CP437_C0_GLYPHS = [
    " ",
    "☺",
    "☻",
    "♥",
    "♦",
    "♣",
    "♠",
    "•",
    "◘",
    null, // HT
    null, // LF
    "♂",
    "♀",
    null, // CR
    "♫",
    "☼",
    "►",
    "◄",
    "↕",
    "‼",
    "¶",
    "§",
    "▬",
    "↨",
    "↑",
    "↓",
    "→",
    null, // ESC
    "∟",
    "↔",
    "▲",
    "▼",
];
const SAUCE_DOS_CODE_PAGES = new Set([
    "437",
    "720",
    "737",
    "775",
    "819",
    "850",
    "852",
    "855",
    "857",
    "858",
    "860",
    "861",
    "862",
    "863",
    "864",
    "865",
    "866",
    "869",
    "872",
    "KAM",
    "MAZ",
    "MIK",
]);

/**
 * @typedef {"basic" | "bright" | "palette" | "rgb"} ColorMode
 */

/**
 * @typedef {Object} ColorState
 *
 * @property {ColorMode} mode
 * @property {number} [value]
 * @property {number} [r]
 * @property {number} [g]
 * @property {number} [b]
 */

/**
 * @typedef {Object} CellAttributes
 *
 * @property {boolean} bold
 * @property {boolean} dim
 * @property {boolean} italic
 * @property {boolean} underline
 * @property {boolean} blink
 * @property {boolean} inverse
 * @property {boolean} hidden
 * @property {boolean} strike
 * @property {ColorState | null} fg
 * @property {ColorState | null} bg
 */

/**
 * @typedef {Object} Cell
 *
 * @property {string} char
 * @property {CellAttributes} attrs
 */

/**
 * @typedef {Object} TerminalRow
 *
 * @property {Map<number, Cell>} cells
 * @property {number} maxCol
 */

/**
 * @typedef {Object} TerminalOptions
 *
 * @property {number} [columns]
 * @property {boolean} [autoWrap]
 * @property {boolean} [stripSpaceBackground]
 * @property {number} [minimumRows] Explicit logical canvas floor. Do not infer
 *   this from SAUCE tInfo2, which may include unused trailing padding.
 * @property {number} [maxHeight]
 * @property {boolean} [iceColors]
 * @property {boolean} [dosAnsi] Match DOS ANSI-art/libansilove behavior for
 *   legacy color aliases, bare-LF line endings, and immediate right-margin
 *   wrapping.
 */

/**
 * @typedef {Object} SauceRecord
 *
 * @property {string} version
 * @property {string} title
 * @property {string} author
 * @property {string} group
 * @property {string} date
 * @property {number} fileSize
 * @property {number} dataType
 * @property {number} fileType
 * @property {number} tInfo1
 * @property {number} tInfo2
 * @property {number} tInfo3
 * @property {number} tInfo4
 * @property {number} comments
 * @property {number} flags
 * @property {Buffer} tInfoS
 * @property {string[]} commentLines
 */

/**
 * @typedef {Object} SourceProvenance
 *
 * @property {string | null} url
 * @property {string | null} revision
 * @property {string | null} sha256
 * @property {string | null} license
 * @property {string | null} attribution
 * @property {string | null} modification
 */

/**
 * @returns {CellAttributes}
 */
function createDefaultAttrs() {
    return {
        bold: false,
        dim: false,
        italic: false,
        underline: false,
        blink: false,
        inverse: false,
        hidden: false,
        strike: false,
        fg: null,
        bg: null,
    };
}

/**
 * @param {CellAttributes} attrs
 *
 * @returns {CellAttributes}
 */
function cloneAttrs(attrs) {
    return {
        bold: attrs.bold,
        dim: attrs.dim,
        italic: attrs.italic,
        underline: attrs.underline,
        blink: attrs.blink,
        inverse: attrs.inverse,
        hidden: attrs.hidden,
        strike: attrs.strike,
        fg: attrs.fg ? { ...attrs.fg } : null,
        bg: attrs.bg ? { ...attrs.bg } : null,
    };
}

const SGR_ATTRIBUTE_CHANGES = new Map([
    [1, { bold: true }],
    [2, { dim: true }],
    [3, { italic: true }],
    [4, { underline: true }],
    [7, { inverse: true }],
    [8, { hidden: true }],
    [9, { strike: true }],
    [22, { bold: false, dim: false }],
    [23, { italic: false }],
    [24, { underline: false }],
    [25, { blink: false }],
    [27, { inverse: false }],
    [28, { hidden: false }],
    [29, { strike: false }],
    [39, { fg: null }],
    [49, { bg: null }],
]);

/**
 * Decode single-byte DOS ANSI data without leaking graphic control-range bytes
 * into the Unicode output. TAB, LF, CR, and ESC retain their ANSI semantics;
 * the remaining C0 bytes and DEL use the glyphs displayed by IBM text fonts.
 *
 * @param {Buffer} buffer
 * @param {string} [encoding="cp437"] Default is `"cp437"`
 *
 * @returns {string}
 */
function decodeDosAnsi(buffer, encoding = "cp437") {
    if (!iconv.encodingExists(encoding)) {
        throw new RangeError(`Unsupported DOS text encoding: ${encoding}.`);
    }
    const decoded = iconv.decode(buffer, encoding);
    if (decoded.length !== buffer.length) {
        throw new Error(
            `DOS text encoding ${encoding} did not decode one character per source byte.`
        );
    }
    let output = "";
    for (let index = 0; index < buffer.length; index += 1) {
        const byte = buffer[index];
        if (byte === 0x7f) {
            output += "⌂";
        } else if (byte < CP437_C0_GLYPHS.length) {
            output += CP437_C0_GLYPHS[byte] ?? decoded[index];
        } else {
            output += decoded[index];
        }
    }
    return output;
}

/**
 * Decode CP437 ANSI data while preserving the DOS graphic-control glyphs.
 *
 * @param {Buffer} buffer
 *
 * @returns {string}
 */
function decodeCp437Ansi(buffer) {
    return decodeDosAnsi(buffer, "cp437");
}

/**
 * Determine whether an input encoding uses the archival DOS ANSI terminal
 * model. UTF-8 inputs target modern Unicode terminals; every supported
 * single-byte code page is decoded as DOS text and therefore needs the same
 * libansilove cursor, wrapping, and color behavior as CP437.
 *
 * @param {string} encoding
 *
 * @returns {boolean}
 */
function usesDosAnsiSemantics(encoding) {
    const normalizedEncoding = String(encoding).toLowerCase();
    return normalizedEncoding !== "utf8" && normalizedEncoding !== "utf-8";
}

/**
 * Truncate a DOS byte stream at its first SUB (0x1A) logical EOF marker.
 *
 * @param {Buffer} buffer
 *
 * @returns {Buffer}
 */
function truncateDosAnsiAtEof(buffer) {
    const eofOffset = buffer.indexOf(0x1a);
    return eofOffset === -1 ? buffer : buffer.subarray(0, eofOffset);
}

/**
 * Resolve a SAUCE ANSI font name to the DOS character encoding it declares. The
 * SAUCE specification defines an optional code-page suffix for the IBM EGA/VGA
 * font families. Unknown or malformed font strings are metadata, not evidence
 * of a different character set, so they retain the historical CP437 fallback. A
 * recognized but unavailable code page is reported as unsupported so archive
 * tooling can reject it instead of silently corrupting glyphs.
 *
 * @param {string | null | undefined} fontName
 *
 * @returns {{
 *     encoding: string;
 *     label: string;
 *     supported: boolean;
 *     explicit: boolean;
 *     codePage: string;
 * }}
 */
function resolveSauceEncoding(fontName) {
    const normalizedFont = String(fontName || "").trim();
    const match =
        /^IBM (?:VGA|VGA50|VGA25G|EGA|EGA43)(?: (\d{3}|KAM|MAZ|MIK))?$/iu.exec(
            normalizedFont
        );
    if (!match) {
        return {
            encoding: "cp437",
            label: "CP437",
            supported: true,
            explicit: false,
            codePage: "437",
        };
    }

    const codePage = (match[1] || "437").toUpperCase();
    const encoding = /^\d{3}$/u.test(codePage)
        ? `cp${codePage}`
        : codePage.toLowerCase();
    return {
        encoding,
        label: /^\d{3}$/u.test(codePage) ? `CP${codePage}` : codePage,
        supported:
            SAUCE_DOS_CODE_PAGES.has(codePage) &&
            iconv.encodingExists(encoding),
        explicit: Boolean(match[1]),
        codePage,
    };
}

/**
 * @param {ColorState | null} a
 * @param {ColorState | null} b
 *
 * @returns {boolean}
 */
function colorsEqual(a, b) {
    if (!a && !b) {
        return true;
    }
    if (!a || !b) {
        return false;
    }
    if (a.mode !== b.mode) {
        return false;
    }
    if (a.mode === "rgb") {
        return a.r === b.r && a.g === b.g && a.b === b.b;
    }
    return a.value === b.value;
}

/**
 * @param {CellAttributes} a
 * @param {CellAttributes} b
 *
 * @returns {boolean}
 */
function attrsEqual(a, b) {
    return (
        a.bold === b.bold &&
        a.dim === b.dim &&
        a.italic === b.italic &&
        a.underline === b.underline &&
        a.blink === b.blink &&
        a.inverse === b.inverse &&
        a.hidden === b.hidden &&
        a.strike === b.strike &&
        colorsEqual(a.fg, b.fg) &&
        colorsEqual(a.bg, b.bg)
    );
}

/**
 * @param {CellAttributes} attrs
 *
 * @returns {boolean}
 */
function isDefaultAttrs(attrs) {
    return attrsEqual(attrs, createDefaultAttrs());
}

/**
 * @param {boolean} isForeground
 *
 * @returns {{ base: number; bright: number; extended: number }}
 */
function getColorCodeBases(isForeground) {
    if (isForeground) return { base: 30, bright: 90, extended: 38 };
    return { base: 40, bright: 100, extended: 48 };
}

/**
 * @param {ColorState | null} color
 * @param {boolean} isForeground
 *
 * @returns {number[]}
 */
function colorToCodes(color, isForeground) {
    if (!color) return [];
    const bases = getColorCodeBases(isForeground);
    switch (color.mode) {
        case "basic":
            if (typeof color.value !== "number") return [];
            return [bases.base + color.value];
        case "bright":
            if (typeof color.value !== "number") return [];
            return [bases.bright + color.value];
        case "palette":
            if (typeof color.value !== "number") return [];
            return [
                bases.extended,
                5,
                color.value,
            ];
        case "rgb":
            if (typeof color.r !== "number") return [];
            if (typeof color.g !== "number") return [];
            if (typeof color.b !== "number") return [];
            return [
                bases.extended,
                2,
                color.r,
                color.g,
                color.b,
            ];
        default:
            return [];
    }
}

/**
 * @param {CellAttributes} attrs
 *
 * @returns {number[]}
 */
function serializeAttrs(attrs) {
    const codes = [];
    if (attrs.bold) codes.push(1);
    if (attrs.dim) codes.push(2);
    if (attrs.italic) codes.push(3);
    if (attrs.underline) codes.push(4);
    if (attrs.blink) codes.push(5);
    if (attrs.inverse) codes.push(7);
    if (attrs.hidden) codes.push(8);
    if (attrs.strike) codes.push(9);
    codes.push(
        ...colorToCodes(attrs.fg, true),
        ...colorToCodes(attrs.bg, false)
    );
    return codes;
}

/**
 * @param {CellAttributes} prev
 * @param {CellAttributes} next
 *
 * @returns {number[]}
 */
function diffAttrs(prev, next) {
    if (attrsEqual(prev, next)) {
        return [];
    }
    if (isDefaultAttrs(next)) {
        return [0];
    }
    if (isDefaultAttrs(prev)) {
        return serializeAttrs(next);
    }
    return [0, ...serializeAttrs(next)];
}

/**
 * Remove SAUCE field padding without deleting embedded null bytes from a
 * malformed-but-readable record.
 *
 * @param {string} value
 *
 * @returns {string}
 */
function trimTrailingNulls(value) {
    let end = value.length;
    while (end > 0 && value.codePointAt(end - 1) === 0) {
        end -= 1;
    }
    return value.slice(0, end);
}

/**
 * Normalize fixed-width SAUCE text fields. Some producers place a null byte
 * before their space padding, so whitespace must be removed before the final
 * trailing-null pass. Nulls embedded within meaningful text remain intact.
 *
 * @param {string} value
 *
 * @returns {string}
 */
function trimSauceTextField(value) {
    return trimTrailingNulls(value.trim()).trimEnd();
}

/**
 * @param {Buffer} buffer
 *
 * @returns {SauceRecord}
 */
function parseSauceRecord(buffer) {
    return {
        version: buffer.subarray(5, 7).toString("ascii"),
        title: trimSauceTextField(buffer.subarray(7, 42).toString("ascii")),
        author: trimSauceTextField(buffer.subarray(42, 62).toString("ascii")),
        group: trimSauceTextField(buffer.subarray(62, 82).toString("ascii")),
        date: buffer.subarray(82, 90).toString("ascii"),
        fileSize: buffer.readUInt32LE(90),
        dataType: buffer.readUInt8(94),
        fileType: buffer.readUInt8(95),
        tInfo1: buffer.readUInt16LE(96),
        tInfo2: buffer.readUInt16LE(98),
        tInfo3: buffer.readUInt16LE(100),
        tInfo4: buffer.readUInt16LE(102),
        comments: buffer.readUInt8(104),
        flags: buffer.readUInt8(105),
        tInfoS: buffer.subarray(106, 128),
        commentLines: [],
    };
}

/**
 * @param {Buffer} buffer
 * @param {number} offset
 *
 * @returns {number}
 */
function trimDosEofMarkers(buffer, offset) {
    let markerStart = offset;
    let foundMarker = false;
    while (markerStart > 0) {
        let markerEnd = markerStart;
        while (
            markerEnd > 0 &&
            (buffer[markerEnd - 1] === 0x0a || buffer[markerEnd - 1] === 0x0d)
        ) {
            markerEnd -= 1;
        }
        let nextMarkerStart = markerEnd;
        while (nextMarkerStart > 0 && buffer[nextMarkerStart - 1] === 0x1a) {
            nextMarkerStart -= 1;
        }
        if (nextMarkerStart === markerEnd) break;
        foundMarker = true;
        markerStart = nextMarkerStart;
    }
    return foundMarker ? markerStart : offset;
}

/**
 * @param {Buffer} buffer
 * @param {SauceRecord} sauce
 * @param {number} sauceOffset
 *
 * @returns {number}
 */
function readSauceComments(buffer, sauce, sauceOffset) {
    if (sauce.comments <= 0) return sauceOffset;
    const commentBlockLength = 5 + sauce.comments * 64;
    const commentOffset = sauceOffset - commentBlockLength;
    if (commentOffset < 0) return sauceOffset;
    const commentId = buffer
        .subarray(commentOffset, commentOffset + 5)
        .toString("ascii");
    if (commentId !== "COMNT") return sauceOffset;
    for (let index = 0; index < sauce.comments; index += 1) {
        const lineOffset = commentOffset + 5 + index * 64;
        const decodedComment = iconv.decode(
            buffer.subarray(lineOffset, lineOffset + 64),
            "cp437"
        );
        const commentLine = trimTrailingNulls(decodedComment).trimEnd();
        if (commentLine) sauce.commentLines.push(commentLine);
    }
    return commentOffset;
}

/**
 * @param {Buffer} buffer
 *
 * @returns {{ buffer: Buffer; sauce: SauceRecord | null }}
 */
function stripSauce(buffer) {
    const SAUCE_LENGTH = 128;
    const contentEnd = trimDosEofMarkers(buffer, buffer.length);
    const truncatedMarker = buffer.lastIndexOf(
        Buffer.from("\x1aSAUCE00", "binary")
    );
    if (
        truncatedMarker >= 0 &&
        buffer.length - truncatedMarker - 1 < SAUCE_LENGTH
    ) {
        // A few historical archives contain a visibly truncated SAUCE record.
        // It cannot be parsed safely, but the explicit DOS EOF + SAUCE00
        // framing is still metadata and must never leak into rendered art.
        return {
            buffer: buffer.subarray(
                0,
                trimDosEofMarkers(buffer, truncatedMarker)
            ),
            sauce: null,
        };
    }
    if (buffer.length < SAUCE_LENGTH) {
        return { buffer: buffer.subarray(0, contentEnd), sauce: null };
    }

    const sauceOffset = buffer.length - SAUCE_LENGTH;
    const sauceId = buffer
        .subarray(sauceOffset, sauceOffset + 5)
        .toString("ascii");
    if (sauceId !== "SAUCE") {
        return { buffer: buffer.subarray(0, contentEnd), sauce: null };
    }

    const sauceRecord = buffer.subarray(
        sauceOffset,
        sauceOffset + SAUCE_LENGTH
    );
    const sauce = parseSauceRecord(sauceRecord);

    let trimOffset = readSauceComments(buffer, sauce, sauceOffset);

    // A DOS 0x1A end-of-file marker commonly precedes COMNT/SAUCE metadata.
    // Remove only metadata-adjacent markers here. DOS stream truncation is
    // centralized separately so UTF-8 callers can retain interior SUB bytes.
    trimOffset = trimDosEofMarkers(buffer, trimOffset);

    return {
        buffer: buffer.subarray(0, trimOffset),
        sauce,
    };
}

class TerminalEmulator {
    /**
     * @param {TerminalOptions} [options]
     */
    constructor(options = {}) {
        const opts = options || {};
        const requestedColumns =
            typeof opts.columns === "number" ? opts.columns : DEFAULT_COLUMNS;
        if (
            !Number.isSafeInteger(requestedColumns) ||
            requestedColumns <= 0 ||
            requestedColumns > MAX_TERMINAL_COLUMNS
        ) {
            throw new RangeError(
                `Terminal columns must be between 1 and ${MAX_TERMINAL_COLUMNS}.`
            );
        }
        this.columns = requestedColumns;
        const requestedMinimumRows =
            typeof opts.minimumRows === "number" ? opts.minimumRows : 0;
        if (
            !Number.isSafeInteger(requestedMinimumRows) ||
            requestedMinimumRows < 0 ||
            requestedMinimumRows > MAX_TERMINAL_ROWS
        ) {
            throw new RangeError(
                `Terminal minimum rows must be between 0 and ${MAX_TERMINAL_ROWS}.`
            );
        }
        this.minimumRows = requestedMinimumRows;
        this.autoWrap = opts.autoWrap !== undefined ? opts.autoWrap : true;
        this.clampAtRightMargin = false;
        this.wrapPending = false;
        /** @type {Map<number, TerminalRow>} */
        this.rows = new Map();
        this.cursorX = 0;
        this.cursorY = 0;
        this.currentAttrs = createDefaultAttrs();
        /**
         * @type {{
         *     x: number;
         *     y: number;
         *     attrs: CellAttributes;
         *     iceBackground: boolean;
         * }}
         */
        this.savedCursor = {
            x: 0,
            y: 0,
            attrs: createDefaultAttrs(),
            iceBackground: false,
        };
        /** @type {Record<string, unknown>[]} */
        this.warnings = [];
        this.maxRow = 0;
        this.maxCol = 0;
        this.stripSpaceBackground = opts.stripSpaceBackground === true;
        this.iceColors = opts.iceColors === true;
        // DOS ANSI art and the canonical 16colors/libansilove renderer differ
        // from a modern ECMA-48 terminal in their legacy color aliases,
        // CR/LF/TAB cursor semantics, and immediate right-margin wrapping.
        // Archived single-byte DOS artwork commonly relies on these behaviors.
        this.dosAnsi = opts.dosAnsi === true;
        this.iceBackground = false;
        this.writtenCellCount = 0;
    }

    /**
     * @param {number} row
     *
     * @returns {TerminalRow}
     */
    ensureRow(row) {
        let existing = this.rows.get(row);
        if (!existing) {
            existing = { cells: new Map(), maxCol: -1 };
            this.rows.set(row, existing);
        }
        return existing;
    }

    saveCursor() {
        this.savedCursor = {
            x: this.cursorX,
            y: this.cursorY,
            attrs: cloneAttrs(this.currentAttrs),
            iceBackground: this.iceBackground,
        };
    }

    restoreCursor() {
        this.setCursor(this.savedCursor.x, this.savedCursor.y);
        this.currentAttrs = cloneAttrs(this.savedCursor.attrs);
        this.iceBackground = this.savedCursor.iceBackground;
    }

    /**
     * @param {number} x
     * @param {number} y
     * @param {boolean} [allowRightMarginSentinel]
     */
    setCursor(x, y, allowRightMarginSentinel = false) {
        const useRightMarginSentinel =
            allowRightMarginSentinel && this.autoWrap && x >= this.columns;
        this.assertCursorPosition(x, y, useRightMarginSentinel);
        // Real ANSI terminals constrain absolute and relative horizontal cursor
        // movement to the active right margin. libansilove additionally retains
        // a one-column sentinel for DOS cursor movement that reaches the margin;
        // the next input byte resolves that sentinel as a wrap.
        this.cursorX = Math.min(x, this.columns - 1);
        this.cursorY = y;
        this.wrapPending = useRightMarginSentinel;
    }

    /**
     * @param {number} x
     * @param {number} y
     * @param {boolean} [allowRightMarginSentinel]
     */
    assertCursorPosition(x, y, allowRightMarginSentinel = false) {
        const maximumX = allowRightMarginSentinel
            ? MAX_TERMINAL_COLUMNS
            : MAX_TERMINAL_COLUMNS - 1;
        if (
            !Number.isSafeInteger(x) ||
            !Number.isSafeInteger(y) ||
            x < 0 ||
            y < 0 ||
            x > maximumX ||
            y >= MAX_TERMINAL_ROWS
        ) {
            throw new RangeError(
                `ANSI cursor position exceeds the supported ${MAX_TERMINAL_COLUMNS}x${MAX_TERMINAL_ROWS} terminal bounds.`
            );
        }
    }

    /**
     * @param {string} ch
     */
    writeChar(ch) {
        if (ch === "\0") {
            return;
        }
        this.resolvePendingWrap();
        this.assertCursorPosition(this.cursorX, this.cursorY);
        const row = this.ensureRow(this.cursorY);
        if (!row.cells.has(this.cursorX)) {
            this.writtenCellCount += 1;
            if (this.writtenCellCount > MAX_TERMINAL_CELLS) {
                throw new RangeError(
                    `ANSI input exceeds the ${MAX_TERMINAL_CELLS} rendered-cell limit.`
                );
            }
        }
        row.cells.set(this.cursorX, {
            char: ch,
            attrs: cloneAttrs(this.currentAttrs),
        });
        if (this.cursorX > row.maxCol) {
            row.maxCol = this.cursorX;
        }
        if (this.cursorX > this.maxCol) {
            this.maxCol = this.cursorX;
        }
        if (this.cursorY > this.maxRow) {
            this.maxRow = this.cursorY;
        }

        this.cursorX += 1;
        if (this.autoWrap && this.columns && this.cursorX >= this.columns) {
            this.cursorX = this.columns - 1;
            this.wrapPending = true;
        } else if (this.clampAtRightMargin && this.cursorX >= this.columns) {
            this.cursorX = this.columns - 1;
        }
    }

    /**
     * @param {string} text
     */
    printString(text) {
        for (const character of text) {
            this.printChar(character);
        }
    }

    /**
     * @param {string} ch
     */
    printChar(ch) {
        // libansilove resolves a full-width row before it processes the next
        // byte, including a CR/LF control byte. A modern terminal keeps the
        // wrap pending until the next printable character, so preserve that
        // behavior outside the archival DOS mode.
        if (this.dosAnsi) {
            this.resolvePendingWrap();
        }
        const code = ch.codePointAt(0);
        switch (code) {
            case 0x08: // BS
                this.backspace();
                break;
            case 0x09: // HT
                this.horizontalTab();
                break;
            case 0x0a: // LF
                this.lineFeed(1);
                if (this.dosAnsi) {
                    this.carriageReturn();
                }
                break;
            case 0x0b: // VT
            case 0x0c: // FF
                this.lineFeed(1);
                break;
            case 0x0d: // CR
                // libansilove ignores CR and performs both the row increment
                // and column reset on LF. Preserve modern CR behavior for
                // Unicode/non-archival input.
                if (!this.dosAnsi) {
                    this.carriageReturn();
                }
                break;
            default:
                this.writeChar(ch);
                break;
        }
    }

    backspace() {
        this.wrapPending = false;
        if (this.cursorX > 0) {
            this.cursorX -= 1;
        }
    }

    resolvePendingWrap() {
        if (this.autoWrap && this.wrapPending) {
            this.setCursor(0, this.cursorY + 1);
        }
    }

    horizontalTab() {
        if (this.dosAnsi) {
            // libansilove advances DOS TAB by eight columns without painting
            // intervening cells. This is deliberately not a modern tab stop.
            this.setCursor(this.cursorX + 8, this.cursorY, true);
            return;
        }
        const nextStop = (Math.floor(this.cursorX / 8) + 1) * 8;
        const spaces = Math.max(1, nextStop - this.cursorX);
        for (let i = 0; i < spaces; i += 1) {
            this.writeChar(" ");
        }
    }

    /**
     * @param {number} [count]
     */
    lineFeed(count = 1) {
        const step = count;
        this.setCursor(this.cursorX, this.cursorY + step);
    }

    carriageReturn() {
        this.cursorX = 0;
        this.wrapPending = false;
    }

    /**
     * @param {number} [count]
     */
    insertCharacters(count) {
        const n = Math.max(1, count || 1);
        const inserted = Math.min(n, this.columns - this.cursorX);
        const row = this.ensureRow(this.cursorY);
        const updated = new Map();
        for (const [col, cell] of row.cells.entries()) {
            if (col >= this.cursorX) {
                const destination = col + inserted;
                if (destination < this.columns) {
                    updated.set(destination, cell);
                }
            } else {
                updated.set(col, cell);
            }
        }
        for (let i = 0; i < inserted; i += 1) {
            updated.set(this.cursorX + i, {
                char: " ",
                attrs: cloneAttrs(this.currentAttrs),
            });
        }
        this.writtenCellCount += inserted;
        if (this.writtenCellCount > MAX_TERMINAL_CELLS) {
            throw new RangeError(
                `ANSI input exceeds the ${MAX_TERMINAL_CELLS} rendered-cell limit.`
            );
        }
        row.cells = updated;
        this.recalculateRowBounds(this.cursorY);
    }

    /**
     * @param {number} [count]
     */
    deleteCharacters(count) {
        const n = Math.max(1, count || 1);
        const row = this.rows.get(this.cursorY);
        if (!row) {
            return;
        }
        const updated = new Map();
        for (const [col, cell] of row.cells.entries()) {
            if (col < this.cursorX) {
                updated.set(col, cell);
            } else if (col >= this.cursorX + n) {
                updated.set(col - n, cell);
            }
        }
        row.cells = updated;
        this.recalculateRowBounds(this.cursorY);
    }

    /**
     * @param {number} [count]
     */
    insertLines(count) {
        const n = Math.max(1, count || 1);
        const affectedRows = [...this.rows.keys()].sort((a, b) => b - a);
        const highestAffectedRow = affectedRows.find(
            (rowIndex) => rowIndex >= this.cursorY
        );
        const highestResultingRow =
            highestAffectedRow === undefined
                ? this.cursorY + n - 1
                : Math.max(highestAffectedRow + n, this.cursorY + n - 1);
        if (highestResultingRow >= MAX_TERMINAL_ROWS) {
            throw new RangeError(
                `ANSI insert operation exceeds the supported ${MAX_TERMINAL_ROWS}-row terminal bound.`
            );
        }
        affectedRows.forEach((rowIndex) => {
            if (rowIndex >= this.cursorY) {
                const row = this.rows.get(rowIndex);
                if (row) {
                    this.rows.set(rowIndex + n, row);
                    this.rows.delete(rowIndex);
                }
            }
        });
        for (let i = 0; i < n; i += 1) {
            this.rows.set(this.cursorY + i, { cells: new Map(), maxCol: -1 });
        }
        this.recalculateBounds();
    }

    /**
     * @param {number} [count]
     */
    deleteLines(count) {
        const n = Math.max(1, count || 1);
        for (let i = 0; i < n; i += 1) {
            this.rows.delete(this.cursorY + i);
        }
        const affectedRows = [...this.rows.keys()].sort((a, b) => a - b);
        affectedRows.forEach((rowIndex) => {
            if (rowIndex > this.cursorY) {
                const row = this.rows.get(rowIndex);
                if (row) {
                    this.rows.set(rowIndex - n, row);
                    this.rows.delete(rowIndex);
                }
            }
        });
        this.recalculateBounds();
    }

    /**
     * @param {number} [mode]
     */
    eraseInLine(mode) {
        const row = this.ensureRow(this.cursorY);
        const start = mode === 1 || mode === 2 ? 0 : this.cursorX;
        const end = mode === 0 || mode === 2 ? this.columns - 1 : this.cursorX;
        for (let col = start; col <= end; col += 1) {
            if (!row.cells.has(col)) {
                this.writtenCellCount += 1;
                if (this.writtenCellCount > MAX_TERMINAL_CELLS) {
                    throw new RangeError(
                        `ANSI input exceeds the ${MAX_TERMINAL_CELLS} rendered-cell limit.`
                    );
                }
            }
            row.cells.set(col, {
                char: " ",
                attrs: cloneAttrs(this.currentAttrs),
            });
        }
        this.recalculateRowBounds(this.cursorY);
    }

    /**
     * @param {number} [mode]
     */
    eraseInDisplay(mode) {
        if (mode === 2) {
            this.rows.clear();
            this.maxRow = 0;
            this.maxCol = 0;
            return;
        }
        if (mode === 0) {
            this.eraseInLine(0);
            const keys = [...this.rows.keys()].filter(
                (row) => row > this.cursorY
            );
            keys.forEach((row) => this.rows.delete(row));
        } else if (mode === 1) {
            this.eraseInLine(1);
            const keys = [...this.rows.keys()].filter(
                (row) => row < this.cursorY
            );
            keys.forEach((row) => this.rows.delete(row));
        }
        this.recalculateBounds();
    }

    /**
     * @param {number} code
     *
     * @returns {boolean}
     */
    applySimpleSgr(code) {
        if (code === 0) {
            this.currentAttrs = createDefaultAttrs();
            this.iceBackground = false;
            return true;
        }
        if (code === 5) {
            if (this.iceColors) {
                this.iceBackground = true;
                if (this.currentAttrs.bg?.mode === "basic") {
                    this.currentAttrs.bg = {
                        mode: "bright",
                        value: this.currentAttrs.bg.value,
                    };
                }
            } else {
                this.currentAttrs.blink = true;
            }
            return true;
        }
        const changes = SGR_ATTRIBUTE_CHANGES.get(code);
        if (!changes) return false;
        Object.assign(this.currentAttrs, changes);
        if (code === 25) this.iceBackground = false;
        return true;
    }

    /**
     * @param {number[]} values
     * @param {number} index
     * @param {"fg" | "bg"} target
     *
     * @returns {number} Number of additional parameters consumed.
     */
    applyExtendedSgrColor(values, index, target) {
        const mode = values[index + 1];
        if (mode === 5 && values[index + 2] !== undefined) {
            this.currentAttrs[target] = {
                mode: "palette",
                value: values[index + 2],
            };
            return 2;
        }
        if (mode === 2 && values[index + 4] !== undefined) {
            this.currentAttrs[target] = {
                mode: "rgb",
                r: values[index + 2],
                g: values[index + 3],
                b: values[index + 4],
            };
            return 4;
        }
        return 0;
    }

    /**
     * @param {number} code
     */
    applyStandardSgrColor(code) {
        if (code >= 30 && code <= 37) {
            this.currentAttrs.fg = { mode: "basic", value: code - 30 };
            return;
        }
        if (code >= 90 && code <= 97) {
            if (!this.dosAnsi) {
                this.currentAttrs.fg = { mode: "bright", value: code - 90 };
            }
            return;
        }
        if (code >= 40 && code <= 47) {
            this.currentAttrs.bg = {
                mode: this.iceBackground ? "bright" : "basic",
                value: code - 40,
            };
            return;
        }
        if (!this.dosAnsi && code >= 100 && code <= 107) {
            this.currentAttrs.bg = { mode: "bright", value: code - 100 };
        }
    }

    /**
     * @param {number[]} params
     */
    applySgr(params) {
        const values = params.length === 0 ? [0] : params;
        let i = 0;
        while (i < values.length) {
            const code = values[i] ?? 0;
            if (!this.applySimpleSgr(code)) {
                if (code === 38 || code === 48) {
                    const target = code === 38 ? "fg" : "bg";
                    i += this.applyExtendedSgrColor(values, i, target);
                } else {
                    this.applyStandardSgrColor(code);
                }
            }
            i += 1;
        }
    }

    /**
     * @param {string} collected
     * @param {number[]} values
     * @param {string} flag
     */
    warnUnsupportedCsi(collected, values, flag) {
        this.warnings.push({
            type: "CSI",
            collected,
            params: [...values],
            flag,
        });
    }

    /**
     * @param {string} flag
     * @param {number[]} values
     *
     * @returns {boolean}
     */
    applyCursorCsi(flag, values) {
        const getParam = (index, fallback) => {
            const value = values[index];
            return value === undefined || value === 0 ? fallback : value;
        };
        switch (flag) {
            case "A":
                this.setCursor(
                    this.cursorX,
                    Math.max(0, this.cursorY - getParam(0, 1))
                );
                return true;
            case "B":
                this.setCursor(this.cursorX, this.cursorY + getParam(0, 1));
                return true;
            case "C":
                this.setCursor(
                    this.cursorX + getParam(0, 1),
                    this.cursorY,
                    this.dosAnsi
                );
                return true;
            case "D":
                this.setCursor(
                    Math.max(0, this.cursorX - getParam(0, 1)),
                    this.cursorY
                );
                return true;
            case "E":
                this.setCursor(0, this.cursorY + getParam(0, 1));
                return true;
            case "F":
                this.setCursor(0, Math.max(0, this.cursorY - getParam(0, 1)));
                return true;
            case "G":
                this.setCursor(
                    Math.max(0, getParam(0, 1) - 1),
                    this.cursorY,
                    this.dosAnsi
                );
                return true;
            case "H":
            case "f":
                this.setCursor(
                    Math.max(0, getParam(1, 1) - 1),
                    Math.max(0, getParam(0, 1) - 1),
                    this.dosAnsi
                );
                return true;
            default:
                return false;
        }
    }

    /**
     * @param {number[]} params
     *
     * @returns {boolean}
     */
    applyPabloDrawRgb(params) {
        const valid =
            params.length === 4 &&
            (params[0] === 0 || params[0] === 1) &&
            params.slice(1).every((value) => value <= 255);
        if (!valid) return false;
        const color = {
            mode: "rgb",
            r: params[1],
            g: params[2],
            b: params[3],
        };
        if (params[0] === 0) this.currentAttrs.bg = color;
        else this.currentAttrs.fg = color;
        return true;
    }

    /**
     * @param {string} collected
     * @param {number[]} params
     * @param {string} flag
     *
     * @returns {boolean}
     */
    applyPrivateMode(collected, params, flag) {
        const supported =
            collected === "?" &&
            params.length === 1 &&
            (params[0] === 7 || params[0] === 33);
        if (!supported) return false;
        const enabled = flag === "h";
        if (params[0] === 7) {
            this.autoWrap = enabled;
            this.clampAtRightMargin = !enabled;
            this.wrapPending = false;
        } else {
            this.iceColors = enabled;
            if (!enabled) this.iceBackground = false;
        }
        return true;
    }

    /**
     * @param {string} collected
     * @param {number[]} params
     * @param {string} flag
     */
    applyCsi(collected, params, flag) {
        const values = params.length ? params : [0];
        if (
            values.some(
                (value) =>
                    !Number.isSafeInteger(value) ||
                    value < 0 ||
                    value > MAX_CSI_PARAMETER
            )
        ) {
            throw new RangeError(
                `ANSI CSI parameter exceeds the supported maximum of ${MAX_CSI_PARAMETER}.`
            );
        }
        if (this.applyCursorCsi(flag, values)) return;
        if (flag === "S" || flag === "T") {
            // SU/SD move display contents rather than the cursor. Warn until
            // scrolling-region emulation is implemented.
            this.warnUnsupportedCsi(collected, values, flag);
            return;
        }
        switch (flag) {
            case "J":
                this.eraseInDisplay(values[0]);
                break;
            case "K":
                this.eraseInLine(values[0]);
                break;
            case "L":
                this.insertLines(values[0]);
                break;
            case "M":
                this.deleteLines(values[0]);
                break;
            case "P":
                this.deleteCharacters(values[0]);
                break;
            case "@":
                this.insertCharacters(values[0]);
                break;
            case "m":
                this.applySgr(values);
                break;
            case "t":
                // PabloDraw emits a four-parameter RGB extension:
                // CSI 0;R;G;B t for background and CSI 1;R;G;B t for foreground.
                // Other CSI t shapes are standard window-manipulation commands
                // or malformed input and remain unsupported.
                if (!this.applyPabloDrawRgb(params)) {
                    this.warnUnsupportedCsi(collected, values, flag);
                }
                break;
            case "h":
            case "l":
                if (!this.applyPrivateMode(collected, params, flag)) {
                    this.warnUnsupportedCsi(collected, values, flag);
                }
                break;
            case "s":
                this.saveCursor();
                break;
            case "u":
                this.restoreCursor();
                break;
            default:
                this.warnUnsupportedCsi(collected, values, flag);
                break;
        }
    }

    /**
     * @param {string} collected
     * @param {string} flag
     */
    applyEsc(collected, flag) {
        switch (flag) {
            case "7":
                this.saveCursor();
                break;
            case "8":
                this.restoreCursor();
                break;
            case "D":
                this.lineFeed(1);
                break;
            case "E":
                this.lineFeed(1);
                this.carriageReturn();
                break;
            case "M":
                this.setCursor(this.cursorX, Math.max(0, this.cursorY - 1));
                break;
            case "c":
                this.rows.clear();
                this.cursorX = 0;
                this.cursorY = 0;
                this.currentAttrs = createDefaultAttrs();
                this.iceBackground = false;
                this.maxRow = 0;
                this.maxCol = 0;
                break;
            default:
                this.warnings.push({ type: "ESC", collected, flag });
                break;
        }
    }

    /**
     * @param {string} text
     */
    inst_p(text) {
        this.printString(text);
    }

    inst_o() {
        // OSC sequences are ignored for ColorScript output.
    }

    /**
     * @param {string} flag
     */
    inst_x(flag) {
        this.printChar(flag);
    }

    /**
     * @param {string} collected
     * @param {number[]} params
     * @param {string} flag
     */
    inst_c(collected, params, flag) {
        if (this.dosAnsi) {
            this.resolvePendingWrap();
        }
        this.applyCsi(collected, params, flag);
    }

    /**
     * @param {string} collected
     * @param {string} flag
     */
    inst_e(collected, flag) {
        if (this.dosAnsi) {
            this.resolvePendingWrap();
        }
        this.applyEsc(collected, flag);
    }

    inst_H() {
        return undefined;
    }

    inst_P() {
        return undefined;
    }

    inst_U() {
        return undefined;
    }

    /**
     * @param {unknown} error
     */
    inst_E(error) {
        this.warnings.push({ type: "ERROR", error });
        return undefined;
    }

    /**
     * @param {number} rowIndex
     */
    recalculateRowBounds(rowIndex) {
        const row = this.rows.get(rowIndex);
        if (!row) {
            return;
        }
        let maxCol = -1;
        row.cells.forEach((_, col) => {
            if (col > maxCol) {
                maxCol = col;
            }
        });
        row.maxCol = maxCol;
    }

    recalculateBounds() {
        let maxRow = Math.max(0, this.minimumRows - 1);
        let maxCol = 0;
        this.rows.forEach((row, index) => {
            this.recalculateRowBounds(index);
            if (row.maxCol >= 0) {
                if (index > maxRow) {
                    maxRow = index;
                }
                if (row.maxCol > maxCol) {
                    maxCol = row.maxCol;
                }
            }
        });
        this.maxRow = maxRow;
        this.maxCol = maxCol;
    }

    /**
     * @param {{ start: number; end: number } | null} columnRange
     *
     * @returns {{ start: number; end: number }}
     */
    resolveBuildColumnRange(columnRange) {
        const resolved = {
            start: columnRange?.start ?? 0,
            end: columnRange?.end ?? this.maxCol,
        };
        if (
            !Number.isSafeInteger(resolved.start) ||
            !Number.isSafeInteger(resolved.end) ||
            resolved.start < 0 ||
            resolved.end < resolved.start ||
            resolved.end >= MAX_TERMINAL_COLUMNS
        ) {
            throw new RangeError(
                `Column range must be within the supported 1-${MAX_TERMINAL_COLUMNS} terminal columns.`
            );
        }
        return resolved;
    }

    /**
     * @param {Cell | undefined} cell
     * @param {CellAttributes} defaultAttrs
     *
     * @returns {Cell}
     */
    prepareCellForSerialization(cell, defaultAttrs) {
        if (!cell) return { char: " ", attrs: defaultAttrs };
        const removeBackground =
            this.stripSpaceBackground && cell.char === " " && cell.attrs.bg;
        if (!removeBackground) return cell;
        const attrs = cloneAttrs(cell.attrs);
        attrs.bg = null;
        return { char: cell.char, attrs };
    }

    /**
     * @param {Cell[]} cells
     * @param {CellAttributes} defaultAttrs
     *
     * @returns {number}
     */
    findSerializedCellLength(cells, defaultAttrs) {
        let length = cells.length;
        while (length > 0) {
            const cell = cells[length - 1];
            if (cell.char !== " " || !attrsEqual(cell.attrs, defaultAttrs)) {
                break;
            }
            length -= 1;
        }
        return length;
    }

    /**
     * @param {Cell[]} cells
     * @param {CellAttributes} defaultAttrs
     *
     * @returns {string}
     */
    serializeCells(cells, defaultAttrs) {
        const length = this.findSerializedCellLength(cells, defaultAttrs);
        let line = "";
        let lastAttrs = defaultAttrs;
        for (let index = 0; index < length; index += 1) {
            const cell = cells[index];
            const diff = diffAttrs(lastAttrs, cell.attrs);
            if (diff.length > 0) {
                line += `${ESC}[${diff.join(";")}m`;
                lastAttrs = cell.attrs;
            }
            line += cell.char;
        }
        if (length > 0 && !attrsEqual(lastAttrs, defaultAttrs)) {
            line += `${ESC}[0m`;
        }
        return line;
    }

    /**
     * @param {TerminalRow} row
     * @param {{ start: number; end: number }} columnRange
     * @param {CellAttributes} defaultAttrs
     *
     * @returns {string}
     */
    serializeRow(row, columnRange, defaultAttrs) {
        const cells = [];
        const lastColumn = Math.min(row.maxCol, columnRange.end);
        for (let col = columnRange.start; col <= lastColumn; col += 1) {
            cells.push(
                this.prepareCellForSerialization(
                    row.cells.get(col),
                    defaultAttrs
                )
            );
        }
        return this.serializeCells(cells, defaultAttrs);
    }

    /**
     * Serialize the rendered terminal, optionally limiting each row to an
     * inclusive zero-based column range. Column slicing happens against the
     * terminal cell matrix so SGR state is reconstructed at the beginning of
     * every emitted row instead of cutting through escape sequences.
     *
     * @param {{ start: number; end: number } | null} [columnRange]
     *
     * @returns {string[]}
     */
    buildLines(columnRange = null) {
        this.recalculateBounds();
        const resolvedRange = this.resolveBuildColumnRange(columnRange);
        const lines = [];
        const defaultAttrs = createDefaultAttrs();
        for (let rowIndex = 0; rowIndex <= this.maxRow; rowIndex += 1) {
            const row = this.rows.get(rowIndex);
            const hasVisibleRange = row && row.maxCol >= resolvedRange.start;
            lines.push(
                hasVisibleRange
                    ? this.serializeRow(row, resolvedRange, defaultAttrs)
                    : ""
            );
        }
        return lines;
    }
}

/**
 * @param {string} name
 *
 * @returns {string}
 */
function sanitizeName(name) {
    return name
        .toLowerCase()
        .replace(/[^a-z0-9]/g, "-")
        .replace(/-+/g, "-")
        .replace(/^-|-$/g, "");
}

/**
 * Restrict generated comment metadata to one printable line so a hostile file
 * name cannot terminate the comment and inject PowerShell source.
 *
 * @param {string} value
 *
 * @returns {string}
 */
function sanitizePowerShellComment(value) {
    return String(value)
        .replace(/[\r\n\u0085\u2028\u2029]+/g, " ")
        .replace(/[\u0000-\u0008\u000b\u000c\u000e-\u001f\u007f]/g, "?");
}

/**
 * Return a SAUCE date only when the fixed-width field contains a valid YYYYMMDD
 * calendar date. Empty, partial, and producer-specific placeholder values are
 * metadata omissions rather than dates and must not be serialized into
 * generated script comments.
 *
 * @param {string} value
 *
 * @returns {string | null}
 */
function getValidSauceDate(value) {
    if (!/^[1-9]\d{3}(?:0[1-9]|1[0-2])(?:0[1-9]|[12]\d|3[01])$/.test(value)) {
        return null;
    }

    const year = Number(value.slice(0, 4));
    const month = Number(value.slice(4, 6));
    const day = Number(value.slice(6, 8));
    const daysInMonth = new Date(Date.UTC(year, month, 0)).getUTCDate();
    return day <= daysInMonth ? value : null;
}

/**
 * Build non-executable source-provenance comments for generated colorscripts.
 *
 * @param {string} sourceName
 * @param {string} sourceEncoding
 * @param {SauceRecord | null} sauce
 * @param {Partial<SourceProvenance>} [provenance]
 * @param {"Passthrough" | "TerminalEmulation" | null} [conversionMode]
 *
 * @returns {string}
 */
function buildSourceMetadataHeader(
    sourceName,
    sourceEncoding,
    sauce,
    provenance = {},
    conversionMode = null
) {
    const lines = [
        `# Converted from: ${sanitizePowerShellComment(sourceName)}`,
        `# Source encoding: ${sanitizePowerShellComment(sourceEncoding)}`,
    ];
    const sourceMetadata = [
        ["URL", provenance.url],
        ["Revision", provenance.revision],
        ["SHA-256", provenance.sha256],
        ["License", provenance.license],
        ["Attribution", provenance.attribution],
        ["Modification", provenance.modification],
        ["Conversion Mode", conversionMode],
    ];
    for (const [label, value] of sourceMetadata) {
        if (value) {
            lines.push(
                `# Source ${label}: ${sanitizePowerShellComment(value)}`
            );
        }
    }
    if (sauce) {
        const metadata = [
            ["Title", sauce.title],
            ["Author", sauce.author],
            ["Group", sauce.group],
            ["Date", getValidSauceDate(sauce.date)],
            Number.isSafeInteger(sauce.tInfo1) &&
            sauce.tInfo1 > 0 &&
            Number.isSafeInteger(sauce.tInfo2) &&
            sauce.tInfo2 > 0
                ? ["Dimensions", `${sauce.tInfo1}x${sauce.tInfo2}`]
                : null,
            ["Font", getSauceFontName(sauce)],
            ["Comments", sauce.commentLines.join(" | ")],
        ];
        for (const entry of metadata) {
            if (!entry) {
                continue;
            }
            const [label, value] = entry;
            if (value) {
                lines.push(
                    `# SAUCE ${label}: ${sanitizePowerShellComment(value)}`
                );
            }
        }
    }
    return `${lines.join("\n")}\n`;
}

/**
 * Validate optional provenance values before embedding them in generated
 * source. Metadata remains Unicode-friendly, but must be a bounded single
 * line.
 *
 * @param {string} value
 * @param {string} label
 * @param {number} maxLength
 *
 * @returns {string}
 */
function validateSourceMetadataValue(value, label, maxLength) {
    if (!value || value.length > maxLength) {
        throw new Error(
            `${label} must contain between 1 and ${maxLength} characters.`
        );
    }
    if (/\r|\n|\u0085|\u2028|\u2029|[\u0000-\u001f\u007f]/u.test(value)) {
        throw new Error(`${label} must be a single printable line.`);
    }
    return value;
}

/**
 * @param {string} value
 *
 * @returns {string}
 */
function validateSourceUrl(value) {
    const validated = validateSourceMetadataValue(value, "Source URL", 2048);
    let parsed;
    try {
        parsed = new URL(validated);
    } catch {
        throw new Error("Source URL must be an absolute HTTP or HTTPS URL.");
    }
    if (parsed.protocol !== "http:" && parsed.protocol !== "https:") {
        throw new Error("Source URL must be an absolute HTTP or HTTPS URL.");
    }
    return validated;
}

/**
 * Serialize display text as a literal PowerShell expression.
 *
 * Single-quoted PowerShell strings do not expand dollar signs, subexpressions,
 * or backticks. Doubling embedded apostrophes is the only escaping required,
 * and ordinary quoted strings can safely span lines (including a line that is
 * equal to a here-string terminator).
 *
 * @param {string} content
 *
 * @returns {string}
 */
function serializePowerShellStringLiteral(content) {
    return `'${content.replaceAll("'", "''")}'`;
}

/**
 * Build the executable portion of a generated colorscript without allowing
 * ANSI-art text to become PowerShell source code.
 *
 * @param {string} content
 * @param {{
 *     noNewline?: boolean;
 *     startOnNewLine?: boolean;
 * }} [options]
 *
 * @returns {string}
 */
function buildPowerShellOutput(
    content,
    { noNewline = false, startOnNewLine = false } = {}
) {
    const outputContent =
        startOnNewLine && !/^\r?\n/u.test(content) ? `\n${content}` : content;
    const noNewlineArgument = noNewline ? " -NoNewline" : "";
    return `Write-Host ${serializePowerShellStringLiteral(outputContent)}${noNewlineArgument}\n`;
}

/**
 * Write generated PowerShell with a UTF-8 BOM. Windows PowerShell 5.1 treats
 * BOM-less script files as the active ANSI code page, corrupting Unicode art.
 *
 * @param {string} filePath
 * @param {string} content
 */
function writePowerShellFile(filePath, content) {
    const source = content.startsWith("\ufeff") ? content : `\ufeff${content}`;
    fs.writeFileSync(filePath, source, "utf8");
}

/**
 * @param {string[]} argv
 *
 * @returns {{
 *     options: {
 *         columns: number | null;
 *         autoWrap: boolean;
 *         stripSpaceBackground: boolean;
 *         maxHeight: number | null;
 *         encoding: string;
 *         passthrough: boolean;
 *         force: boolean;
 *         analyzeJson: boolean;
 *         provenancePath: string;
 *         provenanceRecordPath: string | null;
 *         sourceProvenance: SourceProvenance;
 *     };
 *     positional: string[];
 * }}
 */
function parseArguments(argv) {
    const options =
        /**
         * @type {{
         *     columns: number | null;
         *     autoWrap: boolean;
         *     stripSpaceBackground: boolean;
         *     maxHeight: number | null;
         *     encoding: string;
         *     passthrough: boolean;
         *     force: boolean;
         *     analyzeJson: boolean;
         *     provenancePath: string;
         *     provenanceRecordPath: string | null;
         *     sourceProvenance: SourceProvenance;
         * }}
         */ ({
            columns: null,
            autoWrap: true,
            stripSpaceBackground: false,
            maxHeight: null,
            encoding: "cp437",
            passthrough: false,
            force: false,
            analyzeJson: false,
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
        });
    /** @type {string[]} */
    const positional = [];
    let optionsEnded = false;
    for (const arg of argv) {
        if (!optionsEnded && arg === "--") {
            optionsEnded = true;
            continue;
        }
        if (optionsEnded) {
            positional.push(arg);
            continue;
        }

        if (arg.startsWith("--columns=")) {
            const value = Number.parseInt(arg.split("=")[1], 10);
            if (!Number.isNaN(value) && value > 0) {
                options.columns = value;
            }
        } else if (
            arg.startsWith("--max-height=") ||
            arg.startsWith("--height=") ||
            arg.startsWith("--Height=")
        ) {
            const value = Number.parseInt(arg.split("=")[1], 10);
            if (!Number.isNaN(value) && value > 0) {
                options.maxHeight = value;
            }
        } else if (arg === "--no-autowrap") {
            options.autoWrap = false;
        } else if (arg === "--autowrap") {
            options.autoWrap = true;
        } else if (
            arg === "--strip-space-bg" ||
            arg === "--strip-space-background"
        ) {
            options.stripSpaceBackground = true;
        } else if (arg === "--keep-space-bg") {
            options.stripSpaceBackground = false;
        } else if (arg.startsWith("--encoding=")) {
            const enc = arg.split("=")[1].toLowerCase();
            if (enc === "utf8" || enc === "utf-8") {
                options.encoding = "utf8";
            } else if (enc === "cp437" || enc === "437") {
                options.encoding = "cp437";
            } else {
                options.encoding = enc;
            }
        } else if (arg === "--utf8" || arg === "--utf-8") {
            options.encoding = "utf8";
        } else if (
            arg === "--passthrough" ||
            arg === "--simple" ||
            arg === "--raw"
        ) {
            options.passthrough = true;
        } else if (arg === "--force") {
            options.force = true;
        } else if (arg === "--analyze-json") {
            options.analyzeJson = true;
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
    }
    return { options, positional };
}

/**
 * @param {string} filePath
 * @param {string} [encoding="cp437"] - Encoding to use (cp437 for ANSI art,
 *   utf8 for Unicode) Default is `"cp437"`
 *
 * @returns {{ content: string; sauce: SauceRecord | null }}
 */
function readAnsiFile(filePath, encoding = "cp437") {
    const fileSize = fs.statSync(filePath).size;
    if (fileSize > MAX_INPUT_BYTES) {
        throw new RangeError(
            `ANSI input exceeds the ${MAX_INPUT_BYTES}-byte safety limit.`
        );
    }
    const raw = fs.readFileSync(filePath);
    if (raw.length > MAX_INPUT_BYTES) {
        throw new RangeError(
            `ANSI input exceeds the ${MAX_INPUT_BYTES}-byte safety limit.`
        );
    }
    const { buffer, sauce } = stripSauce(raw);
    const normalizedEncoding = encoding.toLowerCase();
    const isUtf8 = !usesDosAnsiSemantics(normalizedEncoding);
    // DOS and libansilove treat SUB (0x1A) as the logical end of an ANSI
    // stream. Some historical packs contain line breaks, duplicate EOF
    // markers, or other bytes between the first SUB and SAUCE metadata; none
    // of those bytes are part of the rendered artwork.
    const contentBuffer = isUtf8 ? buffer : truncateDosAnsiAtEof(buffer);
    let content;
    if (isUtf8) {
        content = contentBuffer.toString("utf8");
    } else {
        const dosEncoding =
            normalizedEncoding === "437" ? "cp437" : normalizedEncoding;
        content = decodeDosAnsi(contentBuffer, dosEncoding);
    }
    return { content, sauce };
}

/**
 * @param {SauceRecord | null} sauce
 *
 * @returns {string}
 */
function getSauceFontName(sauce) {
    if (!sauce) {
        return "";
    }

    const terminatorIndex = sauce.tInfoS.indexOf(0);
    const field =
        terminatorIndex === -1
            ? sauce.tInfoS
            : sauce.tInfoS.subarray(0, terminatorIndex);
    if (field.some((byte) => byte < 0x20 || byte > 0x7e)) {
        return "";
    }

    return field.toString("ascii").trim();
}

/**
 * @param {string} ansiContent
 * @param {TerminalOptions} convertOptions
 *
 * @returns {{
 *     lines: string[];
 *     warnings: Record<string, unknown>[];
 *     terminal: TerminalEmulator;
 * }}
 */
function convertAnsiToPs1(ansiContent, convertOptions) {
    const terminal = new TerminalEmulator(convertOptions);
    const parser = new AnsiParser(terminal);
    parser.parse(ansiContent);
    const lines = terminal.buildLines();
    return { lines, warnings: terminal.warnings, terminal };
}

/**
 * @param {string} outputFile
 *
 * @returns {string}
 */
function getGeneratedScriptName(outputFile) {
    if (path.extname(outputFile).toLowerCase() !== ".ps1") {
        throw new Error(
            "External artwork provenance can only accompany PowerShell output."
        );
    }
    const name = path.basename(outputFile, path.extname(outputFile));
    if (!/^[a-z0-9][a-z0-9-]*$/u.test(name)) {
        throw new Error(
            `Provenance-backed output requires a lowercase kebab-case filename: ${path.basename(outputFile)}.`
        );
    }
    return name;
}

function main(argv = process.argv.slice(2)) {
    const { options, positional } = parseArguments(argv);

    if (positional.length === 0) {
        console.error(
            "Usage: node Convert-AnsiToColorScript.js [options] <ansi-file> [output-file]"
        );
        console.error("Options:");
        console.error(
            "  --columns=<n>      Set terminal column width (defaults to SAUCE width or 80)."
        );
        console.error(
            "  --no-autowrap      Disable automatic line wrapping at the terminal width."
        );
        console.error(
            "  --strip-space-bg   Clear background color for plain space characters."
        );
        console.error(
            "  --max-height=<n>   Split output into multiple files every <n> lines."
        );
        console.error(
            "  --encoding=<enc>   Input file encoding (cp437 for ANSI art, utf8 for Unicode)."
        );
        console.error(
            "  --utf8             Shorthand for --encoding=utf8 (for Pokemon colorscripts)."
        );
        console.error(
            "  --passthrough      Preserve a pre-formatted decoded stream byte-for-byte without terminal emulation."
        );
        console.error("  --force            Replace existing output files.");
        console.error(
            "  --source-url=<url> Embed the original artwork URL in a comment."
        );
        console.error(
            "  --source-revision=<revision> Embed the source revision or archive identifier."
        );
        console.error(
            "  --source-sha256=<hash> Embed the original artwork SHA-256."
        );
        console.error(
            "  --source-license=<license> Embed the artwork license identifier."
        );
        console.error(
            "  --source-attribution=<text> Embed the artwork attribution."
        );
        console.error(
            "  --source-modification=<text> Describe how the source artwork was modified."
        );
        console.error(
            "  --provenance-record=<json> Emit a compact header and upsert a complete external provenance record."
        );
        console.error(
            "  --provenance-path=<psd1> Override the authoritative provenance data file."
        );
        process.exit(1);
    }

    const ansiFile = positional[0];
    const sanitizedBaseName = sanitizeName(
        path.basename(ansiFile, path.extname(ansiFile))
    );
    if (!sanitizedBaseName) {
        throw new Error(
            `Input filename cannot form a safe colorscript name: ${path.basename(ansiFile)}`
        );
    }
    const outputFile =
        positional[1] ||
        path.join(
            __dirname,
            "..",
            "ColorScripts-Enhanced",
            "Scripts",
            `${sanitizedBaseName}.ps1`
        );

    try {
        if (options.analyzeJson) {
            if (positional.length !== 1) {
                throw new Error(
                    "--analyze-json requires exactly one ANSI input file."
                );
            }
            const { content, sauce } = readAnsiFile(ansiFile, options.encoding);
            const terminalColumns =
                options.columns || sauce?.tInfo1 || DEFAULT_COLUMNS;
            const { warnings, terminal } = convertAnsiToPs1(content, {
                columns: terminalColumns,
                autoWrap: options.autoWrap,
                stripSpaceBackground: options.stripSpaceBackground,
                iceColors: Boolean(sauce?.flags & 1),
                dosAnsi: usesDosAnsiSemantics(options.encoding),
            });
            process.stdout.write(
                JSON.stringify({
                    width:
                        terminal.writtenCellCount > 0 ? terminal.maxCol + 1 : 0,
                    height: terminal.maxRow + 1,
                    warnings,
                })
            );
            return { terminal, warnings };
        }

        console.log(
            `Reading ANSI file: ${ansiFile} (encoding: ${options.encoding})`
        );
        const { content, sauce } = readAnsiFile(ansiFile, options.encoding);
        const sourceBuffer = fs.readFileSync(ansiFile);
        const provenanceTemplate = options.provenanceRecordPath
            ? readGeneratedArtworkTemplate(options.provenanceRecordPath)
            : null;
        if (
            provenanceTemplate &&
            Object.values(options.sourceProvenance).some(
                (value) => value !== null
            )
        ) {
            throw new Error(
                "--provenance-record cannot be combined with legacy --source-* header options. Put those values in the JSON record."
            );
        }
        const conversionMode = options.passthrough
            ? "Passthrough"
            : "TerminalEmulation";
        const legacyHeader = provenanceTemplate
            ? null
            : buildSourceMetadataHeader(
                  path.basename(ansiFile),
                  options.encoding,
                  sauce,
                  options.sourceProvenance,
                  conversionMode
              );

        const outputDir = path.dirname(outputFile);
        if (!fs.existsSync(outputDir)) {
            fs.mkdirSync(outputDir, { recursive: true });
        }

        // Passthrough mode - skip terminal emulation and preserve the decoded stream exactly.
        if (options.passthrough) {
            console.log("Using passthrough mode (no terminal emulation)...");
            // Preserve the pre-formatted stream exactly. Write-Host's default newline would add
            // bytes that are not present in the source, so passthrough output uses -NoNewline.
            if (fs.existsSync(outputFile) && !options.force) {
                throw new Error(
                    `Output file already exists: ${outputFile}. Use --force to replace it.`
                );
            }
            if (provenanceTemplate) {
                const geometry = convertAnsiToPs1(content, {
                    columns:
                        options.columns || sauce?.tInfo1 || DEFAULT_COLUMNS,
                    autoWrap: options.autoWrap,
                    stripSpaceBackground: false,
                    iceColors: Boolean(sauce?.flags & 1),
                    dosAnsi: usesDosAnsiSemantics(options.encoding),
                });
                const scriptName = getGeneratedScriptName(outputFile);
                const entry = buildGeneratedArtworkEntry({
                    conversionMode: "Passthrough",
                    name: scriptName,
                    sauce,
                    sourceBuffer,
                    sourceColumns: `1-${Math.max(
                        1,
                        geometry.terminal.maxCol + 1
                    )}`,
                    sourceEncoding: options.encoding,
                    sourceName: ansiFile,
                    sourceRows: `1-${Math.max(1, geometry.lines.length)}`,
                    template: provenanceTemplate,
                });
                const entries = new Map([[scriptName, entry]]);
                const prepared = prepareGeneratedArtworkProvenance(
                    options.provenancePath,
                    entries
                );
                const compactHeader = prepared.headers.get(scriptName);
                const ps1Content = `${compactHeader}\n\n${buildPowerShellOutput(
                    content,
                    { noNewline: true }
                )}`;
                writeGeneratedArtworkTransaction(
                    options.provenancePath,
                    prepared.provenanceSource,
                    new Map([[path.resolve(outputFile), ps1Content]])
                );
            } else {
                const ps1Content = `${legacyHeader}\n${buildPowerShellOutput(
                    content,
                    { noNewline: true }
                )}`;
                writePowerShellFile(outputFile, ps1Content);
            }
            console.log(
                `✓ Converted: ${path.basename(ansiFile)} → ${path.basename(outputFile)}`
            );
            console.log(`  Output: ${outputFile}`);
            console.log("\n✓ Conversion complete!");
            return;
        }

        const terminalColumns =
            options.columns || sauce?.tInfo1 || DEFAULT_COLUMNS;
        const terminalOptions = {
            columns: terminalColumns,
            autoWrap: options.autoWrap,
            stripSpaceBackground: options.stripSpaceBackground,
            iceColors: Boolean(sauce?.flags & 1),
            dosAnsi: usesDosAnsiSemantics(options.encoding),
        };

        const sauceFontName = getSauceFontName(sauce);
        if (
            sauceFontName &&
            !/(?:IBM|CP[ -]?437|VGA|EGA)/i.test(sauceFontName)
        ) {
            console.warn(
                `Warning: SAUCE declares font "${sanitizePowerShellComment(sauceFontName)}"; CP437 decoding may not reproduce its glyphs exactly.`
            );
        }

        console.log(
            `Using terminal width: ${terminalOptions.autoWrap ? terminalColumns : "no wrap"}`
        );
        if (terminalOptions.stripSpaceBackground) {
            console.log(
                "Stripping background color from plain space characters."
            );
        }
        console.log("Converting ANSI to PowerShell...");

        const { lines, warnings, terminal } = convertAnsiToPs1(
            content,
            terminalOptions
        );

        // Split output if max-height is specified
        if (options.maxHeight && lines.length > options.maxHeight) {
            const maxHeight = options.maxHeight;
            const chunks = [];
            for (let i = 0; i < lines.length; i += maxHeight) {
                chunks.push(lines.slice(i, i + maxHeight));
            }

            const baseName = path.basename(
                outputFile,
                path.extname(outputFile)
            );
            const ext = path.extname(outputFile);

            const chunkFiles = chunks.map((unusedChunk, index) =>
                path.join(outputDir, `${baseName}-${index + 1}${ext}`)
            );
            if (!options.force) {
                const existingFile = chunkFiles.find((filePath) =>
                    fs.existsSync(filePath)
                );
                if (existingFile) {
                    throw new Error(
                        `Output file already exists: ${existingFile}. Use --force to replace it.`
                    );
                }
            }

            if (provenanceTemplate) {
                const entries = new Map();
                chunks.forEach((chunk, index) => {
                    const chunkFile = chunkFiles[index];
                    const scriptName = getGeneratedScriptName(chunkFile);
                    entries.set(
                        scriptName,
                        buildGeneratedArtworkEntry({
                            conversionMode: "TerminalEmulation",
                            name: scriptName,
                            sauce,
                            sourceBuffer,
                            sourceColumns: `1-${terminalColumns}`,
                            sourceEncoding: options.encoding,
                            sourceName: ansiFile,
                            sourceRows: `${index * maxHeight + 1}-${
                                index * maxHeight + chunk.length
                            }`,
                            template: provenanceTemplate,
                        })
                    );
                });
                const prepared = prepareGeneratedArtworkProvenance(
                    options.provenancePath,
                    entries
                );
                const scripts = new Map();
                chunks.forEach((chunk, index) => {
                    const chunkFile = chunkFiles[index];
                    const scriptName = getGeneratedScriptName(chunkFile);
                    scripts.set(
                        path.resolve(chunkFile),
                        `${prepared.headers.get(scriptName)}\n\n${buildPowerShellOutput(
                            chunk.join("\n"),
                            { startOnNewLine: true }
                        )}`
                    );
                });
                writeGeneratedArtworkTransaction(
                    options.provenancePath,
                    prepared.provenanceSource,
                    scripts
                );
            } else {
                chunks.forEach((chunk, index) => {
                    const chunkFile = chunkFiles[index];
                    const convertedContent = chunk.join("\n");
                    const ps1Content = `${legacyHeader}# Part ${index + 1} of ${chunks.length}\n\n${buildPowerShellOutput(convertedContent, { startOnNewLine: true })}`;
                    writePowerShellFile(chunkFile, ps1Content);
                });
            }
            chunks.forEach((unusedChunk, index) => {
                console.log(
                    `✓ Created part ${index + 1}/${chunks.length}: ${path.basename(chunkFiles[index])}`
                );
            });

            console.log(
                `\n✓ Split into ${chunks.length} files (max height: ${maxHeight} lines)`
            );
        } else {
            // Single file output
            const convertedContent = lines.join("\n");
            if (fs.existsSync(outputFile) && !options.force) {
                throw new Error(
                    `Output file already exists: ${outputFile}. Use --force to replace it.`
                );
            }
            if (provenanceTemplate) {
                const scriptName = getGeneratedScriptName(outputFile);
                const entry = buildGeneratedArtworkEntry({
                    conversionMode: "TerminalEmulation",
                    name: scriptName,
                    sauce,
                    sourceBuffer,
                    sourceColumns: `1-${terminalColumns}`,
                    sourceEncoding: options.encoding,
                    sourceName: ansiFile,
                    sourceRows: `1-${Math.max(1, lines.length)}`,
                    template: provenanceTemplate,
                });
                const prepared = prepareGeneratedArtworkProvenance(
                    options.provenancePath,
                    new Map([[scriptName, entry]])
                );
                const ps1Content = `${prepared.headers.get(scriptName)}\n\n${buildPowerShellOutput(convertedContent, { startOnNewLine: true })}`;
                writeGeneratedArtworkTransaction(
                    options.provenancePath,
                    prepared.provenanceSource,
                    new Map([[path.resolve(outputFile), ps1Content]])
                );
            } else {
                const ps1Content = `${legacyHeader}\n${buildPowerShellOutput(
                    convertedContent,
                    { startOnNewLine: true }
                )}`;
                writePowerShellFile(outputFile, ps1Content);
            }
            console.log(
                `✓ Converted: ${path.basename(ansiFile)} → ${path.basename(outputFile)}`
            );
        }

        console.log(`  Output: ${outputFile}`);
        if (warnings.length > 0) {
            console.warn("Warnings during conversion:");
            warnings.slice(0, 5).forEach((warning) => {
                console.warn(`  • ${JSON.stringify(warning)}`);
            });
            if (warnings.length > 5) {
                console.warn(`  • ... and ${warnings.length - 5} more`);
            }
        }
        console.log("\n✓ Conversion complete!");

        return { lines, warnings, terminal };
    } catch (error) {
        const message = error instanceof Error ? error.message : String(error);
        console.error(`Error: ${message}`);
        process.exit(1);
    }
}

if (require.main === module) {
    main();
}

module.exports = {
    TerminalEmulator,
    decodeDosAnsi,
    decodeCp437Ansi,
    readAnsiFile,
    convertAnsiToPs1,
    parseArguments,
    sanitizeName,
    sanitizePowerShellComment,
    trimSauceTextField,
    validateSourceMetadataValue,
    validateSourceUrl,
    buildSourceMetadataHeader,
    serializePowerShellStringLiteral,
    buildPowerShellOutput,
    writePowerShellFile,
    getSauceFontName,
    resolveSauceEncoding,
    truncateDosAnsiAtEof,
    usesDosAnsiSemantics,
    main,
    createDefaultAttrs,
    stripSauce,
    MAX_INPUT_BYTES,
    MAX_TERMINAL_COLUMNS,
    MAX_TERMINAL_ROWS,
};
