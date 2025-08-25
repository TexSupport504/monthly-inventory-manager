# DAX Measures Guide - Which File to Use

## 📊 **Available DAX Measure Files**

### 1. **MCCNO_DAX_Measures.dax** ✅ **RECOMMENDED FOR MCCNO**
- **Use When**: Working with MCCNO project sample data
- **Compatible With**: events_sample.csv, inventory_sample.csv, sales_sample.csv  
- **Table Names**: sales_sample, inventory_sample, events_sample
- **Ready to Use**: Copy/paste directly into Power BI Desktop

### 2. **MCCNO_DAX_Measures_Template.dax** 🔧 **FOR NEW CLIENTS** 
- **Use When**: Creating dashboards for other clients
- **Compatible With**: Generic table structures
- **Table Names**: Sales, Inventory, Events, Calendar, Products
- **Customization Required**: Update table/column names for client data

### 3. **MCCNO_DAX_Measures_SampleData.dax** 📋 **BACKUP COPY**
- **Use When**: Same as #1, alternative copy
- **Purpose**: Identical to main file, kept for reference

---

## 🚀 **Quick Start Instructions**

### **For MCCNO Project (Current)**:
```
1. Open Power BI Desktop
2. Import: events_sample.csv, inventory_sample.csv, sales_sample.csv
3. Copy measures from: MCCNO_DAX_Measures.dax
4. Paste into Power BI: Home → New Measure
5. ✅ Measures work immediately!
```

### **For New Client Project**: 
```
1. Start with: MCCNO_DAX_Measures_Template.dax
2. Replace table names:
   - Sales → [ClientActualSalesTable]
   - Inventory → [ClientActualInventoryTable]
   - Events → [ClientActualEventsTable]
3. Replace column names to match client data
4. Customize categories and locations
5. Add client-specific business rules
```

---

## 📋 **Sample Data Column Mapping**

### **Current MCCNO Sample Data Structure**:
```
events_sample: event_id, name, venue_area, event_type, start_dt, end_dt, est_attendance, actual_revenue, conversion_rate, attach_rate

inventory_sample: asof_date, checkpoint, location, sku, desc, category, qty, uom, cost, price, lead_time_days, reorder_point, safety_stock

sales_sample: date, sku, desc, category, units_sold, revenue, cogs, gross_margin, event_id, channel, location
```

### **Template Generic Structure**:
```
Events: EventID, EventName, StartDate, EndDate, EstimatedAttendance, ActualRevenue

Inventory: SKU, Quantity, UnitCost, ReorderPoint, SafetyStock, Category, Location  

Sales: Date, SKU, Revenue, COGS, GrossMargin, UnitsSold, EventID, Channel
```

---

## 🎯 **Key Measures Included**

### **Core KPIs**:
- **GMROI**: Gross Margin Return on Investment
- **Total_Revenue**: Sum of all sales revenue
- **Sell_Through_Rate**: Units sold vs inventory quantity
- **Days_of_Supply**: How many days current inventory will last

### **Event Analysis**:
- **Event_Revenue**: Revenue tied to specific events
- **Event_Conversion_Rate**: Sales per attendee

### **Risk Management**:
- **Stockout_Risk_SKUs**: Items approaching stockout
- **Critical_Stock_Level**: Items with < 7 days supply

### **Financial Performance**:
- **Gross_Margin_Percent**: Margin as percentage of revenue
- **Inventory_Value**: Total value of inventory on hand

---

## 💡 **Pro Tips**

### **Testing Measures**:
1. **Always test** with a simple table visual first
2. **Verify calculations** match your expectations
3. **Check for BLANK() results** - indicates data relationship issues

### **Troubleshooting**:
- **"Cannot find table"** → Check table names in Data Model view
- **"Cannot find column"** → Verify column names match CSV headers exactly
- **Blank results** → Check relationships between tables

### **Performance**:
- **Avoid calculated columns** where measures can work
- **Use CALCULATE** for filtered aggregations
- **Test with full dataset** before deploying

---

**🎉 Ready to build your dashboard with working DAX measures!**

*Use MCCNO_DAX_Measures.dax for immediate results with sample data.*
