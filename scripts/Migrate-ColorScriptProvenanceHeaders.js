#!/usr/bin/env node
"use strict";
// @ts-check

const fs = require("node:fs");
const path = require("node:path");

const {
    DEFAULT_PROVENANCE_PATH,
    UNMAPPED_SCRIPT_HASH_MODE,
    buildCompactArtworkHeader,
    escapePowerShellString,
    getArtworkDetailsUrl,
    parseCompactArtworkHeader,
    parseLeadingCommentHeader,
    readArtworkProvenance,
    sha256,
} = require("./ArtworkProvenance.js");

const REPOSITORY_ROOT = path.resolve(__dirname, "..");
const SCRIPTS_DIRECTORY = path.join(
    REPOSITORY_ROOT,
    "ColorScripts-Enhanced",
    "Scripts"
);
const MIGRATION_MANIFEST_PATH = path.join(
    REPOSITORY_ROOT,
    "audit",
    "ArtworkHeaderMigration.json"
);
const ENTRY_PATTERN =
    /^ {8}'((?:[^']|'')+)'\s*=\s*@\{\r?\n[\s\S]*?^ {8}\}\r?$/gmu;
const KNOWN_VERBOSE_FIELDS = new Set([
    "Columns",
    "Converted from",
    "Lines",
    "SAUCE Author",
    "SAUCE Comments",
    "SAUCE Date",
    "SAUCE Dimensions",
    "SAUCE Font",
    "SAUCE Group",
    "SAUCE Title",
    "Source Attribution",
    "Source Conversion Mode",
    "Source License",
    "Source Modification",
    "Source Revision",
    "Source SHA-256",
    "Source URL",
    "Source encoding",
]);

/** @typedef {boolean | number | string | readonly string[]} ProvenanceValue */
const HEADER_FIELD_TO_PROVENANCE = new Map([
    ["Columns", "SourceColumns"],
    ["Converted from", "ConvertedFrom"],
    ["Lines", "SourceRows"],
    ["SAUCE Author", "SauceAuthor"],
    ["SAUCE Comments", "SauceComments"],
    ["SAUCE Date", "SauceDate"],
    ["SAUCE Dimensions", "SauceDimensions"],
    ["SAUCE Font", "SauceFont"],
    ["SAUCE Group", "SauceGroup"],
    ["SAUCE Title", "SauceTitle"],
    ["Source Conversion Mode", "ConversionMode"],
    ["Source Modification", "SourceModification"],
    ["Source Revision", "SourceRevision"],
    ["Source SHA-256", "SourceSha256"],
    ["Source URL", "SourceUrl"],
    ["Source encoding", "SourceEncoding"],
]);

/**
 * @param {string} filePath
 * @param {string} content
 *
 * @returns {void}
 */
function writeFileAtomic(filePath, content) {
    const temporaryPath = `${filePath}.${process.pid}.tmp`;
    try {
        fs.writeFileSync(temporaryPath, content, "utf8");
        fs.renameSync(temporaryPath, filePath);
    } finally {
        if (fs.existsSync(temporaryPath)) fs.rmSync(temporaryPath);
    }
}

/**
 * Hash a PowerShell text file independently of Git's platform-specific LF to
 * CRLF checkout conversion. All bytes other than CRLF pairs remain exact.
 *
 * @param {Buffer} buffer
 *
 * @returns {string}
 */
function getUnmappedScriptSha256(buffer) {
    let crlfCount = 0;
    for (let index = 0; index < buffer.length - 1; index += 1) {
        if (buffer[index] === 0x0d && buffer[index + 1] === 0x0a) {
            crlfCount += 1;
            index += 1;
        }
    }
    if (crlfCount === 0) return sha256(buffer);

    const normalized = Buffer.allocUnsafe(buffer.length - crlfCount);
    let outputIndex = 0;
    for (let index = 0; index < buffer.length; index += 1) {
        if (
            buffer[index] === 0x0d &&
            index + 1 < buffer.length &&
            buffer[index + 1] === 0x0a
        ) {
            normalized[outputIndex] = 0x0a;
            outputIndex += 1;
            index += 1;
            continue;
        }
        normalized[outputIndex] = buffer[index];
        outputIndex += 1;
    }
    return sha256(normalized);
}

