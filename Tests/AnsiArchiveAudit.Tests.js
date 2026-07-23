"use strict";

const assert = require("node:assert/strict");
const fs = require("node:fs");
const os = require("node:os");
const path = require("node:path");
const zlib = require("node:zlib");
const { afterEach, test } = require("node:test");
const {
    analyzeAnsiBuffer,
    analyzeCandidates,
    cacheSixteenColorsArchive,
    classifyCandidate,
    createCheckpoint,
    deduplicateCandidates,
    extractRoyArchiveUrls,
    extractSixteenColorsCandidates,
    extractZipEntry,
    fetchCached,
    indexExistingScriptRenders,
    listSixteenColorsPacks,
    mergeDecisions,
    parseArguments,
    readResponseWithLimit,
    readZipDirectory,
    summarizeDispositions,
    writeTerminalPreviewSvg,
    writeReviewHtml,
} = require("../scripts/Audit-AnsiArchives.js");

const temporaryDirectories = [];

afterEach(() => {
    for (const directory of temporaryDirectories.splice(0)) {
        fs.rmSync(directory, { force: true, recursive: true });
    }
});

function createTemporaryDirectory() {
    const directory = fs.mkdtempSync(path.join(os.tmpdir(), "cse-audit-"));
    temporaryDirectories.push(directory);
    return directory;
}

function createStoredZip(filename, content) {
    const name = Buffer.from(filename, "utf8");
    const payload = Buffer.from(content);
    const crc32 = zlib.crc32(payload) >>> 0;
    const local = Buffer.alloc(30);
    local.writeUInt32LE(0x04034b50, 0);
    local.writeUInt16LE(20, 4);
    local.writeUInt16LE(0x0800, 6);
    local.writeUInt16LE(0, 8);
    local.writeUInt32LE(crc32, 14);
    local.writeUInt32LE(payload.length, 18);
    local.writeUInt32LE(payload.length, 22);
    local.writeUInt16LE(name.length, 26);

    const central = Buffer.alloc(46);
    central.writeUInt32LE(0x02014b50, 0);
    central.writeUInt16LE(20, 4);
    central.writeUInt16LE(20, 6);
    central.writeUInt16LE(0x0800, 8);
    central.writeUInt16LE(0, 10);
    central.writeUInt32LE(crc32, 16);
    central.writeUInt32LE(payload.length, 20);
    central.writeUInt32LE(payload.length, 24);
    central.writeUInt16LE(name.length, 28);

    const directoryOffset = local.length + name.length + payload.length;
    const eocd = Buffer.alloc(22);
    eocd.writeUInt32LE(0x06054b50, 0);
    eocd.writeUInt16LE(1, 8);
    eocd.writeUInt16LE(1, 10);
    eocd.writeUInt32LE(central.length + name.length, 12);
    eocd.writeUInt32LE(directoryOffset, 16);
    return Buffer.concat([
        local,
        name,
        payload,
        central,
        name,
        eocd,
    ]);
}

test("audit arguments keep report paths aligned with a custom cache", () => {
    const directory = createTemporaryDirectory();
    const options = parseArguments([
        "--source=16colors",
        `--cache-dir=${directory}`,
        "--concurrency=3",
        "--pagesize=250",
        "--pack=mist0624",
        "--year=2024",
    ]);

    assert.equal(options.source, "16colors");
    assert.equal(options.reportPath, path.join(directory, "report.json"));
    assert.equal(options.htmlPath, path.join(directory, "review.html"));
    assert.equal(options.concurrency, 3);
    assert.equal(options.pageSize, 250);
    assert.deepEqual(options.packs, ["mist0624"]);
    assert.throws(
        () => parseArguments(["--concurrency=0"]),
        /between 1 and 12/
    );
    assert.throws(
        () => parseArguments(["--source=unknown"]),
        /16colors, roy, or all/
    );
    assert.throws(
        () => parseArguments(["--pack=../escape"]),
        /safe 16colors pack name/
    );
});

