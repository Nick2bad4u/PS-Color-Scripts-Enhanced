"use strict";
// @ts-check

const crypto = require("node:crypto");
const fs = require("node:fs");
const path = require("node:path");

const REPOSITORY_ROOT = path.resolve(__dirname, "..");
const DEFAULT_PROVENANCE_PATH = path.join(
    REPOSITORY_ROOT,
    "audit",
    "ArtworkProvenance.psd1"
);
const DEFAULT_HEADER_MIGRATION_PATH = path.join(
    REPOSITORY_ROOT,
    "audit",
    "ArtworkHeaderMigration.json"
);
const ARTWORK_DETAILS_BASE_URL =
    "https://nick2bad4u.github.io/PS-Color-Scripts-Enhanced/docs/artwork.html?script=";
const UNMAPPED_SCRIPT_HASH_MODE = "sha256-crlf-normalized-v1";
const ENTRY_PATTERN =
    /^ {8}'((?:[^']|'')+)'\s*=\s*@\{\r?\n([\s\S]*?)^ {8}\}\r?$/gmu;
const COMPACT_HEADER_PATTERN =
    /^# Artwork: (?<title>.+) by (?<artist>.+?) \| Details: (?<url>https:\/\/[^\s]+)$/u;

/** @typedef {boolean | number | string | readonly string[]} ProvenanceValue */

/**
 * @param {string} value
 *
 * @returns {string}
 */
function unescapePowerShellString(value) {
    return value.replaceAll("''", "'");
}

/**
 * @param {string} value
 *
 * @returns {string}
 */
function escapePowerShellString(value) {
    return value.replaceAll("'", "''");
}

/**
 * @param {boolean | number | string} value
 *
 * @returns {string}
 */
function serializePowerShellScalar(value) {
    if (typeof value === "string") {
        return `'${escapePowerShellString(value)}'`;
    }
    if (typeof value === "boolean") return value ? "$true" : "$false";
    if (Number.isSafeInteger(value)) return String(value);
    throw new TypeError("PowerShell provenance values must be scalar data.");
}

/**
 * @param {ProvenanceValue} value
 * @param {string} lineEnding
 * @param {string} indentation
 *
 * @returns {string}
 */
function serializePowerShellValue(value, lineEnding, indentation) {
    if (!Array.isArray(value)) {
        return serializePowerShellScalar(
            /** @type {boolean | number | string} */ (value)
        );
    }
    if (!value.every((item) => typeof item === "string")) {
        throw new TypeError(
            "PowerShell provenance arrays must contain strings."
        );
    }
    const items = value
        .map((item) => `${indentation}    '${escapePowerShellString(item)}'`)
        .join(lineEnding);
    return `@(${lineEnding}${items}${lineEnding}${indentation})`;
}

/**
 * @param {string} name
 * @param {Readonly<Record<string, ProvenanceValue>>} entry
 * @param {string} lineEnding
 *
 * @returns {string}
 */
function serializeArtworkProvenanceEntry(name, entry, lineEnding) {
    if (!/^[a-z0-9][a-z0-9-]*$/u.test(name)) {
        throw new Error(`Unsafe artwork script name: ${name}.`);
    }
    const properties = Object.entries(entry);
    if (properties.length === 0) {
        throw new Error(`${name}: artwork provenance entry is empty.`);
    }
    const lines = [`        '${escapePowerShellString(name)}' = @{`];
    for (const [property, value] of properties) {
        if (!/^[A-Za-z][A-Za-z\d]*$/u.test(property)) {
            throw new Error(`${name}: unsafe provenance property ${property}.`);
        }
        lines.push(
            `            ${property} = ${serializePowerShellValue(
                value,
                lineEnding,
                "            "
            )}`
        );
    }
    lines.push("        }");
    return lines.join(lineEnding);
}

/**
 * Parse the scalar values used by the checked-in PowerShell data file. The
 * provenance document is trusted repository input, but unsupported syntax is
 * rejected so a malformed edit cannot be interpreted inconsistently.
 *
 * @param {string} value
 * @param {string} context
 *
 * @returns {boolean | number | string}
 */
