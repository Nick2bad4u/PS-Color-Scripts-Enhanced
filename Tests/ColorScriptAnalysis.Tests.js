"use strict";

const assert = require("node:assert/strict");
const fs = require("node:fs");
const os = require("node:os");
const path = require("node:path");
const { afterEach, test } = require("node:test");

const analyzer = import("../scripts/Analyze-ColorScripts.mjs");
const temporaryDirectories = [];

afterEach(() => {
    for (const directory of temporaryDirectories.splice(0)) {
        fs.rmSync(directory, { recursive: true, force: true });
    }
});

function createTemporaryDirectory() {
    const directory = fs.mkdtempSync(
        path.join(os.tmpdir(), "colorscript-analysis-")
    );
    temporaryDirectories.push(directory);
    return directory;
}

function writeScript(directory, name, rowRange, content) {
    const filePath = path.join(directory, `${name}.ps1`);
    fs.writeFileSync(
        filePath,
        [
            "# Converted from: fixture.ans",
            "# Source encoding: CP437",
            `# Lines: ${rowRange}`,
            "# Columns: 1-80",
            "",
            `Write-Host '\n${content.replaceAll("'", "''")}'`,
        ].join("\n")
    );
    return filePath;
}

test("balanced ranges avoid tiny tails while respecting the maximum", async () => {
    const { buildBalancedRanges } = await analyzer;

    assert.deepEqual(buildBalancedRanges(1, 56, 50), ["1-28", "29-56"]);
    assert.deepEqual(buildBalancedRanges(1, 107, 50), [
        "1-36",
        "37-72",
        "73-107",
    ]);
    assert.deepEqual(buildBalancedRanges(1, 184, 50), [
        "1-46",
        "47-92",
        "93-138",
        "139-184",
    ]);
    assert.throws(() => buildBalancedRanges(0, 50, 50), /positive integers/);
    assert.throws(() => buildBalancedRanges(10, 9, 50), /no earlier/);
});

test("split analysis reports tiny tails and avoidable extra parts", async () => {
    const { analyzeScript, analyzeSplitFamilies } = await analyzer;
    const directory = createTemporaryDirectory();
    const records = [
        analyzeScript(
            writeScript(
                directory,
                "fixture-part01",
                "1-50",
                "\u001b[31mA\u001b[0m"
            )
        ),
        analyzeScript(
            writeScript(
                directory,
                "fixture-part02",
                "51-56",
                "\u001b[32mB\u001b[0m"
            )
        ),
    ];

    const issues = analyzeSplitFamilies(records, {
        blankRun: 3,
        maxRows: 50,
        tinyTailRows: 10,
    });

    assert.equal(issues.length, 1);
    assert.equal(issues[0].type, "tiny-tail-part");
    assert.deepEqual(issues[0].suggestedRanges, ["1-28", "29-56"]);
});

test("split analysis does not infer missing rows from SAUCE height padding", async () => {
    const { analyzeScript, analyzeSplitFamilies } = await analyzer;
    const directory = createTemporaryDirectory();
    const records = [
        ["fixture-part01", "1-20"],
        ["fixture-part02", "21-40"],
    ].map(([name, range]) => {
        const filePath = writeScript(
            directory,
            name,
            range,
            Array.from({ length: 20 }, () => "X").join("\n")
        );
        const source = fs
            .readFileSync(filePath, "utf8")
            .replace(
                "# Source encoding: CP437",
                "# Source encoding: CP437\n# SAUCE Dimensions: 80x45"
            );
        fs.writeFileSync(filePath, source);
        return analyzeScript(filePath);
    });

    const issues = analyzeSplitFamilies(records, {
        blankRun: 3,
        maxRows: 50,
        tinyTailRows: 10,
    });
    const mergeable = issues.find(
        (issue) => issue.type === "mergeable-adjacent-parts"
    );

    assert.deepEqual(
        issues.map((issue) => issue.type).sort(),
        ["avoidable-extra-part", "mergeable-adjacent-parts"]
    );
    assert.equal(mergeable.pairs[0].combinedRows, 40);
    assert.equal(mergeable.pairs[0].suggestedRange, "1-40");
});

