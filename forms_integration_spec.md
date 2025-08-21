# Microsoft Forms + Power Automate Integration Specification
# Dual Intake Strategy for Inventory Counts

## Overview
This specification enables dual intake for inventory counts:
- **Primary**: Microsoft Forms → Power Automate → Excel (mobile-friendly)  
- **Secondary**: Manual transcription grid in Excel (paper backup)
- **Canonicalization**: Both sources merge into `Counts_Entry!tblCounts`

## Microsoft Forms Setup

### Form Structure: "Inventory Count Form"

**Form Fields:**
1. **Checkpoint*** (Choice - Required)
   - BOM (Beginning of Month)
   - MID (Mid-Month) 
   - EOM (End of Month)

2. **Location*** (Choice - Required)
   - in_store (Sales Floor)
   - back_of_store (Reserve/Storage)

3. **Date Counted** (Date - Default: Today)

4. **Counter ID*** (Text - Required)
   - Employee ID or initials

5. **SKU*** (Choice/Text - Required)  
   - Dropdown populated from SKU master
   - Or allow text entry for flexibility

6. **Quantity*** (Number - Required)
   - Validation: Must be ≥ 0
   - Decimal allowed for partial units

7. **Unit of Measure** (Choice - Default: EA)
   - EA (Each)
   - BOX
   - ROLL  
   - PACK

8. **Notes** (Long Text - Optional)
   - Comments, concerns, observations

9. **Photo** (File Upload - Optional)
   - Visual verification of count

### Form Settings
- **Multiple responses**: Allowed
- **Response receipts**: Enabled  
- **Collaboration**: Restricted to organization
- **Response options**: Anyone in organization can respond

## Power Automate Flow: "Forms-to-Excel-Inventory"

### Trigger
**When a new response is submitted** (Microsoft Forms)
- Form: Inventory Count Form

### Actions Sequence

1. **Get response details** 
   - Get full response from Forms

2. **Compose - Generate Unique Key**
   - Formula: `concat(formatDateTime(body('Get_response_details')?['r3d1c8c2e98d4f1a9f2b3c4d5e6f7g8h'],'yyyyMMdd'),'|',body('Get_response_details')?['r1a2b3c4d5e6f7g8h9i0j1k2l3m4n5o'],'|',body('Get_response_details')?['r2b3c4d5e6f7g8h9i0j1k2l3m4n5o6p'],'|',body('Get_response_details')?['r5e6f7g8h9i0j1k2l3m4n5o6p7q8r9s'],'|',body('Get_response_details')?['r4d5e6f7g8h9i0j1k2l3m4n5o6p7q8r'])`

3. **Compose - Clean Quantity**
   - Convert text to number
   - Handle decimal separators
   - Validate ≥ 0

4. **Condition - Validate Required Fields**
   - Check all required fields are present
   - SKU exists in master data (optional lookup)

5. **Add a row into a table** (Excel Online)
   - **File**: Event-Inventory-CommandCenter.xlsx
   - **Table**: Forms_Inbox!tblFormsRaw
   - **Mapping**:
     ```
     Response_ID: @{body('Get_response_details')?['responder']}
     Submitted_At: @{body('Get_response_details')?['submitDate']}
     Checkpoint: @{body('Get_response_details')?['r1a2b3c4d5e6f7g8h9i0j1k2l3m4n5o']}
     Location: @{body('Get_response_details')?['r2b3c4d5e6f7g8h9i0j1k2l3m4n5o6p']}
     Date_Counted: @{body('Get_response_details')?['r3d1c8c2e98d4f1a9f2b3c4d5e6f7g8h']}
     SKU: @{body('Get_response_details')?['r5e6f7g8h9i0j1k2l3m4n5o6p7q8r9s']}
     Qty: @{outputs('Compose_-_Clean_Quantity')}
     UOM: @{body('Get_response_details')?['r6f7g8h9i0j1k2l3m4n5o6p7q8r9s0t']}
     Counter_ID: @{body('Get_response_details')?['r4d5e6f7g8h9i0j1k2l3m4n5o6p7q8r']}
     Notes: @{body('Get_response_details')?['r7g8h9i0j1k2l3m4n5o6p7q8r9s0t1u']}
     Photo: @{body('Get_response_details')?['r8h9i0j1k2l3m4n5o6p7q8r9s0t1u2v']}
     Processed: FALSE
     ```

6. **Condition - Success/Error Handling**
   - **If Success**: Send confirmation email to counter
   - **If Error**: Log to exceptions, notify admin

### Error Handling
- Invalid SKU → Flag for review in tblExceptions
- Duplicate key → Log warning, allow (handled in Excel)
- Missing required → Reject with notification
- System errors → Admin notification with retry logic

## Excel Power Query Integration

### Query 1: "qry_Forms_Normalize" 
**Source**: Forms_Inbox!tblFormsRaw
**Purpose**: Clean and normalize Forms responses