test("cached requests retry transient failures and remain usable offline", async () => {
    const directory = createTemporaryDirectory();
    const cachePath = path.join(directory, "response.json");
    const statuses = [
        500,
        429,
        200,
    ];
    const delays = [];
    const signals = [];
    let calls = 0;
    const fetchImpl = async (unusedUrl, requestOptions) => {
        signals.push(requestOptions.signal);
        const status = statuses[calls];
        calls += 1;
        return new Response(status === 200 ? '{"ok":true}' : "temporary", {
            status,
        });
    };
    const result = await fetchCached("https://example.test/api", {
        cachePath,
        offline: false,
        fetchImpl,
        delayImpl: async (milliseconds) => {
            delays.push(milliseconds);
        },
    });

    assert.equal(result, '{"ok":true}');
    assert.equal(calls, 3);
    assert.deepEqual(delays, [500, 1000]);
    assert.ok(signals.every((signal) => signal instanceof AbortSignal));
    assert.equal(
        await fetchCached("https://example.test/api", {
            cachePath,
            offline: true,
            fetchImpl: async () => {
                throw new Error("cache should prevent a request");
            },
        }),
        result
    );
    await assert.rejects(
        fetchCached("https://example.test/missing", {
            cachePath: path.join(directory, "missing"),
            offline: true,
        }),
        /Offline cache miss/
    );
});

test("response streaming rejects declared and actual bodies above their limit", async () => {
    await assert.rejects(
        readResponseWithLimit(
            new Response("small", { headers: { "content-length": "100" } }),
            10,
            false
        ),
        /declares 100 bytes/
    );
    await assert.rejects(
        readResponseWithLimit(new Response("eleven bytes"), 10, true),
        /exceeds the 10-byte limit/
    );
    assert.equal(
        await readResponseWithLimit(new Response("allowed"), 10, false),
        "allowed"
    );
});

test("cached requests enforce an overall deadline when a fetch never settles", async () => {
    const directory = createTemporaryDirectory();
    let capturedSignal;
    await assert.rejects(
        fetchCached("https://example.test/hung", {
            cachePath: path.join(directory, "hung"),
            offline: false,
            attempts: 1,
            timeoutMs: 10,
            fetchImpl: async (unusedUrl, requestOptions) => {
                capturedSignal = requestOptions.signal;
                return new Promise(() => {});
            },
        }),
        /Request timed out after 10 ms/
    );
    assert.equal(capturedSignal.aborted, true);
});

test("16colors extraction accepts only ANS and ICE candidates", () => {
    const candidates = extractSixteenColorsCandidates({
        year: 2024,
        archive: "mist0624.zip",
        download: "https://16colo.rs/archive/2024/mist0624.zip",
        files: {
            "ART.ANS": {
                file: {
                    raw: "ART.ANS",
                    size: 123,
                    x1: { uri: "/pack/mist0624/x1/ART.ANS.png" },
                },
                artists: ["artist"],
                content: ["landscape"],
            },
            "SECOND.ICE": { file: { raw: "SECOND.ICE" } },
            "IMAGE.PNG": { file: { raw: "IMAGE.PNG" } },
        },
    });

    assert.deepEqual(
        candidates.map((candidate) => candidate.filename),
        ["ART.ANS", "SECOND.ICE"]
    );
    assert.equal(
        candidates[0].sourceUrl,
        "https://16colo.rs/pack/mist0624/raw/ART.ANS"
    );
    assert.equal(
        candidates[0].previewUrl,
        "https://16colo.rs/pack/mist0624/x1/ART.ANS.png"
    );

    const directoryPack = extractSixteenColorsCandidates({
        year: 2013,
        download: "/archive/2013/",
        _listedPack: { name: 2013, year: 2013, download: "/archive/2013/" },
        files: { "ART.ICE": { file: { raw: "ART.ICE" } } },
    });
    assert.equal(directoryPack[0].pack, "2013");
    assert.equal(directoryPack[0].archive, null);
    assert.equal(
        directoryPack[0].archiveUrl,
        "https://16colo.rs/archive/2013/"
    );

    assert.deepEqual(
        extractSixteenColorsCandidates({
            year: 2013,
            _listedPack: { name: 2013, year: 2013 },
            files: [],
        }),
        []
    );
    assert.throws(
        () =>
            extractSixteenColorsCandidates({
                year: 2013,
                _listedPack: { name: 2013, year: 2013 },
                files: [{ unexpected: true }],
            }),
        /must be a JSON object or an empty array/
    );
});

