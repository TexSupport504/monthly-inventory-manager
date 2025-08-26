#  Troubleshooting Guide - Monthly Inventory Manager

Common issues and solutions for MIM setup and operation.

##  Setup Issues

### Setup Assistant Fails

**Problem**: Setup assistant exits with errors
**Solutions**:
```bash
# Run with detailed output
python tools/setup-assistant/setup.py --verbose

# Skip prerequisites check  
.\tools\setup-assistant\setup.ps1 -SkipPrerequisites

# Manual directory creation
mkdir data logs reports samples tests
```

### Python Import Errors

**Problem**: `ModuleNotFoundError` when running scripts
**Solutions**:
```bash
# Install requirements
pip install -r requirements.txt

# Check Python version
python --version  # Must be 3.8+

# Virtual environment (recommended)
python -m venv venv
# Windows:
venv\Scripts\activate  
# macOS/Linux:
source venv/bin/activate
pip install -r requirements.txt
```

### Permission Errors

**Problem**: Cannot create files/directories
**Solutions**:
```bash
# Windows - Run as Administrator
# macOS/Linux - Check permissions
chmod 755 .
ls -la  # Check ownership

# Alternative data directory
mkdir ~/mim-data
# Edit .env: DATA_DIR=~/mim-data
```

##  Power BI Issues

### Power BI Desktop Not Found

**Problem**: Setup can't find Power BI Desktop
**Solutions**:
1. **Install Power BI Desktop**: https://powerbi.microsoft.com/desktop/
2. **Check installation paths**:
   ```powershell
   # Common locations:
   Test-Path "C:\Program Files\Microsoft Power BI Desktop\bin\PBIDesktop.exe"
   Test-Path "C:\Program Files (x86)\Microsoft Power BI Desktop\bin\PBIDesktop.exe"
   ```

### DAX Measure Errors

**Problem**: GMROI or other measures showing errors
**Solutions**:
```dax
// Fix GMROI calculation
GMROI = 
AVERAGEX(
    VALUES(sales_sample[sku]),
    DIVIDE(
        SUM(sales_sample[gross_margin]),
        AVERAGE(inventory_sample[cost])
    )
)

// Fix Critical Stock Level  
Critical_Stock_Level = 
CALCULATE(
    COUNT(inventory_sample[sku]),
    inventory_sample[qty] < inventory_sample[reorder_point]
)
```

### Multi KPI Visual Issues

**Problem**: Multi KPI visual not displaying values
**Solutions**:
1. **Add Date Field**: Drag `start_dt` from events_sample to Date well
2. **Check Values Settings**: Format  Values  Display Units = "None"
3. **Enable KPI Toggles**: Format  KPI  Name/Value/Variance = ON

### Theme Not Loading

**Problem**: MCCNO theme doesn't apply
**Solutions**:
```powershell
# Validate theme file
cd features/inventory-dashboard
.\Validate_Theme.ps1

# Manual theme application
# 1. Open Power BI Desktop
# 2. View  Themes  Browse for themes
# 3. Select: branding-assets/MCCNO_PowerBI_Theme.json
```

##  Data Issues

### CSV Import Errors

**Problem**: Cannot read CSV files
**Solutions**:
```python
# Check file encoding
import pandas as pd
df = pd.read_csv('data/inventory.csv', encoding='utf-8-sig')

# Check file format
head -5 data/inventory.csv  # Linux/macOS
Get-Content data/inventory.csv -Head 5  # Windows

# Common fixes:
# - Save CSV as UTF-8
# - Remove BOM (Byte Order Mark)  
# - Check column names match expected format
```

### Database Connection Errors

**Problem**: SQLite database issues
**Solutions**:
```bash
# Check database exists
ls -la data/inventory.db

# Test connection
python -c "
import sqlite3
conn = sqlite3.connect('data/inventory.db')
print('Connection OK')
conn.close()
"

# Recreate database
rm data/inventory.db  # Remove old database
python ops_controller.py --init-db  # Recreate
```

### Sample Data Missing

**Problem**: No sample data after setup
**Solutions**:
```bash
# Regenerate sample data
python tools/setup-assistant/setup.py

# Manual sample creation
mkdir samples
cat > samples/sample_inventory.csv << EOF
Date,SKU,Product,Quantity,Cost,Price
2025-08-01,SKU001,Test Product,100,5.00,10.00
EOF
```

##  Runtime Issues

### Excel Generation Fails

