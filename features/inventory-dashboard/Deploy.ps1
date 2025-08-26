param(
    [string]$DataPath = "E:\OneDrive\Documents\GitHub\monthly-inventory-manager\",
    [switch]$TestConnection
)

Write-Host "🚀 ConventiCore Dashboard Deployment" -ForegroundColor Cyan

# Check data files exist
$DataFiles = @(
    "data\events_processed.csv",
    "data\sales_processed.csv", 
    "data\counts_processed.csv",
    "sample_sku_data.csv"
)

Write-Host "✅ Verifying data files..." -ForegroundColor Green
foreach ($file in $DataFiles) {
    $FilePath = Join-Path $DataPath $file
    if (Test-Path $FilePath) {
        Write-Host "   ✓ Found: $file" -ForegroundColor Green
    } else {
        Write-Host "   ❌ Missing: $file" -ForegroundColor Red
        Write-Host "      Run ops_controller.py first" -ForegroundColor Yellow
        exit 1
    }
}

if ($TestConnection) {
    Write-Host "🔍 Testing CSV parsing..." -ForegroundColor Yellow
    try {
        $Events = Import-Csv (Join-Path $DataPath "data\events_processed.csv") | Select-Object -First 1
        $Sales = Import-Csv (Join-Path $DataPath "data\sales_processed.csv") | Select-Object -First 1
        Write-Host "   ✓ Events: $($Events.name)" -ForegroundColor Green
        Write-Host "   ✓ Sales: $($Sales.sku)" -ForegroundColor Green
        Write-Host "✅ Data connections verified!" -ForegroundColor Green
    } catch {
        Write-Host "   ❌ Error: $($_.Exception.Message)" -ForegroundColor Red
        exit 1
    }
    return
}

# Update Power Query template
Write-Host "📊 Generating data model..." -ForegroundColor Cyan
$DashboardPath = Join-Path $DataPath "features\inventory-dashboard"
$TemplateFile = Join-Path $DashboardPath "data-connections\PowerQuery_DataModel.m"
$OutputFile = Join-Path $DashboardPath "Generated_DataModel.m"

if (Test-Path $TemplateFile) {
    $Template = Get-Content $TemplateFile -Raw
    $Updated = $Template.Replace("E:\OneDrive\Documents\GitHub\monthly-inventory-manager\", $DataPath.Replace('\', '\\'))
    $Updated | Out-File -FilePath $OutputFile -Encoding UTF8
    Write-Host "   ✓ Generated: Generated_DataModel.m" -ForegroundColor Green
}

# Create instructions
$Instructions = "# ConventiCore Dashboard Setup`n1. Open Power BI Desktop`n2. Get Data > Blank Query`n3. Advanced Editor > Paste from Generated_DataModel.m`n4. Close & Apply`n`nGenerated: $(Get-Date)"
$Instructions | Out-File -FilePath (Join-Path $DashboardPath "Setup_Instructions.txt") -Encoding UTF8
Write-Host "   ✓ Generated: Setup_Instructions.txt" -ForegroundColor Green

# Create launcher
$Launcher = "Start-Process '${env:ProgramFiles}\Microsoft Power BI Desktop\bin\PBIDesktop.exe'`nGet-Content '.\Generated_DataModel.m' | Set-Clipboard`nWrite-Host 'Data model copied to clipboard!'"
$Launcher | Out-File -FilePath (Join-Path $DashboardPath "Launch_PowerBI.ps1") -Encoding UTF8
Write-Host "   ✓ Generated: Launch_PowerBI.ps1" -ForegroundColor Green

Write-Host ""
Write-Host "🎉 Deployment Complete!" -ForegroundColor Green
Write-Host "Next: Run .\Launch_PowerBI.ps1" -ForegroundColor Cyan
