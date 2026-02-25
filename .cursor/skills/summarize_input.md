# Skill: Summarize Input

## Purpose

Extract high-signal structure from messy text (chat, email, docs, pasted notes) so it can be turned into POAIS artifacts without losing important decisions, risks, or scope changes.

## Inputs

- Raw text (file path or pasted content): meeting notes, email thread, doc excerpt, chat log.

## Output format

Produce a structured summary with:

1. **High-signal summary** — 5–10 bullets capturing the main points.
2. **Explicit decisions** — decisions clearly stated in the source (quote or paraphrase + source ref).
3. **Implied decisions** — decisions that seem intended but not clearly stated; **flag each as “Needs confirmation”.**
4. **Risks** — stated or implied risks.
5. **Scope changes** — any change to what’s in/out of scope.
6. **Feature ideas** — concrete ideas worth capturing.
7. **Open questions** — unresolved questions or unknowns.

## Steps

1. Read the full input. If the input is explicitly noted as a portion of a larger file (e.g. an unprocessed chunk from a running input file), treat it as standalone for extraction; do not assume context from other parts of the file.
2. Extract bullets for the high-signal summary.
3. List explicit decisions with a short source reference.
4. List implied decisions and mark every one as “Needs confirmation”.
5. List risks, scope changes, feature ideas, and open questions.
6. Do not add information that is not present or clearly implied in the source.

## Guardrails

- Do not invent decisions or alignment.
- If something is ambiguous, mark it “Needs confirmation”.
- Keep source references (file name, section, or “user-provided”) where helpful.
