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

test("analysis arguments reject unsafe thresholds and unknown options", async () => {
    const { parseArguments } = await analyzer;

    const parsed = parseArguments([
        "--exceptions",
        "temp/exceptions.json",
        "--json",
        "temp/report.json",
        "--type",
        "tiny-tail-part",
        "--max-rows",
        "40",
    ]);
    assert.match(parsed.jsonPath, /temp[\\/]report\.json$/u);
    assert.match(parsed.exceptionsPath, /temp[\\/]exceptions\.json$/u);
    assert.deepEqual(parsed.issueTypes, ["tiny-tail-part"]);
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

test("report filtering keeps only requested review types", async () => {
    const { filterReport } = await analyzer;
    const report = {
        schemaVersion: 2,
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
