# Command: /release

## Syntax

```
/release [version]
```

Optional **version** — New version to release (e.g. `0.2.0`). Must be valid semver and greater than current [VERSION](VERSION). If omitted, bump patch from current VERSION (e.g. `0.1.0` → `0.1.1`).

## When to use

Run this in the **poais-core** repo when you are ready to ship. It performs the full release workflow then pushes to main.

## Behavior

1. **Read current state** — Read [VERSION](VERSION) and [CHANGELOG.md](CHANGELOG.md). If the "Unreleased" section has no real bullets (empty or only `- (none)`): inspect the working tree and staged/unstaged changes (`git status`, `git diff --name-only`, `git diff --cached --name-only`, and optionally the last commit). Add one or more concise Unreleased bullets that summarize what will be included in this release (new files, doc updates, removals, features). Then proceed. If Unreleased already has at least one bullet, use it as-is.
2. **Resolve version** — If `version` was provided, use it and ensure it is greater than current VERSION. If omitted, increment patch from current VERSION (e.g. `0.1.0` → `0.1.1`).
3. **Update CHANGELOG.md** — Replace the `## Unreleased` block (and its bullet list) with `## [X.Y.Z] - YYYY-MM-DD` using today’s date. Insert a new `## Unreleased` section immediately after the top-of-file instructions (before the new release heading), with a single placeholder bullet: `- (none)`. Preserve the rest of the file and the horizontal rules.
4. **Update VERSION** — Write the new version string as the only content of [VERSION](VERSION) (single line, no trailing newline required).
5. **Commit** — Stage all changes (`git add -A` or equivalent). Build a short one-line summary of the release from the Unreleased bullets you promoted (e.g. "Single-product scaffold, archive legacy bootstrap, update docs for product/ paths"). Commit with a two-part message:
   - First line: `Release vX.Y.Z`
   - Blank line, then the short summary line.
   Example: `Release v0.1.1` then newline then `Single-product scaffold, archive legacy bootstrap, update docs for product/ paths.`
   The release commit includes the version bump (CHANGELOG.md, VERSION) and any other modified or new tracked files, so nothing is left uncommitted and the push succeeds.
6. **Push** — Run `git push origin main` (or `git push` if main is the current branch and upstream is set). If the repo has a rule to ask before pushing to main, prompt once: “Ready to push release vX.Y.Z to main? (yes/no).” Proceed only on yes.
7. **Report** — Return the new version, the commit hash (if available), and “Pushed to main.”

## Output format

- **Version** — Released version (e.g. `0.2.0`).
- **Date** — Release date used in CHANGELOG (YYYY-MM-DD).
- **Commit** — Commit message and hash if available.
- **Push** — Confirmation that push to main completed (or that user declined).

## Guardrails

- If Unreleased has no bullets, populate it from the current working tree and changes (see step 1) so every release has a clear summary.
- Do not set a version less than or equal to the current VERSION.
- Only modify CHANGELOG.md and VERSION; no other files.
- Commit message must include both the version and a short description of the changes being released (from the Unreleased bullets).
- Stage and commit all changes (CHANGELOG.md, VERSION, and any other modified or new tracked files) in a single release commit.
- If git push fails (e.g. no upstream, auth), report the error and do not claim success.
