#  Quick Start Guide - Monthly Inventory Manager

Get up and running with MIM in 5 minutes!

## Prerequisites

-  **Git** (https://git-scm.com/)
-  **Python 3.8+** (https://python.org/)  
-  **Power BI Desktop** (Windows - https://powerbi.microsoft.com/desktop/)

##  5-Minute Setup

### 1. Clone & Navigate
```bash
git clone https://github.com/TexSupport504/monthly-inventory-manager.git
cd monthly-inventory-manager
```

### 2. Run Setup Assistant
**Windows (PowerShell):**
```powershell
.\tools\setup-assistant\setup.ps1
```

**Cross-platform (Python):**
```bash
python tools/setup-assistant/setup.py
```

### 3. Verify Setup
The assistant will:
-  Check prerequisites  
-  Create config files (`.env`, `config.yaml`)
-  Set up directories (`data/`, `reports/`, etc.)
-  Generate sample data
-  Run self-tests

### 4. Start Using MIM

**Generate Excel Reports:**
```bash
python generate_workbook.py
```

**Launch Operations Controller:**
```bash
python ops_controller.py
```

**Power BI Dashboard:**
```bash
cd features/inventory-dashboard
# Follow Power_BI_Setup_Guide.md
```

##  What You Get

After setup, your structure looks like:
```
monthly-inventory-manager/
  features/inventory-dashboard/  # Power BI dashboard
  data/                         # Your inventory data  
  reports/                      # Generated reports
  samples/                      # Sample data to learn
  ops_controller.py             # Main operations
  generate_workbook.py          # Excel generator
```

##  Next Steps

1. ** Read Full Setup:** [docs/guides/setup.md](setup.md)
2. ** Configure Power BI:** [features/inventory-dashboard/Power_BI_Setup_Guide.md](../features/inventory-dashboard/Power_BI_Setup_Guide.md)  
3. ** Need Help?** [docs/guides/troubleshooting.md](troubleshooting.md)

##  Common Commands

```bash
# Run setup again (safe to repeat)
python tools/setup-assistant/setup.py

# Generate monthly report  
python generate_workbook.py

# Check system status
python ops_controller.py --status

# Open Power BI dashboard
cd features/inventory-dashboard
powershell .\Launch_PowerBI_Dashboard.ps1
```

---

** That's it! You're ready to manage inventory like a pro!**

*Need help? Check [troubleshooting.md](troubleshooting.md) or open an issue.*
