"use strict";

const assert = require("node:assert/strict");
const fs = require("node:fs");
const os = require("node:os");
const path = require("node:path");
const test = require("node:test");

const {
    alignCurrentRowsToBaseline,
    applyBoundaryControls,
    buildManifest,
    chooseFixedPartBreaks,
    getPayloadRows,
    getRowsSha256,
    getSgrReplayBeforeRows,
    mapBaselineSourceCoordinates,
    parseArguments,
    parseSourceRows,
    planRebalance,
    validateManifest,
    writePlan,
} = require("../scripts/Rebalance-ColorScriptParts.js");
const {
    extractPowerShellPayload,
} = require("../scripts/Audit-ColorScriptContent.js");

const ESC = "\u001b";

/**
 * @param {string[]} rows
 * @param {{ fidelityLock?: boolean; range: string }} options
 *
 * @returns {string}
 */
function createScript(rows, options) {
    const lock = options.fidelityLock
        ? "# Source Conversion Mode: Passthrough\n"
        : "";
    const payload = rows.join("\n").replaceAll("'", "''");
    return `${lock}# Lines: ${options.range}\n# Columns: 1-80\n\nWrite-Host '${payload}'\n`;
}

/**
 * @param {import("node:test").TestContext} context
 *
 * @returns {{
 *     baselineFiles: Map<string, Buffer>;
 *     repositoryRoot: string;
 *     scriptsDirectory: string;
 * }}
 */
function createRepository(context) {
    const repositoryRoot = fs.mkdtempSync(
        path.join(os.tmpdir(), "colorscript-rebalance-")
    );
    const scriptsDirectory = path.join(
        repositoryRoot,
        "ColorScripts-Enhanced",
        "Scripts"
    );
    fs.mkdirSync(scriptsDirectory, { recursive: true });
    context.after(() => {
        const resolved = path.resolve(repositoryRoot);
        assert.ok(resolved.startsWith(path.resolve(os.tmpdir()) + path.sep));
        fs.rmSync(resolved, { recursive: true, force: true });
    });
    return {
        baselineFiles: new Map(),
        repositoryRoot,
        scriptsDirectory,
    };
}

/**
 * @param {ReturnType<typeof createRepository>} repository
 * @param {string} fileName
 * @param {string} baselineSource
 * @param {string} [currentSource]
 *
 * @returns {void}
 */
function addPart(
    repository,
    fileName,
    baselineSource,
    currentSource = baselineSource
) {
    const relativePath = `ColorScripts-Enhanced/Scripts/${fileName}`;
    repository.baselineFiles.set(
        relativePath,
        Buffer.from(baselineSource, "utf8")
    );
    fs.writeFileSync(
        path.join(repository.scriptsDirectory, fileName),
        currentSource,
        "utf8"
    );
}

/**
 * @param {ReturnType<typeof createRepository>} repository
 *
 * @returns {(unusedCommit: string, relativePath: string) => Buffer}
 */
function createBaselineReader(repository) {
    return (unusedCommit, relativePath) => {
        const value = repository.baselineFiles.get(relativePath);
        if (!value) {
            throw new Error(`Missing fixture baseline: ${relativePath}`);
        }
        return value;
    };
}

/**
 * @param {string} script
 * @param {string} [action]
 *
 * @returns {{
 *     disposition: string;
 *     passthrough: boolean;
 *     recommendedAction: string;
 *     script: string;
 *     type: string;
 * }}
 */
function createFinding(
    script,
    action = "re-split-family-at-source-row-boundaries"
) {
    return {
        disposition: "high-confidence-change",
        passthrough: false,
        recommendedAction: action,
        script,
        type: "extreme-leading-blank-run",
    };
}

/**
 * @param {ReturnType<typeof createRepository>} repository
 * @param {ReturnType<typeof createFinding>[]} findings
 *
 * @returns {ReturnType<typeof buildManifest>}
 */
function buildFixtureManifest(repository, findings) {
    return buildManifest({
        baselineCommit: "0cac422b",
        classification: { findings },
        readBaselineFile: createBaselineReader(repository),
        repositoryRoot: repository.repositoryRoot,
        scriptsDirectory: repository.scriptsDirectory,
    });
}

