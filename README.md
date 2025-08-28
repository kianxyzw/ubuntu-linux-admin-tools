# Ubuntu Linux Admin Tools & Productivity Scripts

A clean, organized collection of scripts and tools for Ubuntu Linux administration, productivity enhancement, and system customization.

## 🚀 **Quick Start (Unity Desktop)**

### **One Script Does Everything!**
```bash
cd current-hotkeys
./ubuntu-unity-complete.sh
```

This single script sets up:
- **Windows-style hotkeys** (Win+E, Win+D, Alt+Shift+S, etc.)
- **MMB (Middle Mouse Button)** functionality for browsers (like Windows)
- **MMB autoscroll** when held down (like Windows)
- **Enhanced screenshot tools** with region selection + clipboard support
- **Enhanced Chrome launcher** with proper MMB flags

## 📁 **Project Structure**

```
sandbox_linux_admin/
├── current-hotkeys/          # ✅ Essential hotkey scripts
│   ├── ubuntu-unity-complete.sh    # 🎯 THE ONE SCRIPT
│   ├── test-mmb-functionality.sh   # 🧪 MMB testing
│   └── README.md                    # 📖 Directory guide
├── ffmpeg-tools/             # 🎬 FFmpeg GUI tools
│   ├── ffmpeg_gui.py              # 🖥️  Main GUI
│   ├── launch_ffmpeg_gui.sh       # 🚀 Launcher
│   └── FFMPEG_README.md           # 📖 FFmpeg guide
├── README.md                  # 📚 Main project guide
└── FINAL_SUMMARY.md          # 📋 Project summary
```

## 🎯 **Core Features**

### **Hotkeys (Windows-style)**
| Hotkey | Action | Description |
|--------|--------|-------------|
| **Win + E** | Open Files | Launches Nautilus file manager |
| **Win + D** | Show Desktop | Minimizes all windows |
| **Alt + Shift + S** | Region Screenshot | Interactive area selection |
| **Win + L** | Lock Screen | Quick screen lock |
| **Win + Tab** | Switch Apps | Application switcher |
| **Win + Up/Down** | Maximize/Unmaximize | Window management |

### **MMB (Middle Mouse Button)**
- **New tabs**: Middle-click links to open in new tabs
- **Smooth scrolling**: Enhanced mouse wheel scrolling
- **Browser integration**: Works with Chrome, Firefox, etc.

### **Screenshots**
- **Smart Screenshot**: Multi-option screenshot tool
- **Region selection**: Interactive area selection
- **Timestamped files**: Organized screenshot management

## 📁 **Directory Details**

### **`current-hotkeys/` - Active Scripts** ⭐
- `ubuntu-unity-complete.sh` - **THE ONE SCRIPT** that does everything
- `keyboard-scroll-solution.sh` - Keyboard scrolling fix (if needed)
- `setup-screenshot-hotkey.sh` - Alternative screenshot setup (if needed)
- `README.md` - Directory-specific guide

### **`ffmpeg-tools/` - Media Processing**
- `ffmpeg_gui.py` - Advanced FFmpeg GUI tool
- `ffmpeg_gui_simple.py` - Simple FFmpeg interface
- `launch_ffmpeg_gui.sh` - Launch script for FFmpeg tools
- `FFMPEG_README.md` - FFmpeg tool documentation

### **`docs/` - Documentation**
- `README.md` - This file
- `UBUNTU_HOTKEYS_GUIDE.md` - Comprehensive hotkey guide
- `CHROME_MMB_UBUNTU_GUIDE.md` - Chrome MMB setup guide
- `DAVINCI_MP4_FIX.md` - DaVinci Resolve MP4 fix guide

### **`deprecated-scripts/` - Legacy Scripts**
- Old MMB setup scripts (kept for reference)
- Previous Chrome MMB attempts
- Legacy testing scripts

### **`media-files/` - Sample Media**
- Sample MP4 files for testing FFmpeg tools

## 🛠️ **Installation**

### **Prerequisites**
```bash
# Update system
sudo apt update

# Install essential packages
sudo apt install -y xdotool xbindkeys imwheel gnome-screenshot
```

### **Quick Setup**
```bash
# Navigate to current-hotkeys directory
cd current-hotkeys

# Make scripts executable
chmod +x *.sh

# Run the ONE script that does everything
./ubuntu-unity-complete.sh
```

## 🔧 **Configuration**

### **Custom Hotkeys**
Add your own shortcuts in **Settings > Keyboard > Custom Shortcuts**:

