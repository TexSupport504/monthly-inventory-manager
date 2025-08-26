# Monthly Inventory Manager - Setup Assistant (PowerShell)
# Cross-platform setup script for MIM with friendly guidance

Write-Host " Monthly Inventory Manager Setup Assistant" -ForegroundColor Cyan
Write-Host "=============================================" -ForegroundColor Cyan

# Check prerequisites
Write-Host "`n[1/6] Checking Prerequisites..." -ForegroundColor Blue
try {
    $gitVersion = git --version
    Write-Host " Git found: $gitVersion" -ForegroundColor Green
} catch {
    Write-Host " Git not found. Install from: https://git-scm.com/" -ForegroundColor Red
}

try {
    $pythonVersion = python --version
    Write-Host " Python found: $pythonVersion" -ForegroundColor Green
} catch {
    Write-Host " Python not found. Install from: https://python.org/" -ForegroundColor Red
}

# Create directories
Write-Host "`n[2/6] Creating directories..." -ForegroundColor Blue
$dirs = @("data", "logs", "reports", "samples", "tests", "docs/guides")
foreach ($dir in $dirs) {
    if (-not (Test-Path $dir)) {
        New-Item -ItemType Directory -Path $dir -Force | Out-Null
        Write-Host " Created: $dir" -ForegroundColor Green
    }
}

# Create .env file
Write-Host "`n[3/6] Creating configuration..." -ForegroundColor Blue
if (-not (Test-Path ".env")) {
    @"
# Monthly Inventory Manager Configuration
DATABASE_TYPE=sqlite
DATABASE_PATH=./data/inventory.db
LOG_LEVEL=INFO
"@ | Out-File -FilePath ".env" -Encoding utf8
    Write-Host " Created .env configuration" -ForegroundColor Green
}

Write-Host "`n Setup Complete! Next steps:" -ForegroundColor Green
Write-Host "1. Run: python ops_controller.py" -ForegroundColor Yellow
Write-Host "2. Check features/inventory-dashboard/ for Power BI" -ForegroundColor Yellow
Write-Host "3. Read docs/guides/quickstart.md" -ForegroundColor Yellow
