# Power BI Theme Validator
# Validates JSON theme files for Power BI compatibility

param(
    [string]$ThemePath = "branding-assets\MCCNO_PowerBI_Theme.json"
)

Write-Host "Power BI Theme Validator" -ForegroundColor Blue
Write-Host "=======================" -ForegroundColor Blue

$FullPath = Join-Path (Get-Location) $ThemePath

if (Test-Path $FullPath) {
    Write-Host "✅ Theme file found: $FullPath" -ForegroundColor Green
    
    try {
        $ThemeContent = Get-Content $FullPath -Raw | ConvertFrom-Json
        Write-Host "✅ JSON syntax is valid" -ForegroundColor Green
        
        # Check required properties for Power BI
        $RequiredProps = @("name", "dataColors")
        $MissingProps = @()
        
        foreach ($Prop in $RequiredProps) {
            if (-not $ThemeContent.PSObject.Properties[$Prop]) {
                $MissingProps += $Prop
            }
        }
        
        if ($MissingProps.Count -eq 0) {
            Write-Host "✅ All required properties present" -ForegroundColor Green
            Write-Host "Theme Name: $($ThemeContent.name)" -ForegroundColor Blue
            Write-Host "Data Colors: $($ThemeContent.dataColors.Count) colors defined" -ForegroundColor Blue
        } else {
            Write-Host "❌ Missing required properties: $($MissingProps -join ', ')" -ForegroundColor Red
        }
        
    } catch {
        Write-Host "❌ JSON syntax error: $($_.Exception.Message)" -ForegroundColor Red
    }
    
} else {
    Write-Host "❌ Theme file not found: $FullPath" -ForegroundColor Red
}

Write-Host ""
Write-Host "Usage in Power BI:" -ForegroundColor Yellow
Write-Host "1. Open Power BI Desktop" -ForegroundColor White
Write-Host "2. View → Themes → Browse for themes" -ForegroundColor White
Write-Host "3. Select: $ThemePath" -ForegroundColor White
Write-Host "4. Click 'Open'" -ForegroundColor White
