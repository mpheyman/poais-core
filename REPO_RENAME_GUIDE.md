# Renaming the repo to poais-core

Use this guide to rename the existing GitHub repo to `poais-core`, or to point the repo at a new remote.

## Option A: Rename the existing repo on GitHub

1. Open the repo on GitHub.
2. Go to **Settings**.
3. Under **General**, find **Repository name**.
4. Change the name to `poais-core` and click **Rename**.

GitHub will redirect the old URL to the new one. Update your local clone so `origin` points to the new URL:

```bash
git remote -v
git remote set-url origin https://github.com/YOUR_ORG/poais-core.git
```

(Use the URL GitHub shows for the renamed repo; it may use `https` or `git@`.)

## Option B: Create a new repo and push there

If you create a **new** repo (e.g. `poais-core`) instead of renaming:

1. Create the new repo on GitHub (empty, no README).
2. In your local poais repo:

```bash
git remote rename origin old-origin
git remote add origin https://github.com/YOUR_ORG/poais-core.git
git push -u origin main
```

3. Optional: remove the old remote later with `git remote remove old-origin`.

Anyone else cloning should use the new URL. Existing clones can update with:

```bash
git remote set-url origin https://github.com/YOUR_ORG/poais-core.git
git fetch origin
```