test("tiny-tail analysis includes proportional eleven-row credit tails", async () => {
    const { analyzeScript, analyzeSplitFamilies } = await analyzer;
    const directory = createTemporaryDirectory();
    const ranges = [
        "1-50",
        "51-100",
        "101-150",
        "151-200",
        "201-250",
        "251-261",
    ];
    const records = ranges.map((range, index) =>
        analyzeScript(
            writeScript(
                directory,
                `fixture-part${String(index + 1).padStart(2, "0")}`,
                range,
                index === ranges.length - 1
                    ? "credits"
                    : Array.from({ length: 50 }, () => "X".repeat(60)).join(
                          "\n"
                      )
            )
        )
    );

    const issues = analyzeSplitFamilies(records, {
        blankRun: 3,
        maxRows: 50,
        tinyTailRows: 10,
    });
    const tinyTail = issues.find((issue) => issue.type === "tiny-tail-part");

    assert.equal(tinyTail.tailRows, 11);
    assert.deepEqual(tinyTail.signals, ["row-count", "visible-cell-ratio"]);
});

test("visible-row analysis preserves background-colored spaces", async () => {
    const { analyzeAnsiLines } = await analyzer;
    const metrics = analyzeAnsiLines([
        "",
        "\u001b[44m   \u001b[0m",
        "\u001b[7m  \u001b[0m",
        "",
        "",
        "",
    ]);

    assert.equal(metrics.visibleRows, 2);
    assert.equal(metrics.leadingBlankRows, 1);
    assert.equal(metrics.trailingBlankRows, 3);
    assert.equal(metrics.visibleCells, 5);
});

test("cell analysis reports broad color families and decoding damage", async () => {
    const { analyzeAnsiLines } = await analyzer;
    const metrics = analyzeAnsiLines([
        [
            "\u001b[31mRR\u001b[0m",
            "\u001b[92mGG\u001b[0m",
            "\u001b[34mBB\u001b[0m",
        ].join(""),
        "damaged: \ufffd Ã© â€™ ðŸ ï»¿",
    ]);

    assert.deepEqual(metrics.colorFamilies, [
        "blue",
        "green",
        "neutral",
        "red",
    ]);
    assert.equal(metrics.uniqueColorFamilies, 4);
    assert.ok(metrics.coloredCellRatio > 0);
    assert.equal(metrics.firstRowVisibleCells, 6);
    assert.ok(metrics.lastRowVisibleCells > 6);
    assert.equal(metrics.replacementCharacters, 1);
    assert.equal(metrics.mojibakeSequences, 4);
});

test("embedded DOS EOF controls are reported independently of decoding damage", async () => {
    const { analyzeReviewSignals, analyzeScript } = await analyzer;
    const directory = createTemporaryDirectory();
    const record = analyzeScript(
        writeScript(
            directory,
            "fixture",
            "1-1",
            "\u001b[31mvisible\u001aoutput\u001b[0m"
        )
    );

    const issues = analyzeReviewSignals([record], {
        blankRun: 3,
        maxRows: 50,
        tinyTailRows: 10,
    });
    const eofIssue = issues.find(
        (issue) => issue.type === "embedded-dos-eof"
    );

    assert.equal(record.metrics.dosEofCharacters, 1);
    assert.deepEqual(eofIssue, {
        type: "embedded-dos-eof",
        family: "fixture",
        script: "fixture",
        characters: 1,
    });
    assert.ok(
        !issues.some(
            (issue) => issue.type === "suspicious-character-decoding"
        )
    );
});

test("script analysis removes only the generated presentation newline", async () => {
    const { analyzeScript } = await analyzer;
    const directory = createTemporaryDirectory();
    const filePath = writeScript(
        directory,
        "fixture",
        "11-13",
        [
            "",
            "\u001b[31mA\u001b[0m",
            "",
        ].join("\n")
    );

    const record = analyzeScript(filePath);

    assert.deepEqual(record.lines, [
        "",
        "\u001b[31mA\u001b[0m",
        "",
    ]);
    assert.equal(record.metrics.rows, 3);
    assert.equal(record.metrics.leadingBlankRows, 1);
    assert.equal(record.metrics.trailingBlankRows, 1);
});

