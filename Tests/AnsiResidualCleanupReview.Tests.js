"use strict";

const assert = require("node:assert/strict");
const fs = require("node:fs");
const path = require("node:path");
const test = require("node:test");
const {
    analyzeRow,
    auditAuthoredSourceContacts,
    extractPowerShellPayload,
    findContactDetails,
    getRenderedBlankRows,
    getReviewEvidenceHash,
    isFunctionalContactException,
    stripAnsiControls,
} = require("../scripts/Audit-ColorScriptContent.js");
const {
    getPayloadSha256,
    validateManifest,
} = require("../scripts/Apply-ColorScriptGeometryReview.js");

const REPOSITORY_ROOT = path.resolve(__dirname, "..");
const MODULE_ROOT = path.join(
    REPOSITORY_ROOT,
    "ColorScripts-Enhanced"
);
const SCRIPTS_DIRECTORY = path.join(MODULE_ROOT, "Scripts");
const CONTENT_LEDGER_PATH = path.join(
    MODULE_ROOT,
    "AnsiResidualContentReviewLedger.json"
);
const MIXED_TEXT_LEDGER_PATH = path.join(
    MODULE_ROOT,
    "AnsiResidualMixedTextReviewLedger.json"
);
const GEOMETRY_MANIFEST_PATH = path.join(
    MODULE_ROOT,
    "AnsiResidualGeometryReviewManifest.json"
);

function readPayloadRows(file) {
    const source = fs.readFileSync(
        path.join(SCRIPTS_DIRECTORY, file),
        "utf8"
    );
    return {
        rows: extractPowerShellPayload(source)
            .value.replace(/\r\n?/gu, "\n")
            .split("\n"),
        source,
    };
}

test("residual content review is hash-only and fully applied", () => {
    const ledger = JSON.parse(
        fs.readFileSync(CONTENT_LEDGER_PATH, "utf8")
    );

    assert.equal(ledger.schemaVersion, 1);
    assert.deepEqual(ledger.summary, {
        candidateFiles: 41,
        evidenceRows: 172,
        blankedRows: 148,
        removedRows: 6,
        artOnlyContextRows: 18,
        removedScripts: 27,
        removedWorks: 8,
        retainedFiles: 4,
        retainedRows: 13,
    });
    assert.equal(new Set(ledger.candidates.map(({ file }) => file)).size, 41);

    for (const candidate of ledger.candidates) {
        assert.ok(!Object.hasOwn(candidate, "text"));
        const { rows } = readPayloadRows(candidate.file);
        const currentHashCounts = new Map();
        for (const row of rows) {
            const hash = getReviewEvidenceHash(stripAnsiControls(row));
            currentHashCounts.set(
                hash,
                (currentHashCounts.get(hash) ?? 0) + 1
            );
        }
        for (const evidence of candidate.evidence) {
            assert.ok(!Object.hasOwn(evidence, "text"));
            assert.match(evidence.sha256, /^[a-f\d]{64}$/u);
            assert.equal(
                currentHashCounts.get(evidence.sha256) ?? 0,
                evidence.allowedRemainingOccurrences ?? 0,
                `${candidate.file}: reviewed row hash remains`
            );
        }
    }

    for (const retention of ledger.reviewedRetentions) {
        const { rows } = readPayloadRows(retention.file);
        const currentHashes = new Set(
            rows.map((row) =>
                getReviewEvidenceHash(stripAnsiControls(row))
            )
        );
        for (const evidence of retention.evidence) {
            assert.equal(
                currentHashes.has(evidence.sha256),
                true,
                `${retention.file}: retained row hash drifted`
            );
        }
    }

    for (const work of ledger.removedWorks) {
        assert.equal(work.disposition, "rejected-content");
        for (const script of work.scripts) {
            assert.equal(
                fs.existsSync(
                    path.join(SCRIPTS_DIRECTORY, `${script}.ps1`)
                ),
                false,
                `${script}: rejected script still exists`
            );
        }
    }
});

