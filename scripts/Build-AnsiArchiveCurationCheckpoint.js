"use strict";

const crypto = require("node:crypto");
const fs = require("node:fs");
const path = require("node:path");
const {
    assertCheckpointCurrent,
    reconcileImportedDisposition,
} = require("./AnsiCheckpointValidation.js");
const { readArtworkProvenance } = require("./ArtworkProvenance.js");

const root = path.resolve(__dirname, "..");
const auditRoot = path.join(root, "temp", "ansi-archive-audit-full");
const checkpointPath = path.join(
    root,
    "audit",
    "AnsiArchiveCurationCheckpoint.json"
);
const provenancePath = path.join(root, "audit", "ArtworkProvenance.psd1");
const historicalReconciliationPath = path.join(
    auditRoot,
    "promotion-reconciliation-1990-2003-29ea5150.json"
);
const modernReconciliationPath = path.join(
    auditRoot,
    "promotion-reconciliation-2004-2026-29ea5150-head46e21e04.json"
);
const reportPath = path.join(
    root,
    "temp",
    "final-checkpoint-build-report.json"
);
const detailedReportPath = path.join(
    root,
    "temp",
    "final-consolidated-ansi-archive-review.json"
);
const pendingVisualReviewPath = path.join(
    root,
    "temp",
    "final-ansi-archive-visual-review-pending.json"
);
const supplementalVisualReviewPath = path.join(
    root,
    "temp",
    "final-ansi-archive-supplemental-visual-review.json"
);
const write = process.argv.includes("--write");

const supplementalVisualReview = fs.existsSync(supplementalVisualReviewPath)
    ? JSON.parse(fs.readFileSync(supplementalVisualReviewPath, "utf8"))
    : { schemaVersion: 1, entries: [] };
if (
    supplementalVisualReview.schemaVersion !== 1 ||
    !Array.isArray(supplementalVisualReview.entries)
) {
    throw new Error("Supplemental visual-review evidence is malformed.");
}
const supplementalVisualReviewById = new Map();
for (const entry of supplementalVisualReview.entries) {
    if (
        !entry ||
        typeof entry.id !== "string" ||
        typeof entry.sourceSha256 !== "string" ||
        !/^[0-9a-f]{64}$/u.test(entry.sourceSha256) ||
        typeof entry.reviewNote !== "string" ||
        !entry.reviewNote.trim()
    ) {
        throw new Error("Supplemental visual-review entry is malformed.");
    }
    if (supplementalVisualReviewById.has(entry.id)) {
        throw new Error(
            `Duplicate supplemental visual review for ${entry.id}.`
        );
    }
    supplementalVisualReviewById.set(entry.id, entry);
}
const matchedSupplementalVisualReviewIds = new Set();

function sha256(value) {
    return crypto.createHash("sha256").update(value).digest("hex");
}

function readJson(filePath) {
    return JSON.parse(fs.readFileSync(filePath, "utf8"));
}

function normalizeSourceKey(year, sourceFile) {
    return `${year}\0${sourceFile.replaceAll("\\", "/").toLowerCase()}`;
}

const provenanceEntries = [];
for (const [name, provenance] of readArtworkProvenance(provenancePath)
    .scripts) {
    if (provenance.Collection !== "16colors-permitted") {
        continue;
    }
    const archiveUrl = provenance.ArchiveUrl;
    const yearMatch = /\/archive\/(\d{4})\//u.exec(
        typeof archiveUrl === "string" ? archiveUrl : ""
    );
    if (!yearMatch) {
        throw new Error(
            `${name}: cannot derive the archive year from ${String(archiveUrl)}.`
        );
    }
    const entry = {
        name,
        archiveYear: Number(yearMatch[1]),
        sourceFile: provenance.SourceFile,
        sourceUrl: provenance.SourceUrl,
        sourceSha256: provenance.SourceSha256,
        renderSha256: provenance.RenderSha256,
        normalizedRenderSha256: provenance.NormalizedRenderSha256,
        sourceRows: provenance.SourceRows,
        sourceColumns: provenance.SourceColumns,
    };
    for (const property of [
        "sourceFile",
        "sourceUrl",
        "sourceSha256",
        "renderSha256",
        "normalizedRenderSha256",
        "sourceRows",
        "sourceColumns",
    ]) {
        if (!entry[property]) {
            throw new Error(`${entry.name}: ${property} is missing.`);
        }
    }
    provenanceEntries.push(entry);
}

