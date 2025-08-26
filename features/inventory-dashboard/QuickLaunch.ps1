# ConventiCore Power BI Dashboard - Quick Launch

Write-Host "🚀 ConventiCore Power BI Dashboard" -ForegroundColor Cyan

# Check Power BI Desktop
$PowerBIPath = "${env:ProgramFiles}\Microsoft Power BI Desktop\bin\PBIDesktop.exe"
if (Test-Path $PowerBIPath) {
    Write-Host "✅ Power BI Desktop found" -ForegroundColor Green
    
    # Copy data model to clipboard  
    Get-Content "Ready_For_PowerBI.m" | Set-Clipboard
    
    # Launch Power BI
    Start-Process $PowerBIPath
    
    Write-Host "📋 Data model copied to clipboard!" -ForegroundColor Green
    Write-Host ""
    Write-Host "Next Steps:" -ForegroundColor Cyan
    Write-Host "1. Get Data > Blank Query > Advanced Editor" -ForegroundColor White
    Write-Host "2. Paste data model (Ctrl+V)" -ForegroundColor White
    Write-Host "3. Done > Close & Apply" -ForegroundColor White
    
} else {
    Write-Host "❌ Power BI Desktop not found" -ForegroundColor Red
}
