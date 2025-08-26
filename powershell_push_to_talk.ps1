# PowerShell Push-to-Talk using Windows Forms
# This creates a simple push-to-talk using the F12 key instead of middle mouse button

Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing

Write-Host "=== VS Code Push-to-Talk Setup ===" -ForegroundColor Green
Write-Host "Starting push-to-talk listener..." -ForegroundColor Yellow
Write-Host ""
Write-Host "Instructions:" -ForegroundColor White
Write-Host "1. Make sure VS Code is open and active" -ForegroundColor Cyan
Write-Host "2. Open the chat panel (Ctrl+Shift+I)" -ForegroundColor Cyan
Write-Host "3. Press and HOLD F12 key while speaking" -ForegroundColor Green
Write-Host "4. Release F12 when done speaking" -ForegroundColor Green
Write-Host "5. Press ESC to exit this script" -ForegroundColor Yellow
Write-Host ""

# Create a form to capture key events
$form = New-Object System.Windows.Forms.Form
$form.Size = New-Object System.Drawing.Size(400, 200)
$form.StartPosition = "CenterScreen"
$form.Text = "VS Code Push-to-Talk Active"
$form.BackColor = [System.Drawing.Color]::DarkGreen
$form.TopMost = $true

# Add label
$label = New-Object System.Windows.Forms.Label
$label.Size = New-Object System.Drawing.Size(380, 180)
$label.Location = New-Object System.Drawing.Point(10, 10)
$label.ForeColor = [System.Drawing.Color]::White
$label.Font = New-Object System.Drawing.Font("Arial", 12, [System.Drawing.FontStyle]::Bold)
$label.TextAlign = [System.Drawing.ContentAlignment]::MiddleCenter
$label.Text = "Push-to-Talk Active`n`nHold F12 to speak`nRelease F12 when done`n`nPress ESC to exit"
$form.Controls.Add($label)

# Variable to track if F12 is pressed
$f12Pressed = $false

# Key event handlers
$form.Add_KeyDown({
    param($sender, $e)
    
    if ($e.KeyCode -eq [System.Windows.Forms.Keys]::F12 -and -not $f12Pressed) {
        $f12Pressed = $true
        $label.Text = "🎤 LISTENING... 🎤`n`nSpeaking now...`nRelease F12 when done`n`nPress ESC to exit"
        $label.BackColor = [System.Drawing.Color]::Red
        
        # Send Ctrl+Shift+Alt+V to VS Code
        [System.Windows.Forms.SendKeys]::SendWait("^+%v")
        
        Write-Host "F12 pressed - Voice input started" -ForegroundColor Green
    }
    elseif ($e.KeyCode -eq [System.Windows.Forms.Keys]::Escape) {
        $form.Close()
    }
})

$form.Add_KeyUp({
    param($sender, $e)
    
    if ($e.KeyCode -eq [System.Windows.Forms.Keys]::F12 -and $f12Pressed) {
        $f12Pressed = $false
        $label.Text = "✅ READY ✅`n`nHold F12 to speak`nRelease F12 when done`n`nPress ESC to exit"
        $label.BackColor = [System.Drawing.Color]::Transparent
        
        Write-Host "F12 released - Voice input should stop" -ForegroundColor Yellow
    }
})

# Set focus and key preview
$form.KeyPreview = $true
$form.Add_Shown({$form.Activate()})

Write-Host "Push-to-Talk window opened. Keep it in focus and use F12 to speak." -ForegroundColor Green

# Show the form
[void]$form.ShowDialog()

Write-Host "Push-to-Talk stopped." -ForegroundColor Red