const worksByKey = new Map();
for (const entry of provenanceEntries) {
    const key = normalizeSourceKey(entry.archiveYear, entry.sourceFile);
    const existing = worksByKey.get(key);
    if (existing) {
        for (const property of [
            "sourceUrl",
            "sourceSha256",
            "renderSha256",
            "normalizedRenderSha256",
        ]) {
            if (existing[property] !== entry[property]) {
                throw new Error(
                    `${key}: split provenance disagrees on ${property}.`
                );
            }
        }
        existing.scriptCount += 1;
        existing.scripts.push({
            name: entry.name,
            sourceRows: entry.sourceRows,
            sourceColumns: entry.sourceColumns,
        });
    } else {
        worksByKey.set(key, {
            ...entry,
            scriptCount: 1,
            scripts: [
                {
                    name: entry.name,
                    sourceRows: entry.sourceRows,
                    sourceColumns: entry.sourceColumns,
                },
            ],
        });
    }
}
const works = [...worksByKey.values()];

function parseInclusiveRange(value, label) {
    const match = /^(?<start>\d+)-(?<end>\d+)$/u.exec(value);
    if (!match) {
        throw new Error(`${label}: invalid inclusive range '${value}'.`);
    }
    const start = Number(match.groups.start);
    const end = Number(match.groups.end);
    if (start < 1 || end < start) {
        throw new Error(`${label}: invalid inclusive range '${value}'.`);
    }
    return { start, end };
}

let verifiedAdjacencyCount = 0;
let verifiedGeometryCount = 0;
for (const work of works) {
    const scriptsByColumns = new Map();
    for (const script of work.scripts) {
        const rows = parseInclusiveRange(
            script.sourceRows,
            `${script.name} SourceRows`
        );
        const columns = parseInclusiveRange(
            script.sourceColumns,
            `${script.name} SourceColumns`
        );
        if (rows.end - rows.start + 1 > 50) {
            throw new Error(`${script.name}: output exceeds 50 source rows.`);
        }
        if (columns.end - columns.start + 1 > 120) {
            throw new Error(
                `${script.name}: output exceeds 120 source columns.`
            );
        }
        verifiedGeometryCount += 1;
        const siblings = scriptsByColumns.get(script.sourceColumns) || [];
        siblings.push({ ...script, rows });
        scriptsByColumns.set(script.sourceColumns, siblings);
    }
    for (const [columns, siblings] of scriptsByColumns) {
        siblings.sort(
            (left, right) =>
                left.rows.start - right.rows.start ||
                left.rows.end - right.rows.end
        );
        if (siblings[0].rows.start !== 1) {
            throw new Error(
                `${work.sourceFile} columns ${columns}: source rows do not start at 1.`
            );
        }
        for (let index = 1; index < siblings.length; index += 1) {
            const previous = siblings[index - 1];
            const current = siblings[index];
            if (current.rows.start !== previous.rows.end + 1) {
                throw new Error(
                    `${work.sourceFile} columns ${columns}: ${previous.name} and ${current.name} have a source-row gap or overlap.`
                );
            }
            verifiedAdjacencyCount += 1;
        }
    }
}

for (const property of [
    "sourceSha256",
    "renderSha256",
    "normalizedRenderSha256",
]) {
    const seen = new Map();
    for (const work of works) {
        const first = seen.get(work[property]);
        if (first) {
            throw new Error(
                `${property} collision: ${first.sourceFile} and ${work.sourceFile}.`
            );
        }
        seen.set(work[property], work);
    }
}

const historical = readJson(historicalReconciliationPath);
const modern = readJson(modernReconciliationPath);
const reconciliationsByYear = new Map();
for (const reconciliation of [historical, modern]) {
    for (const year of reconciliation.years) {
        if (reconciliationsByYear.has(year.year)) {
            throw new Error(`Duplicate reconciliation year ${year.year}.`);
        }
        reconciliationsByYear.set(year.year, year);
    }
}