test("script analysis accepts safe single-quoted here-strings", async () => {
    const { analyzeScript } = await analyzer;
    const directory = createTemporaryDirectory();
    const filePath = path.join(directory, "fixture.ps1");
    fs.writeFileSync(
        filePath,
        [
            "# Converted from: fixture.ans",
            "",
            "Write-Host @'",
            "\u001b[31m$literal ` value\u001b[0m",
            "'@",
        ].join("\n")
    );

    const record = analyzeScript(filePath);

    assert.equal(record.analysisError, null);
    assert.deepEqual(record.lines, ["\u001b[31m$literal ` value\u001b[0m"]);
});

test("review signals distinguish sparse output and low variety", async () => {
    const { analyzeReviewSignals, analyzeScript } = await analyzer;
    const directory = createTemporaryDirectory();
    const repeated = Array.from(
        { length: 20 },
        () => "\u001b[31m████\u001b[0m"
    ).join("\n");
    const filePath = writeScript(directory, "fixture-part01", "1-20", repeated);
    const source = fs
        .readFileSync(filePath, "utf8")
        .replace(
            "# Source encoding: CP437",
            "# Source encoding: CP437\n# SAUCE Comments: Ripped from the original image"
        );
    fs.writeFileSync(filePath, source);
    const record = analyzeScript(filePath);
    assert.ok(record.metrics);

    const issues = analyzeReviewSignals([record], {
        blankRun: 3,
        maxRows: 50,
        tinyTailRows: 10,
    });
    const types = issues.map((issue) => issue.type);

    assert.ok(types.includes("low-cell-variety"));
    assert.ok(!types.includes("derivative-attribution-review"));
    assert.ok(issues.every((issue) => issue.family === "fixture-part01"));
});

test("review signals distinguish plain ASCII from CP437 block art", async () => {
    const { analyzeReviewSignals, analyzeScript } = await analyzer;
    const directory = createTemporaryDirectory();
    const plainAscii = analyzeScript(
        writeScript(
            directory,
            "plain-part01",
            "1-10",
            Array.from({ length: 10 }, () => "ASCII TEXT").join("\n")
        )
    );
    const cp437Art = analyzeScript(
        writeScript(
            directory,
            "cp437-part01",
            "1-10",
            Array.from(
                { length: 10 },
                () => "\u001b[31m██████████\u001b[0m"
            ).join("\n")
        )
    );

    const options = {
        blankRun: 3,
        maxRows: 50,
        tinyTailRows: 10,
    };
    const plainIssues = analyzeReviewSignals([plainAscii], options);
    const cp437Issues = analyzeReviewSignals([cp437Art], options);

    assert.ok(
        plainIssues.some((issue) => issue.type === "mostly-plain-ascii")
    );
    assert.ok(
        !cp437Issues.some((issue) => issue.type === "mostly-plain-ascii")
    );
    assert.equal(plainAscii.metrics.extendedGlyphRatio, 0);
    assert.equal(cp437Art.metrics.extendedGlyphRatio, 1);
});

test("sparse cell density is a review signal rather than decoding damage", async () => {
    const { analyzeReviewSignals, analyzeScript } = await analyzer;
    const directory = createTemporaryDirectory();
    const record = analyzeScript(
        writeScript(
            directory,
            "fixture-part01",
            "1-20",
            Array.from(
                { length: 20 },
                (_, index) =>
                    `${" ".repeat(39)}\u001b[${31 + (index % 3)}m█\u001b[0m`
            ).join("\n")
        )
    );

    const issues = analyzeReviewSignals([record], {
        blankRun: 3,
        maxRows: 50,
        tinyTailRows: 10,
    });
    const types = issues.map((issue) => issue.type);

    assert.ok(types.includes("sparse-cell-density"));
    assert.ok(!types.includes("suspicious-character-decoding"));
    assert.equal(record.metrics.replacementCharacters, 0);
    assert.equal(record.metrics.mojibakeSequences, 0);
});

