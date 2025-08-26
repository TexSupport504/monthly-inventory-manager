# ConventiCore Dashboard - Simple Deployment
Write-Host "🚀 ConventiCore Power BI Dashboard Deployment" -ForegroundColor Cyan
Write-Host "=============================================" -ForegroundColor Gray

# Check data files
$DataPath = "E:\OneDrive\Documents\GitHub\monthly-inventory-manager"
$Files = @("data\events_processed.csv", "data\sales_processed.csv", "data\counts_processed.csv", "sample_sku_data.csv")

Write-Host "✅ Checking data files..." -ForegroundColor Green
foreach ($File in $Files) {
    $FullPath = Join-Path $DataPath $File
    if (Test-Path $FullPath) {
        Write-Host "   ✓ $File" -ForegroundColor Green
    } else {
        Write-Host "   ❌ Missing: $File" -ForegroundColor Red
    }
}

# Generate Power Query model
Write-Host "📊 Generating Power BI data model..." -ForegroundColor Cyan

$Template = Get-Content "data-connections\PowerQuery_DataModel.m" -Raw
$Updated = $Template.Replace("E:\OneDrive\Documents\GitHub\monthly-inventory-manager\", "$DataPath\")
$Updated | Out-File "Generated_DataModel.m" -Encoding UTF8

Write-Host "   ✓ Generated_DataModel.m" -ForegroundColor Green

# Create instructions
$Instructions = "# Power BI Setup`n1. Open Power BI Desktop`n2. Get Data > Blank Query > Advanced Editor`n3. Paste from Generated_DataModel.m`n4. Close & Apply`n`nGenerated: $(Get-Date)"
$Instructions | Out-File "Instructions.txt" -Encoding UTF8

Write-Host "   ✓ Instructions.txt" -ForegroundColor Green

# Create launcher
$Launcher = "Write-Host 'Launching Power BI...' -ForegroundColor Cyan`nStart-Process '`${env:ProgramFiles}\Microsoft Power BI Desktop\bin\PBIDesktop.exe'`nGet-Content 'Generated_DataModel.m' | Set-Clipboard`nWrite-Host 'Data model copied to clipboard!' -ForegroundColor Green"
$Launcher | Out-File "Launch.ps1" -Encoding UTF8

Write-Host "   ✓ Launch.ps1" -ForegroundColor Green

Write-Host ""
Write-Host "🎉 Deployment Complete!" -ForegroundColor Green
Write-Host ""
Write-Host "Next: Run ./Launch.ps1 to open Power BI with data model ready" -ForegroundColor Yellow
