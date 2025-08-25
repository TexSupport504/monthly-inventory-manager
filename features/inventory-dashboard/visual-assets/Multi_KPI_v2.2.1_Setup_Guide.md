# Multi KPI v2.2.1 - Complete Setup Guide
## MCCNO Executive Dashboard Configuration

### ✅ **Current Status:**
- Multi KPI visual added ✓
- 4 measures added to Values well ✓
  - GMROI
  - Total_Revenue
  - Sell_Through_Rate
  - Days_of_Supply

---

## 🎨 **Step-by-Step Formatting (Multi KPI v2.2.1)**

### **Step 1: Basic Layout Configuration**
1. **Select your Multi KPI visual**
2. **Format pane** (paint roller icon) → **Layout**
3. **Settings:**
   - **Orientation**: Horizontal
   - **Number of columns**: 4 (for 4 KPIs in a row)
   - **Spacing**: 10-15px between cards

### **Step 2: KPI Card Styling**
**Format pane** → **KPI Cards**
1. **Card Background**: 
   - Color: White (#FFFFFF)
   - Transparency: 0%
2. **Card Border**:
   - Enable: On
   - Color: Light gray (#F5F5F0)
   - Width: 1px
3. **Card Radius**: 5px (for rounded corners)

### **Step 3: Value Formatting**
**Format pane** → **Values**

#### **For GMROI:**
- **Display units**: None (show as 4.20)
- **Decimal places**: 2
- **Font size**: 36pt
- **Font color**: Conditional formatting
  - Good (>3.0): Golden (#FFB500)
  - Poor (<3.0): Red (#DC3545)

#### **For Total_Revenue:**
- **Display units**: Auto (K, M)
- **Decimal places**: 1
- **Font size**: 36pt
- **Font color**: Navy (#003366)
- **Prefix**: $ (if not automatic)

#### **For Sell_Through_Rate:**
- **Display units**: Percentage
- **Decimal places**: 1
- **Font size**: 36pt
- **Font color**: Navy (#003366)
- **Show as**: 45.2%

#### **For Days_of_Supply:**
- **Display units**: None
- **Decimal places**: 0
- **Font size**: 36pt
- **Font color**: Navy (#003366)
- **Suffix**: " days"

### **Step 4: Labels Configuration**
**Format pane** → **Labels**
1. **Show labels**: On
2. **Label position**: Below values
3. **Font size**: 14pt
4. **Font color**: Medium gray (#6C757D)
5. **Custom labels**:
   - GMROI: "GROSS MARGIN ROI"
   - Total_Revenue: "TOTAL REVENUE"
   - Sell_Through_Rate: "SELL-THROUGH RATE"
   - Days_of_Supply: "DAYS OF SUPPLY"

### **Step 5: Conditional Formatting (Advanced)**
**Format pane** → **Conditional Formatting**

#### **GMROI Rules:**
- **Rule 1**: If value ≥ 3.0 → Golden (#FFB500)
- **Rule 2**: If value < 3.0 → Red (#DC3545)

#### **Sell-Through Rate Rules:**
- **Rule 1**: If value ≥ 75% → Green (#28A745)
- **Rule 2**: If value < 75% → Orange (#FFC107)

### **Step 6: Sparklines (if available in v2.2.1)**
**Format pane** → **Sparklines**
1. **Enable**: On
2. **Position**: Bottom right of each card
3. **Color**: Same as value color
4. **Line width**: 2px

### **Step 7: Tooltips**
**Format pane** → **Tooltips**
1. **Enable**: On
2. **Custom tooltips**:
   - GMROI: "Target: 3.0+ (Current: [Value])"
   - Revenue: "Monthly performance: [Value]"
   - Sell-Through: "Target: 75%+ (Current: [Value])"
   - Days Supply: "Optimal range: 20-40 days"

---

## 🎯 **Target Indicators Setup**

### **Add Target Lines/Indicators:**
**Format pane** → **Target Line** (if available)
1. **GMROI Target**: 3.0
2. **Sell-Through Target**: 75%
3. **Days Supply Range**: 20-40 days

---

## 🎨 **MCCNO Branding Final Touches**

### **Visual Header:**
**Format pane** → **Title**
1. **Text**: "Executive KPI Summary"
2. **Font size**: 16pt
3. **Font color**: Navy (#003366)
4. **Alignment**: Center

### **Overall Visual:**
**Format pane** → **General**
1. **Background**: Light neutral (#FAFAFA)
2. **Border**: None
3. **Shadow**: Subtle (optional)

---

## ✅ **Expected Result:**
A professional 4-KPI dashboard with:
- **GMROI**: 4.20 (Golden color - good performance)
- **Revenue**: $XXXk (Navy)
- **Sell-Through**: XX.X% (Navy or Green if >75%)
- **Days Supply**: XX days (Navy)

All with proper MCCNO branding and conditional formatting!

---

## 🔧 **Troubleshooting:**
- **Can't find Conditional Formatting?** → Check "Format" vs "Analytics" panes
- **Sparklines not available?** → Feature may be version-specific
- **Colors not applying?** → Try Data Colors section instead

Let me know which step you'd like to start with!
