"""
PDF Generator for Monthly Inventory Manager Executive Summary
Creates a professional 1-page PDF from the markdown summary
"""

import os
import subprocess
import sys
from pathlib import Path

def create_executive_summary_pdf():
    """Convert the executive summary markdown to PDF"""
    
    # File paths
    md_file = "Monthly_Inventory_Manager_Executive_Summary.md"
    pdf_file = "Monthly_Inventory_Manager_Executive_Summary.pdf"
    
    print("📄 Generating Executive Summary PDF...")
    
    # Check if pandoc is available
    try:
        subprocess.run(["pandoc", "--version"], 
                      capture_output=True, check=True)
        print("✅ Pandoc found - using professional PDF generation")
        
        # Generate PDF with pandoc (professional formatting)
        subprocess.run([
            "pandoc", md_file,
            "-o", pdf_file,
            "--pdf-engine=wkhtmltopdf",
            "--variable", "geometry:margin=0.75in",
            "--variable", "fontsize=11pt",
            "--variable", "colorlinks=true"
        ], check=True)
        
    except (subprocess.CalledProcessError, FileNotFoundError):
        print("⚠️  Pandoc not found - trying alternative method...")
        
        # Try with markdown library and weasyprint
        try:
            import markdown
            import weasyprint
            
            # Read markdown file
            with open(md_file, 'r', encoding='utf-8') as f:
                md_content = f.read()
            
            # Convert to HTML
            html = markdown.markdown(md_content, extensions=['tables', 'fenced_code'])
            
            # Add CSS styling for professional look
            html_with_css = f"""
            <!DOCTYPE html>
            <html>
            <head>
                <meta charset="UTF-8">
                <style>
                    body {{ font-family: 'Segoe UI', Arial, sans-serif; margin: 40px; line-height: 1.4; }}
                    h1 {{ color: #2c3e50; border-bottom: 3px solid #3498db; padding-bottom: 10px; }}
                    h2 {{ color: #34495e; margin-top: 25px; }}
                    h3 {{ color: #7f8c8d; }}
                    .highlight {{ background: #f8f9fa; padding: 15px; border-left: 4px solid #3498db; }}
                    code {{ background: #f4f4f4; padding: 2px 5px; font-size: 0.9em; }}
                    pre {{ background: #f8f9fa; padding: 10px; border: 1px solid #ddd; }}
                    ul, ol {{ margin-left: 20px; }}
                    strong {{ color: #2c3e50; }}
                </style>
            </head>
            <body>
            {html}
            </body>
            </html>
            """
            
            # Generate PDF
            weasyprint.HTML(string=html_with_css).write_pdf(pdf_file)
            
        except ImportError:
            print("❌ Required libraries not found. Please install:")
            print("   pip install markdown weasyprint")
            print("   OR install pandoc: https://pandoc.org/installing.html")
            return False
    
    if os.path.exists(pdf_file):
        print(f"✅ PDF created successfully: {pdf_file}")
        print(f"📊 File size: {os.path.getsize(pdf_file):,} bytes")
        return True
    else:
        print("❌ PDF generation failed")
        return False

if __name__ == "__main__":
    success = create_executive_summary_pdf()
    if success:
        print("\n🎯 Executive Summary PDF is ready for presentation!")
        print("📧 Perfect for sharing with stakeholders and team members.")
    else:
        print("\n⚠️  PDF generation failed. The markdown file is still available for manual conversion.")
