let
    Source = Csv.Document(File.Contents("E:\OneDrive\Documents\GitHub\monthly-inventory-manager\data\events_processed.csv"), [Delimiter=",", Encoding=65001]),
    Headers = Table.PromoteHeaders(Source, [PromoteAllScalars=true])
in
    Headers
