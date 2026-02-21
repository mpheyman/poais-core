# Sync Cursor runtime from poais\.cursor to repo root .cursor\
# Run from product repo root after git subtree add/pull of poais-core.
$ErrorActionPreference = "Stop"

$ScriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path
$PoaisRoot = Split-Path -Parent $ScriptDir
$SourceCursor = Join-Path $PoaisRoot ".cursor"

if (-not (Test-Path -LiteralPath $SourceCursor -PathType Container)) {
    Write-Error "ERROR: poais\.cursor not found at $SourceCursor. Run this from a product repo root after adding poais-core via subtree (prefix=poais)."
    exit 1
}

# Product repo root = parent of poais
$RepoRoot = Split-Path -Parent $PoaisRoot
$TargetCursor = Join-Path $RepoRoot ".cursor"

if (Test-Path -LiteralPath $TargetCursor) {
    Remove-Item -LiteralPath $TargetCursor -Recurse -Force
}
Copy-Item -LiteralPath $SourceCursor -Destination $TargetCursor -Recurse -Force
Write-Host "SUCCESS: .cursor\ synced from poais\.cursor to repo root."
