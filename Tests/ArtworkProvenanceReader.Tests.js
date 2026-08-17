"use strict";

const assert = require("node:assert/strict");
const childProcess = require("node:child_process");
const fs = require("node:fs");
const os = require("node:os");
const path = require("node:path");
const test = require("node:test");

const {
    UNMAPPED_SCRIPT_HASH_MODE,
    buildCompactArtworkHeader,
    getArtworkDetailsUrl,
    parseArtworkProvenance,
    parseCompactArtworkHeader,
    parseLeadingCommentHeader,
    readArtworkHeaderMigration,
    readArtworkProvenance,
    serializeArtworkProvenanceJson,
    sha256,
    upsertArtworkProvenanceScriptEntries,
} = require("../scripts/ArtworkProvenance.js");
const {
    buildGeneratedArtworkEntry,
    prepareGeneratedArtworkProvenance,
    readGeneratedArtworkTemplate,
} = require("../scripts/GeneratedArtworkProvenance.js");
const {
    addProvenanceProperties,
    assertUnmappedScriptsUnchanged,
    getFieldsSha256,
    getMissingProvenanceProperties,
    getUnmappedScriptSha256,
    main: migrationMain,
    reconstructLegacyFields,
} = require("../scripts/Migrate-ColorScriptProvenanceHeaders.js");
const {
    WEB_FIELDS,
    buildWebIndex,
    main: webIndexMain,
} = require("../scripts/Build-ArtworkProvenanceWebIndex.js");

const REPOSITORY_ROOT = path.resolve(__dirname, "..");
const SCRIPTS_DIRECTORY = path.join(
    REPOSITORY_ROOT,
    "ColorScripts-Enhanced",
    "Scripts"
);

test("hash-locked artwork files disable Git line-ending conversion", () => {
    const paths = [
        "ColorScripts-Enhanced/Scripts/16c-0196ciph-ad-ciph1.ps1",
        "ColorScripts-Enhanced/Scripts/botany-sunflower.ps1",
        "audit/ArtworkHeaderMigration.json",
        "audit/ArtworkProvenance.psd1",
        "docs/assets/artwork-provenance.json",
    ];
    const output = childProcess.execFileSync(
        "git",
        [
            "check-attr",
            "-z",
            "text",
            "--",
            ...paths,
        ],
        {
            cwd: REPOSITORY_ROOT,
            encoding: "utf8",
        }
    );
    const fields = output.split("\0");
    fields.pop();

    assert.equal(fields.length, paths.length * 3);
    for (let index = 0; index < fields.length; index += 3) {
        const filePath = fields[index];
        const attribute = fields[index + 1];
        const value = fields[index + 2];
        assert.equal(attribute, "text");
        assert.equal(value, "unset", `${filePath} must be marked -text`);
    }
});

test("unmapped-script hashes ignore checkout-only CRLF conversion", () => {
    const lf = Buffer.from("first\nsecond\n", "utf8");
    const crlf = Buffer.from("first\r\nsecond\r\n", "utf8");
    const changed = Buffer.from("first\nchanged\n", "utf8");
    const loneCr = Buffer.from("first\rsecond\n", "utf8");

    assert.equal(getUnmappedScriptSha256(lf), getUnmappedScriptSha256(crlf));
    assert.notEqual(
        getUnmappedScriptSha256(lf),
        getUnmappedScriptSha256(changed)
    );
    assert.notEqual(
        getUnmappedScriptSha256(lf),
        getUnmappedScriptSha256(loneCr)
    );
});

test("unmapped-script verification rejects inventory and content drift", () => {
    const expected = { first: "a", second: "b" };
    assert.doesNotThrow(() =>
        assertUnmappedScriptsUnchanged(expected, { ...expected })
    );
    assert.throws(
        () => assertUnmappedScriptsUnchanged(expected, { first: "a" }),
        /inventory has changed/u
    );
    assert.throws(
        () =>
            assertUnmappedScriptsUnchanged(expected, {
                first: "a",
                second: "changed",
            }),
        /second: unmapped legacy script has changed/u
    );
});

