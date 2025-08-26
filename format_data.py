import pandas as pd
from datetime import datetime

print("🔧 Converting data to proper system format...")

# Fix sales data format
print("💰 Converting sales data...")
sales_df = pd.read_csv('complete_sales_data.csv')
sales_formatted = sales_df.rename(columns={
    'quantity': 'units_sold',
    'unit_price': 'revenue_per_unit'
})
sales_formatted.to_csv('complete_sales_formatted.csv', index=False)
print(f"✅ Formatted {len(sales_formatted)} sales records")

# Fix counts data format  
print("📊 Converting counts data...")
counts_df = pd.read_csv('complete_counts_data.csv')
counts_formatted = counts_df.rename(columns={
    'date': 'asof_date',
    'physical_count': 'qty',
    'counter': 'checkpoint'
})
# Add location column
counts_formatted['location'] = 'MAIN-WAREHOUSE'
counts_formatted.to_csv('complete_counts_formatted.csv', index=False)
print(f"✅ Formatted {len(counts_formatted)} count records")

# Create proper SKU master file
print("📦 Creating SKU master file...")
sku_df = pd.read_csv('complete_sku_data.csv')
sku_df.to_csv('complete_sku_master.csv', index=False)
print(f"✅ SKU master with {len(sku_df)} items")

print("🎯 All data formatted for system ingestion!")
