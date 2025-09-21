# Ubuntu Desktop Enhancement Scripts

A collection of scripts to enhance Ubuntu 24.04 GNOME desktop with Windows-style hotkeys, improved MMB behavior, and enhanced screenshot functionality.

## 🎯 What This Does

- **Windows-style hotkeys**: Win+E, Win+D, Alt+Shift+S, etc.
- **Enhanced screenshots**: Smart screenshot tool with clipboard integration
- **MMB behavior improvements**: Reduces accidental pasting (with Chrome limitations)
- **System optimization**: Clean, modular, and maintainable approach

## 🚀 Quick Start

```bash
# Clone the repository
git clone <repository-url>
cd ubuntu-desktop-enhancements

# Run the modular setup (recommended)
cd modular-approach
./ubuntu-unity-manager.sh install
```

## 📁 Project Structure

```
├── modular-approach/           # Recommended modular implementation
│   ├── ubuntu-unity-manager.sh # Main control script
│   └── modules/               # Individual feature modules
└── README.md                  # This file
```

## ✅ What Works

- **Hotkeys**: All Windows-style hotkeys work perfectly
- **Screenshots**: Enhanced screenshot tool with clipboard support
- **System MMB paste**: Disabled in most applications
- **Chrome MMB functions**: New tabs, autoscroll, tab closing work
- **Modular design**: Easy to maintain and extend

## ⚠️ Known Limitations

### Chrome MMB Paste Issue
**Problem**: Middle mouse button still pastes in Chrome text fields.

**Why**: Chrome's MMB paste is hardcoded at the browser engine level and cannot be disabled through any known method (flags, extensions, or policies).

**Solutions**:
1. **Use Firefox**: Has a setting to disable MMB paste completely
2. **Be mindful**: Avoid middle-clicking in Chrome text fields
3. **Clear selection**: Select nothing before using MMB in Chrome

**Research Status**: Extensively researched - this affects all Chrome users on Linux.

## 🛠️ Usage

### Install Everything
```bash
./ubuntu-unity-manager.sh install
```

### Check Status
```bash
./ubuntu-unity-manager.sh status
```

### Test Configuration
```bash
./ubuntu-unity-manager.sh test
```

### Reset if Needed
```bash
./ubuntu-unity-manager.sh reset
```

## 🎯 Target System

- **OS**: Ubuntu 24.04 LTS
- **Desktop**: GNOME (default Ubuntu desktop)
- **Architecture**: x64
- **Requirements**: Standard Ubuntu installation

## 🔧 Features Included

### Hotkeys
- **Win + E**: Open Files (Nautilus)
- **Win + D**: Show Desktop
- **Alt + Shift + S**: Region Screenshot
- **Win + L**: Lock Screen
- **Win + Tab**: Switch Applications
- **Win + Up/Down**: Maximize/Unmaximize

### Screenshots
- **Smart screenshot tool**: Multiple capture modes
- **Automatic clipboard copy**: Screenshots copied for easy pasting
- **Organized storage**: Saved to ~/Pictures/Screenshots/
- **Multiple formats**: Region, window, full screen

### MMB Improvements
- **System-wide paste disabled**: Prevents accidental pasting in terminals, editors
- **Chrome functions preserved**: New tabs, autoscroll, tab closing still work
- **Enhanced scrolling**: Smooth scrolling improvements

## 🧪 Testing

The scripts have been tested on:
- Fresh Ubuntu 24.04 installation
- Mixed GNOME/Unity systems (after reset to pure GNOME)
- Various hardware configurations

## 🤝 Contributing

This project documents real-world solutions for Ubuntu desktop enhancement. Contributions welcome for:
- Additional hotkey configurations
- Alternative MMB solutions
- System compatibility improvements
- Documentation updates

## 📝 License

MIT License - Feel free to use and modify.

## 🔗 Related

- [Ubuntu GNOME Documentation](https://help.gnome.org/)
- [Chrome MMB Paste Issue Discussion](https://bugs.chromium.org/)
- [Firefox MMB Configuration](https://support.mozilla.org/)