test("16colors pagination validates totals and preserves numeric pack names", async () => {
    const directory = createTemporaryDirectory();
    const apiDirectory = path.join(directory, "api");
    fs.mkdirSync(apiDirectory);
    fs.writeFileSync(
        path.join(apiDirectory, "packs-page-0001.json"),
        JSON.stringify({
            page: { pages: 2, total: 3 },
            results: [
                { name: 1990, year: 1990, archive: "1990.zip" },
                { name: "mist0624", year: 2024, archive: "mist0624.zip" },
            ],
        })
    );
    fs.writeFileSync(
        path.join(apiDirectory, "packs-page-0002.json"),
        JSON.stringify({
            page: { pages: 2, total: 3 },
            results: [{ name: "sac1294", year: 1994, archive: "sac1294.zip" }],
        })
    );
    const options = parseArguments([
        `--cache-dir=${directory}`,
        "--source=16colors",
        "--pagesize=2",
        "--offline",
    ]);

    const inventory = await listSixteenColorsPacks(options);
    assert.equal(inventory.reportedTotal, 3);
    assert.equal(inventory.enumeratedCount, 3);
    assert.deepEqual(
        inventory.packs.map((pack) => String(pack.name)),
        [
            "1990",
            "mist0624",
            "sac1294",
        ]
    );
});

test("ANSI analysis preserves cell geometry and detects visible color families", () => {
    const analysis = analyzeAnsiBuffer(
        Buffer.from(
            "\u001b[31mR\u001b[32mG\u001b[34mB\r\n\u001b[0m  X",
            "binary"
        )
    );

    assert.equal(analysis.width, 3);
    assert.equal(analysis.height, 2);
    assert.deepEqual(analysis.colorFamilies, [
        "blue",
        "green",
        "red",
    ]);
    assert.equal(analysis.colorFamilyCount, 3);
    assert.deepEqual(analysis.warnings, []);
    assert.equal(
        analysis.sourceSha256,
        "c246f4d4cb070b7bb3b64a44cafb4771ce530d3f4808fd490a39dbb9e985f695"
    );
    assert.equal(
        analysis.renderSha256,
        "691028cd4f4a9bb8933cf47388d03ba1be2adaa8ed090c486bd09558247a7925"
    );
});

test("ANSI analysis fingerprints CP437 graphic controls as visible cells", () => {
    const analysis = analyzeAnsiBuffer(
        Buffer.concat([
            Buffer.from("\u001b[1;34;44m", "binary"),
            Buffer.from([0x0f]),
            Buffer.from("\u001b[31mR\u001b[32mG", "binary"),
        ])
    );

    assert.equal(analysis.width, 3);
    assert.equal(analysis.height, 1);
    assert.equal(
        analysis.renderSha256,
        "2a1e29c77470d82a4e2a5dfd04fcc13cc60e12a179eb292d671620753b03497b"
    );
});

test("ANSI analysis serializes SAUCE as compact metadata rather than Buffer internals", () => {
    const content = Buffer.from("\u001b[31mR\u001b[32mG\u001b[34mB", "binary");
    const sauce = Buffer.alloc(128);
    sauce.write("SAUCE00", 0, "ascii");
    sauce.write("Compact", 7, "ascii");
    sauce.writeUInt32LE(content.length, 90);
    sauce.writeUInt16LE(80, 96);
    sauce.writeUInt16LE(25, 98);
    sauce.writeUInt8(1, 105);
    sauce.write("IBM VGA", 106, "ascii");

    const analysis = analyzeAnsiBuffer(Buffer.concat([content, sauce]));

    assert.deepEqual(analysis.sauce, {
        version: "00",
        title: "Compact",
        author: "",
        group: "",
        date: "\0\0\0\0\0\0\0\0",
        fileSize: content.length,
        dataType: 0,
        fileType: 0,
        width: 80,
        height: 25,
        tInfo3: 0,
        tInfo4: 0,
        flags: 1,
        iceColors: true,
        font: "IBM VGA",
        comments: [],
    });
    assert.doesNotMatch(JSON.stringify(analysis.sauce), /"type":"Buffer"/u);
    assert.equal(analysis.encoding, "CP437");
    assert.equal(analysis.encodingSupported, true);
});

test("ANSI analysis derives the source encoding from a registered SAUCE font", () => {
    const content = Buffer.from([0x1b, 0x5b, 0x33, 0x31, 0x6d, 0x86]);
    const sauce = Buffer.alloc(128);
    sauce.write("SAUCE00", 0, "ascii");
    sauce.writeUInt32LE(content.length, 90);
    sauce.writeUInt16LE(80, 96);
    sauce.write("IBM VGA 860", 106, "ascii");

    const analysis = analyzeAnsiBuffer(Buffer.concat([content, sauce]));

    assert.equal(analysis.encoding, "CP860");
    assert.equal(analysis.encodingName, "cp860");
    assert.equal(analysis.encodingSupported, true);
});

