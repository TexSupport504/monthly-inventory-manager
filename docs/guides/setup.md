#  Setup Guide - Monthly Inventory Manager

Comprehensive setup instructions for all environments and use cases.

## Overview

Monthly Inventory Manager (MIM) is a comprehensive inventory management solution with:
-  **Power BI Dashboard** - Executive reporting and analytics
-  **Excel Integration** - Automated workbook generation  
-  **Data Connectors** - Import from multiple sources
-  **CLI Automation** - Batch processing and scheduling

## System Requirements

### Minimum Requirements
- **OS**: Windows 10/11, macOS 10.15+, or Linux (Ubuntu 18.04+)
- **Python**: 3.8 or higher
- **RAM**: 4GB minimum, 8GB recommended
- **Storage**: 2GB free space

### Software Dependencies
- **Git** - Version control
- **Python 3.8+** - Core runtime  
- **Power BI Desktop** - Dashboard creation (Windows only)
- **Node.js** - Optional, for web features

##  Installation Methods

### Method 1: Setup Assistant (Recommended)

The setup assistant handles everything automatically:

**Windows:**
```powershell
# Clone repository
git clone https://github.com/TexSupport504/monthly-inventory-manager.git
cd monthly-inventory-manager

# Run assistant
.\tools\setup-assistant\setup.ps1

# Optional flags:
.\tools\setup-assistant\setup.ps1 -QuickMode       # Minimal prompts
.\tools\setup-assistant\setup.ps1 -Help           # Show help
```

**macOS/Linux:**
```bash
# Clone repository  
git clone https://github.com/TexSupport504/monthly-inventory-manager.git
cd monthly-inventory-manager

# Run assistant
python tools/setup-assistant/setup.py
```

### Method 2: Manual Setup

If you prefer manual control:

1. **Clone Repository:**
   ```bash
   git clone https://github.com/TexSupport504/monthly-inventory-manager.git
   cd monthly-inventory-manager
   ```

2. **Install Python Dependencies:**
   ```bash
   pip install -r requirements.txt
   ```

3. **Create Configuration:**
   ```bash
   cp .env.example .env
   # Edit .env with your settings
   ```

4. **Initialize Directories:**
   ```bash
   mkdir -p data logs reports samples tests
   ```

5. **Verify Installation:**
   ```bash
   python -c "import pandas, openpyxl; print('Dependencies OK')"
   ```

##  Directory Structure

After setup, your project structure will be:

```
monthly-inventory-manager/
  features/                     # Feature modules
    inventory-dashboard/         # Power BI dashboard
    data-connectors/             # Import/export tools  
    etl-transform/               # Data transformation
    report-pack/                 # Report generators
    cli-automation/              # Automation scripts
  tools/                        # Utilities
    setup-assistant/             # Setup scripts
  data/                         # Your data files
  reports/                      # Generated reports
  samples/                      # Sample data
  docs/                         # Documentation
  tests/                        # Unit tests
  .env                          # Environment config
  config.yaml                   # Application config  
  ops_controller.py             # Main controller
  generate_workbook.py          # Excel generator
```

##  Configuration

### Environment Variables (.env)

```ini
# Database Configuration
DATABASE_TYPE=sqlite
DATABASE_PATH=./data/inventory.db

# Power BI Integration
POWERBI_WORKSPACE=your-workspace-name
POWERBI_DATASET_ID=your-dataset-id

# File Paths
DATA_DIR=./data
REPORTS_DIR=./reports
TEMPLATES_DIR=./excel_templates

# Features
ENABLE_WEB_INTERFACE=true
ENABLE_AUTO_REFRESH=false
ENABLE_EMAIL_REPORTS=false

# Logging
LOG_LEVEL=INFO
DEBUG_MODE=false
```

### Application Config (config.yaml)

```yaml
app:
  name: "Monthly Inventory Manager"
  version: "0.1.0" 
  environment: "development"

data:
  primary_database: "./data/inventory.db"
  backup_enabled: true

powerbi:
  enabled: true
  workspace_name: ""
  auto_refresh: true

features:
  inventory_dashboard: true
  data_connectors: true
  etl_transform: true
  report_pack: true
  cli_automation: true
```

##  Power BI Setup

Detailed Power BI configuration is in the dashboard feature:

```bash
cd features/inventory-dashboard
# Follow Power_BI_Setup_Guide.md
```

Key steps:
1. Install Power BI Desktop
2. Configure MCCNO theme  
3. Import sample data
4. Set up DAX measures
5. Configure Multi KPI visual

##  Testing Your Setup

Run the built-in tests:

```bash
# Quick system check
python -c "
import os, sys
print(f'Python: {sys.version}')
print(f'Working Dir: {os.getcwd()}')  
print(f'Config Exists: {os.path.exists(\".env\")}')
"

# Run sample data generation
python generate_workbook.py --test

# Validate Power BI connection
cd features/inventory-dashboard
powershell .\Validate_Theme.ps1
```

##  First Run

1. **Generate Sample Report:**
   ```bash
   python generate_workbook.py
   # Creates: reports/Monthly_Inventory_Report_YYYY-MM-DD.xlsx
   ```

2. **Launch Operations Controller:**
   ```bash
   python ops_controller.py
   # Interactive menu system
   ```

3. **Open Power BI Dashboard:**
   ```bash
   cd features/inventory-dashboard  
   powershell .\Launch_PowerBI_Dashboard.ps1
   ```

##  Customization

### Adding Data Sources

1. Place CSV files in `data/` directory
2. Update `config.yaml` with new source paths
3. Modify `ops_controller.py` to include new sources

### Custom Reports

1. Create templates in `excel_templates/`
2. Add report logic to `generate_workbook.py`  
3. Configure output in `.env`

### Power BI Themes

1. Edit `features/inventory-dashboard/branding-assets/MCCNO_PowerBI_Theme.json`
2. Run `features/inventory-dashboard/Validate_Theme.ps1`
3. Apply theme in Power BI Desktop

##  Additional Resources

- ** Quick Start**: [quickstart.md](quickstart.md)
- ** Troubleshooting**: [troubleshooting.md](troubleshooting.md)  
- ** Power BI Guide**: [../features/inventory-dashboard/Power_BI_Setup_Guide.md](../features/inventory-dashboard/Power_BI_Setup_Guide.md)
- ** API Documentation**: [../features/inventory-dashboard/documentation/](../features/inventory-dashboard/documentation/)

##  Getting Help

1. **Check troubleshooting guide** first
2. **Search existing issues** on GitHub
3. **Open a new issue** with details:
   - OS and Python version
   - Error messages  
   - Steps to reproduce
   - Configuration (without secrets)

---

** You're all set! Happy inventory managing!**
