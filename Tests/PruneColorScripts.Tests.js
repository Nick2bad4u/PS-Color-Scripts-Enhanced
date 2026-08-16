"use strict";

const assert = require("node:assert/strict");
const test = require("node:test");

const {
    assertSafeScriptName,
    getFullyRemovedAnalysisScopes,
    getQuotedProperty,
    parseArguments,
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

function createRemainingProvenance(sourceHash) {
    return `@{
    SchemaVersion = 3
    Collections = @{
        'example' = @{
            License = 'ISC'
        }
    }
    Scripts = @{
        'remaining-example' = @{
            Collection = 'example'
            SourceSha256 = '${sourceHash}'
        }
    }
}
`;
}

test("assertSafeScriptName rejects paths and unsafe names", () => {
    assert.doesNotThrow(() => assertSafeScriptName(NAME));
    assert.throws(() => assertSafeScriptName("../escape"));
    assert.throws(() => assertSafeScriptName("Name With Spaces"));
});

test("parseArguments accepts an explicit checkpoint disposition", () => {
    const options = parseArguments([
        "--names-file=temp/removals.json",
        "--checkpoint-disposition=rejected-duplicate-render",
        "--write",
    ]);

    assert.equal(options.checkpointDisposition, "rejected-duplicate-render");
    assert.equal(options.write, true);
    assert.match(options.namesPath, /temp[\\/]removals\.json$/u);
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

test("analysis scopes include a split family only when every sibling is removed", () => {
    const available = [
        "16c-example-part01",
        "16c-example-part02",
        "16c-other-part01",
    ];

    assert.deepEqual(
        getFullyRemovedAnalysisScopes(
            ["16c-example-part01", "16c-example-part02"],
            available
        ).sort((left, right) => left.localeCompare(right, "en-US")),
        [
            "16c-example",
            "16c-example-part01",
            "16c-example-part02",
        ]
    );
    assert.deepEqual(
        getFullyRemovedAnalysisScopes(["16c-example-part01"], available),
        ["16c-example-part01"]
    );
});

test("updateCheckpoint decrements emitted counts but retains the source", () => {
    const checkpoint = {
        sixteenColors: {
            acceptedSources: [{ archiveYear: 2024, sourceSha256: SOURCE_HASH }],
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
    const remaining = createRemainingProvenance(SOURCE_HASH);
    const result = updateCheckpoint(checkpoint, removed, remaining);

    assert.equal(result.sixteenColors.totals.emittedScriptCount, 1);
    assert.equal(result.sixteenColors.years[0].emittedScriptCount, 1);
    assert.equal(result.sixteenColors.totals.importedWorkCount, 1);
    assert.equal(checkpoint.sixteenColors.totals.emittedScriptCount, 2);
});

test("updateCheckpoint rejects the final source as rejected-quality", () => {
    const checkpoint = {
        sixteenColors: {
            acceptedSources: [{ archiveYear: 2024, sourceSha256: SOURCE_HASH }],
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
        createRemainingProvenance("b".repeat(64))
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

test("updateCheckpoint records a selected duplicate-render disposition", () => {
    const checkpoint = {
        sixteenColors: {
            acceptedSources: [{ archiveYear: 2024, sourceSha256: SOURCE_HASH }],
            totals: {
                acceptedSourceCount: 1,
                dispositionTotals: {
                    accepted: 1,
                    "rejected-duplicate-render": 0,
                },
                emittedScriptCount: 1,
                importedWorkCount: 1,
            },
            years: [
                {
                    dispositionTotals: {
                        accepted: 1,
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
        createRemainingProvenance("b".repeat(64)),
        "rejected-duplicate-render"
    );

    assert.equal(
        result.sixteenColors.totals.dispositionTotals[
            "rejected-duplicate-render"
        ],
        1
    );
    assert.equal(
        result.sixteenColors.years[0].dispositionTotals[
            "rejected-duplicate-render"
        ],
        1
    );
});

test("updateCheckpoint rejects unsupported dispositions", () => {
    const checkpoint = {
        sixteenColors: {
            acceptedSources: [],
            totals: {
                dispositionTotals: {
                    accepted: 0,
                },
            },
            years: [],
        },
    };

    assert.throws(
        () => updateCheckpoint(checkpoint, new Map(), "", "rejected-unknown"),
        /unsupported/u
    );
});