test("classification rejects duplicates and low-color art before manual review", () => {
    const base = {
        id: "16colors:pack/ART.ANS",
        filename: "ART.ANS",
        content: ["landscape"],
        analysis: {
            sourceSha256: "a".repeat(64),
            renderSha256: "b".repeat(64),
            warnings: [],
            colorFamilyCount: 3,
            width: 80,
            height: 100,
        },
    };
    assert.equal(
        classifyCandidate(base, {
            source: new Set(["a".repeat(64)]),
            render: new Set(),
        }).disposition,
        "already-imported-source"
    );
    assert.equal(
        classifyCandidate(
            {
                ...base,
                analysis: { ...base.analysis, colorFamilyCount: 2 },
            },
            { source: new Set(), render: new Set() }
        ).disposition,
        "rejected-duotone"
    );
    assert.equal(
        classifyCandidate(base, { source: new Set(), render: new Set() })
            .disposition,
        "pending-review-split"
    );
    assert.equal(
        classifyCandidate(
            {
                ...base,
                archive: "ROYS-THEDRAW_TDF_FONTS_COLLECTION.ZIP",
                filename: "THEDRAWFONTS/PREVIEW/FONT.TDF.ANS",
            },
            { source: new Set(), render: new Set() }
        ).disposition,
        "rejected-font-preview"
    );
});

test("classification rejects source fonts whose glyphs or aspect cannot survive PowerShell output", () => {
    const base = {
        id: "16colors:pack/ART.ANS",
        filename: "ART.ANS",
        analysis: {
            sourceSha256: "a".repeat(64),
            renderSha256: "b".repeat(64),
            warnings: [],
            colorFamilyCount: 3,
            width: 80,
            height: 25,
        },
    };
    const hashes = { source: new Set(), render: new Set() };

    for (const font of [
        "Amiga Topaz 2+",
        "Amiga mOsOul",
        "IBM VGA50",
        "IBM VGA 872",
        "IBM VGA MAZ",
    ]) {
        const unsupportedEncoding = /(?:872|MAZ)$/u.test(font);
        const result = classifyCandidate(
            {
                ...base,
                analysis: {
                    ...base.analysis,
                    sauce: { font },
                    encodingSupported: !unsupportedEncoding,
                    encoding: unsupportedEncoding ? font.slice(8) : "CP437",
                },
            },
            hashes
        );
        assert.equal(result.disposition, "rejected-unsupported-font");
        assert.equal(result.review, false);
        assert.match(String(result.reviewNote), /cannot be (?:reproduced|preserved)/u);
    }

    assert.equal(
        classifyCandidate(
            {
                ...base,
                analysis: {
                    ...base.analysis,
                    sauce: { font: "IBM VGA" },
                },
            },
            hashes
        ).disposition,
        "pending-review"
    );
});

test("missing previews do not misclassify valid artwork as malformed", async () => {
    const directory = createTemporaryDirectory();
    const options = parseArguments([
        `--cache-dir=${directory}`,
        "--source=16colors",
        "--offline",
    ]);
    const [candidate] = await analyzeCandidates(
        [
            {
                id: "16colors:pack/ART.ANS",
                source: "16colors",
                pack: "pack",
                filename: "ART.ANS",
                previewUrl: "https://example.test/preview.png",
                raw: Buffer.from("\u001b[31mR\u001b[32mG\u001b[34mB", "binary"),
            },
        ],
        options,
        { source: new Set(), render: new Set() }
    );

    assert.equal(candidate.disposition, "pending-review");
    assert.equal(candidate.review, true);
    assert.match(String(candidate.previewError), /Offline cache miss/u);
    assert.equal(candidate.previewKind, "local-terminal-render");
    assert.match(String(candidate.previewPath), /\.svg$/u);
    assert.match(
        fs.readFileSync(String(candidate.previewPath), "utf8"),
        /<svg[^>]+viewBox="0 0 640 16"/u
    );
});

