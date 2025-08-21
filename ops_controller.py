#!/usr/bin/env python3
"""
ConventiCore - Convention Events Inventory Management System
Senior Economics & Inventory Strategist Command Interface

This script provides operational commands for managing the inventory system.
Usage: python ops_controller.py [command] [args]

Commands:
  /ingest events [file]     - Parse event calendar into system
  /ingest audits [file]     - Load BOM/MID/EOM counts 
  /ingest sales [file]      - Load optional sales history
  /forms setup ms           - Generate Microsoft Forms integration
  /counts manual enable     - Build manual transcription capability
  /counts unify            - Normalize & dedupe all count sources
  /forecast [YYYY-MM]      - Generate event-aware demand forecast
  /plan [YYYY-MM]          - Compute ROP, safety stock, buy recommendations
  /pnl [YYYY-MM]           - Calculate GM, GMROI, sell-through metrics
  /build workbook          - Generate complete Excel workbook
  /publish pack [YYYY-MM]  - Export dashboard + CSVs to reports

Author: Senior Economics & Inventory Strategist — Convention Events
Motto: "Let's turn stock into profit, not décor"
"""

import sys
import os
import argparse
import pandas as pd
import numpy as np
from datetime import datetime, timedelta
import json
import csv
from pathlib import Path

class InventoryStrategist:
    """Senior Economics & Inventory Strategist — Convention Events"""
    
    def __init__(self):
        self.base_path = Path(".")
        self.data_path = self.base_path / "data"
        self.reports_path = self.base_path / "reports"
        self.config = self.load_config()
        
        # Ensure directories exist
        self.data_path.mkdir(exist_ok=True)
        self.reports_path.mkdir(exist_ok=True)
        
        print("🎯 ConventiCore - Convention Events Inventory Management System")
        print("📊 Senior Economics & Inventory Strategist — Ready")
        print("💡 \"Let's turn stock into profit, not décor\"\n")

    def load_config(self):
        """Load system configuration parameters"""
        default_config = {
            'z_service_level': 1.65,
            'default_lead_time_days': 14,
            'target_days_of_supply': 30,
            'max_cash_per_order': 50000,
            'shrink_threshold_pct': 0.05,
            'low_dos_warning': 15,
            'default_event_conversion': 0.15,
            'default_attach_rate': 1.2,
            'forms_integration_enabled': True,
            'manual_entry_enabled': True
        }
        
        config_file = self.base_path / "config.json"
        if config_file.exists():
            with open(config_file, 'r') as f:
                user_config = json.load(f)
                default_config.update(user_config)
        
        return default_config

    def save_config(self):
        """Save configuration to file"""
        config_file = self.base_path / "config.json"
        with open(config_file, 'w') as f:
            json.dump(self.config, f, indent=2)

    def ingest_events(self, file_path=None, data=None):
        """Parse event calendar into system with full event lifecycle rules"""
        print("📅 Ingesting Event Calendar with Event Rules...")
        
        if data:
            # Direct data input
            events_df = self.parse_data_input(data, 'events')
        elif file_path:
            # Handle Events.xlsx with proper column mapping
            if file_path.endswith('.xlsx'):
                print(f"📊 Processing Events.xlsx with proper column mapping...")
                events_df = pd.read_excel(file_path, sheet_name=0, header=1)
                events_df = self.transform_events_xlsx(events_df)
            else:
                events_df = pd.read_csv(file_path)
        else:
            # Use sample data
            events_df = self.get_sample_events()
        
        # Validate and normalize with event rules
        events_df = self.validate_events_with_rules(events_df)
        
        # Save processed events
        output_file = self.data_path / "events_processed.csv"
        events_df.to_csv(output_file, index=False)
        
        print(f"✅ Processed {len(events_df)} events")
        print(f"💾 Saved to: {output_file}")
        self.show_assumptions("Event ingestion with rules", [
            "In-Date = Event setup begins, crews arrive onsite", 
            "Out-Date = Load-out date, crews depart",
            "Start Date = Actual event commencement",
            "End Date = Event conclusion", 
            "Forecast Attendance = Authoritative attendee count for analysis",
            "Event lifecycle impacts inventory timing and quantities"
        ])
        return events_df

    def transform_events_xlsx(self, events_df):
        """Transform Events.xlsx format to system format with all required columns"""
        print("🔄 Transforming Events.xlsx columns...")
        
        # Column mapping from Events.xlsx to system format
        column_mapping = {
            'Event ID': 'event_id',
            'Account': 'account', 
            'Description': 'name',
            'Anchor Venue': 'venue_area',
            'Span of Attendees': 'event_type',
            'In Date': 'in_date',
            'Start Date': 'start_dt', 
            'End Date': 'end_dt',
            'Out Date': 'out_date',
            'Forecast Attendance': 'est_attendance',
            'Contact': 'contact',
            'Salesperson': 'salesperson'
        }
        
        # Create transformed DataFrame with only the columns we want
        transformed_df = pd.DataFrame()
        
        for excel_col, system_col in column_mapping.items():
            if excel_col in events_df.columns:
                transformed_df[system_col] = events_df[excel_col]
            else:
                print(f"⚠️  Column '{excel_col}' not found in Events.xlsx")
                transformed_df[system_col] = None
        
        # Clean up data types and handle missing values
        if 'est_attendance' in transformed_df.columns:
            transformed_df['est_attendance'] = pd.to_numeric(transformed_df['est_attendance'], errors='coerce').fillna(0)
        
        # Convert dates to proper format
        date_columns = ['in_date', 'start_dt', 'end_dt', 'out_date']
        for col in date_columns:
            if col in transformed_df.columns:
                transformed_df[col] = pd.to_datetime(transformed_df[col], errors='coerce')
        
        print(f"✅ Transformed {len(transformed_df)} events with full column set")
        return transformed_df

    def validate_events_with_rules(self, events_df):
        """Validate events according to the 8 event rules"""
        print("✅ Validating events with lifecycle rules...")
        
        validated_df = events_df.copy()
        
        # Rule validation and cleanup
        if 'est_attendance' in validated_df.columns:
            # Use Forecast Attendance as authoritative source (Rule 5)
            validated_df['est_attendance'] = pd.to_numeric(validated_df['est_attendance'], errors='coerce').fillna(1)
        
        # Ensure event lifecycle makes sense (Rules 1-4)
        date_cols = ['in_date', 'start_dt', 'end_dt', 'out_date']
        for col in date_cols:
            if col in validated_df.columns:
                validated_df[col] = pd.to_datetime(validated_df[col], errors='coerce')
        
        # Remove rows where all critical data is missing
        critical_cols = ['event_id', 'name', 'start_dt', 'est_attendance']
        before_count = len(validated_df)
        validated_df = validated_df.dropna(subset=[col for col in critical_cols if col in validated_df.columns], how='all')
        after_count = len(validated_df)
        
        if before_count != after_count:
            print(f"📊 Removed {before_count - after_count} incomplete event records")
        
        return validated_df

    def ingest_audits(self, file_path=None, data=None):
        """Load BOM/MID/EOM inventory counts"""
        print("📋 Ingesting Inventory Counts...")
        
        if data:
            audits_df = self.parse_data_input(data, 'audits')
        elif file_path:
            audits_df = pd.read_csv(file_path)
        else:
            audits_df = self.get_sample_counts()
        
        # Validate and normalize
        audits_df = self.validate_counts(audits_df)
        
        # Generate unique keys
        audits_df['unique_key'] = (
            audits_df['asof_date'].astype(str).str.replace('-', '') + '|' +
            audits_df['checkpoint'] + '|' +
            audits_df['location'] + '|' +
            audits_df['sku'] + '|' +
            audits_df['counter_id'].astype(str)
        )
        
        # Check for duplicates
        duplicates = audits_df[audits_df.duplicated(['unique_key'], keep=False)]
        if not duplicates.empty:
            print(f"⚠️  Found {len(duplicates)} duplicate count entries")
            self.log_exceptions(duplicates, "Duplicate count entries")
        
        # Save processed counts
        output_file = self.data_path / "counts_processed.csv"
        audits_df.to_csv(output_file, index=False)
        
        print(f"✅ Processed {len(audits_df)} inventory counts")
        print(f"💾 Saved to: {output_file}")
        return audits_df

    def ingest_sales(self, file_path=None, data=None):
        """Load optional sales history"""
        print("💰 Ingesting Sales History...")
        
        if data:
            sales_df = self.parse_data_input(data, 'sales')
        elif file_path:
            sales_df = pd.read_csv(file_path)
        else:
            sales_df = self.get_sample_sales()
        
        # Validate sales data
        sales_df['date'] = pd.to_datetime(sales_df['date'])
        sales_df = sales_df[sales_df['units_sold'] > 0]
        sales_df = sales_df[sales_df['revenue'] > 0]
        
        # Save processed sales
        output_file = self.data_path / "sales_processed.csv"
        sales_df.to_csv(output_file, index=False)
        
        print(f"✅ Processed {len(sales_df)} sales transactions")
        print(f"💾 Saved to: {output_file}")
        return sales_df

    def forms_setup_ms(self):
        """Generate Microsoft Forms integration setup"""
        print("📱 Setting up Microsoft Forms Integration...")
        
        forms_spec = {
            "form_title": "Inventory Count Form",
            "fields": [
                {
                    "name": "checkpoint",
                    "type": "choice",
                    "required": True,
                    "options": ["BOM", "MID", "EOM"],
                    "description": "Inventory checkpoint period"
                },
                {
                    "name": "location", 
                    "type": "choice",
                    "required": True,
                    "options": ["in_store", "back_of_store"],
                    "description": "Physical location of count"
                },
                {
                    "name": "date_counted",
                    "type": "date",
                    "required": True,
                    "default": "today",
                    "description": "Date when count was performed"
                },
                {
                    "name": "counter_id",
                    "type": "text",
                    "required": True,
                    "description": "Employee ID or initials"
                },
                {
                    "name": "sku",
                    "type": "choice",
                    "required": True,
                    "source": "sku_master",
                    "description": "Product SKU code"
                },
                {
                    "name": "qty",
                    "type": "number",
                    "required": True,
                    "validation": ">=0",
                    "description": "Quantity counted"
                },
                {
                    "name": "uom",
                    "type": "choice",
                    "default": "EA",
                    "options": ["EA", "BOX", "ROLL", "PACK"],
                    "description": "Unit of measure"
                },
                {
                    "name": "notes",
                    "type": "text",
                    "required": False,
                    "description": "Comments or observations"
                },
                {
                    "name": "photo",
                    "type": "file_upload",
                    "required": False,
                    "description": "Photo of counted inventory"
                }
            ],
            "power_automate_flow": {
                "trigger": "When a new response is submitted",
                "actions": [
                    "Get response details",
                    "Compose unique key",
                    "Validate required fields", 
                    "Add row to Excel table (Forms_Inbox!tblFormsRaw)",
                    "Send confirmation email"
                ]
            },
            "excel_integration": {
                "target_table": "Forms_Inbox!tblFormsRaw",
                "power_query": "qry_Forms_Normalize",
                "destination": "Counts_Entry!tblCounts"
            }
        }
        
        # Save forms specification
        forms_file = self.base_path / "forms_specification.json"
        with open(forms_file, 'w') as f:
            json.dump(forms_spec, f, indent=2)
        
        print("✅ Microsoft Forms specification generated")
        print(f"📄 Specification saved: {forms_file}")
        print("🔧 Next steps:")
        print("   1. Create form in Microsoft Forms using specification")
        print("   2. Set up Power Automate flow")
        print("   3. Configure Excel table integration")
        print("   4. Test end-to-end data flow")
        
        return forms_spec

    def counts_manual_enable(self):
        """Build manual transcription capability"""
        print("✏️  Enabling Manual Count Transcription...")
        
        # Generate manual entry template
        manual_template = pd.DataFrame({
            'entry_id': ['MANUAL_001', 'MANUAL_002', 'MANUAL_003'],
            'date_counted': ['2025-08-20', '', ''],
            'checkpoint': ['BOM', '', ''],
            'location': ['in_store', '', ''],
            'sku': ['SKU001', '', ''],
            'description': ['[Auto-filled from SKU master]', '', ''],
            'qty': [0, '', ''],
            'uom': ['EA', '', ''],
            'counter_id': ['EMP001', '', ''],
            'notes': ['', '', ''],
            'status': ['Ready', 'Draft', 'Draft'],
            'validated': [True, False, False]
        })
        
        # Save manual entry template
        template_file = self.data_path / "manual_entry_template.csv"
        manual_template.to_csv(template_file, index=False)
        
        # Generate validation rules
        validation_rules = {
            "checkpoint": ["BOM", "MID", "EOM"],
            "location": ["in_store", "back_of_store"],
            "qty_min": 0,
            "required_fields": ["date_counted", "checkpoint", "location", "sku", "qty", "counter_id"],
            "unique_key_format": "YYYYMMDD|checkpoint|location|sku|counter_id"
        }
        
        validation_file = self.base_path / "manual_entry_validation.json"
        with open(validation_file, 'w') as f:
            json.dump(validation_rules, f, indent=2)
        
        print("✅ Manual transcription capability enabled")
        print(f"📝 Template saved: {template_file}")
        print(f"🔍 Validation rules: {validation_file}")
        print("📋 Ready for paper-to-digital count entry")
        
        return manual_template

    def counts_unify(self):
        """Normalize & dedupe all count sources"""
        print("🔄 Unifying Count Sources...")
        
        unified_counts = []
        
        # Load Forms data (if exists)
        forms_file = self.data_path / "forms_responses.csv"
        if forms_file.exists():
            forms_df = pd.read_csv(forms_file)
            forms_df['source'] = 'Forms'
            unified_counts.append(forms_df)
            print(f"📱 Loaded {len(forms_df)} Forms responses")
        
        # Load Manual data (if exists)  
        manual_file = self.data_path / "manual_entries.csv"
        if manual_file.exists():
            manual_df = pd.read_csv(manual_file)
            manual_df['source'] = 'Manual'
            unified_counts.append(manual_df)
            print(f"✏️  Loaded {len(manual_df)} manual entries")
        
        # Load processed audits
        audits_file = self.data_path / "counts_processed.csv"
        if audits_file.exists():
            audits_df = pd.read_csv(audits_file)
            audits_df['source'] = 'System'
            unified_counts.append(audits_df)
            print(f"📋 Loaded {len(audits_df)} system counts")
        
        if not unified_counts:
            print("❌ No count sources found to unify")
            return None
        
        # Combine all sources
        combined_df = pd.concat(unified_counts, ignore_index=True)
        
        # Deduplicate based on unique_key (keep latest)
        combined_df['submitted_at'] = pd.to_datetime(combined_df.get('submitted_at', datetime.now()))
        combined_df = combined_df.sort_values(['unique_key', 'submitted_at'], ascending=[True, False])
        
        # Identify duplicates before deduplication
        duplicates = combined_df[combined_df.duplicated(['unique_key'], keep=False)]
        if not duplicates.empty:
            print(f"⚠️  Found {len(duplicates)} duplicate keys across sources")
            self.log_exceptions(duplicates, "Cross-source duplicates")
        
        # Keep only latest version of each unique_key
        unified_df = combined_df.drop_duplicates(['unique_key'], keep='first')
        
        # Save unified counts
        output_file = self.data_path / "counts_unified.csv"
        unified_df.to_csv(output_file, index=False)
        
        print(f"✅ Unified to {len(unified_df)} unique count records")
        print(f"💾 Saved to: {output_file}")
        print(f"🔍 Removed {len(combined_df) - len(unified_df)} duplicates")
        
        return unified_df

    def forecast(self, period):
        """Generate event-aware demand forecast"""
        print(f"🔮 Generating Demand Forecast for {period}...")
        
        # Parse period
        year, month = map(int, period.split('-'))
        start_date = datetime(year, month, 1)
        end_date = (start_date + timedelta(days=32)).replace(day=1) - timedelta(days=1)
        
        # Load required data
        sales_df = self.load_data('sales_processed.csv')
        events_df = self.load_data('events_processed.csv')
        skus_df = self.get_sample_skus()
        
        forecasts = []
        
        for _, sku in skus_df.iterrows():
            sku_code = sku['sku']
            
            # Calculate baseline demand from sales history
            sku_sales = sales_df[sales_df['sku'] == sku_code]
            if not sku_sales.empty:
                daily_sales = sku_sales.groupby('date')['units_sold'].sum()
                baseline_daily = daily_sales.mean()
                demand_std = daily_sales.std() if len(daily_sales) > 1 else baseline_daily * 0.3
            else:
                baseline_daily = 1.0  # Default assumption
                demand_std = 0.5
            
            # Calculate event lift
            period_events = events_df[
                (pd.to_datetime(events_df['start_dt']) >= start_date) &
                (pd.to_datetime(events_df['start_dt']) <= end_date)
            ]
            
            event_lift = 0
            for _, event in period_events.iterrows():
                # Get conversion and attach rates for this SKU/event combination
                conversion_rate = self.config['default_event_conversion']
                attach_rate = self.config['default_attach_rate']
                
                # Calculate event demand
                event_demand = event['est_attendance'] * conversion_rate * attach_rate
                event_lift += event_demand
            
            # Total forecast
            days_in_period = (end_date - start_date).days + 1
            baseline_demand = baseline_daily * days_in_period
            total_forecast = baseline_demand + event_lift
            
            forecasts.append({
                'sku': sku_code,
                'description': sku['desc'],
                'category': sku['category'],
                'period': period,
                'baseline_daily': round(baseline_daily, 2),
                'baseline_total': round(baseline_demand, 2),
                'event_lift': round(event_lift, 2),
                'total_forecast': round(total_forecast, 2),
                'demand_std': round(demand_std, 2),
                'confidence': 'HIGH' if not sku_sales.empty else 'LOW'
            })
        
        forecast_df = pd.DataFrame(forecasts)
        
        # Save forecast
        output_file = self.reports_path / f"forecast_{period}.csv"
        forecast_df.to_csv(output_file, index=False)
        
        print(f"✅ Generated forecasts for {len(forecast_df)} SKUs")
        print(f"📊 Total period demand: {forecast_df['total_forecast'].sum():.0f} units")
        print(f"📈 Event lift: {forecast_df['event_lift'].sum():.0f} units ({forecast_df['event_lift'].sum()/forecast_df['total_forecast'].sum()*100:.1f}%)")
        print(f"💾 Saved to: {output_file}")
        
        self.show_assumptions("Demand forecasting", [
            f"Baseline calculated from {len(sales_df)} sales transactions",
            f"Event conversion rate: {self.config['default_event_conversion']:.1%}",
            f"Attach rate: {self.config['default_attach_rate']:.1f} items/transaction",
            "New SKUs use category defaults for demand patterns"
        ])
        
        return forecast_df

    def plan(self, period):
        """Compute ROP, safety stock, buy recommendations"""
        print(f"📦 Generating Buy Plan for {period}...")
        
        # Load required data
        forecast_df = self.load_data(f"forecast_{period}.csv", self.reports_path)
        if forecast_df is None:
            print(f"❌ Forecast for {period} not found. Run /forecast {period} first.")
            return None
        
        counts_df = self.load_data('counts_unified.csv')
        skus_df = self.get_sample_skus()
        
        buy_plans = []
        total_order_value = 0
        
        for _, forecast in forecast_df.iterrows():
            sku_code = forecast['sku']
            
            # Get current stock levels
            current_stock = 0
            if counts_df is not None:
                sku_counts = counts_df[counts_df['sku'] == sku_code]
                if not sku_counts.empty:
                    current_stock = sku_counts['qty'].sum()
            
            # Get SKU parameters
            sku_info = skus_df[skus_df['sku'] == sku_code].iloc[0]
            lead_time = sku_info.get('lead_time_days', self.config['default_lead_time_days'])
            cost = sku_info.get('cost', 1.0)
            
            # Calculate safety stock
            daily_demand = forecast['total_forecast'] / 30  # Convert to daily
            demand_std = forecast['demand_std']
            
            safety_stock = (self.config['z_service_level'] * 
                          np.sqrt(demand_std**2 * lead_time + daily_demand**2 * 1))  # LT variance = 1
            
            # Calculate ROP
            rop = daily_demand * lead_time + safety_stock
            
            # Calculate recommended order quantity
            target_stock = daily_demand * self.config['target_days_of_supply'] + safety_stock
            recommended_qty = max(0, target_stock - current_stock)
            
            # Calculate Days of Supply
            dos = current_stock / daily_demand if daily_demand > 0 else 999
            
            # Order cost and priority
            order_cost = recommended_qty * cost
            total_order_value += order_cost
            
            # Determine priority
            if current_stock < rop:
                priority = "HIGH"
            elif dos < self.config['low_dos_warning']:
                priority = "MEDIUM"  
            else:
                priority = "LOW"
            
            buy_plans.append({
                'sku': sku_code,
                'description': sku_info['desc'],
                'category': sku_info['category'],
                'current_stock': current_stock,
                'forecast_30d': forecast['total_forecast'],
                'daily_demand': round(daily_demand, 2),
                'safety_stock': round(safety_stock, 0),
                'rop': round(rop, 0),
                'target_stock': round(target_stock, 0),
                'recommended_qty': round(recommended_qty, 0),
                'order_cost': round(order_cost, 2),
                'days_of_supply': round(dos, 1),
                'priority': priority,
                'lead_time_days': lead_time,
                'notes': f"SS={safety_stock:.0f}, Current DoS={dos:.1f}d"
            })
        
        buy_plan_df = pd.DataFrame(buy_plans)
        buy_plan_df = buy_plan_df.sort_values(['priority', 'days_of_supply'])
        
        # Check cash constraints
        if total_order_value > self.config['max_cash_per_order']:
            print(f"⚠️  Total order value ${total_order_value:,.2f} exceeds budget ${self.config['max_cash_per_order']:,.2f}")
            print("💡 Consider phasing orders by priority")
        
        # Save buy plan
        output_file = self.reports_path / f"buy_plan_{period}.csv"
        buy_plan_df.to_csv(output_file, index=False)
        
        # Generate summary statistics
        high_priority = len(buy_plan_df[buy_plan_df['priority'] == 'HIGH'])
        low_dos = len(buy_plan_df[buy_plan_df['days_of_supply'] < self.config['low_dos_warning']])
        
        print(f"✅ Generated buy plan for {len(buy_plan_df)} SKUs")
        print(f"🚨 HIGH priority items: {high_priority}")
        print(f"⚠️  Low DoS items (<{self.config['low_dos_warning']}d): {low_dos}")
        print(f"💰 Total order value: ${total_order_value:,.2f}")
        print(f"💾 Saved to: {output_file}")
        
        self.show_assumptions("Buy planning", [
            f"Safety stock at {self.config['z_service_level']:.2f} sigma ({(1-0.05)*100:.0f}% service level)",
            f"Target inventory: {self.config['target_days_of_supply']} days of supply",
            f"Budget constraint: ${self.config['max_cash_per_order']:,.0f} per order",
            "Lead time variance = 1 day (constant across SKUs)"
        ])
        
        return buy_plan_df

    def pnl(self, period):
        """Calculate GM, GMROI, sell-through metrics"""
        print(f"💹 Generating P&L Analysis for {period}...")
        
        # Load required data
        sales_df = self.load_data('sales_processed.csv')
        skus_df = self.get_sample_skus()
        counts_df = self.load_data('counts_unified.csv')
        
        if sales_df is None:
            print("❌ Sales data required for P&L analysis")
            return None
        
        # Filter to period
        year, month = map(int, period.split('-'))
        period_start = datetime(year, month, 1)
        period_end = (period_start + timedelta(days=32)).replace(day=1) - timedelta(days=1)
        
        sales_df['date'] = pd.to_datetime(sales_df['date'])
        period_sales = sales_df[
            (sales_df['date'] >= period_start) & 
            (sales_df['date'] <= period_end)
        ]
        
        pnl_data = []
        
        for _, sku in skus_df.iterrows():
            sku_code = sku['sku']
            cost = sku.get('cost', 0)
            price = sku.get('price', 0)
            
            # Sales metrics
            sku_sales = period_sales[period_sales['sku'] == sku_code]
            units_sold = sku_sales['units_sold'].sum() if not sku_sales.empty else 0
            revenue = sku_sales['revenue'].sum() if not sku_sales.empty else 0
            
            # Cost and margin calculations
            cogs = units_sold * cost
            gross_margin = revenue - cogs
            gm_pct = gross_margin / revenue if revenue > 0 else 0
            
            # Inventory metrics
            current_stock = 0
            avg_inventory_value = 0
            if counts_df is not None:
                sku_counts = counts_df[counts_df['sku'] == sku_code]
                if not sku_counts.empty:
                    current_stock = sku_counts['qty'].sum()
                    avg_inventory_value = current_stock * cost / 2  # Simplified average
            
            # GMROI calculation
            gmroi = gross_margin / avg_inventory_value if avg_inventory_value > 0 else 0
            
            # Sell-through rate (units sold vs units available)
            initial_stock = current_stock + units_sold  # Simplified
            sell_through = units_sold / initial_stock if initial_stock > 0 else 0
            
            pnl_data.append({
                'sku': sku_code,
                'description': sku['desc'],
                'category': sku['category'],
                'period': period,
                'units_sold': units_sold,
                'revenue': round(revenue, 2),
                'cogs': round(cogs, 2),
                'gross_margin': round(gross_margin, 2),
                'gm_pct': round(gm_pct, 4),
                'current_stock': current_stock,
                'avg_inventory_value': round(avg_inventory_value, 2),
                'gmroi': round(gmroi, 2),
                'sell_through': round(sell_through, 4),
                'avg_unit_price': round(revenue / units_sold if units_sold > 0 else 0, 2)
            })
        
        pnl_df = pd.DataFrame(pnl_data)
        pnl_df = pnl_df.sort_values('gross_margin', ascending=False)
        
        # Save P&L analysis
        output_file = self.reports_path / f"pnl_snapshot_{period}.csv"
        pnl_df.to_csv(output_file, index=False)
        
        # Generate summary metrics
        total_revenue = pnl_df['revenue'].sum()
        total_gm = pnl_df['gross_margin'].sum()
        avg_gmroi = pnl_df[pnl_df['gmroi'] > 0]['gmroi'].mean()
        avg_sell_through = pnl_df[pnl_df['sell_through'] > 0]['sell_through'].mean()
        
        print(f"✅ Generated P&L for {len(pnl_df)} SKUs")
        print(f"💰 Total Revenue: ${total_revenue:,.2f}")
        print(f"💚 Total GM: ${total_gm:,.2f} ({total_gm/total_revenue*100:.1f}%)")
        print(f"📊 Avg GMROI: {avg_gmroi:.2f}x")
        print(f"📈 Avg Sell-Through: {avg_sell_through:.1%}")
        print(f"💾 Saved to: {output_file}")
        
        # Performance alerts
        low_gm_skus = len(pnl_df[pnl_df['gm_pct'] < 0.2])
        low_gmroi_skus = len(pnl_df[pnl_df['gmroi'] < 2.0])
        
        if low_gm_skus > 0:
            print(f"⚠️  {low_gm_skus} SKUs with GM < 20%")
        if low_gmroi_skus > 0:
            print(f"⚠️  {low_gmroi_skus} SKUs with GMROI < 2.0x")
        
        self.show_assumptions("P&L analysis", [
            "Average inventory = (current stock * cost) / 2",
            "Initial stock = current + sold (simplified)",
            "GMROI = Gross Margin ÷ Average Inventory Investment",
            "Sell-through = Units Sold ÷ Units Available"
        ])
        
        return pnl_df

    def build_workbook(self):
        """Generate complete Excel workbook"""
        print("🏗️  Building Complete Excel Workbook...")
        
        try:
            # Import the workbook generator
            from generate_workbook import create_command_center_workbook
            
            # Generate the workbook
            wb = create_command_center_workbook()
            
            # Save workbook
            filename = "Event-Inventory-CommandCenter.xlsx"
            wb.save(filename)
            
            print(f"✅ Workbook '{filename}' created successfully!")
            print(f"📊 Contains {len(wb.sheetnames)} worksheets:")
            for sheet in wb.sheetnames[:5]:  # Show first 5
                print(f"   • {sheet}")
            if len(wb.sheetnames) > 5:
                print(f"   • ... and {len(wb.sheetnames)-5} more sheets")
            
            print("\n🚀 Next Steps:")
            print("1. Open the workbook in Excel")
            print("2. Load your data using the /ingest commands")
            print("3. Set up Microsoft Forms integration")
            print("4. Configure Power Query refresh")
            print("5. Start collecting inventory counts")
            
            return filename
            
        except ImportError:
            print("❌ Excel workbook generator not available")
            print("💡 Run: pip install openpyxl pandas numpy")
            return None

    def publish_pack(self, period):
        """Export dashboard + CSVs to reports"""
        print(f"📦 Publishing Report Pack for {period}...")
        
        # Create period-specific reports directory
        period_dir = self.reports_path / period
        period_dir.mkdir(exist_ok=True)
        
        published_files = []
        
        # Copy all period-specific reports
        for report_type in ['forecast', 'buy_plan', 'pnl_snapshot']:
            source_file = self.reports_path / f"{report_type}_{period}.csv"
            if source_file.exists():
                dest_file = period_dir / f"{report_type}_{period}.csv"
                dest_file.write_bytes(source_file.read_bytes())
                published_files.append(str(dest_file))
        
        # Generate summary report
        summary = self.generate_summary_report(period)
        summary_file = period_dir / f"executive_summary_{period}.txt"
        with open(summary_file, 'w') as f:
            f.write(summary)
        published_files.append(str(summary_file))
        
        # Generate dashboard snapshot (text version)
        dashboard_file = period_dir / f"dashboard_{period}.txt"
        with open(dashboard_file, 'w') as f:
            f.write(self.generate_dashboard_text(period))
        published_files.append(str(dashboard_file))
        
        print(f"✅ Published {len(published_files)} report files")
        print(f"📁 Reports directory: {period_dir}")
        print("📋 Published files:")
        for file in published_files:
            print(f"   • {Path(file).name}")
        
        return published_files

    # Helper methods
    
    def parse_data_input(self, data, data_type):
        """Parse various data input formats"""
        if isinstance(data, str):
            # Try to parse as JSON first, then CSV
            try:
                return pd.read_json(data)
            except:
                try:
                    return pd.read_csv(pd.StringIO(data))
                except:
                    print(f"❌ Could not parse {data_type} data")
                    return pd.DataFrame()
        elif isinstance(data, list):
            return pd.DataFrame(data)
        else:
            return pd.DataFrame(data)

    def validate_events(self, events_df):
        """Validate event data"""
        required_cols = ['event_id', 'name', 'start_dt', 'end_dt', 'est_attendance']
        missing_cols = [col for col in required_cols if col not in events_df.columns]
        
        if missing_cols:
            print(f"⚠️  Missing required columns: {missing_cols}")
        
        # Convert dates
        events_df['start_dt'] = pd.to_datetime(events_df['start_dt'])
        events_df['end_dt'] = pd.to_datetime(events_df['end_dt'])
        
        # Validate attendance
        events_df['est_attendance'] = pd.to_numeric(events_df['est_attendance'], errors='coerce')
        events_df = events_df[events_df['est_attendance'] > 0]
        
        return events_df

    def validate_counts(self, counts_df):
        """Validate inventory count data"""
        required_cols = ['asof_date', 'checkpoint', 'location', 'sku', 'qty']
        missing_cols = [col for col in required_cols if col not in counts_df.columns]
        
        if missing_cols:
            print(f"⚠️  Missing required columns: {missing_cols}")
        
        # Convert dates and validate quantities
        counts_df['asof_date'] = pd.to_datetime(counts_df['asof_date'])
        counts_df['qty'] = pd.to_numeric(counts_df['qty'], errors='coerce')
        
        # Remove invalid entries
        invalid_qty = counts_df[counts_df['qty'] < 0]
        if not invalid_qty.empty:
            print(f"⚠️  Removing {len(invalid_qty)} entries with negative quantities")
            self.log_exceptions(invalid_qty, "Negative quantities")
            counts_df = counts_df[counts_df['qty'] >= 0]
        
        return counts_df

    def log_exceptions(self, exception_data, exception_type):
        """Log data quality exceptions"""
        exceptions_file = self.data_path / "exceptions_log.csv"
        
        exception_log = pd.DataFrame({
            'timestamp': [datetime.now()] * len(exception_data),
            'exception_type': [exception_type] * len(exception_data),
            'severity': ['HIGH'] * len(exception_data),
            'data': [str(row) for _, row in exception_data.iterrows()],
            'status': ['OPEN'] * len(exception_data)
        })
        
        # Append to existing log or create new
        if exceptions_file.exists():
            existing_log = pd.read_csv(exceptions_file)
            combined_log = pd.concat([existing_log, exception_log], ignore_index=True)
        else:
            combined_log = exception_log
        
        combined_log.to_csv(exceptions_file, index=False)

    def load_data(self, filename, path=None):
        """Load data file with error handling"""
        if path is None:
            path = self.data_path
        
        file_path = path / filename
        if file_path.exists():
            return pd.read_csv(file_path)
        else:
            return None

    def show_assumptions(self, context, assumptions):
        """Display assumptions made during analysis"""
        print(f"\n📋 Assumptions ({context}):")
        for i, assumption in enumerate(assumptions, 1):
            print(f"   {i}. {assumption}")
        print()

    def generate_summary_report(self, period):
        """Generate executive summary report"""
        return f"""
EXECUTIVE SUMMARY - CONVENTION INVENTORY MANAGEMENT
Period: {period}
Generated: {datetime.now().strftime('%Y-%m-%d %H:%M:%S')}

OPERATIONAL METRICS:
• Forecasting: Event-aware demand planning with baseline + event lift
• Safety Stock: Calculated at {self.config['z_service_level']:.2f} sigma service level
• Buy Planning: Target {self.config['target_days_of_supply']} days of supply
• Budget Constraint: ${self.config['max_cash_per_order']:,.0f} per purchase order

KEY RECOMMENDATIONS:
1. Focus on HIGH priority SKUs for immediate reordering
2. Monitor DoS levels below {self.config['low_dos_warning']} days  
3. Review SKUs with GMROI < 2.0x for profitability
4. Investigate shrink variances > {self.config['shrink_threshold_pct']:.1%}

NEXT ACTIONS:
• Execute buy plan for critical SKUs
• Continue dual intake inventory counting (Forms + Manual)
• Monitor exception reports for data quality issues
• Schedule monthly forecast refresh

Senior Economics & Inventory Strategist
"Let's turn stock into profit, not décor"
"""

    def generate_dashboard_text(self, period):
        """Generate text version of dashboard"""
        return f"""
CONVENTION INVENTORY DASHBOARD - {period}
{'='*50}

PERFORMANCE INDICATORS:
• Revenue Target: Track against monthly goals
• Gross Margin: Monitor profitability by category
• GMROI: Target >3.0x for healthy inventory turns
• Sell-Through: Target >75% for demand accuracy  
• Days of Supply: Maintain 20-40 days optimal range
• Stockout Risk: Minimize SKUs below ROP
• Shrink Control: Keep variance <2%

OPERATIONAL STATUS:
• Dual intake counting system active
• Microsoft Forms + Manual transcription enabled
• Power Query refresh automating data flow
• Exception monitoring identifying data quality issues

INVENTORY PLANNING:
• Event-aware forecasting incorporating attendance estimates
• Safety stock calculations based on demand variability  
• Purchase recommendations within budget constraints
• Performance metrics guiding strategic decisions

Last Updated: {datetime.now().strftime('%Y-%m-%d %H:%M:%S')}
"""

    # Sample data methods
    
    def get_sample_events(self):
        """Generate sample events data"""
        return pd.DataFrame([
            {"event_id": "EVT001", "name": "Q4 Tech Conference", "venue_area": "Main Hall", 
             "event_type": "Conference", "start_dt": "2025-09-15 09:00:00", 
             "end_dt": "2025-09-15 18:00:00", "est_attendance": 500},
            {"event_id": "EVT002", "name": "Product Launch", "venue_area": "Booth A",
             "event_type": "Launch", "start_dt": "2025-09-20 10:00:00",
             "end_dt": "2025-09-20 16:00:00", "est_attendance": 250}
        ])

    def get_sample_skus(self):
        """Generate sample SKU data"""
        return pd.DataFrame([
            {"sku": "SKU001", "desc": "Branded Pen", "category": "Promotional", 
             "cost": 0.50, "price": 2.00, "lead_time_days": 14},
            {"sku": "SKU002", "desc": "Small Shipping Box", "category": "Packaging",
             "cost": 1.25, "price": 3.50, "lead_time_days": 7},
            {"sku": "SKU003", "desc": "T-Shirt Large", "category": "Apparel",
             "cost": 8.00, "price": 25.00, "lead_time_days": 21}
        ])

    def get_sample_counts(self):
        """Generate sample count data"""
        return pd.DataFrame([
            {"asof_date": "2025-08-01", "checkpoint": "BOM", "location": "in_store",
             "sku": "SKU001", "qty": 150, "uom": "EA", "counter_id": "JD001", "notes": ""},
            {"asof_date": "2025-08-01", "checkpoint": "BOM", "location": "back_of_store", 
             "sku": "SKU001", "qty": 500, "uom": "EA", "counter_id": "JD001", "notes": ""},
            {"asof_date": "2025-08-15", "checkpoint": "MID", "location": "in_store",
             "sku": "SKU001", "qty": 135, "uom": "EA", "counter_id": "SM002", "notes": ""}
        ])

    def get_sample_sales(self):
        """Generate sample sales data"""
        return pd.DataFrame([
            {"date": "2025-08-02", "sku": "SKU001", "units_sold": 12, "revenue": 24.00, "event_id": ""},
            {"date": "2025-08-03", "sku": "SKU002", "units_sold": 15, "revenue": 52.50, "event_id": ""},
            {"date": "2025-08-06", "sku": "SKU001", "units_sold": 15, "revenue": 30.00, "event_id": "EVT002"}
        ])


