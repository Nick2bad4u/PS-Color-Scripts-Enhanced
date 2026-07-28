"use strict";

const assert = require("node:assert/strict");
const crypto = require("node:crypto");
const fs = require("node:fs");
const path = require("node:path");
const test = require("node:test");
const { pathToFileURL } = require("node:url");

const REPOSITORY_ROOT = path.resolve(__dirname, "..");
const ANALYZER_PATH = path.join(
    REPOSITORY_ROOT,
    "scripts",
    "Analyze-ColorScripts.mjs"
);
const LEDGER_PATH = path.join(
    REPOSITORY_ROOT,
    "ColorScripts-Enhanced",
    "AnsiGeometryRetentionReviewLedger.json"
);
const CHECKPOINT_PATH = path.join(
    REPOSITORY_ROOT,
    "ColorScripts-Enhanced",
    "AnsiContentCurationCheckpoint.json"
);
const SCRIPTS_DIRECTORY = path.join(
    REPOSITORY_ROOT,
    "ColorScripts-Enhanced",
    "Scripts"
);
const SHA256_PATTERN = /^[0-9a-f]{64}$/u;
const SCRIPT_NAME_PATTERN = /^16c-[a-z0-9-]+$/u;
const SOURCE_RANGE_PATTERN = /^\d+-\d+$/u;
const REVIEWED_SIGNALS = new Set([
    "extreme-leading-blank-run",
    "orphaned-tail-after-blank-run",
]);
const analyzer = import(pathToFileURL(ANALYZER_PATH).href);

function sha256(content) {
    return crypto.createHash("sha256").update(content).digest("hex");
}

function loadLedger() {
    return JSON.parse(fs.readFileSync(LEDGER_PATH, "utf8"));
}

function loadCheckpoint() {
    return JSON.parse(fs.readFileSync(CHECKPOINT_PATH, "utf8"));
}

function analysisOptions(ledger) {
    return {
        blankRun: ledger.analyzer.blankRun,
        maxRows: ledger.analyzer.maxRows,
        tinyTailRows: ledger.analyzer.tinyTailRows,
    };
}

function normalizeMetrics(issue) {
    if (issue.type === "extreme-leading-blank-run") {
        return {
            leadingBlankRows: issue.rows,
            totalRows: issue.totalRows,
        };
    }
    if (issue.type === "orphaned-tail-after-blank-run") {
        return {
            blankRunStartRow: issue.startRow,
            blankRunEndRow: issue.endRow,
            blankRunRows: issue.rows,
            visibleRowsAfter: issue.visibleRowsAfter,
            remainingRows: issue.remainingRows,
        };
    }
    throw new Error(`Unsupported geometry-retention signal: ${issue.type}`);
}

function assertCanonical16colorsUrl(value, expectedPathPattern, label) {
    assert.equal(typeof value, "string", `${label} must be a string`);
    assert.doesNotThrow(() => new URL(value), `${label} must be a valid URL`);
    const parsed = new URL(value);
    assert.equal(parsed.protocol, "https:", `${label} must use HTTPS`);
    assert.equal(parsed.hostname, "16colo.rs", `${label} must use 16colo.rs`);
    assert.equal(parsed.port, "", `${label} must not specify a port`);
    assert.equal(parsed.username, "", `${label} must not contain credentials`);
    assert.equal(parsed.password, "", `${label} must not contain credentials`);
    assert.equal(parsed.search, "", `${label} must not contain a query`);
    assert.equal(parsed.hash, "", `${label} must not contain a fragment`);
    assert.match(
        parsed.pathname,
        expectedPathPattern,
        `${label} is not canonical`
    );
}

