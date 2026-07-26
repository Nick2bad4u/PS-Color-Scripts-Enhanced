"use strict";

const IMPORTABLE_REPORT_DISPOSITIONS = Object.freeze([
    "accepted",
    "already-imported-render",
    "already-imported-source",
]);
const importableReportDispositions = new Set(
    IMPORTABLE_REPORT_DISPOSITIONS
);

function reconcileImportedDisposition(key, reportDisposition) {
    if (!importableReportDispositions.has(reportDisposition)) {
        throw new Error(
            `${key}: provenance exists for report disposition ${JSON.stringify(
                reportDisposition
            )}; expected accepted or already imported.`
        );
    }
    return "accepted";
}

function assertCheckpointCurrent(beforeSha256, afterSha256) {
    if (beforeSha256 !== afterSha256) {
        throw new Error(
            "The ANSI archive curation checkpoint is stale. Run npm run ansi:checkpoint:update after reviewing the generated report."
        );
    }
}

module.exports = {
    IMPORTABLE_REPORT_DISPOSITIONS,
    assertCheckpointCurrent,
    reconcileImportedDisposition,
};
