"use strict";

const assert = require("node:assert/strict");
const fs = require("node:fs");
const path = require("node:path");
const test = require("node:test");

const REPOSITORY_ROOT = path.resolve(__dirname, "..");
const LEDGER_PATH = path.join(
    REPOSITORY_ROOT,
    "audit",
    "AnsiPolicyRetentionReviewLedger.json"
);
const REMOVAL_MANIFEST_PATH = path.join(
    REPOSITORY_ROOT,
    "audit",
    "AnsiPolicyRemovalManifest.json"
);
const PROVENANCE_PATH = path.join(
    REPOSITORY_ROOT,
    "audit",
    "ArtworkProvenance.psd1"
);
const SCRIPTS_DIRECTORY = path.join(
    REPOSITORY_ROOT,
    "ColorScripts-Enhanced",
    "Scripts"
);
const SHA256_PATTERN = /^[0-9a-f]{64}$/u;
const SCRIPT_NAME_PATTERN = /^16c-[a-z0-9-]+$/u;
const SOURCE_ID_PATTERN = /^16colors:([^/]+)\/([^/]+)$/u;
const TAG_NAME_PATTERN = /^[a-z0-9-]+$/u;

function getQuotedProperty(block, propertyName) {
    const expression = new RegExp(
        String.raw`^ {12}${propertyName}\s*=\s*'((?:[^']|'')*)'\r?$`,
        "mu"
    );
    const match = expression.exec(block);
    return match ? match[1].replaceAll("''", "'") : null;
}

function parseProvenance(source) {
    const entries = new Map();
    for (const match of source.matchAll(
        /^ {8}'((?:[^']|'')+)' = @\{\r?\n([\s\S]*?)^ {8}\}\r?$/gmu
    )) {
        const name = match[1].replaceAll("''", "'");
        assert.ok(!entries.has(name), `Duplicate provenance entry: ${name}`);
        const block = match[2];
        entries.set(name, {
            collection: getQuotedProperty(block, "Collection"),
            normalizedRenderSha256: getQuotedProperty(
                block,
                "NormalizedRenderSha256"
            ),
            renderSha256: getQuotedProperty(block, "RenderSha256"),
            sourceFile: getQuotedProperty(block, "SourceFile"),
            sourceSha256: getQuotedProperty(block, "SourceSha256"),
            sourceUrl: getQuotedProperty(block, "SourceUrl"),
        });
    }
    return entries;
}

function assertCanonicalUrl(value, expected, label) {
    assert.equal(typeof value, "string", `${label} must be a string`);
    assert.doesNotThrow(() => new URL(value), `${label} must be a valid URL`);
    assert.equal(value, expected, `${label} must be canonical`);
    const parsed = new URL(value);
    assert.equal(parsed.protocol, "https:", `${label} must use HTTPS`);
    assert.equal(parsed.hostname, "16colo.rs", `${label} must use 16colo.rs`);
    assert.equal(parsed.port, "", `${label} must not specify a port`);
    assert.equal(parsed.username, "", `${label} must not contain credentials`);
    assert.equal(parsed.password, "", `${label} must not contain credentials`);
    assert.equal(parsed.search, "", `${label} must not contain a query`);
    assert.equal(parsed.hash, "", `${label} must not contain a fragment`);
}

