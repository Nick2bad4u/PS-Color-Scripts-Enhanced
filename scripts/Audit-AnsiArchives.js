#!/usr/bin/env node
"use strict";
// @ts-check

const crypto = require("node:crypto");
const fs = require("node:fs");
const path = require("node:path");
const zlib = require("node:zlib");
const iconv = require("iconv-lite");
const {
    convertAnsiToPs1,
    decodeDosAnsi,
    getSauceFontName,
    resolveSauceEncoding,
    stripSauce,
    truncateDosAnsiAtEof,
    MAX_INPUT_BYTES,
    MAX_TERMINAL_COLUMNS,
} = require("./Convert-AnsiToColorScript.js");
const { extractLinesFromPs1 } = require("./Split-AnsiFile.js");
const { readArtworkProvenance } = require("./ArtworkProvenance.js");

const SIXTEEN_COLORS_API = "https://api.16colo.rs/v1";
const SIXTEEN_COLORS_SITE = "https://16colo.rs";
const ROY_DOWNLOADS_URL = "https://www.roysac.com/roy-sac_downloads_links.html";
const USER_AGENT =
    "ps-color-scripts-enhanced/ansi-curation (+https://github.com/Nick2bad4u/ps-color-scripts-enhanced)";
const DEFAULT_CACHE_DIR = path.resolve(
    __dirname,
    "..",
    "temp",
    "ansi-archive-audit"
);
const SUPPORTED_EXTENSIONS = new Set([".ans", ".ice"]);
const MAX_ZIP_ENTRIES = 20_000;
const MAX_ZIP_UNCOMPRESSED_BYTES = 512 * 1024 * 1024;
const ARCHIVE_REQUEST_TIMEOUT_MS = 5 * 60_000;
const MIXED_MEDIA_ARCHIVE_THRESHOLD_BYTES = 32 * 1024 * 1024;
const MAX_LOCAL_PREVIEW_CELLS = 250_000;
const DECISION_SCHEMA_VERSION = 2;
const SHA256_PATTERN = /^[a-f\d]{64}$/u;
const ANSI_FAMILY_NAMES = [
    "neutral",
    "red",
    "green",
    "yellow",
    "blue",
    "magenta",
    "cyan",
    "neutral",
];
const ANSI_PREVIEW_PALETTE = [
    "#000000",
    "#aa0000",
    "#00aa00",
    "#aa5500",
    "#0000aa",
    "#aa00aa",
    "#00aaaa",
    "#aaaaaa",
    "#555555",
    "#ff5555",
    "#55ff55",
    "#ffff55",
    "#5555ff",
    "#ff55ff",
    "#55ffff",
    "#ffffff",
];

/** @typedef {"16colors" | "roy" | "all"} AuditSource */

/**
 * @typedef {Object} AuditOptions
 *
 * @property {AuditSource} source
 * @property {string} cacheDir
 * @property {string} reportPath
 * @property {string} htmlPath
 * @property {string | null} checkpointPath
 * @property {string | null} decisionsPath
 * @property {string[]} excludedExistingManifestPaths
 * @property {boolean} offline
 * @property {boolean} metadataOnly
 * @property {number} concurrency
 * @property {number} pageSize
 * @property {number | null} limitPacks
 * @property {number | null} year
 * @property {string[]} packs
 */

/**
 * @typedef {Object} ZipEntry
 *
 * @property {string} name
 * @property {number} flags
 * @property {number} compressionMethod
 * @property {number} crc32
 * @property {number} compressedSize
 * @property {number} uncompressedSize
 * @property {number} localHeaderOffset
 */

/**
 * @param {Buffer | string} value
 *
 * @returns {string}
 */
function sha256(value) {
    return crypto.createHash("sha256").update(value).digest("hex");
}

/**
 * @param {string} value
 *
 * @returns {string}
 */
function safePathSegment(value) {
    const normalized = value
        .normalize("NFKD")
        .replace(/[^a-z0-9._-]+/giu, "-")
        .replace(/-+/gu, "-")
        .replace(/^-|-$/gu, "");
    return normalized || sha256(value).slice(0, 16);
}

/**
 * @param {unknown} value
 * @param {string} label
 *
 * @returns {Record<string, unknown>}
 */
function requireObject(value, label) {
    if (!value || typeof value !== "object" || Array.isArray(value)) {
        throw new TypeError(`${label} must be a JSON object.`);
    }
    return /** @type {Record<string, unknown>} */ (value);
}

/**
 * @param {unknown} value
 * @param {string} label
 *
 * @returns {unknown[]}
 */
function requireArray(value, label) {
    if (!Array.isArray(value)) {
        throw new TypeError(`${label} must be a JSON array.`);
    }
    return value;
}

/**
 * @param {unknown} value
 * @param {string} label
 *
 * @returns {string}
 */
function requireString(value, label) {
    if (typeof value !== "string" || value.length === 0) {
        throw new TypeError(`${label} must be a non-empty string.`);
    }
    return value;
}

/**
 * @param {unknown} value
 * @param {string} label
 * @param {string} [fallback]
 *
 * @returns {string}
 */
function readOptionalString(value, label, fallback = "") {
    if (value === undefined || value === null || value === "") {
        return fallback;
    }
    return requireString(value, label);
}

/**
 * @param {unknown} value
 * @param {string} label
 * @param {number} minimum
 *
 * @returns {number}
 */
function requireSafeInteger(value, label, minimum = 0) {
    if (!Number.isSafeInteger(value) || Number(value) < minimum) {
        throw new TypeError(
            `${label} must be an integer greater than or equal to ${minimum}.`
        );
    }
    return Number(value);
}

/**
 * The API serializes all-digit pack identifiers as JSON numbers. Preserve their
 * canonical textual form without accepting arbitrary coercions.
 *
 * @param {unknown} value
 *
 * @returns {string}
 */
function requirePackName(value) {
    if (typeof value === "string" && value.length > 0) {
        return value;
    }
    if (Number.isSafeInteger(value) && Number(value) >= 0) {
        return Number(value).toString();
    }
    throw new TypeError(
        "16colors pack name must be a non-empty string or integer."
    );
}

/**
 * @param {string[]} argv
 *
 * @returns {AuditOptions}
 */
function createAuditOptions() {
    /** @type {AuditOptions} */
    return {
        source: "all",
        cacheDir: DEFAULT_CACHE_DIR,
        reportPath: path.join(DEFAULT_CACHE_DIR, "report.json"),
        htmlPath: path.join(DEFAULT_CACHE_DIR, "review.html"),
        checkpointPath: null,
        decisionsPath: null,
        excludedExistingManifestPaths: [],
        offline: false,
        metadataOnly: false,
        concurrency: 4,
        pageSize: 500,
        limitPacks: null,
        year: null,
        packs: [],
    };
}

/**
 * @param {AuditOptions} options
 * @param {{ htmlWasSet: boolean; reportWasSet: boolean }} state
 * @param {string} argument
 */
function applyAuditArgument(options, state, argument) {
    if (argument === "--offline") {
        options.offline = true;
        return;
    }
    if (argument === "--metadata-only") {
        options.metadataOnly = true;
        return;
    }
    if (argument === "--help" || argument === "-h") {
        printHelp();
        process.exit(0);
    }
    const optionMatch = /^--([^=]+)=(.*)$/u.exec(argument);
    if (!optionMatch) throw new Error(`Unknown option: ${argument}`);
    const [
        ,
        optionName,
        value,
    ] = optionMatch;
    switch (optionName) {
        case "source": {
            const source = value;
            if (source !== "16colors" && source !== "roy" && source !== "all") {
                throw new Error("--source must be 16colors, roy, or all.");
            }
            options.source = source;
            return;
        }
        case "cache-dir":
            options.cacheDir = path.resolve(value);
            return;
        case "report":
            options.reportPath = path.resolve(value);
            state.reportWasSet = true;
            return;
        case "html":
            options.htmlPath = path.resolve(value);
            state.htmlWasSet = true;
            return;
        case "checkpoint":
            options.checkpointPath = path.resolve(value);
            return;
        case "decisions":
            options.decisionsPath = path.resolve(value);
            return;
        case "exclude-existing-manifest": {
            const manifestPath = value.trim();
            if (!manifestPath) {
                throw new Error(
                    "--exclude-existing-manifest must name an import manifest."
                );
            }
            options.excludedExistingManifestPaths.push(
                path.resolve(manifestPath)
            );
            return;
        }
        case "concurrency":
            options.concurrency = parseBoundedInteger(
                value,
                "concurrency",
                1,
                12
            );
            return;
        case "pagesize":
            options.pageSize = parseBoundedInteger(value, "pagesize", 1, 500);
            return;
        case "limit-packs":
            options.limitPacks = parseBoundedInteger(
                value,
                "limit-packs",
                1,
                100_000
            );
            return;
        case "year":
            options.year = parseBoundedInteger(value, "year", 1980, 2100);
            return;
        case "pack": {
            const pack = value.trim();
            if (!pack || !/^[a-z0-9._-]+$/iu.test(pack)) {
                throw new Error(
                    "--pack must contain a safe 16colors pack name."
                );
            }
            options.packs.push(pack);
            return;
        }
        default:
            throw new Error(`Unknown option: ${argument}`);
    }
}

/**
 * @param {string[]} argv
 *
 * @returns {AuditOptions}
 */
function parseArguments(argv) {
    const options = createAuditOptions();
    const state = { reportWasSet: false, htmlWasSet: false };
    for (const argument of argv) {
        applyAuditArgument(options, state, argument);
    }

    if (!state.reportWasSet) {
        options.reportPath = path.join(options.cacheDir, "report.json");
    }
    if (!state.htmlWasSet) {
        options.htmlPath = path.join(options.cacheDir, "review.html");
    }
    return options;
}

/**
 * @param {string} value
 * @param {string} label
 * @param {number} minimum
 * @param {number} maximum
 *
 * @returns {number}
 */
function parseBoundedInteger(value, label, minimum, maximum) {
    const parsed = Number.parseInt(value, 10);
    if (
        !/^\d+$/u.test(value) ||
        !Number.isSafeInteger(parsed) ||
        parsed < minimum ||
        parsed > maximum
    ) {
        throw new RangeError(
            `--${label} must be an integer between ${minimum} and ${maximum}.`
        );
    }
    return parsed;
}

function printHelp() {
    console.log("Usage: node scripts/Audit-AnsiArchives.js [options]");
    console.log("  --source=16colors|roy|all  Archive source (default: all)");
    console.log(
        "  --cache-dir=<path>         Resumable cache and default report directory"
    );
    console.log(
        "  --offline                  Refuse network access; require cached responses"
    );
    console.log(
        "  --metadata-only            Inventory without downloading raw artwork"
    );
    console.log(
        "  --concurrency=<1-12>       Maximum simultaneous requests (default: 4)"
    );
    console.log(
        "  --pagesize=<1-500>         16colors API page size (default: 500)"
    );
    console.log(
        "  --year=<year>              Restrict 16colors packs to one year"
    );
    console.log(
        "  --pack=<name>              Restrict to a pack; may be repeated"
    );
    console.log(
        "  --limit-packs=<count>      Bound a smoke or fixture-backed run"
    );
    console.log("  --decisions=<path>         Merge exported review decisions");
    console.log(
        "  --exclude-existing-manifest=<path>  Exclude a prior import from the gallery baseline; may be repeated"
    );
    console.log("  --report=<path>            Full JSON report output");
    console.log(
        "  --html=<path>              Interactive contact-sheet output"
    );
    console.log(
        "  --checkpoint=<path>        Compact curation checkpoint output"
    );
}

/**
 * @param {string} filePath
 * @param {Buffer | string} content
 */
function writeFileAtomic(filePath, content) {
    fs.mkdirSync(path.dirname(filePath), { recursive: true });
    const temporaryPath = `${filePath}.${process.pid}.tmp`;
    fs.writeFileSync(temporaryPath, content);
    fs.renameSync(temporaryPath, filePath);
}

/**
 * @param {number} milliseconds
 *
 * @returns {Promise<void>}
 */
function delay(milliseconds) {
    return new Promise((resolve) => setTimeout(resolve, milliseconds));
}

/**
 * @param {string} url
 * @param {{
 *     cachePath: string;
 *     offline: boolean;
 *     binary?: boolean;
 *     fetchImpl?: typeof fetch;
 *     delayImpl?: (milliseconds: number) => Promise<void>;
 *     attempts?: number;
 *     timeoutMs?: number;
 *     maxBytes?: number;
 * }} options
 *
 * @returns {Promise<Buffer | string>}
 */
async function fetchCached(url, options) {
    if (fs.existsSync(options.cachePath)) {
        if (
            options.maxBytes &&
            fs.statSync(options.cachePath).size > options.maxBytes
        ) {
            throw new RangeError(
                `Cached response exceeds the ${options.maxBytes}-byte limit for ${url}`
            );
        }
        return options.binary
            ? fs.readFileSync(options.cachePath)
            : fs.readFileSync(options.cachePath, "utf8");
    }
    if (options.offline) {
        throw new Error(`Offline cache miss for ${url}`);
    }

    const fetchImpl = options.fetchImpl || fetch;
    const delayImpl = options.delayImpl || delay;
    const attempts = options.attempts || 5;
    const timeoutMs = options.timeoutMs || 30_000;
    const maxBytes = options.maxBytes || 64 * 1024 * 1024;
    let lastError = null;
    for (let attempt = 1; attempt <= attempts; attempt += 1) {
        const controller = new AbortController();
        /** @type {ReturnType<typeof setTimeout> | undefined} */
        let timeout;
        try {
            const request = (async () => {
                const response = await fetchImpl(url, {
                    headers: { "User-Agent": USER_AGENT },
                    redirect: "follow",
                    signal: controller.signal,
                });
                if (!response.ok) {
                    if (response.status === 429 || response.status >= 500) {
                        throw new Error(`HTTP ${response.status} for ${url}`);
                    }
                    throw new Error(
                        `Non-retryable HTTP ${response.status} for ${url}`
                    );
                }
                return readResponseWithLimit(
                    response,
                    maxBytes,
                    options.binary === true
                );
            })();
            const deadline = new Promise((unusedResolve, reject) => {
                timeout = setTimeout(() => {
                    controller.abort();
                    reject(
                        new Error(
                            `Request timed out after ${timeoutMs} ms for ${url}`
                        )
                    );
                }, timeoutMs);
            });
            const content = /** @type {Buffer | string} */ (
                await Promise.race([request, deadline])
            );
            writeFileAtomic(options.cachePath, content);
            return content;
        } catch (error) {
            lastError =
                error instanceof Error ? error : new Error(String(error));
            if (
                lastError.message.startsWith("Non-retryable") ||
                lastError instanceof RangeError ||
                attempt === attempts
            ) {
                break;
            }
            await delayImpl(500 * 2 ** (attempt - 1));
        } finally {
            if (timeout !== undefined) clearTimeout(timeout);
        }
    }
    throw lastError || new Error(`Unable to fetch ${url}`);
}

