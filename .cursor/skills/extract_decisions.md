# Skill: Extract Decisions

## Purpose

Create properly formatted entries for DECISIONS.md from raw text or from a summarize_input output. Ensures consistent format and clear separation of explicit vs implied decisions.

## Inputs

- List of decision candidates (explicit and/or implied) from a prior step, or raw text.
- Optional: source reference (file, meeting, date).

## Output format

For each decision, output one block in this form:

- **Date** — YYYY-MM-DD (or “Date: TBD” if unknown)
- **Decision** — one clear sentence
- **Context** — why it was needed (1–3 sentences)
- **Aligned With** — who agreed or was consulted (or “Needs confirmation”)
- **Impact** — what is affected (products, teams, systems)

Differentiate in the output:
- **Explicit** — stated clearly in source; can be appended to DECISIONS.md as-is after PM review.
- **Implied** — inferred; must be marked “Needs confirmation” and not appended until confirmed.

## Steps

1. For each decision candidate, classify as explicit or implied.
2. Format each using the five fields above.
3. For implied decisions, set “Aligned With” (or a note) to “Needs confirmation”.
4. Never fabricate “Aligned With” or dates; use “TBD” or “Needs confirmation” if missing.
5. Output the list of formatted entries (and which are explicit vs implied).

## Guardrails

- **Never fabricate alignment** — if who agreed is unknown, say so.
- **Differentiate explicit vs implied** — only explicit, confirmed decisions belong in DECISIONS.md without a “Needs confirmation” flag.
- Do not duplicate an existing DECISIONS entry; check before adding.
