# ConventiCore Power BI - Power Query M Code
# Direct connection to CSV data files for immediate deployment

# Events Data Connection
let
    Source = Csv.Document(
        File.Contents("E:\OneDrive\Documents\GitHub\monthly-inventory-manager\data\events_processed.csv"),
        [Delimiter=",", Columns=12, Encoding=65001, QuoteStyle=QuoteStyle.None]
    ),
    #"Promoted Headers" = Table.PromoteHeaders(Source, [PromoteAllScalars=true]),
    #"Changed Type" = Table.TransformColumnTypes(
        #"Promoted Headers",
        {
            {"event_id", type text},
            {"account", type text},
            {"name", type text},
            {"venue_area", type text},
            {"event_type", type text},
            {"in_date", type datetime},
            {"start_dt", type datetime},
            {"end_dt", type datetime},
            {"out_date", type datetime},
            {"est_attendance", Int64.Type},
            {"contact", type text},
            {"salesperson", type text}
        }
    ),
    #"Added Custom Columns" = Table.AddColumn(
        #"Changed Type", 
        "Event Status", 
        each if [start_dt] > DateTime.LocalNow() then "Upcoming" 
             else if [end_dt] < DateTime.LocalNow() then "Completed" 
             else "In Progress"
    ),
    #"Added Date Intelligence" = Table.AddColumn(
        #"Added Custom Columns",
        "Event Year", 
        each Date.Year([start_dt])
    ),
    #"Added Month" = Table.AddColumn(
        #"Added Date Intelligence",
        "Event Month",
        each Date.Month([start_dt])
    ),
    #"Added Quarter" = Table.AddColumn(
        #"Added Month",
        "Event Quarter",
        each Date.QuarterOfYear([start_dt])
    )
in
    #"Added Quarter"