/**
 * @param {Response} response
 * @param {number} maxBytes
 * @param {boolean} binary
 *
 * @returns {Promise<Buffer | string>}
 */
async function readResponseWithLimit(response, maxBytes, binary) {
    const declaredLength = Number(response.headers.get("content-length"));
    if (Number.isFinite(declaredLength) && declaredLength > maxBytes) {
        throw new RangeError(
            `HTTP response declares ${declaredLength} bytes, exceeding the ${maxBytes}-byte limit.`
        );
    }
    if (!response.body) {
        throw new Error("HTTP response has no readable body.");
    }
    const reader = response.body.getReader();
    const chunks = [];
    let total = 0;
    try {
        while (true) {
            const { done, value } = await reader.read();
            if (done) break;
            total += value.byteLength;
            if (total > maxBytes) {
                await reader.cancel("response size limit exceeded");
                throw new RangeError(
                    `HTTP response exceeds the ${maxBytes}-byte limit.`
                );
            }
            chunks.push(Buffer.from(value));
        }
    } finally {
        reader.releaseLock();
    }
    const buffer = Buffer.concat(chunks, total);
    return binary ? buffer : buffer.toString("utf8");
}

/**
 * @template T,U
 *
 * @param {T[]} values
 * @param {number} concurrency
 * @param {(value: T, index: number) => Promise<U>} mapper
 *
 * @returns {Promise<U[]>}
 */
async function mapConcurrent(values, concurrency, mapper) {
    /** @type {U[]} */
    const results = new Array(values.length);
    let nextIndex = 0;
    const workers = Array.from(
        { length: Math.min(concurrency, values.length) },
        async () => {
            while (nextIndex < values.length) {
                const index = nextIndex;
                nextIndex += 1;
                results[index] = await mapper(values[index], index);
            }
        }
    );
    await Promise.all(workers);
    return results;
}

/**
 * @param {string} url
 * @param {AuditOptions} options
 * @param {string} cacheName
 *
 * @returns {Promise<Record<string, unknown>>}
 */
async function fetchJson(url, options, cacheName) {
    const content = await fetchCached(url, {
        cachePath: path.join(options.cacheDir, "api", cacheName),
        offline: options.offline,
    });
    try {
        return requireObject(JSON.parse(String(content)), url);
    } catch (error) {
        throw new Error(
            `Invalid JSON from ${url}: ${error instanceof Error ? error.message : String(error)}`
        );
    }
}

/**
 * @param {AuditOptions} options
 *
 * @returns {Promise<{
 *     packs: Record<string, unknown>[];
 *     reportedTotal: number;
 *     enumeratedCount: number;
 * }>}
 */
async function listSixteenColorsPacks(options) {
    const firstUrl = `${SIXTEEN_COLORS_API}/pack/?pagesize=${options.pageSize}&page=1`;
    const first = await fetchJson(firstUrl, options, "packs-page-0001.json");
    const page = requireObject(first.page, "16colors page metadata");
    const pages = Number(page.pages);
    const reportedTotal = Number(page.total);
    if (!Number.isSafeInteger(pages) || pages < 1) {
        throw new Error("16colors returned an invalid page count.");
    }
    if (!Number.isSafeInteger(reportedTotal) || reportedTotal < 0) {
        throw new Error("16colors returned an invalid pack total.");
    }

    const pageNumbers = Array.from(
        { length: pages - 1 },
        (_, index) => index + 2
    );
    const remaining = await mapConcurrent(
        pageNumbers,
        options.concurrency,
        async (pageNumber) =>
            fetchJson(
                `${SIXTEEN_COLORS_API}/pack/?pagesize=${options.pageSize}&page=${pageNumber}`,
                options,
                `packs-page-${String(pageNumber).padStart(4, "0")}.json`
            )
    );
    const packs = [first, ...remaining].flatMap((response, index) =>
        requireArray(
            response.results,
            `16colors page ${index + 1} results`
        ).map((result, resultIndex) =>
            requireObject(
                result,
                `16colors page ${index + 1} result ${resultIndex + 1}`
            )
        )
    );
    const filtered = packs.filter((pack) => {
        const name = requirePackName(pack.name);
        const year = Number(pack.year);
        return (
            (options.year === null || year === options.year) &&
            (options.packs.length === 0 || options.packs.includes(name))
        );
    });
    return {
        packs: options.limitPacks
            ? filtered.slice(0, options.limitPacks)
            : filtered,
        reportedTotal,
        enumeratedCount: packs.length,
    };
}

/**
 * @param {Record<string, unknown>} pack
 * @param {AuditOptions} options
 *
 * @returns {Promise<Record<string, unknown>>}
 */
async function getSixteenColorsPack(pack, options) {
    const name = requirePackName(pack.name);
    const url = `${SIXTEEN_COLORS_API}/pack/${encodeURIComponent(name)}?sauce=true&dimensions=true&filesize=true`;
    const response = await fetchJson(
        url,
        options,
        path.join("packs", `${safePathSegment(name)}.json`)
    );
    const results = requireArray(response.results, `${name} results`);
    if (results.length === 0) {
        return {
            year: pack.year,
            archive: pack.archive,
            download: pack.download,
            files: {},
            _metadataFallbackReason:
                "The pack-detail endpoint returned no records; inventory was recovered from the listed archive when available.",
        };
    }
    if (results.length > 1) {
        const archive =
            typeof pack.archive === "string" ? pack.archive : undefined;
        const year = Number(pack.year);
        const matches = results.filter((result) => {
            const detail = requireObject(result, `${name} pack`);
            if (archive && detail.archive === archive) return true;
            return Number(detail.year) === year;
        });
        if (matches.length === 1) {
            return requireObject(matches[0], `${name} pack`);
        }
        throw new Error(
            `${name} returned ${results.length} pack records and could not be matched uniquely to year ${year}.`
        );
    }
    return requireObject(results[0], `${name} pack`);
}

/**
 * Empty packs are represented inconsistently by the API as either an object or
 * an empty array. Accept only the empty-array variant; a populated array
 * remains a schema error so malformed metadata cannot silently disappear.
 *
 * @param {string} value
 * @param {string} label
 *
 * @returns {Record<string, unknown>}
 */
function requirePackFiles(value, label) {
    if (Array.isArray(value)) {
        if (value.length === 0) return {};
        throw new TypeError(
            `${label} must be a JSON object or an empty array.`
        );
    }
    return requireObject(value, label);
}

/**
 * Preserve archive subdirectories while escaping every URL path component.
 *
 * @param {string} filename
 *
 * @returns {string}
 */
function encodeArchivePath(filename) {
    return filename
        .replaceAll("\\", "/")
        .split("/")
        .map((segment) => encodeURIComponent(segment))
        .join("/");
}

/**
 * @param {Record<string, unknown>} pack
 * @param {Record<string, unknown> | null} listedPack
 *
 * @returns {string | null}
 */
function getPackArchiveName(pack, listedPack) {
    if (typeof pack.archive === "string") return pack.archive;
    if (typeof listedPack?.archive === "string") return listedPack.archive;
    return null;
}

/**
 * @param {Record<string, unknown>} pack
 * @param {Record<string, unknown> | null} listedPack
 *
 * @returns {string | null}
 */
function getPackArchiveUrl(pack, listedPack) {
    if (typeof pack.download === "string") {
        return new URL(pack.download, SIXTEEN_COLORS_SITE).href;
    }
    if (typeof listedPack?.download === "string") {
        return new URL(listedPack.download, SIXTEEN_COLORS_SITE).href;
    }
    return null;
}

/**
 * Build the common 16colors candidate record. Archive-only recovery uses this
 * same path so recovered files receive the same canonical URLs and identifiers
 * as API-described files.
 *
 * @param {Record<string, unknown>} pack
 * @param {string} filename
 * @param {Record<string, unknown> | null} metadata
 * @param {number | null} declaredSize
 *
 * @returns {Record<string, unknown>}
 */
function createSixteenColorsCandidate(pack, filename, metadata, declaredSize) {
    const listedPack = pack._listedPack
        ? requireObject(pack._listedPack, "listed pack")
        : null;
    const archive = getPackArchiveName(pack, listedPack);
    const packName = listedPack
        ? requirePackName(listedPack.name)
        : requireString(archive, "pack archive").replace(/\.zip$/iu, "");
    const year = Number(pack.year ?? listedPack?.year);
    const file = metadata
        ? requireObject(metadata.file, `${packName}/${filename} file`)
        : null;
    const rawName = file
        ? requireString(file.raw, `${packName}/${filename} raw filename`)
        : filename;
    const x1 = file?.x1 ? requireObject(file.x1, `${filename} x1`) : null;
    const tn = file?.tn
        ? requireObject(file.tn, `${filename} thumbnail`)
        : null;
    const previewUri = tn?.uri || x1?.uri || null;
    const encodedPack = encodeURIComponent(packName);
    const encodedRawName = encodeArchivePath(rawName);
    const encodedFilename = encodeArchivePath(filename);
    const artists = Array.isArray(metadata?.artists)
        ? metadata.artists.filter((item) => typeof item === "string")
        : [];
    const content = Array.isArray(metadata?.content)
        ? metadata.content.filter((item) => typeof item === "string")
        : [];
    return {
        id: `16colors:${packName}/${filename}`,
        source: "16colors",
        year,
        pack: packName,
        archive,
        archiveUrl: getPackArchiveUrl(pack, listedPack),
        filename,
        format: path.extname(filename).slice(1).toUpperCase(),
        sourceUrl: `${SIXTEEN_COLORS_SITE}/pack/${encodedPack}/raw/${encodedRawName}`,
        galleryUrl: `${SIXTEEN_COLORS_SITE}/pack/${encodedPack}/${encodedFilename}`,
        previewUrl:
            typeof previewUri === "string"
                ? new URL(previewUri, SIXTEEN_COLORS_SITE).href
                : `${SIXTEEN_COLORS_SITE}/pack/${encodedPack}/x1/${encodedFilename}.png`,
        artists,
        content,
        sauce: metadata?.sauce || null,
        declaredSize,
        metadataSource: metadata ? "16colors-api" : "16colors-archive",
    };
}

/**
 * @param {Record<string, unknown>} pack
 *
 * @returns {Record<string, unknown>[]}
 */
function extractSixteenColorsCandidates(pack) {
    const listedPack = pack._listedPack
        ? requireObject(pack._listedPack, "listed pack")
        : null;
    const archive = getPackArchiveName(pack, listedPack);
    const packName = listedPack
        ? requirePackName(listedPack.name)
        : requireString(archive, "pack archive").replace(/\.zip$/iu, "");
    const files = requirePackFiles(pack.files, `${packName} files`);
    return Object.entries(files).flatMap(([filename, rawMetadata]) => {
        if (!SUPPORTED_EXTENSIONS.has(path.extname(filename).toLowerCase())) {
            return [];
        }
        const metadata = requireObject(rawMetadata, `${packName}/${filename}`);
        const file = requireObject(
            metadata.file,
            `${packName}/${filename} file`
        );
        return [
            createSixteenColorsCandidate(
                pack,
                filename,
                metadata,
                Number(file.size) || null
            ),
        ];
    });
}

/**
 * Cache one canonical 16colors pack archive and extract only its ANSI/ICE
 * candidates. Missing or malformed archives are reported to the caller; raw
 * endpoint fallback remains available for individual candidates.
 *
 * @param {Record<string, unknown>} pack
 * @param {Record<string, unknown>[]} candidates
 * @param {AuditOptions} options
 *
 * @returns {Promise<Record<string, unknown>>}
 */
