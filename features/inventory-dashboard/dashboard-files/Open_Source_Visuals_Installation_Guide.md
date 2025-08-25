# MCCNO Dashboard - Open Source Visuals Installation Guide

## 🚀 Quick Install (5 minutes)

### Method 1: Direct from Power BI Desktop

1. **Open Power BI Desktop**
2. **Visualizations pane** → Click **"..."** → **"Get more visuals"**
3. **Search and install these visuals:**

#### Essential Visuals (Install These First):

```
✅ Advanced Card Visual - Enhanced KPI cards
✅ Multi KPI - Multiple KPIs in one visual  
✅ HTML Content - For MCCNO logo/branding
✅ Bullet Chart - Performance vs targets
```

#### Enhanced Analytics (Optional):

```
✅ Enhanced Scatter Chart - Event analysis
✅ Calendar Heatmap - Sales patterns
✅ Word Cloud - Category analysis
```

### Method 2: Web Installation (Personal Account)

1. **Visit AppSource**: https://appsource.microsoft.com/en-us/marketplace/apps?product=power-bi-visuals
2. **Search for each visual by name**
3. **Click "Get it now"** 
4. **Sign in with your personal Microsoft account** (same one used for Power BI Desktop)
5. **Visuals auto-sync to your Power BI Desktop**

> **Note**: Personal Microsoft accounts work perfectly with Power BI visuals!

## 🎯 Recommended Dashboard Layout

### Page 1: Executive Overview

```
[MCCNO Logo - HTML Content]          [Dashboard Title]
[Multi KPI Visual - All 4 main KPIs spanning full width]
[Bullet Chart - GMROI vs Target]     [Enhanced Scatter - Events]
[Advanced Cards - Risk Alerts]       [Calendar Heatmap - Trends]
```

### Visual Configuration:

#### Multi KPI Setup:

- **Values**: GMROI, Total_Revenue, Sell_Through_Rate, Days_of_Supply
- **Colors**: Golden (#FFB500) for good, Red (#DC3545) for alerts
- **Format**: Add sparklines for trends

#### HTML Content (MCCNO Branding):

```html
<div style="background: #003366; color: white; padding: 20px; text-align: center;">
    <h1 style="margin: 0; font-family: 'Segoe UI';">MCCNO Executive Dashboard</h1>
    <p style="margin: 5px 0 0 0;">Inventory Intelligence & Performance Analytics</p>
</div>
```

#### Bullet Chart (GMROI Performance):

- **Actual**: GMROI measure
- **Target**: 3.0
- **Colors**: Navy background, golden for achievement

## 🎨 MCCNO Color Scheme Application

### For Each Visual:

- **Background**: White (#FFFFFF)
- **Headers**: Navy (#003366)  
- **Good Performance**: Golden (#FFB500)
- **Alerts**: Red (#DC3545)
- **Neutral**: Gray (#6C757D)

## 🔧 Troubleshooting

### If Visual Doesn't Install (Personal Account)

1. **Check Power BI version** (need 2.130.x+)
2. **Sign in to Power BI Desktop** with your personal Microsoft account
3. **Restart Power BI Desktop** after installation
4. **Check if you have Power BI Free** (sufficient for custom visuals)
5. **Try Method 1** (direct install) if web method doesn't work

> **Personal Account Benefits**: You can use ALL free visuals without restrictions!

### Alternative Sources:

- **GitHub**: Many visuals have open source repos
- **Power BI Community**: Additional free visuals
- **Custom Development**: Contact for custom visual needs

## 📊 Performance Tips

### For Best Performance:

- **Limit to 5-7 visuals per page**
- **Use Multi KPI instead of individual cards** when possible
- **Optimize data model** before adding complex visuals
- **Test on mobile** if dashboard will be used on tablets

## 🆓 Cost: $0.00

All recommended visuals are **completely free** and open source!

## 📞 Support

- **Technical Issues**: Power BI Community forums
- **Visual-Specific**: Each visual's AppSource page has support links
- **MCCNO Customization**: Your internal IT/Analytics team