test("scan-local duplicates retain one deterministic canonical candidate", () => {
    const baseAnalysis = {
        sourceSha256: "a".repeat(64),
        renderSha256: "b".repeat(64),
    };
    const candidates = deduplicateCandidates([
        {
            id: "16colors:pack/ART.ANS",
            disposition: "pending-review",
            review: true,
            artists: ["Artist"],
            analysis: baseAnalysis,
        },
        {
            id: "roy:pack/COPY.ANS",
            disposition: "pending-review",
            review: true,
            artists: ["Archive Artist"],
            groups: ["Archive Group"],
            analysis: baseAnalysis,
        },
        {
            id: "roy:pack/REENCODED.ANS",
            disposition: "pending-review",
            review: true,
            artists: [],
            analysis: {
                sourceSha256: "c".repeat(64),
                renderSha256: "b".repeat(64),
            },
        },
    ]);

    assert.equal(candidates[0].disposition, "pending-review");
    assert.equal(candidates[1].disposition, "rejected-duplicate-source");
    assert.equal(candidates[1].duplicateOf, candidates[0].id);
    assert.deepEqual(candidates[0].groups, ["Archive Group"]);
    assert.equal(
        candidates[0].metadataSources.includes(candidates[1].id),
        true
    );
    assert.equal(candidates[2].disposition, "rejected-duplicate-render");
    assert.equal(candidates[2].duplicateOf, candidates[0].id);
});

test("manual rejections remain canonical across duplicate repacks", () => {
    const analysis = {
        sourceSha256: "d".repeat(64),
        renderSha256: "e".repeat(64),
    };
    const candidates = deduplicateCandidates([
        {
            id: "roy:pack/REVIEWED.ANS",
            disposition: "rejected-content",
            review: false,
            reviewNote: "Recognizable third-party character.",
            artists: [],
            analysis,
        },
        {
            id: "16colors:pack/ALIAS.ANS",
            disposition: "pending-review",
            review: true,
            artists: ["Artist"],
            analysis,
        },
    ]);

    assert.equal(candidates[0].disposition, "rejected-content");
    assert.equal(candidates[1].disposition, "rejected-duplicate-source");
    assert.equal(candidates[1].duplicateOf, candidates[0].id);
});

test("existing script render indexing is cached and ignores generated presentation newline", () => {
    const directory = createTemporaryDirectory();
    const scriptsDirectory = path.join(directory, "Scripts");
    const cachePath = path.join(directory, "render-cache.json");
    fs.mkdirSync(scriptsDirectory);
    fs.writeFileSync(
        path.join(scriptsDirectory, "generated.ps1"),
        "# Converted from: source.ans\n\nWrite-Host '\n\u001b[31mR\u001b[32mG\u001b[34mB\u001b[0m'\n"
    );
    fs.copyFileSync(
        path.join(scriptsDirectory, "generated.ps1"),
        path.join(scriptsDirectory, "duplicate.ps1")
    );

    const first = indexExistingScriptRenders(scriptsDirectory, cachePath);
    const second = indexExistingScriptRenders(scriptsDirectory, cachePath);
    const sourceFingerprint = analyzeAnsiBuffer(
        Buffer.from("\u001b[31mR\u001b[32mG\u001b[34mB\u001b[0m", "binary")
    ).renderSha256;

    assert.equal(first.indexed, 2);
    assert.equal(first.unique, 1);
    assert.deepEqual([...first.hashes], [sourceFingerprint]);
    assert.deepEqual([...second.hashes], [...first.hashes]);
    assert.deepEqual(second.failed, {});
});

test("bounded ZIP reader inventories and verifies Roy ANSI entries", () => {
    const zip = createStoredZip("ROY/ART.ANS", "\u001b[31mROY");
    const entries = readZipDirectory(zip);

    assert.equal(entries.length, 1);
    assert.equal(entries[0].name, "ROY/ART.ANS");
    assert.equal(extractZipEntry(zip, entries[0]).toString(), "\u001b[31mROY");
    const corrupted = Buffer.from(zip);
    corrupted[30 + Buffer.byteLength("ROY/ART.ANS")] ^= 0xff;
    assert.throws(
        () => extractZipEntry(corrupted, readZipDirectory(corrupted)[0]),
        /CRC mismatch/
    );
    assert.throws(
        () => readZipDirectory(Buffer.from("not a zip")),
        /too small/
    );

    const centralDirectoryOffset = zip.indexOf(
        Buffer.from([
            0x50,
            0x4b,
            0x01,
            0x02,
        ])
    );
    const localRecordsOnly = zip.subarray(0, centralDirectoryOffset);
    const recoveredEntries = readZipDirectory(localRecordsOnly);
    assert.equal(recoveredEntries.length, 1);
    assert.equal(recoveredEntries[0].name, "ROY/ART.ANS");
    assert.equal(
        extractZipEntry(localRecordsOnly, recoveredEntries[0]).toString(),
        "\u001b[31mROY"
    );
});

