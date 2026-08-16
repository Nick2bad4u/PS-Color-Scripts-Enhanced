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

const REQUIRED_GENERATED_PROPERTIES = Object.freeze([
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
]);

/**
 * @param {Readonly<Record<string, ProvenanceValue>>} entry
 * @param {string} property
 * @param {string} name
 *
 * @returns {string}
 */
function requireGeneratedString(entry, property, name) {
    const value = entry[property];
    if (typeof value !== "string" || !value.trim()) {
        throw new Error(`${name}: complete provenance requires ${property}.`);
    }
    return value;
}

/**
 * @param {Readonly<Record<string, ProvenanceValue>>} entry
 * @param {string} name
 */
function validateRequiredGeneratedProperties(entry, name) {
    for (const property of REQUIRED_GENERATED_PROPERTIES) {
        requireGeneratedString(entry, property, name);
    }
}

/**
 * @param {Readonly<Record<string, ProvenanceValue>>} entry
 * @param {string} name
 */
function validateGeneratedHashes(entry, name) {
    if (
        !SHA256_PATTERN.test(
            requireGeneratedString(entry, "SourceSha256", name)
        )
    ) {
        throw new Error(`${name}: SourceSha256 must be lowercase SHA-256.`);
    }
    for (const property of ["RenderSha256", "NormalizedRenderSha256"]) {
        const value = entry[property];
        if (
            value !== undefined &&
            (typeof value !== "string" || !SHA256_PATTERN.test(value))
        ) {
            throw new Error(`${name}: ${property} must be lowercase SHA-256.`);
        }
    }
}

/**
 * @param {Readonly<Record<string, ProvenanceValue>>} entry
 * @param {string} name
 */
function validateGeneratedCoordinates(entry, name) {
    for (const property of ["SourceRows", "SourceColumns"]) {
        const value = requireGeneratedString(entry, property, name);
        if (!COORDINATE_PATTERN.test(value)) {
            throw new Error(
                `${name}: ${property} must be a one-based inclusive range.`
            );
        }
    }
}

/**
 * @param {string} value
 * @param {string} name
 */
function validateGeneratedSourceUrl(value, name) {
    let sourceUrl;
    try {
        sourceUrl = new URL(value);
    } catch {
        throw new Error(`${name}: SourceUrl must be an absolute URL.`);
    }
    if (sourceUrl.protocol !== "https:" && sourceUrl.protocol !== "http:") {
        throw new Error(`${name}: SourceUrl must use HTTP or HTTPS.`);
    }
}

/**
 * @param {Readonly<Record<string, ProvenanceValue>>} entry
 * @param {string} name
 */
function validateCompleteGeneratedEntry(entry, name) {
    validateRequiredGeneratedProperties(entry, name);
    if (
        (typeof entry.Artist !== "string" || !entry.Artist.trim()) &&
        (typeof entry.Attribution !== "string" || !entry.Attribution.trim())
    ) {
        throw new Error(
            `${name}: complete provenance requires Artist or Attribution.`
        );
    }
    validateGeneratedHashes(entry, name);
    validateGeneratedCoordinates(entry, name);
    validateGeneratedSourceUrl(
        requireGeneratedString(entry, "SourceUrl", name),
        name
    );
}

/**
 * @param {string} sourceEncoding
 */
function normalizeGeneratedEncoding(sourceEncoding) {
    const normalized = sourceEncoding.toLowerCase();
    if (normalized === "cp437" || normalized === "437") {
        return { input: "cp437", display: "CP437" };
    }
    if (normalized === "utf8" || normalized === "utf-8") {
        return { input: normalized, display: "UTF-8" };
    }
    return { input: normalized, display: sourceEncoding };
}

/**
 * @param {Record<string, ProvenanceValue>} entry
 * @param {import("./Convert-AnsiToColorScript.js").SauceRecord | null} sauce
 */
function applySauceProvenance(entry, sauce) {
    if (!sauce) return;
    if (sauce.title) entry.SauceTitle = sauce.title;
    if (sauce.author) entry.SauceAuthor = sauce.author;
    if (sauce.group) entry.SauceGroup = sauce.group;
    if (isValidSauceDate(sauce.date)) entry.SauceDate = sauce.date;
    if (sauce.commentLines.length > 0) {
        entry.SauceComments = sauce.commentLines.join(" | ");
    }
    if (sauce.tInfo1 > 0 && sauce.tInfo2 > 0) {
        entry.SauceDimensions = `${sauce.tInfo1}x${sauce.tInfo2}`;
    }
    entry.SauceFlags = sauce.flags;
    const sauceFont = getPrintableSauceFont(sauce);
    if (sauceFont) entry.SauceFont = sauceFont;
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
    const encoding = normalizeGeneratedEncoding(options.sourceEncoding);
    const sourceName = path.basename(options.sourceName);
    const format = path.extname(sourceName).slice(1).toUpperCase() || "ANS";
    requireMatchingString(sourceHash, "SourceSha256", options.template);
    requireMatchingString(sourceName, "OriginalFilename", options.template);
    requireMatchingString(sourceName, "ConvertedFrom", options.template);
    requireMatchingString(encoding.input, "InputEncoding", options.template);

    /** @type {Record<string, ProvenanceValue>} */
    const entry = {
        ...options.template,
        OriginalFilename: sourceName,
        Format: format,
        SourceSha256: sourceHash,
        SourceRows: options.sourceRows,
        SourceColumns: options.sourceColumns,
        InputEncoding: encoding.input,
        ConversionMode: options.conversionMode,
        HasSauce: Boolean(options.sauce),
        IceColors: Boolean(options.sauce && options.sauce.flags & 1),
        ConvertedFrom: sourceName,
        SourceEncoding: encoding.display,
        HeaderFormat: "CompactV1",
    };
    if (!Object.hasOwn(entry, "SourceFile")) entry.SourceFile = sourceName;
    applySauceProvenance(entry, options.sauce);
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
        writeGeneratedTargets(targets);
    } catch (error) {
        restoreGeneratedTargets(previous);
        throw error;
    }
}

/**
 * @param {ReadonlyMap<string, string>} targets
 */
function writeGeneratedTargets(targets) {
    for (const [target, content] of targets) {
        fs.mkdirSync(path.dirname(target), { recursive: true });
        let output = content;
        if (target.endsWith(".ps1") && !content.startsWith("\ufeff")) {
            output = `\ufeff${content}`;
        }
        fs.writeFileSync(target, output, "utf8");
    }
}

/**
 * @param {ReadonlyMap<string, Buffer | null>} previous
 */
function restoreGeneratedTargets(previous) {
    for (const [target, content] of previous) {
        if (content === null) {
            if (fs.existsSync(target)) fs.rmSync(target);
            continue;
        }
        fs.writeFileSync(target, content);
    }
}

module.exports = {
    buildGeneratedArtworkEntry,
    prepareGeneratedArtworkProvenance,
    readGeneratedArtworkTemplate,
    validateCompleteGeneratedEntry,
    writeGeneratedArtworkTransaction,
};
