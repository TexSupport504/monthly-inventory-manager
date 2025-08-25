# MCCNO Brand Implementation Guidelines
## Power BI Dashboard Brand Compliance Standards

### Brand Identity Overview
MCCNO's brand identity reflects prestige, reliability, and executive sophistication. This guide ensures complete brand compliance in your Power BI executive dashboard implementation.

### Official Color Palette

#### Primary Navy (PMS 295)
- **Hex**: #003366
- **RGB**: R:0, G:51, B:102
- **Usage**: Primary headers, KPI card backgrounds, main navigation elements
- **Logo Rule**: Required background for reversed-out logo versions only

#### Golden Accent (PMS 139)  
- **Hex**: #FFB500
- **RGB**: R:255, G:181, B:0
- **Usage**: Performance highlights, positive variance indicators, call-to-action elements
- **Application**: Maximum 20% of visual elements for optimal impact

#### Neutral Support (PMS 4685)
- **Hex**: #F5F5F0  
- **RGB**: R:245, G:245, B:240
- **Usage**: Secondary backgrounds, subtle card sections, supporting data areas
- **Contrast**: Maintains accessibility standards with dark text

#### Clean Foundation White
- **Hex**: #FFFFFF
- **RGB**: R:255, G:255, B:255  
- **Usage**: Primary dashboard background, full-color logo placement
- **Clear Space**: Minimum 0.5-inch equivalent around all MCCNO logo applications

### Logo Standards & Placement

