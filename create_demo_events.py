import pandas as pd
import numpy as np
from datetime import datetime, timedelta
import random

# Set seeds for reproducible demo
np.random.seed(42)
random.seed(42)

print('🔄 Creating demo Events.xlsx with proper structure...')

# Demo data components  
companies = [
    'TechCorp Industries', 'Global Solutions Inc', 'Innovation Partners LLC',
    'Metro Business Group', 'Future Systems Co', 'Premier Events Ltd',
    'Professional Services Corp', 'Advanced Technologies Inc', 'Strategic Partners Group',
    'Enterprise Solutions LLC', 'Dynamic Business Systems', 'Visionary Companies Inc'
]

event_types = [
    'Annual Convention', 'Trade Show', 'Tech Conference', 'Product Launch',
    'Training Workshop', 'Corporate Summit', 'Awards Gala', 'Industry Expo'
]

venues = [
    'Grand Convention Center - Main Hall', 'Metro Conference Complex - Hall A',
    'Downtown Exhibition Center', 'Riverside Meeting Center - Suite B',
    'Corporate Training Facility', 'Luxury Hotel Ballroom',
    'Business District Conference Center', 'Innovation Hub - Auditorium'
]

contacts = [
    'Smith, Sarah', 'Johnson, Michael', 'Williams, Jennifer', 'Brown, David',
    'Davis, Lisa', 'Miller, Robert', 'Wilson, Amanda', 'Moore, Christopher'
]

salespeople = [
    'Adams, Kelly', 'Baker, Steven', 'Clark, Nicole', 'Evans, Brian',
    'Foster, Laura', 'Garcia, Daniel', 'Harris, Jessica', 'King, Matthew'
]

# Generate 3734 simulated events
events_data = []
base_date = datetime(2023, 1, 1)

for i in range(3734):
    # Event timing
    days_offset = random.randint(0, 730)
    start_date = base_date + timedelta(days=days_offset)
    duration = random.choices([1, 2, 3, 4, 5], weights=[30, 25, 20, 15, 10])[0]
    end_date = start_date + timedelta(days=duration-1)
    in_date = start_date - timedelta(days=random.randint(1, 2))
    out_date = end_date + timedelta(days=random.randint(0, 1))
    
    # Realistic attendance distribution
    attendance_type = random.choices(['small', 'medium', 'large', 'mega'], weights=[40, 35, 20, 5])[0]
    if attendance_type == 'small':
        forecast_attendance = random.randint(10, 150)
    elif attendance_type == 'medium':
        forecast_attendance = random.randint(150, 1000)
    elif attendance_type == 'large':
        forecast_attendance = random.randint(1000, 5000)
    else:
        forecast_attendance = random.randint(5000, 18000)
    
    # Event details
    company = random.choice(companies)
    event_type = random.choice(event_types)
    description = f'{event_type} - {company}'
    
    # Build event record
    event = {
        'Event ID': 10000 + i,
        'Account': company,
        'Description': description,
        'Contact': random.choice(contacts),
        'In Date': in_date,
        'Start Date': start_date,
        'End Date': end_date,
        'Out Date': out_date,
        'Forecast Attendance': forecast_attendance,
        'Peak Room Nights': int(forecast_attendance * duration * 0.4) if duration > 1 else 0,
        'Room Nights': int(forecast_attendance * duration * 0.6) if duration > 1 else 0,
        'Salesperson': random.choice(salespeople),
        'Anchor Venue': random.choice(venues),
        'Span of Attendees': f'{max(1, int(forecast_attendance * 0.8))}-{int(forecast_attendance * 1.2)}',
        '# MRs': random.randint(1, min(10, max(1, forecast_attendance // 100))),
        'Actual Attendance': int(forecast_attendance * random.uniform(0.8, 1.2)),
        'Attendance - Current': forecast_attendance,
        'Attendance': int(forecast_attendance * random.uniform(0.8, 1.2)),
        'Revised Attendance': int(forecast_attendance * random.uniform(0.9, 1.1)),
        'Total Rev/Attendee': random.uniform(25, 750) if forecast_attendance > 50 else 0
    }
    
    events_data.append(event)

# Create DataFrame
demo_df = pd.DataFrame(events_data)

# Create Excel file with proper structure (matching original)
with pd.ExcelWriter('Events.xlsx', engine='openpyxl') as writer:
    # Create a header row like the original
    header_df = pd.DataFrame([['2023_2025 Events'] + [''] * (len(demo_df.columns) - 1)])
    header_df.to_excel(writer, sheet_name='Sheet1', index=False, header=False, startrow=0)
    
    # Write the actual data starting from row 2 (with headers)
    demo_df.to_excel(writer, sheet_name='Sheet1', index=False, header=True, startrow=1)

print(f'✅ Created {len(demo_df)} simulated events')
print(f'Attendance range: {demo_df["Forecast Attendance"].min():,} - {demo_df["Forecast Attendance"].max():,}')
print(f'Date range: {demo_df["Start Date"].min().strftime("%Y-%m-%d")} to {demo_df["Start Date"].max().strftime("%Y-%m-%d")}')
print('🎯 Demo Events.xlsx ready for open source!')
