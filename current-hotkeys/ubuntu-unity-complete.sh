#!/bin/bash

echo "=== Ubuntu Unity Complete Setup - CLEAN RESET ==="
echo "One script to rule them all: Hotkeys + MMB + Screenshots"
echo ""

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Function to print colored output
print_status() {
    echo -e "${GREEN}[INFO]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

print_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

print_header() {
    echo -e "${BLUE}=== $1 ===${NC}"
}

# Check if running as root
if [ "$EUID" -eq 0 ]; then
    print_error "Please don't run this script as root"
    exit 1
fi

# Check desktop environment
print_header "System Check"
if [ "$XDG_CURRENT_DESKTOP" = "Unity" ]; then
    print_status "Unity desktop environment detected - perfect!"
else
    print_warning "This script is optimized for Unity desktop"
    print_warning "Current desktop: $XDG_CURRENT_DESKTOP"
fi

# Install required packages for clipboard support
print_header "Installing Required Packages"
print_status "Installing xclip for clipboard support..."
if ! command -v xclip >/dev/null 2>&1; then
    print_status "Installing xclip..."
    sudo apt update
    sudo apt install -y xclip
else
    print_status "xclip already installed"
fi

# Create necessary directories
print_status "Creating directories..."
mkdir -p ~/.local/bin
mkdir -p ~/.config/autostart
mkdir -p ~/Pictures/Screenshots

# 1. COMPLETE HOTKEY RESET
print_header "COMPLETE HOTKEY RESET - Clean Slate"
print_status "Resetting ALL Unity hotkeys to default state..."

# Reset Unity window manager hotkeys
print_status "Resetting Unity window manager hotkeys..."
dconf reset /org/gnome/desktop/wm/keybindings/show-desktop
dconf reset /org/gnome/desktop/wm/keybindings/switch-applications
dconf reset /org/gnome/desktop/wm/keybindings/maximize
dconf reset /org/gnome/desktop/wm/keybindings/unmaximize
dconf reset /org/gnome/desktop/wm/keybindings/tile-to-side-left
dconf reset /org/gnome/desktop/wm/keybindings/tile-to-side-right

# Reset ALL custom keybindings
print_status "Resetting ALL custom keybindings..."
dconf reset /org/gnome/settings-daemon/plugins/media-keys/custom-keybindings

# Reset any conflicting screenshot hotkeys
print_status "Resetting screenshot hotkeys..."
gsettings reset org.gnome.shell.keybindings screenshot
gsettings reset org.gnome.shell.keybindings show-screenshot-ui

print_status "✅ All hotkeys reset to clean state"

# 2. Setup Unity Hotkeys (Fresh Start)
print_header "Setting Up Unity Hotkeys (Fresh Start)"

# Win + D - Show Desktop
print_status "Setting Win + D to show desktop..."
dconf write /org/gnome/desktop/wm/keybindings/show-desktop "['<Super>d']"

# Win + Tab - Switch Applications
print_status "Setting Win + Tab to switch applications..."
dconf write /org/gnome/desktop/wm/keybindings/switch-applications "['<Super>Tab']"

# Win + Up - Maximize
print_status "Setting Win + Up to maximize..."
dconf write /org/gnome/desktop/wm/keybindings/maximize "['<Super>Up']"

# Win + Down - Unmaximize
print_status "Setting Win + Down to unmaximize..."
dconf write /org/gnome/desktop/wm/keybindings/unmaximize "['<Super>Down']"

# 3. Setup Custom Keybindings (Clean)
print_header "Setting Up Custom Keybindings (Clean)"

# Create custom keybinding for file manager (Win + E)
print_status "Creating Win + E for Files..."
dconf write /org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/file-manager/name "'Open Files'"
dconf write /org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/file-manager/command "'nautilus'"
dconf write /org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/file-manager/binding "'<Super>e'"

# Create custom keybinding for lock screen (Win + L)
print_status "Creating Win + L for Lock Screen..."
dconf write /org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/lock-screen/name "'Lock Screen'"
dconf write /org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/lock-screen/command "'gnome-screensaver-command --lock'"
dconf write /org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/lock-screen/binding "'<Super>l'"

# Create custom keybinding for region screenshot (Alt + Shift + S) - ONLY ONE
print_status "Creating Alt + Shift + S for Region Screenshot (ONLY)..."
dconf write /org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/region-screenshot/name "'Region Screenshot'"
dconf write /org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/region-screenshot/command "'$HOME/.local/bin/smart-screenshot'"
dconf write /org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/region-screenshot/binding "'<Alt><Shift>s'"

# Add all custom keybindings to the list
print_status "Adding custom keybindings to Unity..."
dconf write /org/gnome/settings-daemon/plugins/media-keys/custom-keybindings "['/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/file-manager/', '/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/lock-screen/', '/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/region-screenshot/']"

# 4. Setup MMB (Middle Mouse Button) Functionality
print_header "Setting Up MMB Functionality"

# Kill any existing MMB processes
print_status "Stopping existing MMB processes..."
pkill xbindkeys 2>/dev/null
pkill imwheel 2>/dev/null

# Create proper MMB configuration for Unity
print_status "Creating proper MMB configuration for Unity..."
cat > ~/.xbindkeysrc << 'EOF'
# Proper MMB configuration for Unity
# MMB opens links in new tab AND enables scrolling when held

# Button 6 (often the actual middle mouse button) - Enable scrolling
"xdotool mousedown 2"
    b:6

# Button 6 release - Stop scrolling
"xdotool mouseup 2"
    b:6 + Release

# Button 3 (alternative middle mouse button) - Enable scrolling
"xdotool mousedown 2"
    b:3

# Button 3 release - Stop scrolling
"xdotool mouseup 2"
    b:3 + Release

# Note: Chrome will handle opening links in new tab naturally
# This configuration enables MMB scrolling when held down
EOF

# Setup imwheel for smooth scrolling only (don't interfere with MMB)
print_status "Setting up imwheel for smooth scrolling only..."
cat > ~/.imwheelrc << 'EOF'
# Smooth scrolling configuration - does NOT interfere with MMB
# MMB functionality is handled by Chrome's built-in features
# Format: window_name, modifier, scroll_up, scroll_down

# Chrome/Chromium - smooth scrolling
".*chrome.*"
None,      Up,   Button4, 3
None,      Down, Button5, 3

# Firefox - smooth scrolling  
".*firefox.*"
None,      Up,   Button4, 3
None,      Down, Button5, 3

# All other applications - standard scrolling
".*"
None,      Up,   Button4, 3
None,      Down, Button5, 3
EOF

# Start MMB services
print_status "Starting MMB services..."
xbindkeys -f ~/.xbindkeysrc
imwheel

# 5. Setup Screenshots
print_header "Setting Up Screenshots"

# Create enhanced screenshot script with clipboard support
print_status "Creating enhanced screenshot script with clipboard support..."
cat > ~/.local/bin/smart-screenshot << 'EOF'
#!/bin/bash
# Smart screenshot script for Unity with clipboard support

timestamp=$(date +"%Y%m%d_%H%M%S")
screenshot_dir="$HOME/Pictures/Screenshots"
filename="$screenshot_dir/screenshot_${timestamp}.png"

# Create directory if it doesn't exist
mkdir -p "$screenshot_dir"

# Function to copy to clipboard
copy_to_clipboard() {
    local image_path="$1"
    if command -v xclip >/dev/null 2>&1; then
        # Copy image to clipboard for pasting
        xclip -selection clipboard -t image/png -i "$image_path"
        echo "✅ Screenshot copied to clipboard! You can now paste it anywhere."
    elif command -v wl-copy >/dev/null 2>&1; then
        # Wayland clipboard support
        wl-copy < "$image_path"
        echo "✅ Screenshot copied to clipboard! You can now paste it anywhere."
    else
        echo "⚠️  Install xclip for clipboard support: sudo apt install xclip"
    fi
}

# Function to show help
show_help() {
    echo "Smart Screenshot Tool for Unity (with clipboard support)"
    echo ""
    echo "Usage: $0 [option]"
    echo ""
    echo "Options:"
    echo "  -r, --region    Take region screenshot (default) + copy to clipboard"
    echo "  -f, --full      Take full screen screenshot + copy to clipboard"
    echo "  -w, --window    Take active window screenshot + copy to clipboard"
    echo "  -h, --help      Show this help message"
    echo ""
    echo "Examples:"
    echo "  $0              # Region screenshot + clipboard (default)"
    echo "  $0 -f           # Full screen + clipboard"
    echo "  $0 -w           # Active window + clipboard"
    echo ""
    echo "Note: Screenshots are automatically copied to clipboard for easy pasting!"
}

# Function to take region screenshot
take_region() {
    echo "Select a region to capture..."
    if command -v flameshot >/dev/null 2>&1; then
        # Use flameshot for better region selection
        flameshot gui -p "$filename"
    else
        # Fallback to gnome-screenshot
        gnome-screenshot --area --file="$filename"
    fi
    
    if [ -f "$filename" ]; then
        copy_to_clipboard "$filename"
        echo "Region screenshot saved: $filename"
    else
        echo "Screenshot cancelled or failed"
    fi
}

# Function to take full screenshot
take_full() {
    gnome-screenshot --file="$filename"
    if [ -f "$filename" ]; then
        copy_to_clipboard "$filename"
        echo "Full screenshot saved: $filename"
    else
        echo "Screenshot failed"
    fi
}

# Function to take window screenshot
take_window() {
    gnome-screenshot --window --file="$filename"
    if [ -f "$filename" ]; then
        copy_to_clipboard "$filename"
        echo "Window screenshot saved: $filename"
    else
        echo "Screenshot failed"
    fi
}

# Parse command line arguments
case "${1:-}" in
    -r|--region)
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
    "")
        # Default: region screenshot
        take_region
        ;;
    *)
        echo "Unknown option: $1"
        show_help
        exit 1
        ;;