test("family review signals aggregate derivatives and simple split artwork", async () => {
    const { analyzeFamilyReviewSignals, analyzeScript } = await analyzer;
    const directory = createTemporaryDirectory();
    const records = [1, 2].map((part) => {
        const start = part === 1 ? 1 : 21;
        const end = start + 19;
        const filePath = writeScript(
            directory,
            `fixture-part0${part}`,
            `${start}-${end}`,
            Array.from(
                { length: 20 },
                (_, index) =>
                    `\u001b[31m${"█".repeat(index % 2 === 0 ? 4 : 3)}\u001b[0m`
            ).join("\n")
        );
        const source = fs
            .readFileSync(filePath, "utf8")
            .replace(
                "# Source encoding: CP437",
                "# Source encoding: CP437\n# SAUCE Comments: Ripped from the original image"
            );
        fs.writeFileSync(filePath, source);
        return analyzeScript(filePath);
    });

    const issues = analyzeFamilyReviewSignals(records);
    const derivative = issues.find(
        (issue) => issue.type === "derivative-attribution-review"
    );
    const simple = issues.find(
        (issue) => issue.type === "low-structural-complexity"
    );

    assert.deepEqual(derivative.scripts, ["fixture-part01", "fixture-part02"]);
    assert.deepEqual(simple.scripts, ["fixture-part01", "fixture-part02"]);
});

test("family review reports genuinely low color variety", async () => {
    const { analyzeFamilyReviewSignals, analyzeScript } = await analyzer;
    const directory = createTemporaryDirectory();
    const records = [1, 2].map((part) => {
        const start = part === 1 ? 1 : 11;
        const end = start + 9;
        return analyzeScript(
            writeScript(
                directory,
                `fixture-part0${part}`,
                `${start}-${end}`,
                Array.from(
                    { length: 10 },
                    () => `\u001b[31m${"█".repeat(20)}\u001b[0m`
                ).join("\n")
            )
        );
    });

    const issues = analyzeFamilyReviewSignals(records);
    const lowColor = issues.find((issue) => issue.type === "low-color-variety");

    assert.deepEqual(lowColor.colorFamilies, ["red"]);
    assert.equal(lowColor.uniqueColorFamilies, 1);
    assert.deepEqual(lowColor.scripts, ["fixture-part01", "fixture-part02"]);
});

test("split analysis flags dense cuts but not source blank boundaries", async () => {
    const { analyzeScript, analyzeSplitFamilies } = await analyzer;
    const directory = createTemporaryDirectory();
    const denseRows = Array.from(
        { length: 20 },
        () => `\u001b[31m${"█".repeat(40)}\u001b[0m`
    );
    const denseRecords = [
        analyzeScript(
            writeScript(
                directory,
                "dense-part01",
                "1-20",
                [
                    ...denseRows.slice(0, 17),
                    "",
                    ...denseRows.slice(18),
                ].join("\n")
            )
        ),
        analyzeScript(
            writeScript(
                directory,
                "dense-part02",
                "21-40",
                denseRows.join("\n")
            )
        ),
    ];
    const blankRecords = [
        analyzeScript(
            writeScript(
                directory,
                "blank-part01",
                "1-20",
                [...denseRows.slice(0, 19), ""].join("\n")
            )
        ),
        analyzeScript(
            writeScript(
                directory,
                "blank-part02",
                "21-40",
                denseRows.join("\n")
            )
        ),
    ];
    const blankIntroRecords = [
        analyzeScript(
            writeScript(
                directory,
                "intro-part01",
                "1-20",
                [
                    ...Array.from({ length: 18 }, () => ""),
                    ...denseRows.slice(18),
                ].join("\n")
            )
        ),
        analyzeScript(
            writeScript(
                directory,
                "intro-part02",
                "21-40",
                denseRows.join("\n")
            )
        ),
    ];
    const options = {
        blankRun: 3,
        maxRows: 50,
        tinyTailRows: 10,
    };

    const denseIssues = analyzeSplitFamilies(denseRecords, options);
    const blankIssues = analyzeSplitFamilies(blankRecords, options);
    const blankIntroIssues = analyzeSplitFamilies(blankIntroRecords, options);
    const boundary = denseIssues.find(
        (issue) => issue.type === "dense-split-boundary"
    );

    assert.equal(boundary.boundaryAfterRow, 20);
    assert.equal(boundary.suggestedBoundaryAfterRow, 18);
    assert.deepEqual(boundary.scripts, ["dense-part01", "dense-part02"]);
    assert.ok(
        !blankIssues.some((issue) => issue.type === "dense-split-boundary")
    );
    assert.ok(
        !blankIntroIssues.some((issue) => issue.type === "dense-split-boundary")
    );
});