function parsePowerShellScalar(value, context) {
    const stringMatch = /^'((?:[^']|'')*)'$/u.exec(value);
    if (stringMatch) return unescapePowerShellString(stringMatch[1]);
    if (value === "$true") return true;
    if (value === "$false") return false;
    if (/^-?(?:0|[1-9]\d*)$/u.test(value)) return Number(value);
    throw new Error(`${context}: unsupported PowerShell data value ${value}.`);
}

/**
 * @param {string[]} lines
 * @param {number} startIndex
 * @param {string} context
 *
 * @returns {{ endIndex: number; value: readonly string[] }}
 */
function parsePowerShellStringArray(lines, startIndex, context) {
    const values = [];
    for (let index = startIndex; index < lines.length; index += 1) {
        if (/^ {12}\)$/u.test(lines[index])) {
            return { endIndex: index, value: Object.freeze(values) };
        }
        const valueMatch = /^ {16}'((?:[^']|'')*)'$/u.exec(lines[index]);
        if (!valueMatch) {
            throw new Error(
                `${context}: unsupported array item ${lines[index]}.`
            );
        }
        values.push(unescapePowerShellString(valueMatch[1]));
    }
    throw new Error(`${context}: unterminated array.`);
}

/**
 * Parse one fixed-indentation property assignment without a backtracking
 * expression. Unsupported lines remain non-assignments and are ignored by the
 * containing data-block parser.
 *
 * @param {string} line
 *
 * @returns {{ name: string; rawValue: string } | null}
 */
function parseEntryAssignment(line) {
    const indentation = "            ";
    if (!line.startsWith(indentation)) return null;
    const assignment = line.slice(indentation.length);
    const separator = assignment.indexOf("=");
    if (separator < 1) return null;
    const name = assignment.slice(0, separator).trimEnd();
    if (!/^[A-Za-z][A-Za-z\d]*$/u.test(name)) return null;
    return {
        name,
        rawValue: assignment.slice(separator + 1).trimStart(),
    };
}

/**
 * @param {string} block
 * @param {string} context
 *
 * @returns {Readonly<Record<string, ProvenanceValue>>}
 */
function parseEntryProperties(block, context) {
    /** @type {Record<string, ProvenanceValue>} */
    const properties = {};
    const lines = block.replaceAll("\r\n", "\n").split("\n");
    let index = 0;
    while (index < lines.length) {
        const assignment = parseEntryAssignment(lines[index]);
        if (!assignment) {
            index += 1;
            continue;
        }
        const { name, rawValue } = assignment;
        if (Object.hasOwn(properties, name)) {
            throw new Error(`${context}: duplicate property ${name}.`);
        }
        if (rawValue !== "@(") {
            properties[name] = parsePowerShellScalar(
                rawValue,
                `${context}.${name}`
            );
            index += 1;
            continue;
        }
        const parsedArray = parsePowerShellStringArray(
            lines,
            index + 1,
            `${context}.${name}`
        );
        properties[name] = parsedArray.value;
        index = parsedArray.endIndex + 1;
    }
    return Object.freeze(properties);
}

/**
 * @param {string} source
 * @param {string} sectionName
 * @param {string | null} nextSectionName
 *
 * @returns {string}
 */
function getSection(source, sectionName, nextSectionName) {
    const startExpression = new RegExp(
        String.raw`^ {4}${sectionName}\s*=\s*@\{\r?$`,
        "mu"
    );
    const startMatch = startExpression.exec(source);
    if (!startMatch) {
        throw new Error(`Artwork provenance is missing ${sectionName}.`);
    }
    const contentStart = startMatch.index + startMatch[0].length;
    if (!nextSectionName) return source.slice(contentStart);
    const endExpression = new RegExp(
        String.raw`^ {4}${nextSectionName}\s*=\s*@\{\r?$`,
        "mu"
    );
    const remaining = source.slice(contentStart);
    const endMatch = endExpression.exec(remaining);
    if (!endMatch) {
        throw new Error(
            `Artwork provenance is missing ${nextSectionName} after ${sectionName}.`
        );
    }
    return remaining.slice(0, endMatch.index);
}