test("16colors archive caching extracts supported candidates without raw requests", async () => {
    const directory = createTemporaryDirectory();
    const options = parseArguments([
        `--cache-dir=${directory}`,
        "--source=16colors",
        "--offline",
    ]);
    const archivePath = path.join(
        directory,
        "16colors",
        "archives",
        "2024",
        "mist0624.zip"
    );
    fs.mkdirSync(path.dirname(archivePath), { recursive: true });
    fs.writeFileSync(
        archivePath,
        createStoredZip("nested/ART.ANS", "\u001b[31marchive")
    );
    const candidates = [
        {
            filename: "ART.ANS",
            archiveUrl: "https://16colo.rs/archive/2024/mist0624.zip",
            declaredSize: 15,
        },
    ];
    const result = await cacheSixteenColorsArchive(
        {
            year: 2024,
            files: { "ART.ANS": { file: { size: 15 } } },
            _listedPack: { name: "mist0624", year: 2024 },
        },
        candidates,
        options
    );

    assert.equal(result.status, "cached");
    assert.equal(result.extracted, 1);
    assert.match(String(candidates[0].archiveSha256), /^[a-f\d]{64}$/u);
    assert.equal(
        fs.readFileSync(String(candidates[0].rawPath), "utf8"),
        "\u001b[31marchive"
    );
});

test("16colors archive caching recovers candidates omitted by pack metadata", async () => {
    const directory = createTemporaryDirectory();
    const options = parseArguments([
        `--cache-dir=${directory}`,
        "--source=16colors",
        "--offline",
    ]);
    const archivePath = path.join(
        directory,
        "16colors",
        "archives",
        "1999",
        "1oo-vs.zip"
    );
    fs.mkdirSync(path.dirname(archivePath), { recursive: true });
    fs.writeFileSync(
        archivePath,
        createStoredZip("nested/RECOVERED.ICE", "\u001b[31marchive")
    );
    const candidates = [];
    const result = await cacheSixteenColorsArchive(
        {
            year: 1999,
            download: "https://16colo.rs/archive/1999/1oo-vs.zip",
            files: [],
            _listedPack: {
                name: "1oo-vs",
                year: 1999,
                archive: "1oo-vs.zip",
            },
        },
        candidates,
        options
    );

    assert.equal(result.status, "cached");
    assert.equal(result.recovered, 1);
    assert.equal(result.extracted, 1);
    assert.equal(candidates.length, 1);
    assert.equal(candidates[0].filename, "nested/RECOVERED.ICE");
    assert.equal(candidates[0].metadataSource, "16colors-archive");
    assert.equal(
        candidates[0].sourceUrl,
        "https://16colo.rs/pack/1oo-vs/raw/nested/RECOVERED.ICE"
    );
    assert.equal(
        fs.readFileSync(String(candidates[0].rawPath), "utf8"),
        "\u001b[31marchive"
    );
});

test("16colors archive caching bypasses disproportionate mixed-media packs", async () => {
    const directory = createTemporaryDirectory();
    const candidates = [
        {
            archiveUrl: "https://16colo.rs/archive/2026/huge.zip",
            declaredSize: 256_000,
            filename: "ART.ANS",
        },
    ];
    const result = await cacheSixteenColorsArchive(
        {
            year: 2026,
            files: {
                "ART.ANS": { file: { size: 256_000 } },
                "MEDIA.PNG": { file: { size: 40 * 1024 * 1024 } },
            },
            _listedPack: { name: "huge", year: 2026 },
        },
        candidates,
        { cacheDir: directory, offline: true }
    );

    assert.equal(result.status, "raw-fallback-archive-inefficient");
    assert.equal(result.extracted, 0);
    assert.equal(candidates[0].rawPath, undefined);
});

