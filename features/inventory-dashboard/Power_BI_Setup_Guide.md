# Power BI Setup Guide
## Step-by-Step Implementation for MCCNO Executive Dashboard

### Prerequisites Checklist

#### Technical Requirements
- **Power BI Desktop**: Latest version (minimum 2.130.x)
- **Excel Data Source**: ConventiCore monthly-inventory-manager workbook
- **Brand Assets**: MCCNO logo files (SVG/PNG), color codes, fonts
- **Access Permissions**: Data refresh and publishing rights
- **Display Hardware**: 1920x1080 minimum resolution for development

#### Business Requirements Validation
- **Executive Stakeholder Approval**: C-suite sign-off on dashboard scope
- **Data Quality Verification**: Inventory and sales data accuracy confirmed
- **KPI Target Agreement**: Performance benchmarks established (GMROI 3.0x, etc.)
- **Refresh Schedule**: Business hours data update requirements
- **User Access List**: Executive team members requiring dashboard access

### Phase 1: Data Source Preparation (30 minutes)

#### Excel Workbook Connection
1. **Open ConventiCore Workbook**: Navigate to monthly-inventory-manager Excel file
2. **Verify Table Structure**: Confirm named tables exist:
   - tblEvents (event calendar data)
   - tblSKU (product master data)  
   - tblInventory (current stock levels)
   - tblSales (transaction history)
   - tblConfig (system parameters)

3. **Data Refresh Test**: Ensure Excel Power Query connections work properly
4. **File Location**: Place workbook in accessible network location or SharePoint

#### Alternative: Database Connection (if applicable)
```sql
-- Sample SQL views for direct database connection
CREATE VIEW vw_Executive_KPIs AS
SELECT 
    GMROI = SUM(GrossMargin) / AVG(InventoryValue),
    TotalRevenue = SUM(Revenue),
    SellThroughRate = SUM(UnitsSold) / SUM(UnitsAvailable),
    DaysOfSupply = AVG(CurrentStock) / AVG(DailyUsage)
FROM ConventiCore_Analytics
WHERE DateRange = 'CurrentMonth';
```

### Phase 2: Power BI Desktop Setup (45 minutes)

#### Initial Configuration
1. **Launch Power BI Desktop**
2. **Import Data Sources**:
   - File → Get Data → Excel → Select ConventiCore workbook
   - Choose relevant tables: Events, SKU, Inventory, Sales, Config
   - Preview data to ensure accuracy

3. **Data Model Relationships**:
   - Events.event_id ↔ Sales.event_id (Many-to-One)
   - SKU.sku ↔ Sales.sku (One-to-Many)
   - SKU.sku ↔ Inventory.sku (One-to-Many)
   - Auto-detect relationships, verify cardinality

#### MCCNO Theme Implementation
1. **Create Custom Theme**:
```json
{
  "name": "MCCNO Executive Theme",
  "dataColors": [
    "#003366",  // Primary Navy
    "#FFB500",  // Golden Accent  
    "#666666",  // Medium Gray
    "#F5F5F0",  // Neutral Support
    "#28A745",  // Success Green
    "#DC3545"   // Alert Red
  ],
  "background": "#FFFFFF",
  "foreground": "#003366",
  "tableAccent": "#F5F5F0"
}
```

2. **Apply Theme**: View → Themes → Browse for themes → Select MCCNO theme file
3. **Logo Integration**: Insert → Image → Select MCCNO logo (SVG preferred)

### Phase 3: Page 1 - Executive Overview (60 minutes)