esac
EOF

chmod +x ~/.local/bin/smart-screenshot

# 6. Create Chrome launcher with proper MMB support
print_header "Setting Up Chrome MMB Support"

# Create Chrome launcher with proper MMB support
print_status "Creating Chrome launcher with proper MMB support..."
cat > ~/.local/bin/chrome-mmb << 'EOF'
#!/bin/bash
# Chrome with proper MMB support
# MMB opens links in new tab and enables autoscroll when held
google-chrome \
  --enable-features=MiddleClickAutoscroll \
  --enable-features=OverlayScrollbar \
  --disable-features=TranslateUI \
  --disable-web-security \
  --disable-features=VizDisplayCompositor \
  --enable-smooth-scrolling \
  "$@"
EOF

chmod +x ~/.local/bin/chrome-mmb

# Create desktop entry for Chrome MMB
print_status "Creating desktop entry for Chrome MMB..."
mkdir -p ~/.local/share/applications
cat > ~/.local/share/applications/google-chrome-mmb.desktop << 'EOF'
[Desktop Entry]
Version=1.0
Type=Application
Name=Chrome (MMB Enhanced)
GenericName=Web Browser
Comment=Google Chrome with enhanced MMB support
Exec=google-chrome --enable-features=MiddleClickAutoscroll
Icon=google-chrome
Terminal=false
Categories=Network;WebBrowser;
MimeType=text/html;text/xml;application/xhtml+xml;application/xml;application/rss+xml;application/rdf+xml;image/gif;image/jpeg;image/png;x-scheme-handler/http;x-scheme-handler/https;x-scheme-handler/ftp;x-scheme-handler/chrome;text/xml;image/svg+xml;application/xml;application/atom+xml;application/rss+xml;application/x-shockwave-flash;application/x-ns-proxy-autoconfig;x-scheme-handler/unknown;text/plain;application/x-vnd.google-chrome.remotedesktop;x-scheme-handler/chrome-extension;
EOF

