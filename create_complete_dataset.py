import pandas as pd
import numpy as np
from datetime import datetime, timedelta
import random

print("🚀 Creating Complete Ready-to-Use System...")

# Generate comprehensive SKU data (100 SKUs instead of 3)
print("📦 Generating 100 SKUs with realistic data...")
np.random.seed(42)
random.seed(42)

categories = ['Audio/Visual', 'Lighting', 'Staging', 'Furniture', 'Decor', 'Catering', 'Tech Equipment', 'Security']
vendors = ['EventPro Supply', 'Convention Masters', 'StageWorld', 'TechRental Inc', 'DecorPlus', 'CateringSource']

skus = []
for i in range(100):
    sku_id = f"SKU{1000 + i:04d}"
    category = random.choice(categories)
    vendor = random.choice(vendors)
    
    # Realistic pricing based on category
    if category == 'Audio/Visual':
        cost = random.uniform(150, 800)
        price = cost * random.uniform(1.4, 2.2)
    elif category == 'Lighting':
        cost = random.uniform(50, 300)
        price = cost * random.uniform(1.3, 1.8)
    elif category == 'Staging':
        cost = random.uniform(200, 1200)
        price = cost * random.uniform(1.5, 2.5)
    else:
        cost = random.uniform(25, 400)
        price = cost * random.uniform(1.2, 2.0)
    
    current_stock = random.randint(0, 150)
    
    skus.append({
        'sku': sku_id,
        'description': f"{category} - {sku_id}",
        'category': category,
        'vendor': vendor,
        'cost': round(cost, 2),
        'price': round(price, 2),
        'current_stock': current_stock,
        'location': f"Zone-{random.choice(['A', 'B', 'C', 'D'])}{random.randint(1, 20):02d}",
        'lead_time': random.choice([3, 5, 7, 10, 14])
    })

sku_df = pd.DataFrame(skus)
print(f"✅ Generated {len(skus)} SKUs")

# Generate realistic sales history (500 transactions over 12 months)
print("💰 Generating 500 sales transactions...")
sales = []
base_date = datetime(2024, 8, 1)

for i in range(500):
    # Weight sales toward recent months and certain SKUs
    days_ago = int(np.random.exponential(60))  # Exponential distribution favoring recent sales
    if days_ago > 365: days_ago = 365
    
    sale_date = base_date + timedelta(days=days_ago)
    sku = random.choice(skus)
    
    # Quantity based on item type and seasonality
    if sku['category'] in ['Audio/Visual', 'Staging']:
        qty = random.randint(1, 8)  # Higher volume items
    else:
        qty = random.randint(1, 3)  # Lower volume
    
    sales.append({
        'date': sale_date.strftime('%Y-%m-%d'),
        'sku': sku['sku'],
        'quantity': qty,
        'unit_price': sku['price'],
        'total_revenue': qty * sku['price'],
        'customer': f"Customer-{random.randint(1000, 9999)}"
    })

sales_df = pd.DataFrame(sales)
print(f"✅ Generated {len(sales)} sales transactions")

# Generate realistic inventory counts (200 count records)
print("📊 Generating 200 inventory count records...")
counts = []
count_date = datetime(2025, 8, 25)

for i in range(200):
    sku = random.choice(skus)
    # Add some variance to counts (simulation of real counting differences)
    variance = random.uniform(-0.1, 0.1)  # +/- 10% variance
    physical_count = max(0, int(sku['current_stock'] * (1 + variance)))
    
    counts.append({
        'date': count_date.strftime('%Y-%m-%d'),
        'sku': sku['sku'],
        'system_count': sku['current_stock'],
        'physical_count': physical_count,
        'variance': physical_count - sku['current_stock'],
        'counter': f"Counter-{random.choice(['A', 'B', 'C', 'D'])}"
    })

counts_df = pd.DataFrame(counts)
print(f"✅ Generated {len(counts)} count records")

# Save all data files
print("💾 Saving complete dataset...")
sku_df.to_csv('complete_sku_data.csv', index=False)
sales_df.to_csv('complete_sales_data.csv', index=False)
counts_df.to_csv('complete_counts_data.csv', index=False)

print("🎯 Summary of Complete Dataset:")
print(f"   • {len(skus)} SKUs across {len(categories)} categories")
print(f"   • {len(sales)} sales transactions over 12 months")
print(f"   • {len(counts)} inventory counts")
print(f"   • Total sales value: ${sales_df['total_revenue'].sum():,.2f}")
print(f"   • Total inventory value: ${(sku_df['current_stock'] * sku_df['cost']).sum():,.2f}")

print("\n🚀 Ready for client deployment!")