test("header migration reader requires canonical schema 2 evidence", () => {
    const directory = fs.mkdtempSync(
        path.join(os.tmpdir(), "artwork-header-migration-")
    );
    const migrationPath = path.join(directory, "migration.json");
    const valid = {
        provenanceSchemaVersion: 3,
        records: {},
        schemaVersion: 2,
        unmappedHashMode: UNMAPPED_SCRIPT_HASH_MODE,
        unmappedScripts: {},
    };
    try {
        fs.writeFileSync(migrationPath, JSON.stringify(valid));
        assert.equal(
            readArtworkHeaderMigration(migrationPath).unmappedHashMode,
            UNMAPPED_SCRIPT_HASH_MODE
        );
        for (const invalid of [
            { ...valid, schemaVersion: 1 },
            { ...valid, unmappedHashMode: "raw-sha256" },
            { ...valid, unmappedScripts: undefined },
        ]) {
            fs.writeFileSync(migrationPath, JSON.stringify(invalid));
            assert.throws(
                () => readArtworkHeaderMigration(migrationPath),
                /migration evidence is malformed/u
            );
        }
    } finally {
        fs.rmSync(directory, { force: true, recursive: true });
    }
});

function createFixture() {
    return `@{
    SchemaVersion = 2

    Collections = @{
        'example' = @{
            DisplayName = 'Example''s collection'
            License = 'ISC'
            Evidence = @(
                'https://example.test/one'
                'https://example.test/two'
            )
        }
    }

    Scripts = @{
        'example-art' = @{
            Collection = 'example'
            OriginalFilename = 'ART.ANS'
            Artist = 'Artist'
            HasSauce = $true
            SauceFlags = 2
        }
    }
}
`;
}

test("shared provenance reader preserves supported PowerShell data types", () => {
    const provenance = parseArtworkProvenance(createFixture());
    assert.equal(provenance.schemaVersion, 2);
    assert.deepEqual(
        [...provenance.collections],
        [
            [
                "example",
                {
                    DisplayName: "Example's collection",
                    License: "ISC",
                    Evidence: [
                        "https://example.test/one",
                        "https://example.test/two",
                    ],
                },
            ],
        ]
    );
    assert.deepEqual(provenance.scripts.get("example-art"), {
        Collection: "example",
        OriginalFilename: "ART.ANS",
        Artist: "Artist",
        HasSauce: true,
        SauceFlags: 2,
    });
});

test("shared provenance reader serializes a PowerShell-compatible JSON view", () => {
    const provenance = parseArtworkProvenance(createFixture());
    assert.deepEqual(JSON.parse(serializeArtworkProvenanceJson(provenance)), {
        SchemaVersion: 2,
        Collections: {
            example: {
                DisplayName: "Example's collection",
                Evidence: [
                    "https://example.test/one",
                    "https://example.test/two",
                ],
                License: "ISC",
            },
        },
        Scripts: {
            "example-art": {
                Artist: "Artist",
                Collection: "example",
                HasSauce: true,
                OriginalFilename: "ART.ANS",
                SauceFlags: 2,
            },
        },
    });
});

test("shared provenance reader rejects unknown collections and unsupported schemas", () => {
    assert.throws(
        () =>
            parseArtworkProvenance(
                createFixture().replace(
                    "Collection = 'example'",
                    "Collection = 'missing'"
                )
            ),
        /unknown collection missing/u
    );
    assert.throws(
        () =>
            parseArtworkProvenance(
                createFixture().replace(
                    "SchemaVersion = 2",
                    "SchemaVersion = 4"
                )
            ),
        /Unsupported artwork provenance schema version: 4/u
    );
});

