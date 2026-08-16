"use strict";
// @ts-check

const fs = require("node:fs");
const path = require("node:path");

const {
    buildCompactArtworkHeader,
    parseArtworkProvenance,
    readArtworkProvenance,
    sha256,
    upsertArtworkProvenanceScriptEntries,
} = require("./ArtworkProvenance.js");

const MAX_TEMPLATE_BYTES = 1024 * 1024;
const SHA256_PATTERN = /^[a-f\d]{64}$/u;
const COORDINATE_PATTERN = /^[1-9]\d*-[1-9]\d*$/u;

/** @typedef {boolean | number | string | readonly string[]} ProvenanceValue */

/**
 * @param {unknown} value
 * @param {string} context
 *
 * @returns {value is ProvenanceValue}
 */
function isProvenanceValue(value, context) {
    if (
        typeof value === "string" ||
        typeof value === "boolean" ||
        Number.isSafeInteger(value)
    ) {
        return true;
    }
    if (
        Array.isArray(value) &&
        value.length > 0 &&
        value.every((item) => typeof item === "string")
    ) {
        return true;
    }
    throw new TypeError(
        `${context} must be a string, boolean, safe integer, or non-empty string array.`
    );
}

/**
 * @param {string} filePath
 *
 * @returns {Readonly<Record<string, ProvenanceValue>>}
 */
function readGeneratedArtworkTemplate(filePath) {
    const resolvedPath = path.resolve(filePath);
    const stats = fs.statSync(resolvedPath);
    if (!stats.isFile() || stats.size > MAX_TEMPLATE_BYTES) {
        throw new Error(
            `Artwork provenance template must be a file no larger than ${MAX_TEMPLATE_BYTES} bytes.`
        );
    }
    /** @type {unknown} */
    let parsed;
    try {
        parsed = JSON.parse(fs.readFileSync(resolvedPath, "utf8"));
    } catch (error) {
        throw new Error(
            `Cannot parse artwork provenance template ${resolvedPath}: ${
                error instanceof Error ? error.message : String(error)
            }`
        );
    }
    if (!parsed || typeof parsed !== "object" || Array.isArray(parsed)) {
        throw new TypeError(
            "Artwork provenance template must be a JSON object of PSD1 property names and values."
        );
    }
    /** @type {Record<string, ProvenanceValue>} */
    const record = {};
    for (const [property, value] of Object.entries(parsed)) {
        if (!/^[A-Za-z][A-Za-z\d]*$/u.test(property)) {
            throw new Error(`Unsafe artwork provenance property: ${property}.`);
        }
        if (isProvenanceValue(value, property)) record[property] = value;
    }
    return Object.freeze(record);
}

/**
 * @param {string} value
 * @param {string} property
 * @param {Readonly<Record<string, ProvenanceValue>>} entry
 */
function requireMatchingString(value, property, entry) {
    const supplied = entry[property];
    if (supplied !== undefined && supplied !== value) {
        throw new Error(
            `${property} in the provenance template disagrees with the generated value.`
        );
    }
}

/**
 * @param {import("./Convert-AnsiToColorScript.js").SauceRecord} sauce
 *
 * @returns {string}
 */
function getPrintableSauceFont(sauce) {
    const terminator = sauce.tInfoS.indexOf(0);
    const field =
        terminator === -1 ? sauce.tInfoS : sauce.tInfoS.subarray(0, terminator);
    return field.some((byte) => byte < 0x20 || byte > 0x7e)
        ? ""
        : field.toString("ascii").trim();
}

/**
 * @param {string} value
 *
 * @returns {boolean}
 */
function isValidSauceDate(value) {
    if (!/^[1-9]\d{3}(?:0[1-9]|1[0-2])(?:0[1-9]|[12]\d|3[01])$/u.test(value)) {
        return false;
    }
    const year = Number(value.slice(0, 4));
    const month = Number(value.slice(4, 6));
    const day = Number(value.slice(6, 8));
    return day <= new Date(Date.UTC(year, month, 0)).getUTCDate();
}

