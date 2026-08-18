<!-- markdownlint-disable -->
<!-- eslint-disable markdown/no-missing-label-refs -->

# 📜 Changelog

## ✨ What's Changed in v2026.8.17.1627

- <b>Commit Range: ➡️</b> [`v2026.8...v2026.8`](https://github.com/Nick2bad4u/PS-Color-Scripts-Enhanced/compare/v2026.8.4.412...v2026.8.17.1627 "View full commit range on GitHub")

### 🛠️ Bug Fixes

- [`82fc7a2`](https://github.com/Nick2bad4u/PS-Color-Scripts-Enhanced/commit/82fc7a2368039a00d03f666dfdb3fbbd2ea1e3fb "Diff: 2 files, +40 | -5") — 📝 [fix] Exclude release prep from published notes <sub><em>(2 files, +40, -5)</em></sub>

Build GitHub release notes with the same validated preparation-commit filter used by the checked-in changelog.

Resolve the previous release tag safely, validate candidate hashes before passing them to git-cliff, and cover the workflow contract with a focused Pester assertion.

- [`9a47345`](https://github.com/Nick2bad4u/PS-Color-Scripts-Enhanced/commit/9a4734588e8b4000361a10033450e194c3327815 "Diff: 5 files, +49 | -10") — 🔗 [fix] Repair packaged documentation links <sub><em>(5 files, +49, -10)</em></sub>

Rewrite references to repository-only provenance files and third-party notices as absolute GitHub links when producing the packaged README.

Point the packaged artwork guide at the hosted gallery, keep the mirrored guide synchronized, correct the rights-boundary wording, and add regression coverage for every rewritten link.

- [`39c1e77`](https://github.com/Nick2bad4u/PS-Color-Scripts-Enhanced/commit/39c1e77a566b7542428232ebd698974227f3a51d "Diff: 2 files, +9 | -3") — Simplify rebalance invariant validation <sub><em>(2 files, +9, -3)</em></sub>

- [`0eb3899`](https://github.com/Nick2bad4u/PS-Color-Scripts-Enhanced/commit/0eb3899291442b70dfd58f9573a83a14f881dd63 "Diff: 5 files, +24 | -24") — Satisfy strict PowerShell analysis <sub><em>(5 files, +24, -24)</em></sub>

- [`6035a8b`](https://github.com/Nick2bad4u/PS-Color-Scripts-Enhanced/commit/6035a8bfdb1e64cb6b88b45d28392098bc991d5a "Diff: 3 files, +9 | -5") — Resolve residual Sonar JavaScript findings <sub><em>(3 files, +9, -5)</em></sub>

- [`c4865a1`](https://github.com/Nick2bad4u/PS-Color-Scripts-Enhanced/commit/c4865a115b95e14c6045d181aa3ca6fe8c0421c2 "Diff: 1 file, +5 | -5") — Keep installer compatible with Windows PowerShell <sub><em>(1 file, +5, -5)</em></sub>

- [`86e0385`](https://github.com/Nick2bad4u/PS-Color-Scripts-Enhanced/commit/86e03855d56ae4f268b6e2fe9343b495cad168ca "Diff: 3 files, +21 | -20") — Resolve Sonar JavaScript findings <sub><em>(3 files, +21, -20)</em></sub>

- [`3c9c7a2`](https://github.com/Nick2bad4u/PS-Color-Scripts-Enhanced/commit/3c9c7a2f83af3db985944e944736c336043a31e3 "Diff: 1 file, +33 | -12") — Harden provenance assignment parsing <sub><em>(1 file, +33, -12)</em></sub>

- [`3ceadbe`](https://github.com/Nick2bad4u/PS-Color-Scripts-Enhanced/commit/3ceadbe2002b9582bd6377ceeb7219770014f053 "Diff: 2 files, +29 | -2") — 🛠️ [fix] Repair 16colors provenance validation <sub><em>(2 files, +29, -2)</em></sub>

Align the authoritative artwork provenance record with the renamed packaged permission notice so Pester and the generated web index resolve the same license evidence path.

Restore the complete project-specific permission scope and remove the incorrect suggestion that fair use can grant permission.

- [`5c8efd0`](https://github.com/Nick2bad4u/PS-Color-Scripts-Enhanced/commit/5c8efd0e482faa4b190a592a9cd4efb88a79d56f "Diff: 7 files, +28 | -55") — 🛠️ [fix] Resolve issues with code changes <sub><em>(7 files, +28, -55)</em></sub>

- Fixed multiple instances of unused variables that were causing warnings during compilation.

- Corrected the logic in the main processing function to ensure accurate data handling.

- Updated the configuration settings to reflect the latest environment variables.

- Removed deprecated methods that were no longer in use to streamline the codebase.

- Enhanced error handling to provide more informative messages during runtime failures.

### 🚜 Refactor

- [`73ea6b0`](https://github.com/Nick2bad4u/PS-Color-Scripts-Enhanced/commit/73ea6b0f677bdbbb75270e7da73ebd276cc829d3 "Diff: 1 file, +22 | -11") — Separate completed cache worker handling <sub><em>(1 file, +22, -11)</em></sub>

- [`06fa7c1`](https://github.com/Nick2bad4u/PS-Color-Scripts-Enhanced/commit/06fa7c1367ff2b9008d9730607198f31d5fd972f "Diff: 1 file, +48 | -25") — Reduce cache target selection complexity <sub><em>(1 file, +48, -25)</em></sub>

- [`ee15abb`](https://github.com/Nick2bad4u/PS-Color-Scripts-Enhanced/commit/ee15abb092c3c9eef9951e86bfd72dfd21c2b217 "Diff: 1 file, +536 | -754") — Separate cache build orchestration <sub><em>(1 file, +536, -754)</em></sub>

- [`672c398`](https://github.com/Nick2bad4u/PS-Color-Scripts-Enhanced/commit/672c3989dc72722abd725e5c85201fecca3903b1 "Diff: 1 file, +452 | -404") — Separate cache clear stages <sub><em>(1 file, +452, -404)</em></sub>

- [`2fd6bf9`](https://github.com/Nick2bad4u/PS-Color-Scripts-Enhanced/commit/2fd6bf9d943000ca3cc2347ff86e5649611eb465 "Diff: 1 file, +389 | -292") — Separate profile configuration stages <sub><em>(1 file, +389, -292)</em></sub>

- [`dc72ecd`](https://github.com/Nick2bad4u/PS-Color-Scripts-Enhanced/commit/dc72ecdfb87c65b55511ade689025885904baef8 "Diff: 1 file, +158 | -137") — Separate colorscript list completion <sub><em>(1 file, +158, -137)</em></sub>

- [`29e541f`](https://github.com/Nick2bad4u/PS-Color-Scripts-Enhanced/commit/29e541fac69953d9fd501e8d35fc390027eafc25 "Diff: 2 files, +91 | -36") — Reduce residual initialization complexity <sub><em>(2 files, +91, -36)</em></sub>

- [`d353178`](https://github.com/Nick2bad4u/PS-Color-Scripts-Enhanced/commit/d353178e3bd1a9d58dcd69e61c1f16b2580b7e06 "Diff: 1 file, +557 | -423") — Separate metadata table stages <sub><em>(1 file, +557, -423)</em></sub>

- [`18d9444`](https://github.com/Nick2bad4u/PS-Color-Scripts-Enhanced/commit/18d9444d990666f57f71278fd4844e6643b7b442 "Diff: 1 file, +399 | -264") — Separate localization initialization <sub><em>(1 file, +399, -264)</em></sub>

- [`4f15b99`](https://github.com/Nick2bad4u/PS-Color-Scripts-Enhanced/commit/4f15b999d86ae45afadefd3b236987600a186c53 "Diff: 1 file, +355 | -312") — Separate cached output validation <sub><em>(1 file, +355, -312)</em></sub>

- [`0db4d73`](https://github.com/Nick2bad4u/PS-Color-Scripts-Enhanced/commit/0db4d733b06d9c905c6cfcabd7edcaca4018fa23 "Diff: 1 file, +482 | -235") — Separate static colorscript evaluation <sub><em>(1 file, +482, -235)</em></sub>

- [`75eb435`](https://github.com/Nick2bad4u/PS-Color-Scripts-Enhanced/commit/75eb435ed937bd96ae5efdb6dac578f82ab4671f "Diff: 2 files, +381 | -292") — Separate cache initialization stages <sub><em>(2 files, +381, -292)</em></sub>

- [`da87d0a`](https://github.com/Nick2bad4u/PS-Color-Scripts-Enhanced/commit/da87d0a879b4c6350c453b493eae3199527a2d05 "Diff: 4 files, +608 | -369") — Simplify configuration and localization <sub><em>(4 files, +608, -369)</em></sub>

- [`a56403a`](https://github.com/Nick2bad4u/PS-Color-Scripts-Enhanced/commit/a56403aec1272030547ad171a72d309fb49171a3 "Diff: 4 files, +672 | -386") — Simplify PowerShell repository tooling <sub><em>(4 files, +672, -386)</em></sub>

- [`ce1b504`](https://github.com/Nick2bad4u/PS-Color-Scripts-Enhanced/commit/ce1b5045445a0a9e0b9673f6b5dfdbf5b47bc692 "Diff: 2 files, +291 | -169") — Simplify metadata and scaffold cmdlets <sub><em>(2 files, +291, -169)</em></sub>

- [`51ea553`](https://github.com/Nick2bad4u/PS-Color-Scripts-Enhanced/commit/51ea5538789978b86248bbba2692ddfd3e4117df "Diff: 6 files, +648 | -409") — Simplify PowerShell support functions <sub><em>(6 files, +648, -409)</em></sub>

- [`ef78f45`](https://github.com/Nick2bad4u/PS-Color-Scripts-Enhanced/commit/ef78f45efb7b1e2dbbf1f066fdcee855a0d7de8d "Diff: 1 file, +258 | -212") — Separate rebalance plan verification <sub><em>(1 file, +258, -212)</em></sub>

- [`a7d6b2f`](https://github.com/Nick2bad4u/PS-Color-Scripts-Enhanced/commit/a7d6b2ff76701c82c8465e73038280f48609ded0 "Diff: 1 file, +267 | -232") — Separate rebalance manifest construction <sub><em>(1 file, +267, -232)</em></sub>

- [`1708d22`](https://github.com/Nick2bad4u/PS-Color-Scripts-Enhanced/commit/1708d22bc3fbebe19419fb4998d709d9539677d0 "Diff: 1 file, +195 | -151") — Separate rebalance manifest validation <sub><em>(1 file, +195, -151)</em></sub>

- [`c683ba4`](https://github.com/Nick2bad4u/PS-Color-Scripts-Enhanced/commit/c683ba49d665761719e5c6ad8107909cb28c4164 "Diff: 1 file, +115 | -64") — Separate rebalancer transactions <sub><em>(1 file, +115, -64)</em></sub>

- [`c19c233`](https://github.com/Nick2bad4u/PS-Color-Scripts-Enhanced/commit/c19c233dbb30a194a57dd6cc128b3c8c524efd48 "Diff: 1 file, +187 | -105") — Separate fixed-part optimization <sub><em>(1 file, +187, -105)</em></sub>

- [`8546d96`](https://github.com/Nick2bad4u/PS-Color-Scripts-Enhanced/commit/8546d96fa6a1dcc2c835776af54a20bf8494c0f7 "Diff: 1 file, +269 | -202") — Separate split family diagnostics <sub><em>(1 file, +269, -202)</em></sub>

- [`ba46233`](https://github.com/Nick2bad4u/PS-Color-Scripts-Enhanced/commit/ba462338597f1c40d115a436a1ed9134fa4630d0 "Diff: 1 file, +182 | -140") — Separate gallery review signals <sub><em>(1 file, +182, -140)</em></sub>

- [`0d80adc`](https://github.com/Nick2bad4u/PS-Color-Scripts-Enhanced/commit/0d80adc13909731deed3ffe62ffcd5be0583de7a "Diff: 1 file, +175 | -107") — Separate terminal preview rendering <sub><em>(1 file, +175, -107)</em></sub>

- [`4e72305`](https://github.com/Nick2bad4u/PS-Color-Scripts-Enhanced/commit/4e7230538952ba5faf364cc7d088f2fee8eef6f0 "Diff: 1 file, +192 | -114") — Separate archive candidate analysis <sub><em>(1 file, +192, -114)</em></sub>

- [`5265f8a`](https://github.com/Nick2bad4u/PS-Color-Scripts-Enhanced/commit/5265f8afed9a63fa1af14a0a33ac7762ee11b8e1 "Diff: 1 file, +86 | -63") — Separate existing render indexing <sub><em>(1 file, +86, -63)</em></sub>

- [`cad0c85`](https://github.com/Nick2bad4u/PS-Color-Scripts-Enhanced/commit/cad0c858e228bfddc2cd87cd901f105d25bd41db "Diff: 1 file, +271 | -156") — Separate provenance migration stages <sub><em>(1 file, +271, -156)</em></sub>

- [`cefcf01`](https://github.com/Nick2bad4u/PS-Color-Scripts-Enhanced/commit/cefcf01ea5fdcfc4d9130627e12abc14eb8c8708 "Diff: 1 file, +149 | -66") — Separate balanced split optimization <sub><em>(1 file, +149, -66)</em></sub>

- [`2760c7a`](https://github.com/Nick2bad4u/PS-Color-Scripts-Enhanced/commit/2760c7a6003613369c0ba9d785dda464e98ca05a "Diff: 1 file, +463 | -356") — Separate converter output workflows <sub><em>(1 file, +463, -356)</em></sub>

- [`65d2cfc`](https://github.com/Nick2bad4u/PS-Color-Scripts-Enhanced/commit/65d2cfce27cc8d67c3888d562795d2bedd0d2d95 "Diff: 1 file, +207 | -125") — Separate converter option parsing <sub><em>(1 file, +207, -125)</em></sub>

- [`865b536`](https://github.com/Nick2bad4u/PS-Color-Scripts-Enhanced/commit/865b53668bd20cb98125597d933f194e5669acc2 "Diff: 1 file, +111 | -64") — Separate terminal row serialization <sub><em>(1 file, +111, -64)</em></sub>

- [`64e081d`](https://github.com/Nick2bad4u/PS-Color-Scripts-Enhanced/commit/64e081d9312b3a14996044069c0796e22455d184 "Diff: 1 file, +111 | -128") — Separate terminal SGR handling <sub><em>(1 file, +111, -128)</em></sub>

- [`1ffbf23`](https://github.com/Nick2bad4u/PS-Color-Scripts-Enhanced/commit/1ffbf23ee1ad1f732bda2805536735ac3b24707c "Diff: 1 file, +115 | -98") — Separate terminal CSI handling <sub><em>(1 file, +115, -98)</em></sub>

- [`abafd36`](https://github.com/Nick2bad4u/PS-Color-Scripts-Enhanced/commit/abafd36eaaa4982e179733122a61874cc358a697 "Diff: 1 file, +186 | -123") — Separate content audit orchestration <sub><em>(1 file, +186, -123)</em></sub>

- [`bed9da7`](https://github.com/Nick2bad4u/PS-Color-Scripts-Enhanced/commit/bed9da78865a11fe7b2bc3ec316bc5871e8e6b13 "Diff: 1 file, +165 | -103") — Separate 16colors archive caching <sub><em>(1 file, +165, -103)</em></sub>

- [`3425dfe`](https://github.com/Nick2bad4u/PS-Color-Scripts-Enhanced/commit/3425dfe8a9c95ef21692a3c332c34e78890e4981 "Diff: 1 file, +139 | -136") — Separate archive deduplication stages <sub><em>(1 file, +139, -136)</em></sub>

- [`63e2103`](https://github.com/Nick2bad4u/PS-Color-Scripts-Enhanced/commit/63e2103825e51e74bb96c1d1754510d1d1282662 "Diff: 1 file, +99 | -53") — Simplify colorscript analysis loading <sub><em>(1 file, +99, -53)</em></sub>

- [`729bcf6`](https://github.com/Nick2bad4u/PS-Color-Scripts-Enhanced/commit/729bcf6d6ebbaa47b81f9066c75ae2672964235c "Diff: 1 file, +145 | -104") — Separate ANSI metric collection <sub><em>(1 file, +145, -104)</em></sub>

- [`3851e36`](https://github.com/Nick2bad4u/PS-Color-Scripts-Enhanced/commit/3851e36e78300ebc29a75d51e8598067c3479200 "Diff: 1 file, +46 | -22") — Simplify analysis exception matching <sub><em>(1 file, +46, -22)</em></sub>

- [`682fbb3`](https://github.com/Nick2bad4u/PS-Color-Scripts-Enhanced/commit/682fbb38a20e40fe4890537e18306bcc2db1c48a "Diff: 1 file, +505 | -380") — Separate ANSI splitter orchestration <sub><em>(1 file, +505, -380)</em></sub>

- [`95d09da`](https://github.com/Nick2bad4u/PS-Color-Scripts-Enhanced/commit/95d09da578d31b389d703c3448872899b2f9c818 "Diff: 2 files, +288 | -204") — Simplify review manifest generation <sub><em>(2 files, +288, -204)</em></sub>

- [`3c21273`](https://github.com/Nick2bad4u/PS-Color-Scripts-Enhanced/commit/3c21273fc5507a309255694e00a08e00fa6dedc0 "Diff: 1 file, +225 | -154") — Isolate reviewed content redaction <sub><em>(1 file, +225, -154)</em></sub>

- [`82877b3`](https://github.com/Nick2bad4u/PS-Color-Scripts-Enhanced/commit/82877b3883906c72f790988077cb068dd3620d25 "Diff: 1 file, +312 | -242") — Separate content-review curation stages <sub><em>(1 file, +312, -242)</em></sub>

- [`5db2b1c`](https://github.com/Nick2bad4u/PS-Color-Scripts-Enhanced/commit/5db2b1c0e2fba5bb089a3d5d77f5f8bd0e47dd80 "Diff: 3 files, +187 | -162") — Simplify artwork review validation <sub><em>(3 files, +187, -162)</em></sub>

- [`ba34769`](https://github.com/Nick2bad4u/PS-Color-Scripts-Enhanced/commit/ba347696ebccc3b0ac5fd3df49866503c6e7893d "Diff: 3 files, +456 | -302") — Separate ANSI audit responsibilities <sub><em>(3 files, +456, -302)</em></sub>

- [`e28f0ae`](https://github.com/Nick2bad4u/PS-Color-Scripts-Enhanced/commit/e28f0ae00cb639e6b159cf7936390ee2edf6c7cd "Diff: 3 files, +289 | -169") — Simplify ANSI CLI argument parsing <sub><em>(3 files, +289, -169)</em></sub>

- [`8e4c7cc`](https://github.com/Nick2bad4u/PS-Color-Scripts-Enhanced/commit/8e4c7cc8595e0d9ef63ebd3db4e18e6b5a45dc3a "Diff: 14 files, +561 | -337") — Simplify PowerShell support paths <sub><em>(14 files, +561, -337)</em></sub>

- [`99983b9`](https://github.com/Nick2bad4u/PS-Color-Scripts-Enhanced/commit/99983b9e1806697811d3ae4b1d4d934044f62a1a "Diff: 9 files, +878 | -565") — Reduce ANSI tooling complexity <sub><em>(9 files, +878, -565)</em></sub>

- [`fd49a50`](https://github.com/Nick2bad4u/PS-Color-Scripts-Enhanced/commit/fd49a50c337dc255225a79b47628fdeb61a37a04 "Diff: 12 files, +257 | -167") — Resolve Sonar maintainability findings <sub><em>(12 files, +257, -167)</em></sub>

### 📝 Documentation

- [`d69df92`](https://github.com/Nick2bad4u/PS-Color-Scripts-Enhanced/commit/d69df92ced4ff2310a81c95cedf78e5350fa493f "Diff: 5 files, +107 | -35") — 📝 [docs] Update publishing and release checklist documentation <sub><em>(5 files, +107, -35)</em></sub>

- Clarify that NuGet.org uses OIDC trusted publishing in the Publishing Guide.

- Modify the description of the publishing process to reflect the new trusted publishing workflow.

- Remove references to `NUGETAPIKEY` from the required secrets section, emphasizing that it is no longer needed.

- Add details about the NuGet.org trusted publishing policy requirements.

- Update the Release Checklist to specify the repository secret name and the trusted publishing policy targets.

### 🧹 Chores

- [`83974d1`](https://github.com/Nick2bad4u/PS-Color-Scripts-Enhanced/commit/83974d16f1ed1d7a6b3adf71343a5b6d55f3afc1 "Diff: 2 files, +25 | -1") — 🧹 [chore] Prepare release 2026.8.17.1627 <sub><em>(2 files, +25, -1)</em></sub>

Refresh the candidate changelog and PowerShell Gallery release notes after the exact-SHA Sonar corrections.

Keep both user-facing fixes in the release range while excluding mechanical preparation commits from generated notes.

- [`7b6f292`](https://github.com/Nick2bad4u/PS-Color-Scripts-Enhanced/commit/7b6f292de05e6799e553314cab90b6d5794d4349 "Diff: 10 files, +1997 | -1690") — 🧹 [chore] Prepare release 2026.8.17.1627 <sub><em>(10 files, +1997, -1690)</em></sub>

Bump the module manifest to the patch CalVer release candidate and synchronize versioned documentation mirrors.

Regenerate the changelog and distributable release notes from the complete commit range since v2026.8.4.412.

### 🛡️ Security

- [`7fa6de8`](https://github.com/Nick2bad4u/PS-Color-Scripts-Enhanced/commit/7fa6de8c02f84382dc567056ea8c572c95686f05 "Diff: 2 files, +11 | -2") — 🔒 [fix] Prevent insecure artwork links <sub><em>(2 files, +11, -2)</em></sub>

Keep historical HTTP-only SAUCE strings visible as provenance text without promoting them to clickable external links.

Add a focused regression requiring the artwork details page to remain free of insecure origins while retaining its explicit HTTPS allowlist.

- [`c93b395`](https://github.com/Nick2bad4u/PS-Color-Scripts-Enhanced/commit/c93b3959d890aa2fd57c5937e748786ac9805728 "Diff: 4 files, +30 | -6") — 🔒 [fix] Harden release security checks <sub><em>(4 files, +30, -6)</em></sub>

🔒 Restrict rendered artwork links to the provenance archive's explicit trusted origins.

🛡️ Deny default workflow token permissions for the Pages deployment while preserving its job-scoped grants.

🧪 Make the DOS newline fixture replace every line feed so static analysis sees the complete transformation.

📦 Refresh the lockfile to nanoid 3.3.18 and remove the actionable high-severity development dependency advisory.

- [`2ae28c0`](https://github.com/Nick2bad4u/PS-Color-Scripts-Enhanced/commit/2ae28c059b0e38a5d962943ce308dead6d4fce30 "Diff: 24 files, +508 | -388") — Resolve Sonar correctness and security findings <sub><em>(24 files, +508, -388)</em></sub>

> [!NOTE]
> **Release comparison**: https://github.com/Nick2bad4u/PS-Color-Scripts-Enhanced/compare/v2026.8.4.412...v2026.8.17.1627

## ⭐ Contributors

Thanks to anyone who has 🧑‍💻 [contributed](https://github.com/Nick2bad4u/PS-Color-Scripts-Enhanced/graphs/contributors).

_This changelog was automatically generated with ⛰️ [git-cliff](https://github.com/orhun/git-cliff)._