def main():
    """Main CLI interface"""
    strategist = InventoryStrategist()
    
    if len(sys.argv) < 2:
        print("Usage: python ops_controller.py [command] [args]")
        print("Run 'python ops_controller.py --help' for available commands")
        return
    
    command = sys.argv[1].lower()
    args = sys.argv[2:] if len(sys.argv) > 2 else []
    
    try:
        if command == "/ingest" and len(args) >= 1:
            data_type = args[0]
            file_path = args[1] if len(args) > 1 else None
            
            if data_type == "events":
                strategist.ingest_events(file_path)
            elif data_type == "audits":
                strategist.ingest_audits(file_path)  
            elif data_type == "sales":
                strategist.ingest_sales(file_path)
            else:
                print(f"❌ Unknown data type: {data_type}")
                
        elif command == "/forms" and len(args) >= 1 and args[0] == "setup" and len(args) >= 2 and args[1] == "ms":
            strategist.forms_setup_ms()
            
        elif command == "/counts":
            if len(args) >= 1:
                if args[0] == "manual" and len(args) >= 2 and args[1] == "enable":
                    strategist.counts_manual_enable()
                elif args[0] == "unify":
                    strategist.counts_unify()
                else:
                    print(f"❌ Unknown counts command: {' '.join(args)}")
            else:
                print("❌ Missing counts subcommand")
                
        elif command == "/forecast" and len(args) >= 1:
            period = args[0]
            strategist.forecast(period)
            
        elif command == "/plan" and len(args) >= 1:
            period = args[0]
            strategist.plan(period)
            
        elif command == "/pnl" and len(args) >= 1:
            period = args[0]
            strategist.pnl(period)
            
        elif command == "/build" and len(args) >= 1 and args[0] == "workbook":
            strategist.build_workbook()
            
        elif command == "/publish" and len(args) >= 2 and args[0] == "pack":
            period = args[1]
            strategist.publish_pack(period)
            
        elif command == "--help":
            print(__doc__)
            
        else:
            print(f"❌ Unknown command: {command}")
            print("Run 'python ops_controller.py --help' for available commands")
            
    except Exception as e:
        print(f"❌ Error executing command: {e}")
        print("📞 Contact: Senior Economics & Inventory Strategist")


if __name__ == "__main__":
    main()