const overrideDispositions = new Map();
const setOverride = (year, sourceFile, disposition) => {
    const key = normalizeSourceKey(year, sourceFile);
    const prior = overrideDispositions.get(key);
    if (prior && prior !== disposition) {
        throw new Error(`${key}: conflicting disposition overrides.`);
    }
    overrideDispositions.set(key, disposition);
};
for (const removal of historical.scope.removalAuthority.removals) {
    const dispositions = {
        "explicit-content-rejection": "rejected-content",
        "explicit-composition-rejection": "rejected-composition",
        "explicit-duplicate-render-repack": "rejected-duplicate-render",
    };
    const disposition = dispositions[removal.reason];
    if (disposition) {
        setOverride(removal.year, removal.sourceFile, disposition);
    }
}
for (const removal of modern.scope.resolvedSourceRejections) {
    setOverride(removal.year, removal.sourceFile, removal.disposition);
}
setOverride(2016, "33rules/33-TREG3.ANS", "rejected-duplicate-render");
for (const [year, sourceFile] of [
    [1992, "1992/GD_IR1.ANS"],
    [1994, "acdu0294/TC-BV2.ANS"],
    [1994, "acdu0294/TC-GOD.ANS"],
    [1994, "acdu0494/RN-TTG1.ANS"],
    [1995, "acdu0695/P1-SUCCO.ANS"],
    [1994, "bkn-1094/DD-TH.ANS"],
    [1994, "blde9404/SS-CZ.ANS"],
    [1994, "blde9404/SS-RH.ANS"],
    [1994, "grnd1194/CS-HSA1.ANS"],
    [1994, "grnd1194/NO-BB2.ANS"],
    [1994, "grnd1194/SOS-SAMH.ANS"],
    [1994, "ice-9407/FS-HM.ICE"],
    [1996, "k0tpr0be/TR-USLST.ANS"],
    [1994, "rem-0694/FA-EU3.ANS"],
]) {
    setOverride(year, sourceFile, "rejected-licensing");
}
setOverride(1994, "acdu1294/TT-TF.ANS", "rejected-content");
setOverride(1995, "cnc-0295/EN-ANIM.ANS", "rejected-unsupported-terminal");
setOverride(2000, "sac-20/frx-pd01.ans", "rejected-content");
setOverride(2021, "lgcy-003/5m-acidburn.ans", "rejected-composition");
setOverride(2021, "lgcy-003/5m-toxicbbs.ans", "rejected-composition");

const oldCheckpoint = readJson(checkpointPath);
const years = [];
const dispositionTotals = {};
const acceptedSources = [];
const detailedCandidates = [];
const matchedWorkKeys = new Set();
let apiInventory = null;
const visualReview = {
    acceptedSourceCount: 0,
    acceptedWithReviewNoteCount: 0,
    acceptedWithReviewFlagCount: 0,
    acceptedWithReviewEvidenceCount: 0,
    acceptedWithSupplementalReviewCount: 0,
    acceptedWithCachedPreviewCount: 0,
    acceptedWithoutCachedPreviewCount: 0,
    previewKinds: {},
    missingReviewEvidence: [],
};

function addDisposition(target, disposition) {
    target[disposition] = (target[disposition] || 0) + 1;
}