test("fixed-count balancing conserves every row and permits a reviewed 51-row ceiling", () => {
    const rows = Array.from(
        { length: 101 },
        (unusedValue, index) => `row-${index + 1}`
    );
    const breaks = chooseFixedPartBreaks(rows, 2, 51);

    assert.equal(breaks.length, 2);
    assert.equal(breaks.at(-1), rows.length);
    assert.deepEqual(
        [breaks[0], breaks[1] - breaks[0]].sort((left, right) => left - right),
        [50, 51]
    );
    assert.throws(() => chooseFixedPartBreaks(rows, 2, 50), /enough capacity/u);
});

test("baseline alignment selects a unique contiguous curated window and rejects ambiguity", () => {
    assert.deepEqual(
        alignCurrentRowsToBaseline(
            [
                "",
                "",
                "A",
                "B",
            ],
            [
                "",
                "A",
                "B",
            ]
        ),
        {
            baselineEnd: 4,
            baselineStart: 1,
            exactRows: 3,
            normalizedRows: 0,
            renderedBlankRows: 0,
        }
    );
    assert.throws(
        () =>
            alignCurrentRowsToBaseline(
                [
                    "",
                    "",
                    "",
                ],
                ["", ""]
            ),
        /ambiguous/u
    );
});

test("source-coordinate mapping excludes a single generated presentation row", () => {
    assert.deepEqual(
        mapBaselineSourceCoordinates(
            [
                "",
                "A",
                "B",
            ],
            {
                end: 2,
                start: 1,
            }
        ),
        [
            null,
            1,
            2,
        ]
    );
    assert.deepEqual(
        mapBaselineSourceCoordinates(["", "A"], {
            end: 2,
            start: 1,
        }),
        [1, 2]
    );
    assert.throws(
        () =>
            mapBaselineSourceCoordinates(
                [
                    "A",
                    "B",
                    "C",
                ],
                { end: 2, start: 1 }
            ),
        /presentation row/u
    );
});

test("boundary controls restore active SGR state and reset original input boundaries", () => {
    const rawRows = [
        `${ESC}[31mRED`,
        "CONT",
        "DEFAULT",
    ];
    const replay = getSgrReplayBeforeRows(rawRows);
    const result = applyBoundaryControls(rawRows.slice(1), replay[1], [1]);

    assert.equal(replay[1], `${ESC}[31m`);
    assert.equal(result.rows[0], `${ESC}[0m${ESC}[31mCONT`);
    assert.equal(result.rows[1], `${ESC}[0mDEFAULT${ESC}[0m`);
    assert.deepEqual(result.internalResetIndexes, [1]);
    assert.throws(
        () => applyBoundaryControls(["A", "B"], "", [0]),
        /Internal reset indexes/u
    );
});

test("balancing rejects blank outputs and avoids a severe leading run when a visible-start cut is feasible", () => {
    assert.throws(
        () =>
            chooseFixedPartBreaks(
                [
                    "A",
                    "",
                    "",
                    "",
                    "B",
                ],
                3,
                5
            ),
        /rendered-visible row per part/u
    );

    const rows = [
        "A",
        ...Array.from({ length: 15 }, () => ""),
        "B",
        "C",
        "D",
    ];
    assert.deepEqual(chooseFixedPartBreaks(rows, 2, 18), [17, 19]);
});

test("balancing does not create a tiny part solely to cut after a short blank run", () => {
    const rows = [
        "A",
        "B",
        "C",
        "",
        "",
        ...Array.from({ length: 181 }, (unusedValue, index) => `row-${index}`),
    ];
    const breaks = chooseFixedPartBreaks(rows, 5, 50);
    const starts = [0, ...breaks.slice(0, -1)];
    const visibleRows = breaks.map(
        (end, index) =>
            rows.slice(starts[index], end).filter((row) => row.length > 0)
                .length
    );

    assert.equal(breaks.at(-1), rows.length);
    assert.ok(breaks[0] > 20);
    assert.ok(Math.min(...visibleRows) > 20);
});

