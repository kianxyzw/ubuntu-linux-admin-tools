# Current Hotkeys Directory

This directory contains the **essential, working scripts** for Ubuntu Unity hotkeys and MMB functionality.

## 🎯 **Main Script**

### **`ubuntu-unity-complete.sh`** ⭐ **THE ONE SCRIPT TO RULE THEM ALL**
- **Sets up everything**: Hotkeys + MMB + Screenshots
- **Unity-optimized**: Works perfectly with Unity desktop
- **Comprehensive**: Handles all your requested functionality
- **Self-contained**: No need for other scripts

## 🚀 **Quick Start**

```bash
# Run the complete setup (recommended)
./ubuntu-unity-complete.sh
```

This single script will:
- ✅ Set up all Windows-style hotkeys (Win+E, Win+D, Alt+Shift+S, etc.)
- ✅ Configure MMB (Middle Mouse Button) for opening links in new tab
- ✅ Enable MMB autoscroll when held down (like Windows)
- ✅ Create enhanced screenshot tools with clipboard support
- ✅ Configure Chrome with proper MMB support and flags
- ✅ Set up autostart services
- ✅ Install required packages (xclip for clipboard)

## 🖱️ **What You Get**

### **Hotkeys**
- **Win + E**: Open Files (Nautilus)
- **Win + D**: Show Desktop
- **Alt + Shift + S**: Region Screenshot
- **Win + L**: Lock Screen
- **Win + Tab**: Switch Applications
- **Win + Up/Down**: Maximize/Unmaximize

### **MMB Functionality**
- **New tabs**: Middle-click links to open in new tabs (like Windows)
- **Autoscroll**: Middle-click and hold to enable page scrolling
- **Enhanced Chrome**: Special launcher with proper MMB flags
- **Browser integration**: Works with Chrome, Firefox, etc.

### **Screenshots**
- **Smart Screenshot**: Multi-option screenshot tool
- **Region selection**: Interactive area selection
- **Clipboard support**: Automatically copied for easy pasting
- **Timestamped files**: Organized screenshot management

## 🛠️ **Additional Scripts**

### **`test-mmb-functionality.sh`**
- Comprehensive MMB testing script
- Verifies all MMB processes and configurations
- Easy troubleshooting and verification

## 🔄 **Maintenance**

### **Restart MMB if needed**
```bash
~/.local/bin/ubuntu-unity-complete
```

### **Test your setup**
```bash
# Test hotkeys manually
# Test MMB in browsers
# Test screenshots with Alt+Shift+S
```

### **Reset everything**
```bash
dconf reset /org/gnome/settings-daemon/plugins/media-keys/custom-keybindings
dconf reset /org/gnome/desktop/wm/keybindings/show-desktop
dconf reset /org/gnome/desktop/wm/keybindings/switch-applications
dconf reset /org/gnome/desktop/wm/keybindings/maximize
dconf reset /org/gnome/desktop/wm/keybindings/unmaximize
```

## 📝 **Notes**

- **Unity optimized**: This script is specifically designed for Unity desktop
- **Self-contained**: Everything you need is in one script
- **No conflicts**: Removes old configurations before setting new ones
- **Autostart**: Automatically starts MMB services on login

## 🎊 **That's It!**

One script does everything. No more confusion, no more multiple scripts to run. Just:

```bash
./ubuntu-unity-complete.sh
```

And you're done! 🐧✨
