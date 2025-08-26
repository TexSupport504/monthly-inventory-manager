import pandas as pd
import csv

# Read the original data
print("Reading events_processed.csv...")
df = pd.read_csv('data/events_processed.csv')
print(f"Loaded {len(df)} rows")

# Clean up the data for Excel compatibility
print("Cleaning data for Excel...")
df['account'] = df['account'].astype(str).str[:30]
df['name'] = df['name'].astype(str).str[:50] 
df['venue_area'] = df['venue_area'].astype(str).str[:40]
df['contact'] = df['contact'].astype(str).str.replace('"', '').str[:20]
df['salesperson'] = df['salesperson'].astype(str).str.replace('"', '').str[:20]

print("Sample of cleaned data:")
print(df.head(3)[['event_id', 'account', 'name', 'est_attendance']])

# Save Excel-friendly version
print("Saving Excel-ready CSV...")
df.to_csv('data/events_excel_ready.csv', index=False, quoting=csv.QUOTE_MINIMAL)
print(f"Successfully saved {len(df)} rows to data/events_excel_ready.csv")
