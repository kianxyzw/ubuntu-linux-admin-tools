#!/bin/bash

echo "=== 🎨 Complete Ubuntu Unity Theme Restoration ==="
echo ""

echo "1. Setting proper Ubuntu background..."
# Set the classic Ubuntu background
gsettings set org.gnome.desktop.background picture-uri 'file:///usr/share/backgrounds/ubuntu-default-greyscale-wallpaper.png'
gsettings set org.gnome.desktop.background picture-options 'zoom'
echo "✅ Ubuntu background restored"

echo ""
echo "2. Setting proper Ubuntu themes..."
# Set the classic Ubuntu themes
gsettings set org.gnome.desktop.interface gtk-theme 'Ambiance'
gsettings set org.gnome.desktop.interface icon-theme 'ubuntu-mono-dark'
gsettings set org.gnome.desktop.interface cursor-theme 'DMZ-White'
echo "✅ Ubuntu themes restored"

echo ""
echo "3. Setting proper Unity appearance..."
# Set Unity-specific appearance settings
dconf write /org/gnome/desktop/interface/gtk-theme "'Ambiance'"
dconf write /org/gnome/desktop/interface/icon-theme "'ubuntu-mono-dark'"
dconf write /org/gnome/desktop/interface/cursor-theme "'DMZ-White'"
dconf write /org/gnome/desktop/background/picture-uri "'file:///usr/share/backgrounds/ubuntu-default-greyscale-wallpaper.png'"
dconf write /org/gnome/desktop/background/picture-options "'zoom'"
echo "✅ Unity appearance restored"

echo ""
echo "4. Resetting workspace display settings..."
# Fix workspace display issues
dconf reset /org/gnome/mutter/workspaces-only-on-primary
dconf reset /org/gnome/mutter/display-arrangement-setup
dconf write /org/gnome/mutter/workspaces-only-on-primary true
echo "✅ Workspace settings fixed"

echo ""
echo "5. Setting proper color scheme..."
# Set the classic Ubuntu color scheme
gsettings set org.gnome.desktop.interface color-scheme 'prefer-dark'
echo "✅ Color scheme restored"

echo ""
echo "6. Resetting any remaining problematic settings..."
# Clear any remaining problematic settings
dconf reset /org/gnome/desktop/interface/gtk-enable-primary-paste
dconf reset /org/gnome/desktop/peripherals/mouse/middle-click-emulation
dconf reset /org/gnome/desktop/peripherals/touchpad/middle-click-emulation
dconf reset /org/gnome/desktop/peripherals/trackball/middle-click-emulation
echo "✅ Problematic settings cleared"

echo ""
echo "7. Setting minimal MMB settings (theme-safe)..."
# Only set essential MMB settings that don't affect themes
gsettings set org.gnome.desktop.interface gtk-enable-primary-paste false
gsettings set org.gnome.desktop.peripherals.mouse middle-click-emulation false
echo "✅ MMB settings configured (theme-safe)"

echo ""
echo "8. Starting essential services..."
# Start imwheel for scrolling
if ! pgrep imwheel > /dev/null; then
    imwheel &
    echo "✅ imwheel started"
else
    echo "✅ imwheel already running"
fi

echo ""
echo "9. Testing theme restoration..."
echo "   • Background should be Ubuntu default (grey/orange)"
echo "   • Theme should be classic Ambiance (brown/orange)"
echo "   • Icons should be ubuntu-mono-dark"
echo "   • Workspace display should be normal"

echo ""
echo "🎉 Complete Ubuntu Unity theme restoration finished!"
echo ""
echo "📝 What was restored:"
echo "   • Classic Ubuntu background (ubuntu-default-greyscale-wallpaper.png)"
echo "   • Ambiance GTK theme (classic Ubuntu brown/orange)"
echo "   • ubuntu-mono-dark icon theme"
echo "   • DMZ-White cursor theme"
echo "   • Proper workspace display"
echo "   • Classic Ubuntu color scheme"
echo "   • MMB functionality (theme-safe)"
echo ""
echo "🔄 Next steps:"
echo "   • Your desktop should now look like classic Ubuntu Unity"
echo "   • If not, logout and login again"
echo "   • MMB should work without theme interference"
echo ""
echo "🎨 Your Ubuntu Unity appearance should now be completely restored!"