for (let year = 1990; year <= 2026; year += 1) {
    const reconciliation = reconciliationsByYear.get(year);
    if (!reconciliation) {
        throw new Error(`No authoritative reconciliation for ${year}.`);
    }
    let reportReference = reconciliation.report || null;
    if (!reportReference) {
        const yearDirectory = path.join(
            auditRoot,
            "review-years",
            String(year)
        );
        const candidates = [
            "report.content-corrected-29ea5150.json",
            "report.regen-29ea5150.json",
            "report.decided.json",
        ];
        const filename = candidates.find((name) =>
            fs.existsSync(path.join(yearDirectory, name))
        );
        if (!filename) {
            throw new Error(`${year}: no authoritative report exists.`);
        }
        reportReference = {
            path: path
                .relative(root, path.join(yearDirectory, filename))
                .replaceAll("\\", "/"),
            sha256: null,
        };
    }
    const authoritativeReportPath = path.join(root, reportReference.path);
    const reportBytes = fs.readFileSync(authoritativeReportPath);
    const actualReportSha256 = sha256(reportBytes);
    if (
        reportReference.sha256 &&
        actualReportSha256 !== reportReference.sha256
    ) {
        throw new Error(`${year}: authoritative report hash changed.`);
    }
    const report = JSON.parse(reportBytes.toString("utf8"));
    const yearDispositionTotals = {};
    for (const candidate of report.candidates) {
        const sourceFile = String(candidate.id).replace(/^16colors:/u, "");
        const key = normalizeSourceKey(year, sourceFile);
        const work = worksByKey.get(key);
        let disposition = candidate.disposition;
        if (work) {
            if (candidate.analysis?.sourceSha256 !== work.sourceSha256) {
                throw new Error(
                    `${key}: report/provenance source hash mismatch.`
                );
            }
            disposition = reconcileImportedDisposition(
                key,
                candidate.disposition
            );
            matchedWorkKeys.add(key);
        } else if (candidate.disposition === "accepted") {
            disposition = overrideDispositions.get(key);
            if (!disposition) {
                throw new Error(
                    `${key}: accepted report candidate is absent from final provenance without an override.`
                );
            }
        }
        if (String(disposition).startsWith("pending-review")) {
            throw new Error(`${key}: final disposition is still pending.`);
        }
        const supplementalReview = supplementalVisualReviewById.get(
            candidate.id
        );
        if (supplementalReview) {
            if (
                supplementalReview.sourceSha256 !==
                candidate.analysis?.sourceSha256
            ) {
                throw new Error(
                    `${candidate.id}: supplemental visual-review source hash changed.`
                );
            }
            matchedSupplementalVisualReviewIds.add(candidate.id);
        }
        const reportReviewNote =
            typeof candidate.reviewNote === "string"
                ? candidate.reviewNote.trim()
                : "";
        const reviewNote =
            reportReviewNote || supplementalReview?.reviewNote.trim() || "";
        const reviewEvidenceSource = reportReviewNote
            ? "authoritative-report-note"
            : candidate.review === true
              ? "authoritative-report-flag"
              : supplementalReview
                ? "supplemental-official-preview-review"
                : null;
        const previewKind =
            typeof candidate.previewKind === "string"
                ? candidate.previewKind
                : supplementalReview?.previewKind || "unrecorded";
        const previewPath =
            typeof candidate.previewPath === "string"
                ? candidate.previewPath
                : supplementalReview?.previewPath || null;
        const hasCachedPreview =
            previewPath !== null && fs.existsSync(previewPath);
        if (disposition === "accepted") {
            visualReview.acceptedSourceCount += 1;
            visualReview.previewKinds[previewKind] =
                (visualReview.previewKinds[previewKind] || 0) + 1;
            if (reviewNote) {
                visualReview.acceptedWithReviewNoteCount += 1;
            }
            if (candidate.review === true) {
                visualReview.acceptedWithReviewFlagCount += 1;
            }
            if (supplementalReview) {
                visualReview.acceptedWithSupplementalReviewCount += 1;
            }
            if (reviewEvidenceSource) {
                visualReview.acceptedWithReviewEvidenceCount += 1;
            } else {
                visualReview.missingReviewEvidence.push({
                    id: candidate.id,
                    year,
                    pack: candidate.pack,
                    filename: candidate.filename,
                    previewPath,
                    previewKind,
                });
            }
            if (hasCachedPreview) {
                visualReview.acceptedWithCachedPreviewCount += 1;
            } else {
                visualReview.acceptedWithoutCachedPreviewCount += 1;
            }
        }
        detailedCandidates.push({
            id: candidate.id,
            year,
            pack: candidate.pack,
            filename: candidate.filename,
            format: candidate.format,
            disposition,
            sourceUrl: candidate.sourceUrl,
            galleryUrl: candidate.galleryUrl,
            previewUrl: candidate.previewUrl,
            sourceSha256: candidate.analysis?.sourceSha256 || null,
            normalizedRenderSha256:
                candidate.analysis?.normalizedRenderSha256 || null,
            reviewNote: reviewNote || null,
            reviewEvidenceSource,
            previewKind,
            cachedPreview: hasCachedPreview,
        });
        addDisposition(yearDispositionTotals, disposition);
        addDisposition(dispositionTotals, disposition);
    }
    const inventory = report.inventory.sixteenColors;
    if (report.candidates.length !== inventory.candidateCount) {
        throw new Error(`${year}: candidate inventory count mismatch.`);
    }
    const dispositionCount = Object.values(yearDispositionTotals).reduce(
        (sum, count) => sum + count,
        0
    );
    if (dispositionCount !== inventory.candidateCount) {
        throw new Error(`${year}: incomplete disposition totals.`);
    }
    const currentApiInventory = {
        apiReportedPackTotal: inventory.apiReportedPackTotal,
        apiEnumeratedPackCount: inventory.apiEnumeratedPackCount,
        apiUnreturnedPackCount: inventory.apiUnreturnedPackCount,
    };
    if (
        apiInventory &&
        JSON.stringify(apiInventory) !== JSON.stringify(currentApiInventory)
    ) {
        throw new Error(`${year}: canonical API totals changed.`);
    }
    apiInventory ||= currentApiInventory;
    const yearWorks = works
        .filter((work) => work.archiveYear === year)
        .sort((left, right) => left.sourceFile.localeCompare(right.sourceFile));
    for (const work of yearWorks) {
        acceptedSources.push({
            archiveYear: year,
            id: `16colors:${work.sourceFile}`,
            disposition: "accepted",
            sourceUrl: work.sourceUrl,
            sourceSha256: work.sourceSha256,
            renderSha256: work.renderSha256,
            normalizedRenderSha256: work.normalizedRenderSha256,
        });
    }
    years.push({
        year,
        scannedAt: report.scannedAt,
        packCount: inventory.packCount,
        candidateCount: inventory.candidateCount,
        importedWorkCount: yearWorks.length,
        emittedScriptCount: yearWorks.reduce(
            (sum, work) => sum + work.scriptCount,
            0
        ),
        inventorySha256: inventory.fingerprint,
        auditCheckpointSha256: actualReportSha256,
        dispositionTotals: Object.fromEntries(
            Object.entries(yearDispositionTotals).sort(([left], [right]) =>
                left.localeCompare(right)
            )
        ),
    });
}

