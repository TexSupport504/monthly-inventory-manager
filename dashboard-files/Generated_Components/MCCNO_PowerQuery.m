// MCCNO Executive Dashboard - Power Query M Code
// Data transformation and preparation scripts

// ===============================
// SAMPLE DATA IMPORT
// ===============================

let
    // Import Events Sample Data
    Events_Source = Csv.Document(File.Contents("D:\OneDrive\Documents\GitHub\inventory-dashboard-powerbi\sample-data\events_sample.csv"),[Delimiter=",", Columns=10, Encoding=1252, QuoteStyle=QuoteStyle.None]),
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
    Inventory_Source = Csv.Document(File.Contents("D:\OneDrive\Documents\GitHub\inventory-dashboard-powerbi\sample-data\inventory_sample.csv"),[Delimiter=",", Columns=13, Encoding=1252, QuoteStyle=QuoteStyle.None]),
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
    Sales_Source = Csv.Document(File.Contents("D:\OneDrive\Documents\GitHub\inventory-dashboard-powerbi\sample-data\sales_sample.csv"),[Delimiter=",", Columns=11, Encoding=1252, QuoteStyle=QuoteStyle.None]),
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
