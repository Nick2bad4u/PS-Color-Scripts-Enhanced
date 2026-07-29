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
    { candidateFiles, evidenceRows, expectedMissingRows }
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
    assert.deepEqual(missingRows, expectedMissingRows);
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