```powerquery
let
    Source = Excel.CurrentWorkbook(){[Name="tblFormsRaw"]}[Content],
    #"Changed Type" = Table.TransformColumnTypes(Source,{
        {"Submitted_At", type datetimezone},
        {"Date_Counted", type date},
        {"Qty", type number}
    }),
    #"Added Unique Key" = Table.AddColumn(#"Changed Type", "Unique_Key", 
        each Date.ToText([Date_Counted], "yyyyMMdd") & "|" & 
             [Checkpoint] & "|" & [Location] & "|" & [SKU] & "|" & [Counter_ID]),
    #"Added Source" = Table.AddColumn(#"Added Unique Key", "Source", each "Forms"),
    #"Added Validated" = Table.AddColumn(#"Added Source", "Validated", 
        each [Date_Counted] <> null and [Checkpoint] <> null and [Location] <> null 
             and [SKU] <> null and [Qty] >= 0),
    #"Filtered Rows" = Table.SelectRows(#"Added Validated", each ([Processed] = false))
in
    #"Filtered Rows"
```

### Query 2: "qry_Manual_Normalize"
**Source**: Counts_Manual!tblCountsManual  
**Purpose**: Clean and normalize manual entries

```powerquery
let
    Source = Excel.CurrentWorkbook(){[Name="tblCountsManual"]}[Content],
    #"Filtered Rows" = Table.SelectRows(Source, each ([Status] = "Ready")),
    #"Added Unique Key" = Table.AddColumn(#"Filtered Rows", "Unique_Key",
        each Date.ToText([Date_Counted], "yyyyMMdd") & "|" & 
             [Checkpoint] & "|" & [Location] & "|" & [SKU] & "|" & [Counter_ID]),
    #"Added Source" = Table.AddColumn(#"Added Unique Key", "Source", each "Manual"),
    #"Added Submitted At" = Table.AddColumn(#"Added Source", "Submitted_At", each DateTime.LocalNow()),
    #"Reordered Columns" = Table.SelectColumns(#"Added Submitted At",{
        "Unique_Key", "Date_Counted", "Checkpoint", "Location", "SKU", 
        "Qty", "UOM", "Counter_ID", "Notes", "Source", "Submitted_At", "Validated"
    })
in
    #"Reordered Columns"
```

### Query 3: "qry_Counts_Union"
**Purpose**: Combine and deduplicate all count sources

```powerquery
let
    Forms = qry_Forms_Normalize,
    Manual = qry_Manual_Normalize,
    Combined = Table.Combine({Forms, Manual}),
    #"Sorted Rows" = Table.Sort(Combined,{{"Submitted_At", Order.Descending}}),
    #"Removed Duplicates" = Table.Distinct(#"Sorted Rows", {"Unique_Key"}),
    #"Added AsOf Date" = Table.AddColumn(#"Removed Duplicates", "AsOf_Date", each [Date_Counted])
in
    #"Added AsOf Date"
```

## Implementation Steps

### Phase 1: Forms Creation (15 minutes)
1. Create Microsoft Form with specified fields
2. Set up field validation and defaults
3. Test form submission and response capture
4. Share with inventory team

### Phase 2: Power Automate Flow (30 minutes)
1. Create new automated cloud flow
2. Configure Forms trigger
3. Add Excel table action
4. Test end-to-end flow
5. Enable error notifications

### Phase 3: Excel Integration (20 minutes)
1. Create Power Queries in Excel
2. Set up automatic refresh (15 minutes)
3. Test data flow and validation
4. Configure exception handling

### Phase 4: Testing & Validation (30 minutes)
1. Submit test Forms responses
2. Verify data lands in Excel correctly
3. Test manual entry pathway
4. Validate deduplication logic
5. Check exception reporting

## QR Code Generation (Optional Enhancement)

Create QR codes for quick form access:
- Base URL: `https://forms.office.com/r/[FormID]`
- Pre-filled URLs for common scenarios:
  - BOM counts: `?checkpoint=BOM&date=[today]`
  - Specific locations: `&location=in_store`

## Monitoring & Maintenance

### Daily Checks
- Review tblExceptions for data quality issues
- Verify Forms responses are processing
- Check for stuck Power Automate flows

### Weekly Maintenance  
- Archive processed Forms responses
- Clear resolved exceptions
- Update SKU dropdown in Forms (if needed)
- Review duplicate patterns

### Monthly Review
- Analyze form submission patterns
- Optimize field defaults based on usage
- Update validation rules if needed
- Train staff on any improvements

## Backup & Resilience

**If Microsoft Forms is unavailable:**
1. Use manual transcription grid (always available)
2. Export form template for printing
3. Bulk entry catch-up when service restored

**If Power Automate fails:**
1. Forms still collect responses
2. Manual trigger available in Excel
3. IT can run recovery script

**If Excel is offline:**
1. Forms continue collecting (cloud storage)
2. Manual counts on paper sheets
3. Batch import upon reconnection

## Security Considerations

- **Forms access**: Restricted to organization
- **Excel workbook**: SharePoint/OneDrive permissions
- **Power Automate**: Runs under service account
- **Data retention**: Follow company policy for count records
- **Photo uploads**: Review storage and access policies

This dual intake strategy ensures robust, reliable inventory counting with built-in redundancy and excellent user experience across mobile and desktop platforms.
