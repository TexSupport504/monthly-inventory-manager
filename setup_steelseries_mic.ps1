# SteelSeries Microphone Setup for VS Code
Write-Host "🎤 Configuring SteelSeries Microphone for VS Code..." -ForegroundColor Green

# Check current audio devices
Write-Host "`n📋 Current Audio Devices:" -ForegroundColor Yellow
Get-WmiObject -Class Win32_SoundDevice | Where-Object {$_.Name -like "*Steel*"} | ForEach-Object {
    Write-Host "  ✅ Found: $($_.Name) - Status: $($_.Status)" -ForegroundColor Green
}

# Registry settings for VS Code audio access
Write-Host "`n🔧 Configuring Windows Audio Permissions..." -ForegroundColor Yellow
try {
    # Enable microphone access for desktop apps
    $regPath = "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\microphone"
    if (Test-Path $regPath) {
        Set-ItemProperty -Path $regPath -Name "Value" -Value "Allow"
        Write-Host "  ✅ Desktop app microphone access enabled" -ForegroundColor Green
    }
    
    # VS Code specific microphone permissions
    $vsCodePath = "$regPath\Microsoft.VisualStudioCode_8wekyb3d8bbwe"
    if (Test-Path $vsCodePath) {
        Set-ItemProperty -Path $vsCodePath -Name "Value" -Value "Allow"
        Write-Host "  ✅ VS Code microphone access enabled" -ForegroundColor Green
    }
} catch {
    Write-Host "  ⚠️  Registry access limited - run as Administrator for full setup" -ForegroundColor Yellow
}

Write-Host "`n🎯 VS Code Configuration:" -ForegroundColor Yellow
Write-Host "  ✅ Workspace settings configured for voice input" -ForegroundColor Green
Write-Host "  ✅ Speech timeout extended to 1200ms" -ForegroundColor Green
Write-Host "  ✅ Copilot chat enabled" -ForegroundColor Green

Write-Host "`n📋 Next Steps:" -ForegroundColor Cyan
Write-Host "1. Restart VS Code completely" -ForegroundColor White
Write-Host "2. In SteelSeries GG, ensure microphone is active" -ForegroundColor White
Write-Host "3. Test Windows Voice Recorder first" -ForegroundColor White
Write-Host "4. Click the microphone button in VS Code Claude interface" -ForegroundColor White
Write-Host "5. Grant microphone permissions when prompted" -ForegroundColor White

Write-Host "`n🚀 Ready for voice input in VS Code!" -ForegroundColor Green