/**
 * @param {string} section
 * @param {string} sectionName
 *
 * @returns {ReadonlyMap<
 *     string,
 *     Readonly<Record<string, boolean | number | string>>
 * >}
 */
function parseEntries(section, sectionName) {
    const entries = new Map();
    for (const match of section.matchAll(ENTRY_PATTERN)) {
        const name = unescapePowerShellString(match[1]);
        if (entries.has(name)) {
            throw new Error(`Duplicate ${sectionName} entry: ${name}.`);
        }
        entries.set(
            name,
            parseEntryProperties(match[2], `${sectionName}.${name}`)
        );
    }
    if (entries.size === 0) {
        throw new Error(`Artwork provenance ${sectionName} is empty.`);
    }
    return entries;
}

/**
 * @param {string} source
 *
 * @returns {{
 *     collections: ReadonlyMap<
 *         string,
 *         Readonly<Record<string, ProvenanceValue>>
 *     >;
 *     schemaVersion: number;
 *     scripts: ReadonlyMap<string, Readonly<Record<string, ProvenanceValue>>>;
 * }}
 */
function parseArtworkProvenance(source) {
    const schemaMatch = /^ {4}SchemaVersion\s*=\s*(\d+)\s*$/mu.exec(source);
    if (!schemaMatch) {
        throw new Error("Artwork provenance is missing SchemaVersion.");
    }
    const schemaVersion = Number(schemaMatch[1]);
    if (schemaVersion !== 2 && schemaVersion !== 3) {
        throw new Error(
            `Unsupported artwork provenance schema version: ${schemaVersion}.`
        );
    }
    const collections = parseEntries(
        getSection(source, "Collections", "Scripts"),
        "Collections"
    );
    const scripts = parseEntries(
        getSection(source, "Scripts", null),
        "Scripts"
    );
    for (const [scriptName, entry] of scripts) {
        const collection = entry.Collection;
        if (typeof collection !== "string" || !collections.has(collection)) {
            throw new Error(
                `Scripts.${scriptName}: unknown collection ${String(collection)}.`
            );
        }
    }
    return { collections, schemaVersion, scripts };
}

/**
 * @param {string} [filePath]
 *
 * @returns {{
 *     collections: ReadonlyMap<
 *         string,
 *         Readonly<Record<string, ProvenanceValue>>
 *     >;
 *     filePath: string;
 *     schemaVersion: number;
 *     scripts: ReadonlyMap<string, Readonly<Record<string, ProvenanceValue>>>;
 *     source: string;
 * }}
 */
function readArtworkProvenance(filePath = DEFAULT_PROVENANCE_PATH) {
    const resolvedPath = path.resolve(filePath);
    const source = fs.readFileSync(resolvedPath, "utf8");
    return {
        ...parseArtworkProvenance(source),
        filePath: resolvedPath,
        source,
    };
}

/**
 * Serialize parsed provenance without relying on PowerShell's version-specific
 * data-file limits. The PascalCase shape intentionally mirrors the
 * authoritative PSD1 so Windows PowerShell 5.1 verification can consume the
 * same parsed data.
 *
 * @param {{
 *     collections: ReadonlyMap<
 *         string,
 *         Readonly<Record<string, ProvenanceValue>>
 *     >;
 *     schemaVersion: number;
 *     scripts: ReadonlyMap<string, Readonly<Record<string, ProvenanceValue>>>;
 * }} provenance
 *
 * @returns {string}
 */
function serializeArtworkProvenanceJson(provenance) {
    return JSON.stringify({
        SchemaVersion: provenance.schemaVersion,
        Collections: Object.fromEntries(provenance.collections),
        Scripts: Object.fromEntries(provenance.scripts),
    });
}

/**
 * @param {string} [filePath]
 *
 * @returns {Readonly<Record<string, unknown>>}
 */
