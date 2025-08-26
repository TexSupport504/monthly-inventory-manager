# ConventiCore Dashboard Deployment Script
# Generates Power BI template and sets up data connections

param(
    [string]$DataPath = "E:\OneDrive\Documents\GitHub\monthly-inventory-manager\",
    [switch]$TestConnection,
    [switch]$OpenPowerBI
)

$ErrorActionPreference = "Stop"
$DashboardPath = Join-Path $DataPath "features\inventory-dashboard"

Write-Host "🚀 ConventiCore Dashboard Deployment" -ForegroundColor Cyan
Write-Host "=================================================" -ForegroundColor Gray

# Check Prerequisites
Write-Host "✅ Checking prerequisites..." -ForegroundColor Green

# Check if Power BI Desktop is installed
$PowerBIPath = Get-ChildItem -Path "${env:ProgramFiles}\Microsoft Power BI Desktop\bin" -Filter "PBIDesktop.exe" -ErrorAction SilentlyContinue
if (-not $PowerBIPath) {
    $PowerBIPath = Get-ChildItem -Path "${env:LOCALAPPDATA}\Microsoft\WindowsApps" -Filter "PBIDesktop.exe" -ErrorAction SilentlyContinue
}

if (-not $PowerBIPath) {
    Write-Warning "❌ Power BI Desktop not found. Please install from Microsoft Store or PowerBI.com"
    Write-Host "   Download: https://powerbi.microsoft.com/desktop/" -ForegroundColor Yellow
    exit 1
} else {
    Write-Host "   ✓ Power BI Desktop found: $($PowerBIPath.FullName)" -ForegroundColor Green
}

# Check data files
$DataFiles = @{
    "Events" = "data\events_processed.csv"
    "Sales" = "data\sales_processed.csv" 
    "Counts" = "data\counts_processed.csv"
    "SKUs" = "sample_sku_data.csv"
}

Write-Host "✅ Verifying data files..." -ForegroundColor Green
foreach ($file in $DataFiles.GetEnumerator()) {
    $FilePath = Join-Path $DataPath $file.Value
    if (Test-Path $FilePath) {
        $FileInfo = Get-Item $FilePath
        Write-Host "   ✓ $($file.Key): $($FileInfo.Length) bytes" -ForegroundColor Green
    } else {
        Write-Host "   ❌ Missing: $($file.Key) at $FilePath" -ForegroundColor Red
        Write-Host "      Run ops_controller.py to generate required data files" -ForegroundColor Yellow
        exit 1
    }
}

if ($TestConnection) {
    Write-Host "🔍 Testing data connections..." -ForegroundColor Yellow
    
    # Test CSV parsing
    try {
        $EventsTest = Import-Csv (Join-Path $DataPath "data\events_processed.csv") | Select-Object -First 1
        Write-Host "   ✓ Events CSV: $($EventsTest.name)" -ForegroundColor Green
        
        $SalesTest = Import-Csv (Join-Path $DataPath "data\sales_processed.csv") | Select-Object -First 1  
        Write-Host "   ✓ Sales CSV: $($SalesTest.sku)" -ForegroundColor Green
        
        $CountsTest = Import-Csv (Join-Path $DataPath "data\counts_processed.csv") | Select-Object -First 1
        Write-Host "   ✓ Counts CSV: $($CountsTest.sku)" -ForegroundColor Green
        
    } catch {
        Write-Host "   ❌ CSV parsing error: $($_.Exception.Message)" -ForegroundColor Red
        exit 1
    }
}

# Create Power Query connection string
Write-Host "📊 Generating Power BI data model..." -ForegroundColor Cyan