async function cacheSixteenColorsArchive(pack, candidates, options) {
    const listed = requireObject(pack._listedPack, "listed 16colors pack");
    const packName = requirePackName(listed.name);
    const year = Number(pack.year ?? listed.year);
    const archiveUrl =
        candidates.find((candidate) => typeof candidate.archiveUrl === "string")
            ?.archiveUrl ||
        (typeof pack.download === "string"
            ? new URL(pack.download, SIXTEEN_COLORS_SITE).href
            : typeof listed.download === "string"
              ? new URL(listed.download, SIXTEEN_COLORS_SITE).href
              : null);
    if (
        typeof archiveUrl !== "string" ||
        !new URL(archiveUrl).pathname.toLowerCase().endsWith(".zip")
    ) {
        return {
            pack: packName,
            year,
            status: "raw-fallback-no-zip",
            extracted: 0,
        };
    }
    const files = requirePackFiles(pack.files, `${packName} files`);
    const declaredArchiveContentBytes = Object.values(files).reduce(
        (total, rawMetadata) => {
            if (!rawMetadata || typeof rawMetadata !== "object") return total;
            const metadata = /** @type {Record<string, unknown>} */ (
                rawMetadata
            );
            if (!metadata.file || typeof metadata.file !== "object") {
                return total;
            }
            const file = /** @type {Record<string, unknown>} */ (metadata.file);
            return total + (Number(file.size) || 0);
        },
        0
    );
    const declaredCandidateBytes = candidates.reduce(
        (total, candidate) => total + (Number(candidate.declaredSize) || 0),
        0
    );
    if (
        declaredArchiveContentBytes > MIXED_MEDIA_ARCHIVE_THRESHOLD_BYTES &&
        declaredCandidateBytes > 0 &&
        declaredCandidateBytes * 4 < declaredArchiveContentBytes
    ) {
        return {
            pack: packName,
            year,
            status: "raw-fallback-archive-inefficient",
            archiveUrl,
            declaredArchiveContentBytes,
            declaredCandidateBytes,
            extracted: 0,
        };
    }
    const archivePath = path.join(
        options.cacheDir,
        "16colors",
        "archives",
        safePathSegment(String(year)),
        `${safePathSegment(packName)}.zip`
    );
    try {
        const buffer = /** @type {Buffer} */ (
            await fetchCached(archiveUrl, {
                cachePath: archivePath,
                offline: options.offline,
                binary: true,
                maxBytes: MAX_ZIP_UNCOMPRESSED_BYTES,
                timeoutMs: ARCHIVE_REQUEST_TIMEOUT_MS,
            })
        );
        const archiveSha256 = sha256(buffer);
        const entries = readZipDirectory(buffer);
        const entryByPath = new Map();
        const entriesByBasename = new Map();
        for (const entry of entries) {
            const normalized = entry.name.replaceAll("\\", "/").toLowerCase();
            entryByPath.set(normalized, entry);
            const basename = path.posix.basename(normalized);
            const matches = entriesByBasename.get(basename) || [];
            matches.push(entry);
            entriesByBasename.set(basename, matches);
        }
        const candidatePaths = new Set(
            candidates.map((candidate) =>
                requireString(candidate.filename, "16colors candidate filename")
                    .replaceAll("\\", "/")
                    .toLowerCase()
            )
        );
        const candidateBasenames = new Map();
        for (const candidatePath of candidatePaths) {
            const basename = path.posix.basename(candidatePath);
            candidateBasenames.set(
                basename,
                (candidateBasenames.get(basename) || 0) + 1
            );
        }
        let recovered = 0;
        for (const entry of entries) {
            const normalized = entry.name.replaceAll("\\", "/").toLowerCase();
            if (
                entry.name.endsWith("/") ||
                !SUPPORTED_EXTENSIONS.has(path.extname(normalized)) ||
                candidatePaths.has(normalized) ||
                candidateBasenames.get(path.posix.basename(normalized)) === 1
            ) {
                continue;
            }
            candidates.push(
                createSixteenColorsCandidate(
                    pack,
                    entry.name.replaceAll("\\", "/"),
                    null,
                    entry.uncompressedSize
                )
            );
            candidatePaths.add(normalized);
            const basename = path.posix.basename(normalized);
            candidateBasenames.set(
                basename,
                (candidateBasenames.get(basename) || 0) + 1
            );
            recovered += 1;
        }
        let extracted = 0;
        for (const candidate of candidates) {
            const filename = requireString(
                candidate.filename,
                "16colors candidate filename"
            );
            const normalized = filename.replaceAll("\\", "/").toLowerCase();
            let entry = entryByPath.get(normalized);
            if (!entry) {
                const matches = entriesByBasename.get(
                    path.posix.basename(normalized)
                );
                if (matches?.length === 1) [entry] = matches;
            }
            candidate.archiveSha256 = archiveSha256;
            if (!entry) continue;
            const rawPath = path.join(
                options.cacheDir,
                "16colors",
                "raw",
                safePathSegment(String(year)),
                safePathSegment(packName),
                safePathSegment(filename)
            );
            if (!fs.existsSync(rawPath)) {
                writeFileAtomic(rawPath, extractZipEntry(buffer, entry));
            }
            candidate.rawPath = rawPath;
            extracted += 1;
        }
        return {
            pack: packName,
            year,
            status: "cached",
            archiveUrl,
            archiveSha256,
            entryCount: entries.length,
            extracted,
            recovered,
        };
    } catch (error) {
        return {
            pack: packName,
            year,
            status: "raw-fallback-archive-error",
            archiveUrl,
            extracted: 0,
            error: error instanceof Error ? error.message : String(error),
        };
    }
}

/**
 * @param {Buffer} zipBuffer
 *
 * @returns {ZipEntry[]}
 */
function readZipCentralDirectory(zipBuffer) {
    const minimumEocd = 22;
    if (zipBuffer.length < minimumEocd) {
        throw new Error("ZIP archive is too small to contain an end record.");
    }
    const searchStart = Math.max(0, zipBuffer.length - 65_557);
    let eocdOffset = -1;
    for (
        let offset = zipBuffer.length - minimumEocd;
        offset >= searchStart;
        offset -= 1
    ) {
        if (zipBuffer.readUInt32LE(offset) === 0x06054b50) {
            eocdOffset = offset;
            break;
        }
    }
    if (eocdOffset < 0) {
        throw new Error("ZIP end-of-central-directory record was not found.");
    }
    const entryCount = zipBuffer.readUInt16LE(eocdOffset + 10);
    const directorySize = zipBuffer.readUInt32LE(eocdOffset + 12);
    const directoryOffset = zipBuffer.readUInt32LE(eocdOffset + 16);
    if (entryCount > MAX_ZIP_ENTRIES) {
        throw new RangeError(`ZIP exceeds the ${MAX_ZIP_ENTRIES}-entry limit.`);
    }
    if (directoryOffset + directorySize > eocdOffset) {
        throw new Error("ZIP central directory extends beyond its end record.");
    }

    /** @type {ZipEntry[]} */
    const entries = [];
    let offset = directoryOffset;
    let totalUncompressed = 0;
    for (let index = 0; index < entryCount; index += 1) {
        if (
            offset + 46 > zipBuffer.length ||
            zipBuffer.readUInt32LE(offset) !== 0x02014b50
        ) {
            throw new Error(
                `ZIP central directory entry ${index + 1} is invalid.`
            );
        }
        const flags = zipBuffer.readUInt16LE(offset + 8);
        const compressionMethod = zipBuffer.readUInt16LE(offset + 10);
        const crc32 = zipBuffer.readUInt32LE(offset + 16);
        const compressedSize = zipBuffer.readUInt32LE(offset + 20);
        const uncompressedSize = zipBuffer.readUInt32LE(offset + 24);
        const filenameLength = zipBuffer.readUInt16LE(offset + 28);
        const extraLength = zipBuffer.readUInt16LE(offset + 30);
        const commentLength = zipBuffer.readUInt16LE(offset + 32);
        const localHeaderOffset = zipBuffer.readUInt32LE(offset + 42);
        const entryEnd =
            offset + 46 + filenameLength + extraLength + commentLength;
        if (entryEnd > zipBuffer.length) {
            throw new Error(
                `ZIP central directory entry ${index + 1} is truncated.`
            );
        }
        if (
            compressedSize === 0xffffffff ||
            uncompressedSize === 0xffffffff ||
            localHeaderOffset === 0xffffffff
        ) {
            throw new Error(
                "ZIP64 archives are not supported by this auditor."
            );
        }
        const filenameBuffer = zipBuffer.subarray(
            offset + 46,
            offset + 46 + filenameLength
        );
        const name =
            flags & 0x0800
                ? filenameBuffer.toString("utf8")
                : iconv.decode(filenameBuffer, "cp437");
        totalUncompressed += uncompressedSize;
        if (totalUncompressed > MAX_ZIP_UNCOMPRESSED_BYTES) {
            throw new RangeError(
                `ZIP exceeds the ${MAX_ZIP_UNCOMPRESSED_BYTES}-byte uncompressed limit.`
            );
        }
        entries.push({
            name,
            flags,
            compressionMethod,
            crc32,
            compressedSize,
            uncompressedSize,
            localHeaderOffset,
        });
        offset = entryEnd;
    }
    return entries;
}

/**
 * Recover legacy archives whose local file records are intact but whose central
 * directory is absent or damaged. This format appears in early scene uploads
 * and is accepted by established ZIP tools. Suspect records and entries with
 * data descriptors cannot be bounded safely without a central directory, so
 * they are skipped rather than guessed.
 *
 * @param {Buffer} zipBuffer
 * @param {unknown} centralDirectoryError
 *
 * @returns {ZipEntry[]}
 */
function readZipLocalDirectory(zipBuffer, centralDirectoryError) {
    const localSignature = Buffer.from([
        0x50,
        0x4b,
        0x03,
        0x04,
    ]);
    /** @type {ZipEntry[]} */
    const entries = [];
    let offset = zipBuffer.indexOf(localSignature);
    let totalUncompressed = 0;
    while (offset >= 0 && offset + 30 <= zipBuffer.length) {
        if (entries.length >= MAX_ZIP_ENTRIES) {
            throw new RangeError(
                `ZIP exceeds the ${MAX_ZIP_ENTRIES}-entry limit.`
            );
        }
        const flags = zipBuffer.readUInt16LE(offset + 6);
        if (flags & 0x0008) {
            offset = zipBuffer.indexOf(localSignature, offset + 1);
            continue;
        }
        const compressionMethod = zipBuffer.readUInt16LE(offset + 8);
        const crc32 = zipBuffer.readUInt32LE(offset + 14);
        const compressedSize = zipBuffer.readUInt32LE(offset + 18);
        const uncompressedSize = zipBuffer.readUInt32LE(offset + 22);
        const filenameLength = zipBuffer.readUInt16LE(offset + 26);
        const extraLength = zipBuffer.readUInt16LE(offset + 28);
        if (compressedSize === 0xffffffff || uncompressedSize === 0xffffffff) {
            offset = zipBuffer.indexOf(localSignature, offset + 1);
            continue;
        }
        const nameStart = offset + 30;
        const nameEnd = nameStart + filenameLength;
        const dataStart = nameEnd + extraLength;
        const dataEnd = dataStart + compressedSize;
        if (nameEnd > zipBuffer.length || dataEnd > zipBuffer.length) {
            offset = zipBuffer.indexOf(localSignature, offset + 1);
            continue;
        }
        const filenameBuffer = zipBuffer.subarray(nameStart, nameEnd);
        const name =
            flags & 0x0800
                ? filenameBuffer.toString("utf8")
                : iconv.decode(filenameBuffer, "cp437");
        if (name.length === 0 || name.includes("\0")) {
            offset = zipBuffer.indexOf(localSignature, offset + 1);
            continue;
        }
        totalUncompressed += uncompressedSize;
        if (totalUncompressed > MAX_ZIP_UNCOMPRESSED_BYTES) {
            throw new RangeError(
                `ZIP exceeds the ${MAX_ZIP_UNCOMPRESSED_BYTES}-byte uncompressed limit.`
            );
        }
        entries.push({
            name,
            flags,
            compressionMethod,
            crc32,
            compressedSize,
            uncompressedSize,
            localHeaderOffset: offset,
        });
        offset = zipBuffer.indexOf(localSignature, dataEnd);
    }
    if (entries.length === 0) {
        throw centralDirectoryError;
    }
    return entries;
}

/**
 * Prefer the canonical ZIP central directory, with bounded local-record
 * recovery for damaged legacy archives.
 *
 * @param {Buffer} zipBuffer
 *
 * @returns {ZipEntry[]}
 */
function readZipDirectory(zipBuffer) {
    try {
        return readZipCentralDirectory(zipBuffer);
    } catch (error) {
        if (error instanceof RangeError) throw error;
        return readZipLocalDirectory(zipBuffer, error);
    }
}

/**
 * @param {Buffer} zipBuffer
 * @param {ZipEntry} entry
 *
 * @returns {Buffer}
 */
function extractZipEntry(zipBuffer, entry) {
    if (entry.flags & 1) {
        throw new Error(`Encrypted ZIP entry is unsupported: ${entry.name}`);
    }
    if (entry.uncompressedSize > MAX_INPUT_BYTES) {
        throw new RangeError(
            `${entry.name} exceeds the ${MAX_INPUT_BYTES}-byte ANSI input limit.`
        );
    }
    const offset = entry.localHeaderOffset;
    if (
        offset + 30 > zipBuffer.length ||
        zipBuffer.readUInt32LE(offset) !== 0x04034b50
    ) {
        throw new Error(`ZIP local header is invalid for ${entry.name}.`);
    }
    const filenameLength = zipBuffer.readUInt16LE(offset + 26);
    const extraLength = zipBuffer.readUInt16LE(offset + 28);
    const dataStart = offset + 30 + filenameLength + extraLength;
    const dataEnd = dataStart + entry.compressedSize;
    if (dataEnd > zipBuffer.length) {
        throw new Error(`ZIP data is truncated for ${entry.name}.`);
    }
    const compressed = zipBuffer.subarray(dataStart, dataEnd);
    let result;
    if (entry.compressionMethod === 0) {
        result = Buffer.from(compressed);
    } else if (entry.compressionMethod === 8) {
        result = zlib.inflateRawSync(compressed, {
            maxOutputLength: Math.min(MAX_INPUT_BYTES, entry.uncompressedSize),
        });
    } else {
        throw new Error(
            `Unsupported ZIP compression method ${entry.compressionMethod} for ${entry.name}.`
        );
    }
    if (result.length !== entry.uncompressedSize) {
        throw new Error(`ZIP size mismatch for ${entry.name}.`);
    }
    if (zlib.crc32(result) >>> 0 !== entry.crc32) {
        throw new Error(`ZIP CRC mismatch for ${entry.name}.`);
    }
    return result;
}

/**
 * @param {string} html
 *
 * @returns {string[]}
 */
