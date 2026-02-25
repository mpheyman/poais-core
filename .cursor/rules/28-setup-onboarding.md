# Setup and onboarding

- If the user does **not** have POAIS in the repo yet (no `poais/` directory), direct them to the [README setup instructions](README.md#setup) to run the CLI first (create project folder, make a commit, run the init one-liner). After that they can open the repo in Cursor and run **`/setup-poais`** for the guided menu.
- When the user **already has** `poais/` and wants to **set up POAIS**, **initialize their repo**, **onboard**, or **get started**, use the **`/setup-poais` command** and guide them **conversationally**.
- Setup is always **portfolio** layout (products under `products/<name>/`, `portfolio/` for roll-up). Do not offer a single-product option.
- When guiding via `/setup-poais`, keep the flow **agent-driven**: one question at a time, prompt for clarification when needed, confirm before running init, and lead them through the post-setup menu.