const unusedSupplementalVisualReviewIds = [
    ...supplementalVisualReviewById.keys(),
].filter((id) => !matchedSupplementalVisualReviewIds.has(id));
if (unusedSupplementalVisualReviewIds.length > 0) {
    throw new Error(
        `${unusedSupplementalVisualReviewIds.length} supplemental visual-review entries do not match the authoritative reports: ${unusedSupplementalVisualReviewIds
            .slice(0, 10)
            .join(", ")}`
    );
}

const unmatchedWorkKeys = [...worksByKey.keys()].filter(
    (key) => !matchedWorkKeys.has(key)
);
if (unmatchedWorkKeys.length > 0) {
    throw new Error(
        `${unmatchedWorkKeys.length} final provenance works are absent from their authoritative reports: ${unmatchedWorkKeys
            .slice(0, 10)
            .join(", ")}`
    );
}

const stableInventory = {
    sixteenColors: years.map(({ year, inventorySha256 }) => ({
        year,
        inventorySha256,
    })),
    roy: oldCheckpoint.roy.inventorySha256,
};
const combinedInventorySha256 = sha256(JSON.stringify(stableInventory));
const totals = {
    completedYearCount: years.length,
    ...apiInventory,
    packCount: years.reduce((sum, year) => sum + year.packCount, 0),
    candidateCount: years.reduce((sum, year) => sum + year.candidateCount, 0),
    importedWorkCount: works.length,
    emittedScriptCount: provenanceEntries.length,
    acceptedSourceCount: acceptedSources.length,
    dispositionTotals: Object.fromEntries(
        Object.entries(dispositionTotals).sort(([left], [right]) =>
            left.localeCompare(right)
        )
    ),
};
if (totals.acceptedSourceCount !== totals.importedWorkCount) {
    throw new Error("Accepted-source and imported-work totals diverged.");
}
if (visualReview.acceptedSourceCount !== totals.acceptedSourceCount) {
    throw new Error("Accepted-source and visual-review totals diverged.");
}
visualReview.acceptedWithoutReviewEvidenceCount =
    visualReview.acceptedSourceCount -
    visualReview.acceptedWithReviewEvidenceCount;
