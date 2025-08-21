#!/usr/bin/env python3
"""
Simplified Excel Workbook Generator for ConventiCore Inventory Management
Creates a working Excel template with all required sheets and basic formulas
"""

import pandas as pd
from datetime import datetime, timedelta
from pathlib import Path

def create_workbook_csv_templates():
    """Generate CSV templates for all worksheets that can be imported into Excel"""
    
    print("🏗️  Creating Excel Workbook CSV Templates...")
    
    # Create templates directory
    templates_dir = Path("excel_templates")
    templates_dir.mkdir(exist_ok=True)
    
    # 1. Dashboard KPIs (summary data)
    dashboard_data = {
        'Metric': ['Total Revenue', 'Gross Margin %', 'GMROI', 'Sell-Through %', 'Days of Supply', 'Stockout Risk SKUs', 'Shrink %'],
        'Current': [0, 0, 0, 0, 0, 0, 0],
        'Target': [100000, 0.35, 3.0, 0.75, 30, 0, 0.02],
        'Status': ['⚠️', '⚠️', '⚠️', '⚠️', '⚠️', '⚠️', '⚠️'],
        'Formula_Notes': [
            'SUMIF(PnL!A:A,">="&DATE(YEAR(TODAY()),MONTH(TODAY()),1),PnL!E:E)',
            'SUMIF(PnL!A:A,">="&DATE(YEAR(TODAY()),MONTH(TODAY()),1),PnL!F:F)/SUMIF(PnL!A:A,">="&DATE(YEAR(TODAY()),MONTH(TODAY()),1),PnL!E:E)',
            'AVERAGE(PnL!G:G)',
            'AVERAGE(PnL!H:H)', 
            'AVERAGE(Plan_Buy!G:G)',
            'COUNTIFS(ROP_SS!H:H,"<0")',
            'ABS(SUMIF(Shrink!A:A,">="&DATE(YEAR(TODAY()),MONTH(TODAY()),1),Shrink!G:G))'
        ]
    }
    pd.DataFrame(dashboard_data).to_csv(templates_dir / "01_Dashboard.csv", index=False)
    
    # 2. Plan_Buy sheet
    plan_buy_columns = [
        'SKU', 'Description', 'Category', 'Current_Stock', 'Forecast_30d', 
        'Safety_Stock', 'Days_of_Supply', 'ROP', 'Recommended_Order_Qty', 
        'Order_Cost', 'GM_Impact', 'Priority', 'Notes'
    ]
    pd.DataFrame(columns=plan_buy_columns).to_csv(templates_dir / "02_Plan_Buy.csv", index=False)
    
    # 3. ROP_SS sheet with sample calculations
    rop_ss_data = {
        'SKU': ['SKU001', 'SKU002', 'SKU003'],
        'Description': ['Branded Pen', 'Small Shipping Box', 'T-Shirt Large'],
        'Avg_Daily_Demand': [2.5, 1.8, 0.5],
        'Lead_Time_Days': [14, 7, 21],
        'Demand_StdDev': [0.8, 0.6, 0.3],
        'Safety_Stock': [15, 8, 12],
        'ROP': [50, 21, 23],
        'Stock_Available': [150, 75, 25],
        'Days_Until_Stockout': [60, 42, 50],
        'Action_Required': ['OK', 'OK', 'MONITOR']
    }
    pd.DataFrame(rop_ss_data).to_csv(templates_dir / "03_ROP_SS.csv", index=False)
    
    # 4. P&L Analysis sheet
    pnl_columns = [
        'Date', 'SKU', 'Description', 'Category', 'Revenue', 'COGS', 
        'Gross_Margin', 'GMROI', 'Sell_Through', 'Units_Sold', 'Avg_Unit_Price'
    ]
    pd.DataFrame(columns=pnl_columns).to_csv(templates_dir / "04_PnL.csv", index=False)
    
    # 5. Shrink Analysis
    shrink_columns = [
        'Date', 'Checkpoint', 'Location', 'SKU', 'Expected_Qty', 'Counted_Qty', 
        'Variance', 'Shrink_Pct', 'Shrink_Value', 'Category', 'Counter_ID', 'Notes'
    ]
    pd.DataFrame(columns=shrink_columns).to_csv(templates_dir / "05_Shrink.csv", index=False)
    
    # 6. Counts_Entry (canonical counts table)
    counts_entry_columns = [
        'Unique_Key', 'AsOf_Date', 'Checkpoint', 'Location', 'SKU', 
        'Qty', 'UOM', 'Counter_ID', 'Notes', 'Source', 'Submitted_At', 
        'Photo_URL', 'Validated'
    ]
    pd.DataFrame(columns=counts_entry_columns).to_csv(templates_dir / "06_Counts_Entry.csv", index=False)
    
    # 7. Forms_Inbox (Microsoft Forms integration)
    forms_inbox_columns = [
        'Response_ID', 'Submitted_At', 'Checkpoint', 'Location', 'Date_Counted', 
        'SKU', 'Qty', 'UOM', 'Counter_ID', 'Notes', 'Photo', 'Processed'
    ]
    pd.DataFrame(columns=forms_inbox_columns).to_csv(templates_dir / "07_Forms_Inbox.csv", index=False)
    
    # 8. Counts_Manual (manual transcription)
    manual_columns = [
        'Entry_ID', 'Date_Counted', 'Checkpoint', 'Location', 'SKU', 
        'Description', 'Qty', 'UOM', 'Counter_ID', 'Notes', 'Status', 'Validated'
    ]
    manual_template = pd.DataFrame({
        'Entry_ID': ['MANUAL_001', 'MANUAL_002', 'MANUAL_003'],
        'Date_Counted': ['2025-08-20', '', ''],
        'Checkpoint': ['BOM', 'MID', 'EOM'],
        'Location': ['in_store', 'back_of_store', 'in_store'],
        'SKU': ['', '', ''],
        'Description': ['[Auto-populated]', '[Auto-populated]', '[Auto-populated]'],
        'Qty': [0, 0, 0],
        'UOM': ['EA', 'EA', 'EA'],
        'Counter_ID': ['', '', ''],
        'Notes': ['', '', ''],
        'Status': ['Draft', 'Draft', 'Draft'],
        'Validated': [False, False, False]
    })
    manual_template.to_csv(templates_dir / "08_Counts_Manual.csv", index=False)
    
    # 9. Events master data with samples
    events_data = {
        'Event_ID': ['EVT001', 'EVT002', 'EVT003', 'EVT004'],
        'Name': ['Q4 Tech Conference 2025', 'Product Launch', 'Training Workshop', 'Holiday Event'],
        'Venue_Area': ['Main Hall', 'Booth A', 'Room B', 'Main Lobby'],
        'Event_Type': ['Conference', 'Launch', 'Training', 'Customer Event'],
        'Start_DateTime': ['2025-09-15 09:00:00', '2025-09-20 10:00:00', '2025-09-25 08:00:00', '2025-12-15 14:00:00'],
        'End_DateTime': ['2025-09-15 18:00:00', '2025-09-20 16:00:00', '2025-09-25 17:00:00', '2025-12-15 20:00:00'],
        'Est_Attendance': [500, 250, 100, 800],
        'Actual_Attendance': ['', '', '', ''],
        'Status': ['Planned', 'Planned', 'Planned', 'Planned'],
        'Conversion_Rate': ['', '', '', ''],
        'Attach_Rate': ['', '', '', ''],
        'Notes': ['', '', '', '']
    }
    pd.DataFrame(events_data).to_csv(templates_dir / "09_Events.csv", index=False)
    
    # 10. SKU Master Data with samples
    sku_data = {
        'SKU': ['SKU001', 'SKU002', 'SKU003', 'SKU004', 'SKU005', 'SKU006', 'SKU007', 'SKU008', 'SKU009', 'SKU010'],
        'Description': [
            'Branded Pen - Black', 'Small Shipping Box 10x8x6', 'T-Shirt Large Logo',
            'Bubble Wrap Roll 12inch', 'Coffee Mug Ceramic', 'Shipping Labels 4x6 Roll',
            'Polo Shirt Medium', 'Packaging Tape 2inch', 'Notebook Leather', 'Priority Overnight Envelopes'
        ],
        'Category': [
            'Promotional', 'Packaging', 'Apparel', 'Packaging', 'Promotional', 
            'Labels', 'Apparel', 'Packaging', 'Promotional', 'Shipping'
        ],
        'Cost': [0.50, 1.25, 8.00, 15.00, 3.25, 12.50, 18.00, 2.25, 7.50, 0.85],
        'Price': [2.00, 3.50, 25.00, 35.00, 12.00, 28.00, 45.00, 6.50, 18.00, 2.50],
        'Lead_Time_Days': [14, 7, 21, 10, 14, 14, 21, 7, 14, 5],
        'Supplier': ['PromoCorp', 'BoxCo', 'ApparelPlus', 'PackingSupply', 'PromoCorp', 'LabelMaker', 'ApparelPlus', 'PackingSupply', 'PromoCorp', 'ShippingCorp'],
        'UOM': ['EA', 'EA', 'EA', 'ROLL', 'EA', 'ROLL', 'EA', 'ROLL', 'EA', 'EA'],
        'Active': ['Y', 'Y', 'Y', 'Y', 'Y', 'Y', 'Y', 'Y', 'Y', 'Y'],
        'Min_Order_Qty': [100, 50, 25, 10, 48, 20, 25, 12, 24, 100],
        'Notes': ['', '', '', '', '', '', '', '', '', '']
    }
    pd.DataFrame(sku_data).to_csv(templates_dir / "10_SKU.csv", index=False)
    
    # 11. Sales History template
    sales_columns = [
        'Date', 'SKU', 'Units_Sold', 'Revenue', 'Event_ID', 'Channel', 
        'Salesperson', 'Discount_Pct', 'Notes'
    ]
    pd.DataFrame(columns=sales_columns).to_csv(templates_dir / "11_Sales.csv", index=False)
    
    # 12. Audits Archive
    audits_columns = [
        'Audit_ID', 'Date', 'Checkpoint', 'Location', 'SKU', 'Qty', 
        'UOM', 'Counter_ID', 'Auditor', 'Notes', 'Archived_At'
    ]
    pd.DataFrame(columns=audits_columns).to_csv(templates_dir / "12_Audits.csv", index=False)
    
    # 13. Configuration Parameters
    config_data = {
        'Parameter': [
            'Z Service Level', 'Default Lead Time Days', 'Target Days of Supply',
            'Max Cash Per Order', 'Shrink Threshold %', 'Low DoS Warning',
            'Default Event Conversion', 'Default Attach Rate', 
            'Forms Integration Enabled', 'Manual Entry Enabled'
        ],
        'Value': [1.65, 14, 30, 50000, 0.05, 15, 0.15, 1.2, 'TRUE', 'TRUE'],
        'Description': [
            'Standard deviations for safety stock', 'When SKU lead time is missing',
            'Inventory planning horizon', 'Budget constraint per purchase order',
            'Flag shrink above this percentage', 'Days of supply warning threshold',
            'Default event conversion rate', 'Default items per transaction',
            'Enable Microsoft Forms intake', 'Enable manual transcription'
        ]
    }
    pd.DataFrame(config_data).to_csv(templates_dir / "13_Config.csv", index=False)
    
    # 14. Mappings (Conversion & Attach Rates)
    mappings_data = {
        'Mapping_Type': ['conversion', 'conversion', 'conversion', 'conversion', 'conversion', 
                        'attach', 'attach', 'attach', 'attach', 'attach'],
        'Event_Type': ['Conference', 'Launch', 'Training', 'Customer Event', 'Conference',
                      'Conference', 'Launch', 'Training', 'Customer Event', 'Conference'],
        'Category': ['Promotional', 'Promotional', 'Promotional', 'Promotional', 'Apparel',
                    'Promotional', 'Promotional', 'Promotional', 'Promotional', 'Apparel'],
        'Rate_Value': [0.20, 0.35, 0.15, 0.25, 0.10, 1.5, 2.0, 1.3, 2.2, 1.0]
    }
    pd.DataFrame(mappings_data).to_csv(templates_dir / "14_Mappings.csv", index=False)
    
    # 15. Calendar (date spine)
    start_date = datetime.now().date()
    calendar_data = []
    for i in range(365):
        current_date = start_date + timedelta(days=i)
        calendar_data.append({
            'Date': current_date,
            'Day_of_Week': current_date.strftime('%A'),
            'Is_Weekend': 'TRUE' if current_date.weekday() >= 5 else 'FALSE',
            'Is_Holiday': 'FALSE',
            'Holiday_Name': '',
            'Event_Window': 'FALSE',
            'Event_Count': 0,
            'Notes': ''
        })
    pd.DataFrame(calendar_data).to_csv(templates_dir / "15_Calendar.csv", index=False)
    
    # 16. Staging area
    staging_data = {
        'Info': ['STAGING AREA - DO NOT EDIT DIRECTLY'],
        'Description': ['This area is used by Power Query for data transformations']
    }
    pd.DataFrame(staging_data).to_csv(templates_dir / "16_Staging.csv", index=False)
    
    # 17. Exceptions tracking
    exceptions_columns = [
        'Exception_ID', 'Date_Found', 'Source_Sheet', 'Source_Row', 'Exception_Type', 
        'Description', 'Severity', 'Resolution_Required', 'Status', 'Notes'
    ]
    sample_exceptions = {
        'Exception_ID': ['EXC001', 'EXC002'],
        'Date_Found': ['2025-08-20', '2025-08-20'],
        'Source_Sheet': ['Forms_Inbox', 'Counts_Manual'],
        'Source_Row': ['5', '12'],
        'Exception_Type': ['Invalid SKU', 'Duplicate Entry'],
        'Description': ["SKU 'XYZ999' not found in master", 'Same count submitted twice'],
        'Severity': ['HIGH', 'MEDIUM'],
        'Resolution_Required': ['Verify and correct SKU', 'Remove duplicate'],
        'Status': ['OPEN', 'RESOLVED'],
        'Notes': ['Check with counter', 'Kept latest entry']
    }
    pd.DataFrame(sample_exceptions).to_csv(templates_dir / "17_Exceptions.csv", index=False)
    
    return templates_dir

