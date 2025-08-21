# Sample Data for ConventiCore Inventory System Testing

## Events Sample Data (CSV Format)
```csv
event_id,name,venue_area,event_type,start_dt,end_dt,est_attendance
EVT001,Q4 Tech Conference 2025,Main Hall,Conference,2025-09-15 09:00:00,2025-09-15 18:00:00,500
EVT002,Product Launch,Booth A,Launch,2025-09-20 10:00:00,2025-09-20 16:00:00,250
EVT003,Logistics Training Workshop,Room B,Training,2025-09-25 08:00:00,2025-09-25 17:00:00,100
EVT004,Holiday Customer Appreciation,Main Lobby,Customer Event,2025-12-15 14:00:00,2025-12-15 20:00:00,800
EVT005,Supplier Summit,Conference Room C,Meeting,2025-10-05 09:00:00,2025-10-05 17:00:00,75
```

## SKU Master Data (CSV Format)
```csv
sku,desc,category,cost,price,lead_time_days
SKU001,Branded Pen - Black,Promotional,0.50,2.00,14
SKU002,Small Shipping Box 10x8x6,Packaging,1.25,3.50,7
SKU003,T-Shirt Large Logo,Apparel,8.00,25.00,21
SKU004,Bubble Wrap Roll 12inch,Packaging,15.00,35.00,10
SKU005,Coffee Mug Ceramic,Promotional,3.25,12.00,14
SKU006,Shipping Labels 4x6 Roll,Labels,12.50,28.00,14
SKU007,Polo Shirt Medium,Apparel,18.00,45.00,21
SKU008,Packaging Tape 2inch,Packaging,2.25,6.50,7
SKU009,Notebook Leather,Promotional,7.50,18.00,14
SKU010,Priority Overnight Envelopes,Shipping,0.85,2.50,5
```

## Sample Inventory Counts (CSV Format)
```csv
asof_date,checkpoint,location,sku,qty,uom,counter_id,notes
2025-08-01,BOM,in_store,SKU001,150,EA,JD001,Fresh stock from delivery
2025-08-01,BOM,back_of_store,SKU001,500,EA,JD001,Reserve inventory
2025-08-01,BOM,in_store,SKU002,75,EA,JD001,Display area
2025-08-01,BOM,back_of_store,SKU002,200,EA,JD001,Warehouse section A
2025-08-01,BOM,in_store,SKU003,25,EA,SM002,Apparel display
2025-08-01,BOM,back_of_store,SKU003,100,EA,SM002,Apparel storage
2025-08-01,BOM,in_store,SKU004,10,ROLL,KL003,Packaging station
2025-08-01,BOM,back_of_store,SKU004,50,ROLL,KL003,Bulk storage
2025-08-01,BOM,in_store,SKU005,40,EA,JD001,Counter display
2025-08-01,BOM,back_of_store,SKU005,120,EA,JD001,Storage cabinet B
2025-08-15,MID,in_store,SKU001,135,EA,SM002,Some sales activity
2025-08-15,MID,back_of_store,SKU001,485,EA,SM002,Moved 15 to floor
2025-08-15,MID,in_store,SKU002,68,EA,KL003,Conference prep
2025-08-15,MID,back_of_store,SKU002,185,EA,KL003,Prepping for event
2025-08-15,MID,in_store,SKU003,23,EA,JD001,Good sales
2025-08-15,MID,back_of_store,SKU003,98,EA,JD001,Restocked 2 units
2025-08-15,MID,in_store,SKU004,8,ROLL,SM002,Used for packaging
2025-08-15,MID,back_of_store,SKU004,48,ROLL,SM002,No change
2025-08-15,MID,in_store,SKU005,35,EA,KL003,Popular item
2025-08-15,MID,back_of_store,SKU005,115,EA,KL003,Good reserves
```