test("split analysis flags a family whose first surviving part starts after row one", async () => {
    const { analyzeScript, analyzeSplitFamilies } = await analyzer;
    const directory = createTemporaryDirectory();
    const record = analyzeScript(
        writeScript(
            directory,
            "missing-intro-part02",
            "21-40",
            Array.from(
                { length: 20 },
                () => `\u001b[31m${"█".repeat(40)}\u001b[0m`
            ).join("\n")
        )
    );

    const issues = analyzeSplitFamilies([record], {
        blankRun: 3,
        maxRows: 50,
        tinyTailRows: 10,
    });
    const gap = issues.find(
        (issue) => issue.type === "source-row-gap-or-overlap"
    );

    assert.deepEqual(gap, {
        type: "source-row-gap-or-overlap",
        family: "missing-intro",
        scripts: ["missing-intro-part02"],
        previousEnd: 0,
        currentStart: 21,
    });
});

test("split analysis flags continuous dense artwork when no safer boundary exists", async () => {
    const { analyzeScript, analyzeSplitFamilies } = await analyzer;
    const directory = createTemporaryDirectory();
    const denseRows = Array.from(
        { length: 50 },
        () => `\u001b[31m${"█".repeat(40)}\u001b[0m`
    );
    const records = [
        analyzeScript(
            writeScript(
                directory,
                "continuous-part01",
                "1-50",
                denseRows.join("\n")
            )
        ),
        analyzeScript(
            writeScript(
                directory,
                "continuous-part02",
                "51-100",
                denseRows.join("\n")
            )
        ),
    ];

    const issues = analyzeSplitFamilies(records, {
        blankRun: 3,
        maxRows: 50,
        tinyTailRows: 10,
    });
    const continuousReview = issues.find(
        (issue) => issue.type === "continuous-split-review"
    );

    assert.equal(continuousReview.partCount, 2);
    assert.equal(continuousReview.boundaryCount, 1);
    assert.equal(continuousReview.boundaryRatio, 1);
    assert.equal(continuousReview.sourceRows, "1-100");
    assert.deepEqual(continuousReview.scripts, [
        "continuous-part01",
        "continuous-part02",
    ]);
    assert.deepEqual(continuousReview.boundaries, [
        {
            scripts: ["continuous-part01", "continuous-part02"],
            boundaryAfterRow: 50,
            previousVisibleCells: 40,
            nextVisibleCells: 40,
            boundaryWidth: 40,
            minimumBoundaryCells: 12,
        },
    ]);
    assert.ok(
        !issues.some((issue) => issue.type === "dense-split-boundary")
    );
});

test("analysis arguments reject unsafe thresholds and unknown options", async () => {
    const { parseArguments } = await analyzer;

    const parsed = parseArguments([
        "--exceptions",
        "temp/exceptions.json",
        "--json",
        "temp/report.json",
        "--type",
        "tiny-tail-part",
        "--type",
        "suspicious-character-decoding",
        "--max-rows",
        "40",
    ]);
    assert.match(parsed.jsonPath, /temp[\\/]report\.json$/u);
    assert.match(parsed.exceptionsPath, /temp[\\/]exceptions\.json$/u);
    assert.deepEqual(parsed.issueTypes, [
        "tiny-tail-part",
        "suspicious-character-decoding",
    ]);
    assert.equal(parsed.options.maxRows, 40);
    assert.throws(
        () => parseArguments(["--tiny-tail-rows=50", "--max-rows=50"]),
        /must be less/
    );
    assert.throws(() => parseArguments(["--json"]), /--json requires a value/);
    assert.throws(() => parseArguments(["--typo"]), /Unknown option/);
    assert.throws(
        () => parseArguments(["--type=Tiny Tail"]),
        /Unknown issue type/
    );
    assert.throws(
        () => parseArguments(["--type=tiny-taill-part"]),
        /Unknown issue type/
    );
    assert.throws(
        () =>
            parseArguments([
                "--exceptions=temp/exceptions.json",
                "--no-exceptions",
            ]),
        /cannot be used together/
    );
});

