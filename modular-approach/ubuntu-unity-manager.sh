#!/bin/bash
# Ubuntu Unity Manager
# Main control script for Ubuntu Unity setup

set -euo pipefail

# Get script directory
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Source common functions
source "$SCRIPT_DIR/modules/common.sh"

# Source all modules
source "$SCRIPT_DIR/modules/hotkeys.sh"
# source "$SCRIPT_DIR/modules/mmb-handler.sh"  # DEPRECATED: MMB handler not working reliably
source "$SCRIPT_DIR/modules/screenshots.sh"
source "$SCRIPT_DIR/modules/chrome-setup.sh"
source "$SCRIPT_DIR/modules/autostart.sh"

# Show help
show_help() {
    echo "Ubuntu Unity Manager"
    echo ""
    echo "Commands:"
    echo "  install   - Install everything"
    echo "  test      - Test configuration"
    echo "  restart   - Restart services"
    echo "  status    - Show current status"
    echo "  backup    - Create backup"
    echo "  reset     - Reset hotkeys"
    echo "  help      - Show this help"
    echo ""
    echo "Examples:"
    echo "  $0 install    # Complete setup"
    echo "  $0 test       # Test all components"
    echo "  $0 status     # Check status"
}

# Install everything
install_all() {
    header "Ubuntu Unity Manager - Complete Installation"
    
    # Check prerequisites
    check_prerequisites
    
    # Setup directories
    setup_directories
    
    # Install all modules
    setup_hotkeys
    # setup_mmb_behavior  # DEPRECATED: MMB handler disabled due to reliability issues
    setup_screenshots
    setup_chrome_mmb || warn "Chrome setup failed (Chrome may not be installed)"
    setup_autostart
    
    log "Installation complete!"
    log "Please log out and log back in for all changes to take effect."
}

# Test configuration
test_configuration() {
    header "Testing Configuration"
    
    # Check if test script exists
    if [[ -f "$SCRIPT_DIR/test-setup.sh" ]]; then
        log "Running comprehensive tests..."
        "$SCRIPT_DIR/test-setup.sh"
    else
        # Basic tests
        log "Running basic tests..."
        
        # Test hotkeys
        log "Testing hotkey bindings..."
        if dconf read /org/gnome/desktop/wm/keybindings/show-desktop | grep -q "Super"; then
            log "✓ Win+D hotkey configured"
        else
            warn "✗ Win+D hotkey not configured"
        fi
        
        # Test screenshot script
        if [[ -x "$HOME/.local/bin/smart-screenshot" ]]; then
            log "✓ Screenshot script installed"
        else
            warn "✗ Screenshot script missing"
        fi
        
        # Test startup script
        if [[ -f "$HOME/.config/autostart/ubuntu-unity-startup.desktop" ]]; then
            log "✓ Autostart configured"
        else
            warn "✗ Autostart not configured"
        fi
    fi
}

# Restart services
restart_services() {
    header "Restarting Services"
    
    # Kill existing processes
    log "Stopping existing services..."
    pkill -f "ubuntu-unity-startup" || true
    # pkill -f "imwheel" || true  # DEPRECATED: MMB handler disabled
    
    # Restart services
    log "Starting services..."
    if [[ -x "$HOME/.local/bin/ubuntu-unity-startup" ]]; then
        nohup "$HOME/.local/bin/ubuntu-unity-startup" >/dev/null 2>&1 &
        log "✓ Startup script restarted"
    fi
    
    # Reload hotkeys
    log "Reloading hotkeys..."
    dconf update
    
    log "Services restarted successfully"
}

# Show status
show_status() {
    header "Ubuntu Unity Status"
    
    # Check processes
    echo "Running Processes:"
    if pgrep -f "ubuntu-unity-startup" >/dev/null; then
        echo "  ✓ ubuntu-unity-startup: Running"
    else
        echo "  ✗ ubuntu-unity-startup: Not running"
    fi
    
    # MMB handler deprecated
    # if pgrep -f "imwheel" >/dev/null; then
    #     echo "  ✓ imwheel: Running"
    # else
    #     echo "  ✗ imwheel: Not running"
    # fi
    
    # Check files
    echo ""
    echo "Configuration Files:"
    local files=(
        "$HOME/.local/bin/smart-screenshot"
        "$HOME/.local/bin/ubuntu-unity-startup"
        "$HOME/.config/autostart/ubuntu-unity-startup.desktop"
        # "$HOME/.imwheelrc"  # DEPRECATED: MMB handler disabled
    )
    
    for file in "${files[@]}"; do
        if [[ -f "$file" ]]; then
            echo "  ✓ $(basename "$file"): Exists"
        else
            echo "  ✗ $(basename "$file"): Missing"
        fi
    done
    
    # Check hotkeys
    echo ""
    echo "Hotkey Bindings:"
    local show_desktop
    show_desktop=$(dconf read /org/gnome/desktop/wm/keybindings/show-desktop 2>/dev/null || echo "[]")
    if [[ "$show_desktop" == *"Super"* ]]; then
        echo "  ✓ Win+D: Configured"
    else
        echo "  ✗ Win+D: Not configured"
    fi
}

# Create backup
create_backup() {
    header "Creating Backup"
    
    local backup_dir="$HOME/.ubuntu-unity-backup-$(date +%Y%m%d_%H%M%S)"
    mkdir -p "$backup_dir"
    
    # Backup configuration files
    local files_to_backup=(
        "$HOME/.imwheelrc"
        "$HOME/.profile"
        "$HOME/.local/bin/smart-screenshot"
        "$HOME/.local/bin/ubuntu-unity-startup"
        "$HOME/.config/autostart/ubuntu-unity-startup.desktop"
    )
    
    for file in "${files_to_backup[@]}"; do
        if [[ -f "$file" ]]; then
            cp "$file" "$backup_dir/"
            log "Backed up: $(basename "$file")"
        fi
    done
    
    # Backup dconf settings
    log "Backing up dconf settings..."
    dconf dump /org/gnome/desktop/wm/keybindings/ > "$backup_dir/keybindings.dconf" 2>/dev/null || true
    dconf dump /org/gnome/settings-daemon/plugins/media-keys/ > "$backup_dir/media-keys.dconf" 2>/dev/null || true
    
    log "Backup created in: $backup_dir"
}

# Reset hotkeys
reset_hotkeys() {
    header "Resetting Hotkeys"
    
    log "Resetting all custom hotkeys..."
    dconf reset -f /org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/ || true
    dconf reset /org/gnome/desktop/wm/keybindings/show-desktop || true
    dconf reset /org/gnome/desktop/wm/keybindings/switch-applications || true
    dconf reset /org/gnome/desktop/wm/keybindings/maximize || true
    dconf reset /org/gnome/desktop/wm/keybindings/unmaximize || true
    
    log "Hotkeys reset to defaults"
    log "Run '$0 install' to reconfigure hotkeys"
}

# Handle commands
case "${1:-help}" in
    "install")
        install_all
        ;;
    "test")
        test_configuration
        ;;
    "restart")
        restart_services
        ;;
    "status")
        show_status
        ;;
    "backup")
        create_backup
        ;;
    "reset")
        reset_hotkeys
        ;;
    "help"|"")
        show_help
        ;;
    *)
        error "Unknown command: $1"
        echo ""
        show_help
        exit 1
        ;;
esac