function readArtworkHeaderMigration(filePath = DEFAULT_HEADER_MIGRATION_PATH) {
    const parsed = JSON.parse(fs.readFileSync(path.resolve(filePath), "utf8"));
    if (
        !parsed ||
        typeof parsed !== "object" ||
        parsed.schemaVersion !== 2 ||
        parsed.provenanceSchemaVersion !== 3 ||
        parsed.unmappedHashMode !== UNMAPPED_SCRIPT_HASH_MODE ||
        !parsed.records ||
        typeof parsed.records !== "object" ||
        !parsed.unmappedScripts ||
        typeof parsed.unmappedScripts !== "object"
    ) {
        throw new Error("Artwork header migration evidence is malformed.");
    }
    return Object.freeze(parsed);
}

/**
 * Accept a review ledger's historical whole-file hash only when the migration
 * evidence proves both that exact legacy file and the exact current compact
 * file. Arbitrary old or current hashes never receive this compatibility path.
 *
 * @param {Readonly<Record<string, unknown>>} migration
 * @param {string} scriptName
 * @param {string} expectedHash
 * @param {string} currentHash
 *
 * @returns {boolean}
 */
function matchesArtworkHeaderMigrationHash(
    migration,
    scriptName,
    expectedHash,
    currentHash
) {
    if (expectedHash === currentHash) return true;
    const records = migration.records;
    if (!records || typeof records !== "object") return false;
    const record = records[scriptName];
    if (!record || typeof record !== "object") return false;
    const legacyHash = record.legacyFileSha256;
    const compactHash =
        record.currentCompactFileSha256 ?? record.compactFileSha256;
    return legacyHash === expectedHash && compactHash === currentHash;
}

/**
 * Update scalar properties in existing script entries without reserializing the
 * 40 MiB data file or changing unrelated formatting.
 *
 * @param {string} source
 * @param {ReadonlyMap<
 *     string,
 *     Readonly<Record<string, boolean | number | string>>
 * >} updates
 *
 * @returns {string}
 */
