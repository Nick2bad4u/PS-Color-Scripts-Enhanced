import sharedConfig from "prettier-config-nick2bad4u";

/** @type {import("prettier").Config} */
const prettierConfig = {
    ...sharedConfig,
    overrides: [
        ...(sharedConfig.overrides ?? []),
        {
            files: "**/*.{ps1,psd1,psm1}",
            options: {
                plugins: ["prettier-plugin-powershell"],
                powershellBlankLineAfterParam: true,
                powershellBlankLinesBetweenFunctions: 1,
                powershellBraceStyle: "1tbs",
                powershellIndentSize: 4,
                powershellIndentStyle: "spaces",
                powershellKeywordCase: "preserve",
                powershellLineWidth: 120,
                powershellPreferSingleQuote: false,
                powershellPreset: "invoke-formatter",
                powershellRewriteWriteHost: false,
                powershellTrailingComma: "none",
            },
        },
        {
            files: ["**/package.json", "**/package-lock.json"],
            options: {
                requirePragma: true,
            },
        },
    ],
};

export default prettierConfig;
