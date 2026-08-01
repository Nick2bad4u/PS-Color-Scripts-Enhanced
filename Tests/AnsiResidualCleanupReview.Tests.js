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
    getRawRowHash,
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
const MIXED_TEXT_LEDGER2_PATH = path.join(
    MODULE_ROOT,
    "AnsiResidualMixedTextReviewLedger2.json"
);
const MIXED_TEXT_LEDGER3_PATH = path.join(
    MODULE_ROOT,
    "AnsiResidualMixedTextReviewLedger3.json"
);
const MIXED_TEXT_LEDGER4_PATH = path.join(
    MODULE_ROOT,
    "AnsiResidualMixedTextReviewLedger4.json"
);
const MIXED_TEXT_LEDGER5_PATH = path.join(
    MODULE_ROOT,
    "AnsiResidualMixedTextReviewLedger5.json"
);
const MIXED_TEXT_LEDGER6_PATH = path.join(
    MODULE_ROOT,
    "AnsiResidualMixedTextReviewLedger6.json"
);
const MIXED_TEXT_LEDGER7_PATH = path.join(
    MODULE_ROOT,
    "AnsiResidualMixedTextReviewLedger7.json"
);
const MIXED_TEXT_LEDGER8_PATH = path.join(
    MODULE_ROOT,
    "AnsiResidualMixedTextReviewLedger8.json"
);
const MIXED_TEXT_LEDGER9_PATH = path.join(
    MODULE_ROOT,
    "AnsiResidualMixedTextReviewLedger9.json"
);
const MIXED_TEXT_LEDGER10_PATH = path.join(
    MODULE_ROOT,
    "AnsiResidualMixedTextReviewLedger10.json"
);
const MIXED_TEXT_LEDGER11_PATH = path.join(
    MODULE_ROOT,
    "AnsiResidualMixedTextReviewLedger11.json"
);
const MIXED_TEXT_LEDGER12_PATH = path.join(
    MODULE_ROOT,
    "AnsiResidualMixedTextReviewLedger12.json"
);
const MIXED_TEXT_LEDGER13_PATH = path.join(
    MODULE_ROOT,
    "AnsiResidualMixedTextReviewLedger13.json"
);
const MIXED_TEXT_LEDGER14_PATH = path.join(
    MODULE_ROOT,
    "AnsiResidualMixedTextReviewLedger14.json"
);
const MIXED_TEXT_LEDGER15_PATH = path.join(
    MODULE_ROOT,
    "AnsiResidualMixedTextReviewLedger15.json"
);
const MIXED_TEXT_LEDGER16_PATH = path.join(
    MODULE_ROOT,
    "AnsiResidualMixedTextReviewLedger16.json"
);
const MIXED_TEXT_LEDGER17_PATH = path.join(
    MODULE_ROOT,
    "AnsiResidualMixedTextReviewLedger17.json"
);
const MIXED_TEXT_LEDGER18_PATH = path.join(
    MODULE_ROOT,
    "AnsiResidualMixedTextReviewLedger18.json"
);
const MIXED_TEXT_LEDGER19_PATH = path.join(
    MODULE_ROOT,
    "AnsiResidualMixedTextReviewLedger19.json"
);
const MIXED_TEXT_LEDGER20_PATH = path.join(
    MODULE_ROOT,
    "AnsiResidualMixedTextReviewLedger20.json"
);
const MIXED_TEXT_LEDGER21_PATH = path.join(
    MODULE_ROOT,
    "AnsiResidualMixedTextReviewLedger21.json"
);
const MIXED_TEXT_LEDGER22_PATH = path.join(
    MODULE_ROOT,
    "AnsiResidualMixedTextReviewLedger22.json"
);
const MIXED_TEXT_LEDGER23_PATH = path.join(
    MODULE_ROOT,
    "AnsiResidualMixedTextReviewLedger23.json"
);
const MIXED_TEXT_LEDGER24_PATH = path.join(
    MODULE_ROOT,
    "AnsiResidualMixedTextReviewLedger24.json"
);
const MIXED_TEXT_LEDGER25_PATH = path.join(
    MODULE_ROOT,
    "AnsiResidualMixedTextReviewLedger25.json"
);
const MIXED_TEXT_LEDGER26_PATH = path.join(
    MODULE_ROOT,
    "AnsiResidualMixedTextReviewLedger26.json"
);
const MIXED_TEXT_LEDGER27_PATH = path.join(
    MODULE_ROOT,
    "AnsiResidualMixedTextReviewLedger27.json"
);
const MIXED_TEXT_LEDGER28_PATH = path.join(
    MODULE_ROOT,
    "AnsiResidualMixedTextReviewLedger28.json"
);
const MIXED_TEXT_LEDGER29_PATH = path.join(
    MODULE_ROOT,
    "AnsiResidualMixedTextReviewLedger29.json"
);
const MIXED_TEXT_LEDGER30_PATH = path.join(
    MODULE_ROOT,
    "AnsiResidualMixedTextReviewLedger30.json"
);
const MIXED_TEXT_LEDGER31_PATH = path.join(
    MODULE_ROOT,
    "AnsiResidualMixedTextReviewLedger31.json"
);
const MIXED_TEXT_LEDGER32_PATH = path.join(
    MODULE_ROOT,
    "AnsiResidualMixedTextReviewLedger32.json"
);
const MIXED_TEXT_LEDGER33_PATH = path.join(
    MODULE_ROOT,
    "AnsiResidualMixedTextReviewLedger33.json"
);
const MIXED_TEXT_LEDGER34_PATH = path.join(
    MODULE_ROOT,
    "AnsiResidualMixedTextReviewLedger34.json"
);
const MIXED_TEXT_LEDGER35_PATH = path.join(
    MODULE_ROOT,
    "AnsiResidualMixedTextReviewLedger35.json"
);
const MIXED_TEXT_LEDGER36_PATH = path.join(
    MODULE_ROOT,
    "AnsiResidualMixedTextReviewLedger36.json"
);
const MIXED_TEXT_LEDGER37_PATH = path.join(
    MODULE_ROOT,
    "AnsiResidualMixedTextReviewLedger37.json"
);
const MIXED_TEXT_LEDGER38_PATH = path.join(
    MODULE_ROOT,
    "AnsiResidualMixedTextReviewLedger38.json"
);
const MIXED_TEXT_LEDGER39_PATH = path.join(
    MODULE_ROOT,
    "AnsiResidualMixedTextReviewLedger39.json"
);
const MIXED_TEXT_LEDGER40_PATH = path.join(
    MODULE_ROOT,
    "AnsiResidualMixedTextReviewLedger40.json"
);
const MIXED_TEXT_LEDGER41_PATH = path.join(
    MODULE_ROOT,
    "AnsiResidualMixedTextReviewLedger41.json"
);
const MIXED_TEXT_LEDGER42_PATH = path.join(
    MODULE_ROOT,
    "AnsiResidualMixedTextReviewLedger42.json"
);
const MIXED_TEXT_LEDGER43_PATH = path.join(
    MODULE_ROOT,
    "AnsiResidualMixedTextReviewLedger43.json"
);
const MIXED_TEXT_LEDGER44_PATH = path.join(
    MODULE_ROOT,
    "AnsiResidualMixedTextReviewLedger44.json"
);
const MIXED_TEXT_LEDGER45_PATH = path.join(
    MODULE_ROOT,
    "AnsiResidualMixedTextReviewLedger45.json"
);
const MIXED_TEXT_LEDGER46_PATH = path.join(
    MODULE_ROOT,
    "AnsiResidualMixedTextReviewLedger46.json"
);
const MIXED_TEXT_LEDGER47_PATH = path.join(
    MODULE_ROOT,
    "AnsiResidualMixedTextReviewLedger47.json"
);
const MIXED_TEXT_LEDGER48_PATH = path.join(
    MODULE_ROOT,
    "AnsiResidualMixedTextReviewLedger48.json"
);
const MIXED_TEXT_LEDGER49_PATH = path.join(
    MODULE_ROOT,
    "AnsiResidualMixedTextReviewLedger49.json"
);
const GEOMETRY_MANIFEST_PATH = path.join(
    MODULE_ROOT,
    "AnsiResidualGeometryReviewManifest.json"
);
const CONTENT_CHECKPOINT = JSON.parse(
    fs.readFileSync(
        path.join(MODULE_ROOT, "AnsiContentCurationCheckpoint.json"),
        "utf8"
    )
);
const POST_CURATION_DUPLICATE_SCRIPTS = new Set(
    CONTENT_CHECKPOINT.removals.postCurationDuplicateWorks.flatMap(
        ({ removedScripts = [] }) =>
            removedScripts.map((name) => `${name}.ps1`)
    )
);

