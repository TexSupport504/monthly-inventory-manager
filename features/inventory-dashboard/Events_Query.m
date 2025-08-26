// ConventiCore Events Data - Single Table Query
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
