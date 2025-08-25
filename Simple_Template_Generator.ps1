# Dashboard Template Generator - Creates reusable project structures
param(
    [Parameter(Mandatory=$true)]
    [string]$ProjectName,
    
    [Parameter(Mandatory=$true)] 
    [string]$ClientName,
    
    [string]$OutputPath = "D:\OneDrive\Documents\GitHub",
    [string]$BrandColors = "#003366,#FFB500,#F5F5F0",
    [string]$DataSource = "Excel",
    [string]$DashboardType = "Executive"
)

Write-Host "Dashboard Template Generator v2.0" -ForegroundColor Blue
Write-Host "==================================" -ForegroundColor Blue

$ProjectPath = Join-Path $OutputPath "$ProjectName-dashboard-powerbi"
$Colors = $BrandColors -split ","

# Create folder structure
Write-Host "Creating project structure for $ClientName..." -ForegroundColor Yellow

$Folders = @(
    "branding-assets",
    "sample-data", 
    "dashboard-files\Generated_Components",
    "documentation",
    "data-source",
    "templates",
    "scripts"
)

New-Item -ItemType Directory -Path $ProjectPath -Force | Out-Null

foreach ($Folder in $Folders) {
    $FolderPath = Join-Path $ProjectPath $Folder
    New-Item -ItemType Directory -Path $FolderPath -Force | Out-Null
}

Write-Host "✅ Created project structure" -ForegroundColor Green

# Generate .gitignore
$GitIgnore = @"
# Power BI Files
*.pbix
*.pbit
~*.pbix
*.tmp

# Data Files  
*.xlsx
*.xls
*.csv
*.json

# Logs
*.log

# Windows
Thumbs.db
Desktop.ini

# VS Code
.vscode/
"@

$GitIgnore | Out-File -FilePath (Join-Path $ProjectPath ".gitignore") -Encoding UTF8

Write-Host "✅ Generated .gitignore" -ForegroundColor Green

# Generate project README
$ReadMe = @"
# $ClientName Executive Dashboard

## 🎯 Quick Start
1. Run: ``.\Launch_PowerBI_Dashboard.ps1``  
2. Follow: ``IMPLEMENTATION_CHECKLIST.md``
3. Setup time: 15 minutes

## 🎨 Brand Colors
- Primary: $($Colors[0])
- Secondary: $($Colors[1])  
- Neutral: $($Colors[2])

## 📊 Dashboard Pages
1. Executive Overview
2. Business Impact Analysis
3. Operational Intelligence  
4. Financial Performance

## 🛠️ Generated Components
- DAX measures ready to paste
- Power Query transformations
- Layout specifications
- Brand theme files

*Ready to transform $ClientName data into strategic advantage!*
"@

$ReadMe | Out-File -FilePath (Join-Path $ProjectPath "README.md") -Encoding UTF8

Write-Host "✅ Generated README.md" -ForegroundColor Green

# Create master template creation script
$MasterTemplate = @"
# Master Dashboard Creation Script
# Run this in any new client project folder

param(
    [string]`$ClientName = "$ClientName",
    [string]`$ProjectPath = (Get-Location).Path
)

Write-Host "Creating `$ClientName Dashboard Components..." -ForegroundColor Blue

# Copy this entire MCCNO project structure as base template
# Then customize for specific client needs

Write-Host "Dashboard template ready for `$ClientName!" -ForegroundColor Green
"@

$MasterTemplate | Out-File -FilePath (Join-Path $ProjectPath "scripts\Create_Client_Dashboard.ps1") -Encoding UTF8

Write-Host "✅ Generated master template script" -ForegroundColor Green

# Initialize git
Set-Location $ProjectPath
git init 2>$null | Out-Null
git add . 2>$null | Out-Null
git commit -m "Initial template for $ClientName dashboard" 2>$null | Out-Null

Write-Host ""
Write-Host "🎉 TEMPLATE CREATED!" -ForegroundColor Green
Write-Host "Project: $ProjectPath" -ForegroundColor Blue
Write-Host "Client: $ClientName" -ForegroundColor Blue
Write-Host ""
Write-Host "Next steps:" -ForegroundColor Yellow
Write-Host "1. cd `"$ProjectPath`"" -ForegroundColor White  
Write-Host "2. Copy MCCNO components" -ForegroundColor White
Write-Host "3. Customize for $ClientName" -ForegroundColor White