function readPayloadRows(file) {
    const scriptPath = path.join(SCRIPTS_DIRECTORY, file);
    if (!fs.existsSync(scriptPath)) {
        assert.equal(
            POST_CURATION_DUPLICATE_SCRIPTS.has(file),
            true,
            `${file}: missing script must have a post-curation duplicate disposition`
        );
        return { rows: [], source: "" };
    }
    const source = fs.readFileSync(scriptPath, "utf8");
    return {
        rows: extractPowerShellPayload(source)
            .value.replace(/\r\n?/gu, "\n")
            .split("\n"),
        source,
    };
}

function assertAppliedMixedTextLedger(
    ledgerPath,
    {
        candidateFiles,
        evidenceRows,
        expectedMissingRows,
        expectedSupersededRows = [],
    }
) {
    const ledger = JSON.parse(fs.readFileSync(ledgerPath, "utf8"));

    assert.equal(ledger.schemaVersion, 1);
    assert.equal(ledger.summary.candidateFiles, candidateFiles);
    assert.equal(ledger.summary.evidenceRows, evidenceRows);
    assert.equal(
        Object.values(ledger.summary.categoryRows).reduce(
            (total, count) => total + count,
            0
        ),
        evidenceRows
    );
    assert.equal(
        new Set(ledger.candidates.map(({ file }) => file)).size,
        candidateFiles
    );
    assert.equal(
        ledger.candidates.reduce(
            (total, candidate) => total + candidate.evidence.length,
            0
        ),
        evidenceRows
    );

    const missingRows = [];
    const expectedSuperseded = new Set(
        expectedSupersededRows.map(({ file, row }) => `${file}:${row}`)
    );
    const supersededRows = [];
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
            if (evidence.action === "blank-columns") {
                assert.ok(Array.isArray(evidence.columnRanges));
                assert.match(
                    evidence.expectedRawSha256,
                    /^[a-f\d]{64}$/u
                );
                assert.match(
                    evidence.expectedRenderedSha256,
                    /^[a-f\d]{64}$/u
                );
                const key = `${candidate.file}:${evidence.row}`;
                if (expectedSuperseded.has(key)) {
                    supersededRows.push({
                        file: candidate.file,
                        row: evidence.row,
                    });
                    assert.notEqual(
                        getRawRowHash(currentRow),
                        evidence.expectedRawSha256,
                        `${key} was declared superseded but still matches the intermediate projection`
                    );
                } else {
                    assert.equal(
                        getRawRowHash(currentRow),
                        evidence.expectedRawSha256,
                        `${candidate.file}: row ${evidence.row} targeted raw projection drifted`
                    );
                    assert.equal(
                        getReviewEvidenceHash(
                            stripAnsiControls(currentRow)
                        ),
                        evidence.expectedRenderedSha256,
                        `${candidate.file}: row ${evidence.row} targeted rendered projection drifted`
                    );
                }
            } else {
                assert.equal(
                    analyzeRow(currentRow).letterCount,
                    0,
                    `${candidate.file}: row ${evidence.row} still contains letters`
                );
            }
        }
    }
    assert.deepEqual(missingRows, expectedMissingRows);
    const byCoordinate = (left, right) =>
        left.file.localeCompare(right.file, "en-US") || left.row - right.row;
    assert.deepEqual(
        [...supersededRows].sort(byCoordinate),
        [...expectedSupersededRows].sort(byCoordinate)
    );
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
        retainedFiles: 3,
        retainedRows: 7,
    });
    assert.equal(new Set(ledger.candidates.map(({ file }) => file)).size, 41);
    assert.equal(
        ledger.reviewedRetentions.reduce(
            (total, retention) => total + retention.evidence.length,
            0
        ),
        ledger.summary.retainedRows
    );

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