function validateLedger({
    ledger,
    provenance,
    removalManifest,
    scriptsDirectory,
}) {
    assert.equal(ledger.schemaVersion, 1);
    assert.match(ledger.reviewedAt, /^\d{4}-\d{2}-\d{2}$/u);
    assert.equal(ledger.disposition, "retained-after-review");
    assert.ok(
        typeof ledger.policy === "string" && ledger.policy.trim().length > 0,
        "Policy must be documented"
    );
    assert.ok(
        typeof ledger.reviewBasis === "string" &&
            ledger.reviewBasis.trim().length > 0,
        "Review basis must be documented"
    );
    assert.ok(Array.isArray(ledger.works), "Ledger works must be an array");

    const removedSources = new Set(
        removalManifest.works.map((work) => work.id)
    );
    const removedScripts = new Set(
        removalManifest.scripts.map((script) => script.name)
    );
    const seenSources = new Set();
    const seenScripts = new Set();
    const orderedSourceIds = ledger.works.map((work) => work.id);
    assert.deepEqual(
        orderedSourceIds,
        [...orderedSourceIds].sort((left, right) =>
            left.localeCompare(right, "en-US")
        ),
        "Ledger sources must have deterministic ordering"
    );

    for (const work of ledger.works) {
        const sourceMatch = SOURCE_ID_PATTERN.exec(work.id);
        assert.ok(sourceMatch, `Malformed source ID: ${work.id}`);
        assert.ok(
            !seenSources.has(work.id),
            `Duplicate retained source: ${work.id}`
        );
        seenSources.add(work.id);
        assert.ok(
            !removedSources.has(work.id),
            `Retained source overlaps removal manifest: ${work.id}`
        );

        const sourceFile = `${sourceMatch[1]}/${sourceMatch[2]}`;
        const expectedSourceUrl =
            `https://16colo.rs/pack/${sourceMatch[1]}/raw/` + sourceMatch[2];
        assertCanonicalUrl(
            work.sourceUrl,
            expectedSourceUrl,
            `${work.id} source URL`
        );
        for (const [property, value] of Object.entries({
            normalizedRenderSha256: work.normalizedRenderSha256,
            renderSha256: work.renderSha256,
            sourceSha256: work.sourceSha256,
        })) {
            assert.match(
                value,
                SHA256_PATTERN,
                `${work.id} ${property} must be a lowercase SHA-256`
            );
        }
        assert.ok(
            typeof work.reviewRationale === "string" &&
                work.reviewRationale.trim().length > 0,
            `${work.id} must have a review rationale`
        );

        assert.ok(
            Array.isArray(work.officialTags) && work.officialTags.length > 0,
            `${work.id} must record at least one official tag`
        );
        const seenTags = new Set();
        for (const tag of work.officialTags) {
            assert.match(
                tag.name,
                TAG_NAME_PATTERN,
                `${work.id} has a malformed tag name`
            );
            assert.ok(
                !seenTags.has(tag.name),
                `${work.id} repeats official tag ${tag.name}`
            );
            seenTags.add(tag.name);
            assertCanonicalUrl(
                tag.url,
                `https://16colo.rs/tags/content/${tag.name}`,
                `${work.id} tag URL`
            );
        }

        assert.ok(
            Array.isArray(work.scripts) && work.scripts.length > 0,
            `${work.id} must name at least one emitted script`
        );
        assert.deepEqual(
            work.scripts,
            [...work.scripts].sort((left, right) =>
                left.localeCompare(right, "en-US")
            ),
            `${work.id} scripts must have deterministic ordering`
        );
        for (const scriptName of work.scripts) {
            assert.match(
                scriptName,
                SCRIPT_NAME_PATTERN,
                `${work.id} has a malformed script name`
            );
            assert.ok(
                !seenScripts.has(scriptName),
                `Duplicate retained script: ${scriptName}`
            );
            seenScripts.add(scriptName);
            assert.ok(
                !removedScripts.has(scriptName),
                `Retained script overlaps removal manifest: ${scriptName}`
            );
            assert.ok(
                fs.existsSync(path.join(scriptsDirectory, `${scriptName}.ps1`)),
                `Retained script is missing: ${scriptName}`
            );

            const entry = provenance.get(scriptName);
            assert.ok(entry, `Provenance is missing for ${scriptName}`);
            assert.equal(
                entry.collection,
                "16colors-permitted",
                `${scriptName} must use 16colors provenance`
            );
            assert.equal(
                entry.sourceFile,
                sourceFile,
                `${scriptName} source file differs from the retention ledger`
            );
            for (const property of [
                "sourceUrl",
                "sourceSha256",
                "renderSha256",
                "normalizedRenderSha256",
            ]) {
                assert.equal(
                    entry[property],
                    work[property],
                    `${scriptName} ${property} differs from the retention ledger`
                );
            }
        }
    }

    assert.equal(
        ledger.summary.works,
        seenSources.size,
        "Retention work summary is stale"
    );
    assert.equal(
        ledger.summary.scripts,
        seenScripts.size,
        "Retention script summary is stale"
    );
}

function loadValidationInput() {
    return {
        ledger: JSON.parse(fs.readFileSync(LEDGER_PATH, "utf8")),
        provenance: parseProvenance(fs.readFileSync(PROVENANCE_PATH, "utf8")),
        removalManifest: JSON.parse(
            fs.readFileSync(REMOVAL_MANIFEST_PATH, "utf8")
        ),
        scriptsDirectory: SCRIPTS_DIRECTORY,
    };
}

test("retained adult-tag review decisions reconcile with scripts and provenance", () => {
    assert.doesNotThrow(() => validateLedger(loadValidationInput()));
});

test("retention validation fails closed on missing scripts and provenance drift", () => {
    const missingScript = loadValidationInput();
    missingScript.ledger.works[0].scripts = ["16c-missing-retained-script"];
    assert.throws(
        () => validateLedger(missingScript),
        /Retained script is missing/u
    );

    const sourceMismatch = loadValidationInput();
    sourceMismatch.ledger.works[0].sourceSha256 = "0".repeat(64);
    assert.throws(
        () => validateLedger(sourceMismatch),
        /sourceSha256 differs/u
    );
});

test("retention validation rejects duplicates and removal overlap", () => {
    const duplicateSource = loadValidationInput();
    duplicateSource.ledger.works.splice(
        1,
        0,
        structuredClone(duplicateSource.ledger.works[0])
    );
    assert.throws(
        () => validateLedger(duplicateSource),
        /Duplicate retained source/u
    );

    const duplicateScript = loadValidationInput();
    duplicateScript.ledger.works[1].scripts = [
        duplicateScript.ledger.works[0].scripts[0],
    ];
    assert.throws(
        () => validateLedger(duplicateScript),
        /Duplicate retained script/u
    );

    const sourceOverlap = loadValidationInput();
    sourceOverlap.removalManifest.works.push({
        id: sourceOverlap.ledger.works[0].id,
    });
    assert.throws(
        () => validateLedger(sourceOverlap),
        /source overlaps removal manifest/u
    );

    const scriptOverlap = loadValidationInput();
    scriptOverlap.removalManifest.scripts.push({
        name: scriptOverlap.ledger.works[0].scripts[0],
    });
    assert.throws(
        () => validateLedger(scriptOverlap),
        /script overlaps removal manifest/u
    );
});

test("retention validation rejects malformed URLs and hashes", () => {
    const sourceUrl = loadValidationInput();
    sourceUrl.ledger.works[0].sourceUrl =
        "http://16colo.rs/pack/aaa-8991/raw/HIGHS.ANS";
    assert.throws(
        () => validateLedger(sourceUrl),
        /source URL must be canonical/u
    );

    const tagUrl = loadValidationInput();
    tagUrl.ledger.works[0].officialTags[0].url =
        "https://16colo.rs/tags/content/wrong";
    assert.throws(() => validateLedger(tagUrl), /tag URL must be canonical/u);

    const hash = loadValidationInput();
    hash.ledger.works[0].renderSha256 = "not-a-hash";
    assert.throws(
        () => validateLedger(hash),
        /renderSha256 must be a lowercase SHA-256/u
    );
});
