# OpenSSF Best Practices: passing-level answers

Answers to paste into the [bestpractices.dev](https://www.bestpractices.dev) form for this project. `R` is `https://github.com/minegene-labs/reelmark`. Items marked **Maintainer** are statements only the maintainer can make or check.

## Basics

| Criterion | Answer | Justification |
|---|---|---|
| description_good | Met | R#readme: the first lines say what the app does. |
| interact | Met | README links Releases, Issues and Discussions; CONTRIBUTING.md says how to report bugs and suggest features. |
| contribution | Met | R/blob/main/CONTRIBUTING.md (Workflow): pull requests on GitHub. |
| contribution_requirements | Met | CONTRIBUTING.md: commit message style, tests with each change, privacy rules, `swift format`. |
| floss_license | Met | MIT. |
| floss_license_osi | Met | MIT is OSI-approved. |
| license_location | Met | R/blob/main/LICENSE |
| documentation_basics | Met | README: requirements, install, use, privacy, verifying a release. |
| documentation_interface | N/A | A desktop app with no external API; its interface is documented in the README. |
| sites_https | Met | Everything is on github.com over HTTPS. |
| discussion | Met | GitHub Issues and Discussions: searchable, addressable by URL, no proprietary client needed. |
| english | Met | All docs and discussion are in English. |
| maintained | Met | Releases and merged pull requests in the last months. |

## Change control

| Criterion | Answer | Justification |
|---|---|---|
| repo_public | Met | R |
| repo_track | Met | Git records who changed what and when. |
| repo_interim | Met | Every change lands on `main` through a pull request, between releases. |
| repo_distributed | Met | Git. |
| version_unique | Met | Each release has its own version (`version.txt`, tags `vX.Y.Z`). |
| version_semver | Met | Semantic Versioning, see CONTRIBUTING.md. |
| version_tags | Met | Every release is tagged `vX.Y.Z`. |
| release_notes | Met | R/blob/main/CHANGELOG.md and each GitHub release's notes. |
| release_notes_vulns | Met | SECURITY.md: release notes name each fixed vulnerability and its CVE. (No vulnerabilities fixed so far.) |

## Reporting

| Criterion | Answer | Justification |
|---|---|---|
| report_process | Met | Issues with bug and feature forms; SUPPORT.md. |
| report_tracker | Met | GitHub Issues. |
| report_responses | Met | **Maintainer**: confirm most bug reports in the last 2–12 months were answered. CONTRIBUTING.md aims for a reply within a week. |
| enhancement_responses | Met | **Maintainer**: as above, for feature requests. |
| report_archive | Met | R/issues (public and searchable). |
| vulnerability_report_process | Met | R/blob/main/SECURITY.md |
| vulnerability_report_private | Met | GitHub private vulnerability reporting (turned on), see SECURITY.md. |
| vulnerability_report_response | Met | SECURITY.md commits to a first reply within 14 days. No reports so far. |

## Quality

| Criterion | Answer | Justification |
|---|---|---|
| build | Met | `xcodebuild` with the shared scheme, see CONTRIBUTING.md (Building locally). |
| build_common_tools | Met | Xcode / `xcodebuild` and Swift Package Manager. |
| build_floss_tools | Unmet | Building a macOS app needs Xcode, which isn't open source. The core package (`Packages/FilmfoldCore`) builds and tests with the open-source Swift toolchain. |
| test | Met | XCTest suites in `Packages/FilmfoldCore/Tests` and `FilmfoldUITests`, run as in CONTRIBUTING.md. |
| test_invocation | Met | `swift test` and `xcodebuild test`, the standard commands. |
| test_most | Met | The naming, parsing, search and file logic lives in the core package and is unit tested; the UI tests cover every list command. |
| test_continuous_integration | Met | `.github/workflows/ci.yml` runs the core tests and builds the app on every pull request. |
| test_policy | Met | CONTRIBUTING.md (From idea to release, Code): changes come with tests. |
| tests_are_added | Met | Recent feature pull requests added tests, for example the Quick Look UI test in [minegene-labs/reelmark#88](https://github.com/minegene-labs/reelmark/pull/88). |
| tests_documented_added | Met | CONTRIBUTING.md (From idea to release, Code). |
| warnings | Met | Swift 6 with complete strict concurrency checking, and `swift format lint --strict` in CI. |
| warnings_fixed | Met | **Maintainer**: confirm CI builds are free of warnings. |
| warnings_strict | Met | Strict concurrency is set to `complete`, the strictest level. |

## Security

| Criterion | Answer | Justification |
|---|---|---|
| know_secure_design | Met | **Maintainer** statement. The rules in CONTRIBUTING.md (sandbox, fixed entitlements, one web address, Keychain, no third-party code) apply least privilege and keep the attack surface small. |
| know_common_errors | Met | **Maintainer** statement. Swift is memory safe; the sandbox limits file access to what the user chose. |
| crypto_published | N/A | The app uses no cryptography of its own; HTTPS comes from macOS (URLSession). |
| crypto_call | N/A | As above. |
| crypto_floss | N/A | As above. |
| crypto_keylength | N/A | As above. |
| crypto_working | N/A | As above. |
| crypto_weaknesses | N/A | As above. |
| crypto_pfs | N/A | As above. |
| crypto_password_storage | N/A | No passwords are stored. A user's own TMDB token goes in the macOS Keychain. |
| crypto_random | N/A | No keys or nonces are generated. |
| delivery_mitm | Met | Releases are downloaded from GitHub over HTTPS, with a SHA-256 checksum and a signed GitHub build attestation (README, Verify a release). |
| delivery_unsigned | Met | The checksum is published with the release over HTTPS, and `gh attestation verify` checks the signed build record. |
| vulnerabilities_fixed_60_days | Met | No known unpatched vulnerabilities. SECURITY.md commits to fixes within 60 days. |
| vulnerabilities_critical_fixed | Met | As above. |
| no_leaked_credentials | Met | No private credentials in the repository. The built-in TMDB token is a read-only key for a public API, public on purpose (README, Privacy). Secrets for releases are GitHub Actions secrets. |

## Analysis

| Criterion | Answer | Justification |
|---|---|---|
| static_analysis | Met once CodeQL is on | Not met yet: the shared CI has no CodeQL. **Maintainer**: turn on Settings › Code security › CodeQL analysis › Set up › Default (Swift is supported), then answer Met: "CodeQL default setup scans every pull request and `main`." |
| static_analysis_common_vulnerabilities | Met once CodeQL is on | CodeQL's security queries. |
| static_analysis_fixed | Met once CodeQL is on | **Maintainer**: fix any medium or higher alerts from the first scan (Security › Code scanning). |
| static_analysis_often | Met once CodeQL is on | Default setup scans every pull request and push to `main`. |
| dynamic_analysis | Unmet | Suggested only. The UI tests run the real app, but only on a Mac, not in CI. |
| dynamic_analysis_unsafe | N/A | Written only in Swift, which is memory safe; no C or C++. |
| dynamic_analysis_enable_assertions | Unmet | Suggested only, as above. |
| dynamic_analysis_fixed | N/A | No dynamic analysis findings. |

After the project is registered and passes, add the badge to the top of README.md.
