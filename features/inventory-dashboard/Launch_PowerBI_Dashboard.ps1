# MCCNO Dashboard - Automated Power BI Launcher
# This script opens Power BI Desktop and prepares clipboard with DAX measures

param(
    [string]$ProjectPath = "D:\OneDrive\Documents\GitHub\inventory-dashboard-powerbi"
)

Write-Host "MCCNO Power BI Auto-Launcher" -ForegroundColor Blue
Write-Host "=============================" -ForegroundColor Blue

# Function to find Power BI Desktop executable
function Find-PowerBIDesktop {
    # Check if Power BI is currently running (most reliable method)
    $RunningPBI = Get-Process -Name "PBIDesktop" -ErrorAction SilentlyContinue
    if ($RunningPBI -and $RunningPBI.Path) {
        # Return first path if multiple instances running
        return ($RunningPBI.Path | Select-Object -First 1)
    }
    
    # Common installation paths
    $CommonPaths = @(
        "${env:ProgramFiles}\Microsoft Power BI Desktop\bin\PBIDesktop.exe",
        "${env:LOCALAPPDATA}\Microsoft\WindowsApps\PBIDesktop.exe",
        "${env:ProgramFiles(x86)}\Microsoft Power BI Desktop\bin\PBIDesktop.exe"
    )
    
    foreach ($Path in $CommonPaths) {
        if (Test-Path $Path) {
            return $Path
        }
    }
    
    # Check Microsoft Store app location
    $StoreAppPath = Get-ChildItem -Path "${env:ProgramFiles}\WindowsApps" -Filter "*PowerBI*" -Directory -ErrorAction SilentlyContinue |
        Get-ChildItem -Filter "PBIDesktop.exe" -Recurse -ErrorAction SilentlyContinue |
        Select-Object -First 1 -ExpandProperty FullName
    
    if ($StoreAppPath) {
        return $StoreAppPath
    }
    
    # Try launching via Start command (works for Store apps)
    return "PBIDesktop"
}

# Check if Power BI Desktop is installed
$PowerBIPath = Find-PowerBIDesktop

if ($PowerBIPath) {
    Write-Host "Found Power BI Desktop: $PowerBIPath" -ForegroundColor Green
    
    # Prepare the first DAX measure for clipboard
    $FirstDAXMeasure = @"
GMROI = 
DIVIDE(
    SUM(sales_sample[gross_margin]), 
    AVERAGE(inventory_sample[qty] * inventory_sample[cost]), 
    0
)
"@
    
    # Copy to clipboard
    $FirstDAXMeasure | Set-Clipboard
    Write-Host "First DAX measure copied to clipboard!" -ForegroundColor Green
    
    # Open the Quick Setup Guide
    $QuickGuide = Join-Path $ProjectPath "dashboard-files\Generated_Components\Quick_Setup_Guide.md"
    if (Test-Path $QuickGuide) {
        Start-Process "notepad.exe" -ArgumentList $QuickGuide
        Write-Host "Opened Quick Setup Guide in Notepad" -ForegroundColor Green
    }
    
    # Launch Power BI Desktop
    Write-Host "Launching Power BI Desktop..." -ForegroundColor Yellow
    
    try {
        if ($PowerBIPath -eq "PBIDesktop") {
            # Use Start-Process with shell execution for Store apps
            Start-Process -FilePath "cmd" -ArgumentList "/c start PBIDesktop" -WindowStyle Hidden
        } else {
            # Use direct path for traditional installation
            Start-Process -FilePath $PowerBIPath
        }
        Write-Host "✅ Power BI Desktop launched successfully!" -ForegroundColor Green
    } catch {
        Write-Host "⚠️  Power BI launch method 1 failed, trying alternative..." -ForegroundColor Yellow
        try {
            # Alternative launch method
            Start-Process -FilePath "PBIDesktop" -ErrorAction Stop
            Write-Host "✅ Power BI Desktop launched successfully!" -ForegroundColor Green
        } catch {
            Write-Host "❌ Could not launch Power BI Desktop automatically" -ForegroundColor Red
            Write-Host "Please open Power BI Desktop manually and continue with the guide" -ForegroundColor Yellow
        }
    }
    
    Write-Host ""
    Write-Host "READY TO GO!" -ForegroundColor Green
    Write-Host "=============" -ForegroundColor Green
    Write-Host "1. Power BI Desktop is opening" -ForegroundColor White
    Write-Host "2. Quick Setup Guide is open in Notepad" -ForegroundColor White
    Write-Host "3. First DAX measure is in your clipboard" -ForegroundColor White
    Write-Host ""
    Write-Host "Next Steps in Power BI:" -ForegroundColor Yellow
    Write-Host "1. Get Data -> Text/CSV" -ForegroundColor White
    Write-Host "2. Import sample-data/*.csv files" -ForegroundColor White
    Write-Host "3. Home -> New Measure -> Paste (Ctrl+V)" -ForegroundColor White
    Write-Host "4. Follow the Quick Setup Guide!" -ForegroundColor White
    
} else {
    Write-Host "Power BI Desktop not found!" -ForegroundColor Red
    Write-Host "Please download from: https://powerbi.microsoft.com/desktop/" -ForegroundColor Yellow
    Write-Host ""
    Write-Host "Alternative: Follow the manual setup guide:" -ForegroundColor Blue
    $QuickGuide = Join-Path $ProjectPath "dashboard-files\Generated_Components\Quick_Setup_Guide.md"
    Start-Process "notepad.exe" -ArgumentList $QuickGuide
}
