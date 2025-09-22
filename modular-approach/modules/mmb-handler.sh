#!/bin/bash
# MMB (Middle Mouse Button) Handler Module
# DEPRECATED: This module has been deprecated due to reliability issues
# The MMB handler conflicts with Chrome's native scrolling and causes more problems than it solves
# 
# Issues found:
# - imwheel interferes with Chrome's native MMB autoscroll
# - Complex window detection logic is unreliable
# - GTK settings alone are insufficient for complete MMB paste prevention
# - Chrome's MMB paste cannot be disabled through any known method
#
# Recommendation: Use Firefox if MMB paste prevention is critical, or live with Chrome's behavior

setup_mmb_behavior() {
    header "Setting Up MMB Behavior"
    
    # Get the actual mouse device name dynamically
    local mouse_device
    mouse_device=$(xinput list | grep -i "mouse" | head -1 | sed 's/.*↳ \(.*\) *id=.*/\1/' | sed 's/[[:space:]]*$//')
    
    if [[ -z "$mouse_device" ]]; then
        error "No mouse device found"
        return 1
    fi
    
    log "Found mouse device: $mouse_device"
    
    # Backup existing configurations
    backup_file "$HOME/.profile"
    backup_file "$HOME/.Xresources"
    backup_file "$HOME/.config/gtk-3.0/settings.ini"
    
    # Method 1: Disable primary paste at GTK level (most effective)
    log "Disabling GTK primary paste..."
    gsettings set org.gnome.desktop.interface gtk-enable-primary-paste false
    
    # Method 2: Create/update GTK3 settings
    log "Configuring GTK3 settings..."
    mkdir -p "$HOME/.config/gtk-3.0"
    
    # Check if settings.ini exists and has our setting
    local gtk_settings_file="$HOME/.config/gtk-3.0/settings.ini"
    if [[ -f "$gtk_settings_file" ]]; then
        # Update existing file
        if grep -q "gtk-enable-primary-paste" "$gtk_settings_file"; then
            sed -i 's/gtk-enable-primary-paste.*/gtk-enable-primary-paste = false/' "$gtk_settings_file"
        else
            echo "gtk-enable-primary-paste = false" >> "$gtk_settings_file"
        fi
    else
        # Create new file
        cat > "$gtk_settings_file" << 'EOF'
[Settings]
gtk-enable-primary-paste = false
EOF
    fi
    
    # Method 3: Create smart MMB handler (legacy approach that works)
    log "Creating smart MMB handler based on legacy approach..."
    cat > "$HOME/.local/bin/mmb-smart-handler" << EOF
#!/bin/bash
# Smart MMB Handler - Legacy approach that actually works
# Let Chrome handle MMB natively, disable MMB paste everywhere else

# Get mouse device dynamically
MOUSE_DEVICE="$mouse_device"

# Function to check active window
get_active_window() {
    xdotool getactivewindow getwindowname 2>/dev/null || echo "unknown"
}

# Function to check if we're in a browser (let browsers handle MMB natively)
is_browser() {
    local window="\$(get_active_window)"
    [[ "\$window" == *"Chrome"* ]] || [[ "\$window" == *"Firefox"* ]] || [[ "\$window" == *"Chromium"* ]]
}

# Function to check if we're in a terminal (allow MMB paste in terminals)
is_terminal() {
    local window="\$(get_active_window)"
    [[ "\$window" == *"Terminal"* ]] || [[ "\$window" == *"xterm"* ]] || \
    [[ "\$window" == *"gnome-terminal"* ]] || [[ "\$window" == *"konsole"* ]]
}

# Function to enable MMB (normal behavior for browsers and terminals)
enable_mmb() {
    xinput set-button-map "\$MOUSE_DEVICE" 1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20 2>/dev/null || true
}

# Function to disable MMB paste (for other applications)
disable_mmb_paste() {
    # Don't constantly remap buttons - this interferes with Chrome autoscroll
    # Instead, just rely on GTK settings to disable primary paste
    :
}

# Main monitoring loop
log_file="\$HOME/.mmb-smart-handler.log"
echo "Smart MMB Handler started at \$(date)" >> "\$log_file"

while true; do
    if is_browser || is_terminal; then
        enable_mmb
        echo "\$(date): Browser/Terminal detected - MMB enabled" >> "\$log_file"
    else
        disable_mmb_paste
        echo "\$(date): Other app - MMB paste disabled" >> "\$log_file"
    fi
    sleep 0.5
done
EOF
    
    chmod +x "$HOME/.local/bin/mmb-smart-handler"
    
    chmod +x "$HOME/.local/bin/mmb-smart-handler"
    
    # Method 4: Setup imwheel for enhanced scrolling (exclude browsers)
    log "Setting up enhanced scrolling..."
    cat > "$HOME/.imwheelrc" << 'EOF'
# Enhanced scrolling configuration - exclude browsers to prevent conflicts
"^(?!.*Chrome)(?!.*Firefox)(?!.*Chromium).*"
None,      Up,   Button4, 3
None,      Down, Button5, 3
Shift_L,   Up,   Shift_L|Button4
Shift_L,   Down, Shift_L|Button5
Control_L, Up,   Control_L|Button4
Control_L, Down, Control_L|Button5

# Let browsers handle their own scrolling natively
".*Chrome.*"
None, Up, Button4, 1
None, Down, Button5, 1

".*Firefox.*"
None, Up, Button4, 1
None, Down, Button5, 1

".*Chromium.*"
None, Up, Button4, 1
None, Down, Button5, 1
EOF
    
    # Kill existing processes and start new ones
    log "Starting MMB services..."
    pkill imwheel 2>/dev/null || true
    pkill mmb-smart-handler 2>/dev/null || true
    
    # Start services with proper configuration
    imwheel &
    "$HOME/.local/bin/mmb-smart-handler" &
    
    log "MMB behavior configured successfully"
    log "- Primary paste disabled system-wide"
    log "- Smart handler running for context-aware behavior"
    log "- Enhanced scrolling enabled"
}

# Function to test MMB behavior
test_mmb_behavior() {
    header "Testing MMB Behavior"
    
    log "Testing MMB configuration..."
    
    # Check if GTK setting is applied
    local gtk_setting
    gtk_setting=$(gsettings get org.gnome.desktop.interface gtk-enable-primary-paste)
    if [[ "$gtk_setting" == "false" ]]; then
        log "✓ GTK primary paste disabled"
    else
        warn "✗ GTK primary paste still enabled"
    fi
    
    # Check if processes are running
    if pgrep imwheel >/dev/null; then
        log "✓ imwheel running (enhanced scrolling)"
    else
        warn "✗ imwheel not running"
    fi
    
    if pgrep -f mmb-smart-handler >/dev/null; then
        log "✓ MMB smart handler running"
    else
        warn "✗ MMB smart handler not running"
    fi
    
    log "MMB test complete"
}

# Function to restart MMB services
restart_mmb_services() {
    header "Restarting MMB Services"
    
    log "Stopping existing MMB services..."
    pkill imwheel 2>/dev/null || true
    pkill mmb-smart-handler 2>/dev/null || true
    
    sleep 1
    
    log "Starting MMB services..."
    imwheel &
    "$HOME/.local/bin/mmb-smart-handler" &
    
    log "MMB services restarted"
}