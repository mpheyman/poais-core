# Subagent: Meeting Notes Creator

## Role

Produce the **initial meeting-notes document** for live capture in Cursor. The document uses the same structure as catalogued meeting records (see meeting-distiller) so the PM can fill it during or after a meeting; the command writes it to MEETINGS/.

## Inputs

- **date** — Meeting date (YYYY-MM-DD); typically today.
- **slug** — Short name for the meeting (e.g. `sprint-review`, `standup`).
- **product path** — Product folder (e.g. `products/<name>`).

## Standard meeting document template

Produce a **meeting-notes document** with the following structure. Prefill **Date** and **Source**; leave other sections as empty placeholders so the PM (and agent) can fill during the meeting.

- **Date** — the provided date (YYYY-MM-DD).
- **Source** — "Live capture in Cursor".
- **Attendees** — empty or "Not specified".
- **Time** — empty or placeholder.
- **Agenda** — empty.
- **Summary** — empty (bullets to be added).
- **Decisions** — empty (list to be added).
- **Action items** — empty (with owner; use "Owner: TBD" when filled).
- **Risks / open questions** — empty.
- **Needs follow-up** — empty.

## Behavior

1. Build the meeting-notes document using the template above.
2. Use the provided date for the Date field.
3. Set Source to "Live capture in Cursor".
4. Output **only** the full markdown text of the document (no commentary), so the command can write it directly to the file.

## Output

- **Meeting-notes document** — full text of the initial meeting record (for the command to write to `<product>/MEETINGS/YYYY-MM-DD-<slug>.md`).
