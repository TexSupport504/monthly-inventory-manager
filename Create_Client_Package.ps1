# ConventiCore Client Delivery Package Creator
# This script creates a complete ZIP package for client delivery

Write-Host "🚀 CONVENTICORE CLIENT PACKAGE CREATOR" -ForegroundColor Green
Write-Host "=" * 50

# Define package name with timestamp
$timestamp = Get-Date -Format "yyyy-MM-dd"
$packageName = "ConventiCore_ClientPackage_$timestamp"
$packagePath = "./$packageName"

# Create package directory
Write-Host "📁 Creating package directory..." -ForegroundColor Yellow
if (Test-Path $packagePath) {
    Remove-Item $packagePath -Recurse -Force
}
New-Item -ItemType Directory -Path $packagePath | Out-Null

# Copy essential files
Write-Host "📋 Copying essential files..." -ForegroundColor Yellow

$filesToCopy = @{
    "Event-Inventory-CommandCenter.xlsx" = "Excel workbook (17 sheets)"
    "CLIENT_Events.csv" = "3,734 events"
    "CLIENT_Sales.csv" = "500 sales transactions" 
    "CLIENT_Counts.csv" = "200 inventory counts"
    "CLIENT_SKU_Master.csv" = "100 product catalog"
    "CLIENT_Buy_Plan.csv" = "Purchase recommendations"
    "CLIENT_Forecast.csv" = "Demand forecasting"
    "CLIENT_PnL.csv" = "Profit & loss analysis"
    "QUICK_START_GUIDE.md" = "5-minute setup guide"
}

foreach ($file in $filesToCopy.Keys) {
    if (Test-Path $file) {
        Copy-Item $file $packagePath
        $size = (Get-Item $file).Length
        Write-Host "  ✅ $file ($($filesToCopy[$file])) - $([math]::Round($size/1KB, 1))KB" -ForegroundColor Green
    } else {
        Write-Host "  ⚠️  $file not found" -ForegroundColor Red
    }
}

# Create README for the package
Write-Host "📄 Creating package README..." -ForegroundColor Yellow
$readmeContent = @"
# CONVENTICORE INVENTORY MANAGER
## Client Delivery Package

### 🎁 WHAT'S INCLUDED:
- Event-Inventory-CommandCenter.xlsx (Complete Excel workbook)
- CLIENT_Events.csv (3,734 events)
- CLIENT_Sales.csv (500 sales transactions)
- CLIENT_Counts.csv (200 inventory counts)
- CLIENT_SKU_Master.csv (100 product catalog)
- CLIENT_Buy_Plan.csv (Purchase recommendations)
- CLIENT_Forecast.csv (Demand forecasting)
- CLIENT_PnL.csv (Profit & loss analysis)
- QUICK_START_GUIDE.md (5-minute setup instructions)

### 🚀 QUICK START:
1. Open Event-Inventory-CommandCenter.xlsx
2. Follow QUICK_START_GUIDE.md (5 minutes total)
3. Start managing your inventory immediately!

### 💼 BUSINESS VALUE:
- `$2,042,502.54 inventory value managed
- `$853,831.20 annual sales tracked
- Complete operational visibility from day 1
- Zero learning curve - Excel-based

### 📞 SUPPORT:
This is a complete, self-contained system. Follow the Quick Start Guide for immediate setup.

Generated: $(Get-Date -Format "MMMM dd, yyyy")
Version: Production v1.0
Status: ✅ CLIENT READY
"@

$readmeContent | Out-File -FilePath "$packagePath/README.txt" -Encoding UTF8

# Create the ZIP file
Write-Host "🗜️  Creating ZIP package..." -ForegroundColor Yellow
$zipPath = "./$packageName.zip"
if (Test-Path $zipPath) {
    Remove-Item $zipPath -Force
}

Compress-Archive -Path $packagePath -DestinationPath $zipPath -Force

# Get package info
$zipSize = (Get-Item $zipPath).Length
$fileCount = (Get-ChildItem $packagePath).Count

Write-Host ""
Write-Host "🎉 PACKAGE CREATED SUCCESSFULLY!" -ForegroundColor Green
Write-Host "=" * 50
Write-Host "📦 Package: $packageName.zip" -ForegroundColor Cyan
Write-Host "📏 Size: $([math]::Round($zipSize/1MB, 2)) MB" -ForegroundColor Cyan
Write-Host "📁 Files: $fileCount files included" -ForegroundColor Cyan
Write-Host ""
Write-Host "🚚 READY FOR CLIENT DELIVERY!" -ForegroundColor Green
Write-Host "Client can be operational in 5 minutes with this package." -ForegroundColor Yellow

# Clean up temporary directory
Remove-Item $packagePath -Recurse -Force

Write-Host ""
Write-Host "Client package ready: $packageName.zip" -ForegroundColor Green
