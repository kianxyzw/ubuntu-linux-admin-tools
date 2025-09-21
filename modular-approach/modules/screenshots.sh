#!/bin/bash
# Screenshots Module
# Enhanced screenshot functionality with clipboard support

setup_screenshots() {
    header "Setting Up Screenshots"
    
    # Create screenshots directory
    mkdir -p "$HOME/Pictures/Screenshots"
    
    # Create smart screenshot script
    log "Creating smart screenshot script..."
    cat > "$HOME/.local/bin/smart-screenshot" << 'EOF'
#!/bin/bash
# Smart screenshot script with clipboard support

set -euo pipefail

readonly SCREENSHOT_DIR="$HOME/Pictures/Screenshots"
readonly TIMESTAMP=$(date +"%Y%m%d_%H%M%S")
readonly FILENAME="$SCREENSHOT_DIR/screenshot_${TIMESTAMP}.png"

# Ensure directory exists
mkdir -p "$SCREENSHOT_DIR"

# Function to copy to clipboard
copy_to_clipboard() {
    local image_path="$1"
    if command -v xclip >/dev/null 2>&1; then
        xclip -selection clipboard -t image/png -i "$image_path"
        echo "✅ Screenshot copied to clipboard!"
    else
        echo "⚠️  Install xclip for clipboard support"
    fi
}

# Function to show notification
show_notification() {
    local message="$1"
    if command -v notify-send >/dev/null 2>&1; then
        notify-send "Screenshot" "$message" -i "$FILENAME" 2>/dev/null || true
    fi
}

# Function to take region screenshot
take_region() {
    echo "Select a region to capture..."
    if gnome-screenshot --area --file="$FILENAME" 2>/dev/null; then
        copy_to_clipboard "$FILENAME"
        show_notification "Region screenshot saved and copied to clipboard"
        echo "Region screenshot saved: $FILENAME"
    else
        echo "Screenshot cancelled or failed"
        exit 1
    fi
}

# Function to take full screenshot
take_full() {
    if gnome-screenshot --file="$FILENAME" 2>/dev/null; then
        copy_to_clipboard "$FILENAME"
        show_notification "Full screenshot saved and copied to clipboard"
        echo "Full screenshot saved: $FILENAME"
    else
        echo "Screenshot failed"
        exit 1
    fi
}

# Function to take window screenshot
take_window() {
    echo "Click on a window to capture..."
    if gnome-screenshot --window --file="$FILENAME" 2>/dev/null; then
        copy_to_clipboard "$FILENAME"
        show_notification "Window screenshot saved and copied to clipboard"
        echo "Window screenshot saved: $FILENAME"
    else
        echo "Screenshot failed"
        exit 1
    fi
}

# Function to show help
show_help() {
    cat << 'HELP'
Smart Screenshot Tool

Usage: smart-screenshot [option]

Options:
  -r, --region    Take region screenshot (default)
  -f, --full      Take full screen screenshot
  -w, --window    Take active window screenshot
  -h, --help      Show this help

Examples:
  smart-screenshot              # Region screenshot (default)
  smart-screenshot -f           # Full screen
  smart-screenshot -w           # Window

Screenshots are automatically copied to clipboard and saved to:
~/Pictures/Screenshots/
HELP
}

# Parse arguments
case "${1:-}" in
    -r|--region|"")
        take_region
        ;;
    -f|--full)
        take_full
        ;;
    -w|--window)
        take_window
        ;;
    -h|--help)
        show_help
        ;;
    *)
        echo "Unknown option: $1"
        show_help
        exit 1
        ;;
esac
EOF
    
    chmod +x "$HOME/.local/bin/smart-screenshot"
    log "✓ Smart screenshot script created"
    
    # Test screenshot functionality
    if command -v gnome-screenshot >/dev/null 2>&1; then
        log "✓ gnome-screenshot available"
    else
        warn "gnome-screenshot not found, installing..."
        sudo apt install -y gnome-screenshot
    fi
    
    log "Screenshots setup complete"
    log "- Screenshots saved to: ~/Pictures/Screenshots/"
    log "- Automatic clipboard copy enabled"
    log "- Usage: Alt + Shift + S for region screenshot"
}

# Function to test screenshot functionality
test_screenshots() {
    header "Testing Screenshot Functionality"
    
    # Check if script exists and is executable
    if [[ -x "$HOME/.local/bin/smart-screenshot" ]]; then
        log "✓ Smart screenshot script is executable"
    else
        error "✗ Smart screenshot script not found or not executable"
        return 1
    fi
    
    # Check dependencies
    local deps=("gnome-screenshot" "xclip")
    for dep in "${deps[@]}"; do
        if command -v "$dep" >/dev/null 2>&1; then
            log "✓ $dep available"
        else
            warn "✗ $dep not available"
        fi
    done
    
    # Check directory
    if [[ -d "$HOME/Pictures/Screenshots" ]]; then
        log "✓ Screenshots directory exists"
    else
        warn "✗ Screenshots directory missing"
    fi
    
    log "Screenshot test complete"
}