test("compact artwork headers retain offline attribution and a script-scoped URL", () => {
    const header = buildCompactArtworkHeader("example-art", {
        OriginalFilename: "ART.ANS",
        Artist: "Artist\nInjected",
    });
    assert.equal(
        header,
        "# Artwork: ART.ANS by Artist Injected | Details: https://nick2bad4u.github.io/PS-Color-Scripts-Enhanced/docs/artwork.html?script=example-art"
    );
    assert.deepEqual(parseCompactArtworkHeader(header), {
        artist: "Artist Injected",
        title: "ART.ANS",
        url: getArtworkDetailsUrl("example-art"),
    });
    assert.throws(
        () => getArtworkDetailsUrl("../unsafe"),
        /Unsafe artwork script name/u
    );
});

test("compact artwork headers fall back to collection attribution", () => {
    const header = buildCompactArtworkHeader(
        "example-art",
        { OriginalFilename: "ART.ANS" },
        { Attribution: "Collection Artist" }
    );
    assert.match(header, /^# Artwork: ART\.ANS by Collection Artist \|/u);
});

test("leading comment parser preserves the exact body after a BOM and CRLF header", () => {
    const body = "Write-Host '\r\nART'\r\n";
    const source = `\uFEFF# Source URL: https://example.test/art.ans\r\n# Lines: 1-1\r\n\r\n${body}`;
    const parsed = parseLeadingCommentHeader(source);
    assert.ok(parsed);
    assert.equal(parsed.prefix, "\uFEFF");
    assert.equal(parsed.lineEnding, "\r\n");
    assert.equal(parsed.body, body);
    assert.equal(parsed.fields.get("Lines"), "1-1");
    assert.equal(sha256(parsed.body), sha256(body));
});

test("checked-in provenance maps every imported script exactly once", () => {
    const provenance = readArtworkProvenance();
    const importedPrefixes = [
        "16c-",
        "asciiville-",
        "botany-",
        "durdraw-",
        "os-ansi-",
        "roy-sac-",
    ];
    const importedNames = fs
        .readdirSync(SCRIPTS_DIRECTORY)
        .filter(
            (name) =>
                name.endsWith(".ps1") &&
                importedPrefixes.some((prefix) => name.startsWith(prefix))
        )
        .map((name) => name.slice(0, -4))
        .sort((left, right) => left.localeCompare(right, "en-US"));
    assert.deepEqual(
        [...provenance.scripts.keys()].sort((left, right) =>
            left.localeCompare(right, "en-US")
        ),
        importedNames
    );
});

test("migration stores missing archival fields and reconstructs the legacy digest", () => {
    const provenance = parseArtworkProvenance(createFixture());
    const entry = provenance.scripts.get("example-art");
    const collection = provenance.collections.get("example");
    const fields = new Map([
        ["Converted from", "ART.ANS"],
        ["Source encoding", "CP437"],
        ["Source License", "ISC"],
        ["Source Attribution", "Example's collection"],
    ]);
    const collectionWithAttribution = {
        ...collection,
        Attribution: "Example's collection",
    };
    const additions = getMissingProvenanceProperties(
        "example-art",
        fields,
        entry,
        collectionWithAttribution
    );
    assert.deepEqual(additions, {
        ConvertedFrom: "ART.ANS",
        SourceEncoding: "CP437",
    });
    const reconstructed = reconstructLegacyFields(
        { ...entry, ...additions },
        collectionWithAttribution,
        [...fields.keys()]
    );
    assert.equal(getFieldsSha256(reconstructed), getFieldsSha256(fields));

    const updated = addProvenanceProperties(
        createFixture(),
        new Map([["example-art", additions]])
    );
    assert.match(updated, /SchemaVersion = 3/u);
    assert.match(updated, /ConvertedFrom = 'ART\.ANS'/u);
    assert.match(updated, /SourceEncoding = 'CP437'/u);
    assert.equal(parseArtworkProvenance(updated).schemaVersion, 3);
});

test("web index uses compact field arrays and collection-backed artist details", () => {
    const parsed = parseArtworkProvenance(
        createFixture().replace(
            "License = 'ISC'",
            "License = 'ISC'\n            Attribution = 'Collection Artist'"
        )
    );
    const index = buildWebIndex(parsed);
    assert.deepEqual(index.fields, WEB_FIELDS);
    const script = index.scripts["example-art"];
    assert.equal(script[WEB_FIELDS.indexOf("Title")], "ART.ANS");
    assert.equal(script[WEB_FIELDS.indexOf("Artist")], "Artist");
    assert.equal(script.length, WEB_FIELDS.length);
});

test("generated artwork records are complete, compact, and safely upserted", () => {
    const directory = fs.mkdtempSync(path.join(os.tmpdir(), "cse-provenance-"));
    try {
        const templatePath = path.join(directory, "record.json");
        fs.writeFileSync(
            templatePath,
            JSON.stringify({
                Collection: "example",
                SourceFile: "pack/NEW.ANS",
                SourceUrl: "https://example.test/pack/raw/NEW.ANS",
                SourceRevision: "archive-sha256:test",
                Artist: "Example Artist",
                Attribution: "NEW.ANS by Example Artist.",
                SourceModification: "Decoded without reflow.",
            })
        );
        const template = readGeneratedArtworkTemplate(templatePath);
        const entry = buildGeneratedArtworkEntry({
            conversionMode: "TerminalEmulation",
            name: "example-new",
            sauce: null,
            sourceBuffer: Buffer.from("ANSI source"),
            sourceColumns: "1-80",
            sourceEncoding: "cp437",
            sourceName: "NEW.ANS",
            sourceRows: "1-20",
            template,
        });
        const updated = upsertArtworkProvenanceScriptEntries(
            createFixture(),
            new Map([["example-new", entry]])
        );
        const parsed = parseArtworkProvenance(updated);
        assert.equal(
            parsed.scripts.get("example-new").HeaderFormat,
            "CompactV1"
        );
        assert.equal(
            parsed.scripts.get("example-new").SourceSha256,
            sha256("ANSI source")
        );

        const provenancePath = path.join(directory, "ArtworkProvenance.psd1");
        fs.writeFileSync(provenancePath, createFixture());
        const prepared = prepareGeneratedArtworkProvenance(
            provenancePath,
            new Map([["example-new", entry]])
        );
        assert.equal(
            prepared.headers.get("example-new"),
            `${buildCompactArtworkHeader(
                "example-new",
                entry,
                parsed.collections.get("example")
            )}`
        );
        assert.equal(
            parseArtworkProvenance(prepared.provenanceSource).scripts.size,
            2
        );
    } finally {
        fs.rmSync(directory, { force: true, recursive: true });
    }
});

test("checked-in migration evidence prohibits verbose headers and payload drift", () => {
    const originalLog = console.log;
    console.log = () => {};
    try {
        assert.doesNotThrow(() => migrationMain(["--check"]));
    } finally {
        console.log = originalLog;
    }
});

test("checked-in web provenance index is generated from the authoritative PSD1", () => {
    const originalLog = console.log;
    console.log = () => {};
    try {
        assert.doesNotThrow(() => webIndexMain([]));
    } finally {
        console.log = originalLog;
    }
    const index = JSON.parse(
        fs.readFileSync(
            path.join(
                REPOSITORY_ROOT,
                "docs",
                "assets",
                "artwork-provenance.json"
            ),
            "utf8"
        )
    );
    const provenance = readArtworkProvenance();
    for (const name of provenance.scripts.keys()) {
        assert.ok(
            Object.hasOwn(index.scripts, name),
            `${getArtworkDetailsUrl(name)} has no web-index record.`
        );
        assert.equal(
            new URL(getArtworkDetailsUrl(name)).searchParams.get("script"),
            name
        );
    }
});

test("artwork details page never turns insecure origins into links", () => {
    const html = fs.readFileSync(
        path.join(REPOSITORY_ROOT, "docs", "artwork.html"),
        "utf8"
    );

    assert.doesNotMatch(html, /http:\/\//u);
    assert.match(html, /"https:\/\/16colo\.rs"/u);
    assert.match(html, /allowedExternalOrigins\.has\(url\.origin\)/u);
});
