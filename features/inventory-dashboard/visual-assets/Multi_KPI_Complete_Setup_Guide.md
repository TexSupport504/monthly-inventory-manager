# Multi KPI Visual - Complete Setup Guide
## Latest Power BI Desktop (2025) - Step by Step

### ✅ **Starting Point:**
- Multi KPI visual added to canvas ✓
- 4 measures in Values well: GMROI, Total_Revenue, Sell_Through_Rate, Days_of_Supply ✓
- start_dt from events_sample in Date field ✓
- Visual reset to default settings ✓

---

## 🎯 **Phase 1: Basic Display Configuration**

### **Step 1: Values Formatting**
1. **Select your Multi KPI visual**
2. **Format pane** (paint roller icon) → **Values** section
3. **Configure these settings:**
   - **Format**: Auto
   - **Display Units**: **None** (not Auto)
   - **Precision**: **2** (for 2 decimal places)
   - **Missing Value Label**: N/A
   - **Treat Empty/Missing Values As Zero**: ON
   - **Show Latest Available As Current Value**: OFF

### **Step 2: Main Chart Layout**
**Format pane** → **Main Chart** section
1. **Type**: Keep as "Area" or change to "Line" if preferred
2. **This controls the background chart style**

### **Step 3: KPI Display Settings**
**Format pane** → **KPI** section
1. **Auto Font Size**: **ON**
2. **Font Family**: Segoe UI (or your preference)
3. **Name**: **ON** (shows KPI labels)
4. **Value**: **ON** (shows the numbers)
5. **Variance**: **ON** (shows +86.95% type indicators)
6. **Date**: **ON** (shows time context)

---

## 🎨 **Phase 2: MCCNO Branding Colors**

### **Step 4: Value Colors (The Big Numbers)**
**Format pane** → **KPI** → **Value Color**

**For GMROI (Golden - Key Performance Metric):**
1. **Click Value Color dropdown**
2. **Select "More colors" or "Custom color"**
3. **Enter HEX code**: `#FFB500`
4. **Apply**

**Note**: In latest Power BI, you might need to set colors for all KPIs to Navy first, then change GMROI to Golden in conditional formatting.

### **Step 5: Label Colors**
**Format pane** → **KPI** → **Name Color**
1. **Click Name Color dropdown**
2. **Enter HEX code**: `#003366` (Navy)
3. **Apply**

### **Step 6: Additional Text Colors**
**Format pane** → **KPI** section:
- **Date Color**: `#6C757D` (Medium gray)
- **Variance Color**: `#28A745` (Green for positive variance)

---

## 📊 **Phase 3: Individual KPI Formatting**

### **Step 7: Fix Sell-Through Rate (Show as Percentage)**
**This requires going back to your DAX measure:**

1. **Go to Data pane** → **Find Sell_Through_Rate measure**
2. **Right-click** → **Edit**
3. **Ensure the measure ends with**: `FORMAT([YourCalculation], "0.0%")`
4. **Example**:
   ```dax
   Sell_Through_Rate = 
   FORMAT(
       DIVIDE(
           SUM(sales_sample[units_sold]),
           SUM(inventory_sample[qty])
       ),
       "0.0%"
   )
   ```

**Alternative**: Use conditional formatting in the visual for percentage display.

### **Step 8: Revenue Formatting**
**Format pane** → **Values** → **For Total_Revenue specifically**:
- **Display Units**: Auto (will show as $4.37K)
- **Precision**: 2
- **Prefix**: $ (if not automatic)

---

## 🎯 **Phase 4: Layout & Positioning**

### **Step 9: Visual Layout**
**Format pane** → **General** → **Properties**
1. **Position**: X=0, Y=100 (below header)
2. **Size**: Width=1000, Height=200
3. **This creates a horizontal strip of KPIs**

### **Step 10: Title Configuration**
**Format pane** → **General** → **Title**
1. **Title**: ON
2. **Title Text**: "Executive KPI Summary"
3. **Font Color**: `#003366` (Navy)
4. **Font Size**: 16
5. **Alignment**: Center

---

## 🔧 **Phase 5: Advanced Formatting**

### **Step 11: Conditional Formatting (Advanced)**
**Format pane** → **KPI** → **Conditional Formatting** (if available)

**GMROI Rules:**
- **If ≥ 3.0**: Golden `#FFB500`
- **If < 3.0**: Red `#DC3545`

**Sell-Through Rate Rules:**
- **If ≥ 75%**: Green `#28A745`
- **If < 75%**: Orange `#FFC107`

### **Step 12: Sparkline Configuration** (if available)
**Format pane** → **Sparkline** section
1. **Show**: ON
2. **Line Color**: Match value color
3. **Position**: Right side of each KPI

### **Step 13: Tooltip Enhancement**
**Format pane** → **Tooltip** section
1. **Tooltip**: ON
2. **Custom tooltip text**:
   - "GMROI Target: 3.0+ | Current: [Value]"
   - "Revenue Performance: [Value]"
   - "Sell-Through Target: 75%+ | Current: [Value]"
   - "Days Supply Optimal: 20-40 days | Current: [Value]"

---

## 🎨 **Phase 6: Final Visual Polish**

### **Step 14: Background & Borders**
**Format pane** → **General** → **Effects**
1. **Background**: Light gray `#FAFAFA` or White
2. **Border**: OFF or thin gray `#E0E0E0`
3. **Shadow**: Subtle (optional)

### **Step 15: Visual Header Styling**
**Format pane** → **General** → **Title**
1. **Background**: Match dashboard background
2. **Text alignment**: Center
3. **Font weight**: Bold

---

## ✅ **Expected Final Result:**

Your Multi KPI should display:
```
EXECUTIVE KPI SUMMARY
┌─────────────────────────────────────────────────┐
│ GMROI          TOTAL REVENUE    SELL-THROUGH    DAYS SUPPLY │
│ 4.20           $4.37K           75.2%          28 days     │
│ (+15.5%) ↑     (+8.3%) ↑        (+2.1%) ↑     (-5 days) ↓  │
│ [sparkline]    [sparkline]      [sparkline]    [sparkline] │
└─────────────────────────────────────────────────┘
```

**Colors:**
- **GMROI**: Golden (#FFB500) - key metric
- **Others**: Navy (#003366)
- **Labels**: Navy (#003366)
- **Variance**: Green (positive), Red (negative)

---

## 🚀 **Quick Start Checklist:**

1. **Values**: Display Units = None, Precision = 2 ✓
2. **KPI**: All toggles ON (Name, Value, Variance, Date) ✓
3. **Colors**: Value = Golden/Navy, Name = Navy ✓
4. **Layout**: Horizontal, proper sizing ✓
5. **Title**: "Executive KPI Summary" ✓

**Start with Phase 1, then move through each phase systematically!**

**Questions or issues? Check the troubleshooting section below.**

---

## 🔧 **Troubleshooting:**

**Values not showing?** → Check KPI section toggles (Name, Value ON)
**Wrong colors?** → Use HEX codes exactly: #FFB500, #003366
**Percentage not working?** → Edit DAX measure with FORMAT function
**Layout issues?** → Adjust visual size and positioning in General properties

**Let me know which step you need help with!**
