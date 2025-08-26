#!/usr/bin/env python3
"""
Monthly Inventory Manager - Setup Assistant (Python)
Cross-platform setup script with friendly guidance
"""

import os
import sys
import subprocess
import shutil
from pathlib import Path

def print_banner():
    print("\n" + "="*60)
    print(" Monthly Inventory Manager (MIM) Setup Assistant")
    print("="*60)
    print("Welcome! This will set up MIM quickly and safely.")
    print("")

def check_prerequisites():
    print("[1/6] Checking Prerequisites...")
    issues = []
    
    # Check Python version
    if sys.version_info < (3, 8):
        issues.append(f"Python {sys.version_info.major}.{sys.version_info.minor} found, but 3.8+ required")
    else:
        print(f" Python {sys.version_info.major}.{sys.version_info.minor} OK")
    
    # Check Git
    try:
        result = subprocess.run(["git", "--version"], capture_output=True, text=True)
        print(f" Git found: {result.stdout.strip()}")
    except FileNotFoundError:
        issues.append("Git not found. Install from: https://git-scm.com/")
    
    if issues:
        print("\n Issues found:")
        for issue in issues:
            print(f"   {issue}")
        return False
    
    print(" All prerequisites satisfied!")
    return True

def create_directories():
    print("\n[2/6] Creating directories...")
    directories = [
        "data", "logs", "reports", "samples", "tests",
        "docs/guides", ".github/ISSUE_TEMPLATE",
        "features/data-connectors", "features/etl-transform",
        "features/report-pack", "features/cli-automation"
    ]
    
    for directory in directories:
        path = Path(directory)
        if not path.exists():
            path.mkdir(parents=True, exist_ok=True)
            print(f" Created: {directory}")
        else:
            print(f" Exists: {directory}")

def create_config():
    print("\n[3/6] Creating configuration...")
    
    # Create .env file
    if not Path(".env").exists():
        env_content = """# Monthly Inventory Manager Configuration
DATABASE_TYPE=sqlite
DATABASE_PATH=./data/inventory.db
POWERBI_WORKSPACE=
LOG_LEVEL=INFO
DEBUG_MODE=false
"""
        with open(".env", "w") as f:
            f.write(env_content)
        print(" Created .env configuration")
    
    # Create config.yaml
    if not Path("config.yaml").exists():
        config_content = """# Monthly Inventory Manager Configuration
app:
  name: "Monthly Inventory Manager"
  version: "0.1.0"
  environment: "development"

features:
  inventory_dashboard: true
  data_connectors: true
  etl_transform: true
  report_pack: true
  cli_automation: true
"""
        with open("config.yaml", "w") as f:
            f.write(config_content)
        print(" Created config.yaml")

def seed_sample_data():
    print("\n[4/6] Creating sample data...")
    
    samples_dir = Path("samples")
    samples_dir.mkdir(exist_ok=True)
    
    # Sample inventory
    inventory_data = """Date,SKU,Product,Category,Quantity,Unit_Cost,Unit_Price,Location
2025-08-01,SKU001,Branded Pen Black,Office,150,0.50,2.00,Warehouse-A
2025-08-01,SKU002,Coffee Mug Ceramic,Promotional,75,3.25,12.00,Warehouse-A
2025-08-01,SKU003,T-Shirt Large,Apparel,50,8.00,25.00,Warehouse-B"""
    
    with open("samples/sample_inventory.csv", "w") as f:
        f.write(inventory_data)
    print(" Created sample inventory data")
    
    # Sample sales
    sales_data = """Date,SKU,Units_Sold,Revenue,Channel
2025-08-02,SKU001,12,24.00,Walk-in
2025-08-02,SKU003,3,75.00,Walk-in
2025-08-03,SKU001,5,10.00,Online"""
    
    with open("samples/sample_sales.csv", "w") as f:
        f.write(sales_data)
    print(" Created sample sales data")

def run_tests():
    print("\n[5/6] Running self-tests...")
    tests_passed = 0
    total_tests = 3
    
    # Test 1: Config files exist
    if Path(".env").exists() and Path("config.yaml").exists():
        print(" Configuration files exist")
        tests_passed += 1
    else:
        print(" Missing configuration files")
    
    # Test 2: Sample data exists
    if Path("samples/sample_inventory.csv").exists():
        print(" Sample data created")
        tests_passed += 1
    else:
        print(" Sample data missing")
    
    # Test 3: Directory structure
    required_dirs = ["data", "reports", "features/inventory-dashboard"]
    if all(Path(d).exists() for d in required_dirs):
        print(" Directory structure correct")
        tests_passed += 1
    else:
        print(" Missing directories")
    
    print(f"\n Tests: {tests_passed}/{total_tests} passed")
    return tests_passed == total_tests

def show_next_steps():
    print("\n[6/6] Next Steps")
    print("\n Setup Complete! Here's what to do next:")
    print("\n1.  Power BI Dashboard:")
    print("   cd features/inventory-dashboard")
    print("   # Follow Power_BI_Setup_Guide.md")
    print("\n2.  Run MIM:")
    print("   python ops_controller.py")
    print("\n3.  Documentation:")
    print("   docs/guides/quickstart.md")
    print("   docs/guides/setup.md")
    print("\n Happy inventory managing!")

def main():
    print_banner()
    
    if not check_prerequisites():
        print("\n  Prerequisites not met. Please install required software and try again.")
        sys.exit(1)
    
    create_directories()
    create_config()
    seed_sample_data()
    
    if run_tests():
        print("\n All tests passed!")
    else:
        print("\n  Some tests failed. Check the output above.")
    
    show_next_steps()
    print("\n Setup Assistant completed successfully!")

if __name__ == "__main__":
    main()
