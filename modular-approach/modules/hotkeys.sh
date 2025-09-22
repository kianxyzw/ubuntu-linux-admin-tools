#!/bin/bash
# Hotkeys Module
# Sets up Windows-style hotkeys for Ubuntu GNOME

setup_hotkeys() {
    header "Setting Up Hotkeys"
    
    # Reset existing hotkeys to clean state
    log "Resetting existing hotkeys..."
    dconf reset -f /org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/ || true
    dconf reset /org/gnome/desktop/wm/keybindings/show-desktop || true
    dconf reset /org/gnome/desktop/wm/keybindings/switch-applications || true
    dconf reset /org/gnome/desktop/wm/keybindings/maximize || true
    dconf reset /org/gnome/desktop/wm/keybindings/unmaximize || true
    
    # Set up GNOME window manager hotkeys
    log "Setting up GNOME window manager hotkeys..."
    
    # Win + D - Show Desktop
    dconf write /org/gnome/desktop/wm/keybindings/show-desktop "['<Super>d']"
    log "✓ Win + D: Show Desktop"
    
    # Win + Tab - Switch Applications
    dconf write /org/gnome/desktop/wm/keybindings/switch-applications "['<Super>Tab']"
    log "✓ Win + Tab: Switch Applications"
    
    # Win + Up - Maximize
    dconf write /org/gnome/desktop/wm/keybindings/maximize "['<Super>Up']"
    log "✓ Win + Up: Maximize"
    
    # Win + Down - Unmaximize
    dconf write /org/gnome/desktop/wm/keybindings/unmaximize "['<Super>Down']"
    log "✓ Win + Down: Unmaximize"
    
    # Set up custom keybindings
    log "Setting up custom keybindings..."
    
    # Win + E - Open Files
    dconf write /org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/file-manager/name "'Open Files'"
    dconf write /org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/file-manager/command "'nautilus'"
    dconf write /org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/file-manager/binding "'<Super>e'"
    log "✓ Win + E: Open Files"
    
    # Win + L - Lock Screen
    dconf write /org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/lock-screen/name "'Lock Screen'"
    dconf write /org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/lock-screen/command "'gnome-screensaver-command --lock'"
    dconf write /org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/lock-screen/binding "'<Super>l'"
    log "✓ Win + L: Lock Screen"
    
    # Alt + Shift + S - Region Screenshot
    dconf write /org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/region-screenshot/name "'Region Screenshot'"
    dconf write /org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/region-screenshot/command "'$HOME/.local/bin/smart-screenshot'"
    dconf write /org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/region-screenshot/binding "'<Alt><Shift>s'"
    log "✓ Alt + Shift + S: Region Screenshot"
    
    # Register all custom keybindings
    dconf write /org/gnome/settings-daemon/plugins/media-keys/custom-keybindings "['/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/file-manager/', '/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/lock-screen/', '/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/region-screenshot/']"
    
    log "Hotkeys setup complete"
}

# Function to test hotkeys
test_hotkeys() {
    header "Testing Hotkeys Configuration"
    
    log "Current hotkey configuration:"
    
    # Test GNOME window manager hotkeys
    echo "GNOME Window Manager Hotkeys:"
    echo "  Show Desktop: $(dconf read /org/gnome/desktop/wm/keybindings/show-desktop)"
    echo "  Switch Apps: $(dconf read /org/gnome/desktop/wm/keybindings/switch-applications)"
    echo "  Maximize: $(dconf read /org/gnome/desktop/wm/keybindings/maximize)"
    echo "  Unmaximize: $(dconf read /org/gnome/desktop/wm/keybindings/unmaximize)"
    
    # Test custom keybindings
    echo "Custom Keybindings:"
    echo "  Registered: $(dconf read /org/gnome/settings-daemon/plugins/media-keys/custom-keybindings)"
    
    log "Hotkeys test complete"
}

# Function to reset hotkeys
reset_hotkeys() {
    header "Resetting Hotkeys"
    
    log "Resetting all hotkeys to default..."
    dconf reset -f /org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/
    dconf reset /org/gnome/desktop/wm/keybindings/show-desktop
    dconf reset /org/gnome/desktop/wm/keybindings/switch-applications
    dconf reset /org/gnome/desktop/wm/keybindings/maximize
    dconf reset /org/gnome/desktop/wm/keybindings/unmaximize
    
    log "Hotkeys reset complete"
}