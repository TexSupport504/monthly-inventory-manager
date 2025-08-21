
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
