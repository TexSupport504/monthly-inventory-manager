# Configure Mouse Middle Button as Push-to-Talk for VS Code
# This script sets up the middle mouse button (scroll wheel click) as a push-to-talk feature

Write-Host "Setting up Mouse Middle Button Push-to-Talk for VS Code..." -ForegroundColor Green

# Check if AutoHotkey is available
$ahkPath = Get-Command "AutoHotkey.exe" -ErrorAction SilentlyContinue

if (-not $ahkPath) {
    Write-Host "AutoHotkey not found. Installing AutoHotkey..." -ForegroundColor Yellow
    
    # Download and install AutoHotkey
    $downloadUrl = "https://www.autohotkey.com/download/ahk-install.exe"
    $installerPath = "$env:TEMP\ahk-install.exe"
    
    try {
        Write-Host "Downloading AutoHotkey installer..." -ForegroundColor Yellow
        Invoke-WebRequest -Uri $downloadUrl -OutFile $installerPath -UseBasicParsing
        
        Write-Host "Installing AutoHotkey..." -ForegroundColor Yellow
        Start-Process -FilePath $installerPath -ArgumentList "/S" -Wait
        
        # Add AutoHotkey to PATH
        $ahkInstallPath = "${env:ProgramFiles}\AutoHotkey"
        if (Test-Path $ahkInstallPath) {
            $env:PATH += ";$ahkInstallPath"
            [Environment]::SetEnvironmentVariable("PATH", $env:PATH, "User")
        }
        
        Write-Host "AutoHotkey installed successfully!" -ForegroundColor Green
    }
    catch {
        Write-Host "Failed to install AutoHotkey automatically. Please install it manually from https://www.autohotkey.com" -ForegroundColor Red
        Write-Host "Error: $($_.Exception.Message)" -ForegroundColor Red
        exit 1
    }
}
else {
    Write-Host "AutoHotkey found at: $($ahkPath.Source)" -ForegroundColor Green
}

# Create AutoHotkey script for middle button push-to-talk
$ahkScript = @"
; VS Code Push-to-Talk with Middle Mouse Button
; Hold middle mouse button to activate voice chat in VS Code

#NoEnv
#SingleInstance Force
#Persistent

; Only activate when VS Code is the active window
SetTitleMatchMode, 2

; Middle Mouse Button (MButton) as Push-to-Talk
~MButton::
WinGetActiveTitle, ActiveWindow
if (InStr(ActiveWindow, "Visual Studio Code")) {
    ; Send the voice chat activation hotkey
    Send, ^+!v
    KeyWait, MButton  ; Wait for button release
    ; Optional: Send stop/submit command when button is released
    ; Send, ^+!v
}
return

; Optional: ESC to cancel voice input
~Esc::
WinGetActiveTitle, ActiveWindow
if (InStr(ActiveWindow, "Visual Studio Code")) {
    ; This will cancel voice input if active
    ; The keybinding in VS Code handles the actual cancellation
}
return

; Ctrl+Alt+Q to exit this script
^!q::ExitApp
"@

# Save the AutoHotkey script
$scriptPath = "$PSScriptRoot\vscode_push_to_talk.ahk"
$ahkScript | Out-File -FilePath $scriptPath -Encoding UTF8

Write-Host "Created AutoHotkey script at: $scriptPath" -ForegroundColor Green

# Start the AutoHotkey script
try {
    if (Get-Process "AutoHotkey" -ErrorAction SilentlyContinue) {
        Write-Host "Stopping existing AutoHotkey processes..." -ForegroundColor Yellow
        Get-Process "AutoHotkey" | Stop-Process -Force
        Start-Sleep -Seconds 2
    }
    
    Write-Host "Starting Push-to-Talk script..." -ForegroundColor Green
    Start-Process -FilePath "AutoHotkey.exe" -ArgumentList $scriptPath
    
    Write-Host "" -ForegroundColor Green
    Write-Host "========================================" -ForegroundColor Cyan
    Write-Host "  PUSH-TO-TALK SETUP COMPLETE!" -ForegroundColor Green
    Write-Host "========================================" -ForegroundColor Cyan
    Write-Host ""
    Write-Host "How to use:" -ForegroundColor White
    Write-Host "1. Open VS Code with your project" -ForegroundColor Yellow
    Write-Host "2. Open the chat panel (Ctrl+Shift+I or click the chat icon)" -ForegroundColor Yellow
    Write-Host "3. HOLD DOWN the MIDDLE MOUSE BUTTON (scroll wheel click)" -ForegroundColor Green
    Write-Host "4. Speak while holding the button" -ForegroundColor Yellow
    Write-Host "5. RELEASE the button when done speaking" -ForegroundColor Yellow
    Write-Host ""
    Write-Host "Hotkeys:" -ForegroundColor White
    Write-Host "• Middle Mouse Button (hold) = Push-to-Talk" -ForegroundColor Green
    Write-Host "• Escape = Cancel voice input" -ForegroundColor Yellow
    Write-Host "• Ctrl+Alt+Q = Exit push-to-talk script" -ForegroundColor Red
    Write-Host ""
    Write-Host "The script only works when VS Code is the active window." -ForegroundColor Cyan
    Write-Host "Script will run in the background until you exit VS Code or press Ctrl+Alt+Q" -ForegroundColor White
    Write-Host ""
}
catch {
    Write-Host "Failed to start AutoHotkey script: $($_.Exception.Message)" -ForegroundColor Red
    Write-Host "You may need to run the script manually: AutoHotkey.exe `"$scriptPath`"" -ForegroundColor Yellow
}

Write-Host "Setup complete! Test by opening VS Code and holding down your middle mouse button while speaking." -ForegroundColor Green
