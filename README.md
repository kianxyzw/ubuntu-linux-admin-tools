# Ubuntu Unity Hotkeys & MMB Setup

A comprehensive setup script for Ubuntu Unity that provides enhanced hotkeys, smart MMB (Middle Mouse Button) functionality, and screenshot tools.

## 🎯 What This Provides

### 🖱️ **Hotkeys**
- **Win + E**: Open Files window
- **Win + D**: Show Desktop  
- **Alt + Shift + S**: Region Screenshot (automatically copied to clipboard)
- **Win + L**: Lock Screen
- **Win + Tab**: Switch Applications
- **Win + Up/Down**: Maximize/Unmaximize

### 🖱️ **Smart MMB (Middle Mouse Button)**
- **In Chrome/Firefox**: MMB works normally (new tabs + scrolling)
- **Everywhere else**: MMB is disabled (prevents accidental pasting)
- **Dynamic switching**: Automatically enables/disables based on active window
- **Enhanced scrolling**: imwheel provides smooth scrolling support

### 📸 **Screenshots**
- **Smart screenshot tool** with multiple options
- **Automatic clipboard copy** for easy pasting
- **Organized storage** in `~/Pictures/Screenshots/`
- **No configuration conflicts** (uses gnome-screenshot)

## 🚀 Quick Start

### 1. **Run the Setup Script**
```bash
chmod +x setup-ubuntu-hotkeys.sh
./setup-ubuntu-hotkeys.sh
```

### 2. **Use Chrome with MMB Support**
```bash
~/.local/bin/chrome-mmb
```

### 3. **Take Screenshots**
- **Alt + Shift + S**: Region selection (automatically copied to clipboard)
- **Ctrl + V**: Paste screenshots anywhere

## 🏗️ Repository Structure

```
sandbox_linux_admin/
├── setup-ubuntu-hotkeys.sh          # Main setup script (v1.0 FINAL)
├── README.md                        # This documentation
├── current-hotkeys/                 # Hotkey-related files
│   └── README.md                   # Hotkey-specific documentation
└── ffmpeg-tools/                    # Separate FFmpeg project
    ├── launch_ffmpeg_gui.sh        # FFmpeg GUI launcher
    ├── FFMPEG_README.md            # FFmpeg documentation
    └── FFMPEG_GUI_README.md        # FFmpeg GUI documentation
```

## 🔧 How It Works

### **Smart MMB Handler**
The system uses a smart MMB handler that dynamically enables/disables MMB based on the active window:
- **Browsers (Chrome/Firefox)**: MMB enabled for new tabs and scrolling
- **Terminals**: MMB enabled for scrolling
- **Other applications**: MMB disabled to prevent accidental pasting

### **Chrome MMB Support**
- Chrome handles MMB natively (no interference)
- Enhanced scrolling with `--enable-features=MiddleClickAutoscroll`
- Smooth scrolling with `--enable-smooth-scrolling`

### **Persistence**
- **Autostart**: Automatically runs on login
- **Smart handler**: Continuously monitors and adjusts MMB behavior
- **gsettings**: System-level MMB paste disable

## 🧪 Testing

### **Test MMB Functionality**
1. **Open Chrome**: `~/.local/bin/chrome-mmb`
2. **Test MMB**: Middle-click links (should open in new tab)
3. **Test MMB Scroll**: Hold MMB and move mouse (should scroll)
4. **Switch to Terminal**: MMB should be disabled (no paste)
5. **Switch back to Chrome**: MMB should be enabled again

### **Test Hotkeys**
- **Win + E**: Should open Files window
- **Win + D**: Should show desktop
- **Alt + Shift + S**: Should open region screenshot tool

## 🔄 Troubleshooting

### **If MMB Paste Returns**
The smart handler should automatically fix this, but if issues persist:
```bash
# Restart the smart handler
~/.local/bin/ubuntu-unity-complete
```

### **If Hotkeys Don't Work**
```bash
# Reset Unity hotkeys
dconf reset /org/gnome/settings-daemon/plugins/media-keys/custom-keybindings
dconf reset /org/gnome/desktop/wm/keybindings/show-desktop
```

### **Reset Everything**
```bash
# Run the setup script again
./setup-ubuntu-hotkeys.sh
```

## 📝 Notes

- **MMB paste setting** may require logout/login to fully take effect
- **Chrome MMB** works best with the provided launcher script
- **Screenshots** are automatically copied to clipboard for easy pasting
- **All configurations** are persistent across restarts

## 🎉 What Makes This Special

This setup provides the **best of both worlds**:
- ✅ **MMB works perfectly in Chrome** (new tabs + scrolling)
- ✅ **MMB paste is disabled everywhere else** (no accidental pasting)
- ✅ **Dynamic switching** based on active application
- ✅ **No theme interference** or aggressive overrides
- ✅ **Production ready** with comprehensive error handling

## 📚 Version History

- **v1.0 FINAL**: Complete Ubuntu Unity hotkeys with persistent MMB fix
- **Current**: Clean, organized repository with working v1.0 FINAL approach

---

**Enjoy your enhanced Ubuntu Unity experience!** 🎊 