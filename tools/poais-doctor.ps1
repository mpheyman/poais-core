# Diagnose POAIS installation in a product repo. Run from product repo root.
# Usage: .\poais\tools\poais-doctor.ps1
# Exit 0 if all OK, 1 if any WARN or FAIL.
$ErrorActionPreference = "Stop"

$repoRoot = $null
try {
    $repoRoot = git rev-parse --show-toplevel 2>$null
} catch {}
if (-not $repoRoot) {
    Write-Host "FAIL: Not in a git repository. Run from the root of a product repo." -ForegroundColor Red
    Write-Host "  Fix: cd to your product repo root."
    exit 1
}
Set-Location -LiteralPath $repoRoot

$Status = 0
$PoaisDir = "poais"
$ProductDir = "product"
$RequiredFiles = @("CONTEXT.md", "DISCOVERY.md", "PLAN.md", "EXECUTION.md", "DECISIONS.md", "RISKS.md", "ROADMAP.md", "STATUS.md")
$RequiredDirs = @("INPUTS", "MEETINGS", "FEATURES")
$LockFile = "POAIS_LOCK.json"

function Check-Ok($msg) { Write-Host "  OK:   $msg" -ForegroundColor Green }
function Check-Warn($msg) { Write-Host "  WARN: $msg" -ForegroundColor Yellow; $script:Status = 1 }
function Check-Fail($msg) { Write-Host "  FAIL: $msg" -ForegroundColor Red; $script:Status = 1 }

Write-Host "POAIS doctor (product repo root: $repoRoot)"
Write-Host ""

if (-not (Test-Path -LiteralPath $PoaisDir -PathType Container)) {
    Check-Fail ".\poais not found."
    Write-Host "    Fix: .\poais\tools\poais-init.ps1 -RepoUrl 'https://github.com/mpheyman/poais-core.git'"
} else {
    Check-Ok ".\poais exists"
}

if (Test-Path -LiteralPath $PoaisDir -PathType Container) {
    $poaisCursor = Join-Path $PoaisDir ".cursor"
    if (-not (Test-Path -LiteralPath $poaisCursor -PathType Container)) {
        Check-Fail ".\poais\.cursor not found (poais-core may be incomplete)."
    } else {
        Check-Ok ".\poais\.cursor exists"
    }
}

if (-not (Test-Path -LiteralPath ".cursor" -PathType Container)) {
    Check-Fail "Root .cursor\ not found. Cursor will not see POAIS commands."
    Write-Host "    Fix: .\poais\tools\sync-cursor-runtime.ps1"
} else {
    Check-Ok "Root .cursor\ exists"
}

$rootCursor = Join-Path $repoRoot ".cursor"
$poaisCursorPath = Join-Path $repoRoot (Join-Path $PoaisDir ".cursor")
if ((Test-Path $rootCursor -PathType Container) -and (Test-Path $poaisCursorPath -PathType Container)) {
    $rootCount = (Get-ChildItem -Recurse -File -LiteralPath $rootCursor -ErrorAction SilentlyContinue | Measure-Object).Count
    $poaisCount = (Get-ChildItem -Recurse -File -LiteralPath $poaisCursorPath -ErrorAction SilentlyContinue | Measure-Object).Count
    if ($rootCount -ne $poaisCount) {
        Check-Warn "Root .cursor\ file count ($rootCount) differs from poais\.cursor ($poaisCount). Sync to get latest."
        Write-Host "    Fix: .\poais\tools\sync-cursor-runtime.ps1"
    }
}

if (-not (Test-Path -LiteralPath $ProductDir -PathType Container)) {
    Check-Fail ".\product not found."
    Write-Host "    Fix: .\poais\tools\poais-init.ps1 -RepoUrl <URL>"
} else {
    Check-Ok ".\product exists"
}

foreach ($d in $RequiredDirs) {
    $dirPath = Join-Path $ProductDir $d
    if (Test-Path -LiteralPath $dirPath -PathType Container) {
        Check-Ok "$ProductDir\$d\ exists"
    } else {
        Check-Warn "$ProductDir\$d\ missing."
        Write-Host "    Fix: New-Item -ItemType Directory -Path $dirPath -Force"
    }
}

foreach ($f in $RequiredFiles) {
    $filePath = Join-Path $ProductDir $f
    if (Test-Path -LiteralPath $filePath -PathType Leaf) {
        Check-Ok "$ProductDir\$f exists"
    } else {
        Check-Warn "$ProductDir\$f missing."
        Write-Host "    Fix: Copy-Item poais\templates\product\$f $ProductDir\$f"
    }
}

if (-not (Test-Path -LiteralPath $LockFile -PathType Leaf)) {
    Check-Warn "POAIS_LOCK.json not found (run init or upgrade to create/update)."
} else {
    Check-Ok "POAIS_LOCK.json exists"
}

Write-Host ""
if ($Status -eq 0) {
    Write-Host "All checks passed. You can use /process, /distill, /align, /status in Cursor." -ForegroundColor Green
    exit 0
} else {
    Write-Host "Apply the fixes above, then re-run doctor or run:"
    Write-Host "  .\poais\tools\poais-init.ps1 -RepoUrl 'https://github.com/mpheyman/poais-core.git'"
    Write-Host "  .\poais\tools\poais-upgrade.ps1 -RepoUrl 'https://github.com/mpheyman/poais-core.git'"
    exit 1
}