# Inventory KPIs Data Connection  
let
    CountsSource = Csv.Document(
        File.Contents("E:\OneDrive\Documents\GitHub\monthly-inventory-manager\data\counts_processed.csv"),
        [Delimiter=",", Columns=9, Encoding=65001, QuoteStyle=QuoteStyle.None]
    ),
    #"Promoted Headers Counts" = Table.PromoteHeaders(CountsSource, [PromoteAllScalars=true]),
    #"Changed Type Counts" = Table.TransformColumnTypes(
        #"Promoted Headers Counts",
        {
            {"asof_date", type date},
            {"checkpoint", type text},
            {"location", type text},
            {"sku", type text},
            {"qty", Int64.Type},
            {"uom", type text},
            {"counter_id", type text},
            {"notes", type text},
            {"unique_key", type text}
        }
    ),
    
    # SKU Data
    SKUSource = Csv.Document(
        File.Contents("E:\OneDrive\Documents\GitHub\monthly-inventory-manager\sample_sku_data.csv"),
        [Delimiter=",", Columns=7, Encoding=65001, QuoteStyle=QuoteStyle.None]
    ),
    #"Promoted Headers SKU" = Table.PromoteHeaders(SKUSource, [PromoteAllScalars=true]),
    #"Changed Type SKU" = Table.TransformColumnTypes(
        #"Promoted Headers SKU",
        {
            {"sku", type text},
            {"desc", type text},
            {"category", type text},
            {"cost", type number},
            {"price", type number},
            {"lead_time_days", Int64.Type},
            {"supplier", type text}
        }
    ),
    
    # Sales Velocity Data
    SalesSource = Csv.Document(
        File.Contents("E:\OneDrive\Documents\GitHub\monthly-inventory-manager\data\sales_processed.csv"),
        [Delimiter=",", Columns=6, Encoding=65001, QuoteStyle=QuoteStyle.None]
    ),
    #"Promoted Headers Sales" = Table.PromoteHeaders(SalesSource, [PromoteAllScalars=true]),
    #"Changed Type Sales" = Table.TransformColumnTypes(
        #"Promoted Headers Sales",
        {
            {"date", type date},
            {"sku", type text},
            {"units_sold", Int64.Type},
            {"revenue", type number},
            {"event_id", type text},
            {"channel", type text}
        }
    ),
    
    # Calculate sales velocity by SKU
    #"Grouped Sales" = Table.Group(
        #"Changed Type Sales", 
        {"sku"}, 
        {
            {"avg_daily_sales", each List.Average([units_sold]), type number},
            {"total_revenue", each List.Sum([revenue]), type number},
            {"total_units", each List.Sum([units_sold]), Int64.Type}
        }
    ),
    
    # Join counts with SKU data
    #"Merged with SKU" = Table.NestedJoin(
        #"Changed Type Counts", 
        {"sku"}, 
        #"Changed Type SKU", 
        {"sku"}, 
        "SKU_Data", 
        JoinKind.LeftOuter
    ),
    #"Expanded SKU Data" = Table.ExpandTableColumn(
        #"Merged with SKU", 
        "SKU_Data", 
        {"desc", "category", "cost", "price", "lead_time_days"}, 
        {"sku_description", "category", "cost", "price", "lead_time_days"}
    ),
    
    # Join with sales velocity
    #"Merged with Sales" = Table.NestedJoin(
        #"Expanded SKU Data", 
        {"sku"}, 
        #"Grouped Sales", 
        {"sku"}, 
        "Sales_Data", 
        JoinKind.LeftOuter
    ),
    #"Expanded Sales Data" = Table.ExpandTableColumn(
        #"Merged with Sales", 
        "Sales_Data", 
        {"avg_daily_sales", "total_revenue", "total_units"}, 
        {"avg_daily_sales", "total_revenue_sku", "total_units_sku"}
    ),
    
    # Calculate KPIs
    #"Added Inventory Value" = Table.AddColumn(
        #"Expanded Sales Data", 
        "inventory_value", 
        each [cost] * [qty]
    ),
    #"Added Days of Supply" = Table.AddColumn(
        #"Added Inventory Value", 
        "days_of_supply", 
        each if [avg_daily_sales] > 0 then [qty] / [avg_daily_sales] else 999
    ),
    #"Added Stock Status" = Table.AddColumn(
        #"Added Days of Supply", 
        "stock_status", 
        each if [qty] <= ([avg_daily_sales] * [lead_time_days] * 1.5) then "CRITICAL"
             else if [qty] <= ([avg_daily_sales] * [lead_time_days] * 2.0) then "LOW"
             else if [qty] >= ([avg_daily_sales] * [lead_time_days] * 6.0) then "OVERSTOCK"
             else "OPTIMAL"
    ),
    #"Added Gross Margin %" = Table.AddColumn(
        #"Added Stock Status", 
        "gross_margin_pct", 
        each if [price] > 0 then ([price] - [cost]) / [price] else 0
    ),
    #"Added GMROI" = Table.AddColumn(
        #"Added Gross Margin %", 
        "gmroi", 
        each if [inventory_value] > 0 and [total_revenue_sku] > 0 
             then [total_revenue_sku] / [inventory_value] 
             else 0
    ),
    
    # Filter to most recent EOM data
    #"Filtered EOM" = Table.SelectRows(
        #"Added GMROI", 
        each ([checkpoint] = "EOM")
    ),
    #"Grouped by SKU" = Table.Group(
        #"Filtered EOM", 
        {"sku"}, 
        {
            {"Latest Date", each List.Max([asof_date]), type date},
            {"All Data", each _, type table}
        }
    ),
    #"Expanded Latest" = Table.ExpandTableColumn(
        #"Grouped by SKU", 
        "All Data", 
        Table.ColumnNames(#"Added GMROI")
    ),
    #"Filtered Latest Only" = Table.SelectRows(
        #"Expanded Latest", 
        each [asof_date] = [Latest Date]
    ),
    #"Removed Helper Columns" = Table.RemoveColumns(
        #"Filtered Latest Only", 
        {"Latest Date"}
    )
