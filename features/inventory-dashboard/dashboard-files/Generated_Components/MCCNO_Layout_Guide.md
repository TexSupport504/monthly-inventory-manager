# MCCNO Dashboard Layout Guide
## Visual Positioning and Sizing Specifications

This guide provides exact coordinates and specifications for placing visuals in your Power BI dashboard.

---

## 📏 **Canvas Dimensions**
- **Total Width**: 960 pixels  
- **Total Height**: 800 pixels
- **Standard Margin**: 20 pixels

---

## 📄 **PAGE 1: Executive Overview**

### 🎨 **Page Layout**
```
Header Section:     Height 120px, Background #003366 (Navy)
KPI Row:           Height 100px, 4 cards across
Main Content:      Height 680px, charts and tables
Footer:            Height 180px, filters and navigation
```

### 📊 **KPI Cards Row** (Y: 120, Height: 100)
```
Card 1 - GMROI:              X: 0,   Width: 240px
Card 2 - Total Revenue:      X: 240, Width: 240px  
Card 3 - Sell Through Rate:  X: 480, Width: 240px
Card 4 - Days of Supply:     X: 720, Width: 240px
```

### 📈 **Main Visuals** (Y: 220)
```
Revenue Waterfall:     X: 0,   Y: 220, Width: 576px, Height: 400px
Risk Alert Panel:      X: 576, Y: 220, Width: 384px, Height: 400px
```

---

## 📄 **PAGE 2: Event Impact Analysis**

### 📊 **Visual Layout**
```
Event Performance Matrix:     X: 0,   Y: 120, Width: 480px, Height: 300px
Inventory-Sales Correlation: X: 480, Y: 120, Width: 432px, Height: 300px
Conversion Funnel:           X: 0,   Y: 420, Width: 432px, Height: 300px
Before/After Analysis:       X: 432, Y: 420, Width: 480px, Height: 300px
```

---

## 📄 **PAGE 3: Inventory Intelligence**

### 🗺️ **Visual Layout**
```
Stock Level Heat Map:        X: 0,   Y: 120, Width: 960px, Height: 200px
Reorder Dashboard:           X: 0,   Y: 320, Width: 576px, Height: 300px
Safety Stock Performance:    X: 576, Y: 320, Width: 336px, Height: 150px
Shrink Detection Monitor:    X: 576, Y: 470, Width: 336px, Height: 150px
```

---

## 📄 **PAGE 4: Financial Performance**

### 💰 **Visual Layout**
```
Category P&L Analysis:       X: 0,   Y: 120, Width: 960px, Height: 200px
GMROI Trending:             X: 0,   Y: 320, Width: 576px, Height: 300px
Working Capital Optimization: X: 576, Y: 320, Width: 336px, Height: 150px
Investment Planning:         X: 576, Y: 470, Width: 336px, Height: 150px
```

---

## 🎛️ **FILTERS & SLICERS**
All filters positioned at top of each page:

```
Time Period Filter:     Field: Date[MonthName]
Event Type Filter:      Field: Events[event_type]  
Category Filter:        Field: Inventory[category]
Location Filter:        Field: Inventory[location]
```

---

## 🎨 **VISUAL TYPES REFERENCE**

### **Card Visuals** (KPI Cards)
- **Type**: Card
- **Measures**: GMROI, Total_Revenue, Sell_Through_Rate, Days_of_Supply
- **Formatting**: Navy header, white background, golden accent values

### **Chart Types**
- **Waterfall**: Revenue contribution analysis
- **Scatter**: Performance matrix with bubble sizing
- **Combo**: Bar charts with line overlays
- **Funnel**: Multi-stage conversion process
- **Matrix**: Heat map with conditional formatting
- **Table**: Alert lists with priority indicators

---

## 📐 **COPY-PASTE POSITIONING**

### **Quick Copy Format**
For each visual, use these exact coordinates:

```powershell
# Page 1 - Executive Overview
New-PowerBIVisual -Type "Card" -Measure "GMROI" -X 0 -Y 120 -Width 240 -Height 100
New-PowerBIVisual -Type "Card" -Measure "Total_Revenue" -X 240 -Y 120 -Width 240 -Height 100
New-PowerBIVisual -Type "Card" -Measure "Sell_Through_Rate" -X 480 -Y 120 -Width 240 -Height 100
New-PowerBIVisual -Type "Card" -Measure "Days_of_Supply" -X 720 -Y 120 -Width 240 -Height 100

New-PowerBIVisual -Type "Waterfall" -Measure "Total_Revenue" -X 0 -Y 220 -Width 576 -Height 400
New-PowerBIVisual -Type "Table" -Name "Risk_Alerts" -X 576 -Y 220 -Width 384 -Height 400

# Page 2 - Event Impact Analysis  
New-PowerBIVisual -Type "Scatter" -XAxis "est_attendance" -YAxis "actual_revenue" -X 0 -Y 120 -Width 480 -Height 300
New-PowerBIVisual -Type "Combo" -Bars "Pre_Event_Inventory" -Line "Sales" -X 480 -Y 120 -Width 432 -Height 300
New-PowerBIVisual -Type "Funnel" -Stages 4 -X 0 -Y 420 -Width 432 -Height 300
New-PowerBIVisual -Type "Column" -Comparison "before_after" -X 432 -Y 420 -Width 480 -Height 300

# Page 3 - Inventory Intelligence
New-PowerBIVisual -Type "Matrix" -Rows "category" -Columns "location" -X 0 -Y 120 -Width 960 -Height 200
New-PowerBIVisual -Type "Table" -Name "Reorder_Dashboard" -X 0 -Y 320 -Width 576 -Height 300
New-PowerBIVisual -Type "Gauge" -Measure "Service_Level" -X 576 -Y 320 -Width 336 -Height 150
New-PowerBIVisual -Type "Line" -Measure "Shrink_Variance_Percent" -X 576 -Y 470 -Width 336 -Height 150

# Page 4 - Financial Performance
New-PowerBIVisual -Type "StackedBar" -Categories "Promotional,Apparel,Packaging,Shipping" -X 0 -Y 120 -Width 960 -Height 200
New-PowerBIVisual -Type "Line" -Measure "GMROI" -Target 3.0 -X 0 -Y 320 -Width 576 -Height 300
New-PowerBIVisual -Type "Scatter" -XAxis "Days_of_Supply" -YAxis "Cash_Flow" -X 576 -Y 320 -Width 336 -Height 150
New-PowerBIVisual -Type "Table" -Name "Investment_Planning" -X 576 -Y 470 -Width 336 -Height 150
```

---

## 🎯 **POWER BI PLACEMENT TIPS**

### **Using Coordinates**
1. **Select Visual** in Power BI Desktop
2. **View Tab** → Show **Selection Pane**
3. **Format Visual** → General → Properties
4. **Enter X, Y coordinates** from this guide
5. **Set Width and Height** as specified

### **Alignment Helpers**
- **Snap to Grid**: View → Show gridlines
- **Align Tools**: Format → Align → Distribute horizontally/vertically  
- **Size Tools**: Format → Align → Same width/height

### **Mobile Layout**
- All visuals automatically resize for mobile
- KPI cards stack vertically on tablets
- Tables become scrollable on phones

---

**🎉 Ready to build your executive dashboard with precision!**

*Use this guide alongside the Quick_Setup_Guide.md for complete implementation.*
