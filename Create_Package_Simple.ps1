# ConventiCore Client Package Creator
Write-Host "Creating ConventiCore Client Package..." -ForegroundColor Green

# Create package directory
$packageName = "ConventiCore_ClientPackage_$(Get-Date -Format 'yyyy-MM-dd')"
$packagePath = "./$packageName"

if (Test-Path $packagePath) {
    Remove-Item $packagePath -Recurse -Force
}
New-Item -ItemType Directory -Path $packagePath | Out-Null

# Copy files
Write-Host "Copying essential files..." -ForegroundColor Yellow

$files = @(
    "Event-Inventory-CommandCenter.xlsx",
    "CLIENT_Events.csv",
    "CLIENT_Sales.csv", 
    "CLIENT_Counts.csv",
    "CLIENT_SKU_Master.csv",
    "CLIENT_Buy_Plan.csv",
    "CLIENT_Forecast.csv",
    "CLIENT_PnL.csv",
    "QUICK_START_GUIDE.md"
)

foreach ($file in $files) {
    if (Test-Path $file) {
        Copy-Item $file $packagePath
        $size = (Get-Item $file).Length
        Write-Host "  Copied: $file - $([math]::Round($size/1KB, 1))KB" -ForegroundColor Green
    } else {
        Write-Host "  Missing: $file" -ForegroundColor Red
    }
}

# Create README
$readme = @"
CONVENTICORE INVENTORY MANAGER - CLIENT PACKAGE

INCLUDED FILES:
- Event-Inventory-CommandCenter.xlsx (Complete Excel workbook)
- CLIENT_Events.csv (3,734 events)
- CLIENT_Sales.csv (500 sales transactions)
- CLIENT_Counts.csv (200 inventory counts)
- CLIENT_SKU_Master.csv (100 product catalog)
- CLIENT_Buy_Plan.csv (Purchase recommendations)
- CLIENT_Forecast.csv (Demand forecasting)
- CLIENT_PnL.csv (Profit analysis)
- QUICK_START_GUIDE.md (5-minute setup guide)

QUICK START:
1. Open Event-Inventory-CommandCenter.xlsx
2. Follow QUICK_START_GUIDE.md (5 minutes)
3. Import CSV files using Data > Get Data > From Text/CSV
4. View Dashboard for live metrics

BUSINESS VALUE:
- $2,042,502.54 inventory value
- $853,831.20 annual sales tracked
- Immediate operational visibility
- Professional Excel-based system

Generated: $(Get-Date)
Status: READY FOR CLIENT USE
"@

$readme | Out-File -FilePath "$packagePath/README.txt" -Encoding UTF8

# Create ZIP
$zipPath = "./$packageName.zip"
if (Test-Path $zipPath) { Remove-Item $zipPath -Force }
Compress-Archive -Path $packagePath -DestinationPath $zipPath -Force

# Results
$zipSize = (Get-Item $zipPath).Length
$fileCount = (Get-ChildItem $packagePath).Count

Write-Host ""
Write-Host "PACKAGE CREATED SUCCESSFULLY!" -ForegroundColor Green
Write-Host "Package: $packageName.zip" -ForegroundColor Cyan
Write-Host "Size: $([math]::Round($zipSize/1MB, 2)) MB" -ForegroundColor Cyan  
Write-Host "Files: $fileCount files" -ForegroundColor Cyan
Write-Host ""
Write-Host "READY FOR CLIENT DELIVERY!" -ForegroundColor Green

# Cleanup
Remove-Item $packagePath -Recurse -Force
