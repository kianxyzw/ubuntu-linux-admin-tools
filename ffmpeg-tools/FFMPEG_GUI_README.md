# FFmpeg Image Sequence Converter GUI

A modern, user-friendly GUI application for converting image sequences to MP4 videos. Perfect for VFX professionals who need to quickly convert rendered sequences to video format.

## 🎬 Features

### Core Functionality
- **Drag-and-drop support** (advanced version)
- **Auto-detection** of file patterns and extensions
- **Multiple format support**: PNG, JPG, JPEG, EXR, TIFF, TGA
- **Professional quality settings** with CRF control
- **Real-time progress monitoring** with detailed logs
- **Background processing** (non-blocking UI)

### VFX-Optimized Settings
- **Frame rate options**: 12, 15, 23.976, 24, 25, 29.97, 30, 50, 59.94, 60 fps
- **Quality control**: CRF 15-25 (visually lossless to good quality)
- **Encoding presets**: ultrafast to veryslow
- **DaVinci-friendly output** with fast start flag
- **Auto-pattern detection** for common naming conventions

## 🚀 Quick Start

### Method 1: Use the Launcher Script
```bash
./launch_ffmpeg_gui.sh
```

### Method 2: Run Directly
```bash
python3 ffmpeg_gui_simple.py
```

### Method 3: Advanced Version (with drag-and-drop)
```bash
# Install dependencies first
pip3 install tkinterdnd2
python3 ffmpeg_gui.py
```

## 📋 Requirements

### System Requirements
- **Ubuntu 20.04+** (or other Linux distributions)
- **Python 3.6+**
- **FFmpeg** (installed and accessible in PATH)
- **tkinter** (usually included with Python)

### Installation
```bash
# Install FFmpeg
sudo apt update
sudo apt install ffmpeg

# Install Python tkinter (if not already installed)
sudo apt install python3-tk

# Install drag-and-drop support (optional)
pip3 install tkinterdnd2
```

## 🎯 How to Use

### Step 1: Select Input Folder
1. Click "Browse" next to "Input Folder"
2. Select the folder containing your image sequence
3. The app will auto-detect file patterns and extensions

### Step 2: Configure Settings
- **Frame Rate**: Choose your desired output frame rate
- **Quality (CRF)**: 18-20 for high quality, 23-25 for smaller files
- **Preset**: "slow" for good quality, "fast" for speed
- **File Pattern**: Auto-detected, but can be manually adjusted
- **File Extension**: Auto-detected from your files

### Step 3: Set Output File
1. Click "Save As" next to "Output File"
2. Choose where to save your MP4 file
3. The app auto-generates a filename based on the folder name

### Step 4: Convert
1. Click "Convert to MP4"
2. Monitor progress in the log window
3. Wait for completion notification

## 🎨 Supported File Patterns

The app automatically detects these common naming patterns:

### Numbered Sequences
- `0001.png`, `0002.png`, `0003.png` → Pattern: `%04d`
- `00001.jpg`, `00002.jpg` → Pattern: `%05d`
- `000001.exr`, `000002.exr` → Pattern: `%06d`

### Named Sequences
- `frame_0001.png`, `frame_0002.png` → Pattern: `frame_%04d`
- `render_00001.exr`, `render_00002.exr` → Pattern: `render_%05d`

## ⚙️ Advanced Settings

### Quality Settings (CRF)
- **15-17**: Visually lossless, very large files
- **18-20**: High quality, good for most content
- **21-23**: Good quality, smaller files
- **24-25**: Acceptable quality, much smaller files

### Encoding Presets
- **ultrafast**: Fastest encoding, largest files
- **superfast**: Very fast encoding
- **veryfast**: Fast encoding
- **faster**: Fast encoding
- **fast**: Fast encoding
- **medium**: Default preset
- **slow**: Better compression
- **slower**: Better compression
- **veryslow**: Best compression, slowest encoding

## 🔧 Troubleshooting

### Common Issues

#### "FFmpeg not found"
```bash
sudo apt install ffmpeg
```

#### "tkinter not available"
```bash
sudo apt install python3-tk
```

