# Command: /setup-poais

## Syntax

```
/setup-poais
```

No arguments. The agent collects all choices via conversation.

## Purpose

Conversational, agent-driven POAIS setup. Guide the PM step by step: ask one question at a time, confirm before running anything, run the init script(s), then offer a "what's next" menu. Prefer agent executing init; only give the user a terminal command if execution is not possible (e.g. network disabled or user declines).

## Tone and behavior (hand-holding)

- Ask **one question at a time** (or a very small set). Do not dump multiple questions in one message.
- If the user's answer is ambiguous (e.g. "both", "not sure"), ask a **short follow-up** to clarify.
- **Confirm before running** any init or git command: state exactly what you will do and ask "Should I go ahead?" (or similar).
- After init succeeds, present the **"what's next" menu** and wait for the user to pick (or describe) before taking the next action.
- Resolve repo root with `git rev-parse --show-toplevel` and run all init/ git commands from that directory. If the workspace is not the repo root, tell the user to open the repo root in Cursor or run the command from there.

## Conversational flow

Follow these steps in order. Wait for the user's reply at each question or confirmation before proceeding.

### 1. Pre-check

- Run `git rev-parse --show-toplevel` from the current workspace. If it fails: say this does not appear to be a git repository; they should create one and run `/setup-poais` again.
- If it succeeds, run `git rev-parse HEAD` (or equivalent) to see if there is at least one commit. If there is no commit: say "You need at least one commit before POAIS can be added. Should I create a minimal README and make an initial commit for you?" If the user says yes, run from repo root: create a minimal README (e.g. `echo '# myproduct' > README.md` or write a one-line README), then `git add README.md` and `git commit -m "Initial commit"`. Then continue to step 2.
- If there is already a commit, go to step 2.

### 2. Layout

Ask: "Are you setting up **one product** (single workspace at `product/`) or **multiple products** (portfolio with `products/<name>/`)?" Wait for the answer. If unclear (e.g. "both", "not sure"), ask: "So that's one product, or several?"

### 3. Product names (portfolio only)

If they chose portfolio, ask: "What product names do you want? For example: widget, api. Or say **default** to use product-a and product-b." Parse their reply: either a list of names (comma- or space-separated) or "default". If unclear, ask once more for the names or "default".

### 4. POAIS repo URL

Ask: "Use the **default** poais-core repo (https://github.com/mpheyman/poais-core.git) or a **different URL**? Reply **default** or paste the URL." Use default unless they paste a different URL.

### 5. Confirm

Summarize: "I'll run POAIS init with: [single | portfolio], [product names if portfolio], [repo URL]. This will [add poais if missing and] scaffold your workspace. Ready?" Only proceed to step 6 if they confirm (yes, go ahead, etc.).

### 6. Run init

- **Resolve repo root:** Use `git rev-parse --show-toplevel`; all commands below run from that directory. If you cannot run from repo root, output the exact command for the user to run from their repo root and stop.

- **If `poais/` does not exist (first-time setup):**
  - **Mac/Linux / Git Bash:** Run from repo root: `curl -fsSL https://raw.githubusercontent.com/mpheyman/poais-core/main/tools/poais-init.sh | bash -s -- <REPO_URL>`. For portfolio, append ` --layout=portfolio <name1> <name2>` (e.g. ` --layout=portfolio product-a product-b` or the names they gave). Requires network.
  - **Windows PowerShell:** The remote one-liner only passes the repo URL (via `$env:POAIS_CORE_REPO_URL`). So: (1) Run the one-liner to add poais: `$env:POAIS_CORE_REPO_URL = '<REPO_URL>'; irm https://raw.githubusercontent.com/mpheyman/poais-core/main/tools/poais-init.ps1 | iex`. (2) If they chose portfolio, then run from repo root: `powershell -ExecutionPolicy Bypass -File poais\tools\poais-init.ps1 -Layout Portfolio -ProductNames name1,name2` (no -RepoUrl needed; lock or script will use existing poais). Requires network for step 1.
  - If the agent cannot run these (e.g. network permission denied or command failed): output the **exact** command(s) for the user to run from repo root, with their choices (URL, layout, product names) filled in for their OS. Say: "You can run /setup-poais again after this is done."

- **If `poais/` exists (re-run or re-scaffold):**
  - **Mac/Linux / Git Bash:** From repo root: `bash poais/tools/poais-init.sh <REPO_URL>` for single, or `bash poais/tools/poais-init.sh --layout=portfolio <name1> <name2>` for portfolio.
  - **Windows PowerShell:** From repo root: `powershell -ExecutionPolicy Bypass -File poais\tools\poais-init.ps1 -RepoUrl <url> -Layout Single` for single, or `-Layout Portfolio -ProductNames name1,name2` for portfolio.
  - If execution fails, output the exact command for their OS and choices; say they can run /setup-poais again after fixing.

### 7. Post-init menu

After a successful init, say setup is complete and then:

"What would you like to do first? (1) **Define your product** — I can help you fill `product/CONTEXT.md` (problem, who it's for, why now). (2) **Capture an idea** — we'll run `/capture-idea` and create a file in IDEAS/. (3) **Create meeting notes** — we'll run `/create-meeting-notes` for a live meeting. (4) **Process some input** — paste an email or doc and we'll run `/process`. (5) **Just explore** — I'll point you to GETTING_STARTED. Reply with 1–5 or describe what you want."

Wait for their reply. Then:
- 1: Open or show CONTEXT.md and offer to help fill the sections (problem, who it's for, why now, success metric, constraints).
- 2: Run `/capture-idea` (with optional product and slug if they specify).
- 3: Run `/create-meeting-notes` (with optional product and slug if they specify).
- 4: Ask them to paste the content or provide a path; then run `/process` on that input (create file in INPUTS if needed).
- 5: Give a short pointer to GETTING_STARTED.md and the main workflow (capture → process → align → status).

For portfolio, use `product` → first product (e.g. `products/<first-name>/`) in the menu text and commands where relevant.

## Output format

- Each step: short, friendly message and one question or confirmation.
- After init: success message and the numbered "what's next" menu.
- On error (e.g. init failed): clear message, the exact command they can run manually for their OS and choices, and "You can run /setup-poais again after fixing this."

## Guardrails

- Do not run init or git commands without explicit user confirmation after summarizing choices.
- If the user says they're on Windows, use the PowerShell init form when generating or running the command.
- If execution fails (network, permission, script error), provide the exact command for their OS and choices; do not ask them to read the README for setup.
- If the workspace is not the git repo root, either run from repo root if you can resolve it, or give the user the exact command to run from repo root.