test("Roy inventory parser keeps only unique SAC pack archives", () => {
    const urls = extractRoyArchiveUrls(`
        <a href="images/galleries/SACPACKS/SAC1294.ZIP">one</a>
        <a href="images/galleries/SACPACKS/SAC1294.ZIP">duplicate</a>
        <a href="http://www.roysac.com/images/galleries/ZIP/Roy_ANSI.ZIP">standalone</a>
        <a href="files/tools/SACVIEW.ZIP">tool</a>
    `);

    assert.deepEqual(urls, [
        "https://www.roysac.com/images/galleries/SACPACKS/SAC1294.ZIP",
        "https://www.roysac.com/images/galleries/ZIP/Roy_ANSI.ZIP",
    ]);
});

test("review decisions, summaries, checkpoints, and HTML remain deterministic", () => {
    const directory = createTemporaryDirectory();
    const decisionsPath = path.join(directory, "decisions.json");
    fs.writeFileSync(
        decisionsPath,
        JSON.stringify({
            decisions: {
                "16colors:pack/ART.ANS": {
                    disposition: "accepted",
                    note: "Strong landscape",
                },
            },
        })
    );
    const candidates = mergeDecisions(
        [
            {
                id: "16colors:pack/ART.ANS",
                filename: "ART.ANS",
                pack: "pack",
                sourceUrl: "https://example.test/ART.ANS",
                galleryUrl: "https://example.test/gallery",
                artists: ["artist"],
                disposition: "pending-review",
                review: true,
                analysis: {
                    sourceSha256: "a".repeat(64),
                    renderSha256: "b".repeat(64),
                    width: 80,
                    height: 25,
                    colorFamilies: [
                        "blue",
                        "green",
                        "red",
                    ],
                },
            },
        ],
        decisionsPath
    );
    const report = {
        scannedAt: "2026-07-22T00:00:00.000Z",
        policy: { formats: ["ANS", "ICE"] },
        inventory: { sixteenColors: { packCount: 1 } },
        summary: summarizeDispositions(candidates),
        candidates,
    };
    const checkpoint = createCheckpoint(report);
    assert.deepEqual(report.summary, { accepted: 1 });
    assert.equal(checkpoint.accepted.length, 1);
    assert.match(checkpoint.canonicalInventorySha256, /^[a-f\d]{64}$/u);
    assert.deepEqual(createCheckpoint(report), checkpoint);
    const importedCheckpoint = createCheckpoint({
        ...report,
        candidates: [
            ...candidates,
            {
                ...candidates[0],
                id: "16colors:pack/IMPORTED.ANS",
                disposition: "already-imported-source",
                analysis: {
                    ...candidates[0].analysis,
                    sourceSha256: "c".repeat(64),
                    renderSha256: "d".repeat(64),
                },
            },
            {
                ...candidates[0],
                id: "16colors:repack/IMPORTED.ANS",
                disposition: "already-imported-source",
                analysis: {
                    ...candidates[0].analysis,
                    sourceSha256: "c".repeat(64),
                    renderSha256: "d".repeat(64),
                },
            },
        ],
    });
    assert.equal(importedCheckpoint.accepted.length, 2);

    const htmlPath = path.join(directory, "review.html");
    writeReviewHtml(report, htmlPath);
    const html = fs.readFileSync(htmlPath, "utf8");
    assert.match(html, /Export decisions/);
    assert.match(html, /At most 200 cards/);
    assert.match(html, /Strong landscape|ART\.ANS/);
    assert.match(html, /grid\.replaceChildren/);
    assert.doesNotMatch(html, /<script[^>]+src=/u);
});

test("local review previews brighten the default DOS foreground", () => {
    const directory = createTemporaryDirectory();
    const outputPath = path.join(directory, "preview.svg");
    const terminal = {
        columns: 1,
        maxCol: 0,
        maxRow: 0,
        writtenCellCount: 1,
        rows: new Map([
            [
                0,
                {
                    maxCol: 0,
                    cells: new Map([
                        [
                            0,
                            {
                                char: "█",
                                attrs: {
                                    bold: true,
                                    dim: false,
                                    italic: false,
                                    underline: false,
                                    blink: false,
                                    inverse: false,
                                    hidden: false,
                                    strike: false,
                                    fg: null,
                                    bg: null,
                                },
                            },
                        ],
                    ]),
                },
            ],
        ]),
    };

    writeTerminalPreviewSvg(terminal, outputPath);

    const svg = fs.readFileSync(outputPath, "utf8");
    assert.match(svg, /fill="#ffffff"/u);
    assert.doesNotMatch(svg, /fill="#aaaaaa"/u);
});
