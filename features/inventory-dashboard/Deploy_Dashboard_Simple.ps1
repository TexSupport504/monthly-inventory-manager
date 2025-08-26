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
$PowerBIPath = $null
$PossiblePaths = @(
    "${env:ProgramFiles}\Microsoft Power BI Desktop\bin\PBIDesktop.exe",
    "${env:LOCALAPPDATA}\Microsoft\WindowsApps\PBIDesktop.exe"
)

foreach ($Path in $PossiblePaths) {
    if (Test-Path $Path) {
        $PowerBIPath = $Path
        break
    }
}

if (-not $PowerBIPath) {
    Write-Warning "❌ Power BI Desktop not found. Please install from Microsoft Store"
    Write-Host "   Download: https://powerbi.microsoft.com/desktop/" -ForegroundColor Yellow
    exit 1
} else {
    Write-Host "   ✓ Power BI Desktop found: $PowerBIPath" -ForegroundColor Green
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

# Test connections if requested
if ($TestConnection) {
    Write-Host "🔍 Testing data connections..." -ForegroundColor Yellow
    
    try {
        $EventsTest = Import-Csv (Join-Path $DataPath "data\events_processed.csv") | Select-Object -First 1
        Write-Host "   ✓ Events CSV: $($EventsTest.name)" -ForegroundColor Green
        
        $SalesTest = Import-Csv (Join-Path $DataPath "data\sales_processed.csv") | Select-Object -First 1  
        Write-Host "   ✓ Sales CSV: $($SalesTest.sku)" -ForegroundColor Green
        
        $CountsTest = Import-Csv (Join-Path $DataPath "data\counts_processed.csv") | Select-Object -First 1
        Write-Host "   ✓ Counts CSV: $($CountsTest.sku)" -ForegroundColor Green
        
        Write-Host "✅ All data connections verified!" -ForegroundColor Green
        
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

# Create instructions
$Instructions = @"
# ConventiCore Dashboard Setup Instructions

## Quick Setup Steps
1. Open Power BI Desktop
2. Get Data > Blank Query > Advanced Editor
3. Paste content from: Generated_DataModel.m
4. Close & Apply
5. Load MCCNO theme from: branding-assets\MCCNO_PowerBI_Theme.json

Data Path: $DataPath
Generated: $(Get-Date)
"@

$InstructionsFile = Join-Path $DashboardPath "Dashboard_Setup_Instructions.txt"
$Instructions | Out-File -FilePath $InstructionsFile -Encoding UTF8
Write-Host "   ✓ Instructions saved: $InstructionsFile" -ForegroundColor Green

# Generate sample metrics
Write-Host "📈 Creating sample metrics..." -ForegroundColor Cyan
try {
    $Events = Import-Csv (Join-Path $DataPath "data\events_processed.csv")
    $Sales = Import-Csv (Join-Path $DataPath "data\sales_processed.csv") 
    
    $EventsCount = $Events.Count
    $TotalRevenue = ($Sales | Measure-Object -Property revenue -Sum).Sum
    
    $SampleMetrics = @"
# ConventiCore Dashboard - Sample Metrics

## Current Data Overview
- Total Events: $EventsCount
- Total Revenue: $($TotalRevenue.ToString('C'))

Generated: $(Get-Date)
"@

    $MetricsFile = Join-Path $DashboardPath "Sample_Metrics_Preview.txt"
    $SampleMetrics | Out-File -FilePath $MetricsFile -Encoding UTF8
    Write-Host "   ✓ Sample metrics: $MetricsFile" -ForegroundColor Green
    
} catch {
    Write-Warning "   ⚠️  Could not generate sample metrics"
    $MetricsFile = $null
}

# Create quick launcher
$LaunchScript = @'
Write-Host "🚀 Launching ConventiCore Dashboard..." -ForegroundColor Cyan
$PowerBIPath = "${env:ProgramFiles}\Microsoft Power BI Desktop\bin\PBIDesktop.exe"
if (-not (Test-Path $PowerBIPath)) {
    $PowerBIPath = "${env:LOCALAPPDATA}\Microsoft\WindowsApps\PBIDesktop.exe"
}
if (Test-Path $PowerBIPath) {
    Start-Process -FilePath $PowerBIPath
    Get-Content ".\Generated_DataModel.m" | Set-Clipboard
    Write-Host "✅ Data model copied to clipboard!" -ForegroundColor Green
} else {
    Write-Host "❌ Power BI Desktop not found" -ForegroundColor Red
}
'@

$LaunchFile = Join-Path $DashboardPath "Quick_Launch_Dashboard.ps1"
$LaunchScript | Out-File -FilePath $LaunchFile -Encoding UTF8
Write-Host "   ✓ Quick launch script: $LaunchFile" -ForegroundColor Green

# Launch if requested
if ($OpenPowerBI -or (-not $TestConnection)) {
    Write-Host "🚀 Launching Power BI Desktop..." -ForegroundColor Cyan
    
    Get-Content $ConnectionFile | Set-Clipboard
    Write-Host "   📋 Data model copied to clipboard" -ForegroundColor Yellow
    
    Start-Process -FilePath $PowerBIPath
    
    Write-Host "✅ Dashboard deployment initiated!" -ForegroundColor Green
    Write-Host "   Next: Paste data model in Power BI Advanced Editor" -ForegroundColor Cyan
}

Write-Host ""
Write-Host "🎉 ConventiCore Dashboard Deployment Complete!" -ForegroundColor Green
Write-Host "=================================================" -ForegroundColor Gray
Write-Host "Files Generated:" -ForegroundColor Cyan
Write-Host "  • Generated_DataModel.m" -ForegroundColor White
Write-Host "  • Dashboard_Setup_Instructions.txt" -ForegroundColor White
Write-Host "  • Quick_Launch_Dashboard.ps1" -ForegroundColor White
if ($MetricsFile) { Write-Host "  • Sample_Metrics_Preview.txt" -ForegroundColor White }

Write-Host ""
Write-Host "🔗 Quick Commands:" -ForegroundColor Yellow  
Write-Host "  Launch: .\Quick_Launch_Dashboard.ps1" -ForegroundColor White
Write-Host "  Test: .\Deploy_Dashboard.ps1 -TestConnection" -ForegroundColor White
