# Rules

## Scope
- Work only on the issue named in the prompt. Read that issue once with `gh issue view <n>`.
- Smallest change that solves it. No refactors, features or files beyond the issue.
- Ask before adding any dependency.

## Code
- Swift, Apple API Design Guidelines. Logic in the core package (`Core/` or `Packages/<Name>Core/`), UI thin.
- No comments unless the why is non-obvious. No docs unless asked.
- Tests for logic changes only. Run `swift test --package-path <core package>` before pushing.
- `swift format` with `.swift-format` decides style; run `swift format -i -r` on changed files.

## Git
- Branch `<type>/<issue>-<slug>`. One PR per issue.
- PR title in Conventional Commits (`feat:`, `fix:`, `chore:`). Body: one line + `Closes #<n>`.
- Never push to `main`, merge, tag, release or edit workflows, rulesets or settings.

## GitHub
- After opening the PR, stop. Do not watch, poll or re-run CI.
- Never review PRs, browse issues, read full logs or query the API unless asked.
- When asked to fix CI: `gh run view --log-failed` for the failed job only.

## Replies
- One or two lines: what changed and the PR link.