async function validateLedger(ledger, scriptsDirectory = SCRIPTS_DIRECTORY) {
    const { analyzeReviewSignals, analyzeScript } = await analyzer;

    assert.equal(ledger.schemaVersion, 1);
    assert.match(ledger.reviewedAt, /^\d{4}-\d{2}-\d{2}$/u);
    assert.equal(ledger.disposition, "retained-after-review");
    assert.ok(
        typeof ledger.policy === "string" && ledger.policy.trim().length > 0,
        "Retention policy must be documented"
    );
    assert.ok(
        typeof ledger.reviewBasis === "string" &&
            ledger.reviewBasis.trim().length > 0,
        "Review basis must be documented"
    );
    assert.equal(ledger.analyzer.script, "scripts/Analyze-ColorScripts.mjs");
    assert.deepEqual(ledger.analyzer.signals, [...REVIEWED_SIGNALS]);
    for (const property of [
        "blankRun",
        "maxRows",
        "tinyTailRows",
    ]) {
        assert.ok(
            Number.isSafeInteger(ledger.analyzer[property]) &&
                ledger.analyzer[property] > 0,
            `Analyzer ${property} must be a positive integer`
        );
    }
    assert.ok(
        Array.isArray(ledger.decisions) && ledger.decisions.length > 0,
        "Retention decisions must be a non-empty array"
    );

    const decisionOrder = ledger.decisions.map(
        ({ signal, script }) => `${signal}\0${script}`
    );
    assert.deepEqual(
        decisionOrder,
        [...decisionOrder].sort((left, right) =>
            left.localeCompare(right, "en-US")
        ),
        "Retention decisions must have deterministic signal/script ordering"
    );

    const seenScripts = new Set();
    const issueKeys = new Set();
    const counts = Object.fromEntries(
        [...REVIEWED_SIGNALS].map((signal) => [signal, 0])
    );
    for (const decision of ledger.decisions) {
        assert.match(
            decision.script,
            SCRIPT_NAME_PATTERN,
            `Malformed script name: ${decision.script}`
        );
        assert.ok(
            !seenScripts.has(decision.script),
            `Duplicate retained script: ${decision.script}`
        );
        seenScripts.add(decision.script);
        assert.ok(
            REVIEWED_SIGNALS.has(decision.signal),
            `${decision.script} has unsupported signal ${decision.signal}`
        );
        assert.equal(
            decision.disposition,
            "retain-authentic-composition",
            `${decision.script} must retain authentic composition`
        );
        assert.ok(
            decision.confidence === "high" || decision.confidence === "medium",
            `${decision.script} must record high or medium confidence`
        );
        assert.match(
            decision.scriptSha256,
            SHA256_PATTERN,
            `${decision.script} scriptSha256 must be lowercase SHA-256`
        );
        assert.match(
            decision.sourceRows,
            SOURCE_RANGE_PATTERN,
            `${decision.script} sourceRows must be inclusive coordinates`
        );
        assert.match(
            decision.sourceColumns,
            SOURCE_RANGE_PATTERN,
            `${decision.script} sourceColumns must be inclusive coordinates`
        );
        assert.ok(
            typeof decision.observedComposition === "string" &&
                decision.observedComposition.trim().length > 0,
            `${decision.script} must record the observed composition`
        );
        assert.ok(
            typeof decision.reviewRationale === "string" &&
                decision.reviewRationale.trim().length > 0,
            `${decision.script} must document its review rationale`
        );
        assertCanonical16colorsUrl(
            decision.sourceUrl,
            /^\/pack\/[^/]+\/raw\/[^/]+$/u,
            `${decision.script} sourceUrl`
        );
        assertCanonical16colorsUrl(
            decision.previewUrl,
            /^\/pack\/[^/]+\/x1\/[^/]+\.png$/u,
            `${decision.script} previewUrl`
        );

        const scriptPath = path.join(
            scriptsDirectory,
            `${decision.script}.ps1`
        );
        assert.ok(
            fs.existsSync(scriptPath),
            `Retained script is missing: ${decision.script}`
        );
        const source = fs.readFileSync(scriptPath, "utf8");
        assert.equal(
            sha256(source),
            decision.scriptSha256,
            `${decision.script} changed after geometry review`
        );

        const record = analyzeScript(scriptPath);
        assert.equal(
            record.analysisError,
            null,
            `${decision.script} must remain statically analyzable`
        );
        assert.equal(
            record.header["Source URL"],
            decision.sourceUrl,
            `${decision.script} source URL differs from its script header`
        );
        assert.equal(
            `${record.sourceRowStart}-${record.sourceRowEnd}`,
            decision.sourceRows,
            `${decision.script} source rows differ from its script header`
        );
        assert.equal(
            `${record.sourceColumnStart}-${record.sourceColumnEnd}`,
            decision.sourceColumns,
            `${decision.script} source columns differ from its script header`
        );

        const severeIssues = analyzeReviewSignals(
            [record],
            analysisOptions(ledger)
        ).filter((issue) => REVIEWED_SIGNALS.has(issue.type));
        assert.equal(
            severeIssues.length,
            1,
            `${decision.script} must produce exactly one reviewed severe signal`
        );
        const issue = severeIssues[0];
        assert.equal(
            issue.type,
            decision.signal,
            `${decision.script} severe signal changed`
        );
        assert.deepEqual(
            normalizeMetrics(issue),
            decision.metrics,
            `${decision.script} severe geometry metrics changed`
        );
        const issueKey = `${issue.type}\0${issue.script}`;
        assert.ok(
            !issueKeys.has(issueKey),
            `Duplicate severe geometry issue: ${issueKey}`
        );
        issueKeys.add(issueKey);
        counts[decision.signal] += 1;
    }

    assert.equal(
        ledger.summary.scripts,
        seenScripts.size,
        "Retention script summary is stale"
    );
    assert.equal(
        ledger.summary.extremeLeadingBlankRun,
        counts["extreme-leading-blank-run"],
        "Extreme-leading summary is stale"
    );
    assert.equal(
        ledger.summary.orphanedTailAfterBlankRun,
        counts["orphaned-tail-after-blank-run"],
        "Orphaned-tail summary is stale"
    );
}

