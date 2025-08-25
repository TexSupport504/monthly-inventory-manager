# Visual Assets Installation & Usage Guide

## 📁 **File Organization:**

### **Step 1: Move Your Downloaded Visuals**

Move your 4 downloaded visual files to: `visual-assets/` folder

### **Expected Files:**

```
visual-assets/
├── AdvancedCardVisual.pbiviz
├── MultiKPI.pbiviz  
├── HTMLContent.pbiviz
└── BulletChart.pbiviz
```

## 🚀 **Installation Process:**

### **Method 1: Import from Files (Recommended)**

1. **Open Power BI Desktop**
2. **Visualizations pane** → Click **"..."** → **"Import a visual from a file"**
3. **Navigate to:** `visual-assets/` folder
4. **Select and import each .pbiviz file one by one**

### **Method 2: If Files Are .zip Format**

1. **Extract each .zip file** to get the .pbiviz files inside
2. **Follow Method 1** with the extracted .pbiviz files

## ✅ **Verification:**

After importing, you should see **4 new icons** in your Visualizations pane alongside the standard Power BI visuals.

## 🎯 **Next Steps After Installation:**

### **Step 1: Replace Your GMROI Card**

1. **Delete current GMROI card**
2. **Add Multi KPI visual** instead
3. **Configure with all 4 measures:**
   - GMROI
   - Total_Revenue  
   - Sell_Through_Rate
   - Days_of_Supply

### **Step 2: Add MCCNO Branding Header**

1. **Add HTML Content visual**
2. **Paste this code:**

```html
<div style="background: #003366; color: white; padding: 20px; text-align: center;">
    <h1 style="margin: 0; font-family: 'Segoe UI';">MCCNO Executive Dashboard</h1>
    <p style="margin: 5px 0 0 0;">Inventory Intelligence & Performance Analytics</p>
</div>
```

### **Step 3: Create GMROI Performance Tracker**

1. **Add Bullet Chart visual**
2. **Configure:**
   - Actual Value: GMROI measure
   - Target Value: 3.0
   - Colors: Golden for good, Red for poor

## 🔧 **Troubleshooting:**

### **If VS Code Doesn't Show Files:**

1. **Refresh VS Code Explorer** (F5)
2. **Check file extensions** - should be .pbiviz
3. **Files might be in Downloads folder** - move to visual-assets/

### **If Import Fails:**

1. **Check Power BI Desktop version** (need 2.130.x+)
2. **Verify file integrity** - redownload if needed
3. **Try one visual at a time**

### **If You Can't Find Downloaded Files:**

Check these common locations:

- `Downloads` folder
- `Desktop`
- Browser download location
- Email attachments folder

## 📞 **Need Help?**

Tell me:

1. **Where you saved the 4 visual files**
2. **What file extensions they have** (.pbiviz, .zip, etc.)
3. **Any error messages** you see

Then I can give you exact next steps!
