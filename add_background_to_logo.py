#!/usr/bin/env python3
"""
Script to add a gradient background to the robot logo matching the sign-in page background.
The gradient goes from #0A0E27 (top) to #111827 (bottom).
"""

from PIL import Image, ImageDraw
import sys
import os

def hex_to_rgb(hex_color):
    """Convert hex color to RGB tuple."""
    hex_color = hex_color.lstrip('#')
    return tuple(int(hex_color[i:i+2], 16) for i in (0, 2, 4))

def create_gradient_background(width, height, start_color, end_color):
    """Create a vertical gradient background."""
    # Create a new image with RGBA mode
    img = Image.new('RGB', (width, height))
    pixels = []
    
    start_rgb = hex_to_rgb(start_color)
    end_rgb = hex_to_rgb(end_color)
    
    for y in range(height):
        # Calculate the interpolation factor (0.0 at top, 1.0 at bottom)
        factor = y / (height - 1) if height > 1 else 0
        
        # Interpolate between start and end colors
        r = int(start_rgb[0] * (1 - factor) + end_rgb[0] * factor)
        g = int(start_rgb[1] * (1 - factor) + end_rgb[1] * factor)
        b = int(start_rgb[2] * (1 - factor) + end_rgb[2] * factor)
        
        # Create a row of pixels with this color
        row = [(r, g, b)] * width
        pixels.extend(row)
    
    img.putdata(pixels)
    return img

def add_background_to_logo(input_path, output_path):
    """Add gradient background to the robot logo."""
    try:
        # Load the original logo
        logo = Image.open(input_path).convert('RGBA')
        logo_width, logo_height = logo.size
        
        # Create gradient background matching sign-in page
        # Colors: #0A0E27 (top) to #111827 (bottom)
        background = create_gradient_background(
            logo_width, 
            logo_height, 
            '#0A0E27',  # neutralDark
            '#111827'   # cardBg
        )
        
        # Composite the logo on top of the background
        # Use alpha composite to preserve transparency
        result = Image.alpha_composite(
            background.convert('RGBA'),
            logo
        )
        
        # Convert back to RGB for saving (removes alpha channel)
        result = result.convert('RGB')
        
        # Save the result
        result.save(output_path, 'PNG')
        print(f"✅ Successfully added background to logo!")
        print(f"   Input:  {input_path}")
        print(f"   Output: {output_path}")
        return True
        
    except Exception as e:
        print(f"❌ Error processing image: {e}")
        return False

if __name__ == "__main__":
    input_file = "assets/images/rcb_logo.png"
    output_file = "assets/images/rcb_logo.png"  # Overwrite original
    
    # Check if input file exists
    if not os.path.exists(input_file):
        print(f"❌ Error: Input file not found: {input_file}")
        sys.exit(1)
    
    # Add background to logo
    success = add_background_to_logo(input_file, output_file)
    
    if success:
        print("\n✨ Logo updated with gradient background!")
        print("   The background matches the sign-in page gradient.")
    else:
        sys.exit(1)

