# Excel Power Query Setup Instructions

## Connecting CSV Data Sources

### FIRST: Clean Up Auto-Created Sheets

If Excel already created new sheets with your data:
1. **Right-click on each auto-created sheet** (like "events_processed", "sales_processed", etc.)
2. **Select "Delete"** to remove them
3. **Or rename them** if you want to keep the data temporarily

### Step-by-Step Process:

1. **Open Event-Inventory-CommandCenter.xlsx**

2. **For Each Data Sheet (Events, Sales, Counts_Entry):**
   - Click on the **existing** sheet tab (not a new one)
   - **Click on cell A1** in that sheet
   - Go to Data Tab → Get Data → From File → From Text/CSV
   - Navigate to the corresponding CSV file:
     - Events sheet → data\events_processed.csv
     - Sales sheet → data\sales_processed.csv  
     - Counts_Entry sheet → data\counts_processed.csv
   - Click "Transform Data" to open Power Query Editor
   - Verify column types and formatting
   - **IMPORTANT**: Click "Close & Load To..." (not just "Close & Load")
   - Select **"Existing worksheet"** 
   - Confirm it shows **$A$1** as the location
   - Click **OK**

3. **Set Up Automatic Refresh:**
   - Data Tab → Queries & Connections
   - Right-click each query → Properties
   - Check "Refresh data when opening the file"
   - Set refresh interval (e.g., every 60 minutes)

4. **Verify Dashboard Calculations:**
   - Navigate to Dashboard sheet
   - Verify KPIs are calculating correctly
   - Check that formulas reference the correct data ranges

## Key Formulas in Dashboard:

- **Total Revenue**: `=SUMIF(PnL!A:A,">"&DATE(YEAR(TODAY()),MONTH(TODAY()),1),PnL!E:E)`
- **Gross Margin %**: `=SUMIF(PnL!A:A,">"&DATE(YEAR(TODAY()),MONTH(TODAY()),1),PnL!F:F)/SUMIF(PnL!A:A,">"&DATE(YEAR(TODAY()),MONTH(TODAY()),1),PnL!E:E)`
- **Days of Supply**: `=AVERAGE(Plan_Buy!G:G)`
- **Stockout Risk**: `=COUNTIFS(ROP_SS!H:H,"<0")`

## Operational Workflow:

1. **Daily**: Check Dashboard for alerts
2. **Weekly**: Review buy recommendations in Plan_Buy sheet  
3. **Monthly**: Run Python system to refresh forecasts
4. **As Needed**: Enter inventory counts in Counts_Entry or Forms_Inbox

## Troubleshooting:

- If formulas show #REF! errors, verify data connections are active
- If KPIs show 0 or #DIV/0!, ensure source data has been loaded
- Use Data → Refresh All to update all connections

Generated: $(Get-Date)