/**
 * @param {Readonly<Record<string, string>>} expected
 * @param {Readonly<Record<string, string>>} current
 *
 * @returns {void}
 */
function assertUnmappedScriptsUnchanged(expected, current) {
    const expectedNames = Object.keys(expected);
    const currentNames = Object.keys(current);
    if (
        expectedNames.length !== currentNames.length ||
        expectedNames.some((name) => !Object.hasOwn(current, name))
    ) {
        throw new Error("Unmapped legacy script inventory has changed.");
    }
    for (const [name, expectedHash] of Object.entries(expected)) {
        if (current[name] !== expectedHash) {
            throw new Error(`${name}: unmapped legacy script has changed.`);
        }
    }
}

/**
 * @param {ReadonlyMap<string, string>} fields
 *
 * @returns {string}
 */
function getFieldsSha256(fields) {
    return sha256(
        JSON.stringify(
            Object.fromEntries(
                [...fields].sort(([left], [right]) =>
                    left.localeCompare(right, "en-US")
                )
            )
        )
    );
}

/**
 * @param {Readonly<Record<string, ProvenanceValue>>} entry
 * @param {Readonly<Record<string, ProvenanceValue>>} collection
 * @param {string} fieldName
 *
 * @returns {string | null}
 */
function getProvenanceHeaderValue(entry, collection, fieldName) {
    if (fieldName === "Source License") {
        return typeof collection.License === "string"
            ? collection.License
            : null;
    }
    if (fieldName === "Source Attribution") {
        const value = entry.Attribution ?? collection.Attribution;
        return typeof value === "string" ? value : null;
    }
    const property = HEADER_FIELD_TO_PROVENANCE.get(fieldName);
    if (!property) return null;
    const value = entry[property];
    if (typeof value === "string") return value;
    return typeof value === "number" || typeof value === "boolean"
        ? String(value)
        : null;
}

/**
 * @param {Readonly<Record<string, ProvenanceValue>>} entry
 * @param {Readonly<Record<string, ProvenanceValue>>} collection
 * @param {readonly string[]} fieldNames
 *
 * @returns {ReadonlyMap<string, string>}
 */
function reconstructLegacyFields(entry, collection, fieldNames) {
    const fields = new Map();
    for (const fieldName of fieldNames) {
        const value = getProvenanceHeaderValue(entry, collection, fieldName);
        if (value === null) {
            throw new Error(
                `Provenance cannot reconstruct legacy header field ${fieldName}.`
            );
        }
        fields.set(fieldName, value);
    }
    return fields;
}

/**
 * @param {string} source
 * @param {Map<string, Readonly<Record<string, string>>>} additionsByScript
 *
 * @returns {string}
 */
function addProvenanceProperties(source, additionsByScript) {
    const lineEnding = source.includes("\r\n") ? "\r\n" : "\n";
    let matched = 0;
    const updated = source.replace(ENTRY_PATTERN, (block, escapedName) => {
        const name = escapedName.replaceAll("''", "'");
        const additions = additionsByScript.get(name);
        if (!additions || Object.keys(additions).length === 0) return block;
        matched += 1;
        const closing = `${lineEnding}        }`;
        const closingIndex = block.lastIndexOf(closing);
        if (closingIndex < 0) {
            throw new Error(`${name}: cannot locate provenance entry closing.`);
        }
        const serialized = Object.entries(additions)
            .map(
                ([property, value]) =>
                    `            ${property} = '${escapePowerShellString(value)}'`
            )
            .join(lineEnding);
        return `${block.slice(0, closingIndex)}${lineEnding}${serialized}${block.slice(closingIndex)}`;
    });
    const expected = [...additionsByScript.values()].filter(
        (entry) => Object.keys(entry).length > 0
    ).length;
    if (matched !== expected) {
        throw new Error(
            `Updated ${matched} provenance entries; expected ${expected}.`
        );
    }
    return updated.replace(
        /^( {4}SchemaVersion\s*=\s*)2(\s*)$/mu,
        (_match, prefix, suffix) => `${prefix}3${suffix}`
    );
}

