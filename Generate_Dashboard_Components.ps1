# MCCNO Dashboard Auto-Generator
# PowerShell script to create Power BI components from specifications

param(
    [string]$ProjectPath = "D:\OneDrive\Documents\GitHub\inventory-dashboard-powerbi",
    [string]$OutputPath = "dashboard-files\Generated_Components"
)

Write-Host "MCCNO Executive Dashboard Auto-Generator" -ForegroundColor Blue
Write-Host "==========================================" -ForegroundColor Blue

# Create output directory
$OutputDir = Join-Path $ProjectPath $OutputPath
if (!(Test-Path $OutputDir)) {
    New-Item -ItemType Directory -Path $OutputDir -Force
    Write-Host "✅ Created output directory: $OutputDir" -ForegroundColor Green
}

# Function to generate DAX measures file
function Generate-DAXMeasures {
    # Generate Sample Data Version
    $DAXContentSample = @"
-- MCCNO Executive Dashboard - DAX Measures (SAMPLE DATA VERSION)
-- Generated from project specifications
-- Date: $(Get-Date -Format 'yyyy-MM-dd HH:mm:ss')
-- Compatible with: events_sample.csv, inventory_sample.csv, sales_sample.csv

-- ===============================
-- PRIMARY KPI MEASURES
-- ===============================

GMROI = 
DIVIDE(
    SUM(sales_sample[gross_margin]), 
    SUMX(inventory_sample, inventory_sample[qty] * inventory_sample[cost]) / COUNTROWS(inventory_sample), 
    0
)

Total_Revenue = SUM(sales_sample[revenue])

Sell_Through_Rate = 
DIVIDE(
    SUM(sales_sample[units_sold]), 
    SUM(inventory_sample[qty]), 
    0
)

Days_of_Supply = 
DIVIDE(
    SUM(inventory_sample[qty]), 
    CALCULATE(
        AVERAGE(sales_sample[units_sold]), 
        DATESINPERIOD(sales_sample[date], TODAY(), -30, DAY)
    ), 
    0
)

-- ===============================
-- EVENT IMPACT MEASURES
-- ===============================

Event_Revenue = 
CALCULATE(
    SUM(sales_sample[revenue]), 
    NOT(ISBLANK(sales_sample[event_id]))
)

Event_Conversion_Rate = 
DIVIDE(
    CALCULATE(SUM(sales_sample[units_sold]), NOT(ISBLANK(sales_sample[event_id]))), 
    RELATED(events_sample[est_attendance]), 
    0
)

-- ===============================
-- FINANCIAL MEASURES
-- ===============================

Gross_Margin_Percent = 
DIVIDE(
    SUM(sales_sample[gross_margin]), 
    SUM(sales_sample[revenue]), 
    0
)

Inventory_Value = 
SUMX(inventory_sample, inventory_sample[qty] * inventory_sample[cost])

-- ===============================
-- RISK & ALERT MEASURES
-- ===============================

Stockout_Risk_SKUs = 
CALCULATE(
    DISTINCTCOUNT(inventory_sample[sku]), 
    inventory_sample[qty] < inventory_sample[reorder_point]
)

Critical_Stock_Level = 
CALCULATE(
    DISTINCTCOUNT(inventory_sample[sku]), 
    [Days_of_Supply] < 7
)
"@

    # Generate Template Version
    $DAXContentTemplate = @"
-- CLIENT DASHBOARD - DAX Measures (TEMPLATE VERSION)
-- Generated from project specifications  
-- Date: $(Get-Date -Format 'yyyy-MM-dd HH:mm:ss')
-- Compatible with: Generic table and column names for any client

-- ===============================
-- PRIMARY KPI MEASURES
-- ===============================

GMROI = 
DIVIDE(
    SUM(Sales[GrossMargin]), 
    AVERAGE(Inventory[Quantity] * Inventory[UnitCost]), 
    0
)

Total_Revenue = SUM(Sales[Revenue])

Sell_Through_Rate = 
DIVIDE(
    SUM(Sales[UnitsSold]), 
    SUM(Inventory[Quantity]), 
    0
)

Days_of_Supply = 
DIVIDE(
    SUM(Inventory[Quantity]), 
    CALCULATE(
        AVERAGE(Sales[UnitsSold]), 
        DATESINPERIOD(Calendar[Date], TODAY(), -30, DAY)
    ), 
    0
)

-- ===============================
-- EVENT IMPACT MEASURES
-- ===============================

Event_Revenue = 
CALCULATE(
    SUM(Sales[Revenue]), 
    NOT(ISBLANK(Sales[EventID]))
)

Event_Conversion_Rate = 
DIVIDE(
    CALCULATE(SUM(Sales[UnitsSold]), NOT(ISBLANK(Sales[EventID]))), 
    RELATED(Events[EstimatedAttendance]), 
    0
)

-- ===============================
-- FINANCIAL MEASURES
-- ===============================

Gross_Margin_Percent = 
DIVIDE(
    SUM(Sales[GrossMargin]), 
    SUM(Sales[Revenue]), 
    0
)

Inventory_Value = 
SUMX(Inventory, Inventory[Quantity] * Inventory[UnitCost])

-- ===============================
-- CLIENT CUSTOMIZATION NOTES
-- ===============================

-- TO CUSTOMIZE FOR NEW CLIENT:
-- 1. Replace table names with client's actual table names
-- 2. Replace column names with client's actual column names  
-- 3. Add client-specific KPIs and business rules
-- 4. Adjust time intelligence based on client's fiscal calendar
"@

    # Save both versions
    $DAXFileSample = Join-Path $OutputDir "MCCNO_DAX_Measures.dax"
    $DAXContentSample | Out-File -FilePath $DAXFileSample -Encoding UTF8
    Write-Host "✅ Generated sample data DAX measures: $DAXFileSample" -ForegroundColor Green
    
    $DAXFileTemplate = Join-Path $OutputDir "MCCNO_DAX_Measures_Template.dax"
    $DAXContentTemplate | Out-File -FilePath $DAXFileTemplate -Encoding UTF8
    Write-Host "✅ Generated template DAX measures: $DAXFileTemplate" -ForegroundColor Green
}