test("second mixed text review is hash-only and fully applied", () => {
    const ledger = JSON.parse(
        fs.readFileSync(MIXED_TEXT_LEDGER2_PATH, "utf8")
    );

    assert.equal(ledger.schemaVersion, 1);
    assert.equal(ledger.summary.candidateFiles, 755);
    assert.equal(ledger.summary.evidenceRows, 1629);
    assert.equal(
        Object.values(ledger.summary.categoryRows).reduce(
            (total, count) => total + count,
            0
        ),
        1629
    );
    assert.equal(new Set(ledger.candidates.map(({ file }) => file)).size, 755);
    assert.equal(
        ledger.candidates.reduce(
            (total, candidate) => total + candidate.evidence.length,
            0
        ),
        1629
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
            file: "16c-blde9412-fx-si1-part03.ps1",
            row: 51,
        },
        {
            file: "16c-blndr2019-tk-blendpress-part02.ps1",
            row: 19,
        },
        {
            file: "16c-d38-05-mc-alina.ps1",
            row: 35,
        },
        {
            file: "16c-ecl-pak4-ex-ecl.ps1",
            row: 25,
        },
        {
            file: "16c-fire0896-fr-apoc1.ps1",
            row: 28,
        },
        {
            file: "16c-fuel28-sm-nullart-part01.ps1",
            row: 27,
        },
        {
            file: "16c-kbsart03-lm-kbs.ps1",
            row: 26,
        },
        {
            file: "16c-nerp-04-us-black.ps1",
            row: 26,
        },
        {
            file: "16c-nph-06-cl-defc.ps1",
            row: 18,
        },
        {
            file: "16c-phat0297-tt-phat.ps1",
            row: 27,
        },
        {
            file: "16c-phat0497-tr-usefl-part02.ps1",
            row: 24,
        },
        {
            file: "16c-thesauna01-tk-flamesauna.ps1",
            row: 28,
        },
    ]);
});

test("third mixed text review is hash-only and fully applied", () => {
    const ledger = JSON.parse(
        fs.readFileSync(MIXED_TEXT_LEDGER3_PATH, "utf8")
    );

    assert.equal(ledger.schemaVersion, 1);
    assert.equal(ledger.summary.candidateFiles, 753);
    assert.equal(ledger.summary.evidenceRows, 1303);
    assert.equal(
        Object.values(ledger.summary.categoryRows).reduce(
            (total, count) => total + count,
            0
        ),
        1303
    );
    assert.equal(new Set(ledger.candidates.map(({ file }) => file)).size, 753);
    assert.equal(
        ledger.candidates.reduce(
            (total, candidate) => total + candidate.evidence.length,
            0
        ),
        1303
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
        { file: "16c-afc-r7-su-rehab-part03.ps1", row: 37 },
        { file: "16c-axf-ap-1-bx-bre.ps1", row: 22 },
        { file: "16c-brhood02-sor-ccol-part04.ps1", row: 46 },
        { file: "16c-d38-02-bs-dman.ps1", row: 41 },
        { file: "16c-drg0697-jda-j4p.ps1", row: 21 },
        { file: "16c-drop9705-rr-drop1.ps1", row: 44 },
        { file: "16c-forge-07-mj-fluph.ps1", row: 22 },
        { file: "16c-fos-0396-ck-opmn1.ps1", row: 27 },
        { file: "16c-fsn-0497-53-plan4.ps1", row: 26 },
        { file: "16c-fti-0695-cndx-kt-part03.ps1", row: 37 },
        { file: "16c-glue-21-psi-9904-part01.ps1", row: 23 },
        { file: "16c-impure70-pmt-cyberpunks-part02.ps1", row: 33 },
        { file: "16c-locus-08-us-loc1.ps1", row: 26 },
        { file: "16c-mdn-9704-rs-vansi.ps1", row: 18 },
        { file: "16c-mist1223-ni-xms23.ps1", row: 31 },
        { file: "16c-nh-0597-biz-locl-part02.ps1", row: 41 },
        { file: "16c-oph-0013-bhabt-06.ps1", row: 37 },
        { file: "16c-quad0896-mr-ut3.ps1", row: 24 },
        { file: "16c-rare-002-sqr-acmp.ps1", row: 21 },
        { file: "16c-surge14-imi-prt.ps1", row: 25 },
        { file: "16c-trans03-pc-mess.ps1", row: 28 },
    ]);
});

