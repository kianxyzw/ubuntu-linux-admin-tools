#!/bin/bash
# Autostart Module
# Sets up automatic startup of services

setup_autostart() {
    header "Setting Up Autostart"
    
    # Create main startup script
    log "Creating main startup script..."
    cat > "$HOME/.local/bin/ubuntu-gnome-startup" << 'EOF'
#!/bin/bash
# Ubuntu GNOME Startup Script
# Starts all necessary services

# Wait for desktop to be ready
sleep 3

# Log file
LOG_FILE="$HOME/.ubuntu-unity-startup.log"
echo "Ubuntu GNOME startup at $(date)" >> "$LOG_FILE"

# Function to log messages
log_startup() {
    echo "$(date): $1" >> "$LOG_FILE"
}

# Kill existing processes
log_startup "Stopping existing processes..."
pkill imwheel 2>/dev/null || true
pkill mmb-smart-handler 2>/dev/null || true

# Wait a moment
sleep 1

# Start MMB services
log_startup "Starting MMB services..."
if command -v imwheel >/dev/null 2>&1; then
    imwheel -b "4 5" &
    log_startup "imwheel started"
fi

if [[ -x "$HOME/.local/bin/mmb-smart-handler" ]]; then
    "$HOME/.local/bin/mmb-smart-handler" &
    log_startup "MMB smart handler started"
fi

log_startup "Ubuntu GNOME startup complete"
EOF
    
    chmod +x "$HOME/.local/bin/ubuntu-gnome-startup"
    log "✓ Startup script created"
    
    # Create autostart desktop entry
    log "Creating autostart desktop entry..."
    cat > "$HOME/.config/autostart/ubuntu-gnome-enhancements.desktop" << 'EOF'
[Desktop Entry]
Type=Application
Name=Ubuntu GNOME Enhancements
Comment=Start Ubuntu GNOME enhancements (hotkeys, MMB, etc.)
Exec=/home/ian/.local/bin/ubuntu-gnome-startup
Hidden=false
NoDisplay=false
X-GNOME-Autostart-enabled=true
StartupNotify=false
EOF
    
    # Fix the Exec path to use actual home directory
    sed -i "s|/home/ian|$HOME|g" "$HOME/.config/autostart/ubuntu-gnome-enhancements.desktop"
    
    log "✓ Autostart entry created"
    
    # Create systemd user service as backup
    log "Creating systemd user service..."
    mkdir -p "$HOME/.config/systemd/user"
    cat > "$HOME/.config/systemd/user/ubuntu-gnome.service" << 'EOF'
[Unit]
Description=Ubuntu GNOME Enhancements
After=graphical-session.target
Wants=graphical-session.target

[Service]
Type=forking
ExecStart=%h/.local/bin/ubuntu-gnome-startup
Restart=on-failure
RestartSec=5

[Install]
WantedBy=default.target
EOF
    
    # Enable systemd service
    systemctl --user daemon-reload
    systemctl --user enable ubuntu-gnome.service
    
    log "✓ Systemd service created and enabled"
    
    log "Autostart setup complete"
    log "- Services will start automatically on login"
    log "- Manual restart: ~/.local/bin/ubuntu-gnome-startup"
}

# Function to test autostart
test_autostart() {
    header "Testing Autostart Configuration"
    
    # Check startup script
    if [[ -x "$HOME/.local/bin/ubuntu-gnome-startup" ]]; then
        log "✓ Startup script exists and is executable"
    else
        warn "✗ Startup script not found or not executable"
    fi
    
    # Check autostart entry
    if [[ -f "$HOME/.config/autostart/ubuntu-gnome-enhancements.desktop" ]]; then
        log "✓ Autostart desktop entry exists"
    else
        warn "✗ Autostart desktop entry not found"
    fi
    
    # Check systemd service
    if systemctl --user is-enabled ubuntu-gnome.service >/dev/null 2>&1; then
        log "✓ Systemd service is enabled"
    else
        warn "✗ Systemd service not enabled"
    fi
    
    log "Autostart test complete"
}

# Function to start services manually
start_services() {
    header "Starting Services Manually"
    
    if [[ -x "$HOME/.local/bin/ubuntu-gnome-startup" ]]; then
        "$HOME/.local/bin/ubuntu-gnome-startup"
        log "Services started manually"
    else
        error "Startup script not found"
        return 1
    fi
}