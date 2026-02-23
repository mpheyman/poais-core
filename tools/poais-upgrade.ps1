# Upgrade vendored poais-core in an existing product repo. Run from product repo root.
# Usage: .\poais\tools\poais-upgrade.ps1 [-RepoUrl <POAIS_CORE_REPO_URL>]
# RepoUrl may be omitted if POAIS_LOCK.json exists and contains poais_core_repo_url.
$ErrorActionPreference = "Stop"

$repoRoot = $null
try {
    $repoRoot = git rev-parse --show-toplevel 2>$null
} catch {}
if (-not $repoRoot) {
    Write-Error "ERROR: Not in a git repository. Run this from the root of a product repo."
    exit 1
}
Set-Location -LiteralPath $repoRoot

param([string]$RepoUrl = "")

$PoaisDir = "poais"
if (-not (Test-Path -LiteralPath $PoaisDir -PathType Container)) {
    Write-Error "ERROR: .\poais not found. Run poais-init first (e.g. .\poais\tools\poais-init.ps1 -RepoUrl 'https://github.com/mpheyman/poais-core.git')."
    exit 1
}

$hasHead = $false
git rev-parse -q HEAD 2>$null | Out-Null
if ($LASTEXITCODE -eq 0) {
    $diffOut = git diff-index HEAD -- 2>&1
    if ($LASTEXITCODE -ne 0 -or $diffOut) {
        Write-Error "ERROR: Working tree is not clean. Commit or stash changes, then run upgrade again."
        exit 1
    }
}

$LockFile = "POAIS_LOCK.json"
if (-not $RepoUrl -and (Test-Path -LiteralPath $LockFile -PathType Leaf)) {
    try {
        $lock = Get-Content -LiteralPath $LockFile -Raw | ConvertFrom-Json
        if ($lock.poais_core_repo_url) { $RepoUrl = $lock.poais_core_repo_url }
    } catch {}
}
if (-not $RepoUrl) {
    Write-Error "ERROR: Provide -RepoUrl or ensure POAIS_LOCK.json contains poais_core_repo_url."
    exit 1
}

Write-Host "Pulling latest poais-core..."
git subtree pull --prefix=poais $RepoUrl main --squash

Write-Host "Syncing Cursor runtime..."
& "powershell" "-ExecutionPolicy" "Bypass" "-File" (Join-Path $PoaisDir "tools\sync-cursor-runtime.ps1")

$poaisCommit = ""
$logOut = git log -1 --format=%H -- poais/ 2>&1
if ($LASTEXITCODE -eq 0 -and $logOut) { $poaisCommit = $logOut.Trim() }
$now = [DateTime]::UtcNow.ToString("yyyy-MM-ddTHH:mm:ssZ")

$lockContent = @{
    poais_core_repo_url = $RepoUrl
    poais_prefix = "poais"
    poais_branch = "main"
    poais_core_commit = $poaisCommit
    cursor_runtime_synced_at = $now
    upgraded_at = $now
}
if (Test-Path -LiteralPath $LockFile -PathType Leaf) {
    try {
        $existing = Get-Content -LiteralPath $LockFile -Raw | ConvertFrom-Json
        $lockContent.installed_at = $existing.installed_at
        if ($existing.products) { $lockContent.products = $existing.products }
        if ($existing.portfolio) { $lockContent.portfolio = $existing.portfolio }
        if (-not $lockContent.products -and -not $lockContent.portfolio -and $existing.workspace_root) {
            $lockContent.workspace_root = $existing.workspace_root
        }
    } catch {}
}
if (-not $lockContent.workspace_root -and -not $lockContent.products) {
    $lockContent.workspace_root = "product"
}
$lockContent | ConvertTo-Json -Depth 3 | Set-Content -LiteralPath $LockFile -Encoding utf8 -NoNewline:$false

Write-Host ""
Write-Host "SUCCESS: poais-core upgraded."
Write-Host "  poais-core commit (this repo): $poaisCommit"
Write-Host ""
Write-Host "Next: run /align product (or /align products/<name> for portfolio) in Cursor to check artifact alignment after upgrades."
Write-Host ""
exit 0