/**
 * @param {string} name
 * @param {ReadonlyMap<string, string>} fields
 * @param {Readonly<Record<string, ProvenanceValue>>} entry
 * @param {Readonly<Record<string, ProvenanceValue>>} collection
 *
 * @returns {Readonly<Record<string, string>>}
 */
function getMissingProvenanceProperties(name, fields, entry, collection) {
    /** @type {Record<string, string>} */
    const additions = {};
    for (const [fieldName, fieldValue] of fields) {
        if (!KNOWN_VERBOSE_FIELDS.has(fieldName)) {
            throw new Error(
                `${name}: unknown verbose header field ${fieldName}.`
            );
        }
        const property = HEADER_FIELD_TO_PROVENANCE.get(fieldName);
        if (!property) {
            const expected = getProvenanceHeaderValue(
                { ...entry, ...additions },
                collection,
                fieldName
            );
            if (expected !== fieldValue) {
                throw new Error(
                    `${name}: ${fieldName} disagrees with collection provenance.`
                );
            }
            continue;
        }
        const existing = entry[property];
        if (existing === undefined) {
            additions[property] = fieldValue;
        } else if (String(existing) !== fieldValue) {
            throw new Error(
                `${name}: ${fieldName} disagrees with ${property}.`
            );
        }
    }
    return Object.freeze(additions);
}

/**
 * @param {string[]} argv
 *
 * @returns {{ check: boolean; write: boolean }}
 */
function parseArguments(argv) {
    const options = { check: false, write: false };
    for (const argument of argv) {
        if (argument === "--check") options.check = true;
        else if (argument === "--write") options.write = true;
        else throw new Error(`Unknown argument: ${argument}.`);
    }
    if (options.check && options.write) {
        throw new Error("--check and --write cannot be combined.");
    }
    return options;
}

/**
 * @param {string} name
 * @param {Buffer} buffer
 * @param {{ header: string; body: string }} parsed
 * @param {Readonly<Record<string, ProvenanceValue>>} entry
 * @param {Readonly<Record<string, ProvenanceValue>>} collection
 * @param {Record<string, unknown> | undefined} manifestRecord
 *
 * @returns {Record<string, unknown> | null}
 */
function validateCompactScript(
    name,
    buffer,
    parsed,
    entry,
    collection,
    manifestRecord
) {
    const compactLine = parsed.header.replace(/\r?\n$/u, "");
    const expectedHeader = buildCompactArtworkHeader(name, entry, collection);
    if (compactLine !== expectedHeader) {
        throw new Error(`${name}: compact header has drifted.`);
    }
    if (!manifestRecord) {
        if (entry.HeaderFormat !== "CompactV1") {
            throw new Error(
                `${name}: compact script lacks migration evidence or a generated-header marker.`
            );
        }
        return null;
    }
    const currentFileSha256 =
        manifestRecord.currentCompactFileSha256 ||
        manifestRecord.compactFileSha256;
    const currentPayloadSha256 =
        manifestRecord.currentPayloadSha256 || manifestRecord.payloadSha256;
    if (sha256(buffer) !== currentFileSha256) {
        throw new Error(`${name}: compact file hash has drifted.`);
    }
    if (sha256(parsed.body) !== currentPayloadSha256) {
        throw new Error(`${name}: PowerShell payload has drifted.`);
    }
    const reconstructed = reconstructLegacyFields(
        entry,
        collection,
        manifestRecord.fieldNames
    );
    if (getFieldsSha256(reconstructed) !== manifestRecord.legacyFieldsSha256) {
        throw new Error(`${name}: external provenance lost legacy fields.`);
    }
    return manifestRecord;
}

/**
 * @param {string} name
 * @param {Buffer} buffer
 * @param {{
 *     prefix: string;
 *     header: string;
 *     lineEnding: string;
 *     body: string;
 *     fields: Map<string, string>;
 * }} parsed
 * @param {Readonly<Record<string, ProvenanceValue>>} entry
 * @param {Readonly<Record<string, ProvenanceValue>>} collection
 * @param {{ check: boolean; write: boolean }} options
 */