function updateArtworkProvenanceScriptProperties(source, updates) {
    const lineEnding = source.includes("\r\n") ? "\r\n" : "\n";
    const scriptsSectionStart = /^ {4}Scripts\s*=\s*@\{\r?$/mu.exec(source);
    if (!scriptsSectionStart) {
        throw new Error("Artwork provenance is missing Scripts.");
    }
    const prefixEnd = scriptsSectionStart.index + scriptsSectionStart[0].length;
    const prefix = source.slice(0, prefixEnd);
    const scriptsSection = source.slice(prefixEnd);
    const matched = new Set();
    const updatedSection = scriptsSection.replace(
        ENTRY_PATTERN,
        (block, escapedName) => {
            const name = unescapePowerShellString(escapedName);
            const entryUpdates = updates.get(name);
            if (!entryUpdates) return block;
            matched.add(name);
            let updatedBlock = block;
            /** @type {string[]} */
            const additions = [];
            for (const [property, value] of Object.entries(entryUpdates)) {
                if (!/^[A-Za-z][A-Za-z\d]*$/u.test(property)) {
                    throw new Error(
                        `${name}: unsafe provenance property ${property}.`
                    );
                }
                const serialized = serializePowerShellScalar(value);
                const expression = new RegExp(
                    String.raw`^( {12}${property}\s*=\s*).*$`,
                    "mu"
                );
                if (expression.test(updatedBlock)) {
                    updatedBlock = updatedBlock.replace(
                        expression,
                        (_match, propertyPrefix) =>
                            `${propertyPrefix}${serialized}`
                    );
                } else {
                    additions.push(`            ${property} = ${serialized}`);
                }
            }
            if (additions.length > 0) {
                const closing = `${lineEnding}        }`;
                const closingIndex = updatedBlock.lastIndexOf(closing);
                if (closingIndex < 0) {
                    throw new Error(`${name}: cannot locate entry closing.`);
                }
                updatedBlock = `${updatedBlock.slice(0, closingIndex)}${lineEnding}${additions.join(lineEnding)}${updatedBlock.slice(closingIndex)}`;
            }
            return updatedBlock;
        }
    );
    const missing = [...updates.keys()].filter((name) => !matched.has(name));
    if (missing.length > 0) {
        throw new Error(
            `Artwork provenance entries are missing: ${missing.join(", ")}.`
        );
    }
    return `${prefix}${updatedSection}`;
}

/**
 * Insert or replace complete script records while preserving collection data
 * and unrelated script-entry formatting. This is intentionally stricter than a
 * generic PSD1 writer: only the data subset understood by the shared reader can
 * be emitted.
 *
 * @param {string} source
 * @param {ReadonlyMap<string, Readonly<Record<string, ProvenanceValue>>>} entries
 *
 * @returns {string}
 */
function upsertArtworkProvenanceScriptEntries(source, entries) {
    if (entries.size === 0) return source;
    const parsed = parseArtworkProvenance(source);
    for (const [name, entry] of entries) {
        const collection = entry.Collection;
        if (
            typeof collection !== "string" ||
            !parsed.collections.has(collection)
        ) {
            throw new Error(
                `${name}: unknown collection ${String(collection)}.`
            );
        }
    }

    const lineEnding = source.includes("\r\n") ? "\r\n" : "\n";
    const scriptsSectionStart = /^ {4}Scripts\s*=\s*@\{\r?$/mu.exec(source);
    if (!scriptsSectionStart) {
        throw new Error("Artwork provenance is missing Scripts.");
    }
    const prefixEnd = scriptsSectionStart.index + scriptsSectionStart[0].length;
    const prefix = source.slice(0, prefixEnd);
    let scriptsSection = source.slice(prefixEnd);
    const matched = new Set();
    scriptsSection = scriptsSection.replace(
        ENTRY_PATTERN,
        (block, escapedName) => {
            const name = unescapePowerShellString(escapedName);
            const entry = entries.get(name);
            if (!entry) return block;
            matched.add(name);
            return serializeArtworkProvenanceEntry(name, entry, lineEnding);
        }
    );

    const additions = [...entries]
        .filter(([name]) => !matched.has(name))
        .map(([name, entry]) =>
            serializeArtworkProvenanceEntry(name, entry, lineEnding)
        );
    if (additions.length > 0) {
        const closingPattern = /\r?\n {4}\}\r?\n\}\s*$/u;
        const closing = closingPattern.exec(scriptsSection);
        if (!closing) {
            throw new Error("Artwork provenance Scripts closing is malformed.");
        }
        scriptsSection = `${scriptsSection.slice(0, closing.index)}${lineEnding}${additions.join(
            lineEnding
        )}${scriptsSection.slice(closing.index)}`;
    }

    const updated = `${prefix}${scriptsSection}`;
    const reparsed = parseArtworkProvenance(updated);
    for (const name of entries.keys()) {
        if (!reparsed.scripts.has(name)) {
            throw new Error(
                `${name}: provenance upsert did not persist the entry.`
            );
        }
    }
    return updated;
}

/**
 * @param {string} scriptName
 *
 * @returns {string}
 */
function getArtworkDetailsUrl(scriptName) {
    if (!/^[a-z0-9][a-z0-9-]*$/u.test(scriptName)) {
        throw new Error(`Unsafe artwork script name: ${scriptName}.`);
    }
    return `${ARTWORK_DETAILS_BASE_URL}${encodeURIComponent(scriptName)}`;
}

/**
 * @param {Readonly<Record<string, ProvenanceValue>>} entry
 *
 * @returns {string}
 */
function getArtworkTitle(entry) {
    for (const property of [
        "SauceTitle",
        "ConvertedFrom",
        "OriginalFilename",
        "SourceFile",
    ]) {
        const value = entry[property];
        if (typeof value === "string" && value.trim()) {
            return property === "SourceFile"
                ? path.basename(value.replaceAll("\\", "/"))
                : value.trim();
        }
    }
    throw new Error("Artwork provenance entry has no usable title.");
}

/**
 * @param {Readonly<Record<string, ProvenanceValue>>} entry
 * @param {Readonly<Record<string, ProvenanceValue>> | null} [collection]
 *
 * @returns {string}
 */
function getArtworkArtist(entry, collection = null) {
    for (const value of [
        entry.Artist,
        entry.Attribution,
        collection?.Attribution,
    ]) {
        if (typeof value === "string" && value.trim()) return value.trim();
    }
    throw new Error(
        "Artwork provenance entry has no usable artist attribution."
    );
}

