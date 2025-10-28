# Ubuntu Desktop Enhancement Scripts
# this is comment

A collection of scripts to enhance Ubuntu 24.04 GNOME desktop with Windows-style hotkeys, improved MMB behavior, and enhanced screenshot functionality.

## 🎯 What This Does

- **Windows-style hotkeys**: Win+E, Win+D, Alt+Shift+S, etc.
- **Enhanced screenshots**: Smart screenshot tool with clipboard integration
- **Chrome MMB optimization**: Enhanced Chrome launcher with better MMB support
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
- **Chrome MMB functions**: Enhanced Chrome launcher with optimized MMB behavior
- **Modular design**: Easy to maintain and extend

## ⚠️ Known Limitations

### MMB Handler Deprecated
**Status**: The MMB handler module has been deprecated due to reliability issues.

**Why**: 
- Complex window detection was unreliable
- imwheel interfered with Chrome's native MMB autoscroll
- GTK settings alone insufficient for complete MMB paste prevention
- Chrome's MMB paste cannot be disabled through any known method

**Current Approach**: 
- Enhanced Chrome launcher with optimized MMB flags
- Focus on improving what works rather than fighting Chrome's limitations
- Use Firefox if MMB paste prevention is critical

**Research Status**: Extensively tested - Chrome's MMB behavior is hardcoded and cannot be reliably modified.

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

### Setup Website Blocker
```bash
./ubuntu-unity-manager.sh blocker
```

### Manage Website Blocking
```bash
# Check status
~/.local/bin/website-blocker-status

# Temporarily disable blocking
~/.local/bin/disable-website-blocker

# Re-enable blocking
~/.local/bin/enable-website-blocker
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

### Chrome MMB Optimization
- **Enhanced Chrome launcher**: Optimized flags for better MMB behavior
- **Native MMB functions**: New tabs, autoscroll, tab closing work optimally
- **Simplified approach**: Focus on what works rather than complex workarounds

### Website Blocker (Productivity)
- **Block distracting sites**: Facebook, Instagram, Twitter, TikTok, Reddit, YouTube
- **Easy management**: Enable/disable blocking with simple commands
- **Hosts-based blocking**: Works across all browsers and applications
- **Customizable**: Add or remove sites from block list

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