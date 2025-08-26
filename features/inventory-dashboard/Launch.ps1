Write-Host "ConventiCore Power BI Dashboard Launcher" -ForegroundColor Cyan
Write-Host ""

# Check multiple Power BI Desktop installation locations
$PowerBIPaths = @(
    "${env:ProgramFiles}\Microsoft Power BI Desktop\bin\PBIDesktop.exe",
    "${env:LOCALAPPDATA}\Microsoft\WindowsApps\PBIDesktopStore.exe",
    "${env:LOCALAPPDATA}\Microsoft\WindowsApps\PBIDesktop.exe"
)

$PowerBIPath = $null
foreach ($Path in $PowerBIPaths) {
    if (Test-Path $Path) {
        $PowerBIPath = $Path
        break
    }
}

if ($PowerBIPath) {
    Write-Host "Launching Power BI Desktop..." -ForegroundColor Green
    Write-Host "Found at: $PowerBIPath" -ForegroundColor Gray
    
    Get-Content "Ready_For_PowerBI.m" | Set-Clipboard
    Start-Process $PowerBIPath
    
    Write-Host ""
    Write-Host "Data model copied to clipboard!" -ForegroundColor Green
    Write-Host "In Power BI:" -ForegroundColor Yellow
    Write-Host "1. Get Data - Blank Query" -ForegroundColor White
    Write-Host "2. Advanced Editor" -ForegroundColor White
    Write-Host "3. Paste model (Ctrl+V)" -ForegroundColor White
    Write-Host "4. Done - Close and Apply" -ForegroundColor White
    
} else {
    Write-Host "Power BI Desktop not found" -ForegroundColor Red
    Write-Host "Install from powerbi.microsoft.com" -ForegroundColor Yellow
}