test("exception ledger suppresses exact reviewed findings and rejects drift", async () => {
    const { applyAnalysisExceptions, loadAnalysisExceptions } = await analyzer;
    const directory = createTemporaryDirectory();
    const filePath = path.join(directory, "exceptions.json");
    fs.writeFileSync(
        filePath,
        `${JSON.stringify(
            {
                schemaVersion: 1,
                exceptions: [
                    {
                        issueType: "avoidable-extra-part",
                        family: "fixture",
                        reason: "Reviewed source panel boundaries.",
                    },
                ],
            },
            null,
            2
        )}\n`
    );

    const exceptions = loadAnalysisExceptions(filePath);
    const result = applyAnalysisExceptions(
        [
            {
                type: "avoidable-extra-part",
                family: "fixture",
                currentParts: 3,
                minimumParts: 2,
            },
            { type: "tiny-tail-part", family: "other" },
        ],
        exceptions
    );

    assert.deepEqual(result.issues, [
        { type: "tiny-tail-part", family: "other" },
    ]);
    assert.deepEqual(result.applied, exceptions);
    assert.throws(
        () =>
            applyAnalysisExceptions(
                [{ type: "tiny-tail-part", family: "fixture" }],
                exceptions
            ),
        /matched 0 findings/
    );
    assert.throws(
        () => applyAnalysisExceptions([], [...exceptions, ...exceptions]),
        /matched 0 findings|Duplicate analysis exception/
    );
});

test("exception ledger can identify one dense boundary within a family", async () => {
    const { applyAnalysisExceptions, loadAnalysisExceptions } = await analyzer;
    const directory = createTemporaryDirectory();
    const filePath = path.join(directory, "exceptions.json");
    fs.writeFileSync(
        filePath,
        `${JSON.stringify(
            {
                schemaVersion: 1,
                exceptions: [
                    {
                        issueType: "dense-split-boundary",
                        family: "fixture",
                        boundaryAfterRow: 50,
                        reason: "No safe blank-row boundary exists.",
                    },
                ],
            },
            null,
            2
        )}\n`
    );

    const exceptions = loadAnalysisExceptions(filePath);
    const result = applyAnalysisExceptions(
        [
            {
                type: "dense-split-boundary",
                family: "fixture",
                boundaryAfterRow: 50,
            },
            {
                type: "dense-split-boundary",
                family: "fixture",
                boundaryAfterRow: 100,
            },
        ],
        exceptions
    );

    assert.deepEqual(result.issues, [
        {
            type: "dense-split-boundary",
            family: "fixture",
            boundaryAfterRow: 100,
        },
    ]);
    assert.deepEqual(result.applied, exceptions);
});

test("report filtering keeps only requested review types", async () => {
    const { filterReport } = await analyzer;
    const report = {
        schemaVersion: 4,
        generatedAt: "2026-07-23T00:00:00.000Z",
        scriptsDirectory: "fixture",
        summary: {
            scripts: 2,
            splitScripts: 2,
            issues: 2,
            suppressedIssues: 1,
            "tiny-tail-part": 1,
            "very-small-output": 1,
        },
        appliedExceptions: [
            {
                issueType: "avoidable-extra-part",
                family: "intentional",
                reason: "Fixture.",
            },
        ],
        issues: [
            { type: "tiny-tail-part", script: "fixture-part02" },
            { type: "very-small-output", script: "fixture-part02" },
        ],
        scripts: [],
    };

    const filtered = filterReport(report, ["tiny-tail-part"]);

    assert.deepEqual(filtered.summary, {
        scripts: 2,
        splitScripts: 2,
        issues: 1,
        suppressedIssues: 0,
        "tiny-tail-part": 1,
    });
    assert.deepEqual(filtered.appliedExceptions, []);
    assert.deepEqual(filtered.issues, [
        { type: "tiny-tail-part", script: "fixture-part02" },
    ]);
});
