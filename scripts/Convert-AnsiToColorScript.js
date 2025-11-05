#!/usr/bin/env node
"use strict";

const fs = require("fs");
const path = require("path");
const iconv = require("iconv-lite");
const AnsiParser = require("node-ansiparser");

const ESC = "\x1b";
const DEFAULT_COLUMNS = 80;

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
 * @property {number} [maxHeight]
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
 * @param {ColorState | null} color
 * @param {boolean} isForeground
 *
 * @returns {number[]}
 */
function colorToCodes(color, isForeground) {
    if (!color) {
        return [];
    }
    const base = isForeground ? 30 : 40;
    const brightBase = isForeground ? 90 : 100;
    switch (color.mode) {
        case "basic":
            return typeof color.value === "number" ? [base + color.value] : [];
        case "bright":
            return typeof color.value === "number"
                ? [brightBase + color.value]
                : [];
        case "palette":
            return typeof color.value === "number"
                ? [
                      isForeground ? 38 : 48,
                      5,
                      color.value,
                  ]
                : [];
        case "rgb":
            if (
                typeof color.r === "number" &&
                typeof color.g === "number" &&
                typeof color.b === "number"
            ) {
                return [
                    isForeground ? 38 : 48,
                    2,
                    color.r,
                    color.g,
                    color.b,
                ];
            }
            return [];
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
    codes.push(...colorToCodes(attrs.fg, true));
    codes.push(...colorToCodes(attrs.bg, false));
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
 * @param {Buffer} buffer
 *
 * @returns {SauceRecord}
 */
function parseSauceRecord(buffer) {
    return {
        version: buffer.subarray(5, 7).toString("ascii"),
        title: buffer
            .subarray(7, 42)
            .toString("ascii")
            .replace(/\0+$/, "")
            .trim(),
        author: buffer
            .subarray(42, 62)
            .toString("ascii")
            .replace(/\0+$/, "")
            .trim(),
        group: buffer
            .subarray(62, 82)
            .toString("ascii")
            .replace(/\0+$/, "")
            .trim(),
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
    };
}

/**
 * @param {Buffer} buffer
 *
 * @returns {{ buffer: Buffer; sauce: SauceRecord | null }}
 */
function stripSauce(buffer) {
    const SAUCE_LENGTH = 128;
    if (buffer.length < SAUCE_LENGTH) {
        return { buffer, sauce: null };
    }

    const sauceOffset = buffer.length - SAUCE_LENGTH;
    const sauceId = buffer
        .subarray(sauceOffset, sauceOffset + 5)
        .toString("ascii");
    if (sauceId !== "SAUCE") {
        return { buffer, sauce: null };
    }

    const sauceRecord = buffer.subarray(
        sauceOffset,
        sauceOffset + SAUCE_LENGTH
    );
    const sauce = parseSauceRecord(sauceRecord);

    let trimOffset = sauceOffset;

    if (sauce.comments > 0) {
        const commentBlockLength = 5 + sauce.comments * 64;
        const commentOffset = sauceOffset - commentBlockLength;
        if (commentOffset >= 0) {
            const commentId = buffer
                .subarray(commentOffset, commentOffset + 5)
                .toString("ascii");
            if (commentId === "COMNT") {
                trimOffset = commentOffset;
            }
        }
    }

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
        this.columns =
            typeof opts.columns === "number" && opts.columns > 0
                ? opts.columns
                : DEFAULT_COLUMNS;
        this.autoWrap = opts.autoWrap !== undefined ? opts.autoWrap : true;
        /** @type {Map<number, TerminalRow>} */
        this.rows = new Map();
        this.cursorX = 0;
        this.cursorY = 0;
        this.currentAttrs = createDefaultAttrs();
        /** @type {{ x: number; y: number; attrs: CellAttributes }} */
        this.savedCursor = { x: 0, y: 0, attrs: createDefaultAttrs() };
        /** @type {Record<string, unknown>[]} */
        this.warnings = [];
        this.maxRow = 0;
        this.maxCol = 0;
        this.stripSpaceBackground = opts.stripSpaceBackground === true;
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
        };
    }

    restoreCursor() {
        this.cursorX = this.savedCursor.x;
        this.cursorY = this.savedCursor.y;
        this.currentAttrs = cloneAttrs(this.savedCursor.attrs);
    }

    /**
     * @param {number} x
     * @param {number} y
     */
    setCursor(x, y) {
        this.cursorX = Math.max(0, x);
        this.cursorY = Math.max(0, y);
    }

    /**
     * @param {string} ch
     */
    writeChar(ch) {
        if (ch === "\0") {
            return;
        }
        const row = this.ensureRow(this.cursorY);
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
            this.cursorX = 0;
            this.cursorY += 1;
            if (this.cursorY > this.maxRow) {
                this.maxRow = this.cursorY;
            }
        }
    }

    /**
     * @param {string} text
     */
    printString(text) {
        for (let i = 0; i < text.length; i += 1) {
            this.printChar(text[i]);
        }
    }

    /**
     * @param {string} ch
     */
    printChar(ch) {
        const code = ch.charCodeAt(0);
        switch (code) {
            case 0x08: // BS
                this.backspace();
                break;
            case 0x09: // HT
                this.horizontalTab();
                break;
            case 0x0a: // LF
                this.lineFeed(1);
                break;
            case 0x0b: // VT
            case 0x0c: // FF
                this.lineFeed(1);
                break;
            case 0x0d: // CR
                this.carriageReturn();
                break;
            default:
                this.writeChar(ch);
                break;
        }
    }

    backspace() {
        if (this.cursorX > 0) {
            this.cursorX -= 1;
        }
    }

    horizontalTab() {
        const nextStop = (Math.floor(this.cursorX / 8) + 1) * 8;
        const spaces = Math.max(1, nextStop - this.cursorX);
        for (let i = 0; i < spaces; i += 1) {
            this.writeChar(" ");
        }
    }

    /**
     * @param {number} [count]
     */
    lineFeed(count) {
        const step = count || 1;
        this.cursorY += step;
        if (this.cursorY > this.maxRow) {
            this.maxRow = this.cursorY;
        }
    }

    carriageReturn() {
        this.cursorX = 0;
    }

    /**
     * @param {number} [count]
     */
    insertCharacters(count) {
        const n = Math.max(1, count || 1);
        const row = this.ensureRow(this.cursorY);
        const updated = new Map();
        for (const [col, cell] of row.cells.entries()) {
            if (col >= this.cursorX) {
                updated.set(col + n, cell);
            } else {
                updated.set(col, cell);
            }
        }
        for (let i = 0; i < n; i += 1) {
            updated.set(this.cursorX + i, {
                char: " ",
                attrs: cloneAttrs(this.currentAttrs),
            });
        }
        row.cells = updated;
        row.maxCol = Math.max(row.maxCol, this.cursorX + n - 1);
        if (row.maxCol > this.maxCol) {
            this.maxCol = row.maxCol;
        }
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
        const row = this.rows.get(this.cursorY);
        if (!row) {
            return;
        }
        const start = mode === 1 ? 0 : this.cursorX;
        const end = mode === 0 ? row.maxCol : this.cursorX;
        if (mode === 2) {
            row.cells.clear();
            row.maxCol = -1;
        } else {
            for (let col = start; col <= end; col += 1) {
                row.cells.delete(col);
            }
            this.recalculateRowBounds(this.cursorY);
        }
    }

    /**
     * @param {number} [mode]
     */
    eraseInDisplay(mode) {
        if (mode === 2) {
            this.rows.clear();
            this.cursorX = 0;
            this.cursorY = 0;
            this.currentAttrs = createDefaultAttrs();
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
     * @param {number[]} params
     */
    applySgr(params) {
        const values = params.length === 0 ? [0] : params;
        let i = 0;
        while (i < values.length) {
            const code = values[i] ?? 0;
            switch (code) {
                case 0:
                    this.currentAttrs = createDefaultAttrs();
                    break;
                case 1:
                    this.currentAttrs.bold = true;
                    break;
                case 2:
                    this.currentAttrs.dim = true;
                    break;
                case 3:
                    this.currentAttrs.italic = true;
                    break;
                case 4:
                    this.currentAttrs.underline = true;
                    break;
                case 5:
                    this.currentAttrs.blink = true;
                    break;
                case 7:
                    this.currentAttrs.inverse = true;
                    break;
                case 8:
                    this.currentAttrs.hidden = true;
                    break;
                case 9:
                    this.currentAttrs.strike = true;
                    break;
                case 22:
                    this.currentAttrs.bold = false;
                    this.currentAttrs.dim = false;
                    break;
                case 23:
                    this.currentAttrs.italic = false;
                    break;
                case 24:
                    this.currentAttrs.underline = false;
                    break;
                case 25:
                    this.currentAttrs.blink = false;
                    break;
                case 27:
                    this.currentAttrs.inverse = false;
                    break;
                case 28:
                    this.currentAttrs.hidden = false;
                    break;
                case 29:
                    this.currentAttrs.strike = false;
                    break;
                case 39:
                    this.currentAttrs.fg = null;
                    break;
                case 49:
                    this.currentAttrs.bg = null;
                    break;
                case 38: {
                    const next = values[i + 1];
                    if (next === 5 && values[i + 2] !== undefined) {
                        this.currentAttrs.fg = {
                            mode: "palette",
                            value: values[i + 2],
                        };
                        i += 2;
                    } else if (next === 2 && values[i + 4] !== undefined) {
                        this.currentAttrs.fg = {
                            mode: "rgb",
                            r: values[i + 2],
                            g: values[i + 3],
                            b: values[i + 4],
                        };
                        i += 4;
                    }
                    break;
                }
                case 48: {
                    const next = values[i + 1];
                    if (next === 5 && values[i + 2] !== undefined) {
                        this.currentAttrs.bg = {
                            mode: "palette",
                            value: values[i + 2],
                        };
                        i += 2;
                    } else if (next === 2 && values[i + 4] !== undefined) {
                        this.currentAttrs.bg = {
                            mode: "rgb",
                            r: values[i + 2],
                            g: values[i + 3],
                            b: values[i + 4],
                        };
                        i += 4;
                    }
                    break;
                }
                default:
                    if (code >= 30 && code <= 37) {
                        this.currentAttrs.fg = {
                            mode: "basic",
                            value: code - 30,
                        };
                    } else if (code >= 90 && code <= 97) {
                        this.currentAttrs.fg = {
                            mode: "bright",
                            value: code - 90,
                        };
                    } else if (code >= 40 && code <= 47) {
                        this.currentAttrs.bg = {
                            mode: "basic",
                            value: code - 40,
                        };
                    } else if (code >= 100 && code <= 107) {
                        this.currentAttrs.bg = {
                            mode: "bright",
                            value: code - 100,
                        };
                    }
                    break;
            }
            i += 1;
        }
    }

    /**
     * @param {string} collected
     * @param {number[]} params
     * @param {string} flag
     */
    applyCsi(collected, params, flag) {
        const values = params.length ? params : [0];
        /**
         * @param {number} index
         * @param {number} fallback
         *
         * @returns {number}
         */
        const getParam = (index, fallback) => {
            const value = values[index];
            return value === undefined || value === 0 ? fallback : value;
        };
        switch (flag) {
            case "A":
                this.cursorY = Math.max(0, this.cursorY - getParam(0, 1));
                break;
            case "B":
                this.cursorY += getParam(0, 1);
                if (this.cursorY > this.maxRow) {
                    this.maxRow = this.cursorY;
                }
                break;
            case "C":
                this.cursorX += getParam(0, 1);
                break;
            case "D":
                this.cursorX = Math.max(0, this.cursorX - getParam(0, 1));
                break;
            case "E":
                this.cursorY += getParam(0, 1);
                this.cursorX = 0;
                break;
            case "F":
                this.cursorY = Math.max(0, this.cursorY - getParam(0, 1));
                this.cursorX = 0;
                break;
            case "G":
                this.cursorX = Math.max(0, getParam(0, 1) - 1);
                break;
            case "H":
            case "f": {
                const row = Math.max(0, getParam(0, 1) - 1);
                const col = Math.max(0, getParam(1, 1) - 1);
                this.setCursor(col, row);
                break;
            }
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
            case "S":
                this.cursorY = Math.max(0, this.cursorY - values[0]);
                break;
            case "T":
                this.cursorY += values[0];
                break;
            case "m":
                this.applySgr(values);
                break;
            case "s":
                this.saveCursor();
                break;
            case "u":
                this.restoreCursor();
                break;
            default:
                this.warnings.push({
                    type: "CSI",
                    collected,
                    params: [...values],
                    flag,
                });
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
                this.cursorY = Math.max(0, this.cursorY - 1);
                break;
            case "c":
                this.rows.clear();
                this.cursorX = 0;
                this.cursorY = 0;
                this.currentAttrs = createDefaultAttrs();
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
        this.applyCsi(collected, params, flag);
    }

    /**
     * @param {string} collected
     * @param {string} flag
     */
    inst_e(collected, flag) {
        this.applyEsc(collected, flag);
    }

    inst_H() {}

    inst_P() {}

    inst_U() {}

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
        let maxRow = 0;
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

    buildLines() {
        this.recalculateBounds();
        const lines = [];
        const defaultAttrs = createDefaultAttrs();
        for (let rowIndex = 0; rowIndex <= this.maxRow; rowIndex += 1) {
            const row = this.rows.get(rowIndex);
            if (!row || row.maxCol < 0) {
                lines.push("");
                continue;
            }
            const cells = [];
            for (let col = 0; col <= row.maxCol; col += 1) {
                const cell = row.cells.get(col);
                if (cell) {
                    let attrsToUse = cell.attrs;
                    if (
                        this.stripSpaceBackground &&
                        cell.char === " " &&
                        cell.attrs.bg
                    ) {
                        const cloned = cloneAttrs(cell.attrs);
                        cloned.bg = null;
                        attrsToUse = cloned;
                    }
                    cells.push({ char: cell.char, attrs: attrsToUse });
                } else {
                    cells.push({ char: " ", attrs: defaultAttrs });
                }
            }
            let effectiveLength = cells.length;
            while (effectiveLength > 0) {
                const lastCell = cells[effectiveLength - 1];
                if (
                    lastCell.char === " " &&
                    attrsEqual(lastCell.attrs, defaultAttrs)
                ) {
                    effectiveLength -= 1;
                } else {
                    break;
                }
            }
            let line = "";
            let lastAttrs = defaultAttrs;
            for (let i = 0; i < effectiveLength; i += 1) {
                const cell = cells[i];
                const diff = diffAttrs(lastAttrs, cell.attrs);
                if (diff.length > 0) {
                    line += `${ESC}[${diff.join(";")}m`;
                    lastAttrs = cell.attrs;
                }
                line += cell.char;
            }
            if (effectiveLength > 0 && !attrsEqual(lastAttrs, defaultAttrs)) {
                line += `${ESC}[0m`;
            }
            lines.push(line);
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
 * @param {string[]} argv
 *
 * @returns {{
 *     options: {
 *         columns: number | null;
 *         autoWrap: boolean;
 *         stripSpaceBackground: boolean;
 *         maxHeight: number | null;
 *     };
 *     positional: string[];
 * }}
 */
function parseArguments(argv) {
    const options = /** @type {{
    columns: number | null;
    autoWrap: boolean;
    stripSpaceBackground: boolean;
    maxHeight: number | null;
}} */ ({
        columns: null,
        autoWrap: true,
        stripSpaceBackground: false,
        maxHeight: null,
    });
    /** @type {string[]} */
    const positional = [];
    for (const arg of argv) {
        if (arg.startsWith("--columns=")) {
            const value = parseInt(arg.split("=")[1], 10);
            if (!Number.isNaN(value) && value > 0) {
                options.columns = value;
            }
        } else if (
            arg.startsWith("--max-height=") ||
            arg.startsWith("--height=") ||
            arg.startsWith("--Height=")
        ) {
            const value = parseInt(arg.split("=")[1], 10);
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
        } else {
            positional.push(arg);
        }
    }
    return { options, positional };
}

/**
 * @param {string} filePath
 *
 * @returns {{ content: string; sauce: SauceRecord | null }}
 */
function readAnsiFile(filePath) {
    const raw = fs.readFileSync(filePath);
    const { buffer, sauce } = stripSauce(raw);
    const content = iconv.decode(buffer, "cp437");
    return { content, sauce };
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
        process.exit(1);
    }

    const ansiFile = positional[0];
    const outputFile =
        positional[1] ||
        path.join(
            __dirname,
            "..",
            "ColorScripts-Enhanced",
            "Scripts",
            `${sanitizeName(path.basename(ansiFile, path.extname(ansiFile)))}.ps1`
        );

    try {
        console.log(`Reading ANSI file: ${ansiFile}`);
        const { content, sauce } = readAnsiFile(ansiFile);

        const terminalColumns =
            options.columns ||
            (sauce && sauce.tInfo1 ? sauce.tInfo1 : DEFAULT_COLUMNS);
        const terminalOptions = {
            columns: terminalColumns,
            autoWrap: options.autoWrap,
            stripSpaceBackground: options.stripSpaceBackground,
        };

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

        const header = `# Converted from: ${path.basename(ansiFile)}\n# Conversion date: ${new Date().toISOString()}\n`;

        const outputDir = path.dirname(outputFile);
        if (!fs.existsSync(outputDir)) {
            fs.mkdirSync(outputDir, { recursive: true });
        }

        // Split output if max-height is specified
        if (options.maxHeight && lines.length > options.maxHeight) {
            const chunks = [];
            for (let i = 0; i < lines.length; i += options.maxHeight) {
                chunks.push(lines.slice(i, i + options.maxHeight));
            }

            const baseName = path.basename(
                outputFile,
                path.extname(outputFile)
            );
            const ext = path.extname(outputFile);

            chunks.forEach((chunk, index) => {
                const chunkFile = path.join(
                    outputDir,
                    `${baseName}-${index + 1}${ext}`
                );
                const convertedContent = chunk.join("\n");
                const ps1Content = `${header}# Part ${index + 1} of ${chunks.length}\n\nWrite-Host @"\n${convertedContent}\n"@\n`;
                fs.writeFileSync(chunkFile, ps1Content, "utf8");
                console.log(
                    `✓ Created part ${index + 1}/${chunks.length}: ${path.basename(chunkFile)}`
                );
            });

            console.log(
                `\n✓ Split into ${chunks.length} files (max height: ${options.maxHeight} lines)`
            );
        } else {
            // Single file output
            const convertedContent = lines.join("\n");
            const ps1Content = `${header}\nWrite-Host @"\n${convertedContent}\n"@\n`;
            fs.writeFileSync(outputFile, ps1Content, "utf8");
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
    readAnsiFile,
    convertAnsiToPs1,
    parseArguments,
    sanitizeName,
    main,
    createDefaultAttrs,
    stripSauce,
};