def create_excel_import_instructions():
    """Generate instructions for importing CSV templates into Excel"""
    
    instructions = """
# Excel Workbook Setup Instructions

## Step 1: Create New Excel Workbook
1. Open Excel
2. Create new blank workbook
3. Save as "Event-Inventory-CommandCenter.xlsx"

## Step 2: Import CSV Templates
For each CSV file in the excel_templates folder:

1. **Create New Worksheet**
   - Right-click sheet tab → Insert → Worksheet
   - Rename to match CSV filename (e.g., "Dashboard", "Plan_Buy", etc.)

2. **Import CSV Data**
   - Go to Data tab → Get Data → From File → From Text/CSV
   - Select the CSV file
   - Click "Load" to import data

3. **Format as Table** 
   - Select all data (Ctrl+A)
   - Go to Insert tab → Table
   - Check "My table has headers"
   - Apply table style

4. **Name the Table**
   - Select table → Table Design tab → Table Name
   - Use naming convention: tbl[SheetName] (e.g., tblPlanBuy, tblSKU)

## Step 3: Sheet-Specific Setup

### Dashboard Sheet
- Create charts for KPIs
- Set up conditional formatting for status indicators
- Add slicers for filtering

### Plan_Buy Sheet  
- Add formulas for calculations:
  - Current_Stock: =SUMIFS(Counts_Entry[SKU],[@SKU],Counts_Entry[Qty])
  - Days_of_Supply: =[@Current_Stock]/[@Forecast_30d]*30
  - Priority: =IF([@Current_Stock]<[@ROP],"HIGH","LOW")

### ROP_SS Sheet
- Safety Stock: =Config!$B$1*SQRT([@Demand_StdDev]^2*[@Lead_Time_Days])
- ROP: =[@Avg_Daily_Demand]*[@Lead_Time_Days]+[@Safety_Stock]
- Days_Until_Stockout: =[@Stock_Available]/[@Avg_Daily_Demand]

### Forms_Inbox & Counts_Manual
- Set up data validation dropdowns
- Protect formula cells
- Add conditional formatting for validation status

## Step 4: Power Query Setup (Optional)
1. Go to Data tab → Get Data → Launch Power Query Editor
2. Create queries to merge Forms_Inbox and Counts_Manual into Counts_Entry
3. Set up automatic refresh (Data tab → Refresh All)

## Step 5: Configure Microsoft Forms Integration
1. Create Microsoft Form based on forms_specification.json
2. Set up Power Automate flow to populate Forms_Inbox table
3. Test end-to-end data flow

## Key Formulas Reference

### Dashboard KPIs
- Revenue: =SUMIF(PnL[Date],">="&EOMONTH(TODAY(),-1)+1,PnL[Revenue])
- GM%: =SUMIF(PnL[Date],">="&EOMONTH(TODAY(),-1)+1,PnL[Gross_Margin])/SUMIF(PnL[Date],">="&EOMONTH(TODAY(),-1)+1,PnL[Revenue])
- GMROI: =AVERAGE(PnL[GMROI])
- DoS: =AVERAGE(Plan_Buy[Days_of_Supply])

### Inventory Calculations  
- Safety Stock: =Config!$B$1*SQRT([@Demand_StdDev]^2*[@Lead_Time_Days]+[@Avg_Daily_Demand]^2*1)
- ROP: =[@Avg_Daily_Demand]*[@Lead_Time_Days]+[@Safety_Stock]  
- Order Qty: =MAX(0,[@Target_Stock]-[@Current_Stock])

### P&L Metrics
- GMROI: =[@Gross_Margin]/[@Avg_Inventory_Value]
- Sell-Through: =[@Units_Sold]/([@Current_Stock]+[@Units_Sold])

Remember to:
- Protect formula cells to prevent accidental changes
- Set up data validation to ensure data quality
- Use conditional formatting to highlight exceptions
- Create backup copies before making major changes
- Test all calculations with sample data before going live
"""
    
    return instructions

