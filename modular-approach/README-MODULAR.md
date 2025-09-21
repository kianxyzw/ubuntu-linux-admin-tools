# Ubuntu GNOME Setup - Modular Version

A clean, modular approach to setting up Ubuntu 24.04 GNOME with enhanced hotkeys, MMB behavior, and screenshot functionality.

## 🚀 Quick Start

```bash
# Run the complete setup
./ubuntu-unity-manager.sh install

# Test the configuration
./ubuntu-unity-manager.sh test

# Check status
./ubuntu-unity-manager.sh status
```

## ⚠️ Known Issues

### Chrome MMB Paste
**Issue**: Middle mouse button still pastes in Chrome text fields despite our fixes.

**Root Cause**: Chrome's MMB paste is hardcoded at the browser engine level and cannot be disabled through:
- Command-line flags (the commonly suggested flags don't exist)
- Chrome extensions (paste happens before JavaScript can intercept)
- Chrome policies (no working policy exists)

**Current Status**: We've implemented primary selection clearing, but Chrome's MMB paste remains active.

**Workarounds**:
1. **Use Firefox**: `about:config → middlemouse.paste → false` (100% effective)
2. **Be careful with MMB**: Avoid middle-clicking in text fields
3. **Clear selection manually**: Select nothing before using MMB

**Research**: Extensive testing shows this is a known limitation of Chrome on Linux that affects all users.

## 📁 Structure

```
├── ubuntu-unity-manager.sh          # Main control script
├── setup-ubuntu-unity-modular.sh    # Modular setup script
├── test-setup.sh                    # Testing script
└── modules/                         # Individual modules
    ├── mmb-handler.sh               # MMB behavior fixes
    ├── hotkeys.sh                   # Windows-style hotkeys
    ├── screenshots.sh               # Enhanced screenshots
    ├── chrome-setup.sh              # Chrome MMB support
    └── autostart.sh                 # Startup configuration
```

## 🎯 Features

### Hotkeys
- **Win + E**: Open Files
- **Win + D**: Show Desktop
- **Alt + Shift + S**: Region Screenshot
- **Win + L**: Lock Screen
- **Win + Tab**: Switch Applications
- **Win + Up/Down**: Maximize/Unmaximize

### MMB (Middle Mouse Button)
- **System-wide MMB paste disabled**: Prevents accidental pasting in most applications
- **Chrome MMB paste**: Still active (Chrome limitation - see Known Issues)
- **Enhanced scrolling**: Smooth scrolling with imwheel
- **Smart context handling**: MMB works properly for new tabs and autoscroll

### Screenshots
- **Smart screenshot tool**: Multiple capture modes
- **Automatic clipboard copy**: Easy pasting with Ctrl+V
- **Organized storage**: Saved to ~/Pictures/Screenshots/

### Chrome Integration
- **Enhanced MMB support**: New tab + scrolling behavior optimized
- **Optimized flags**: Smooth scrolling and autoscroll features
- **MMB paste limitation**: Cannot be disabled (Chrome engine limitation)

## 🛠️ Management Commands

```bash
# Install everything
./ubuntu-unity-manager.sh install

# Test configuration
./ubuntu-unity-manager.sh test

# Restart services
./ubuntu-unity-manager.sh restart

# Check status
./ubuntu-unity-manager.sh status

# Create backup
./ubuntu-unity-manager.sh backup

# Reset hotkeys
./ubuntu-unity-manager.sh reset

# Show help
./ubuntu-unity-manager.sh help
```

## 🔧 Individual Module Testing

```bash
# Test specific components
./test-setup.sh mmb        # Test MMB behavior
./test-setup.sh hotkeys    # Test hotkeys
./test-setup.sh screenshots # Test screenshots
./test-setup.sh chrome     # Test Chrome setup
./test-setup.sh autostart  # Test autostart
```

## 📝 Key Improvements

1. **Modular Design**: Each feature in its own module
2. **Proper Error Handling**: Robust error checking and logging
3. **Backup System**: Automatic backup of existing configs
4. **Dynamic Hardware Detection**: No hardcoded device names
5. **Comprehensive Testing**: Individual and integrated tests
6. **Clean Management**: Simple control interface

## 🔄 Troubleshooting

### MMB Issues
```bash
# Restart MMB services
./ubuntu-unity-manager.sh restart

# Check MMB status
./test-setup.sh mmb
```

### Hotkey Issues
```bash
# Reset and reconfigure hotkeys
./ubuntu-unity-manager.sh reset
./ubuntu-unity-manager.sh install
```

### Service Issues
```bash
# Check what's running
./ubuntu-unity-manager.sh status

# Restart everything
./ubuntu-unity-manager.sh restart
```

## 📋 Requirements

- Ubuntu 24.04 with GNOME desktop (default)
- Required packages: `xclip`, `xdotool`, `xinput` (auto-installed)
- Optional: Google Chrome (with MMB paste limitation)
- Alternative: Firefox (full MMB paste control available)

## 🎉 What's Fixed

- ✅ **Modular architecture** - Easy to maintain and extend
- ✅ **Proper error handling** - Robust and reliable
- ✅ **Dynamic hardware detection** - Works with any mouse
- ✅ **Backup system** - Safe configuration changes
- ✅ **Comprehensive testing** - Verify everything works
- ✅ **Clean management interface** - Simple control commands
- ✅ **Fixed systemd service** - Proper service configuration
- ✅ **MMB behavior improved** - System-wide paste disabled (Chrome limitation remains)

This modular approach makes the setup much more maintainable, testable, and reliable!