1. Click the **+** button
2. Name: `Custom Action`
3. Command: `/path/to/your/script`
4. Shortcut: Press your desired key combination

### **GNOME Extensions**
```bash
# Install GNOME Extension Manager
sudo apt install gnome-shell-extension-manager

# Popular extensions
sudo apt install gnome-shell-extensions
```

## 🧪 **Testing**

### **Quick Test**
```bash
cd current-hotkeys
./ubuntu-unity-complete.sh
```

### **Manual Testing**
1. **Hotkeys**: Try Win+E, Win+D, Alt+Shift+S
2. **MMB**: Middle-click links in browsers
3. **Screenshots**: Use Alt+Shift+S for region selection

### **Troubleshooting**
```bash
# Check if services are running
ps aux | grep xbindkeys
ps aux | grep imwheel

# Restart MMB if needed
~/.local/bin/ubuntu-unity-complete

# Reset everything
dconf reset /org/gnome/settings-daemon/plugins/media-keys/custom-keybindings
```

## 🔄 **Maintenance**

### **Update Scripts**
```bash
# Pull latest changes
git pull origin main

# Re-run setup
cd current-hotkeys
./ubuntu-unity-complete.sh
```

### **Backup Configuration**
```bash
# Backup current settings
dconf dump / > ~/ubuntu-settings-backup.dconf

# Restore settings
dconf load / < ~/ubuntu-settings-backup.dconf
```

## 🎯 **Use Cases**

### **For Windows Users**
- Familiar hotkeys (Win+E, Win+D)
- Middle mouse button functionality
- Enhanced productivity tools

### **For Power Users**
- Customizable hotkeys
- Advanced mouse configurations
- System automation scripts

### **For Developers**
- Quick file access
- Efficient window management
- Screenshot tools for documentation

## 🤝 **Community**

### **Based on Ubuntu Community Feedback**
- **Win + E for Files**: "Essential for Windows users switching to Ubuntu"
- **Win + D for Desktop**: "Makes me feel at home on Linux"
- **Alt + Shift + S**: "Better than Windows Snipping Tool"
- **MMB for tabs**: "Can't live without it now"

### **Resources**
- [Ask Ubuntu](https://askubuntu.com/) - Stack Exchange community
- [Ubuntu Forums](https://ubuntuforums.org/) - Official forums
- [r/Ubuntu](https://reddit.com/r/Ubuntu) - Reddit community

## 🚨 **Troubleshooting**

### **Common Issues**

#### **Hotkeys Not Working**
1. Check desktop environment: `echo $XDG_CURRENT_DESKTOP`
2. Verify dconf settings: `dconf list /org/gnome/desktop/wm/keybindings/`
3. Restart Unity: `unity --replace &`

#### **MMB Not Working**
1. Check if xbindkeys is running: `ps aux | grep xbindkeys`
2. Restart MMB: `~/.local/bin/ubuntu-unity-complete`
3. Test button detection: `xev | grep -A 5 ButtonPress`

#### **Screenshots Not Working**
1. Check permissions: `ls -la ~/.local/bin/smart-screenshot`
2. Test manually: `~/.local/bin/smart-screenshot -h`
3. Verify directory: `ls -la ~/Pictures/Screenshots/`

### **Reset Everything**
```bash
dconf reset /org/gnome/settings-daemon/plugins/media-keys/custom-keybindings
dconf reset /org/gnome/desktop/wm/keybindings/show-desktop
dconf reset /org/gnome/desktop/wm/keybindings/switch-applications
dconf reset /org/gnome/desktop/wm/keybindings/maximize
dconf reset /org/gnome/desktop/wm/keybindings/unmaximize
```

## 🔮 **Future Enhancements**

- [ ] Custom hotkey profiles
- [ ] Cloud sync for settings
- [ ] Integration with more desktop environments
- [ ] Advanced window management
- [ ] Touchpad gesture support

## 📄 **License**

This project is open source and available under the MIT License.

## 🤝 **Contributing**

Contributions are welcome! Please feel free to submit pull requests or open issues for bugs and feature requests.

---

## 🎯 **Mission Accomplished!**

Your Ubuntu system now has:
- **Clean, organized project structure** 📁
- **ONE script that does everything** 🎯
- **Working Windows-style hotkeys** 🖱️
- **Unity-compatible functionality** ✅
- **Enhanced screenshot tools** 📸
- **Professional documentation** 📚

**Happy Ubuntu-ing! 🐧✨**

*This collection is based on real Ubuntu community feedback and best practices.* 