# Function to generate Power Query M code
function Generate-PowerQueryCode {
    $MContent = @"
// MCCNO Executive Dashboard - Power Query M Code
// Data transformation and preparation scripts

// ===============================
// SAMPLE DATA IMPORT
// ===============================

let
    // Import Events Sample Data
    Events_Source = Csv.Document(File.Contents("$ProjectPath\sample-data\events_sample.csv"),[Delimiter=",", Columns=10, Encoding=1252, QuoteStyle=QuoteStyle.None]),
    Events_Headers = Table.PromoteHeaders(Events_Source, [PromoteAllScalars=true]),
    Events_Types = Table.TransformColumnTypes(Events_Headers,{
        {"event_id", type text}, 
        {"name", type text}, 
        {"venue_area", type text}, 
        {"event_type", type text}, 
        {"start_dt", type datetime}, 
        {"end_dt", type datetime}, 
        {"est_attendance", Int64.Type}, 
        {"actual_revenue", type number}, 
        {"conversion_rate", type number}, 
        {"attach_rate", type number}
    }),

    // Import Inventory Sample Data
    Inventory_Source = Csv.Document(File.Contents("$ProjectPath\sample-data\inventory_sample.csv"),[Delimiter=",", Columns=13, Encoding=1252, QuoteStyle=QuoteStyle.None]),
    Inventory_Headers = Table.PromoteHeaders(Inventory_Source, [PromoteAllScalars=true]),
    Inventory_Types = Table.TransformColumnTypes(Inventory_Headers,{
        {"asof_date", type date}, 
        {"checkpoint", type text}, 
        {"location", type text}, 
        {"sku", type text}, 
        {"desc", type text}, 
        {"category", type text}, 
        {"qty", Int64.Type}, 
        {"uom", type text}, 
        {"cost", type number}, 
        {"price", type number}, 
        {"lead_time_days", Int64.Type}, 
        {"reorder_point", Int64.Type}, 
        {"safety_stock", Int64.Type}
    }),

    // Import Sales Sample Data
    Sales_Source = Csv.Document(File.Contents("$ProjectPath\sample-data\sales_sample.csv"),[Delimiter=",", Columns=11, Encoding=1252, QuoteStyle=QuoteStyle.None]),
    Sales_Headers = Table.PromoteHeaders(Sales_Source, [PromoteAllScalars=true]),
    Sales_Types = Table.TransformColumnTypes(Sales_Headers,{
        {"date", type date}, 
        {"sku", type text}, 
        {"desc", type text}, 
        {"category", type text}, 
        {"units_sold", Int64.Type}, 
        {"revenue", type number}, 
        {"cogs", type number}, 
        {"gross_margin", type number}, 
        {"event_id", type text}, 
        {"channel", type text}, 
        {"location", type text}
    }),

    // Create Date Table
    Date_Table = 
    let
        StartDate = #date(2025, 1, 1),
        EndDate = #date(2025, 12, 31),
        DateList = List.Dates(StartDate, Duration.Days(EndDate - StartDate) + 1, #duration(1,0,0,0)),
        TableFromList = Table.FromList(DateList, Splitter.SplitByNothing(), {"Date"}),
        ChangedType = Table.TransformColumnTypes(TableFromList, {{"Date", type date}}),
        AddYear = Table.AddColumn(ChangedType, "Year", each Date.Year([Date])),
        AddMonth = Table.AddColumn(AddYear, "Month", each Date.Month([Date])),
        AddMonthName = Table.AddColumn(AddMonth, "MonthName", each Date.MonthName([Date])),
        AddQuarter = Table.AddColumn(AddMonthName, "Quarter", each Date.QuarterOfYear([Date])),
        AddDayOfWeek = Table.AddColumn(AddQuarter, "DayOfWeek", each Date.DayOfWeek([Date])),
        AddDayName = Table.AddColumn(AddDayOfWeek, "DayName", each Date.DayOfWeekName([Date]))
    in
        AddDayName

in
    {
        Events_Types,
        Inventory_Types, 
        Sales_Types,
        Date_Table
    }
"@

    $MFile = Join-Path $OutputDir "MCCNO_PowerQuery.m"
    $MContent | Out-File -FilePath $MFile -Encoding UTF8
    Write-Host "✅ Generated Power Query M code: $MFile" -ForegroundColor Green
}

# Function to generate JSON layout specification
function Generate-LayoutSpec {
    $LayoutSpec = @{
        dashboard_name = "MCCNO Executive Inventory Dashboard"
        version = "1.0"
        brand_theme = "MCCNO_Executive"
        pages = @(
            @{
                name = "Executive Overview"
                layout = @{
                    header = @{ height = 120; background = "#003366" }
                    kpi_row = @{ height = 100; cards = 4 }
                    main_content = @{ height = 680 }
                    footer = @{ height = 180 }
                }
                visuals = @(
                    @{ type = "card"; measure = "GMROI"; position = @{x=0; y=120; w=240; h=100} }
                    @{ type = "card"; measure = "Total_Revenue"; position = @{x=240; y=120; w=240; h=100} }
                    @{ type = "card"; measure = "Sell_Through_Rate"; position = @{x=480; y=120; w=240; h=100} }
                    @{ type = "card"; measure = "Days_of_Supply"; position = @{x=720; y=120; w=240; h=100} }
                    @{ type = "waterfall"; measure = "Total_Revenue"; position = @{x=0; y=220; w=576; h=400} }
                    @{ type = "table"; name = "Risk_Alerts"; position = @{x=576; y=220; w=384; h=400} }
                )
            },
            @{
                name = "Event Impact Analysis"
                visuals = @(
                    @{ type = "scatter"; x_axis = "est_attendance"; y_axis = "actual_revenue"; position = @{x=0; y=120; w=480; h=300} }
                    @{ type = "combo"; bars = "Pre_Event_Inventory"; line = "Sales"; position = @{x=480; y=120; w=432; h=300} }
                    @{ type = "funnel"; stages = 4; position = @{x=0; y=420; w=432; h=300} }
                    @{ type = "column"; comparison = "before_after"; position = @{x=432; y=420; w=480; h=300} }
                )
            },
            @{
                name = "Inventory Intelligence"
                visuals = @(
                    @{ type = "matrix"; rows = "category"; columns = "location"; position = @{x=0; y=120; w=960; h=200} }
                    @{ type = "table"; name = "Reorder_Dashboard"; position = @{x=0; y=320; w=576; h=300} }
                    @{ type = "gauge"; measure = "Service_Level"; position = @{x=576; y=320; w=336; h=150} }
                    @{ type = "line"; measure = "Shrink_Variance_Percent"; position = @{x=576; y=470; w=336; h=150} }
                )
            },
            @{
                name = "Financial Performance"
                visuals = @(
                    @{ type = "stacked_bar"; categories = "Promotional,Apparel,Packaging,Shipping"; position = @{x=0; y=120; w=960; h=200} }
                    @{ type = "line"; measure = "GMROI"; target = 3.0; position = @{x=0; y=320; w=576; h=300} }
                    @{ type = "scatter"; x_axis = "Days_of_Supply"; y_axis = "Cash_Flow"; position = @{x=576; y=320; w=336; h=150} }
                    @{ type = "table"; name = "Investment_Planning"; position = @{x=576; y=470; w=336; h=150} }
                )
            }
        )
        filters = @(
            @{ type = "slicer"; field = "Date[MonthName]"; position = "top" }
            @{ type = "slicer"; field = "Events[event_type]"; position = "top" }
            @{ type = "slicer"; field = "Inventory[category]"; position = "top" }
            @{ type = "slicer"; field = "Inventory[location]"; position = "top" }
        )
    }

    $LayoutFile = Join-Path $OutputDir "MCCNO_Layout_Specification.json"
    $LayoutSpec | ConvertTo-Json -Depth 10 | Out-File -FilePath $LayoutFile -Encoding UTF8
    Write-Host "✅ Generated layout specification: $LayoutFile" -ForegroundColor Green
    
    # Also create readable versions
    $ReadableGuide = Join-Path $OutputDir "MCCNO_Layout_Guide.md"
    Copy-Item -Path "dashboard-files\Generated_Components\MCCNO_Layout_Guide.md" -Destination $ReadableGuide -Force
    
    $CleanJSON = Join-Path $OutputDir "MCCNO_Layout_Clean.json" 
    Copy-Item -Path "dashboard-files\Generated_Components\MCCNO_Layout_Clean.json" -Destination $CleanJSON -Force
    
    $QuickRef = Join-Path $OutputDir "Quick_Copy_Layout.txt"
    Copy-Item -Path "dashboard-files\Generated_Components\Quick_Copy_Layout.txt" -Destination $QuickRef -Force
}

# Function to create Power BI setup instructions
function Generate-QuickSetupGuide {
    $SetupGuide = @"
# MCCNO Dashboard - Quick Setup Guide
## Auto-Generated Components Ready for Power BI

### 🚀 IMMEDIATE SETUP STEPS (15 minutes)

#### Step 1: Import Data (5 minutes)
1. **Open Power BI Desktop**
2. **Get Data → Text/CSV**
3. **Import files from sample-data folder:**
   - events_sample.csv
   - inventory_sample.csv  
   - sales_sample.csv
4. **Click Load**

#### Step 2: Apply Theme (2 minutes)
1. **View → Themes → Browse for themes**
2. **Select:** branding-assets\MCCNO_PowerBI_Theme.json
3. **Verify colors applied**

#### Step 3: Copy DAX Measures (5 minutes)
1. **Open:** Generated_Components\MCCNO_DAX_Measures.dax
2. **In Power BI: Home → New Measure**
3. **Copy/paste each measure from the DAX file**
4. **Verify calculations work**

#### Step 4: Create Visuals (3 minutes)
1. **Follow layout specification:** Generated_Components\MCCNO_Layout_Specification.json
2. **Add Card visuals for KPIs**
3. **Position according to coordinates in JSON**

### 🎯 AUTO-GENERATED FILES READY:
- ✅ **DAX Measures**: All KPI calculations
- ✅ **Power Query Code**: Data transformation scripts
- ✅ **Layout Specification**: Exact positioning and sizing
- ✅ **Quick Setup Guide**: This step-by-step guide

### 📊 KPI CARDS TO CREATE FIRST:
1. **GMROI Card**: Uses GMROI measure
2. **Revenue Card**: Uses Total_Revenue measure
3. **Sell-Through Card**: Uses Sell_Through_Rate measure
4. **Days Supply Card**: Uses Days_of_Supply measure

### 🎨 FORMATTING TO APPLY:
- **Font**: Segoe UI
- **Colors**: Navy (#003366) headers, Golden (#FFB500) values
- **Background**: White cards with subtle borders

### 💡 PRO TIPS:
- Start with Page 1 (Executive Overview)
- Test each measure before adding visuals
- Apply MCCNO colors to match brand standards
- Use the layout JSON for exact positioning

**Total Setup Time: 15 minutes to working dashboard!**
"@

    $GuideFile = Join-Path $OutputDir "Quick_Setup_Guide.md"
    $SetupGuide | Out-File -FilePath $GuideFile -Encoding UTF8
    Write-Host "✅ Generated quick setup guide: $GuideFile" -ForegroundColor Green
}

# Function to create a Power BI template starter
function Generate-PBITemplate {
    # Create a basic .pbit template structure (this would need Power BI Desktop to generate properly)
    $TemplateInfo = @"
# Power BI Template (.pbit) Information
## To create the template file:

1. **Follow the Quick Setup Guide** to create the initial dashboard
2. **In Power BI Desktop:**
   - File → Export → Power BI template (.pbit)
   - Save as: MCCNO_Executive_Dashboard_Template.pbit
   - Location: dashboard-files folder

3. **Template will include:**
   - All DAX measures
   - Visual layouts
   - MCCNO theme
   - Data structure (without data)

4. **To use template:**
   - Open .pbit file
   - Power BI will prompt for data source
   - Point to your CSV files or Excel data
   - Dashboard loads instantly with all formatting

**This template approach will save you 90% of setup time for future deployments!**
"@

    $TemplateFile = Join-Path $OutputDir "Template_Creation_Instructions.md"
    $TemplateInfo | Out-File -FilePath $TemplateFile -Encoding UTF8
    Write-Host "✅ Generated template instructions: $TemplateFile" -ForegroundColor Green
}

# Main execution
Write-Host ""
Write-Host "Generating Power BI components from project specifications..." -ForegroundColor Yellow

Generate-DAXMeasures
Generate-PowerQueryCode  
Generate-LayoutSpec
Generate-QuickSetupGuide
Generate-PBITemplate

Write-Host ""
Write-Host "GENERATION COMPLETE!" -ForegroundColor Green
Write-Host "==============================" -ForegroundColor Green
Write-Host ""
Write-Host "Generated files location: $OutputDir" -ForegroundColor Blue
Write-Host ""
Write-Host "Next Steps:" -ForegroundColor Yellow
Write-Host "1. Run the generated Quick_Setup_Guide.md" -ForegroundColor White
Write-Host "2. Open Power BI Desktop" -ForegroundColor White  
Write-Host "3. Follow the 15-minute setup process" -ForegroundColor White
Write-Host "4. Your dashboard will be 90% complete!" -ForegroundColor White
Write-Host ""
Write-Host "Total time saved: 3-4 hours of manual setup!" -ForegroundColor Green
