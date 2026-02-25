# Initialize a product repo to use POAIS (portfolio layout).
# Run from inside a product repo; or: irm <RAW_URL> | iex (set $env:POAIS_CORE_REPO_URL first if poais is missing)
# Usage: .\poais-init.ps1 [-RepoUrl <POAIS_CORE_REPO_URL>] [-ProductNames @("product-a","product-b")]
# Default product names: product-a, product-b.
param(
    [string]$RepoUrl = "",
    [string[]]$ProductNames = @()
)
if ($ProductNames.Count -eq 0) { $ProductNames = @("product-a", "product-b") }
$ErrorActionPreference = "Stop"

Write-Host "=== POAIS init ==="
Write-Host ""

# Detect repo root
$repoRoot = $null
try {
    $repoRoot = git rev-parse --show-toplevel 2>$null
} catch {}
if (-not $repoRoot) {
    Write-Error "ERROR: Not in a git repository. Run this from inside a product repo (with at least one commit)."
    Write-Host "  Create an initial commit if needed: echo '# myproduct' > README.md; git add README.md; git commit -m 'Initial commit'"
    exit 1
}
Set-Location -LiteralPath $repoRoot
Write-Host "  Repo root: $repoRoot"
Write-Host ""

if (-not $RepoUrl) { $RepoUrl = $env:POAIS_CORE_REPO_URL }

$PoaisDir = "poais"
$Skeleton = Join-Path $PoaisDir "bootstrap\portfolio-repo-skeleton"
$Templates = Join-Path $PoaisDir "templates\product"
$RequiredFiles = @("CONTEXT.md", "DISCOVERY.md", "PLAN.md", "EXECUTION.md", "DECISIONS.md", "RISKS.md", "ROADMAP.md", "STATUS.md")
$RequiredDirs = @("INPUTS", "MEETINGS", "FEATURES", "IDEAS")

if (-not (Test-Path -LiteralPath $PoaisDir -PathType Container)) {
    if (-not $RepoUrl) {
        Write-Error "ERROR: .\poais not found and no repo URL given. Provide -RepoUrl or set env POAIS_CORE_REPO_URL."
        Write-Host "  Example: `$env:POAIS_CORE_REPO_URL='https://github.com/mpheyman/poais-core.git'; irm https://raw.githubusercontent.com/mpheyman/poais-core/main/tools/poais-init.ps1 | iex"
        exit 1
    }
    Write-Host "=== Adding poais-core via subtree ==="
    git subtree add --prefix=poais $RepoUrl main --squash
    Write-Host ""
} else {
    if ($RepoUrl) {
        Write-Host "  .\poais exists; skipping subtree add."
    }
}

Write-Host "=== Syncing Cursor runtime ==="
& "powershell" "-ExecutionPolicy" "Bypass" "-File" (Join-Path $PoaisDir "tools\sync-cursor-runtime.ps1")
Write-Host ""

if (-not (Test-Path -LiteralPath "products" -PathType Container) -or -not (Test-Path -LiteralPath "portfolio" -PathType Container)) {
    Write-Host "=== Scaffolding portfolio workspace (safe copy) ==="
    $skeletonFull = Join-Path $repoRoot $Skeleton
    foreach ($item in Get-ChildItem -LiteralPath $skeletonFull) {
        $dest = Join-Path $repoRoot $item.Name
        if (Test-Path -LiteralPath $dest) { continue }
        if ($item.PSIsContainer) {
            Copy-Item -LiteralPath $item.FullName -Destination $dest -Recurse -Force
        } else {
            Copy-Item -LiteralPath $item.FullName -Destination $dest -Force
        }
    }
    Write-Host "  Created products\ and portfolio\ from scaffold."
    Write-Host ""
}
Write-Host "  Ensuring required dirs and files per product..."
foreach ($pname in $ProductNames) {
    $prodPath = Join-Path "products" $pname
    foreach ($d in $RequiredDirs) {
        $dirPath = Join-Path $prodPath $d
        if (-not (Test-Path -LiteralPath $dirPath -PathType Container)) {
            New-Item -ItemType Directory -Path $dirPath -Force | Out-Null
        }
    }
    foreach ($f in $RequiredFiles) {
        $destFile = Join-Path $prodPath $f
        $srcFile = Join-Path $repoRoot (Join-Path $Templates $f)
        if (-not (Test-Path -LiteralPath $destFile -PathType Leaf)) {
            if (Test-Path -LiteralPath $srcFile -PathType Leaf) {
                Copy-Item -LiteralPath $srcFile -Destination $destFile -Force
                Write-Host "  Added $prodPath\$f from template"
            }
        }
    }
}
Write-Host ""

$poaisCommit = ""
$logOut = git log -1 --format=%H -- poais/ 2>&1
if ($LASTEXITCODE -eq 0 -and $logOut) { $poaisCommit = $logOut.Trim() }
$now = [DateTime]::UtcNow.ToString("yyyy-MM-ddTHH:mm:ssZ")

if (-not $RepoUrl -and (Test-Path -LiteralPath "POAIS_LOCK.json" -PathType Leaf)) {
    try {
        $existing = Get-Content -LiteralPath "POAIS_LOCK.json" -Raw | ConvertFrom-Json
        $RepoUrl = $existing.poais_core_repo_url
    } catch {}
}

Write-Host "=== Updating POAIS_LOCK.json ==="
$LockFile = "POAIS_LOCK.json"
$lockContent = @{
    poais_core_repo_url = if ($RepoUrl) { $RepoUrl } else { "" }
    poais_prefix = "poais"
    poais_branch = "main"
    poais_core_commit = $poaisCommit
    cursor_runtime_synced_at = $now
    installed_at = $now
    products = @($ProductNames | ForEach-Object { "products/$_" })
    portfolio = "portfolio"
}
if (Test-Path -LiteralPath $LockFile -PathType Leaf) {
    try {
        $existing = Get-Content -LiteralPath $LockFile -Raw | ConvertFrom-Json
        $lockContent.poais_core_repo_url = if ($RepoUrl) { $RepoUrl } else { $existing.poais_core_repo_url }
        $lockContent.installed_at = $existing.installed_at
    } catch {}
    Write-Host "  Updated $LockFile"
} else {
    Write-Host "  Created $LockFile"
}
$lockContent | ConvertTo-Json -Depth 3 | Set-Content -LiteralPath $LockFile -Encoding utf8 -NoNewline:$false
Write-Host ""

$dateStr = Get-Date -Format "yyyy-MM-dd"
Write-Host "=== SUCCESS: POAIS initialized ==="
Write-Host ""
Write-Host "Next steps:"
Write-Host "  1. Open this repo in Cursor."
Write-Host "  2. Per product: create input e.g. products\<name>\INPUTS\${dateStr}-notes.md, run /process and /align products/<name>, /status products/<name>."
Write-Host "  3. Run /status portfolio to write portfolio/STATUS.md roll-up."
Write-Host ""
exit 0