test("manifest excludes generated presentation rows, trims only outer blanks, and restores leading style", (context) => {
    const repository = createRepository(context);
    addPart(
        repository,
        "margins-part01.ps1",
        createScript(
            [
                "",
                `${ESC}[31m`,
                "A",
                "B",
            ],
            { range: "1-3" }
        )
    );
    addPart(
        repository,
        "margins-part02.ps1",
        createScript(
            [
                "",
                "C",
                "D",
                `${ESC}[0m`,
            ],
            { range: "4-6" }
        )
    );

    const manifest = buildFixtureManifest(repository, [
        createFinding("margins-part01"),
    ]);
    const family = manifest.families[0];
    assert.deepEqual(manifest.summary, {
        excludedPresentationRows: 2,
        families: 1,
        inputs: 2,
        outputs: 2,
        retainedRows: 4,
        reviewFindings: 1,
        trimmedLeadingRows: 1,
        trimmedTrailingRows: 1,
    });
    assert.deepEqual(
        family.inputs.map((input) => input.excludedPresentationRows),
        [1, 1]
    );
    assert.deepEqual(family.outerTrim, {
        expectedLeadingRowsSha256: getRowsSha256([`${ESC}[31m`]),
        expectedTrailingRowsSha256: getRowsSha256([`${ESC}[0m`]),
        leadingRows: 1,
        trailingRows: 1,
    });
    assert.deepEqual(
        family.outputs.map((output) => output.visibleRowCount),
        [2, 2]
    );
    assert.deepEqual(
        family.outputs.map((output) => output.sourceRows),
        [
            { end: 3, start: 1 },
            { end: 6, start: 4 },
        ]
    );

    const options = {
        readBaselineFile: createBaselineReader(repository),
        repositoryRoot: repository.repositoryRoot,
        scriptsDirectory: repository.scriptsDirectory,
    };
    const firstPlan = planRebalance(manifest, options);
    const secondPlan = planRebalance(manifest, options);
    assert.deepEqual(firstPlan, secondPlan);
    const payloads = firstPlan.families[0].files.map((file) =>
        getPayloadRows(extractPowerShellPayload(file.source).value)
    );
    assert.deepEqual(
        payloads.map((rows) => rows[0]),
        ["", ""]
    );
    assert.equal(payloads[0][1], `${ESC}[0m${ESC}[31mA`);
    assert.equal(payloads[1][1], `${ESC}[0mC`);
});