test("fourth mixed text review is hash-only and fully applied", () => {
    const ledger = JSON.parse(
        fs.readFileSync(MIXED_TEXT_LEDGER4_PATH, "utf8")
    );

    assert.equal(ledger.schemaVersion, 1);
    assert.equal(ledger.summary.candidateFiles, 709);
    assert.equal(ledger.summary.evidenceRows, 1311);
    assert.equal(
        Object.values(ledger.summary.categoryRows).reduce(
            (total, count) => total + count,
            0
        ),
        1311
    );
    assert.equal(new Set(ledger.candidates.map(({ file }) => file)).size, 709);
    assert.equal(
        ledger.candidates.reduce(
            (total, candidate) => total + candidate.evidence.length,
            0
        ),
        1311
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
        { file: "16c-k0tpr0be-tr-cedeu.ps1", row: 32 },
        { file: "16c-k0tpr0be-tr-cedeu.ps1", row: 35 },
    ]);
});

test("fifth mixed text review is hash-only and fully applied", () => {
    const ledger = JSON.parse(
        fs.readFileSync(MIXED_TEXT_LEDGER5_PATH, "utf8")
    );

    assert.equal(ledger.schemaVersion, 1);
    assert.equal(ledger.summary.candidateFiles, 671);
    assert.equal(ledger.summary.evidenceRows, 1298);
    assert.equal(
        Object.values(ledger.summary.categoryRows).reduce(
            (total, count) => total + count,
            0
        ),
        1298
    );
    assert.equal(new Set(ledger.candidates.map(({ file }) => file)).size, 671);
    assert.equal(
        ledger.candidates.reduce(
            (total, candidate) => total + candidate.evidence.length,
            0
        ),
        1298
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
        { file: "16c-laz09aug-cy-tge.ps1", row: 26 },
        { file: "16c-thst0895-ti-crwt-part02.ps1", row: 17 },
        { file: "16c-thst0895-ti-crwt-part02.ps1", row: 18 },
    ]);
});

test("sixth mixed text review is hash-only and fully applied", () => {
    const ledger = JSON.parse(
        fs.readFileSync(MIXED_TEXT_LEDGER6_PATH, "utf8")
    );

    assert.equal(ledger.schemaVersion, 1);
    assert.equal(ledger.summary.candidateFiles, 1276);
    assert.equal(ledger.summary.evidenceRows, 1943);
    assert.equal(
        Object.values(ledger.summary.categoryRows).reduce(
            (total, count) => total + count,
            0
        ),
        1943
    );
    assert.equal(
        new Set(ledger.candidates.map(({ file }) => file)).size,
        1276
    );
    assert.equal(
        ledger.candidates.reduce(
            (total, candidate) => total + candidate.evidence.length,
            0
        ),
        1943
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
        { file: "16c-blndr025-hen-ngst.ps1", row: 28 },
        { file: "16c-max-artpack-0993-sum-pos1.ps1", row: 40 },
        { file: "16c-rmrs-26-sh-yuri.ps1", row: 29 },
    ]);
});

test("seventh mixed text review is hash-only and fully applied", () => {
    const ledger = JSON.parse(
        fs.readFileSync(MIXED_TEXT_LEDGER7_PATH, "utf8")
    );

    assert.equal(ledger.schemaVersion, 1);
    assert.equal(ledger.summary.candidateFiles, 1376);
    assert.equal(ledger.summary.evidenceRows, 1897);
    assert.equal(
        Object.values(ledger.summary.categoryRows).reduce(
            (total, count) => total + count,
            0
        ),
        1897
    );
    assert.equal(
        new Set(ledger.candidates.map(({ file }) => file)).size,
        1376
    );
    assert.equal(
        ledger.candidates.reduce(
            (total, candidate) => total + candidate.evidence.length,
            0
        ),
        1897
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
        { file: "16c-dox-9611-lst-urbn.ps1", row: 24 },
        { file: "16c-glue-17-us-amend.ps1", row: 25 },
    ]);
});

test("eighth mixed text review is hash-only and fully applied", () => {
    const ledger = JSON.parse(
        fs.readFileSync(MIXED_TEXT_LEDGER8_PATH, "utf8")
    );

    assert.equal(ledger.schemaVersion, 1);
    assert.equal(ledger.summary.candidateFiles, 785);
    assert.equal(ledger.summary.evidenceRows, 1082);
    assert.equal(
        Object.values(ledger.summary.categoryRows).reduce(
            (total, count) => total + count,
            0
        ),
        1082
    );
    assert.equal(
        new Set(ledger.candidates.map(({ file }) => file)).size,
        785
    );
    assert.equal(
        ledger.candidates.reduce(
            (total, candidate) => total + candidate.evidence.length,
            0
        ),
        1082
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
        { file: "16c-dvl-pk01-ve-file.ps1", row: 16 },
        { file: "16c-laz09aug-3d-ta2.ps1", row: 26 },
        { file: "ansi-star-wars-nu-boba.ps1", row: 23 },
        { file: "h7-liquid.ps1", row: 19 },
    ]);
});

