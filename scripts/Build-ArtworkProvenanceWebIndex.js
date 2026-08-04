#!/usr/bin/env node
"use strict";
// @ts-check

const fs = require("node:fs");
const path = require("node:path");

const {
    DEFAULT_PROVENANCE_PATH,
    getArtworkArtist,
    getArtworkTitle,
    readArtworkProvenance,
} = require("./ArtworkProvenance.js");

const REPOSITORY_ROOT = path.resolve(__dirname, "..");
const OUTPUT_PATH = path.join(
    REPOSITORY_ROOT,
    "docs",
    "assets",
    "artwork-provenance.json"
);
const WEB_FIELDS = Object.freeze([
    "Collection",
    "Title",
    "Artist",
    "Group",
    "Pack",
    "OriginalFilename",
    "ArtworkDate",
    "ArtworkYear",
    "Attribution",
    "SourceUrl",
    "GalleryUrl",
    "PreviewUrl",
    "ArchiveUrl",
    "SourceRevision",
    "SourceSha256",
    "RenderSha256",
    "NormalizedRenderSha256",
    "InputEncoding",
    "ConversionMode",
    "SourceRows",
    "SourceColumns",
    "SourceModification",
    "SauceTitle",
    "SauceAuthor",
    "SauceGroup",
    "SauceDate",
    "SauceDimensions",
    "SauceFont",
    "SauceComments",
    "IceColors",
]);

/** @typedef {boolean | number | string | readonly string[]} ProvenanceValue */

/**
 * @param {{
 *     collections: ReadonlyMap<
 *         string,
 *         Readonly<Record<string, ProvenanceValue>>
 *     >;
 *     scripts: ReadonlyMap<string, Readonly<Record<string, ProvenanceValue>>>;
 * }} provenance
 *
 * @returns {Record<string, unknown>}
 */
function buildWebIndex(provenance) {
    /** @type {Record<string, Record<string, ProvenanceValue>>} */
    const collections = {};
    for (const [name, collection] of provenance.collections) {
        collections[name] = {
            DisplayName: collection.DisplayName,
            ProjectUrl: collection.ProjectUrl,
            License: collection.License,
            LicenseEvidence: collection.LicenseEvidence,
            Attribution: collection.Attribution,
        };
    }
    /** @type {Record<string, (ProvenanceValue | null)[]>} */
    const scripts = {};
    for (const [name, entry] of [...provenance.scripts].sort(
        ([left], [right]) => left.localeCompare(right, "en-US")
    )) {
        const collectionName = entry.Collection;
        const collection =
            typeof collectionName === "string"
                ? provenance.collections.get(collectionName)
                : null;
        if (!collection) throw new Error(`${name}: collection is missing.`);
        const values = {
            ...entry,
            Title: getArtworkTitle(entry),
            Artist: getArtworkArtist(entry, collection),
        };
        scripts[name] = WEB_FIELDS.map((field) => values[field] ?? null);
    }
    return {
        schemaVersion: 1,
        source: "audit/ArtworkProvenance.psd1",
        fields: WEB_FIELDS,
        collections,
        scripts,
    };
}

/**
 * @param {string[]} [argv]
 *
 * @returns {void}
 */
function main(argv = process.argv.slice(2)) {
    const write = argv.includes("--write");
    if (argv.some((argument) => argument !== "--write")) {
        throw new Error(`Unknown argument: ${argv.join(" ")}.`);
    }
    const index = buildWebIndex(readArtworkProvenance(DEFAULT_PROVENANCE_PATH));
    const output = `${JSON.stringify(index)}\n`;
    if (!write) {
        if (!fs.existsSync(OUTPUT_PATH)) {
            throw new Error(`Artwork web index is missing: ${OUTPUT_PATH}.`);
        }
        const current = fs.readFileSync(OUTPUT_PATH, "utf8");
        if (current !== output) {
            throw new Error(
                "Artwork web index is stale. Run this command with --write."
            );
        }
        console.log("Artwork web index is current.");
        return;
    }
    fs.mkdirSync(path.dirname(OUTPUT_PATH), { recursive: true });
    fs.writeFileSync(OUTPUT_PATH, output, "utf8");
    console.log(`Artwork web index written: ${OUTPUT_PATH}`);
}

if (require.main === module) main();

module.exports = { WEB_FIELDS, buildWebIndex, main };