/**
 * @param {unknown} value
 * @param {string} label
 *
 * @returns {string}
 */
function sanitizeCompactHeaderValue(value, label) {
    if (typeof value !== "string") {
        throw new TypeError(`${label} must be a string.`);
    }
    const sanitized = value
        .replace(/[\r\n\u0085\u2028\u2029]/gu, " ")
        .replace(/[\u0000-\u001f\u007f]/gu, "")
        .replaceAll("|", "/")
        .replace(/\s+/gu, " ")
        .trim();
    if (!sanitized) throw new Error(`${label} must not be empty.`);
    return sanitized;
}

/**
 * @param {string} scriptName
 * @param {Readonly<Record<string, ProvenanceValue>>} entry
 * @param {Readonly<Record<string, ProvenanceValue>> | null} [collection]
 *
 * @returns {string}
 */
function buildCompactArtworkHeader(scriptName, entry, collection = null) {
    const title = sanitizeCompactHeaderValue(
        getArtworkTitle(entry),
        "Artwork title"
    );
    const artist = sanitizeCompactHeaderValue(
        getArtworkArtist(entry, collection),
        "Artwork artist"
    );
    return `# Artwork: ${title} by ${artist} | Details: ${getArtworkDetailsUrl(scriptName)}`;
}

/**
 * @param {string} line
 *
 * @returns {{ artist: string; title: string; url: string } | null}
 */
function parseCompactArtworkHeader(line) {
    const match = COMPACT_HEADER_PATTERN.exec(line);
    return match?.groups
        ? {
              artist: match.groups.artist,
              title: match.groups.title,
              url: match.groups.url,
          }
        : null;
}

/**
 * @param {string} source
 *
 * @returns {{
 *     body: string;
 *     bodyStart: number;
 *     fields: ReadonlyMap<string, string>;
 *     header: string;
 *     lineEnding: "\n" | "\r\n";
 *     prefix: string;
 * } | null}
 */
function parseLeadingCommentHeader(source) {
    const match =
        /^(?<bom>\uFEFF?)(?<header>(?:#[^\r\n]*(?:\r?\n|$))+)\r?\n/u.exec(
            source
        );
    if (!match?.groups) return null;
    const fields = new Map();
    for (const line of match.groups.header
        .replace(/\r?\n$/u, "")
        .split(/\r?\n/u)) {
        const fieldMatch = /^# ([^:]+):\s?(.*)$/u.exec(line);
        if (!fieldMatch) continue;
        if (fields.has(fieldMatch[1])) {
            throw new Error(`Duplicate script header field: ${fieldMatch[1]}.`);
        }
        fields.set(fieldMatch[1], fieldMatch[2]);
    }
    return {
        body: source.slice(match[0].length),
        bodyStart: match[0].length,
        fields,
        header: match.groups.header,
        lineEnding: match.groups.header.includes("\r\n") ? "\r\n" : "\n",
        prefix: match.groups.bom,
    };
}

/**
 * @param {string | Buffer} value
 *
 * @returns {string}
 */
function sha256(value) {
    return crypto.createHash("sha256").update(value).digest("hex");
}

module.exports = {
    ARTWORK_DETAILS_BASE_URL,
    DEFAULT_HEADER_MIGRATION_PATH,
    DEFAULT_PROVENANCE_PATH,
    UNMAPPED_SCRIPT_HASH_MODE,
    buildCompactArtworkHeader,
    escapePowerShellString,
    getArtworkArtist,
    getArtworkDetailsUrl,
    getArtworkTitle,
    parseArtworkProvenance,
    parseCompactArtworkHeader,
    parseLeadingCommentHeader,
    readArtworkHeaderMigration,
    readArtworkProvenance,
    sanitizeCompactHeaderValue,
    serializeArtworkProvenanceJson,
    serializeArtworkProvenanceEntry,
    serializePowerShellScalar,
    serializePowerShellValue,
    sha256,
    matchesArtworkHeaderMigrationHash,
    upsertArtworkProvenanceScriptEntries,
    updateArtworkProvenanceScriptProperties,
};