function prepareVerboseMigration(
    name,
    buffer,
    parsed,
    entry,
    collection,
    options
) {
    if (!parsed.fields.has("Source URL")) {
        throw new Error(`${name}: imported script has no verbose provenance.`);
    }
    if (options.check) {
        throw new Error(`${name}: verbose archival header is still present.`);
    }
    const additions = getMissingProvenanceProperties(
        name,
        parsed.fields,
        entry,
        collection
    );
    const augmentedEntry = Object.freeze({ ...entry, ...additions });
    const reconstructed = reconstructLegacyFields(augmentedEntry, collection, [
        ...parsed.fields.keys(),
    ]);
    const legacyFieldsSha256 = getFieldsSha256(parsed.fields);
    if (getFieldsSha256(reconstructed) !== legacyFieldsSha256) {
        throw new Error(`${name}: provenance cannot reproduce legacy fields.`);
    }
    const header = buildCompactArtworkHeader(name, augmentedEntry, collection);
    const updatedSource = `${parsed.prefix}${header}${parsed.lineEnding}${parsed.lineEnding}${parsed.body}`;
    if (!updatedSource.endsWith(parsed.body)) {
        throw new Error(`${name}: migration changed content after the header.`);
    }
    return {
        additions,
        updatedSource,
        record: {
            compactFileSha256: sha256(Buffer.from(updatedSource, "utf8")),
            detailsUrl: getArtworkDetailsUrl(name),
            fieldNames: [...parsed.fields.keys()],
            legacyFieldsSha256,
            legacyFileSha256: sha256(buffer),
            legacyHeaderSha256: sha256(parsed.header),
            payloadSha256: sha256(parsed.body),
        },
    };
}

/**
 * @param {string} fileName
 * @param {ReturnType<typeof readArtworkProvenance>} provenance
 * @param {Record<string, unknown> | null} existingManifest
 * @param {{ check: boolean; write: boolean }} options
 */
function inspectMigrationScript(
    fileName,
    provenance,
    existingManifest,
    options
) {
    const name = fileName.slice(0, -4);
    const filePath = path.join(SCRIPTS_DIRECTORY, fileName);
    const buffer = fs.readFileSync(filePath);
    const entry = provenance.scripts.get(name);
    if (!entry) {
        return {
            mapped: false,
            name,
            rawHash: sha256(buffer),
            normalizedHash: getUnmappedScriptSha256(buffer),
        };
    }
    const collection =
        typeof entry.Collection === "string"
            ? provenance.collections.get(entry.Collection)
            : null;
    if (!collection) throw new Error(`${name}: collection is missing.`);
    const parsed = parseLeadingCommentHeader(buffer.toString("utf8"));
    if (!parsed) throw new Error(`${name}: leading header is missing.`);
    const compact = parseCompactArtworkHeader(
        parsed.header.replace(/\r?\n$/u, "")
    );
    if (compact) {
        const record = validateCompactScript(
            name,
            buffer,
            parsed,
            entry,
            collection,
            existingManifest?.records?.[name]
        );
        return { mapped: true, name, record };
    }
    return {
        mapped: true,
        name,
        filePath,
        ...prepareVerboseMigration(
            name,
            buffer,
            parsed,
            entry,
            collection,
            options
        ),
    };
}

/**
 * @param {Record<string, unknown> | null} existingManifest
 * @param {{ write: boolean }} options
 * @param {Record<string, string>} unmappedScripts
 * @param {Record<string, string>} rawUnmappedScripts
 */
function validateExistingMigrationManifest(
    existingManifest,
    options,
    unmappedScripts,
    rawUnmappedScripts
) {
    if (!existingManifest) return;
    const existingHashMode = existingManifest.unmappedHashMode;
    if (
        existingHashMode !== undefined &&
        existingHashMode !== UNMAPPED_SCRIPT_HASH_MODE
    ) {
        throw new Error(
            `Unsupported unmapped-script hash mode: ${JSON.stringify(existingHashMode)}.`
        );
    }
    if (existingHashMode === undefined && !options.write) {
        throw new Error(
            "Migration evidence uses platform-dependent unmapped-script hashes; rerun with --write to upgrade it."
        );
    }
    const currentHashes =
        existingHashMode === UNMAPPED_SCRIPT_HASH_MODE
            ? unmappedScripts
            : rawUnmappedScripts;
    assertUnmappedScriptsUnchanged(
        existingManifest.unmappedScripts || {},
        currentHashes
    );
}