/**
 * @param {Readonly<Record<string, ProvenanceValue>>} entry
 * @param {string} name
 */
function validateCompleteGeneratedEntry(entry, name) {
    for (const property of [
        "Collection",
        "SourceFile",
        "OriginalFilename",
        "Format",
        "SourceUrl",
        "SourceRevision",
        "SourceSha256",
        "SourceRows",
        "SourceColumns",
        "InputEncoding",
        "ConversionMode",
        "ConvertedFrom",
        "SourceEncoding",
        "SourceModification",
    ]) {
        if (typeof entry[property] !== "string" || !entry[property].trim()) {
            throw new Error(
                `${name}: complete provenance requires ${property}.`
            );
        }
    }
    if (
        (typeof entry.Artist !== "string" || !entry.Artist.trim()) &&
        (typeof entry.Attribution !== "string" || !entry.Attribution.trim())
    ) {
        throw new Error(
            `${name}: complete provenance requires Artist or Attribution.`
        );
    }
    if (!SHA256_PATTERN.test(String(entry.SourceSha256))) {
        throw new Error(`${name}: SourceSha256 must be lowercase SHA-256.`);
    }
    for (const property of ["RenderSha256", "NormalizedRenderSha256"]) {
        if (
            entry[property] !== undefined &&
            !SHA256_PATTERN.test(String(entry[property]))
        ) {
            throw new Error(`${name}: ${property} must be lowercase SHA-256.`);
        }
    }
    for (const property of ["SourceRows", "SourceColumns"]) {
        if (!COORDINATE_PATTERN.test(String(entry[property]))) {
            throw new Error(
                `${name}: ${property} must be a one-based inclusive range.`
            );
        }
    }
    let sourceUrl;
    try {
        sourceUrl = new URL(String(entry.SourceUrl));
    } catch {
        throw new Error(`${name}: SourceUrl must be an absolute URL.`);
    }
    if (sourceUrl.protocol !== "https:" && sourceUrl.protocol !== "http:") {
        throw new Error(`${name}: SourceUrl must use HTTP or HTTPS.`);
    }
}

/**
 * @param {{
 *     conversionMode: "Passthrough" | "TerminalEmulation";
 *     name: string;
 *     sauce: import("./Convert-AnsiToColorScript.js").SauceRecord | null;
 *     sourceBuffer: Buffer;
 *     sourceColumns: string;
 *     sourceEncoding: string;
 *     sourceName: string;
 *     sourceRows: string;
 *     template: Readonly<Record<string, ProvenanceValue>>;
 * }} options
 *
 * @returns {Readonly<Record<string, ProvenanceValue>>}
 */
