-- ConventiCore Power BI Data Model - SQL Views
-- These views create the optimal data structure for Power BI consumption
-- Execute these against your database or use as guidance for Excel Power Query

-- Main Events View with KPI Calculations
CREATE VIEW vw_PowerBI_Events AS
SELECT 
    e.event_id,
    e.name AS event_name,
    e.venue_area,
    e.event_type,
    e.start_dt AS event_start,
    e.end_dt AS event_end,
    e.est_attendance,
    e.actual_attendance,
    -- Calculate event revenue (if sales data available)
    COALESCE(s.total_revenue, 0) AS event_revenue,
    COALESCE(s.total_units, 0) AS total_units_sold,
    -- Event metrics
    CASE 
        WHEN e.est_attendance > 0 THEN COALESCE(s.total_revenue, 0) / e.est_attendance 
        ELSE 0 
    END AS revenue_per_attendee,
    CASE 
        WHEN e.est_attendance > 0 THEN COALESCE(s.total_units, 0) / CAST(e.est_attendance AS DECIMAL) 
        ELSE 0 
    END AS conversion_rate,
    -- Time intelligence
    YEAR(e.start_dt) AS event_year,
    MONTH(e.start_dt) AS event_month,
    DATENAME(MONTH, e.start_dt) AS event_month_name,
    DATEPART(QUARTER, e.start_dt) AS event_quarter,
    DATEPART(WEEK, e.start_dt) AS event_week,
    -- Event status
    CASE 
        WHEN e.start_dt > GETDATE() THEN 'Upcoming'
        WHEN e.end_dt < GETDATE() THEN 'Completed'
        ELSE 'In Progress'
    END AS event_status
FROM events_processed e
LEFT JOIN (
    SELECT 
        event_id,
        SUM(revenue) AS total_revenue,
        SUM(units_sold) AS total_units
    FROM sales_processed 
    WHERE event_id IS NOT NULL
    GROUP BY event_id
) s ON e.event_id = s.event_id;

-- Inventory KPIs View
CREATE VIEW vw_PowerBI_InventoryKPIs AS
SELECT 
    c.asof_date,
    c.checkpoint,
    c.sku,
    s.description AS sku_description,
    s.category,
    s.cost,
    s.price,
    c.qty AS current_stock,
    s.cost * c.qty AS inventory_value,
    -- Calculate Days of Supply (requires sales velocity)
    CASE 
        WHEN sv.avg_daily_sales > 0 THEN c.qty / sv.avg_daily_sales
        ELSE 999 
    END AS days_of_supply,
    -- Reorder calculations
    CASE 
        WHEN c.qty <= (sv.avg_daily_sales * s.lead_time_days * 1.5) THEN 'CRITICAL'
        WHEN c.qty <= (sv.avg_daily_sales * s.lead_time_days * 2.0) THEN 'LOW'
        WHEN c.qty >= (sv.avg_daily_sales * s.lead_time_days * 6.0) THEN 'OVERSTOCK'
        ELSE 'OPTIMAL'
    END AS stock_status,
    -- Financial metrics
    (s.price - s.cost) / s.price AS gross_margin_pct,
    CASE 
        WHEN s.cost * c.qty > 0 AND sv.total_revenue > 0 
        THEN sv.total_revenue / (s.cost * c.qty) 
        ELSE 0 
    END AS gmroi
FROM counts_processed c
LEFT JOIN sample_sku_data s ON c.sku = s.sku
LEFT JOIN (
    SELECT 
        sku,
        AVG(units_sold) AS avg_daily_sales,
        SUM(revenue) AS total_revenue
    FROM sales_processed 
    WHERE date >= DATEADD(DAY, -30, GETDATE())
    GROUP BY sku
) sv ON c.sku = sv.sku
WHERE c.checkpoint = 'EOM' -- Most recent inventory snapshot
  AND c.asof_date = (
      SELECT MAX(asof_date) 
      FROM counts_processed c2 
      WHERE c2.sku = c.sku AND c2.checkpoint = 'EOM'
  );

-- Sales Performance View
CREATE VIEW vw_PowerBI_SalesPerformance AS
SELECT 
    s.date AS sales_date,
    s.sku,
    sk.description AS sku_description,
    sk.category,
    sk.cost,
    sk.price,
    s.units_sold,
    s.revenue,
    s.event_id,
    e.event_name,
    e.event_type,
    s.channel,
    -- Calculated metrics
    s.revenue / s.units_sold AS avg_unit_price,
    (s.revenue - (sk.cost * s.units_sold)) AS gross_margin,
    (s.revenue - (sk.cost * s.units_sold)) / s.revenue AS gross_margin_pct,
    -- Time intelligence
    YEAR(s.date) AS sales_year,
    MONTH(s.date) AS sales_month,
    DATENAME(MONTH, s.date) AS sales_month_name,
    DATEPART(QUARTER, s.date) AS sales_quarter,
    DATEPART(WEEK, s.date) AS sales_week,
    DATENAME(WEEKDAY, s.date) AS sales_day_of_week,
    -- Event correlation
    CASE 
        WHEN s.event_id IS NOT NULL THEN 'Event-Driven'
        ELSE 'Baseline'
    END AS sales_type
FROM sales_processed s
LEFT JOIN sample_sku_data sk ON s.sku = sk.sku
LEFT JOIN vw_PowerBI_Events e ON s.event_id = e.event_id;

-- Executive Summary Metrics View
CREATE VIEW vw_PowerBI_ExecutiveSummary AS
SELECT 
    -- Date dimension
    GETDATE() AS report_date,
    YEAR(GETDATE()) AS current_year,
    MONTH(GETDATE()) AS current_month,
    DATENAME(MONTH, GETDATE()) AS current_month_name,
    
    -- Financial KPIs
    (SELECT SUM(revenue) 
     FROM sales_processed 
     WHERE YEAR(date) = YEAR(GETDATE()) 
       AND MONTH(date) = MONTH(GETDATE())) AS mtd_revenue,
       
    (SELECT SUM(revenue) 
     FROM sales_processed 
     WHERE YEAR(date) = YEAR(GETDATE())) AS ytd_revenue,
    
    -- Inventory KPIs
    (SELECT AVG(days_of_supply) 
     FROM vw_PowerBI_InventoryKPIs 
     WHERE stock_status IN ('OPTIMAL', 'LOW')) AS avg_days_of_supply,
     
    (SELECT AVG(gross_margin_pct) 
     FROM vw_PowerBI_SalesPerformance 
     WHERE sales_month = MONTH(GETDATE())) AS avg_gross_margin_pct,
     
    (SELECT AVG(gmroi) 
     FROM vw_PowerBI_InventoryKPIs 
     WHERE gmroi > 0) AS avg_gmroi,
     
    -- Operational metrics
    (SELECT COUNT(*) 
     FROM vw_PowerBI_InventoryKPIs 
     WHERE stock_status = 'CRITICAL') AS critical_stock_items,
     
    (SELECT COUNT(*) 
     FROM vw_PowerBI_Events 
     WHERE event_status = 'Upcoming' 
       AND event_start BETWEEN GETDATE() AND DATEADD(DAY, 30, GETDATE())) AS upcoming_events_30d;
