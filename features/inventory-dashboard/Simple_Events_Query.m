let
    Source = Csv.Document(
        File.Contents("E:\OneDrive\Documents\GitHub\monthly-inventory-manager\data\events_processed.csv"),
        [Delimiter=",", Encoding=65001, QuoteStyle=QuoteStyle.Csv]
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
            {"in_date", type text},
            {"start_dt", type text},
            {"end_dt", type text},
            {"out_date", type text},
            {"est_attendance", type text},
            {"contact", type text},
            {"salesperson", type text}
        }
    )
in
    #"Changed Type"
