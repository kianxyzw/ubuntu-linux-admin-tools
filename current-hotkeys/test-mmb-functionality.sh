#!/bin/bash

echo "=== MMB Functionality Test ==="
echo ""

# Colors for output
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
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

echo "1. Testing MMB Processes..."
if pgrep xbindkeys >/dev/null; then
    print_warning "⚠️  xbindkeys is running (this may interfere with Chrome MMB)"
    print_status "   Chrome MMB works best when xbindkeys is NOT running"
else
    print_status "✓ xbindkeys is NOT running (Chrome MMB working natively)"
fi

if pgrep imwheel >/dev/null; then
    print_status "✓ imwheel is running (smooth scrolling)"
else
    print_error "✗ imwheel is not running"
fi

echo ""
echo "2. Testing MMB Configuration..."
if [ -f ~/.xbindkeysrc ]; then
    print_status "✓ xbindkeys config found"
    echo "   Content:"
    cat ~/.xbindkeysrc | sed 's/^/   /'
else
    print_error "✗ xbindkeys config not found"
fi

echo ""
if [ -f ~/.imwheelrc ]; then
    print_status "✓ imwheel config found"
    echo "   Content:"
    cat ~/.imwheelrc | sed 's/^/   /'
else
    print_error "✗ imwheel config not found"
fi

echo ""
echo "3. Testing Chrome MMB Launcher..."
if [ -f ~/.local/bin/chrome-mmb ]; then
    print_status "✓ Chrome MMB launcher found"
    print_status "  Use: ~/.local/bin/chrome-mmb"
else
    print_warning "✗ Chrome MMB launcher not found"
fi

echo ""
echo "4. Testing Screenshot Tool..."
if [ -f ~/.local/bin/smart-screenshot ]; then
    print_status "✓ Smart screenshot tool found"
    print_status "  Use: Alt+Shift+S or ~/.local/bin/smart-screenshot"
else
    print_error "✗ Smart screenshot tool not found"
fi

echo ""
echo "5. Testing Clipboard Support..."
if command -v xclip >/dev/null 2>&1; then
    print_status "✓ xclip installed (clipboard support)"
else
    print_warning "✗ xclip not installed - screenshots won't copy to clipboard"
fi

echo ""
echo "=== Test Summary ==="
echo "To test MMB functionality:"
echo "1. Open a browser and middle-click on a link (should open in new tab)"
echo "2. Middle-click and hold on a page (should enable autoscroll)"
echo "3. Use mouse wheel to scroll (should be smooth)"
echo "4. Press Alt+Shift+S for screenshot (should copy to clipboard)"
echo "5. Use Chrome MMB launcher: ~/.local/bin/chrome-mmb"
echo ""
echo "If MMB isn't working, restart it:"
echo "~/.local/bin/ubuntu-unity-complete"