function extractRoyArchiveUrls(html) {
    const urls = new Set();
    const hrefPattern = /href\s*=\s*["']([^"']+\.zip(?:\?[^"']*)?)["']/giu;
    for (const match of html.matchAll(hrefPattern)) {
        const absolute = new URL(match[1], ROY_DOWNLOADS_URL);
        if (
            /\/images\/galleries\/(?:SACPACKS|ZIP)\//iu.test(absolute.pathname)
        ) {
            if (absolute.hostname === "www.roysac.com") {
                absolute.protocol = "https:";
            }
            absolute.hash = "";
            urls.add(absolute.href);
        }
    }
    return [...urls].sort((left, right) => left.localeCompare(right));
}

/**
 * @param {AuditOptions} options
 *
 * @returns {Promise<{
 *     archives: Record<string, unknown>[];
 *     candidates: Record<string, unknown>[];
 * }>}
 */
async function auditRoyArchives(options) {
    const html = String(
        await fetchCached(ROY_DOWNLOADS_URL, {
            cachePath: path.join(options.cacheDir, "roy", "downloads.html"),
            offline: options.offline,
        })
    );
    let urls = extractRoyArchiveUrls(html);
    if (options.limitPacks) {
        urls = urls.slice(0, options.limitPacks);
    }
    const archives = await mapConcurrent(
        urls,
        options.concurrency,
        async (url) => {
            const archiveName = path.basename(new URL(url).pathname);
            if (options.metadataOnly) {
                return { name: archiveName, url, sha256: null, entries: null };
            }
            const buffer = /** @type {Buffer} */ (
                await fetchCached(url, {
                    cachePath: path.join(
                        options.cacheDir,
                        "roy",
                        "archives",
                        safePathSegment(archiveName)
                    ),
                    offline: options.offline,
                    binary: true,
                    maxBytes: MAX_ZIP_UNCOMPRESSED_BYTES,
                    timeoutMs: ARCHIVE_REQUEST_TIMEOUT_MS,
                })
            );
            const entries = readZipDirectory(buffer);
            return {
                name: archiveName,
                url,
                sha256: sha256(buffer),
                entries: entries.length,
                buffer,
                directory: entries,
            };
        }
    );

    const candidates = archives.flatMap((archive) => {
        if (!archive.buffer || !archive.directory) {
            return [];
        }
        const buffer = /** @type {Buffer} */ (archive.buffer);
        const directory = /** @type {ZipEntry[]} */ (archive.directory);
        return directory.flatMap((entry) => {
            if (
                !SUPPORTED_EXTENSIONS.has(
                    path.extname(entry.name).toLowerCase()
                )
            ) {
                return [];
            }
            let raw;
            try {
                raw = extractZipEntry(buffer, entry);
            } catch (error) {
                return [
                    {
                        id: `roy:${archive.name}/${entry.name}`,
                        source: "roy",
                        pack: archive.name,
                        archive: archive.name,
                        archiveUrl: archive.url,
                        archiveSha256: archive.sha256,
                        filename: entry.name,
                        format: path.extname(entry.name).slice(1).toUpperCase(),
                        sourceUrl: archive.url,
                        galleryUrl: ROY_DOWNLOADS_URL,
                        previewUrl: null,
                        artists: [],
                        content: [],
                        rawError:
                            error instanceof Error
                                ? error.message
                                : String(error),
                    },
                ];
            }
            const rawPath = path.join(
                options.cacheDir,
                "roy",
                "raw",
                safePathSegment(archive.name),
                safePathSegment(entry.name)
            );
            writeFileAtomic(rawPath, raw);
            return [
                {
                    id: `roy:${archive.name}/${entry.name}`,
                    source: "roy",
                    pack: archive.name,
                    archive: archive.name,
                    archiveUrl: archive.url,
                    archiveSha256: archive.sha256,
                    filename: entry.name,
                    format: path.extname(entry.name).slice(1).toUpperCase(),
                    sourceUrl: archive.url,
                    galleryUrl: ROY_DOWNLOADS_URL,
                    previewUrl: null,
                    artists: [],
                    content: [],
                    rawPath,
                    raw,
                },
            ];
        });
    });
    return {
        archives: archives.map(
            ({
                buffer: unusedBuffer,
                directory: unusedDirectory,
                ...archive
            }) => archive
        ),
        candidates,
    };
}

/**
 * @param {unknown} color
 *
 * @returns {string | null}
 */
function getColorFamily(color) {
    if (!color || typeof color !== "object") {
        return null;
    }
    const candidate = /** @type {Record<string, unknown>} */ (color);
    if (candidate.mode === "basic" || candidate.mode === "bright") {
        const index = Number(candidate.value);
        return ANSI_FAMILY_NAMES[index] || null;
    }
    const rgb = colorToRgb(candidate);
    if (!rgb) {
        return null;
    }
    const [
        red,
        green,
        blue,
    ] = rgb.map((channel) => channel / 255);
    const maximum = Math.max(red, green, blue);
    const minimum = Math.min(red, green, blue);
    const delta = maximum - minimum;
    if (maximum < 0.16 || delta < 0.12) {
        return "neutral";
    }
    let hue;
    if (maximum === red) {
        hue = 60 * (((green - blue) / delta) % 6);
    } else if (maximum === green) {
        hue = 60 * ((blue - red) / delta + 2);
    } else {
        hue = 60 * ((red - green) / delta + 4);
    }
    if (hue < 0) hue += 360;
    if (hue < 30 || hue >= 330) return "red";
    if (hue < 90) return "yellow";
    if (hue < 150) return "green";
    if (hue < 210) return "cyan";
    if (hue < 270) return "blue";
    return "magenta";
}

/**
 * @param {Record<string, unknown>} color
 *
 * @returns {number[] | null}
 */
function colorToRgb(color) {
    if (color.mode === "rgb") {
        return [
            Number(color.r),
            Number(color.g),
            Number(color.b),
        ];
    }
    if (color.mode !== "palette") {
        return null;
    }
    const index = Number(color.value);
    const basic = [
        [
            0,
            0,
            0,
        ],
        [
            128,
            0,
            0,
        ],
        [
            0,
            128,
            0,
        ],
        [
            128,
            128,
            0,
        ],
        [
            0,
            0,
            128,
        ],
        [
            128,
            0,
            128,
        ],
        [
            0,
            128,
            128,
        ],
        [
            192,
            192,
            192,
        ],
        [
            128,
            128,
            128,
        ],
        [
            255,
            0,
            0,
        ],
        [
            0,
            255,
            0,
        ],
        [
            255,
            255,
            0,
        ],
        [
            0,
            0,
            255,
        ],
        [
            255,
            0,
            255,
        ],
        [
            0,
            255,
            255,
        ],
        [
            255,
            255,
            255,
        ],
    ];
    if (index >= 0 && index < basic.length) return basic[index];
    if (index >= 16 && index <= 231) {
        const adjusted = index - 16;
        const levels = [
            0,
            95,
            135,
            175,
            215,
            255,
        ];
        return [
            levels[Math.floor(adjusted / 36)],
            levels[Math.floor((adjusted % 36) / 6)],
            levels[adjusted % 6],
        ];
    }
    if (index >= 232 && index <= 255) {
        const level = 8 + (index - 232) * 10;
        return [
            level,
            level,
            level,
        ];
    }
    return null;
}

/**
 * @param {unknown} value
 *
 * @returns {string}
 */
function escapeXmlText(value) {
    return value
        .replace(/[\u0000-\u0008\u000b\u000c\u000e-\u001f]/gu, "�")
        .replaceAll("&", "&amp;")
        .replaceAll("<", "&lt;")
        .replaceAll(">", "&gt;");
}

/**
 * @param {unknown} color
 * @param {boolean} [bold]
 *
 * @returns {string | null}
 */
function colorToPreviewHex(color, bold = false) {
    if (!color || typeof color !== "object") return null;
    const record = /** @type {Record<string, unknown>} */ (color);
    if (record.mode === "basic" || record.mode === "bright") {
        const value = Number(record.value);
        if (!Number.isInteger(value) || value < 0 || value > 7) return null;
        const offset = record.mode === "bright" || bold ? 8 : 0;
        return ANSI_PREVIEW_PALETTE[value + offset];
    }
    const rgb = colorToRgb(record);
    if (!rgb || rgb.some((channel) => !Number.isFinite(channel))) return null;
    return `#${rgb
        .map((channel) =>
            Math.max(0, Math.min(255, Math.round(channel)))
                .toString(16)
                .padStart(2, "0")
        )
        .join("")}`;
}

/**
 * @typedef {Map<
 *     number,
 *     {
 *         cells: Map<number, { char: string; attrs: Record<string, unknown> }>;
 *         maxCol: number;
 *     }
 * >} TerminalRows
 */

/**
 * @param {import("./Convert-AnsiToColorScript.js").TerminalEmulator
 *     | Record<string, unknown>} terminal
 *
 * @returns {TerminalRows}
 */
function getTerminalRows(terminal) {
    const terminalRecord = /** @type {Record<string, unknown>} */ (terminal);
    if (!(terminalRecord.rows instanceof Map)) {
        throw new TypeError("Terminal rows must be a Map.");
    }
    return /** @type {TerminalRows} */ (terminalRecord.rows);
}

/**
 * Write a browser-safe, fixed-cell SVG fallback when an archive does not
 * provide an official preview. This is a review artifact only; conversion and
 * hashes continue to use the terminal cell matrix directly.
 *
 * @param {import("./Convert-AnsiToColorScript.js").TerminalEmulator
 *     | Record<string, unknown>} terminal
 * @param {string} outputPath
 *
 * @returns {void}
 */
function writeTerminalPreviewSvg(terminal, outputPath) {
    const terminalRecord = /** @type {Record<string, unknown>} */ (terminal);
    const writtenCellCount = Number(terminalRecord.writtenCellCount) || 0;
    if (writtenCellCount > MAX_LOCAL_PREVIEW_CELLS) {
        throw new RangeError(
            `Local preview exceeds the ${MAX_LOCAL_PREVIEW_CELLS}-cell review limit.`
        );
    }
    const rows = getTerminalRows(terminal);
    const columns = Math.max(
        1,
        Number(terminalRecord.columns) || 0,
        Number(terminalRecord.maxCol) + 1 || 0
    );
    const rowCount = Math.max(1, Number(terminalRecord.maxRow) + 1 || 0);
    const cellWidth = 8;
    const cellHeight = 16;
    const svg = [
        '<?xml version="1.0" encoding="UTF-8"?>',
        `<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 ${columns * cellWidth} ${rowCount * cellHeight}" width="${columns * cellWidth}" height="${rowCount * cellHeight}">`,
        `<rect width="${columns * cellWidth}" height="${rowCount * cellHeight}" fill="#000000"/>`,
        '<g shape-rendering="crispEdges">',
    ];
    const text = [];
    for (const [rowNumber, row] of [...rows.entries()].sort(
        (left, right) => left[0] - right[0]
    )) {
        const cells = [...row.cells.entries()].sort(
            (left, right) => left[0] - right[0]
        );
        /** @type {{ start: number; end: number; color: string } | null} */
        let backgroundRun = null;
        /**
         * @type {{
         *     start: number;
         *     end: number;
         *     key: string;
         *     color: string;
         *     chars: string[];
         *     bold: boolean;
         *     underline: boolean;
         *     strike: boolean;
         * } | null}
         */
        let textRun = null;
        const flushBackground = () => {
            if (!backgroundRun) return;
            svg.push(
                `<rect x="${backgroundRun.start * cellWidth}" y="${rowNumber * cellHeight}" width="${(backgroundRun.end - backgroundRun.start + 1) * cellWidth}" height="${cellHeight}" fill="${backgroundRun.color}"/>`
            );
            backgroundRun = null;
        };
        const flushText = () => {
            if (!textRun) return;
            const value = textRun.chars.join("");
            if (/\S/u.test(value)) {
                const decorations = [
                    textRun.underline ? "underline" : "",
                    textRun.strike ? "line-through" : "",
                ]
                    .filter(Boolean)
                    .join(" ");
                const boldAttribute = textRun.bold ? ' font-weight="700"' : "";
                const decorationAttribute = decorations
                    ? ` text-decoration="${decorations}"`
                    : "";
                text.push(
                    `<text x="${textRun.start * cellWidth}" y="${rowNumber * cellHeight + 13}" fill="${textRun.color}" font-family="Consolas, 'Courier New', monospace" font-size="16"${boldAttribute}${decorationAttribute} textLength="${textRun.chars.length * cellWidth}" lengthAdjust="spacingAndGlyphs" xml:space="preserve">${escapeXmlText(value)}</text>`
                );
            }
            textRun = null;
        };
        for (const [column, cell] of cells) {
            const attrs = cell.attrs;
            let foreground = attrs.fg;
            let background = attrs.bg;
            if (attrs.inverse) {
                [foreground, background] = [background, foreground];
            }
            const backgroundColor = colorToPreviewHex(background) || "#000000";
            const defaultForegroundColor =
                ANSI_PREVIEW_PALETTE[attrs.bold ? 15 : 7];
            const foregroundColor = attrs.hidden
                ? backgroundColor
                : colorToPreviewHex(foreground, Boolean(attrs.bold)) ||
                  defaultForegroundColor;
            if (backgroundColor !== "#000000") {
                if (
                    backgroundRun &&
                    backgroundRun.end + 1 === column &&
                    backgroundRun.color === backgroundColor
                ) {
                    backgroundRun.end = column;
                } else {
                    flushBackground();
                    backgroundRun = {
                        start: column,
                        end: column,
                        color: backgroundColor,
                    };
                }
            } else {
                flushBackground();
            }

            const key = [
                foregroundColor,
                Boolean(attrs.bold),
                Boolean(attrs.underline),
                Boolean(attrs.strike),
            ].join("|");
            if (textRun && textRun.end + 1 === column && textRun.key === key) {
                textRun.end = column;
                textRun.chars.push(cell.char);
            } else {
                flushText();
                textRun = {
                    start: column,
                    end: column,
                    key,
                    color: foregroundColor,
                    chars: [cell.char],
                    bold: Boolean(attrs.bold),
                    underline: Boolean(attrs.underline),
                    strike: Boolean(attrs.strike),
                };
            }
        }
        flushBackground();
        flushText();
    }
    svg.push(
        "</g>",
        '<g shape-rendering="geometricPrecision">',
        ...text,
        "</g>",
        "</svg>"
    );
    writeFileAtomic(outputPath, `${svg.join("\n")}\n`);
}

