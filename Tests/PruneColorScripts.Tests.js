"use strict";

const assert = require("node:assert/strict");
const test = require("node:test");

const {
    assertSafeScriptName,
    getQuotedProperty,
    removeAnalysisExceptions,
    removeProvenanceEntries,
    removeScriptMetadataLines,
    updateCheckpoint,
} = require("../scripts/Prune-ColorScripts.js");

const NAME = "16c-example-part01";
const SOURCE_HASH = "a".repeat(64);
const PROVENANCE_BLOCK = `        '${NAME}' = @{
            SourceSha256         = '${SOURCE_HASH}'
        }
`;

test("assertSafeScriptName rejects paths and unsafe names", () => {
    assert.doesNotThrow(() => assertSafeScriptName(NAME));
    assert.throws(() => assertSafeScriptName("../escape"));
    assert.throws(() => assertSafeScriptName("Name With Spaces"));
});

test("removeProvenanceEntries removes exactly one complete block", () => {
    const source = `@{
    Scripts = @{
${PROVENANCE_BLOCK}        '16c-example-part02' = @{
            SourceSha256         = '${SOURCE_HASH}'
        }
    }
}
`;
    const result = removeProvenanceEntries(source, [NAME]);

    assert.equal(result.removedBlocks.size, 1);
    assert.doesNotMatch(result.source, new RegExp(NAME, "u"));
    assert.match(result.source, /16c-example-part02/u);
    assert.equal(
        getQuotedProperty(result.removedBlocks.get(NAME), "SourceSha256"),
        SOURCE_HASH
    );
});

test("removeScriptMetadataLines removes list, map, and description entries", () => {
    const source = `        '${NAME}',
        '${NAME}' = @('ANSI')
        '${NAME}' = 'Description.'
`;
    const result = removeScriptMetadataLines(source, [NAME]);

    assert.equal(result.removedLines.get(NAME), 3);
    assert.equal(result.source, "");
});

test("removeAnalysisExceptions removes only exact family matches", () => {
    const document = {
        exceptions: [
            { family: NAME, issueType: "mostly-plain-ascii" },
            { family: `${NAME}-other`, issueType: "mostly-plain-ascii" },
        ],
        schemaVersion: 1,
    };
    const result = removeAnalysisExceptions(document, [NAME]);

    assert.equal(result.removedCount, 1);
    assert.deepEqual(result.document.exceptions, [
        { family: `${NAME}-other`, issueType: "mostly-plain-ascii" },
    ]);
});

test("updateCheckpoint decrements emitted counts but retains the source", () => {
    const checkpoint = {
        sixteenColors: {
            acceptedSources: [
                { archiveYear: 2024, sourceSha256: SOURCE_HASH },
            ],
            totals: {
                acceptedSourceCount: 1,
                dispositionTotals: {
                    accepted: 1,
                    "rejected-quality": 0,
                },
                emittedScriptCount: 2,
                importedWorkCount: 1,
            },
            years: [
                {
                    dispositionTotals: {
                        accepted: 1,
                        "rejected-quality": 0,
                    },
                    emittedScriptCount: 2,
                    importedWorkCount: 1,
                    year: 2024,
                },
            ],
        },
    };
    const removed = new Map([[NAME, PROVENANCE_BLOCK]]);
    const remaining = `            SourceSha256         = '${SOURCE_HASH}'`;
    const result = updateCheckpoint(checkpoint, removed, remaining);

    assert.equal(result.sixteenColors.totals.emittedScriptCount, 1);
    assert.equal(result.sixteenColors.years[0].emittedScriptCount, 1);
    assert.equal(result.sixteenColors.totals.importedWorkCount, 1);
    assert.equal(checkpoint.sixteenColors.totals.emittedScriptCount, 2);
});

test("updateCheckpoint rejects the final source as rejected-quality", () => {
    const checkpoint = {
        sixteenColors: {
            acceptedSources: [
                { archiveYear: 2024, sourceSha256: SOURCE_HASH },
            ],
            totals: {
                acceptedSourceCount: 1,
                dispositionTotals: {
                    accepted: 1,
                    "rejected-quality": 4,
                },
                emittedScriptCount: 1,
                importedWorkCount: 1,
            },
            years: [
                {
                    dispositionTotals: {
                        accepted: 1,
                        "rejected-quality": 2,
                    },
                    emittedScriptCount: 1,
                    importedWorkCount: 1,
                    year: 2024,
                },
            ],
        },
    };

    const result = updateCheckpoint(
        checkpoint,
        new Map([[NAME, PROVENANCE_BLOCK]]),
        ""
    );

    assert.equal(result.sixteenColors.acceptedSources.length, 0);
    assert.equal(result.sixteenColors.totals.importedWorkCount, 0);
    assert.equal(result.sixteenColors.totals.acceptedSourceCount, 0);
    assert.equal(result.sixteenColors.totals.dispositionTotals.accepted, 0);
    assert.equal(
        result.sixteenColors.totals.dispositionTotals["rejected-quality"],
        5
    );
    assert.equal(result.sixteenColors.years[0].importedWorkCount, 0);
});
