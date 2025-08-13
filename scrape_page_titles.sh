#!/bin/bash

# Page Title Scraper
# Expects a simple text file with one URL per line, no headers
# Usage: ./scrape_page_titles.sh urls.txt output.csv

# Function to extract page title from HTML
get_page_title() {
    local url="$1"
    
    # Fetch the page content
    local html=$(curl -s -L --max-time 10 --retry 2 \
        --user-agent "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/120.0.0.0 Safari/537.36" \
        "$url" 2>/dev/null)
    
    if [ -z "$html" ]; then
        return 1
    fi
    
    # Extract title using grep and sed
    local title=$(echo "$html" | grep -i '<title' | head -n1 | sed 's/.*<title[^>]*>//I;s/<\/title>.*//I' | sed 's/^[[:space:]]*//;s/[[:space:]]*$//')
    
    if [ -n "$title" ]; then
        # Clean up the title - remove everything after "|" or " - "
        if [[ "$title" == *"|"* ]]; then
            title=$(echo "$title" | cut -d'|' -f1 | sed 's/^[[:space:]]*//;s/[[:space:]]*$//')
        elif [[ "$title" == *" - "* ]]; then
            title=$(echo "$title" | cut -d'-' -f1 | sed 's/^[[:space:]]*//;s/[[:space:]]*$//')
        fi
        
        echo "$title"
        return 0
    fi
    
    return 1
}

# Main function
main() {
    local input_file="$1"
    local output_file="$2"
    
    # Check arguments
    if [ $# -ne 2 ]; then
        echo "Usage: $0 urls.txt output.csv"
        echo ""
        echo "Input file format (one URL per line):"
        echo "https://www.website.org/"
        echo "https://www.website.org/about-us"
        echo "https://www.website.org/get-involved"
        echo ""
        exit 1
    fi
    
    if [ ! -f "$input_file" ]; then
        echo "❌ ERROR: Input file '$input_file' not found."
        exit 1
    fi
    
    if ! command -v curl &> /dev/null; then
        echo "❌ ERROR: curl is required but not installed."
        exit 1
    fi
    
    echo "🚀 Starting title scraping..."
    echo "📄 Input file: $input_file"
    echo "💾 Output file: $output_file"
    echo ""
    
    # Create output CSV with headers
    echo "title,url" > "$output_file"
    
    local total_lines=$(wc -l < "$input_file" | tr -d ' ')
    local processed=0
    local success=0
    local failed=0
    
    echo "📊 Total URLs to process: $total_lines"
    echo ""
    
    # Process each URL
    while IFS= read -r url; do
        ((processed++))
        
        # Skip empty lines
        if [ -z "$url" ]; then
            continue
        fi
        
        # Remove any quotes and trim whitespace
        url=$(echo "$url" | sed 's/^"//;s/"$//;s/^[[:space:]]*//;s/[[:space:]]*$//')
        
        echo -n "[$processed/$total_lines] $url ... "
        
        # Get the page title
        local title=$(get_page_title "$url")
        
        if [ $? -eq 0 ] && [ -n "$title" ]; then
            # Escape quotes and commas for CSV
            title=$(echo "$title" | sed 's/"/\\"/g')
            echo "\"$title\",\"$url\"" >> "$output_file"
            echo "✅ $title"
            ((success++))
        else
            echo ",\"$url\"" >> "$output_file"
            echo "❌ Failed"
            ((failed++))
        fi
        
        # Progress update every 50 URLs
        if [ $((processed % 50)) -eq 0 ]; then
            echo ""
            echo "📈 Progress: $processed/$total_lines (✅ $success successful, ❌ $failed failed)"
            echo ""
        fi
        
        # Be respectful - small delay
        sleep 0.5
        
    done < "$input_file"
    
    echo ""
    echo "🎉 Complete!"
    echo "📊 Results:"
    echo "   • Total processed: $processed"
    echo "   • Successful: $success"
    echo "   • Failed: $failed"
    echo "   • Success rate: $(( success * 100 / processed ))%"
    echo ""
    echo "💾 Output saved to: $output_file"
    echo "📋 You can now import this CSV into Excel!"
}

# Run the script
main "$@"