/**
 * @param {{
 *     cells: Map<number, { char: string; attrs: Record<string, unknown> }>;
 *     maxCol: number;
 * }} row
 * @param {Set<string>} families
 *
 * @returns {unknown[]}
 */
function fingerprintTerminalRow(row, families) {
    const cells = [];
    for (const [column, cell] of [...row.cells.entries()].sort(
        (left, right) => left[0] - right[0]
    )) {
        const attrs = cell.attrs;
        let foreground = attrs.fg;
        let background = attrs.bg;
        if (attrs.inverse) {
            [foreground, background] = [background, foreground];
        }
        if (cell.char !== " ") {
            const foregroundFamily = getColorFamily(foreground);
            if (foregroundFamily) families.add(foregroundFamily);
        }
        const backgroundFamily = getColorFamily(background);
        if (backgroundFamily) families.add(backgroundFamily);
        cells.push([
            column,
            cell.char,
            attrs,
        ]);
    }
    return cells;
}

/**
 * @param {import("./Convert-AnsiToColorScript.js").TerminalEmulator
 *     | Record<string, unknown>} terminal
 *
 * @returns {{ families: string[]; renderSha256: string }}
 */
function fingerprintTerminal(terminal) {
    const terminalRecord = /** @type {Record<string, unknown>} */ (terminal);
    const rows = getTerminalRows(terminal);
    const families = new Set();
    const canonicalRows = [...rows.keys()]
        .sort((left, right) => left - right)
        .map((rowNumber) => [
            rowNumber,
            fingerprintTerminalRow(rows.get(rowNumber), families),
        ]);
    return {
        families: [...families].sort((left, right) =>
            left.localeCompare(right, "en-US")
        ),
        renderSha256: sha256(
            JSON.stringify({
                maxRow: terminalRecord.maxRow,
                maxCol: terminalRecord.maxCol,
                rows: canonicalRows,
            })
        ),
    };
}

/**
 * Fingerprint the terminal content as it will appear in a generated gallery
 * script. Archival scripts always start on a fresh display line, so a source
 * that already begins with one empty row and an otherwise identical source
 * without that row produce the same Write-Host output. Reparse the serialized
 * rows with that presentation row removed to detect the duplicate without
 * weakening the geometry-sensitive archival render hash.
 *
 * @param {import("./Convert-AnsiToColorScript.js").TerminalEmulator} terminal
 *
 * @returns {string}
 */
function fingerprintGalleryOutput(terminal) {
    const lines = terminal.buildLines();
    if (lines[0] === "") {
        lines.shift();
    }
    const normalized = convertAnsiToPs1(lines.join("\r\n"), {
        columns: MAX_TERMINAL_COLUMNS,
        autoWrap: false,
        stripSpaceBackground: false,
    });
    return fingerprintTerminal(normalized.terminal).renderSha256;
}

/**
 * Keep audit reports compact and JSON-native. The converter's SAUCE record
 * intentionally retains the fixed-width tInfoS Buffer, but serializing that
 * Buffer for every archive candidate would expand it into an object of byte
 * indexes and make exhaustive reports needlessly large.
 *
 * @param {import("./Convert-AnsiToColorScript.js").SauceRecord | null} sauce
 *
 * @returns {Record<string, unknown> | null}
 */
function serializeSauceRecord(sauce) {
    if (!sauce) return null;
    return {
        version: sauce.version,
        title: sauce.title,
        author: sauce.author,
        group: sauce.group,
        date: sauce.date,
        fileSize: sauce.fileSize,
        dataType: sauce.dataType,
        fileType: sauce.fileType,
        width: sauce.tInfo1,
        height: sauce.tInfo2,
        tInfo3: sauce.tInfo3,
        tInfo4: sauce.tInfo4,
        flags: sauce.flags,
        iceColors: Boolean(sauce.flags & 1),
        font: getSauceFontName(sauce),
        comments: [...sauce.commentLines],
    };
}

/**
 * @param {Buffer} raw
 *
 * @returns {{
 *     analysis: Record<string, unknown>;
 *     terminal: import("./Convert-AnsiToColorScript.js").TerminalEmulator;
 * }}
 */
function analyzeAnsiRender(raw) {
    if (raw.length > MAX_INPUT_BYTES) {
        throw new RangeError(
            `ANSI input exceeds the ${MAX_INPUT_BYTES}-byte safety limit.`
        );
    }
    const stripped = stripSauce(raw);
    const sauce = stripped.sauce;
    const sourceEncoding = resolveSauceEncoding(getSauceFontName(sauce));
    const content = decodeDosAnsi(
        truncateDosAnsiAtEof(stripped.buffer),
        sourceEncoding.supported ? sourceEncoding.encoding : "cp437"
    );
    const columns = sauce?.tInfo1 || 80;
    const converted = convertAnsiToPs1(content, {
        columns,
        iceColors: Boolean(sauce && sauce.flags & 1),
        stripSpaceBackground: false,
        dosAnsi: true,
    });
    const fingerprint = fingerprintTerminal(converted.terminal);
    return {
        analysis: {
            sourceSha256: sha256(raw),
            renderSha256: fingerprint.renderSha256,
            normalizedRenderSha256: fingerprintGalleryOutput(
                converted.terminal
            ),
            colorFamilies: fingerprint.families,
            colorFamilyCount: fingerprint.families.length,
            width:
                converted.terminal.writtenCellCount > 0
                    ? converted.terminal.maxCol + 1
                    : 0,
            height: converted.terminal.maxRow + 1,
            columns,
            encoding: sourceEncoding.label,
            encodingName: sourceEncoding.encoding,
            encodingSupported: sourceEncoding.supported,
            encodingExplicit: sourceEncoding.explicit,
            sauce: serializeSauceRecord(sauce),
            warnings: converted.warnings,
        },
        terminal: converted.terminal,
    };
}

/**
 * @param {Buffer} raw
 *
 * @returns {Record<string, unknown>}
 */
function analyzeAnsiBuffer(raw) {
    return analyzeAnsiRender(raw).analysis;
}

/**
 * @param {Readonly<Record<string, unknown>>} entry
 *
 * @returns {{
 *     sourceSha256: string | null;
 *     renderSha256: string | null;
 * }}
 */
function getExistingEntryHashes(entry) {
    return {
        sourceSha256:
            typeof entry.SourceSha256 === "string"
                ? entry.SourceSha256.toLowerCase()
                : null,
        renderSha256:
            typeof entry.RenderSha256 === "string"
                ? entry.RenderSha256.toLowerCase()
                : null,
    };
}

/**
 * @param {string} scriptName
 * @param {Readonly<Record<string, unknown>>} entry
 * @param {{
 *     scriptsByName: Map<
 *         string,
 *         { sourceSha256: string; renderSha256: string }
 *     >;
 *     matchedScriptNames: Set<string>;
 * } | null} exclusions
 * @param {Set<string>} source
 * @param {Set<string>} render
 */
function addExistingEntryHashes(scriptName, entry, exclusions, source, render) {
    const { sourceSha256, renderSha256 } = getExistingEntryHashes(entry);
    const excluded = exclusions?.scriptsByName.get(scriptName);
    if (excluded) {
        if (
            excluded.sourceSha256 !== sourceSha256 ||
            excluded.renderSha256 !== renderSha256
        ) {
            throw new Error(
                `${scriptName}: exclusion manifest hashes do not match checked-in provenance.`
            );
        }
        exclusions.matchedScriptNames.add(scriptName);
        return;
    }
    if (sourceSha256) source.add(sourceSha256);
    if (renderSha256) render.add(renderSha256);
}

/**
 * @param {{
 *     scriptsByName: Map<
 *         string,
 *         { sourceSha256: string; renderSha256: string }
 *     >;
 *     matchedScriptNames: Set<string>;
 * } | null} exclusions
 */
function validateMatchedExclusions(exclusions) {
    if (
        exclusions &&
        exclusions.matchedScriptNames.size !== exclusions.scriptsByName.size
    ) {
        const missing = [...exclusions.scriptsByName.keys()].filter(
            (scriptName) => !exclusions.matchedScriptNames.has(scriptName)
        );
        throw new Error(
            `Exclusion manifest scripts are missing from checked-in provenance: ${missing.join(", ")}`
        );
    }
}

/**
 * @param {string} provenancePath
 * @param {{
 *     scriptsByName: Map<
 *         string,
 *         { sourceSha256: string; renderSha256: string }
 *     >;
 *     matchedScriptNames: Set<string>;
 * } | null} exclusions
 *
 * @returns {{ source: Set<string>; render: Set<string> }}
 */
function readExistingHashes(provenancePath, exclusions = null) {
    const source = new Set();
    const render = new Set();
    if (!fs.existsSync(provenancePath)) {
        if (exclusions && exclusions.scriptsByName.size > 0) {
            throw new Error(
                "Cannot exclude existing imports without an artwork provenance file."
            );
        }
        return { source, render };
    }
    exclusions?.matchedScriptNames.clear();
    const { scripts } = readArtworkProvenance(provenancePath);
    for (const [scriptName, entry] of scripts) {
        addExistingEntryHashes(scriptName, entry, exclusions, source, render);
    }
    validateMatchedExclusions(exclusions);
    return { source, render };
}

/**
 * @param {string[]} manifestPaths
 *
 * @returns {{
 *     manifestCount: number;
 *     scriptsByName: Map<
 *         string,
 *         { sourceSha256: string; renderSha256: string }
 *     >;
 *     matchedScriptNames: Set<string>;
 * }}
 */
function readExistingManifestExclusions(manifestPaths) {
    const scriptsByName = new Map();
    const resolvedPaths = new Set();
    for (const manifestPath of manifestPaths) {
        const resolvedPath = path.resolve(manifestPath);
        if (resolvedPaths.has(resolvedPath)) {
            throw new Error(
                `Existing import manifest was supplied more than once: ${resolvedPath}`
            );
        }
        resolvedPaths.add(resolvedPath);
        const manifest = requireObject(
            JSON.parse(fs.readFileSync(resolvedPath, "utf8")),
            `${resolvedPath} import manifest`
        );
        const scripts = requireArray(
            manifest.scripts,
            `${resolvedPath} scripts`
        );
        if (scripts.length === 0) {
            throw new Error(
                `${resolvedPath}: exclusion manifest must contain at least one script.`
            );
        }
        for (const [index, value] of scripts.entries()) {
            const script = requireObject(
                value,
                `${resolvedPath} script ${index + 1}`
            );
            const scriptName = requireString(
                script.scriptName,
                `${resolvedPath} script ${index + 1} name`
            );
            if (scriptsByName.has(scriptName)) {
                throw new Error(
                    `Existing import script was supplied more than once: ${scriptName}`
                );
            }
            const sourceSha256 = requireString(
                script.sourceSha256,
                `${scriptName} source SHA-256`
            ).toLowerCase();
            const renderSha256 = requireString(
                script.renderSha256,
                `${scriptName} render SHA-256`
            ).toLowerCase();
            if (
                !SHA256_PATTERN.test(sourceSha256) ||
                !SHA256_PATTERN.test(renderSha256)
            ) {
                throw new Error(
                    `${scriptName}: exclusion manifest hashes must be SHA-256 values.`
                );
            }
            scriptsByName.set(scriptName, {
                sourceSha256,
                renderSha256,
            });
        }
    }
    return {
        manifestCount: resolvedPaths.size,
        scriptsByName,
        matchedScriptNames: new Set(),
    };
}

/**
 * Render checked-in colorscripts through the same terminal fingerprint used for
 * archive candidates. Cache unchanged files by size and modification time so
 * exhaustive scans remain resumable without weakening duplicate checks.
 *
 * @param {string} scriptsDirectory
 * @param {string} cachePath
 *
 * @returns {{
 *     hashes: Set<string>;
 *     indexed: number;
 *     unique: number;
 *     failed: Record<string, string>;
 * }}
 */
function indexExistingScriptRenders(
    scriptsDirectory,
    cachePath,
    excludedScriptNames = new Set()
) {
    /**
     * @type {Record<
     *     string,
     *     {
     *         size: number;
     *         mtimeMs: number;
     *         normalizedRenderSha256?: string;
     *         error?: string;
     *     }
     * >}
     */
    let cached = {};
    if (fs.existsSync(cachePath)) {
        try {
            const parsed = requireObject(
                JSON.parse(fs.readFileSync(cachePath, "utf8")),
                "existing render cache"
            );
            if (parsed.algorithmVersion === 3) {
                cached = /** @type {typeof cached} */ (parsed.files || {});
            }
        } catch {
            cached = {};
        }
    }

    /** @type {typeof cached} */
    const next = {};
    const hashes = new Set();
    /** @type {Record<string, string>} */
    const failed = {};
    const scriptNames = fs
        .readdirSync(scriptsDirectory)
        .filter(
            (name) =>
                name.toLowerCase().endsWith(".ps1") &&
                !excludedScriptNames.has(path.parse(name).name)
        )
        .sort((left, right) => left.localeCompare(right));
    for (const scriptName of scriptNames) {
        const filePath = path.join(scriptsDirectory, scriptName);
        const stats = fs.statSync(filePath);
        const prior = cached[scriptName];
        if (
            prior &&
            prior.size === stats.size &&
            prior.mtimeMs === stats.mtimeMs
        ) {
            next[scriptName] = prior;
        } else {
            try {
                const source = fs.readFileSync(filePath, "utf8");
                const lines = extractLinesFromPs1(filePath);
                if (/# Converted from:/u.test(source) && lines[0] === "") {
                    lines.shift();
                }
                const converted = convertAnsiToPs1(lines.join("\r\n"), {
                    columns: 2048,
                    autoWrap: false,
                    stripSpaceBackground: false,
                });
                next[scriptName] = {
                    size: stats.size,
                    mtimeMs: stats.mtimeMs,
                    normalizedRenderSha256: fingerprintTerminal(
                        converted.terminal
                    ).renderSha256,
                };
            } catch (error) {
                next[scriptName] = {
                    size: stats.size,
                    mtimeMs: stats.mtimeMs,
                    error:
                        error instanceof Error ? error.message : String(error),
                };
            }
        }
        const entry = next[scriptName];
        if (entry.normalizedRenderSha256) {
            hashes.add(entry.normalizedRenderSha256);
        } else if (entry.error) {
            failed[scriptName] = entry.error;
        }
    }
    writeFileAtomic(
        cachePath,
        `${JSON.stringify({ algorithmVersion: 3, files: next }, null, 2)}\n`
    );
    const indexed = Object.values(next).filter(
        (entry) => typeof entry.normalizedRenderSha256 === "string"
    ).length;
    return { hashes, indexed, unique: hashes.size, failed };
}