**Problem**: `generate_workbook.py` exits with errors
**Solutions**:
```python
# Check openpyxl installation
pip install openpyxl xlsxwriter

# Test Excel creation
python -c "
import pandas as pd
df = pd.DataFrame({'test': [1,2,3]})
df.to_excel('test.xlsx')
print('Excel write OK')
"

# Check permissions
touch reports/test.xlsx  # Linux/macOS  
echo "test" > reports/test.xlsx  # Windows
```

### Operations Controller Issues

**Problem**: `ops_controller.py` menu not working
**Solutions**:
```bash
# Run with debug mode
python ops_controller.py --debug

# Check configuration
python -c "
import os
print(f'Config exists: {os.path.exists(\".env\")}')
print(f'Data dir: {os.path.exists(\"data\")}')
"

# Reset configuration
cp .env.example .env
python tools/setup-assistant/setup.py
```

##  Network/GitHub Issues

### Git Clone Fails

**Problem**: Cannot clone repository
**Solutions**:
```bash
# HTTPS instead of SSH
git clone https://github.com/TexSupport504/monthly-inventory-manager.git

# Check network/proxy
curl -I https://github.com

# Alternative: Download ZIP
# Go to: https://github.com/TexSupport504/monthly-inventory-manager
# Click: Code  Download ZIP
```

### Subtree Merge Issues

**Problem**: Git subtree command fails
**Solutions**:
```bash
# Update Git (minimum 2.20+)
git --version

# Alternative merge method
git remote add inventory-dashboard ../inventory-dashboard-powerbi
git fetch inventory-dashboard  
git merge --allow-unrelated-histories inventory-dashboard/master
mkdir -p features/inventory-dashboard
git mv [files] features/inventory-dashboard/
```

##  Environment-Specific Issues

### Windows Issues

```powershell
# Execution policy for PowerShell scripts
Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser

# Long path support  
git config --global core.longpaths true

# Character encoding
$env:PYTHONIOENCODING="utf-8"
```

### macOS Issues

```bash
# Xcode command line tools
xcode-select --install

# Python path issues
which python3
alias python=python3  # Add to ~/.zshrc

# Permission issues with homebrew
sudo chown -R $(whoami) /usr/local/lib/python3.*/site-packages
```

### Linux Issues

```bash
# Install Python dev headers
sudo apt update
sudo apt install python3-dev python3-pip

# SQLite issues
sudo apt install sqlite3 libsqlite3-dev

# Excel library dependencies
pip install --upgrade setuptools wheel
```

##  Debugging Tools

### Diagnostic Commands

```bash
# System information
python --version
git --version  
pip list | grep -E "(pandas|openpyxl|sqlite)"

# MIM status check
python -c "
import os, sys, sqlite3
print(f'Python: {sys.version}')
print(f'Working directory: {os.getcwd()}')
print(f'Config file: {os.path.exists(\".env\")}')
print(f'Data directory: {os.path.exists(\"data\")}')
print(f'Features directory: {os.path.exists(\"features\")}')
try:
    conn = sqlite3.connect(':memory:')  
    print('SQLite: OK')
except:
    print('SQLite: ERROR')
"
```

### Log Analysis

```bash
# Check logs
tail -50 logs/mim.log  # Linux/macOS
Get-Content logs/mim.log -Tail 50  # Windows

# Enable debug logging
# Edit .env: LOG_LEVEL=DEBUG
python ops_controller.py
```

##  Getting Additional Help

### Before Opening an Issue

1.  **Run diagnostic commands** above
2.  **Check existing issues**: https://github.com/TexSupport504/monthly-inventory-manager/issues  
3.  **Try setup assistant again**: Often fixes configuration issues

### Issue Report Template

When opening an issue, include:

```
## Environment
- OS: [Windows 10/11, macOS version, Linux distro]
- Python: [python --version]
- Git: [git --version]

## Problem
[Clear description of what's not working]

## Steps to Reproduce
1. [Step 1]
2. [Step 2] 
3. [Error occurs]

## Expected vs Actual
Expected: [What should happen]
Actual: [What actually happens]

## Diagnostic Output
[Paste output from diagnostic commands above]

## Configuration
[Paste .env contents, removing any secrets]
```

### Community Resources

-  **Documentation**: Check all guides in `docs/guides/`
-  **Power BI Help**: `features/inventory-dashboard/documentation/`
-  **Discussions**: GitHub Discussions (if enabled)
-  **Bug Reports**: GitHub Issues

---

** Still stuck? Don't hesitate to open an issue with the template above!**