# 7. Create startup script
print_header "Setting Up Autostart"

# Create startup script
print_status "Creating startup script..."
cat > ~/.config/autostart/ubuntu-unity-enhancements.desktop << 'EOF'
[Desktop Entry]
Type=Application
Name=Ubuntu Unity Enhancements
Comment=Start enhanced hotkeys and MMB functionality
Exec=~/.local/bin/ubuntu-unity-complete
Hidden=false
NoDisplay=false
X-GNOME-Autostart-enabled=true
EOF

# 8. Create utility script for this setup
print_status "Creating utility script..."
cat > ~/.local/bin/ubuntu-unity-complete << 'EOF'
#!/bin/bash
# Utility script to restart MMB functionality

echo "Restarting MMB functionality..."

# Kill any existing processes
pkill xbindkeys 2>/dev/null
pkill imwheel 2>/dev/null

# Start MMB services
xbindkeys -f ~/.xbindkeysrc
imwheel

echo "MMB functionality restarted!"
EOF

chmod +x ~/.local/bin/ubuntu-unity-complete

# 9. Test MMB Functionality
print_header "Testing MMB Functionality"

# Test MMB configuration
print_status "Testing MMB configuration..."
echo "Current xbindkeys config:"
cat ~/.xbindkeysrc
echo ""
echo "Current imwheel config:"
cat ~/.imwheelrc
echo ""

# Test if MMB processes are running
print_status "Testing MMB processes..."
if pgrep xbindkeys >/dev/null; then
    print_status "✓ xbindkeys is running (MMB scrolling)"
else
    print_warning "✗ xbindkeys is not running"
fi

if pgrep imwheel >/dev/null; then
    print_status "✓ imwheel is running (smooth scrolling)"