/**
 * @param {Record<string, unknown>} candidate
 * @param {string} disposition
 * @param {string | null} [reviewNote]
 *
 * @returns {Record<string, unknown>}
 */
function rejectCandidate(candidate, disposition, reviewNote = null) {
    return {
        ...candidate,
        disposition,
        review: false,
        ...(reviewNote ? { reviewNote } : {}),
    };
}

/**
 * @param {Record<string, unknown>} analysis
 * @param {string} sourceFont
 * @param {string} candidateId
 *
 * @returns {string | null}
 */
function getUnsupportedFontReviewNote(analysis, sourceFont, candidateId) {
    if (analysis.encodingSupported === false) {
        const encoding = readOptionalString(
            analysis.encoding,
            `${candidateId} encoding`,
            sourceFont || "an unknown encoding"
        );
        return `The SAUCE font declares ${encoding}, whose glyph encoding cannot be reproduced faithfully by this converter.`;
    }
    if (/^Amiga\b/iu.test(sourceFont)) {
        return "The SAUCE font uses Amiga glyph semantics that cannot be reproduced faithfully by the gallery's CP437-to-Unicode PowerShell output.";
    }
    if (/\bVGA50\b/iu.test(sourceFont)) {
        return "The SAUCE font uses square 8x8 VGA50 cells whose source aspect ratio cannot be preserved in a normal PowerShell terminal.";
    }
    return null;
}

/**
 * @param {number} colorFamilyCount
 *
 * @returns {string | null}
 */
function getLowColorDisposition(colorFamilyCount) {
    if (colorFamilyCount > 2) return null;
    return colorFamilyCount <= 1 ? "rejected-monochrome" : "rejected-duotone";
}

/**
 * @param {boolean} likelyFiller
 * @param {number} width
 * @param {number} height
 *
 * @returns {string}
 */
function getPendingDisposition(likelyFiller, width, height) {
    if (likelyFiller) return "pending-review-filler";
    if (width > 120) return "pending-review-wide";
    if (height > 50) return "pending-review-split";
    return "pending-review";
}

/**
 * @param {Record<string, unknown>} candidate
 * @param {{ source: Set<string>; render: Set<string> }} existingHashes
 *
 * @returns {Record<string, unknown>}
 */
function classifyCandidate(candidate, existingHashes) {
    const candidateId = requireString(candidate.id, "candidate id");
    if (candidate.rawError) {
        return rejectCandidate(candidate, "rejected-malformed");
    }
    const analysis = requireObject(
        candidate.analysis,
        `${candidateId} analysis`
    );
    const sourceHash = requireString(
        analysis.sourceSha256,
        `${candidateId} source hash`
    );
    const normalizedRenderHash = requireString(
        analysis.normalizedRenderSha256 || analysis.renderSha256,
        `${candidateId} normalized render hash`
    );
    if (existingHashes.source.has(sourceHash)) {
        return rejectCandidate(candidate, "already-imported-source");
    }
    if (existingHashes.render.has(normalizedRenderHash)) {
        return rejectCandidate(candidate, "already-imported-render");
    }
    const warnings = requireArray(analysis.warnings, `${candidateId} warnings`);
    if (warnings.length > 0) {
        return rejectCandidate(candidate, "rejected-unsupported-terminal");
    }
    let sauce = null;
    if (analysis.sauce !== null && analysis.sauce !== undefined) {
        sauce = requireObject(analysis.sauce, `${candidateId} SAUCE`);
    }
    const sourceFont = readOptionalString(
        sauce?.font,
        `${candidateId} SAUCE font`
    ).trim();
    const unsupportedFontNote = getUnsupportedFontReviewNote(
        analysis,
        sourceFont,
        candidateId
    );
    if (unsupportedFontNote) {
        return rejectCandidate(
            candidate,
            "rejected-unsupported-font",
            unsupportedFontNote
        );
    }
    const colorFamilyCount = Number(analysis.colorFamilyCount);
    const lowColorDisposition = getLowColorDisposition(colorFamilyCount);
    if (lowColorDisposition) {
        return rejectCandidate(candidate, lowColorDisposition);
    }
    const width = Number(analysis.width);
    const height = Number(analysis.height);
    const filename = requireString(
        candidate.filename,
        `${candidateId} filename`
    );
    const archive = readOptionalString(
        candidate.archive,
        `${candidateId} archive`
    );
    if (
        /THEDRAW_TDF_FONTS_COLLECTION/iu.test(archive) &&
        /(?:^|[\\/])PREVIEW[\\/]/iu.test(filename)
    ) {
        return rejectCandidate(candidate, "rejected-font-preview");
    }
    const content = Array.isArray(candidate.content)
        ? candidate.content.join(" ").toLowerCase()
        : "";
    const likelyFiller =
        /(?:^|[._-])(?:file[_-]?id|nfo|mem(?:bers?)?)(?:[._-]|$)/iu.test(
            filename
        ) || /\b(?:memberlist|infofile|file id)\b/iu.test(content);
    return {
        ...candidate,
        disposition: getPendingDisposition(likelyFiller, width, height),
        review: true,
    };
}

/**
 * @param {unknown} artists
 * @param {Record<string, unknown> | null} sauce
 *
 * @returns {string[]}
 */
function getCandidateArtists(artists, sauce) {
    if (Array.isArray(artists) && artists.length > 0) {
        return artists.filter((artist) => typeof artist === "string");
    }
    if (typeof sauce?.author === "string" && sauce.author) {
        return [sauce.author];
    }
    return [];
}

/**
 * @param {Record<string, unknown>[]} candidates
 * @param {AuditOptions} options
 * @param {{ source: Set<string>; render: Set<string> }} existingHashes
 *
 * @returns {Promise<Record<string, unknown>[]>}
 */
async function analyzeCandidates(candidates, options, existingHashes) {
    let completed = 0;
    return mapConcurrent(candidates, options.concurrency, async (candidate) => {
        try {
            const candidateId = requireString(candidate.id, "candidate id");
            const source = requireString(
                candidate.source,
                `${candidateId} source`
            );
            const pack = requireString(candidate.pack, `${candidateId} pack`);
            const filename = requireString(
                candidate.filename,
                `${candidateId} filename`
            );
            const previewUrl = readOptionalString(
                candidate.previewUrl,
                `${candidateId} preview URL`
            );
            let raw = candidate.raw;
            let rawPath = candidate.rawPath;
            if (!raw) {
                const year =
                    candidate.year === undefined || candidate.year === null
                        ? "unknown"
                        : requireSafeInteger(
                              candidate.year,
                              `${candidateId} year`
                          ).toString();
                rawPath = path.join(
                    options.cacheDir,
                    source,
                    "raw",
                    safePathSegment(year),
                    safePathSegment(pack),
                    safePathSegment(filename)
                );
                raw = await fetchCached(
                    requireString(candidate.sourceUrl, "candidate source URL"),
                    {
                        cachePath: rawPath,
                        offline: options.offline,
                        binary: true,
                        maxBytes: MAX_INPUT_BYTES,
                    }
                );
            }
            const { analysis, terminal } = analyzeAnsiRender(
                /** @type {Buffer} */ (raw)
            );
            const sauce = analysis.sauce
                ? requireObject(analysis.sauce, `${candidateId} SAUCE`)
                : null;
            const artists = getCandidateArtists(candidate.artists, sauce);
            const groups =
                typeof sauce?.group === "string" && sauce.group
                    ? [sauce.group]
                    : [];
            const classified = classifyCandidate(
                {
                    ...candidate,
                    raw: undefined,
                    rawPath,
                    analysis,
                    artists,
                    groups,
                },
                existingHashes
            );
            if (classified.review && previewUrl) {
                const previewPath = path.join(
                    options.cacheDir,
                    "previews",
                    safePathSegment(source),
                    safePathSegment(pack),
                    `${safePathSegment(filename)}.png`
                );
                try {
                    await fetchCached(previewUrl, {
                        cachePath: previewPath,
                        offline: options.offline,
                        binary: true,
                        maxBytes: MAX_INPUT_BYTES,
                    });
                    classified.previewPath = previewPath;
                } catch (error) {
                    classified.previewError =
                        error instanceof Error ? error.message : String(error);
                }
            }
            if (classified.review && !classified.previewPath) {
                const previewPath = path.join(
                    options.cacheDir,
                    "previews",
                    "local-render",
                    safePathSegment(source),
                    safePathSegment(pack),
                    `${safePathSegment(filename)}.svg`
                );
                try {
                    if (!fs.existsSync(previewPath)) {
                        writeTerminalPreviewSvg(terminal, previewPath);
                    }
                    classified.previewPath = previewPath;
                    classified.previewKind = "local-terminal-render";
                } catch (error) {
                    classified.localPreviewError =
                        error instanceof Error ? error.message : String(error);
                }
            } else if (classified.previewPath) {
                classified.previewKind = "official-archive-preview";
            }
            return classified;
        } catch (error) {
            return {
                ...candidate,
                raw: undefined,
                disposition: "rejected-malformed",
                review: false,
                error: error instanceof Error ? error.message : String(error),
            };
        } finally {
            completed += 1;
            if (
                candidates.length >= 1_000 &&
                (completed % 1_000 === 0 || completed === candidates.length)
            ) {
                console.log(
                    `ANSI/ICE analysis: ${completed}/${candidates.length} candidates.`
                );
            }
        }
    });
}

/**
 * @param {Record<string, unknown>} record
 * @param {string} candidateId
 * @param {"artists" | "groups"} property
 *
 * @returns {string[] | undefined}
 */
function readDecisionAttributionOverride(record, candidateId, property) {
    if (record[property] === undefined) return undefined;
    const values = requireArray(record[property], `${candidateId} ${property}`);
    if (values.length === 0) {
        throw new TypeError(
            `${candidateId} ${property} must contain at least one name.`
        );
    }
    const normalized = values.map((value, index) => {
        const name = requireString(
            value,
            `${candidateId} ${property} item ${index + 1}`
        ).trim();
        if (name.length === 0) {
            throw new TypeError(
                `${candidateId} ${property} item ${index + 1} must not be blank.`
            );
        }
        return name;
    });
    const uniqueNames = new Set(
        normalized.map((name) => name.toLocaleLowerCase("en-US"))
    );
    if (uniqueNames.size !== normalized.length) {
        throw new TypeError(
            `${candidateId} ${property} must not contain duplicate names.`
        );
    }
    return normalized;
}

/**
 * Capture the converter-derived evidence a manual review actually evaluated.
 * Source and rendered-cell hashes detect byte or terminal-semantics changes;
 * geometry and color-family counts also catch meaningful analyzer changes that
 * may not affect the occupied-cell fingerprint (for example, trailing rows).
 *
 * @param {Record<string, unknown>} candidate
 *
 * @returns {{
 *     sourceSha256: string;
 *     renderSha256: string;
 *     width: number;
 *     height: number;
 *     colorFamilyCount: number;
 * }}
 */
function createDecisionEvidence(candidate) {
    const candidateId = requireString(candidate.id, "candidate id");
    const analysis = requireObject(
        candidate.analysis,
        `${candidateId} analysis`
    );
    const sourceSha256 = requireString(
        analysis.sourceSha256,
        `${candidateId} sourceSha256`
    ).toLowerCase();
    const renderSha256 = requireString(
        analysis.renderSha256,
        `${candidateId} renderSha256`
    ).toLowerCase();
    if (!SHA256_PATTERN.test(sourceSha256)) {
        throw new TypeError(
            `${candidateId} sourceSha256 must be a lowercase SHA-256 hash.`
        );
    }
    if (!SHA256_PATTERN.test(renderSha256)) {
        throw new TypeError(
            `${candidateId} renderSha256 must be a lowercase SHA-256 hash.`
        );
    }
    return {
        sourceSha256,
        renderSha256,
        width: requireSafeInteger(analysis.width, `${candidateId} width`, 1),
        height: requireSafeInteger(analysis.height, `${candidateId} height`, 1),
        colorFamilyCount: requireSafeInteger(
            analysis.colorFamilyCount,
            `${candidateId} colorFamilyCount`
        ),
    };
}

/**
 * @param {Record<string, unknown>} record
 * @param {Record<string, unknown>} candidate
 */
