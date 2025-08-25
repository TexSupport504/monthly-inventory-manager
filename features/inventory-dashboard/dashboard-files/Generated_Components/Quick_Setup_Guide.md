# MCCNO Dashboard - Quick Setup Guide
## Auto-Generated Components Ready for Power BI

### ðŸš€ IMMEDIATE SETUP STEPS (15 minutes)

#### Step 1: Import Data (5 minutes)
1. **Open Power BI Desktop**
2. **Get Data â†’ Text/CSV**
3. **Import files from sample-data folder:**
   - events_sample.csv
   - inventory_sample.csv  
   - sales_sample.csv
4. **Click Load**

#### Step 2: Apply Theme (2 minutes)
1. **View â†’ Themes â†’ Browse for themes**
2. **Select:** branding-assets\MCCNO_PowerBI_Theme.json
3. **Verify colors applied**

#### Step 3: Copy DAX Measures (5 minutes)
1. **Open:** Generated_Components\MCCNO_DAX_Measures.dax
2. **In Power BI: Home â†’ New Measure**
3. **Copy/paste each measure from the DAX file**
4. **Verify calculations work**

#### Step 4: Create Visuals (3 minutes)
1. **Follow layout specification:** Generated_Components\MCCNO_Layout_Specification.json
2. **Add Card visuals for KPIs**
3. **Position according to coordinates in JSON**

### ðŸŽ¯ AUTO-GENERATED FILES READY:
- âœ… **DAX Measures**: All KPI calculations
- âœ… **Power Query Code**: Data transformation scripts
- âœ… **Layout Specification**: Exact positioning and sizing
- âœ… **Quick Setup Guide**: This step-by-step guide

### ðŸ“Š KPI CARDS TO CREATE FIRST:
1. **GMROI Card**: Uses GMROI measure
2. **Revenue Card**: Uses Total_Revenue measure
3. **Sell-Through Card**: Uses Sell_Through_Rate measure
4. **Days Supply Card**: Uses Days_of_Supply measure

### ðŸŽ¨ FORMATTING TO APPLY:
- **Font**: Segoe UI
- **Colors**: Navy (#003366) headers, Golden (#FFB500) values
- **Background**: White cards with subtle borders

### ðŸ’¡ PRO TIPS:
- Start with Page 1 (Executive Overview)
- Test each measure before adding visuals
- Apply MCCNO colors to match brand standards
- Use the layout JSON for exact positioning

**Total Setup Time: 15 minutes to working dashboard!**