test("manifest generation and dry-run planning conserve rows, state, files, and source spans", (context) => {
    const repository = createRepository(context);
    const firstBaseline = createScript(
        [
            `${ESC}[31mA`,
            "B",
            "C",
        ],
        {
            range: "1-3",
        }
    );
    const secondBaseline = createScript(["D"], {
        range: "4-4",
    });
    addPart(repository, "demo-part01.ps1", firstBaseline);
    addPart(repository, "demo-part02.ps1", secondBaseline);

    const manifest = buildFixtureManifest(repository, [
        createFinding("demo-part01"),
    ]);
    const plan = planRebalance(manifest, {
        readBaselineFile: createBaselineReader(repository),
        repositoryRoot: repository.repositoryRoot,
        scriptsDirectory: repository.scriptsDirectory,
    });

    assert.deepEqual(manifest.summary, {
        excludedPresentationRows: 0,
        families: 1,
        inputs: 2,
        outputs: 2,
        retainedRows: 4,
        reviewFindings: 1,
        trimmedLeadingRows: 0,
        trimmedTrailingRows: 0,
    });
    assert.equal(manifest.families[0].fixedPartCount, 2);
    assert.deepEqual(
        manifest.families[0].outputs.map((output) => output.rowCount),
        [2, 2]
    );
    assert.deepEqual(
        manifest.families[0].outputs.map((output) => output.sourceRows),
        [
            { end: 2, start: 1 },
            { end: 4, start: 3 },
        ]
    );
    assert.equal(plan.changedFiles, 2);
    assert.equal(plan.retainedRows, 4);
    assert.equal(plan.families[0].files.length, 2);

    const outputRows = plan.families[0].files.map((file) =>
        getPayloadRows(extractPowerShellPayload(file.source).value)
    );
    assert.deepEqual(
        outputRows.map((rows) => rows[0]),
        ["", ""]
    );
    assert.equal(outputRows[1][1], `${ESC}[0m${ESC}[31mC`);
    assert.equal(outputRows[1][2], `${ESC}[0mD${ESC}[0m`);
    assert.match(plan.families[0].files[0].source, /^# Lines: 1-2$/mu);
    assert.match(plan.families[0].files[1].source, /^# Lines: 3-4$/mu);

    const reconstructed = [];
    for (const file of plan.families[0].files) {
        const rows = getPayloadRows(
            extractPowerShellPayload(file.source).value
        );
        assert.equal(rows.shift(), "");
        rows[0] = rows[0].slice(file.prefix.length);
        const lastRow = rows.at(-1);
        if (lastRow === undefined) {
            throw new Error("Planned output unexpectedly contained no rows.");
        }
        rows[rows.length - 1] = lastRow.slice(0, -file.suffix.length);
        for (const index of file.internalResetIndexes) {
            rows[index] = rows[index].slice(`${ESC}[0m`.length);
        }
        reconstructed.push(...rows);
    }
    assert.equal(
        getRowsSha256(reconstructed),
        manifest.families[0].expectedFamilyRowsSha256
    );
    assert.deepEqual(reconstructed, [
        `${ESC}[31mA`,
        "B",
        "C",
        "D",
    ]);

    writePlan(plan, repository.scriptsDirectory);
    assert.equal(
        fs
            .readdirSync(repository.scriptsDirectory)
            .filter((name) => /^demo-part\d+\.ps1$/u.test(name)).length,
        2
    );
    assert.match(
        fs.readFileSync(
            path.join(repository.scriptsDirectory, "demo-part02.ps1"),
            "utf8"
        ),
        /^# Lines: 3-4$/mu
    );
    assert.throws(
        () =>
            planRebalance(manifest, {
                readBaselineFile: createBaselineReader(repository),
                repositoryRoot: repository.repositoryRoot,
                scriptsDirectory: repository.scriptsDirectory,
            }),
        /current file hash has drifted/u
    );
});

test("manifest generation derives current coordinates from a cropped baseline subsequence", (context) => {
    const repository = createRepository(context);
    addPart(
        repository,
        "crop-part01.ps1",
        createScript(
            [
                "",
                "",
                "A",
                "B",
            ],
            {
                range: "1-4",
            }
        ),
        createScript(
            [
                "",
                "A",
                "B",
            ],
            {
                range: "1-4",
            }
        )
    );
    addPart(
        repository,
        "crop-part02.ps1",
        createScript(["C", "D"], {
            range: "5-6",
        })
    );

    const manifest = buildFixtureManifest(repository, [
        createFinding("crop-part01"),
    ]);
    const family = manifest.families[0];

    assert.equal(family.inputs[0].alignment.baselineStart, 1);
    assert.deepEqual(
        family.outputs.map((output) => output.sourceRows),
        [
            { end: 4, start: 1 },
            { end: 6, start: 5 },
        ]
    );
});

test("planning fails closed on current file, baseline, and source-fidelity drift", (context) => {
    const repository = createRepository(context);
    const first = createScript(["A", "B"], {
        range: "1-2",
    });
    const second = createScript(["C", "D"], {
        range: "3-4",
    });
    addPart(repository, "drift-part01.ps1", first);
    addPart(repository, "drift-part02.ps1", second);
    const manifest = buildFixtureManifest(repository, [
        createFinding("drift-part01"),
    ]);
    const options = {
        readBaselineFile: createBaselineReader(repository),
        repositoryRoot: repository.repositoryRoot,
        scriptsDirectory: repository.scriptsDirectory,
    };

    fs.appendFileSync(
        path.join(repository.scriptsDirectory, "drift-part01.ps1"),
        "# drift\n"
    );
    assert.throws(
        () => planRebalance(manifest, options),
        /current file hash has drifted/u
    );
    fs.writeFileSync(
        path.join(repository.scriptsDirectory, "drift-part01.ps1"),
        first
    );

    /**
     * @param {string} unusedCommit
     * @param {string} relativePath
     *
     * @returns {Buffer}
     */
    const changedBaselineReader = (unusedCommit, relativePath) => {
        const buffer = createBaselineReader(repository)(
            unusedCommit,
            relativePath
        );
        return relativePath.endsWith("part01.ps1")
            ? Buffer.concat([buffer, Buffer.from("# drift\n")])
            : buffer;
    };
    assert.throws(
        () =>
            planRebalance(manifest, {
                ...options,
                readBaselineFile: changedBaselineReader,
            }),
        /baseline file hash has drifted/u
    );

    const locked = createScript(["A", "B"], {
        fidelityLock: true,
        range: "1-2",
    });
    fs.writeFileSync(
        path.join(repository.scriptsDirectory, "drift-part01.ps1"),
        locked
    );
    assert.throws(
        () => planRebalance(manifest, options),
        /source-fidelity-locked/u
    );
});

test("manifest generation rejects source-fidelity findings and locked baselines", (context) => {
    const repository = createRepository(context);
    addPart(
        repository,
        "locked-part01.ps1",
        createScript(["A"], {
            fidelityLock: true,
            range: "1-1",
        }),
        createScript(["A"], {
            range: "1-1",
        })
    );
    addPart(
        repository,
        "locked-part02.ps1",
        createScript(["B"], {
            range: "2-2",
        })
    );

    assert.throws(
        () =>
            buildFixtureManifest(repository, [createFinding("locked-part01")]),
        /baseline source-fidelity lock/u
    );
    assert.throws(
        () =>
            buildFixtureManifest(repository, [
                {
                    ...createFinding("locked-part01"),
                    passthrough: true,
                },
            ]),
        /non-passthrough/u
    );
});

test("manifest validation fails closed on missing invariants and structural inconsistencies", (context) => {
    const repository = createRepository(context);
    addPart(
        repository,
        "invalid-part01.ps1",
        createScript(["A", "B"], {
            range: "1-2",
        })
    );
    addPart(
        repository,
        "invalid-part02.ps1",
        createScript(["C", "D"], {
            range: "3-4",
        })
    );
    const manifest = buildFixtureManifest(repository, [
        createFinding("invalid-part01"),
    ]);

    const missingInvariants = structuredClone(manifest);
    Reflect.deleteProperty(missingInvariants, "invariants");
    assert.throws(
        () => validateManifest(missingInvariants),
        /schemaVersion 2/u
    );

    const duplicate = structuredClone(manifest);
    duplicate.families[0].inputs[1].file = duplicate.families[0].inputs[0].file;
    assert.throws(() => validateManifest(duplicate), /complete, contiguous/u);

    const coordinateGap = structuredClone(manifest);
    coordinateGap.families[0].outputs[1].sourceRows.start += 1;
    assert.throws(
        () => validateManifest(coordinateGap),
        /output record is malformed/u
    );

    const overlappingRows = structuredClone(manifest);
    overlappingRows.families[0].outputs[1].startRow -= 1;
    overlappingRows.families[0].outputs[1].rowCount += 1;
    assert.throws(
        () => validateManifest(overlappingRows),
        /output record is malformed/u
    );

    const malformedFinding = structuredClone(manifest);
    malformedFinding.families[0].reviewFindings[0].action =
        "crop-leading-blank-rows";
    assert.throws(
        () => validateManifest(malformedFinding),
        /review finding is malformed/u
    );

    const inconsistentSummary = structuredClone(manifest);
    inconsistentSummary.summary.outputs += 1;
    assert.throws(
        () => validateManifest(inconsistentSummary),
        /summary is inconsistent/u
    );

    const missingVisibleRows = structuredClone(manifest);
    missingVisibleRows.families[0].outputs[0].visibleRowCount = 0;
    assert.throws(
        () => validateManifest(missingVisibleRows),
        /output record is malformed/u
    );

    const alteredOuterTrim = structuredClone(manifest);
    alteredOuterTrim.families[0].outerTrim.leadingRows += 1;
    assert.throws(
        () => validateManifest(alteredOuterTrim),
        /family record is malformed/u
    );
});

test("planning rejects a syntactically valid manifest whose reviewed row hash was altered", (context) => {
    const repository = createRepository(context);
    addPart(
        repository,
        "hash-part01.ps1",
        createScript(["A", "B"], {
            range: "1-2",
        })
    );
    addPart(
        repository,
        "hash-part02.ps1",
        createScript(["C", "D"], {
            range: "3-4",
        })
    );
    const manifest = buildFixtureManifest(repository, [
        createFinding("hash-part01"),
    ]);
    manifest.families[0].outputs[0].expectedRawRowsSha256 = "a".repeat(64);

    assert.throws(
        () =>
            planRebalance(manifest, {
                readBaselineFile: createBaselineReader(repository),
                repositoryRoot: repository.repositoryRoot,
                scriptsDirectory: repository.scriptsDirectory,
            }),
        /reviewed output rows/u
    );
});

test("argument and source-row parsing fail closed on ambiguous modes and metadata", () => {
    assert.deepEqual(parseSourceRows("# Lines: 4-9\n"), {
        end: 9,
        start: 4,
    });
    assert.throws(
        () => parseSourceRows("# Lines: 1-2\n# Lines: 3-4\n"),
        /exactly one/u
    );
    assert.throws(
        () =>
            parseArguments([
                "--classification=review.json",
                "--manifest=manifest.json",
                "--output=out.json",
            ]),
        /generation requires/u
    );
    assert.throws(
        () =>
            parseArguments([
                "--classification=review.json",
                "--output=out.json",
                "--write",
            ]),
        /--write requires/u
    );
});