$ConnectionTemplate = Get-Content (Join-Path $DashboardPath "data-connections\PowerQuery_DataModel.m") -Raw
$UpdatedConnection = $ConnectionTemplate.Replace(
    "E:\OneDrive\Documents\GitHub\monthly-inventory-manager\", 
    $DataPath.Replace('\', '\\')
)

# Save updated connection
$ConnectionFile = Join-Path $DashboardPath "Generated_DataModel.m"
$UpdatedConnection | Out-File -FilePath $ConnectionFile -Encoding UTF8
Write-Host "   ✓ Data model saved: $ConnectionFile" -ForegroundColor Green

# Create Power BI instructions file
$Instructions = @"
# ConventiCore Dashboard Setup Instructions

## Automated Setup (Recommended)
1. Open Power BI Desktop
2. Click 'Get Data' > 'Blank Query'
3. Open Advanced Editor
4. Copy-paste content from: Generated_DataModel.m
5. Click 'Done' and 'Close & Apply'

## Apply MCCNO Theme
1. View tab > Themes > Browse for themes
2. Select: branding-assets\MCCNO_PowerBI_Theme.json
3. Click Apply

## Create Dashboard Pages
Based on ConventiCore_Dashboard_Template.json:

### Page 1: Executive Summary
- 4 KPI cards (Revenue, Inventory Value, Event Mix %, Critical Items)
- Revenue by Month column chart
- Revenue by Category pie chart  
- Top SKUs table

### Page 2: Inventory Analysis
- GMROI gauge chart
- Stock Status donut chart
- Days of Supply scatter plot
- Inventory KPIs matrix

### Page 3: Sales Trends
- Sales trend line chart
- Event vs Baseline column chart
- Channel performance table
- Day of week heatmap

## Data Refresh
- Data > Refresh Preview (manual)
- File > Options > Data Load (for automatic refresh)

Last Generated: $(Get-Date)
Data Path: $DataPath
"@

$InstructionsFile = Join-Path $DashboardPath "Dashboard_Setup_Instructions.txt"
$Instructions | Out-File -FilePath $InstructionsFile -Encoding UTF8
Write-Host "   ✓ Instructions saved: $InstructionsFile" -ForegroundColor Green

# Generate sample report
Write-Host "📈 Creating sample visualizations..." -ForegroundColor Cyan

# Quick data analysis for the instructions
try {
    $Events = Import-Csv (Join-Path $DataPath "data\events_processed.csv")
    $Sales = Import-Csv (Join-Path $DataPath "data\sales_processed.csv") 
    $Counts = Import-Csv (Join-Path $DataPath "data\counts_processed.csv")
    
    $EventsCount = $Events.Count
    $TotalRevenue = ($Sales | Measure-Object -Property revenue -Sum).Sum
    $UniqueSkus = ($Sales | Select-Object -Property sku -Unique).Count
    $InventoryItems = ($Counts | Where-Object {$_.checkpoint -eq "EOM"}).Count
    
    $SampleMetrics = @"
# ConventiCore Dashboard - Sample Metrics

## Current Data Overview
- Total Events: $EventsCount
- Total Revenue: $($TotalRevenue.ToString('C'))
- Unique SKUs: $UniqueSkus  
- Inventory Items: $InventoryItems

Generated: $(Get-Date)
"@

    $MetricsFile = Join-Path $DashboardPath "Sample_Metrics_Preview.txt"
    $SampleMetrics | Out-File -FilePath $MetricsFile -Encoding UTF8
    Write-Host "   ✓ Sample metrics: $MetricsFile" -ForegroundColor Green
    
} catch {
    Write-Warning "   ⚠️  Could not generate sample metrics: $($_.Exception.Message)"
}

# Create quick launch script
$LaunchScript = @'
# Quick Launch - ConventiCore Dashboard
$DataModelPath = ".\Generated_DataModel.m"
$PowerBIDesktop = Get-ChildItem -Path "${env:ProgramFiles}\Microsoft Power BI Desktop\bin" -Filter "PBIDesktop.exe" -ErrorAction SilentlyContinue

Write-Host "🚀 Launching ConventiCore Dashboard..." -ForegroundColor Cyan
Write-Host "1. Power BI Desktop will open" -ForegroundColor Yellow
Write-Host "2. Click Get Data > Blank Query" -ForegroundColor Yellow  
Write-Host "3. Open Advanced Editor" -ForegroundColor Yellow
Write-Host "4. Copy-paste from: $DataModelPath" -ForegroundColor Yellow

if ($PowerBIDesktop) {
    Start-Process -FilePath $PowerBIDesktop.FullName
    Get-Content $DataModelPath | Set-Clipboard
    Write-Host "✅ Data model copied to clipboard!" -ForegroundColor Green
} else {
    Write-Host "❌ Power BI Desktop not found" -ForegroundColor Red
}
'@

$LaunchFile = Join-Path $DashboardPath "Quick_Launch_Dashboard.ps1"
$LaunchScript | Out-File -FilePath $LaunchFile -Encoding UTF8
Write-Host "   ✓ Quick launch script: $LaunchFile" -ForegroundColor Green

# Launch Power BI if requested  
if ($OpenPowerBI -or (-not $TestConnection)) {
    Write-Host "🚀 Launching Power BI Desktop..." -ForegroundColor Cyan
    Write-Host "   📋 Data model has been copied to clipboard" -ForegroundColor Yellow
    Write-Host "   📖 Follow instructions in: $InstructionsFile" -ForegroundColor Yellow
    
    # Copy the data model to clipboard
    Get-Content $ConnectionFile | Set-Clipboard
    
    # Launch Power BI Desktop
    Start-Process -FilePath $PowerBIPath.FullName
    
    Write-Host "✅ Dashboard deployment initiated!" -ForegroundColor Green
    Write-Host "   Next steps:" -ForegroundColor Cyan
    Write-Host "   1. In Power BI: Get Data > Blank Query > Advanced Editor" -ForegroundColor White
    Write-Host "   2. Paste data model (already in clipboard)" -ForegroundColor White  
    Write-Host "   3. Apply MCCNO theme from branding-assets/" -ForegroundColor White
    Write-Host "   4. Create dashboard pages per template" -ForegroundColor White
}

Write-Host ""
Write-Host "🎉 ConventiCore Dashboard Deployment Complete!" -ForegroundColor Green
Write-Host "=================================================" -ForegroundColor Gray
Write-Host "Files Generated:" -ForegroundColor Cyan
Write-Host "  • $ConnectionFile" -ForegroundColor White
Write-Host "  • $InstructionsFile" -ForegroundColor White
Write-Host "  • $LaunchFile" -ForegroundColor White
if (Test-Path $MetricsFile) { Write-Host "  • $MetricsFile" -ForegroundColor White }

Write-Host ""
Write-Host "🔗 Quick Commands:" -ForegroundColor Yellow  
Write-Host "  Launch Dashboard: .\Quick_Launch_Dashboard.ps1" -ForegroundColor White
Write-Host "  Test Connection: .\Deploy_Dashboard.ps1 -TestConnection" -ForegroundColor White
Write-Host "  View Instructions: notepad Dashboard_Setup_Instructions.txt" -ForegroundColor White