#### Logo Usage Rules
1. **Full-Color Logo**: Use ONLY on white backgrounds (#FFFFFF)
2. **Reversed Logo**: Use ONLY on PMS 295 navy backgrounds (#003366)
3. **Never**: Use logo on golden accent or neutral backgrounds
4. **Never**: Stretch, distort, or modify logo proportions

#### Dashboard Placement Standards
- **Primary Location**: Top-left corner of dashboard header
- **Size**: Minimum 120px width for desktop viewing
- **Clear Space**: 0.5-inch equivalent margin on all sides
- **Alignment**: Left-aligned with dashboard title text

#### Mobile Responsiveness
- **Tablet View**: Maintain minimum 100px logo width
- **Phone View**: Logo may be centered in header if space constraints exist
- **Scalability**: Vector format (SVG) preferred for crisp rendering

### Typography Standards

#### Primary Font: Segoe UI
- **Rationale**: Executive-friendly readability, Power BI native support
- **Headers**: 24pt, Bold, Navy (#003366)
- **Subheaders**: 18pt, Semibold, Navy (#003366)  
- **Body Text**: 14pt, Regular, Dark Gray (#333333)
- **Captions**: 12pt, Regular, Medium Gray (#666666)

#### Text Hierarchy Implementation
1. **Dashboard Titles**: Segoe UI, 24pt Bold, Navy
2. **KPI Labels**: Segoe UI, 16pt Semibold, Navy  
3. **KPI Values**: Segoe UI, 32pt Bold, Golden (#FFB500 for positive, #CC0000 for negative)
4. **Chart Labels**: Segoe UI, 12pt Regular, Dark Gray
5. **Tooltips**: Segoe UI, 11pt Regular, Black

### Layout & Spacing Standards

#### Grid System
- **12-Column Responsive Grid**: Consistent across all dashboard pages
- **Gutter Width**: 20px between grid columns
- **Margin**: 40px from dashboard edge to content
- **Card Padding**: 20px internal padding for all content cards

#### Visual Element Spacing
- **Section Separation**: 40px vertical space between major sections
- **Card Spacing**: 20px horizontal and vertical space between cards
- **Chart Margins**: 15px internal margins within chart containers
- **Text Spacing**: 1.2x line height for optimal readability

#### Executive-Friendly Layout Principles
1. **Top-Down Information Hierarchy**: Most critical KPIs in upper-left quadrant
2. **Left-to-Right Reading Flow**: Logical progression from overview to detail
3. **Consistent Card Heights**: Uniform sizing for professional appearance
4. **Ample White Space**: 30% of dashboard surface area for clean aesthetics

### Visual Element Standards

#### KPI Card Styling
- **Background**: White (#FFFFFF) with subtle border (#E5E5E5)
- **Header**: Navy background (#003366) with white text
- **Value Display**: Large golden text (#FFB500) for positive performance
- **Trend Indicators**: Green arrows (↑ #28A745) or red arrows (↓ #DC3545)
- **Shadow**: Subtle drop shadow (0px 2px 4px rgba(0,0,0,0.1))

#### Chart Color Schemes
1. **Primary Data Series**: Navy (#003366)  
2. **Secondary Series**: Golden (#FFB500)
3. **Tertiary Series**: Medium Gray (#666666)
4. **Background Elements**: Light Gray (#F8F9FA)
5. **Accent/Highlight**: Bright Blue (#007BFF) for interactive elements

#### Chart-Specific Guidelines
- **Bar Charts**: Navy primary bars with golden highlights for targets
- **Line Charts**: Navy lines with golden data point markers  
- **Pie Charts**: Navy-to-golden gradient scale with white separators
- **Heat Maps**: White-to-navy intensity scale with golden outlier highlighting

### Interactive Element Standards

#### Button Styling
- **Primary Action**: Golden background (#FFB500), white text, rounded corners (4px)
- **Secondary Action**: White background, navy border (#003366), navy text
- **Hover State**: 10% darker shade of base color
- **Disabled State**: 50% opacity with gray text

#### Filter Panel Design
- **Background**: Neutral support color (#F5F5F0)
- **Border**: 1px solid light gray (#E5E5E5)
- **Selected Items**: Navy background (#003366) with white text
- **Unselected Items**: White background with navy text

### Accessibility Compliance

#### Color Contrast Requirements
- **Primary Text**: 4.5:1 minimum contrast ratio (Navy on White = 12.6:1 ✓)
- **Secondary Text**: 3:1 minimum for larger text (14pt+)
- **Interactive Elements**: 3:1 minimum contrast for hover states
- **Color-Blind Friendly**: Navy/Golden combination accessible to all types

#### Alternative Text & Labels
- **Chart Descriptions**: Comprehensive alt-text for screen readers
- **Data Table Headers**: Proper header associations for navigation
- **Interactive Labels**: Clear, descriptive text for all clickable elements
- **Keyboard Navigation**: Full functionality without mouse interaction

### Brand Compliance Checklist

#### Pre-Launch Verification
- [ ] Logo placement follows clear-space requirements
- [ ] Color palette matches exact MCCNO specifications  
- [ ] Typography uses approved font families and sizing
- [ ] Layout maintains professional spacing standards
- [ ] KPI cards follow established styling guidelines
- [ ] Charts implement approved color schemes
- [ ] Interactive elements meet accessibility standards
- [ ] Mobile responsiveness preserves brand integrity

#### Ongoing Maintenance
- [ ] Monthly brand compliance audit
- [ ] Logo file updates when MCCNO releases new versions
- [ ] Color accuracy verification on different monitor calibrations
- [ ] User feedback collection on visual clarity and usability
- [ ] Annual review against updated MCCNO brand guidelines

### Implementation Notes

#### Power BI Specific Considerations
- **Custom Colors**: Use theme JSON file for consistent color application
- **Font Loading**: Ensure Segoe UI is available on all viewing devices
- **Logo Import**: Use high-resolution PNG or SVG format
- **Theme Consistency**: Apply MCCNO theme across all dashboard pages

#### Executive Presentation Mode
- **Full-Screen Optimization**: Remove unnecessary Power BI interface elements
- **High-DPI Support**: Ensure crisp rendering on executive presentation displays
- **Print Compatibility**: Maintain brand standards in PDF export versions
- **Screen Recording**: Consider brand appearance in video presentations

---

**Brand Compliance Authority**: MCCNO Marketing Department  
**Dashboard Brand Owner**: Business Intelligence Team  
**Review Schedule**: Quarterly brand alignment verification  
**Contact**: brand-compliance@company.com for questions or clarifications