visualReview.emittedScriptCount = provenanceEntries.length;
visualReview.verifiedGeometryCount = verifiedGeometryCount;
visualReview.verifiedAdjacencyCount = verifiedAdjacencyCount;
visualReview.geometryFailures = 0;
visualReview.adjacencyFailures = 0;
visualReview.unresolvedCount = 0;
visualReview.previewKinds = Object.fromEntries(
    Object.entries(visualReview.previewKinds).sort(([left], [right]) =>
        left.localeCompare(right)
    )
);
if (visualReview.acceptedWithoutReviewEvidenceCount !== 0) {
    fs.writeFileSync(
        pendingVisualReviewPath,
        `${JSON.stringify(visualReview.missingReviewEvidence, null, 2)}\n`,
        "utf8"
    );
    throw new Error(
        `${visualReview.acceptedWithoutReviewEvidenceCount} accepted sources lack visual-review evidence.`
    );
}

const royProvenanceCount = [
    ...provenanceText.matchAll(/^ {12}Collection\s*=\s*'roy-sac'\r?$/gmu),
].length;
if (royProvenanceCount !== oldCheckpoint.roy.emittedScriptCount) {
    throw new Error(
        "Roy emitted-script checkpoint no longer matches provenance."
    );
}

const output = {
    schemaVersion: 1,
    scanDate: "2026-07-26",
    scope: {
        sixteenColorsCompletedYears: "1990-2026",
        sixteenColorsPendingYears: "none",
        royArchiveComplete: true,
    },
    policy: oldCheckpoint.policy,
    combinedInventorySha256,
    sixteenColors: {
        totals,
        years,
        acceptedSources,
    },
    roy: oldCheckpoint.roy,
};
const outputText = `${JSON.stringify(output, null, 2)}\n`;
const detailedReport = {
    schemaVersion: 1,
    generatedAt: new Date().toISOString(),
    scanDate: output.scanDate,
    scope: {
        years: "1990-2026",
        candidateCount: totals.candidateCount,
        acceptedSourceCount: totals.acceptedSourceCount,
        emittedScriptCount: totals.emittedScriptCount,
    },
    dispositionTotals: totals.dispositionTotals,
    visualQa: visualReview,
    candidates: detailedCandidates,
};
const detailedReportText = `${JSON.stringify(detailedReport, null, 2)}\n`;
fs.writeFileSync(detailedReportPath, detailedReportText, "utf8");
const beforeSha256 = sha256(fs.readFileSync(checkpointPath));
const afterSha256 = sha256(outputText);
const buildReport = {
    schemaVersion: 1,
    write,
    beforeSha256,
    afterSha256,
    stableInventory,
    totals,
    yearCount: years.length,
    overrideCount: overrideDispositions.size,
    matchedWorkCount: matchedWorkKeys.size,
    detailedReportPath: path
        .relative(root, detailedReportPath)
        .replaceAll("\\", "/"),
    detailedReportSha256: sha256(detailedReportText),
    visualQa: visualReview,
};
fs.writeFileSync(reportPath, `${JSON.stringify(buildReport, null, 2)}\n`);
if (write) {
    fs.writeFileSync(checkpointPath, outputText, "utf8");
}
console.log(JSON.stringify(buildReport, null, 2));
if (!write) {
    assertCheckpointCurrent(beforeSha256, afterSha256);
}
