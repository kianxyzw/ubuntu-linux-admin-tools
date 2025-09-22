#!/bin/bash
# Chrome Setup Module
# Enhanced Chrome launcher with MMB support (Legacy approach - WORKS!)

setup_chrome_mmb() {
    header "Setting Up Chrome MMB Support"
    
    # Check if Chrome is installed
    if ! command -v google-chrome >/dev/null 2>&1; then
        warn "Google Chrome not found. Install it first:"
        warn "wget -q -O - https://dl.google.com/linux/linux_signing_key.pub | sudo apt-key add -"
        warn "sudo sh -c 'echo \"deb [arch=amd64] http://dl.google.com/linux/chrome/deb/ stable main\" >> /etc/apt/sources.list.d/google-chrome.list'"
        warn "sudo apt update && sudo apt install google-chrome-stable"
        return 1
    fi
    
    # Create Chrome launcher with enhanced MMB support (simple approach)
    log "Creating Chrome launcher with enhanced MMB support..."
    cat > "$HOME/.local/bin/chrome-mmb" << 'EOF'
#!/bin/bash
# Chrome with enhanced MMB support
# Simple approach - just optimize Chrome's native MMB behavior

exec google-chrome \
  --enable-features=MiddleClickAutoscroll,SmoothScrolling \
  --enable-smooth-scrolling \
  --disable-features=OverscrollHistoryNavigation \
  "$@"
EOF
    
    chmod +x "$HOME/.local/bin/chrome-mmb"
    log "✓ Chrome MMB launcher created: ~/.local/bin/chrome-mmb"
    
    # Create desktop entry for Chrome MMB
    log "Creating desktop entry for Chrome MMB..."
    mkdir -p "$HOME/.local/share/applications"
    cat > "$HOME/.local/share/applications/google-chrome-mmb.desktop" << EOF
[Desktop Entry]
Version=1.0
Type=Application
Name=Chrome (MMB Enhanced)
GenericName=Web Browser
Comment=Google Chrome with enhanced MMB support
Exec=$HOME/.local/bin/chrome-mmb
Icon=google-chrome
Terminal=false
Categories=Network;WebBrowser;
MimeType=text/html;text/xml;application/xhtml+xml;x-scheme-handler/http;x-scheme-handler/https;
StartupNotify=true
EOF
    
    log "✓ Desktop entry created"
    
    # Update desktop database
    if command -v update-desktop-database >/dev/null 2>&1; then
        update-desktop-database "$HOME/.local/share/applications" 2>/dev/null || true
    fi
    
    log "Chrome MMB setup complete"
    log "- Use: ~/.local/bin/chrome-mmb"
    log "- Or find 'Chrome (MMB Enhanced)' in applications menu"
    log "- Enhanced MMB autoscroll and smooth scrolling"
    log "- MMB new tabs, autoscroll, and tab closing work optimally"
}

# Function to test Chrome setup
test_chrome_setup() {
    header "Testing Chrome Setup"
    
    # Check if Chrome is installed
    if command -v google-chrome >/dev/null 2>&1; then
        log "✓ Google Chrome installed"
        log "  Version: $(google-chrome --version)"
    else
        warn "✗ Google Chrome not installed"
    fi
    
    # Check if launcher exists
    if [[ -x "$HOME/.local/bin/chrome-mmb" ]]; then
        log "✓ Chrome MMB launcher exists and is executable"
    else
        warn "✗ Chrome MMB launcher not found"
    fi
    
    # Check desktop entry
    if [[ -f "$HOME/.local/share/applications/google-chrome-mmb.desktop" ]]; then
        log "✓ Desktop entry exists"
    else
        warn "✗ Desktop entry not found"
    fi
    
    log "Chrome setup test complete"
}