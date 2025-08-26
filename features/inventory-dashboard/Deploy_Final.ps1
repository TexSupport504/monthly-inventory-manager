param(
    [string]$DataPath = "E:\OneDrive\Documents\GitHub\monthly-inventory-manager\",
    [switch]$TestConnection
)

Write-Host "🚀 ConventiCore Dashboard Deployment" -ForegroundColor Cyan

# Verify required data files
$RequiredFiles = @(
    "data\events_processed.csv",
    "data\sales_processed.csv", 
    "data\counts_processed.csv",
    "sample_sku_data.csv"
)

Write-Host "✅ Checking data files..." -ForegroundColor Green
$AllFilesExist = $true

foreach ($file in $RequiredFiles) {
    $FullPath = Join-Path $DataPath $file
    if (Test-Path $FullPath) {
        Write-Host "   ✓ $file" -ForegroundColor Green
    } else {
        Write-Host "   ❌ $file" -ForegroundColor Red
        $AllFilesExist = $false
    }
}

if (-not $AllFilesExist) {
    Write-Host "❌ Missing data files. Run ops_controller.py first." -ForegroundColor Red
    exit 1
}

if ($TestConnection) {
    Write-Host "🔍 Testing data connections..." -ForegroundColor Yellow
    
    $EventsPath = Join-Path $DataPath "data\events_processed.csv"
    $SalesPath = Join-Path $DataPath "data\sales_processed.csv"
    
    $EventsSample = Import-Csv $EventsPath | Select-Object -First 1
    $SalesSample = Import-Csv $SalesPath | Select-Object -First 1
    
    Write-Host "   ✓ Events: $($EventsSample.name)" -ForegroundColor Green
    Write-Host "   ✓ Sales: $($SalesSample.sku)" -ForegroundColor Green
    Write-Host "✅ All connections verified!" -ForegroundColor Green
    return
}

# Generate deployment files
Write-Host "📊 Creating Power BI deployment..." -ForegroundColor Cyan

$DashboardDir = Join-Path $DataPath "features\inventory-dashboard"
$TemplateFile = Join-Path $DashboardDir "data-connections\PowerQuery_DataModel.m"
$GeneratedFile = Join-Path $DashboardDir "Generated_DataModel.m"

# Update data paths in template
$Template = Get-Content $TemplateFile -Raw
$UpdatedTemplate = $Template.Replace("E:\OneDrive\Documents\GitHub\monthly-inventory-manager\", $DataPath.Replace('\', '\\'))
$UpdatedTemplate | Out-File -FilePath $GeneratedFile -Encoding UTF8

Write-Host "   ✓ Generated_DataModel.m created" -ForegroundColor Green

# Create setup instructions
$InstructionsContent = @"
# ConventiCore Power BI Setup

## Quick Steps:
1. Open Power BI Desktop
2. Get Data > Blank Query
3. Advanced Editor > Paste from Generated_DataModel.m
4. Close & Apply
5. Apply MCCNO theme from branding-assets/

Generated: $(Get-Date -Format "yyyy-MM-dd HH:mm")
Data Path: $DataPath
"@

$InstructionsFile = Join-Path $DashboardDir "Setup_Instructions.txt"
$InstructionsContent | Out-File -FilePath $InstructionsFile -Encoding UTF8

Write-Host "   ✓ Setup_Instructions.txt created" -ForegroundColor Green

# Create PowerBI launcher
$LauncherContent = @"
# Launch Power BI with data model ready
Write-Host "🚀 Opening Power BI Desktop..." -ForegroundColor Cyan

`$PowerBIPath = "`${env:ProgramFiles}\Microsoft Power BI Desktop\bin\PBIDesktop.exe"
if (Test-Path `$PowerBIPath) {
    Start-Process `$PowerBIPath
    
    # Copy data model to clipboard
    Get-Content "Generated_DataModel.m" | Set-Clipboard
    Write-Host "✅ Data model copied to clipboard!" -ForegroundColor Green
    Write-Host "   Paste in Power BI Advanced Editor" -ForegroundColor Yellow
} else {
    Write-Host "❌ Power BI Desktop not found at `$PowerBIPath" -ForegroundColor Red
    Write-Host "   Install from: https://powerbi.microsoft.com/desktop/" -ForegroundColor Yellow
}
"@

$LauncherFile = Join-Path $DashboardDir "Launch_PowerBI.ps1"
$LauncherContent | Out-File -FilePath $LauncherFile -Encoding UTF8

Write-Host "   ✓ Launch_PowerBI.ps1 created" -ForegroundColor Green

Write-Host ""
Write-Host "🎉 ConventiCore Dashboard Deployment Complete!" -ForegroundColor Green
Write-Host ""
Write-Host "📁 Generated Files:" -ForegroundColor Cyan
Write-Host "  • Generated_DataModel.m" -ForegroundColor White
Write-Host "  • Setup_Instructions.txt" -ForegroundColor White  
Write-Host "  • Launch_PowerBI.ps1" -ForegroundColor White
Write-Host ""
Write-Host "🚀 Next Steps:" -ForegroundColor Yellow
Write-Host "  1. Run: .\Launch_PowerBI.ps1" -ForegroundColor White
Write-Host "  2. In Power BI: Get Data > Blank Query > Advanced Editor" -ForegroundColor White
Write-Host "  3. Paste data model (already in clipboard)" -ForegroundColor White
Write-Host "  4. Apply MCCNO theme from branding-assets/" -ForegroundColor White