test("ninth mixed text review is hash-only and fully applied", () => {
    const ledger = JSON.parse(
        fs.readFileSync(MIXED_TEXT_LEDGER9_PATH, "utf8")
    );

    assert.equal(ledger.schemaVersion, 1);
    assert.equal(ledger.summary.candidateFiles, 134);
    assert.equal(ledger.summary.evidenceRows, 207);
    assert.equal(
        Object.values(ledger.summary.categoryRows).reduce(
            (total, count) => total + count,
            0
        ),
        207
    );
    assert.equal(
        new Set(ledger.candidates.map(({ file }) => file)).size,
        134
    );
    assert.equal(
        ledger.candidates.reduce(
            (total, candidate) => total + candidate.evidence.length,
            0
        ),
        207
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
    assert.deepEqual(missingRows, []);
});

test("tenth mixed text review is hash-only and fully applied", () => {
    assertAppliedMixedTextLedger(MIXED_TEXT_LEDGER10_PATH, {
        candidateFiles: 50,
        evidenceRows: 62,
        expectedMissingRows: [],
    });
});

test("eleventh mixed text review is hash-only and fully applied", () => {
    assertAppliedMixedTextLedger(MIXED_TEXT_LEDGER11_PATH, {
        candidateFiles: 170,
        evidenceRows: 227,
        expectedMissingRows: [
            { file: "16c-bmb-0496-phb-spls.ps1", row: 20 },
            { file: "16c-jasper08-bm-glue.ps1", row: 36 },
            {
                file: "16c-lap-0794-hs-vio-x-part04.ps1",
                row: 39,
            },
            {
                file: "16c-plenty-dx-100ln-part02.ps1",
                row: 51,
            },
            { file: "16c-rare-002-cko-wmsg.ps1", row: 17 },
        ],
    });
});

test("twelfth mixed text review is hash-only and fully applied", () => {
    assertAppliedMixedTextLedger(MIXED_TEXT_LEDGER12_PATH, {
        candidateFiles: 76,
        evidenceRows: 87,
        expectedMissingRows: [],
    });
});

test("thirteenth mixed text review is hash-only and fully applied", () => {
    assertAppliedMixedTextLedger(MIXED_TEXT_LEDGER13_PATH, {
        candidateFiles: 42,
        evidenceRows: 44,
        expectedMissingRows: [],
    });
});

test("fourteenth mixed text review is hash-only and fully applied", () => {
    assertAppliedMixedTextLedger(MIXED_TEXT_LEDGER14_PATH, {
        candidateFiles: 8,
        evidenceRows: 22,
        expectedMissingRows: [],
    });
});

test("fifteenth mixed text review is hash-only and fully applied", () => {
    assertAppliedMixedTextLedger(MIXED_TEXT_LEDGER15_PATH, {
        candidateFiles: 4,
        evidenceRows: 5,
        expectedMissingRows: [],
    });
});

test("sixteenth mixed text review is hash-only and fully applied", () => {
    assertAppliedMixedTextLedger(MIXED_TEXT_LEDGER16_PATH, {
        candidateFiles: 36,
        evidenceRows: 129,
        expectedMissingRows: [],
    });
});

test("seventeenth mixed text review is hash-only and fully applied", () => {
    assertAppliedMixedTextLedger(MIXED_TEXT_LEDGER17_PATH, {
        candidateFiles: 33,
        evidenceRows: 202,
        expectedMissingRows: [],
    });
});

test("eighteenth mixed text review is hash-only and fully applied", () => {
    assertAppliedMixedTextLedger(MIXED_TEXT_LEDGER18_PATH, {
        candidateFiles: 20,
        evidenceRows: 134,
        expectedMissingRows: [],
    });
});

test("nineteenth mixed text review is hash-only and fully applied", () => {
    assertAppliedMixedTextLedger(MIXED_TEXT_LEDGER19_PATH, {
        candidateFiles: 41,
        evidenceRows: 108,
        expectedMissingRows: [],
    });
});

test("twentieth mixed text review is hash-only and fully applied", () => {
    assertAppliedMixedTextLedger(MIXED_TEXT_LEDGER20_PATH, {
        candidateFiles: 48,
        evidenceRows: 230,
        expectedMissingRows: [],
    });
});

test("twenty-first mixed text review is hash-only and fully applied", () => {
    assertAppliedMixedTextLedger(MIXED_TEXT_LEDGER21_PATH, {
        candidateFiles: 42,
        evidenceRows: 264,
        expectedMissingRows: [],
    });
});

test("twenty-second mixed text review is hash-only and fully applied", () => {
    assertAppliedMixedTextLedger(MIXED_TEXT_LEDGER22_PATH, {
        candidateFiles: 29,
        evidenceRows: 192,
        expectedMissingRows: [],
    });
});

test("twenty-third mixed text review is hash-only and fully applied", () => {
    assertAppliedMixedTextLedger(MIXED_TEXT_LEDGER23_PATH, {
        candidateFiles: 8,
        evidenceRows: 46,
        expectedMissingRows: [],
    });
});

test("twenty-fourth mixed text review is hash-only and fully applied", () => {
    assertAppliedMixedTextLedger(MIXED_TEXT_LEDGER24_PATH, {
        candidateFiles: 1,
        evidenceRows: 4,
        expectedMissingRows: [],
    });
});

test("twenty-fifth mixed text review is hash-only and fully applied", () => {
    assertAppliedMixedTextLedger(MIXED_TEXT_LEDGER25_PATH, {
        candidateFiles: 2,
        evidenceRows: 13,
        expectedMissingRows: [],
    });
});

test("twenty-sixth mixed text review is hash-only and fully applied", () => {
    assertAppliedMixedTextLedger(MIXED_TEXT_LEDGER26_PATH, {
        candidateFiles: 2,
        evidenceRows: 4,
        expectedMissingRows: [{ file: "roy-sac-mva.ps1", row: 17 }],
    });
});

test("twenty-seventh mixed text review is hash-only and fully applied", () => {
    assertAppliedMixedTextLedger(MIXED_TEXT_LEDGER27_PATH, {
        candidateFiles: 53,
        evidenceRows: 81,
        expectedMissingRows: [
            { file: "16c-765n000-wt-aos01.ps1", row: 26 },
            { file: "16c-apathy06-mt-entr2.ps1", row: 26 },
            { file: "16c-awe-12-plz-pec.ps1", row: 27 },
            { file: "16c-awe-12-plz-pec.ps1", row: 28 },
            { file: "16c-axf-0197-sk-reque.ps1", row: 9 },
            { file: "16c-axf-ap-1-bx-camou.ps1", row: 22 },
            { file: "16c-cri-0495-da-cri.ps1", row: 43 },
            { file: "16c-elp-0297-sk-elp-1.ps1", row: 13 },
            { file: "16c-fact-04-pl-cot.ps1", row: 26 },
            { file: "16c-fact-04-pl-cot.ps1", row: 30 },
            { file: "16c-fos-0795-on-doa.ps1", row: 34 },
            { file: "16c-l0p18-03-sk-boxfi.ps1", row: 20 },
            { file: "16c-laz04mar-wa-air.ps1", row: 32 },
            { file: "16c-nph-05-hrc-dbw.ps1", row: 41 },
            { file: "16c-odium-04-ce-ld.ps1", row: 24 },
            { file: "16c-odium-04-ce-ld.ps1", row: 27 },
            {
                file: "16c-opx-0497-diz-neve-part02.ps1",
                row: 42,
            },
            {
                file: "16c-plan9-01-bf-ans1-part02.ps1",
                row: 34,
            },
            {
                file: "16c-plan9-01-bf-ans1-part02.ps1",
                row: 35,
            },
            { file: "16c-plenty-dx-plant.ps1", row: 25 },
            { file: "16c-purg-13-drm-ept.ps1", row: 19 },
            { file: "16c-rmrs-51-os-bksx.ps1", row: 26 },
            { file: "16c-rune0896-pn-genoc.ps1", row: 25 },
            { file: "16c-rune0896-pn-genoc.ps1", row: 26 },
            { file: "16c-sclr-25-us-acid.ps1", row: 21 },
            { file: "16c-shao0598-sm-sf.ps1", row: 27 },
            { file: "16c-twi-9709-dr-23l.ps1", row: 25 },
            { file: "16c-uni-0995-mt-gzer0.ps1", row: 27 },
            {
                file: "16c-vain0495-ic-alcat-part02.ps1",
                row: 23,
            },
            { file: "16c-woe0798a-drm-da.ps1", row: 25 },
        ],
    });
});

test("twenty-eighth mixed text review is hash-only and fully applied", () => {
    assertAppliedMixedTextLedger(MIXED_TEXT_LEDGER28_PATH, {
        candidateFiles: 193,
        evidenceRows: 249,
        expectedMissingRows: [],
        expectedSupersededRows: [
            { file: "16c-bommc01-mmc13-15.ps1", row: 18 },
            { file: "16c-bommc01-mmc13-15.ps1", row: 19 },
            { file: "16c-bommc01-mmc13-15.ps1", row: 20 },
            { file: "16c-omen-001-ai-00008.ps1", row: 20 },
            { file: "16c-omen-001-ai-00008.ps1", row: 21 },
            { file: "16c-phat0997-spc-bd.ps1", row: 21 },
            { file: "16c-phat0997-spc-bd.ps1", row: 22 },
        ],
    });
});

test("twenty-ninth mixed text review is hash-only and fully applied", () => {
    assertAppliedMixedTextLedger(MIXED_TEXT_LEDGER29_PATH, {
        candidateFiles: 221,
        evidenceRows: 374,
        expectedMissingRows: [
            { file: "16c-arla0196-apl-tcha.ps1", row: 44 },
            {
                file: "16c-blocktronics-blocktober-x0-burning-at-both-ends-part04.ps1",
                row: 50,
            },
            { file: "16c-fire-42-zir-p4nk-part02.ps1", row: 41 },
            { file: "roy-sac-pent.ps1", row: 17 },
        ],
    });
});

test("thirtieth mixed text review is hash-only and fully applied", () => {
    assertAppliedMixedTextLedger(MIXED_TEXT_LEDGER30_PATH, {
        candidateFiles: 95,
        evidenceRows: 331,
        expectedMissingRows: [],
        expectedSupersededRows: [
            { file: "16c-d0697a3-pnd-pmen.ps1", row: 7 },
            { file: "16c-d0697a3-pnd-pmen.ps1", row: 8 },
            { file: "16c-d0697a3-pnd-pmen.ps1", row: 9 },
            { file: "16c-d0697a3-pnd-pmen.ps1", row: 10 },
            { file: "16c-d0697a3-pnd-pmen.ps1", row: 11 },
            { file: "16c-d0697a3-pnd-pmen.ps1", row: 12 },
            { file: "16c-d0697a3-pnd-pmen.ps1", row: 13 },
            { file: "16c-d0697a3-pnd-pmen.ps1", row: 14 },
            { file: "16c-d0697a3-pnd-pmen.ps1", row: 15 },
            { file: "16c-d0697a3-pnd-pmen.ps1", row: 16 },
            { file: "16c-d0697a3-pnd-pmen.ps1", row: 17 },
            { file: "16c-d0697a3-pnd-pmen.ps1", row: 18 },
            { file: "16c-d0697a3-pnd-pmen.ps1", row: 19 },
            { file: "16c-d0697a3-pnd-pmen.ps1", row: 20 },
            { file: "16c-ira1297f-fs-fz1.ps1", row: 11 },
            { file: "16c-ira1297f-fs-fz1.ps1", row: 12 },
            { file: "16c-riot-019-pm-dr.ps1", row: 8 },
            { file: "16c-riot-019-pm-dr.ps1", row: 9 },
            { file: "16c-riot-019-pm-dr.ps1", row: 10 },
            { file: "16c-riot-019-pm-dr.ps1", row: 11 },
            { file: "16c-riot-019-pm-dr.ps1", row: 12 },
            { file: "16c-riot-019-pm-dr.ps1", row: 13 },
            { file: "16c-riot-019-pm-dr.ps1", row: 14 },
            { file: "16c-riot-019-pm-dr.ps1", row: 15 },
            { file: "16c-riot-019-pm-dr.ps1", row: 16 },
            { file: "16c-root0397-dt-nc2.ps1", row: 12 },
            { file: "16c-root0397-dt-nc2.ps1", row: 13 },
            { file: "16c-root0397-dt-nc2.ps1", row: 14 },
            { file: "16c-awe-15-tna-hys1.ps1", row: 11 },
            { file: "16c-awe-15-tna-hys1.ps1", row: 13 },
            { file: "16c-awe-15-tna-hys1.ps1", row: 15 },
            { file: "16c-awe-15-tna-hys1.ps1", row: 17 },
            { file: "16c-awe-15-tna-hys1.ps1", row: 19 },
            { file: "16c-awe-15-tna-hys1.ps1", row: 21 },
            { file: "16c-awe-15-tna-hys1.ps1", row: 23 },
            { file: "16c-awe-15-tna-hz2.ps1", row: 10 },
            { file: "16c-awe-15-tna-hz2.ps1", row: 12 },
            { file: "16c-awe-15-tna-hz2.ps1", row: 14 },
            { file: "16c-awe-15-tna-hz2.ps1", row: 16 },
            { file: "16c-awe9610-tna-eld.ps1", row: 8 },
            { file: "16c-awe9610-tna-eld.ps1", row: 10 },
            { file: "16c-awe9610-tna-eld.ps1", row: 12 },
            { file: "16c-awe9610-tna-eld.ps1", row: 14 },
            { file: "16c-awe9610-tna-eld.ps1", row: 16 },
            { file: "16c-awe9610-tna-eld.ps1", row: 18 },
            { file: "16c-awe9610-tna-eld.ps1", row: 20 },
            { file: "16c-awe9702-us-p1.ps1", row: 6 },
            { file: "16c-awe9703-tna-smnu.ps1", row: 10 },
            { file: "16c-awe9703-tna-smnu.ps1", row: 12 },
            { file: "16c-awe9703-tna-smnu.ps1", row: 14 },
            { file: "16c-awe9703-tna-smnu.ps1", row: 16 },
            { file: "16c-awe9703-tna-smnu.ps1", row: 18 },
            { file: "16c-awe9704-tna-fmnu.ps1", row: 12 },
            { file: "16c-awe9704-tna-fmnu.ps1", row: 14 },
            { file: "16c-awe9704-tna-fmnu.ps1", row: 16 },
            { file: "16c-awe9704-tna-fmnu.ps1", row: 18 },
            { file: "16c-awe9704-tna-fmnu.ps1", row: 20 },
            { file: "16c-awe9706-tna-pod2.ps1", row: 11 },
            { file: "16c-awe9706-tna-pod2.ps1", row: 12 },
            { file: "16c-awe9706-tna-pod2.ps1", row: 13 },
            { file: "16c-awe9706-tna-pod2.ps1", row: 14 },
            { file: "16c-awe9706-tna-pod2.ps1", row: 15 },
            { file: "16c-awe9706-tna-pod2.ps1", row: 16 },
            { file: "16c-awe9706-tna-pod2.ps1", row: 17 },
            { file: "16c-awe9706-tna-pod2.ps1", row: 18 },
            { file: "16c-awe9706-tna-pod2.ps1", row: 19 },
            { file: "16c-awe9706-tna-pod2.ps1", row: 20 },
            { file: "16c-awe9706-tna-pod2.ps1", row: 21 },
            { file: "16c-awe9706-tna-pod2.ps1", row: 22 },
            { file: "16c-mdn-9706-mr-domen.ps1", row: 19 },
            { file: "16c-phat0297-in-0297a-part02.ps1", row: 6 },
            { file: "16c-phat0997-us-tjg.ps1", row: 8 },
        ],
    });
});

test("thirty-first mixed text review is hash-only and fully applied", () => {
    assertAppliedMixedTextLedger(MIXED_TEXT_LEDGER31_PATH, {
        candidateFiles: 10,
        evidenceRows: 31,
        expectedMissingRows: [],
    });
});

test("thirty-second mixed text review is hash-only and fully applied", () => {
    assertAppliedMixedTextLedger(MIXED_TEXT_LEDGER32_PATH, {
        candidateFiles: 12,
        evidenceRows: 37,
        expectedMissingRows: [],
    });
});

test("thirty-third mixed text review is hash-only and fully applied", () => {
    assertAppliedMixedTextLedger(MIXED_TEXT_LEDGER33_PATH, {
        candidateFiles: 10,
        evidenceRows: 50,
        expectedMissingRows: [],
    });
});

test("thirty-fourth mixed text review is hash-only and fully applied", () => {
    assertAppliedMixedTextLedger(MIXED_TEXT_LEDGER34_PATH, {
        candidateFiles: 9,
        evidenceRows: 24,
        expectedMissingRows: [],
    });
});

test("thirty-fifth mixed text review is hash-only and fully applied", () => {
    assertAppliedMixedTextLedger(MIXED_TEXT_LEDGER35_PATH, {
        candidateFiles: 1,
        evidenceRows: 5,
        expectedMissingRows: [],
    });
});

test("thirty-sixth mixed text review is hash-only and fully applied", () => {
    assertAppliedMixedTextLedger(MIXED_TEXT_LEDGER36_PATH, {
        candidateFiles: 42,
        evidenceRows: 55,
        expectedMissingRows: [],
    });
});

test("thirty-seventh mixed text review is hash-only and fully applied", () => {
    assertAppliedMixedTextLedger(MIXED_TEXT_LEDGER37_PATH, {
        candidateFiles: 16,
        evidenceRows: 21,
        expectedMissingRows: [],
    });
});

test("thirty-eighth mixed text review is hash-only and fully applied", () => {
    assertAppliedMixedTextLedger(MIXED_TEXT_LEDGER38_PATH, {
        candidateFiles: 5,
        evidenceRows: 14,
        expectedMissingRows: [],
    });
});

test("thirty-ninth mixed text review is hash-only and fully applied", () => {
    assertAppliedMixedTextLedger(MIXED_TEXT_LEDGER39_PATH, {
        candidateFiles: 7,
        evidenceRows: 24,
        expectedMissingRows: [],
    });
});

test("fortieth mixed text review is hash-only and fully applied", () => {
    assertAppliedMixedTextLedger(MIXED_TEXT_LEDGER40_PATH, {
        candidateFiles: 14,
        evidenceRows: 35,
        expectedMissingRows: [],
    });
});

test("forty-first mixed text review is hash-only and fully applied", () => {
    assertAppliedMixedTextLedger(MIXED_TEXT_LEDGER41_PATH, {
        candidateFiles: 2,
        evidenceRows: 2,
        expectedMissingRows: [],
    });
});

test("forty-second mixed text review is hash-only and fully applied", () => {
    assertAppliedMixedTextLedger(MIXED_TEXT_LEDGER42_PATH, {
        candidateFiles: 12,
        evidenceRows: 85,
        expectedMissingRows: [],
    });
});

test("forty-third mixed text review is hash-only and fully applied", () => {
    assertAppliedMixedTextLedger(MIXED_TEXT_LEDGER43_PATH, {
        candidateFiles: 36,
        evidenceRows: 261,
        expectedMissingRows: [],
    });
});

test("forty-fourth mixed text review is hash-only and fully applied", () => {
    assertAppliedMixedTextLedger(MIXED_TEXT_LEDGER44_PATH, {
        candidateFiles: 13,
        evidenceRows: 52,
        expectedMissingRows: [],
    });
});

test("forty-fifth mixed text review is hash-only and fully applied", () => {
    assertAppliedMixedTextLedger(MIXED_TEXT_LEDGER45_PATH, {
        candidateFiles: 12,
        evidenceRows: 30,
        expectedMissingRows: [],
    });
});

test("forty-sixth mixed text review is hash-only and fully applied", () => {
    assertAppliedMixedTextLedger(MIXED_TEXT_LEDGER46_PATH, {
        candidateFiles: 4,
        evidenceRows: 8,
        expectedMissingRows: [],
    });
});

test("forty-seventh mixed text review is hash-only and fully applied", () => {
    assertAppliedMixedTextLedger(MIXED_TEXT_LEDGER47_PATH, {
        candidateFiles: 2,
        evidenceRows: 11,
        expectedMissingRows: [],
    });
});

test("forty-eighth mixed text review is hash-only and fully applied", () => {
    assertAppliedMixedTextLedger(MIXED_TEXT_LEDGER48_PATH, {
        candidateFiles: 5,
        evidenceRows: 10,
        expectedMissingRows: [],
    });
});

test("forty-ninth mixed text review is hash-only and fully applied", () => {
    assertAppliedMixedTextLedger(MIXED_TEXT_LEDGER49_PATH, {
        candidateFiles: 1,
        evidenceRows: 2,
        expectedMissingRows: [],
    });
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