#### "No files detected"
- Check that your image files are in the selected folder
- Verify file extensions are supported (PNG, JPG, EXR, etc.)
- Ensure files follow a numbered pattern

#### "Conversion failed"
- Check the log for specific error messages
- Verify FFmpeg is properly installed
- Ensure you have write permissions for the output location

#### "Pattern not detected"
- Use the "Auto-Detect Settings" button
- Manually select the correct file pattern
- Check that your files follow a consistent naming convention

## 📁 File Structure

```
ffmpeg_gui_simple.py      # Main application (recommended)
ffmpeg_gui.py             # Advanced version with drag-and-drop
launch_ffmpeg_gui.sh      # Launcher script
requirements.txt           # Python dependencies
FFMPEG_GUI_README.md      # This file
```

## 🎬 Example Workflows

### Blender Render Sequence
1. Render sequence as PNG files: `render_0001.png` to `render_0100.png`
2. Select folder containing the PNG files
3. Auto-detection will set pattern to `render_%04d`
4. Choose 24 fps, CRF 18, preset "slow"
5. Convert to MP4

### ComfyUI Output
1. ComfyUI saves as `ComfyUI_00001.png` to `ComfyUI_00100.png`
2. Select the output folder
3. Auto-detection will set pattern to `ComfyUI_%05d`
4. Choose 24 fps, CRF 20, preset "fast"
5. Convert to MP4

### DaVinci Resolve Import
1. Convert your sequence to MP4 using this app
2. Import the MP4 into DaVinci Resolve
3. The fast start flag ensures smooth playback

## 🚀 Performance Tips

### For Large Sequences
- Use "fast" or "veryfast" preset for quicker conversion
- Use CRF 23-25 for smaller file sizes
- Consider converting in batches

### For High Quality
- Use "slow" or "slower" preset
- Use CRF 18-20 for best quality
- Use 10-bit color if needed (requires different settings)

### For Web/Sharing
- Use CRF 23-25 for good quality/size balance
- Use "fast" preset for quick conversion
- Consider 30fps for smoother motion

## 🔄 Batch Processing

For multiple sequences, you can use the command line:

```bash
# Convert all PNG sequences in a directory
for dir in */; do
    if [ -d "$dir" ]; then
        echo "Processing $dir"
        ffmpeg -framerate 24 -i "$dir/%04d.png" \
          -c:v libx264 -preset slow -crf 18 \
          -pix_fmt yuv420p -movflags +faststart \
          "${dir%/}.mp4"
    fi
done
```

## 📝 Log Output

The application provides detailed logging:
- FFmpeg command being executed
- Real-time conversion progress
- Error messages and warnings
- Completion status

## 🎯 VFX Workflow Integration

### Typical Workflow
1. **Render** your sequence from Blender/ComfyUI/etc.
2. **Convert** to MP4 using this GUI
3. **Import** into DaVinci Resolve for editing
4. **Export** final video

### Quality Settings by Use Case
- **Preview/Review**: CRF 23-25, fast preset
- **Client Review**: CRF 20-22, medium preset
- **Final Delivery**: CRF 18-20, slow preset
- **Archival**: CRF 15-17, slower preset

## 🔧 Customization

### Adding New File Extensions
Edit the `file_extension` combobox values in the code:
```python
ext_combo = ttk.Combobox(settings_frame, textvariable=self.file_extension, 
                        values=["png", "jpg", "jpeg", "exr", "tiff", "tga", "your_extension"])
```

### Adding New Patterns
Edit the `file_pattern` combobox values:
```python
pattern_combo = ttk.Combobox(settings_frame, textvariable=self.file_pattern, 
                            values=["%04d", "%05d", "%06d", "frame_%04d", "render_%05d", "your_pattern"])
```

## 📞 Support

### Getting Help
1. Check the log output for error messages
2. Verify FFmpeg is properly installed
3. Ensure file permissions are correct
4. Check that your image sequence is complete

### Common Solutions
- **Restart the application** if it becomes unresponsive
- **Check disk space** before large conversions
- **Use simpler patterns** if auto-detection fails
- **Test with a small sequence** first

---

**Happy converting!** 🎬✨

*This application is designed specifically for VFX professionals transitioning to Linux and needing efficient image sequence conversion tools.* 