/**
 * @param {number} validatedMappedScripts
 * @param {ReadonlyMap<string, Readonly<Record<string, string>>>} additionsByScript
 * @param {ReadonlyMap<string, string>} rewrites
 * @param {Record<string, Record<string, unknown>>} records
 * @param {Record<string, string>} unmappedScripts
 */
function reportMigrationSummary(
    validatedMappedScripts,
    additionsByScript,
    rewrites,
    records,
    unmappedScripts
) {
    const provenancePropertiesAdded = [...additionsByScript.values()].reduce(
        (total, additions) => total + Object.keys(additions).length,
        0
    );
    console.log(
        JSON.stringify(
            {
                mappedScripts: validatedMappedScripts,
                generatedCompactScripts:
                    validatedMappedScripts - Object.keys(records).length,
                provenancePropertiesAdded,
                scriptsToRewrite: rewrites.size,
                unmappedScripts: Object.keys(unmappedScripts).length,
            },
            null,
            2
        )
    );
}

/**
 * @param {string[]} [argv]
 *
 * @returns {void}
 */
function main(argv = process.argv.slice(2)) {
    const options = parseArguments(argv);
    const provenance = readArtworkProvenance(DEFAULT_PROVENANCE_PATH);
    const existingManifest = fs.existsSync(MIGRATION_MANIFEST_PATH)
        ? JSON.parse(fs.readFileSync(MIGRATION_MANIFEST_PATH, "utf8"))
        : null;
    const scriptFiles = fs
        .readdirSync(SCRIPTS_DIRECTORY)
        .filter((name) => name.endsWith(".ps1"))
        .sort((left, right) => left.localeCompare(right, "en-US"));
    const additionsByScript = new Map();
    const rewrites = new Map();
    /** @type {Record<string, Record<string, unknown>>} */
    const records = {};
    /** @type {Record<string, string>} */
    const unmappedScripts = {};
    /** @type {Record<string, string>} */
    const rawUnmappedScripts = {};
    let validatedMappedScripts = 0;

    for (const fileName of scriptFiles) {
        const result = inspectMigrationScript(
            fileName,
            provenance,
            existingManifest,
            options
        );
        if (!result.mapped) {
            rawUnmappedScripts[result.name] = result.rawHash;
            unmappedScripts[result.name] = result.normalizedHash;
            continue;
        }
        validatedMappedScripts += 1;
        if (result.record) records[result.name] = result.record;
        if (result.additions) {
            additionsByScript.set(result.name, result.additions);
            rewrites.set(result.filePath, result.updatedSource);
        }
    }

    if (provenance.scripts.size !== validatedMappedScripts) {
        throw new Error(
            `Validated ${validatedMappedScripts} mapped scripts; expected ${provenance.scripts.size}.`
        );
    }
    validateExistingMigrationManifest(
        existingManifest,
        options,
        unmappedScripts,
        rawUnmappedScripts
    );
    const manifest = {
        schemaVersion: 2,
        provenanceSchemaVersion: 3,
        unmappedHashMode: UNMAPPED_SCRIPT_HASH_MODE,
        records,
        unmappedScripts,
    };
    const manifestSource = `${JSON.stringify(manifest, null, 2)}\n`;

    reportMigrationSummary(
        validatedMappedScripts,
        additionsByScript,
        rewrites,
        records,
        unmappedScripts
    );
    if (!options.write) return;

    const updatedProvenance = addProvenanceProperties(
        provenance.source,
        additionsByScript
    );
    writeFileAtomic(DEFAULT_PROVENANCE_PATH, updatedProvenance);
    writeFileAtomic(MIGRATION_MANIFEST_PATH, manifestSource);
    for (const [filePath, updatedSource] of rewrites) {
        writeFileAtomic(filePath, updatedSource);
    }
    console.log("Compact artwork provenance headers written.");
}

if (require.main === module) main();

module.exports = {
    addProvenanceProperties,
    assertUnmappedScriptsUnchanged,
    getFieldsSha256,
    getMissingProvenanceProperties,
    getProvenanceHeaderValue,
    getUnmappedScriptSha256,
    main,
    parseArguments,
    reconstructLegacyFields,
};