function assertCheckpointReconciled(ledger, checkpoint) {
    assert.deepEqual(checkpoint.geometryRetentionReview, {
        ledger: path.basename(LEDGER_PATH),
        scriptsRetained: ledger.summary.scripts,
        extremeLeadingBlankRun: ledger.summary.extremeLeadingBlankRun,
        orphanedTailAfterBlankRun: ledger.summary.orphanedTailAfterBlankRun,
        disposition: "retain-authentic-composition",
    });
}

async function findCurrentSevereIssues(ledger) {
    const { analyzeReviewSignals, analyzeScript } = await analyzer;
    const issues = [];
    for (const entry of fs.readdirSync(SCRIPTS_DIRECTORY, {
        withFileTypes: true,
    })) {
        if (!entry.isFile() || path.extname(entry.name) !== ".ps1") continue;
        const record = analyzeScript(path.join(SCRIPTS_DIRECTORY, entry.name));
        issues.push(
            ...analyzeReviewSignals([record], analysisOptions(ledger)).filter(
                (issue) => REVIEWED_SIGNALS.has(issue.type)
            )
        );
    }
    return issues;
}

test("retained severe geometry decisions reconcile with current scripts", async () => {
    const ledger = loadLedger();
    await assert.doesNotReject(() => validateLedger(ledger));
    assertCheckpointReconciled(ledger, loadCheckpoint());
});

test("retention ledger covers every current severe geometry signal", async () => {
    const ledger = loadLedger();
    const expected = ledger.decisions.map(
        ({ signal, script }) => `${signal}\0${script}`
    );
    const actual = (await findCurrentSevereIssues(ledger))
        .map(({ type, script }) => `${type}\0${script}`)
        .sort((left, right) => left.localeCompare(right, "en-US"));
    assert.deepEqual(actual, expected);
});

test("retention validation fails closed on script and metric drift", async () => {
    const hashDrift = loadLedger();
    hashDrift.decisions[0].scriptSha256 = "0".repeat(64);
    await assert.rejects(
        () => validateLedger(hashDrift),
        /changed after geometry review/u
    );

    const metricDrift = loadLedger();
    metricDrift.decisions[0].metrics.leadingBlankRows += 1;
    await assert.rejects(
        () => validateLedger(metricDrift),
        /severe geometry metrics changed/u
    );
});

test("retention validation rejects duplicates and malformed evidence", async () => {
    const duplicate = loadLedger();
    duplicate.decisions.splice(1, 0, structuredClone(duplicate.decisions[0]));
    await assert.rejects(
        () => validateLedger(duplicate),
        /deterministic signal\/script ordering|Duplicate retained script/u
    );

    const malformedUrl = loadLedger();
    malformedUrl.decisions[0].previewUrl =
        "http://16colo.rs/pack/example/x1/example.ans.png";
    await assert.rejects(
        () => validateLedger(malformedUrl),
        /previewUrl must use HTTPS/u
    );
});