function buildGeneratedArtworkEntry(options) {
    const sourceHash = sha256(options.sourceBuffer);
    const normalizedEncoding = options.sourceEncoding.toLowerCase();
    let displayEncoding = options.sourceEncoding;
    if (normalizedEncoding === "cp437" || normalizedEncoding === "437") {
        displayEncoding = "CP437";
    } else if (
        normalizedEncoding === "utf8" ||
        normalizedEncoding === "utf-8"
    ) {
        displayEncoding = "UTF-8";
    }
    const sourceName = path.basename(options.sourceName);
    const format = path.extname(sourceName).slice(1).toUpperCase() || "ANS";
    requireMatchingString(sourceHash, "SourceSha256", options.template);
    requireMatchingString(sourceName, "OriginalFilename", options.template);
    requireMatchingString(sourceName, "ConvertedFrom", options.template);
    requireMatchingString(
        normalizedEncoding === "437" ? "cp437" : normalizedEncoding,
        "InputEncoding",
        options.template
    );

    /** @type {Record<string, ProvenanceValue>} */
    const entry = {
        ...options.template,
        OriginalFilename: sourceName,
        Format: format,
        SourceSha256: sourceHash,
        SourceRows: options.sourceRows,
        SourceColumns: options.sourceColumns,
        InputEncoding:
            normalizedEncoding === "437" ? "cp437" : normalizedEncoding,
        ConversionMode: options.conversionMode,
        HasSauce: Boolean(options.sauce),
        IceColors: Boolean(options.sauce && options.sauce.flags & 1),
        ConvertedFrom: sourceName,
        SourceEncoding: displayEncoding,
        HeaderFormat: "CompactV1",
    };
    if (!Object.hasOwn(entry, "SourceFile")) entry.SourceFile = sourceName;
    if (options.sauce) {
        if (options.sauce.title) entry.SauceTitle = options.sauce.title;
        if (options.sauce.author) entry.SauceAuthor = options.sauce.author;
        if (options.sauce.group) entry.SauceGroup = options.sauce.group;
        if (isValidSauceDate(options.sauce.date)) {
            entry.SauceDate = options.sauce.date;
        }
        if (options.sauce.commentLines.length > 0) {
            entry.SauceComments = options.sauce.commentLines.join(" | ");
        }
        if (options.sauce.tInfo1 > 0 && options.sauce.tInfo2 > 0) {
            entry.SauceDimensions = `${options.sauce.tInfo1}x${options.sauce.tInfo2}`;
        }
        entry.SauceFlags = options.sauce.flags;
        const sauceFont = getPrintableSauceFont(options.sauce);
        if (sauceFont) entry.SauceFont = sauceFont;
    }
    validateCompleteGeneratedEntry(entry, options.name);
    return Object.freeze(entry);
}

/**
 * @param {string} provenancePath
 * @param {ReadonlyMap<string, Readonly<Record<string, ProvenanceValue>>>} entries
 *
 * @returns {{
 *     headers: ReadonlyMap<string, string>;
 *     provenanceSource: string;
 * }}
 */
function prepareGeneratedArtworkProvenance(provenancePath, entries) {
    const provenance = readArtworkProvenance(provenancePath);
    const provenanceSource = upsertArtworkProvenanceScriptEntries(
        provenance.source,
        entries
    );
    const updated = parseArtworkProvenance(provenanceSource);
    const headers = new Map();
    for (const [name, entry] of entries) {
        const collectionName = entry.Collection;
        const collection =
            typeof collectionName === "string"
                ? updated.collections.get(collectionName)
                : null;
        if (!collection) throw new Error(`${name}: collection is missing.`);
        headers.set(name, buildCompactArtworkHeader(name, entry, collection));
    }
    return { headers, provenanceSource };
}

/**
 * Commit generated scripts and the authoritative provenance update together.
 * Any write failure restores the exact bytes that existed before the attempt.
 *
 * @param {string} provenancePath
 * @param {string} provenanceSource
 * @param {ReadonlyMap<string, string>} scripts UTF-8 source without a BOM.
 */
function writeGeneratedArtworkTransaction(
    provenancePath,
    provenanceSource,
    scripts
) {
    const targets = new Map(scripts);
    targets.set(path.resolve(provenancePath), provenanceSource);
    const previous = new Map();
    for (const target of targets.keys()) {
        previous.set(
            target,
            fs.existsSync(target) ? fs.readFileSync(target) : null
        );
    }
    try {
        for (const [target, content] of targets) {
            fs.mkdirSync(path.dirname(target), { recursive: true });
            let output = content;
            if (target.endsWith(".ps1") && !content.startsWith("\ufeff")) {
                output = `\ufeff${content}`;
            }
            fs.writeFileSync(target, output, "utf8");
        }
    } catch (error) {
        for (const [target, content] of previous) {
            if (content === null) {
                if (fs.existsSync(target)) fs.rmSync(target);
            } else {
                fs.writeFileSync(target, content);
            }
        }
        throw error;
    }
}

module.exports = {
    buildGeneratedArtworkEntry,
    prepareGeneratedArtworkProvenance,
    readGeneratedArtworkTemplate,
    validateCompleteGeneratedEntry,
    writeGeneratedArtworkTransaction,
};
