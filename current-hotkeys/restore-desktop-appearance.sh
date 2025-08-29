#!/bin/bash

echo "=== 🎨 Restoring Desktop Appearance ==="
echo ""

echo "1. Removing problematic environment variables from ~/.profile..."
# Remove the aggressive MMB paste disable variables that are breaking Unity
sed -i '/GTK_USE_PORTAL=1/d' ~/.profile
sed -i '/GDK_USE_XFT=1/d' ~/.profile
sed -i '/CLIPBOARD_FORCE_SELECTION=1/d' ~/.profile
sed -i '/GTK_ENABLE_PRIMARY_PASTE=0/d' ~/.profile
sed -i '/GDK_ENABLE_PRIMARY_PASTE=0/d' ~/.profile
echo "✅ Problematic environment variables removed"

echo ""
echo "2. Resetting Unity appearance settings..."
# Reset Unity appearance to defaults
dconf reset /org/gnome/desktop/interface/gtk-theme
dconf reset /org/gnome/desktop/interface/icon-theme
dconf reset /org/gnome/desktop/interface/cursor-theme
dconf reset /org/gnome/desktop/background/picture-uri
dconf reset /org/gnome/desktop/background/picture-options
echo "✅ Unity appearance settings reset"

echo ""
echo "3. Resetting workspace settings..."
# Reset workspace display settings
dconf reset /org/gnome/mutter/workspaces-only-on-primary
dconf reset /org/gnome/mutter/display-arrangement-setup
echo "✅ Workspace settings reset"

echo ""
echo "4. Cleaning up aggressive GTK settings..."
# Remove the aggressive GTK overrides we created
if [ -f ~/.config/gtk-3.0/settings.ini ]; then
    echo "   Removing aggressive GTK settings..."
    rm ~/.config/gtk-3.0/settings.ini
    echo "   ✅ Aggressive GTK settings removed"
fi

echo ""
echo "5. Restarting Unity to apply changes..."
echo "   This will restart Unity and restore your theme..."
echo "   Press Enter to continue..."
read

# Restart Unity
unity --replace &

echo ""
echo "🎉 Desktop appearance restoration complete!"
echo ""
echo "📝 What was fixed:"
echo "   • Removed problematic environment variables"
echo "   • Reset Unity appearance settings"
echo "   • Reset workspace display settings"
echo "   • Removed aggressive GTK overrides"
echo "   • Restarted Unity"
echo ""
echo "🔄 If Unity doesn't restart automatically, try:"
echo "   • Logging out and back in"
echo "   • Or running: unity --replace &"
echo ""
echo "🎨 Your theme and desktop appearance should now be restored!"
