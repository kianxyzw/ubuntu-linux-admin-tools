#!/bin/bash

echo "=== 🎨 Complete Theme Restoration ==="
echo ""

echo "1. Stopping problematic autostart services..."
# Stop the services that are interfering with themes
if [ -f ~/.local/bin/ubuntu-unity-v1-startup ]; then
    echo "   Stopping ubuntu-unity-v1-startup..."
    pkill -f "ubuntu-unity-v1-startup" 2>/dev/null
    echo "   ✅ Stopped"
fi

if [ -f ~/.local/bin/mmb-smart-handler ]; then
    echo "   Stopping mmb-smart-handler..."
    pkill -f "mmb-smart-handler" 2>/dev/null
    echo "   ✅ Stopped"
fi

echo ""
echo "2. Removing problematic autostart entries..."
# Remove the autostart entries that are causing theme issues
if [ -f ~/.config/autostart/ubuntu-unity-v1.desktop ]; then
    echo "   Removing ubuntu-unity-v1.desktop..."
    rm ~/.config/autostart/ubuntu-unity-v1.desktop
    echo "   ✅ Removed"
fi

if [ -f ~/.config/autostart/mmb-smart-handler.desktop ]; then
    echo "   Removing mmb-smart-handler.desktop..."
    rm ~/.config/autostart/mmb-smart-handler.desktop
    echo "   ✅ Removed"
fi

echo ""
echo "3. Removing problematic startup scripts..."
# Remove the scripts that are setting problematic gsettings
if [ -f ~/.local/bin/ubuntu-unity-v1-startup ]; then
    echo "   Removing ubuntu-unity-v1-startup..."
    rm ~/.local/bin/ubuntu-unity-v1-startup
    echo "   ✅ Removed"
fi

if [ -f ~/.local/bin/mmb-smart-handler ]; then
    echo "   Removing mmb-smart-handler..."
    rm ~/.local/bin/mmb-smart-handler
    echo "   ✅ Removed"
fi

echo ""
echo "4. Resetting ALL Unity and GTK settings to defaults..."
# Reset all the settings that might be interfering
dconf reset /org/gnome/desktop/interface/gtk-theme
dconf reset /org/gnome/desktop/interface/icon-theme
dconf reset /org/gnome/desktop/interface/cursor-theme
dconf reset /org/gnome/desktop/background/picture-uri
dconf reset /org/gnome/desktop/background/picture-options
dconf reset /org/gnome/desktop/interface/gtk-enable-primary-paste
dconf reset /org/gnome/desktop/peripherals/mouse/middle-click-emulation
dconf reset /org/gnome/desktop/peripherals/touchpad/middle-click-emulation
dconf reset /org/gnome/desktop/peripherals/trackball/middle-click-emulation
dconf reset /org/gnome/desktop/wm/preferences/action-middle-click-titlebar
dconf reset /org/gnome/mutter/workspaces-only-on-primary
dconf reset /org/gnome/mutter/display-arrangement-setup
echo "✅ All Unity/GTK settings reset"

echo ""
echo "5. Cleaning up any remaining environment variables..."
# Remove any remaining environment variable exports
unset GTK_USE_PORTAL
unset GDK_USE_XFT
unset CLIPBOARD_FORCE_SELECTION
unset GTK_ENABLE_PRIMARY_PASTE
unset GDK_ENABLE_PRIMARY_PASTE
echo "✅ Environment variables unset"

echo ""
echo "6. Restarting Unity completely..."
echo "   This will restart Unity and restore your original theme..."
echo "   Press Enter to continue..."
read

# Kill Unity completely and restart
pkill -f unity
sleep 2
unity --replace &

echo ""
echo "🎉 Complete theme restoration finished!"
echo ""
echo "📝 What was completely removed:"
echo "   • Problematic autostart entries"
echo "   • Theme-interfering startup scripts"
echo "   • All Unity/GTK settings reset to defaults"
echo "   • Environment variables cleared"
echo "   • Unity completely restarted"
echo ""
echo "🔄 Next steps:"
echo "   • Your theme should now be completely restored"
echo "   • If not, logout and login again"
echo "   • The MMB functionality will still work via imwheel"
echo ""
echo "🎨 Your original Unity appearance should now be fully restored!"