def main():
    """Generate the complete Excel template system"""
    
    print("🎯 ConventiCore - Convention Events Inventory Management System")
    print("📊 Excel Template Generator")
    print("💡 \"Let's turn stock into profit, not décor\"\n")
    
    # Create CSV templates
    templates_dir = create_workbook_csv_templates()
    print(f"✅ Created {len(list(templates_dir.glob('*.csv')))} CSV templates")
    print(f"📁 Templates saved in: {templates_dir}")
    
    # Create import instructions
    instructions = create_excel_import_instructions()
    instructions_file = Path("Excel_Setup_Instructions.md")
    with open(instructions_file, 'w', encoding='utf-8') as f:
        f.write(instructions)
    print(f"📋 Setup instructions: {instructions_file}")
    
    # Create sample data for testing
    sample_counts_data = [
        {'asof_date': '2025-08-01', 'checkpoint': 'BOM', 'location': 'in_store', 
         'sku': 'SKU001', 'qty': 150, 'uom': 'EA', 'counter_id': 'JD001', 
         'notes': 'Fresh stock from delivery'},
        {'asof_date': '2025-08-01', 'checkpoint': 'BOM', 'location': 'back_of_store',
         'sku': 'SKU001', 'qty': 500, 'uom': 'EA', 'counter_id': 'JD001',
         'notes': 'Reserve inventory'},
        {'asof_date': '2025-08-15', 'checkpoint': 'MID', 'location': 'in_store',
         'sku': 'SKU001', 'qty': 135, 'uom': 'EA', 'counter_id': 'SM002',
         'notes': 'Some sales activity'},
    ]
    
    sample_sales_data = [
        {'date': '2025-08-02', 'sku': 'SKU001', 'units_sold': 12, 'revenue': 24.00, 'event_id': '', 'channel': 'Walk-in'},
        {'date': '2025-08-06', 'sku': 'SKU001', 'units_sold': 15, 'revenue': 30.00, 'event_id': 'EVT002', 'channel': 'Event'},
        {'date': '2025-08-03', 'sku': 'SKU002', 'units_sold': 15, 'revenue': 52.50, 'event_id': '', 'channel': 'Bulk'},
    ]
    
    # Save sample data
    pd.DataFrame(sample_counts_data).to_csv("sample_inventory_counts.csv", index=False)
    pd.DataFrame(sample_sales_data).to_csv("sample_sales_data.csv", index=False)
    
    print("📊 Sample data files created:")
    print("   • sample_inventory_counts.csv")
    print("   • sample_sales_data.csv")
    
    print("\n🚀 Next Steps:")
    print("1. Open Excel and follow the setup instructions")
    print("2. Import CSV templates to create your workbook")
    print("3. Set up Microsoft Forms integration")
    print("4. Load sample data to test calculations")
    print("5. Begin inventory counting operations")
    
    print(f"\n📈 System Components Created:")
    print(f"   • {len(list(templates_dir.glob('*.csv')))} Excel worksheet templates")
    print("   • Setup and import instructions")
    print("   • Sample data for testing")
    print("   • Microsoft Forms integration spec")
    print("   • Operational command controller")
    
    print("\n🎯 Ready for operational deployment!")
    print("Senior Economics & Inventory Strategist — Command Center Online")

if __name__ == "__main__":
    main()
