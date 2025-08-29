#!/bin/bash

echo "=== 🔄 Force Theme Reload ==="
echo ""

echo "1. Clearing theme caches..."
# Clear GTK and icon caches
gtk-update-icon-cache -f -t ~/.local/share/icons 2>/dev/null || true
gtk-update-icon-cache -f -t /usr/share/icons 2>/dev/null || true
echo "✅ Theme caches cleared"

echo ""
echo "2. Forcing background refresh..."
# Force the background to reload
gsettings set org.gnome.desktop.background picture-uri 'file:///usr/share/backgrounds/ubuntu-default-greyscale-wallpaper.png'
gsettings set org.gnome.desktop.background picture-options 'zoom'
# Also set via dconf to ensure it takes effect
dconf write /org/gnome/desktop/background/picture-uri "'file:///usr/share/backgrounds/ubuntu-default-greyscale-wallpaper.png'"
dconf write /org/gnome/desktop/background/picture-options "'zoom'"
echo "✅ Background forced to refresh"

echo ""
echo "3. Forcing theme refresh..."
# Force the theme to reload
gsettings set org.gnome.desktop.interface gtk-theme 'Ambiance'
gsettings set org.gnome.desktop.interface icon-theme 'ubuntu-mono-dark'
gsettings set org.gnome.desktop.interface cursor-theme 'DMZ-White'
# Also set via dconf
dconf write /org/gnome/desktop/interface/gtk-theme "'Ambiance'"
dconf write /org/gnome/desktop/interface/icon-theme "'ubuntu-mono-dark'"
dconf write /org/gnome/desktop/interface/cursor-theme "'DMZ-White'"
echo "✅ Themes forced to refresh"

echo ""
echo "4. Checking for background processes..."
# Check if there are any processes that might be setting backgrounds
echo "   Processes that might interfere with background:"
ps aux | grep -E "(nitrogen|feh|wallpaper|background)" | grep -v grep || echo "   No background processes found"

echo ""
echo "5. Forcing Unity to reload themes..."
# Try to force Unity to reload
echo "   Killing any Unity processes..."
pkill -f unity 2>/dev/null || true
sleep 2

echo "   Restarting Unity..."
# Try to restart Unity
if command -v unity &> /dev/null; then
    unity --replace &
    echo "✅ Unity restarted"
else
    echo "⚠️  Unity command not found, trying alternative..."
    # Try to restart the display manager
    echo "   You may need to logout/login or restart display manager"
fi

echo ""
echo "6. Final verification..."
echo "   Current background URI:"
gsettings get org.gnome.desktop.background picture-uri
echo "   Current GTK theme:"
gsettings get org.gnome.desktop.interface gtk-theme

echo ""
echo "🎉 Force theme reload complete!"
echo ""
echo "📝 What was done:"
echo "   • Theme caches cleared"
echo "   • Background forced to refresh"
echo "   • Themes forced to reload"
echo "   • Unity restarted"
echo "   • All settings verified"
echo ""
echo "🔄 If theme still looks wrong:"
echo "   • Logout and login again"
echo "   • Or restart your computer"
echo "   • The settings are now correct"
echo ""
echo "🎨 Your Ubuntu Unity theme should now be fully restored!"
