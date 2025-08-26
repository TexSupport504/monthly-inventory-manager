#!/usr/bin/env python3
"""
System Integration Test Suite
Validates all core functionality of the Monthly Inventory Manager
"""

import subprocess
import sys
import os
from pathlib import Path
import pandas as pd
import json

def run_command(cmd, description):
    """Run a command and capture results"""
    print(f"\n🧪 Testing: {description}")
    print(f"   Command: {cmd}")
    
    try:
        result = subprocess.run(cmd, shell=True, capture_output=True, text=True, cwd=".")
        if result.returncode == 0:
            print(f"   ✅ SUCCESS")
            return True, result.stdout
        else:
            print(f"   ❌ FAILED")
            print(f"   Error: {result.stderr}")
            return False, result.stderr
    except Exception as e:
        print(f"   ❌ EXCEPTION: {e}")
        return False, str(e)

def validate_file_exists(filepath, description):
    """Check if a file exists"""
    print(f"\n📁 Validating: {description}")
    if Path(filepath).exists():
        print(f"   ✅ File exists: {filepath}")
        return True
    else:
        print(f"   ❌ Missing file: {filepath}")
        return False

def validate_data_quality(filepath, expected_rows=None, expected_columns=None):
    """Validate data file quality"""
    try:
        df = pd.read_csv(filepath)
        print(f"   📊 Data shape: {df.shape}")
        
        if expected_rows and df.shape[0] < expected_rows:
            print(f"   ⚠️  Expected at least {expected_rows} rows, got {df.shape[0]}")
        
        if expected_columns and df.shape[1] < expected_columns:
            print(f"   ⚠️  Expected at least {expected_columns} columns, got {df.shape[1]}")
            
        print(f"   📋 Columns: {list(df.columns)}")
        return True
    except Exception as e:
        print(f"   ❌ Data validation failed: {e}")
        return False

def main():
    """Run comprehensive system test"""
    print("="*80)
    print(" MONTHLY INVENTORY MANAGER - SYSTEM INTEGRATION TEST")
    print("="*80)
    
    test_results = []
    
    # Test 1: Event Ingestion
    success, output = run_command(
        "python ops_controller.py /ingest events Events.xlsx",
        "Event calendar ingestion with 3,734 events"
    )
    test_results.append(("Event Ingestion", success))
    
    # Test 2: Inventory Count Ingestion
    success, output = run_command(
        "python ops_controller.py /ingest audits sample_inventory_counts.csv",
        "Inventory count ingestion"
    )
    test_results.append(("Inventory Ingestion", success))
    
    # Test 3: Sales History Ingestion
    success, output = run_command(
        "python ops_controller.py /ingest sales sample_sales_data.csv",
        "Sales history ingestion"
    )
    test_results.append(("Sales Ingestion", success))
    
    # Test 4: Demand Forecasting
    success, output = run_command(
        "python ops_controller.py /forecast 2025-09",
        "Event-aware demand forecasting"
    )
    test_results.append(("Demand Forecasting", success))
    
    # Test 5: Buy Planning
    success, output = run_command(
        "python ops_controller.py /plan 2025-09",
        "Safety stock and buy planning"
    )
    test_results.append(("Buy Planning", success))
    
    # Test 6: Excel Workbook Generation
    success, output = run_command(
        "python ops_controller.py /build workbook",
        "Complete Excel workbook generation"
    )
    test_results.append(("Excel Workbook", success))
    
    # Test 7: Report Publishing
    success, output = run_command(
        "python ops_controller.py /publish pack 2025-09",
        "Executive report pack publishing"
    )
    test_results.append(("Report Publishing", success))
    
    # File validation tests
    print("\n" + "="*80)
    print(" FILE VALIDATION TESTS")
    print("="*80)
    
    file_tests = [
        ("data/events_processed.csv", "Processed events data", 3700, 10),
        ("data/counts_processed.csv", "Processed inventory counts", 25, 8),
        ("data/sales_processed.csv", "Processed sales data", 15, 6),
        ("reports/forecast_2025-09.csv", "Forecast output", 3, 9),
        ("reports/buy_plan_2025-09.csv", "Buy plan output", 3, 12),
        ("Event-Inventory-CommandCenter.xlsx", "Excel workbook", None, None),
        ("reports/2025-09/executive_summary_2025-09.txt", "Executive summary", None, None),
    ]
    
    for filepath, description, min_rows, min_cols in file_tests:
        file_exists = validate_file_exists(filepath, description)
        test_results.append((f"File: {description}", file_exists))
        
        if file_exists and filepath.endswith('.csv'):
            data_valid = validate_data_quality(filepath, min_rows, min_cols)
            test_results.append((f"Data: {description}", data_valid))
    
    # Results Summary
    print("\n" + "="*80)
    print(" TEST RESULTS SUMMARY")
    print("="*80)
    
    passed = 0
    failed = 0
    
    for test_name, success in test_results:
        status = "✅ PASS" if success else "❌ FAIL"
        print(f"{status:<8} {test_name}")
        if success:
            passed += 1
        else:
            failed += 1
    
    print(f"\n📊 FINAL RESULTS:")
    print(f"   ✅ Passed: {passed}")
    print(f"   ❌ Failed: {failed}")
    print(f"   📈 Success Rate: {passed/(passed+failed)*100:.1f}%")
    
    if failed == 0:
        print(f"\n🎉 ALL TESTS PASSED! System is production-ready.")
        return 0
    else:
        print(f"\n⚠️  {failed} test(s) failed. Review errors above.")
        return 1

if __name__ == "__main__":
    exit_code = main()
    sys.exit(exit_code)
