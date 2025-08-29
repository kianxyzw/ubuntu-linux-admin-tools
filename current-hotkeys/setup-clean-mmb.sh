#!/bin/bash

echo "=== 🖱️ Clean MMB Setup (Theme-Safe) ==="
echo ""

echo "1. Setting up clean MMB functionality..."
# Only set the essential MMB settings that don't affect themes
gsettings set org.gnome.desktop.interface gtk-enable-primary-paste false
gsettings set org.gnome.desktop.peripherals.mouse middle-click-emulation false
gsettings set org.gnome.desktop.peripherals.touchpad middle-click-emulation false
echo "✅ Essential MMB settings configured"

echo ""
echo "2. Starting imwheel for enhanced scrolling..."
# Start imwheel if not already running
if ! pgrep imwheel > /dev/null; then
    imwheel &
    echo "✅ imwheel started"
else
    echo "✅ imwheel already running"
fi

echo ""
echo "3. Setting up xbindkeys for MMB control..."
# Create a simple xbindkeys config
cat > ~/.xbindkeysrc << 'EOF'
# MMB Button 2 (middle mouse button)
"xdotool click 2"
    m:0x0 + b:2

# MMB Button 3 (right mouse button) 
"xdotool click 3"
    m:0x0 + b:3
EOF

echo "✅ xbindkeys config created"

echo ""
echo "4. Starting xbindkeys..."
# Kill any existing xbindkeys and start fresh
pkill xbindkeys 2>/dev/null
sleep 1
xbindkeys &
echo "✅ xbindkeys started"

echo ""
echo "5. Testing MMB functionality..."
echo "   • MMB paste should be disabled everywhere"
echo "   • MMB should work for scrolling in Chrome"
echo "   • MMB should work for new tabs in Chrome"
echo "   • Your theme should remain intact"

echo ""
echo "🎉 Clean MMB setup complete!"
echo ""
echo "📝 What this provides:"
echo "   • MMB paste disabled (no more accidental pasting)"
echo "   • Enhanced scrolling with imwheel"
echo "   • Chrome MMB functionality preserved"
echo "   • No theme interference"
echo "   • Clean, simple configuration"
echo ""
echo "🔄 To test:"
echo "   • Try MMB in Chrome (should open new tabs)"
echo "   • Try MMB in other apps (should not paste)"
echo "   • Check that your theme still looks good"
echo ""
echo "🎨 Your theme should now be fully restored with working MMB!"