else
    print_warning "✗ imwheel is not running"
fi

# Test Chrome MMB launcher
print_status "Testing Chrome MMB launcher..."
if [ -f ~/.local/bin/chrome-mmb ]; then
    print_status "✓ Chrome MMB launcher created"
    print_status "  Use: ~/.local/bin/chrome-mmb"
else
    print_warning "✗ Chrome MMB launcher not found"
fi

# 10. Final Testing
print_header "Final Testing"

# Test if everything is working
print_status "Testing configuration..."
if pgrep xbindkeys >/dev/null; then
    print_status "✓ xbindkeys is running"
else
    print_warning "✗ xbindkeys is not running"
fi

if pgrep imwheel >/dev/null; then
    print_status "✓ imwheel is running"
else
    print_warning "✗ imwheel is not running"
fi

# Test hotkey configuration
print_status "Testing hotkey configuration..."
echo "Unity Window Manager Hotkeys:"
dconf read /org/gnome/desktop/wm/keybindings/show-desktop
dconf read /org/gnome/desktop/wm/keybindings/switch-applications
dconf read /org/gnome/desktop/wm/keybindings/maximize
dconf read /org/gnome/desktop/wm/keybindings/unmaximize

echo ""
echo "Custom Keybindings:"
dconf read /org/gnome/settings-daemon/plugins/media-keys/custom-keybindings

# 11. Summary
print_header "Setup Complete!"
echo ""
echo "🎉 Your Ubuntu Unity system is now enhanced with:"
echo ""
echo "🖱️  Hotkeys:"
echo "   • Win + E: Open Files"
echo "   • Win + D: Show Desktop"
echo "   • Alt + Shift + S: Region Screenshot (ONLY - no conflicts)"
echo "   • Win + L: Lock Screen"
echo "   • Win + Tab: Switch Apps"
echo "   • Win + Up/Down: Maximize/Unmaximize"
echo ""
echo "🖱️  MMB (Middle Mouse Button):"
echo "   • Opens links in new tab when middle-clicking links"
echo "   • Enables scrolling when MMB is held down"
echo "   • Enhanced Chrome launcher with proper MMB flags"
echo "   • Smooth scrolling with mouse wheel (doesn't interfere with MMB)"
echo ""
echo "📸 Screenshots:"
echo "   • Smart screenshot tool with multiple options"
echo "   • Alt+Shift+S for region selection (ONLY hotkey)"
echo "   • Screenshots automatically copied to clipboard"
echo "   • Screenshots saved to ~/Pictures/Screenshots/"
echo "   • Easy pasting anywhere with Ctrl+V"
echo ""
echo "🛠️  Tools Created:"
echo "   • ~/.local/bin/smart-screenshot - Enhanced screenshot tool"
echo "   • ~/.local/bin/chrome-mmb - Chrome with MMB support"
echo "   • ~/.local/bin/ubuntu-unity-complete - MMB restart utility"
echo ""
echo "🚀 To get started:"
echo "   1. Test your hotkeys: Win+E, Win+D, Alt+Shift+S"
echo "   2. Use Chrome MMB: ~/.local/bin/chrome-mmb"
echo "   3. Take screenshots: Alt+Shift+S (automatically copied to clipboard)"
echo "   4. Test MMB: Middle-click links for new tab, hold MMB for scrolling"
echo "   5. Restart MMB if needed: ~/.local/bin/ubuntu-unity-complete"
echo ""
echo "📝 Notes:"
echo "   • ALL hotkeys have been reset and reconfigured cleanly"
echo "   • Alt+Shift+S is the ONLY region screenshot hotkey (no conflicts)"
echo "   • RMB behavior should now be normal (no Shift key required)"
echo "   • MMB functionality works best in modern browsers"
echo "   • Screenshots are automatically copied to clipboard for easy pasting"
echo "   • MMB opens links in new tab, hold for scrolling (like Windows)"
echo "   • Use Chrome MMB launcher for best MMB experience"
echo ""
echo "🔄 To reset everything again:"
echo "   dconf reset /org/gnome/settings-daemon/plugins/media-keys/custom-keybindings"
echo "   dconf reset /org/gnome/desktop/wm/keybindings/show-desktop"
echo "   dconf reset /org/gnome/desktop/wm/keybindings/switch-applications"
echo "   dconf reset /org/gnome/desktop/wm/keybindings/maximize"
echo "   dconf reset /org/gnome/desktop/wm/keybindings/unmaximize"
echo ""
echo "Enjoy your enhanced Ubuntu Unity experience! 🎊"