#### KPI Card Creation
1. **GMROI Card**:
   - Visual: Card
   - Field: Calculated measure `GMROI = SUM(Sales[Revenue] - Sales[COGS]) / AVERAGE(Inventory[Value])`
   - Formatting: Golden text (#FFB500), 32pt font
   - Background: White with navy header

2. **Revenue Card**:
   - Visual: Card  
   - Field: `Total Revenue = SUM(Sales[Revenue])`
   - Conditional formatting: Green if positive variance, red if negative
   - Add sparkline for trend visualization

3. **Sell-Through Card**:
   - Visual: Card
   - Field: `Sell Through = DIVIDE(SUM(Sales[Units]), SUM(Inventory[Available]))`
   - Target line at 75%
   - Color coding: Golden >75%, Red <75%

4. **Days of Supply Card**:
   - Visual: Card
   - Field: `DOS = DIVIDE(SUM(Inventory[Current]), AVERAGE(Sales[Daily_Usage]))`
   - Optimal range indicator: 20-40 days
   - Status text: "Optimal", "Low", "High"

#### Revenue Waterfall Chart
1. **Visual**: Waterfall chart
2. **Category Axis**: Month periods
3. **Y Axis**: Revenue values
4. **Breakdown**: Baseline + Event contributions
5. **Formatting**: Navy bars, golden highlights
6. **Labels**: Show values and percentages

#### Risk Alert Panel
1. **Visual**: Table with conditional formatting
2. **Data**: Critical inventory alerts from DAX measures
3. **Calculations**:
```dax
StockoutRisk = 
CALCULATE(
    COUNTROWS(Inventory),
    Inventory[Current_Stock] < Inventory[Reorder_Point]
)
```
4. **Formatting**: Red for critical, yellow for warning, blue for info

### Phase 4: Page 2 - Event Impact Analysis (60 minutes)

#### Event Performance Matrix
1. **Visual**: Scatter chart
2. **X Axis**: Events[Est_Attendance] 
3. **Y Axis**: `Event Revenue = CALCULATE(SUM(Sales[Revenue]), USERELATIONSHIP(Sales[Event_ID], Events[Event_ID]))`
4. **Size**: `Event Margin = Event Revenue - Event Costs`
5. **Color**: Event type categories
6. **Trend Line**: Enable analytics trend line

#### Inventory-Sales Correlation
1. **Visual**: Combo chart (column and line)
2. **Shared Axis**: Time periods
3. **Column Values**: Pre-event inventory levels
4. **Line Values**: Sales velocity during events
5. **Secondary Y Axis**: Configure for different scales

#### Conversion Funnel
1. **Visual**: Funnel chart
2. **Categories**: Attendance → Conversions → Units → Revenue
3. **Values**: Calculated measures for each stage
4. **Formatting**: Navy to golden gradient

### Phase 5: Page 3 - Inventory Intelligence (60 minutes)

#### Stock Level Heat Map
1. **Visual**: Matrix
2. **Rows**: Product categories
3. **Columns**: Locations
4. **Values**: Current stock quantities
5. **Conditional Formatting**: Color scale from white (high) to navy (low) to red (critical)

#### Reorder Dashboard
1. **Visual**: Table
2. **Columns**: SKU, Current Stock, Reorder Point, Recommended Order
3. **Sorting**: Priority ranking (High/Medium/Low)
4. **Conditional Formatting**: Red highlights for urgent actions

#### Shrink Analysis
1. **Visual**: Column chart
2. **X Axis**: Time periods
3. **Y Axis**: Shrink variance percentages
4. **Reference Line**: 5% threshold
5. **Data Labels**: Show variance values

### Phase 6: Page 4 - Financial Performance (60 minutes)

#### Category P&L
1. **Visual**: Stacked bar chart
2. **Axis**: Product categories
3. **Values**: Revenue, COGS, Gross Margin
4. **Formatting**: Navy for revenue, golden for margin

#### GMROI Trending
1. **Visual**: Line chart
2. **X Axis**: Date hierarchy (Month/Quarter)
3. **Y Axis**: GMROI calculated measure
4. **Reference Line**: 3.0x target
5. **Data Labels**: Show values for key points

#### Investment Planning
1. **Visual**: Clustered column chart
2. **Axis**: Recommended purchase categories
3. **Values**: Investment amount, Expected ROI
4. **Formatting**: Navy columns with golden ROI indicators

### Phase 7: Interactive Features (30 minutes)

#### Filter Panel Setup
1. **Add Slicers**: 
   - Time Period: Month/Quarter/YTD buttons
   - Event Type: Multi-select dropdown
   - Product Category: Multi-select dropdown
   - Location: Toggle switches

2. **Slicer Formatting**:
   - Background: Neutral support color (#F5F5F0)
   - Selected: Navy background (#003366)
   - Unselected: White background

#### Navigation Elements
1. **Page Navigation**: Add bookmarks for quick executive navigation
2. **Drill Through**: Configure drill-through pages for detailed analysis
3. **Tooltips**: Custom tooltips with additional context

### Phase 8: Mobile Optimization (30 minutes)

#### Mobile Layout Creation
1. **View Menu**: Switch to Mobile layout view
2. **Rearrange Visuals**: Stack KPIs in 2x2 grid
3. **Resize Elements**: Ensure touch-friendly interaction
4. **Test Navigation**: Verify swipe and tap functionality

### Phase 9: Testing & Validation (45 minutes)

#### Data Accuracy Verification
1. **KPI Validation**: Compare calculated values against source Excel
2. **Chart Accuracy**: Verify visual representations match data
3. **Filter Testing**: Ensure slicers produce correct filtered results
4. **Cross-Page Consistency**: Verify data consistency across pages

#### Performance Testing
1. **Load Time**: Measure initial dashboard load (target <10 seconds)
2. **Interaction Speed**: Test filter and navigation responsiveness
3. **Data Refresh**: Verify scheduled refresh functionality
4. **Mobile Performance**: Test on tablet devices

### Phase 10: Deployment & Publishing (30 minutes)

#### Power BI Service Publishing
1. **Save Desktop File**: Save .pbix file with version number
2. **Publish to Service**: File → Publish → Select workspace
3. **Dataset Configuration**: Configure data source credentials
4. **Refresh Schedule**: Set up automated data refresh

#### Access Management
1. **Workspace Permissions**: Add executive team members
2. **Dashboard Sharing**: Configure appropriate access levels
3. **Mobile App**: Verify dashboard appears correctly in mobile app

### Maintenance Schedule

#### Daily Tasks
- **Data Refresh Monitoring**: Verify successful overnight data updates
- **Alert Review**: Check for new critical alerts or warnings
- **Performance Check**: Ensure dashboard loads within acceptable times

#### Weekly Tasks  
- **Data Quality Audit**: Verify accuracy of key calculations
- **User Feedback Collection**: Gather executive feedback on usability
- **Performance Metrics**: Review usage analytics and optimization opportunities

#### Monthly Tasks
- **Brand Compliance Review**: Ensure MCCNO standards maintained
- **KPI Target Review**: Update performance benchmarks if needed
- **Feature Enhancement**: Evaluate requests for additional functionality

#### Quarterly Tasks
- **Comprehensive Testing**: Full dashboard functionality verification
- **Security Review**: Access permissions and data security audit
- **Strategic Alignment**: Ensure dashboard continues to meet executive needs

### Troubleshooting Guide

#### Common Issues
1. **Slow Performance**: Reduce data model complexity, optimize DAX measures
2. **Data Connection Errors**: Verify Excel file location and permissions
3. **Visual Formatting Issues**: Reapply MCCNO theme, check custom colors
4. **Mobile Display Problems**: Recreate mobile layout, test on actual devices

#### Support Contacts
- **Technical Issues**: IT Support - Power BI functionality
- **Data Questions**: Analytics Team - KPI calculations and insights
- **Brand Issues**: Marketing Team - MCCNO compliance verification
- **Business Support**: Dashboard Owner - Strategic questions and enhancements

### Success Metrics

#### Technical Performance
- **Load Time**: <10 seconds initial load
- **User Adoption**: >80% executive team regular usage
- **Data Accuracy**: 99.5% accuracy vs source systems
- **Uptime**: 99% availability during business hours

#### Business Impact
- **Decision Speed**: 50% faster executive decision making
- **Insight Discovery**: 5+ new actionable insights per month
- **Data Confidence**: Executive trust in dashboard accuracy >95%
- **ROI Achievement**: Dashboard development cost recovered within 6 months