## Sample Sales Data (CSV Format)
```csv
date,sku,units_sold,revenue,event_id,channel
2025-08-02,SKU001,12,24.00,EVT001,Walk-in
2025-08-02,SKU003,3,75.00,EVT001,Walk-in
2025-08-02,SKU005,8,96.00,EVT001,Walk-in
2025-08-03,SKU001,5,10.00,,Online
2025-08-03,SKU002,15,52.50,,Bulk
2025-08-04,SKU001,8,16.00,,Walk-in
2025-08-04,SKU004,2,70.00,,Bulk
2025-08-05,SKU003,2,50.00,,Walk-in
2025-08-05,SKU005,6,72.00,,Walk-in
2025-08-06,SKU001,15,30.00,EVT002,Event
2025-08-06,SKU002,25,87.50,EVT002,Event
2025-08-06,SKU005,12,144.00,EVT002,Event
2025-08-07,SKU001,3,6.00,,Walk-in
2025-08-07,SKU006,10,280.00,,Bulk
2025-08-08,SKU001,7,14.00,,Walk-in
2025-08-08,SKU003,1,25.00,,Walk-in
2025-08-09,SKU002,8,28.00,,Walk-in
2025-08-09,SKU004,1,35.00,,Walk-in
2025-08-10,SKU001,20,40.00,EVT003,Event
2025-08-10,SKU009,15,270.00,EVT003,Event
```

## Configuration Parameters
```csv
parameter,value,description
z_service_level,1.65,Standard deviations for safety stock calculation
default_lead_time_days,14,Default lead time when SKU data missing
target_days_of_supply,30,Planning horizon for inventory targets
max_cash_per_order,50000,Budget constraint per purchase order
shrink_threshold_pct,0.05,Flag shrink variance above this percentage
low_dos_warning,15,Days of supply warning threshold
default_event_conversion,0.15,Default conversion rate for events
default_attach_rate,1.2,Default items per transaction at events
forms_integration_enabled,TRUE,Enable Microsoft Forms data intake
manual_entry_enabled,TRUE,Enable manual transcription pathway
```

## Event Conversion & Attach Rate Mappings
```csv
mapping_type,event_type,category,rate_value
conversion,Conference,Promotional,0.20
conversion,Conference,Apparel,0.10
conversion,Conference,Packaging,0.05
conversion,Launch,Promotional,0.35
conversion,Launch,Apparel,0.15
conversion,Launch,Packaging,0.08
conversion,Training,Promotional,0.15
conversion,Training,Apparel,0.05
conversion,Customer Event,Promotional,0.25
conversion,Customer Event,Apparel,0.20
attach,Conference,Promotional,1.5
attach,Conference,Apparel,1.0
attach,Conference,Packaging,1.2
attach,Launch,Promotional,2.0
attach,Launch,Apparel,1.3
attach,Launch,Packaging,1.5
attach,Training,Promotional,1.3
attach,Training,Apparel,1.0
attach,Customer Event,Promotional,2.2
attach,Customer Event,Apparel,1.8
```

## Data Quality Test Cases

### Valid Inventory Count Entries
- All required fields present
- Quantities ≥ 0
- Valid SKU codes
- Proper checkpoint values (BOM/MID/EOM)
- Valid location codes (in_store/back_of_store)

### Invalid Entries (Should Trigger Exceptions)
```csv
asof_date,checkpoint,location,sku,qty,uom,counter_id,notes,expected_exception
2025-08-20,BOM,in_store,INVALID001,25,EA,JD001,Test invalid SKU,Invalid SKU
2025-08-20,BOM,in_store,SKU001,-5,EA,JD001,Test negative qty,Negative Quantity
2025-08-20,INVALID,in_store,SKU001,25,EA,JD001,Test invalid checkpoint,Invalid Checkpoint
2025-08-20,BOM,invalid_location,SKU001,25,EA,JD001,Test invalid location,Invalid Location
,BOM,in_store,SKU001,25,EA,JD001,Test missing date,Missing Date
2025-08-20,BOM,in_store,SKU001,,EA,JD001,Test missing qty,Missing Quantity
```

## Usage Instructions

### Loading Data into Excel
1. Copy CSV data sections above
2. Paste into respective sheets in Event-Inventory-CommandCenter.xlsx
3. Run "Refresh All" to update calculations
4. Check Exceptions sheet for any data quality issues

### Testing Scenarios
1. **Basic Inventory Planning**: Load events + SKUs + counts → Generate buy plan
2. **Event Impact Analysis**: Compare pre/post event inventory levels
3. **Shrink Detection**: Compare expected vs actual counts across checkpoints
4. **Safety Stock Validation**: Verify ROP calculations against demand patterns
5. **Exception Handling**: Process invalid data and review exception reports

### Performance Metrics to Validate
- GMROI should be > 3.0 for healthy inventory turns
- Sell-through rates > 75% indicate good demand forecasting
- Shrink < 2% suggests good inventory controls
- Days of supply between 20-40 days for optimal cash flow
- Stockout risk SKUs should be < 5% of total SKUs

This sample data provides realistic scenarios for testing all aspects of the inventory management system while demonstrating both normal operations and exception conditions.
