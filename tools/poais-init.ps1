# Initialize a product repo to use POAIS. Run from product repo root.
# Usage: .\poais\tools\poais-init.ps1 [-RepoUrl <POAIS_CORE_REPO_URL>]
# If .\poais does not exist, RepoUrl is required.
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
$Skeleton = Join-Path $PoaisDir "bootstrap\single-product-repo-skeleton"
$Templates = Join-Path $PoaisDir "templates\product"
$ProductDir = "product"
$RequiredFiles = @("CONTEXT.md", "DISCOVERY.md", "PLAN.md", "EXECUTION.md", "DECISIONS.md", "RISKS.md", "ROADMAP.md", "STATUS.md")
$RequiredDirs = @("INPUTS", "MEETINGS", "FEATURES")

if (-not (Test-Path -LiteralPath $PoaisDir -PathType Container)) {
    if (-not $RepoUrl) {
        Write-Error "ERROR: .\poais not found. Provide the poais-core repo URL (e.g. -RepoUrl 'https://github.com/mpheyman/poais-core.git')."
        exit 1
    }
    Write-Host "Adding poais-core via subtree..."
    git subtree add --prefix=poais $RepoUrl main --squash
} else {
    if ($RepoUrl) {
        Write-Host ".\poais exists; skipping subtree add. RepoUrl ignored."
    }
}

Write-Host "Syncing Cursor runtime..."
& "powershell" "-ExecutionPolicy" "Bypass" "-File" (Join-Path $PoaisDir "tools\sync-cursor-runtime.ps1")

if (-not (Test-Path -LiteralPath $ProductDir -PathType Container)) {
    Write-Host "Creating workspace from scaffold (safe copy)..."
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
}

foreach ($d in $RequiredDirs) {
    $dirPath = Join-Path $ProductDir $d
    if (-not (Test-Path -LiteralPath $dirPath -PathType Container)) {
        New-Item -ItemType Directory -Path $dirPath -Force | Out-Null
    }
}
foreach ($f in $RequiredFiles) {
    $destFile = Join-Path $ProductDir $f
    $srcFile = Join-Path $repoRoot (Join-Path $Templates $f)
    if (-not (Test-Path -LiteralPath $destFile -PathType Leaf)) {
        if (Test-Path -LiteralPath $srcFile -PathType Leaf) {
            Copy-Item -LiteralPath $srcFile -Destination $destFile -Force
            Write-Host "  Added $ProductDir\$f from template"
        }
    }
}

$poaisCommit = ""
$err = $null
$logOut = git log -1 --format=%H -- poais/ 2>&1
if ($LASTEXITCODE -eq 0 -and $logOut) { $poaisCommit = $logOut.Trim() }
$now = [DateTime]::UtcNow.ToString("yyyy-MM-ddTHH:mm:ssZ")

$LockFile = "POAIS_LOCK.json"
$lockContent = @{
    poais_core_repo_url = if ($RepoUrl) { $RepoUrl } else { "" }
    poais_prefix = "poais"
    poais_branch = "main"
    poais_core_commit = $poaisCommit
    cursor_runtime_synced_at = $now
    installed_at = $now
    workspace_root = "product"
}
if (Test-Path -LiteralPath $LockFile -PathType Leaf) {
    try {
        $existing = Get-Content -LiteralPath $LockFile -Raw | ConvertFrom-Json
        $lockContent.poais_core_repo_url = if ($RepoUrl) { $RepoUrl } else { $existing.poais_core_repo_url }
        $lockContent.installed_at = $existing.installed_at
    } catch {}
}
$lockContent | ConvertTo-Json -Depth 3 | Set-Content -LiteralPath $LockFile -Encoding utf8 -NoNewline:$false

$dateStr = Get-Date -Format "yyyy-MM-dd"
Write-Host ""
Write-Host "SUCCESS: POAIS initialized."
Write-Host ""
Write-Host "Next steps:"
Write-Host "  1. Create an input file, e.g. ${ProductDir}\INPUTS\${dateStr}-notes.md"
Write-Host "  2. In Cursor, run: /process ${ProductDir}/INPUTS/<your-file>.md"
Write-Host ""
exit 0