in
    #"Removed Helper Columns"

# Sales Performance Data Connection
let
    SalesSource = Csv.Document(
        File.Contents("E:\OneDrive\Documents\GitHub\monthly-inventory-manager\data\sales_processed.csv"),
        [Delimiter=",", Columns=6, Encoding=65001, QuoteStyle=QuoteStyle.None]
    ),
    #"Promoted Headers" = Table.PromoteHeaders(SalesSource, [PromoteAllScalars=true]),
    #"Changed Type" = Table.TransformColumnTypes(
        #"Promoted Headers",
        {
            {"date", type date},
            {"sku", type text},
            {"units_sold", Int64.Type},
            {"revenue", type number},
            {"event_id", type text},
            {"channel", type text}
        }
    ),
    
    # Join with SKU data for pricing
    SKUSource = Csv.Document(
        File.Contents("E:\OneDrive\Documents\GitHub\monthly-inventory-manager\sample_sku_data.csv"),
        [Delimiter=",", Columns=7, Encoding=65001, QuoteStyle=QuoteStyle.None]
    ),
    #"Promoted Headers SKU" = Table.PromoteHeaders(SKUSource, [PromoteAllScalars=true]),
    #"Changed Type SKU" = Table.TransformColumnTypes(
        #"Promoted Headers SKU",
        {
            {"sku", type text},
            {"desc", type text},
            {"category", type text},
            {"cost", type number},
            {"price", type number},
            {"lead_time_days", Int64.Type},
            {"supplier", type text}
        }
    ),
    
    #"Merged with SKU" = Table.NestedJoin(
        #"Changed Type", 
        {"sku"}, 
        #"Changed Type SKU", 
        {"sku"}, 
        "SKU_Data", 
        JoinKind.LeftOuter
    ),
    #"Expanded SKU" = Table.ExpandTableColumn(
        #"Merged with SKU", 
        "SKU_Data", 
        {"desc", "category", "cost", "price"}, 
        {"sku_description", "category", "cost", "price"}
    ),
    
    # Add calculated metrics
    #"Added Avg Unit Price" = Table.AddColumn(
        #"Expanded SKU", 
        "avg_unit_price", 
        each if [units_sold] > 0 then [revenue] / [units_sold] else 0
    ),
    #"Added Gross Margin" = Table.AddColumn(
        #"Added Avg Unit Price", 
        "gross_margin", 
        each [revenue] - ([cost] * [units_sold])
    ),
    #"Added Gross Margin %" = Table.AddColumn(
        #"Added Gross Margin", 
        "gross_margin_pct", 
        each if [revenue] > 0 then ([revenue] - ([cost] * [units_sold])) / [revenue] else 0
    ),
    
    # Add time intelligence
    #"Added Year" = Table.AddColumn(
        #"Added Gross Margin %", 
        "sales_year", 
        each Date.Year([date])
    ),
    #"Added Month" = Table.AddColumn(
        #"Added Year", 
        "sales_month", 
        each Date.Month([date])
    ),
    #"Added Month Name" = Table.AddColumn(
        #"Added Month", 
        "sales_month_name", 
        each Date.MonthName([date])
    ),
    #"Added Quarter" = Table.AddColumn(
        #"Added Month Name", 
        "sales_quarter", 
        each Date.QuarterOfYear([date])
    ),
    #"Added Week" = Table.AddColumn(
        #"Added Quarter", 
        "sales_week", 
        each Date.WeekOfYear([date])
    ),
    #"Added Day of Week" = Table.AddColumn(
        #"Added Week", 
        "sales_day_of_week", 
        each Date.DayOfWeekName([date])
    ),
    
    # Add sales type classification
    #"Added Sales Type" = Table.AddColumn(
        #"Added Day of Week", 
        "sales_type", 
        each if [event_id] <> null and [event_id] <> "" then "Event-Driven" else "Baseline"
    )
in
    #"Added Sales Type"