function validateDecisionEvidence(record, candidate) {
    const candidateId = requireString(candidate.id, "candidate id");
    const supplied = requireObject(
        record.evidence,
        `${candidateId} decision evidence`
    );
    const expected = createDecisionEvidence(candidate);
    for (const [property, expectedValue] of Object.entries(expected)) {
        const suppliedValue = supplied[property];
        if (suppliedValue !== expectedValue) {
            throw new Error(
                `${candidateId} decision evidence is stale: ${property} changed from ${JSON.stringify(
                    suppliedValue
                )} to ${JSON.stringify(
                    expectedValue
                )}. Review this candidate again before reusing the decision.`
            );
        }
    }
}

/**
 * @param {Record<string, unknown>[]} candidates
 * @param {string | null} decisionsPath
 *
 * @returns {Record<string, unknown>[]}
 */
function mergeDecisions(candidates, decisionsPath) {
    if (!decisionsPath || !fs.existsSync(decisionsPath)) return candidates;
    const parsed = requireObject(
        JSON.parse(fs.readFileSync(decisionsPath, "utf8")),
        "review decisions"
    );
    const schemaVersion =
        parsed.schemaVersion === undefined
            ? 1
            : requireSafeInteger(
                  parsed.schemaVersion,
                  "review decision schemaVersion",
                  1
              );
    if (schemaVersion > DECISION_SCHEMA_VERSION) {
        throw new Error(
            `Review decision schemaVersion ${schemaVersion} is newer than the supported version ${DECISION_SCHEMA_VERSION}.`
        );
    }
    const decisions = requireObject(
        parsed.decisions || parsed,
        "decisions map"
    );
    return candidates.map((candidate) => {
        const candidateId = requireString(candidate.id, "candidate id");
        const decision = decisions[candidateId];
        if (!decision) return candidate;
        const record = requireObject(decision, `${candidateId} decision`);
        const disposition = requireString(
            record.disposition,
            `${candidateId} disposition`
        );
        if (
            disposition !== "accepted" &&
            !disposition.startsWith("rejected-")
        ) {
            throw new Error(
                `${candidateId} decision must be accepted or a rejected-* reason.`
            );
        }
        if (schemaVersion >= 2) {
            validateDecisionEvidence(record, candidate);
        }
        // Manual review can only resolve candidates that still require manual
        // review. A later corpus import, parser hardening, or automatic safety
        // classification must remain authoritative even when the candidate's
        // own rendered evidence is unchanged.
        const currentDisposition = requireString(
            candidate.disposition,
            `${candidateId} current disposition`
        );
        if (!currentDisposition.startsWith("pending-review")) {
            return candidate;
        }
        // File-scoped overrides keep verified attribution in the resumable
        // decision instead of a generated report that the next refresh
        // overwrites.
        const artists = readDecisionAttributionOverride(
            record,
            candidateId,
            "artists"
        );
        const groups = readDecisionAttributionOverride(
            record,
            candidateId,
            "groups"
        );
        return {
            ...candidate,
            disposition,
            review: false,
            ...(artists ? { artists } : {}),
            ...(groups ? { groups } : {}),
            reviewNote:
                typeof record.note === "string" ? record.note : undefined,
        };
    });
}

/**
 * @param {Record<string, unknown>[]} candidates
 *
 * @returns {Record<string, number>}
 */
function summarizeDispositions(candidates) {
    /** @type {Record<string, number>} */
    const summary = {};
    for (const candidate of candidates) {
        const disposition = readOptionalString(
            candidate.disposition,
            "candidate disposition",
            "unclassified"
        );
        summary[disposition] = (summary[disposition] || 0) + 1;
    }
    return Object.fromEntries(
        Object.entries(summary).sort(([left], [right]) =>
            left.localeCompare(right)
        )
    );
}

/**
 * Prefer an explicit accepted decision, then a reviewable record with useful
 * attribution and an official preview. The final ID comparison keeps the
 * canonical choice stable across concurrency levels and cache state.
 *
 * @param {Record<string, unknown>} candidate
 *
 * @returns {number}
 */
function duplicateCanonicalPriority(candidate) {
    if (candidate.disposition === "accepted") return 0;
    // A file-scoped manual rejection is authoritative for byte-identical and
    // render-identical repacks. Keep that reviewed record canonical so an
    // undecided alias cannot replace it merely because deduplication runs
    // after decisions are merged.
    if (typeof candidate.reviewNote === "string") return 5;
    if (candidate.review !== true) return 100;
    const artists = Array.isArray(candidate.artists)
        ? candidate.artists.filter(Boolean)
        : [];
    if (artists.length > 0 && candidate.previewUrl) return 10;
    if (artists.length > 0) return 20;
    if (candidate.previewUrl) return 30;
    return 40;
}

/**
 * Deduplicate the current inventory after analysis and decision merging. Raw
 * source hashes take precedence over rendered-cell hashes so exact repacks are
 * distinguished from differently encoded streams that render identically.
 *
 * @param {Record<string, unknown>[]} candidates
 *
 * @returns {Record<string, unknown>[]}
 */
function deduplicateCandidates(candidates) {
    const records = candidates.map((candidate) => ({ ...candidate }));
    /**
     * Preserve useful archive metadata when an accepted or otherwise preferred
     * copy is byte-identical to a better-attributed repack. This does not merge
     * artwork or infer authorship: it only carries explicit metadata attached
     * to the exact same source bytes.
     *
     * @param {Record<string, unknown>} canonical
     * @param {Record<string, unknown>[]} group
     */
    const enrichCanonical = (canonical, group) => {
        let enriched = false;
        for (const field of [
            "artists",
            "groups",
            "content",
        ]) {
            const current = Array.isArray(canonical[field])
                ? canonical[field].filter(Boolean).map(String)
                : [];
            if (current.length > 0) continue;
            const inherited = [
                ...new Set(
                    group.flatMap((candidate) =>
                        Array.isArray(candidate[field])
                            ? candidate[field].filter(Boolean).map(String)
                            : []
                    )
                ),
            ].sort((left, right) => left.localeCompare(right));
            if (inherited.length > 0) {
                canonical[field] = inherited;
                enriched = true;
            }
        }
        for (const field of ["previewUrl", "galleryUrl"]) {
            if (canonical[field]) continue;
            const source = group.find(
                (candidate) => typeof candidate[field] === "string"
            );
            if (source) {
                canonical[field] = source[field];
                enriched = true;
            }
        }
        if (enriched) {
            canonical.metadataSources = group
                .filter((candidate) => candidate !== canonical)
                .map((candidate) => requireString(candidate.id, "candidate id"))
                .sort((left, right) => left.localeCompare(right));
        }
    };
    /**
     * @param {Record<string, unknown>[]} group
     *
     * @returns {Record<string, unknown>}
     */
    const chooseCanonical = (group) =>
        [...group].sort((left, right) => {
            const priority =
                duplicateCanonicalPriority(left) -
                duplicateCanonicalPriority(right);
            const leftId = requireString(left.id, "candidate id");
            const rightId = requireString(right.id, "candidate id");
            return priority || leftId.localeCompare(rightId);
        })[0];
    /**
     * @param {"sourceSha256" | "renderSha256" | "normalizedRenderSha256"} hashName
     * @param {Set<string>} excludedDispositions
     *
     * @returns {Map<string, Record<string, unknown>[]>}
     */
    const groupByHash = (hashName, excludedDispositions) => {
        const groups = new Map();
        for (const candidate of records) {
            const disposition = requireString(
                candidate.disposition,
                "candidate disposition"
            );
            if (excludedDispositions.has(disposition)) {
                continue;
            }
            const analysis = candidate.analysis;
            if (!analysis || typeof analysis !== "object") continue;
            const hash = /** @type {Record<string, unknown>} */ (analysis)[
                hashName
            ];
            if (typeof hash !== "string" || !/^[a-f\d]{64}$/u.test(hash)) {
                continue;
            }
            const matches = groups.get(hash) || [];
            matches.push(candidate);
            groups.set(hash, matches);
        }
        return groups;
    };

    const sourceExclusions = new Set([
        "already-imported-source",
        "already-imported-render",
        "rejected-malformed",
    ]);
    for (const group of groupByHash(
        "sourceSha256",
        sourceExclusions
    ).values()) {
        if (group.length < 2) continue;
        const canonical = chooseCanonical(group);
        enrichCanonical(canonical, group);
        for (const candidate of group) {
            if (candidate === canonical) continue;
            candidate.disposition = "rejected-duplicate-source";
            candidate.review = false;
            candidate.duplicateOf = canonical.id;
        }
    }

    const renderExclusions = new Set([
        ...sourceExclusions,
        "rejected-duplicate-source",
    ]);
    for (const candidate of records) {
        const analysis = candidate.analysis;
        if (!analysis || typeof analysis !== "object") {
            continue;
        }
        const analysisRecord = /** @type {Record<string, unknown>} */ (
            analysis
        );
        if (
            typeof analysisRecord.normalizedRenderSha256 !== "string" &&
            typeof analysisRecord.renderSha256 === "string"
        ) {
            analysisRecord.normalizedRenderSha256 = analysisRecord.renderSha256;
        }
    }
    for (const group of groupByHash(
        "normalizedRenderSha256",
        renderExclusions
    ).values()) {
        if (group.length < 2) continue;
        const canonical = chooseCanonical(group);
        for (const candidate of group) {
            if (candidate === canonical) continue;
            candidate.disposition = "rejected-duplicate-render";
            candidate.review = false;
            candidate.duplicateOf = canonical.id;
        }
    }
    return records;
}

/**
 * @param {Record<string, unknown>} report
 *
 * @returns {Record<string, unknown>}
 */
function createCheckpoint(report) {
    const candidates = requireArray(report.candidates, "report candidates").map(
        (candidate, index) => requireObject(candidate, `candidate ${index + 1}`)
    );
    const acceptedBySource = new Map();
    for (const candidate of candidates) {
        if (
            candidate.disposition !== "accepted" &&
            candidate.disposition !== "already-imported-source"
        ) {
            continue;
        }
        const candidateId = requireString(candidate.id, "candidate id");
        const analysis = requireObject(
            candidate.analysis,
            `${candidateId} analysis`
        );
        const sourceSha256 = requireString(
            analysis.sourceSha256,
            `${candidateId} source hash`
        );
        if (!acceptedBySource.has(sourceSha256)) {
            acceptedBySource.set(sourceSha256, {
                id: candidateId,
                disposition: candidate.disposition,
                sourceUrl: candidate.sourceUrl,
                sourceSha256,
                renderSha256: analysis.renderSha256,
            });
        }
    }
    return {
        schemaVersion: 1,
        scannedAt: report.scannedAt,
        policy: report.policy,
        inventory: report.inventory,
        canonicalInventorySha256: sha256(
            Buffer.from(JSON.stringify(report.inventory), "utf8")
        ),
        summary: report.summary,
        accepted: [...acceptedBySource.values()],
    };
}

/**
 * @param {Record<string, unknown>} report
 * @param {string} htmlPath
 */