test("mixed text review is hash-only and fully applied", () => {
    const ledger = JSON.parse(
        fs.readFileSync(MIXED_TEXT_LEDGER_PATH, "utf8")
    );

    assert.equal(ledger.schemaVersion, 1);
    assert.deepEqual(ledger.summary, {
        candidateFiles: 77,
        evidenceRows: 614,
        categoryRows: {
            "bbs-promotion": 174,
            commentary: 219,
            "mixed-prose": 98,
            "commentary+prose-heavy": 45,
            "prose-heavy": 63,
            "commentary+mixed-prose": 15,
        },
    });
    assert.equal(new Set(ledger.candidates.map(({ file }) => file)).size, 77);
    assert.equal(
        ledger.candidates.reduce(
            (total, candidate) => total + candidate.evidence.length,
            0
        ),
        614
    );

    const missingRows = [];
    for (const candidate of ledger.candidates) {
        assert.ok(!Object.hasOwn(candidate, "text"));
        const { rows } = readPayloadRows(candidate.file);
        for (const evidence of candidate.evidence) {
            assert.ok(!Object.hasOwn(evidence, "text"));
            assert.match(evidence.sha256, /^[a-f\d]{64}$/u);
            const currentRow = rows[evidence.row - 1];
            if (currentRow === undefined) {
                missingRows.push({
                    file: candidate.file,
                    row: evidence.row,
                });
                continue;
            }
            assert.notEqual(
                getReviewEvidenceHash(stripAnsiControls(currentRow)),
                evidence.sha256,
                `${candidate.file}: row ${evidence.row} was not redacted`
            );
            assert.equal(
                analyzeRow(currentRow).letterCount,
                0,
                `${candidate.file}: row ${evidence.row} still contains letters`
            );
        }
    }
    assert.deepEqual(missingRows, [
        {
            file: "16c-rv-awxpk-rv-bbs-part02.ps1",
            row: 27,
        },
    ]);
});

test("residual geometry review preserves one blank row and every visible row", () => {
    const document = JSON.parse(
        fs.readFileSync(GEOMETRY_MANIFEST_PATH, "utf8")
    );
    const actions = validateManifest(document);

    assert.deepEqual(document.summary, {
        actions: 12,
        leadingCrops: 12,
        orphanTailCrops: 0,
    });
    assert.equal(actions.length, 12);
    assert.equal(
        actions.reduce((total, action) => total + action.rows, 0),
        77
    );

    for (const action of actions) {
        assert.equal(action.action, "crop-leading-blank-rows");
        assert.equal(action.preserveLeadingRows, 1);
        const { rows, source } = readPayloadRows(action.script);
        assert.equal(rows.length, action.totalRows - action.rows);
        assert.notEqual(
            getPayloadSha256(extractPowerShellPayload(source).value),
            action.expectedPayloadSha256
        );
        const blankRows = getRenderedBlankRows(rows);
        assert.equal(blankRows[0], true);
        assert.equal(blankRows[1], false);
    }
});

test("current gallery contains no unreviewed contact endpoints", () => {
    const findings = [];
    const files = fs
        .readdirSync(SCRIPTS_DIRECTORY, { withFileTypes: true })
        .filter(
            (entry) =>
                entry.isFile() &&
                entry.name.toLocaleLowerCase("en-US").endsWith(".ps1")
        )
        .map((entry) => entry.name)
        .sort((left, right) => left.localeCompare(right, "en-US"));

    for (const file of files) {
        const source = fs.readFileSync(
            path.join(SCRIPTS_DIRECTORY, file),
            "utf8"
        );
        try {
            const rows = extractPowerShellPayload(source)
                .value.replace(/\r\n?/gu, "\n")
                .split("\n");
            for (const [index, row] of rows.entries()) {
                const text = stripAnsiControls(row);
                const contact = findContactDetails(text);
                if (
                    contact.categories.length > 0 &&
                    !isFunctionalContactException(file, { text })
                ) {
                    findings.push({
                        categories: contact.categories,
                        file,
                        row: index + 1,
                    });
                }
            }
        } catch {
            for (const contact of auditAuthoredSourceContacts(source)) {
                findings.push({
                    categories: contact.categories,
                    file,
                    row: contact.row,
                });
            }
        }
    }

    assert.deepEqual(findings, []);
});