function writeReviewHtml(report, htmlPath) {
    const candidates = requireArray(report.candidates, "report candidates")
        .map((candidate, index) =>
            requireObject(candidate, `candidate ${index + 1}`)
        )
        .filter(
            (candidate) =>
                candidate.review || candidate.disposition === "accepted"
        );
    const htmlDirectory = path.dirname(htmlPath);
    const reviewData = candidates.map((candidate) => {
        const candidateId = requireString(candidate.id, "candidate id");
        const analysis = candidate.analysis
            ? requireObject(candidate.analysis, `${candidateId} analysis`)
            : {};
        let preview = null;
        if (typeof candidate.previewPath === "string") {
            preview = path
                .relative(htmlDirectory, candidate.previewPath)
                .split(path.sep)
                .map(encodeURIComponent)
                .join("/");
        }
        const source =
            typeof candidate.galleryUrl === "string"
                ? candidate.galleryUrl
                : requireString(
                      candidate.sourceUrl,
                      `${candidateId} source URL`
                  );
        return {
            id: candidateId,
            filename: requireString(
                candidate.filename,
                `${candidateId} filename`
            ),
            artists: Array.isArray(candidate.artists)
                ? candidate.artists
                      .filter((artist) => typeof artist === "string")
                      .join(", ")
                : "",
            pack: requireString(candidate.pack, `${candidateId} pack`),
            width: analysis.width || "?",
            height: analysis.height || "?",
            colors: Array.isArray(analysis.colorFamilies)
                ? analysis.colorFamilies
                      .filter((family) => typeof family === "string")
                      .join(", ")
                : "",
            source,
            disposition: requireString(
                candidate.disposition,
                `${candidateId} disposition`
            ),
            evidence: createDecisionEvidence(candidate),
            preview,
        };
    });
    const serializedData = JSON.stringify(reviewData).replaceAll(
        "<",
        String.raw`\u003c`
    );
    const html = `<!doctype html><html lang="en"><meta charset="utf-8"><meta name="viewport" content="width=device-width"><title>ANSI archive review</title><style>body{background:#111;color:#eee;font:14px system-ui;margin:1rem}.controls{align-items:center;background:#111;display:flex;flex-wrap:wrap;gap:.5rem;position:sticky;top:0;z-index:2;padding:.5rem 0}.controls button{padding:.6rem .9rem}.controls input,.controls select{min-width:12rem;padding:.55rem}.grid{display:grid;grid-template-columns:repeat(auto-fill,minmax(280px,1fr));gap:1rem}.card{background:#222;border:1px solid #444;padding:.75rem}.card img{background:#000;display:block;height:360px;image-rendering:pixelated;object-fit:contain;width:100%}.missing{align-content:center;background:#000;color:#888;height:360px;text-align:center}h2{font-size:1rem;overflow-wrap:anywhere}label{display:block;margin-top:.5rem}.card input,.card select{box-sizing:border-box;width:100%}a{color:#7cc7ff}</style><h1>ANSI archive review</h1><p>${candidates.length} candidates require or retain a manual decision. At most 200 cards are rendered at once. Decisions are stored in this browser and exported as JSON for <code>--decisions</code>. Exported decisions include the reviewed source, render, geometry, and color evidence so stale decisions fail closed after converter changes.</p><div class="controls"><input id="search" type="search" placeholder="Filter artist, pack, filename"><select id="disposition"><option value="">All dispositions</option></select><button id="previous">Previous</button><span id="page"></span><button id="next">Next</button><button id="export">Export decisions</button></div><main class="grid" id="grid"></main><script id="review-data" type="application/json">${serializedData}</script><script>const data=JSON.parse(document.querySelector("#review-data").textContent);const key="ps-color-scripts-enhanced-ansi-decisions-v2";const saved=JSON.parse(localStorage.getItem(key)||"{}");const grid=document.querySelector("#grid");const search=document.querySelector("#search");const disposition=document.querySelector("#disposition");const pageLabel=document.querySelector("#page");const pageSize=200;let page=0;for(const value of [...new Set(data.map(item=>item.disposition))].sort()){const option=document.createElement("option");option.value=value;option.textContent=value;disposition.append(option)}const filtered=()=>{const term=search.value.trim().toLocaleLowerCase();return data.filter(item=>(!disposition.value||item.disposition===disposition.value)&&(!term||[item.filename,item.artists,item.pack,item.disposition].some(value=>value.toLocaleLowerCase().includes(term))))};const textElement=(tag,text,className)=>{const element=document.createElement(tag);element.textContent=text;if(className)element.className=className;return element};const evidenceMatches=(decision,item)=>JSON.stringify(decision?.evidence)===JSON.stringify(item.evidence);const render=()=>{const results=filtered();const pageCount=Math.max(1,Math.ceil(results.length/pageSize));page=Math.min(page,pageCount-1);const visible=results.slice(page*pageSize,(page+1)*pageSize);grid.replaceChildren();for(const item of visible){const card=document.createElement("article");card.className="card";card.dataset.id=item.id;if(item.preview){const preview=document.createElement("img");preview.loading="lazy";preview.src=item.preview;preview.alt="";card.append(preview)}else{card.append(textElement("div","No preview supplied","missing"))}card.append(textElement("h2",item.filename));card.append(textElement("p",(item.artists||"Unknown artist")+" · "+item.pack));card.append(textElement("p",item.width+"×"+item.height+" · "+item.colors));const sourceLine=document.createElement("p");const source=document.createElement("a");source.href=item.source;source.textContent="Source";sourceLine.append(source,document.createTextNode(" · "));sourceLine.append(textElement("code",item.disposition));card.append(sourceLine);const decisionLabel=document.createElement("label");decisionLabel.append(document.createTextNode("Decision "));const select=document.createElement("select");for(const [value,label] of [["","Undecided"],["accepted","Accept"],["rejected-quality","Reject: quality"],["rejected-content","Reject: content"],["rejected-duplicate","Reject: duplicate"],["rejected-composition","Reject: composition"]]){const option=document.createElement("option");option.value=value;option.textContent=label;select.append(option)}decisionLabel.append(select);const noteLabel=document.createElement("label");noteLabel.append(document.createTextNode("Note "));const input=document.createElement("input");input.type="text";noteLabel.append(input);card.append(decisionLabel,noteLabel);if(saved[item.id]&&!evidenceMatches(saved[item.id],item)){delete saved[item.id];localStorage.setItem(key,JSON.stringify(saved))}if(saved[item.id]){select.value=saved[item.id].disposition||"";input.value=saved[item.id].note||""}const persist=()=>{if(select.value){saved[item.id]={disposition:select.value,note:input.value,evidence:item.evidence}}else{delete saved[item.id]}localStorage.setItem(key,JSON.stringify(saved))};select.addEventListener("change",persist);input.addEventListener("change",persist);grid.append(card)}pageLabel.textContent=results.length+" matches · page "+(page+1)+"/"+pageCount;document.querySelector("#previous").disabled=page===0;document.querySelector("#next").disabled=page+1>=pageCount};search.addEventListener("input",()=>{page=0;render()});disposition.addEventListener("change",()=>{page=0;render()});document.querySelector("#previous").addEventListener("click",()=>{page-=1;render()});document.querySelector("#next").addEventListener("click",()=>{page+=1;render()});document.querySelector("#export").addEventListener("click",()=>{const currentIds=new Set(data.map(item=>item.id));const decisions=Object.fromEntries(Object.entries(saved).filter(([id,decision])=>currentIds.has(id)&&evidenceMatches(decision,data.find(item=>item.id===id))));const blob=new Blob([JSON.stringify({schemaVersion:${DECISION_SCHEMA_VERSION},decisions},null,2)+"\\n"],{type:"application/json"});const link=document.createElement("a");link.href=URL.createObjectURL(blob);link.download="ansi-archive-decisions.json";link.click();URL.revokeObjectURL(link.href)});render();</script></html>`;
    writeFileAtomic(htmlPath, html);
}

/**
 * @param {AuditOptions} options
 *
 * @returns {Promise<Record<string, unknown>>}
 */
async function runAudit(options) {
    fs.mkdirSync(options.cacheDir, { recursive: true });
    const provenancePath = path.resolve(
        __dirname,
        "..",
        "audit",
        "ArtworkProvenance.psd1"
    );
    const exclusions = readExistingManifestExclusions(
        options.excludedExistingManifestPaths
    );
    const existingHashes = readExistingHashes(provenancePath, exclusions);
    const scriptsDirectory = path.resolve(
        __dirname,
        "..",
        "ColorScripts-Enhanced",
        "Scripts"
    );
    const existingRenderIndex = indexExistingScriptRenders(
        scriptsDirectory,
        path.join(options.cacheDir, "existing-render-hashes.json"),
        new Set(exclusions.scriptsByName.keys())
    );
    for (const hash of existingRenderIndex.hashes) {
        existingHashes.render.add(hash);
    }
    /** @type {Record<string, unknown>[]} */
    let candidates = [];
    /** @type {Record<string, unknown>} */
    const inventory = {};
    inventory.existingGallery = {
        indexedRenderCount: existingRenderIndex.indexed,
        uniqueRenderCount: existingRenderIndex.unique,
        failedRenderCount: Object.keys(existingRenderIndex.failed).length,
        failedRenders: existingRenderIndex.failed,
        excludedManifestCount: exclusions.manifestCount,
        excludedScriptCount: exclusions.scriptsByName.size,
    };

    if (options.source === "16colors" || options.source === "all") {
        const packInventory = await listSixteenColorsPacks(options);
        const packs = packInventory.packs;
        console.log(`16colors: ${packs.length} packs selected.`);
        const detailedPacks = await mapConcurrent(
            packs,
            options.concurrency,
            async (pack, index) => {
                if ((index + 1) % 100 === 0 || index + 1 === packs.length) {
                    console.log(
                        `16colors metadata: ${index + 1}/${packs.length} packs.`
                    );
                }
                try {
                    const detail = await getSixteenColorsPack(pack, options);
                    return { ...detail, _listedPack: pack };
                } catch (error) {
                    return {
                        _auditError:
                            error instanceof Error
                                ? error.message
                                : String(error),
                        _listedPack: pack,
                    };
                }
            }
        );
        const failedPacks = detailedPacks
            .filter((pack) => typeof pack._auditError === "string")
            .map((pack) => ({
                name: requirePackName(
                    requireObject(pack._listedPack, "failed listed pack").name
                ),
                year: requireObject(pack._listedPack, "failed listed pack")
                    .year,
                error: pack._auditError,
            }));
        const validPacks = detailedPacks.filter(
            (pack) => typeof pack._auditError !== "string"
        );
        const candidateGroups = validPacks.map((pack) => {
            try {
                return {
                    pack,
                    candidates: extractSixteenColorsCandidates(pack),
                };
            } catch (error) {
                const listed = requireObject(
                    pack._listedPack,
                    "unextractable listed pack"
                );
                failedPacks.push({
                    name: requirePackName(listed.name),
                    year: listed.year,
                    error:
                        error instanceof Error ? error.message : String(error),
                });
                return { pack, candidates: [] };
            }
        });
        let archiveResults = [];
        if (!options.metadataOnly) {
            const groupsWithCandidates = candidateGroups.filter((group) => {
                const listed = requireObject(
                    group.pack._listedPack,
                    "listed 16colors pack"
                );
                const download =
                    typeof group.pack.download === "string"
                        ? group.pack.download
                        : listed.download;
                return (
                    group.candidates.length > 0 ||
                    (typeof download === "string" &&
                        new URL(download, SIXTEEN_COLORS_SITE).pathname
                            .toLowerCase()
                            .endsWith(".zip"))
                );
            });
            archiveResults = await mapConcurrent(
                groupsWithCandidates,
                Math.min(2, options.concurrency),
                async (group, index) => {
                    if (
                        (index + 1) % 100 === 0 ||
                        index + 1 === groupsWithCandidates.length
                    ) {
                        console.log(
                            `16colors archives: ${index + 1}/${groupsWithCandidates.length} packs.`
                        );
                    }
                    return cacheSixteenColorsArchive(
                        group.pack,
                        group.candidates,
                        options
                    );
                }
            );
        }
        const sixteenCandidates = candidateGroups.flatMap(
            (group) => group.candidates
        );
        const metadataFallbackPacks = validPacks
            .filter((pack) => typeof pack._metadataFallbackReason === "string")
            .map((pack) => {
                const listed = requireObject(
                    pack._listedPack,
                    "fallback listed pack"
                );
                return {
                    name: requirePackName(listed.name),
                    year: listed.year,
                    reason: pack._metadataFallbackReason,
                };
            });
        inventory.sixteenColors = {
            apiReportedPackTotal: packInventory.reportedTotal,
            apiEnumeratedPackCount: packInventory.enumeratedCount,
            apiUnreturnedPackCount:
                packInventory.reportedTotal - packInventory.enumeratedCount,
            packCount: packs.length,
            successfulPackCount: validPacks.length,
            failedPackCount: failedPacks.length,
            failedPacks,
            metadataFallbackPackCount: metadataFallbackPacks.length,
            metadataFallbackPacks,
            candidateCount: sixteenCandidates.length,
            archives: options.metadataOnly
                ? null
                : summarizeArchiveResults(archiveResults),
            fingerprint: sha256(
                JSON.stringify(
                    packs.map((pack) => [
                        pack.year,
                        pack.name,
                        pack.archive,
                    ])
                )
            ),
        };
        candidates.push(...sixteenCandidates);
    }

    if (options.source === "roy" || options.source === "all") {
        const roy = await auditRoyArchives(options);
        inventory.roy = {
            archiveCount: roy.archives.length,
            candidateCount: roy.candidates.length,
            fingerprint: sha256(JSON.stringify(roy.archives)),
        };
        candidates.push(...roy.candidates);
    }

    if (!options.metadataOnly) {
        console.log(
            `${candidates.length} ANSI/ICE candidates selected for analysis.`
        );
        candidates = await analyzeCandidates(
            candidates,
            options,
            existingHashes
        );
    } else {
        candidates = candidates.map((candidate) => ({
            ...candidate,
            disposition: "metadata-only",
            review: false,
        }));
    }
    candidates = mergeDecisions(candidates, options.decisionsPath);
    candidates = deduplicateCandidates(candidates);
    candidates.sort((left, right) => {
        const leftId = requireString(left.id, "candidate id");
        const rightId = requireString(right.id, "candidate id");
        return leftId.localeCompare(rightId);
    });
    const report = {
        schemaVersion: 1,
        scannedAt: new Date().toISOString(),
        policy: {
            formats: ["ANS", "ICE"],
            colorDepth: "At least three visibly used color families",
            audience: "General audience",
            maxColumns: 120,
            maxRows: 50,
            wideWorks: "Logical panel splits only",
        },
        inventory,
        summary: summarizeDispositions(candidates),
        candidates,
    };
    writeFileAtomic(options.reportPath, `${JSON.stringify(report, null, 2)}\n`);
    writeReviewHtml(report, options.htmlPath);
    if (options.checkpointPath) {
        writeFileAtomic(
            options.checkpointPath,
            `${JSON.stringify(createCheckpoint(report), null, 2)}\n`
        );
    }
    return report;
}

/**
 * @param {Record<string, unknown>[]} results
 *
 * @returns {Record<string, unknown>}
 */
function summarizeArchiveResults(results) {
    const statuses = {};
    let extracted = 0;
    for (const result of results) {
        const status = readOptionalString(
            result.status,
            "archive status",
            "unknown"
        );
        statuses[status] = (statuses[status] || 0) + 1;
        extracted += Number(result.extracted) || 0;
    }
    return {
        attempted: results.length,
        extracted,
        statuses,
        failures: results.filter((result) => typeof result.error === "string"),
    };
}

async function main(argv = process.argv.slice(2)) {
    const options = parseArguments(argv);
    const report = await runAudit(options);
    console.log(`Report: ${options.reportPath}`);
    console.log(`Review: ${options.htmlPath}`);
    console.log(JSON.stringify(report.summary, null, 2));
}

if (require.main === module) {
    main().catch((error) => {
        console.error(
            `Error: ${error instanceof Error ? error.message : String(error)}`
        );
        process.exitCode = 1;
    });
}

module.exports = {
    analyzeAnsiBuffer,
    analyzeCandidates,
    cacheSixteenColorsArchive,
    classifyCandidate,
    createDecisionEvidence,
    createCheckpoint,
    deduplicateCandidates,
    extractRoyArchiveUrls,
    extractSixteenColorsCandidates,
    extractZipEntry,
    fetchCached,
    fingerprintGalleryOutput,
    fingerprintTerminal,
    getColorFamily,
    listSixteenColorsPacks,
    mapConcurrent,
    mergeDecisions,
    parseArguments,
    readExistingManifestExclusions,
    readExistingHashes,
    readResponseWithLimit,
    indexExistingScriptRenders,
    readZipDirectory,
    runAudit,
    summarizeDispositions,
    summarizeArchiveResults,
    writeTerminalPreviewSvg,
    writeReviewHtml,
};
