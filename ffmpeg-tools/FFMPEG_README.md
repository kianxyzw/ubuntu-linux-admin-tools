# FFmpeg Guide for VFX Professionals

A comprehensive guide for using FFmpeg in VFX workflows, focusing on image sequence processing and video conversion.

## 🎬 Quick Start

### Install FFmpeg
```bash
# Install FFmpeg and codecs
sudo apt update
sudo apt install ffmpeg
sudo apt install ubuntu-restricted-extras  # Additional codecs
```

### Verify Installation
```bash
ffmpeg -version
```

## 📸 Image Sequence to MP4

### Basic Image Sequence to MP4
```bash
# Convert numbered image sequence to MP4
ffmpeg -framerate 24 -i "sequence_%04d.png" -c:v libx264 -pix_fmt yuv420p output.mp4

# For different naming patterns
ffmpeg -framerate 24 -i "render_%05d.exr" -c:v libx264 -pix_fmt yuv420p output.mp4
ffmpeg -framerate 30 -i "frame_%06d.jpg" -c:v libx264 -pix_fmt yuv420p output.mp4
```

### High Quality Settings
```bash
# High quality with specific bitrate
ffmpeg -framerate 24 -i "sequence_%04d.png" \
  -c:v libx264 -preset slow -crf 18 \
  -pix_fmt yuv420p -movflags +faststart \
  output_high_quality.mp4
```

### ProRes Output (for editing)
```bash
# Convert to ProRes for DaVinci Resolve
ffmpeg -framerate 24 -i "sequence_%04d.exr" \
  -c:v prores_ks -profile:v 3 \
  -pix_fmt yuv422p10le \
  output_prores.mov
```

## 🎨 Common VFX Workflows

### EXR Sequence Processing
```bash
# EXR to MP4 with HDR handling
ffmpeg -framerate 24 -i "render_%04d.exr" \
  -c:v libx264 -preset slow -crf 18 \
  -pix_fmt yuv420p10le \
  -vf "zscale=t=linear:npl=100,format=gbrp,zscale=p=bt709:t=bt709:m=bt709:r=tv,format=yuv420p" \
  output_hdr.mp4
```

### PNG Sequence with Alpha Channel
```bash
# PNG with alpha to MP4 with transparency
ffmpeg -framerate 24 -i "sequence_%04d.png" \
  -c:v libx264 -preset slow -crf 18 \
  -pix_fmt yuv420p \
  -vf "format=yuva420p" \
  output_with_alpha.mp4
```

### JPG Sequence (Fast Processing)
```bash
# JPG sequence to MP4 (faster processing)
ffmpeg -framerate 24 -i "sequence_%04d.jpg" \
  -c:v libx264 -preset fast -crf 23 \
  -pix_fmt yuv420p \
  output_fast.mp4
```

## ⚡ Performance Optimization

### GPU Acceleration (NVIDIA)
```bash
# Use NVIDIA GPU acceleration
ffmpeg -framerate 24 -i "sequence_%04d.png" \
  -c:v h264_nvenc -preset slow -rc vbr -cq 18 \
  -b:v 50M -maxrate 100M -bufsize 100M \
  -pix_fmt yuv420p \
  output_gpu.mp4
```

### Multi-threaded Processing
```bash
# Use all CPU cores
ffmpeg -framerate 24 -i "sequence_%04d.png" \
  -c:v libx264 -preset slow -crf 18 \
  -threads 0 -pix_fmt yuv420p \
  output_multithread.mp4
```

## 🎯 Frame Rate Conversion

### Different Input/Output Frame Rates
```bash
# Convert 30fps sequence to 24fps
ffmpeg -framerate 30 -i "sequence_%04d.png" \
  -r 24 -c:v libx264 -preset slow -crf 18 \
  -pix_fmt yuv420p \
  output_24fps.mp4

# Convert 60fps to 25fps (PAL)
ffmpeg -framerate 60 -i "sequence_%04d.png" \
  -r 25 -c:v libx264 -preset slow -crf 18 \
  -pix_fmt yuv420p \
  output_25fps.mp4
```

## 📏 Resolution and Scaling

### Scale Down for Web
```bash
# Scale 4K sequence to 1080p
ffmpeg -framerate 24 -i "sequence_%04d.png" \
  -vf "scale=1920:1080:flags=lanczos" \
  -c:v libx264 -preset slow -crf 23 \
  -pix_fmt yuv420p \
  output_1080p.mp4
```

### Scale Up (with quality)
```bash
# Scale 1080p to 4K
ffmpeg -framerate 24 -i "sequence_%04d.png" \
  -vf "scale=3840:2160:flags=lanczos" \
  -c:v libx264 -preset slow -crf 18 \
  -pix_fmt yuv420p \
  output_4k.mp4
```

## 🎨 Color Space and Gamma

### Linear to sRGB Conversion
```bash
# Convert linear EXR to sRGB MP4
ffmpeg -framerate 24 -i "sequence_%04d.exr" \
  -vf "zscale=t=linear:npl=100,format=gbrp,zscale=p=bt709:t=bt709:m=bt709:r=tv,format=yuv420p" \
  -c:v libx264 -preset slow -crf 18 \
  output_srgb.mp4
```

### HDR to SDR Conversion
```bash
# HDR EXR to SDR MP4
ffmpeg -framerate 24 -i "sequence_%04d.exr" \
  -vf "zscale=t=linear:npl=100,format=gbrp,zscale=p=bt709:t=bt709:m=bt709:r=tv,format=yuv420p" \
  -c:v libx264 -preset slow -crf 18 \
  -pix_fmt yuv420p \
  output_sdr.mp4
```

## 🔧 Advanced Filters

### Add Motion Blur Effect
```bash
# Add motion blur to sequence
ffmpeg -framerate 24 -i "sequence_%04d.png" \
  -vf "tmix=frames=3:weights='0.2 0.6 0.2'" \
  -c:v libx264 -preset slow -crf 18 \
  -pix_fmt yuv420p \
  output_motion_blur.mp4
```

### Add Film Grain
```bash
# Add film grain effect
ffmpeg -framerate 24 -i "sequence_%04d.png" \
  -vf "noise=c0s=10:c0f=t" \
  -c:v libx264 -preset slow -crf 18 \
  -pix_fmt yuv420p \
  output_with_grain.mp4
```

## 📊 Quality Settings Reference

### CRF (Constant Rate Factor) Values
- **18-20**: Visually lossless, high quality
- **21-23**: High quality, good for most content
- **24-26**: Good quality, smaller file size
- **27-29**: Acceptable quality, smaller file size
- **30+**: Lower quality, very small file size

### Preset Options
- **ultrafast**: Fastest encoding, largest file
- **superfast**: Very fast encoding
- **veryfast**: Fast encoding
- **faster**: Fast encoding
- **fast**: Fast encoding
- **medium**: Default preset
- **slow**: Better compression
- **slower**: Better compression
- **veryslow**: Best compression, slowest encoding

## 🎬 Common VFX Formats

### Input Formats
- **PNG**: Lossless, supports alpha
- **EXR**: HDR, high dynamic range
- **JPG**: Lossy, smaller file size
- **TIFF**: High quality, supports alpha
- **TGA**: Legacy format, supports alpha

### Output Formats
- **MP4**: Web compatible, good compression
- **MOV**: Apple ecosystem, ProRes support
- **AVI**: Legacy Windows format
- **MKV**: Open container, many codecs

## 🚀 Batch Processing Scripts

### Convert Multiple Sequences
```bash
#!/bin/bash
# Convert all PNG sequences in current directory
for dir in */; do
    if [ -d "$dir" ]; then
        echo "Processing $dir"
        ffmpeg -framerate 24 -i "$dir/sequence_%04d.png" \
          -c:v libx264 -preset slow -crf 18 \
          -pix_fmt yuv420p \
          "${dir%/}.mp4"
    fi./launch_ffmpeg_gui.sh

done
```

### Monitor Progress
```bash
# Show progress during conversion
ffmpeg -framerate 24 -i "sequence_%04d.png" \
  -c:v libx264 -preset slow -crf 18 \
  -pix_fmt yuv420p \
  -progress pipe:1 \
  output.mp4 2>&1 | grep -E "(frame|fps|size|time|bitrate)"
```

## 🔍 Troubleshooting

### Common Issues

#### "Invalid data found when processing input"
```bash
# Check if sequence is complete
ls sequence_*.png | wc -l
# Ensure all frames exist and are numbered correctly
```

#### "No such file or directory"
```bash
# Check file naming pattern
ls sequence_*.png | head -5
# Adjust pattern in ffmpeg command
```

#### Poor Quality Output
```bash
# Use higher quality settings
ffmpeg -framerate 24 -i "sequence_%04d.png" \
  -c:v libx264 -preset slow -crf 18 \
  -pix_fmt yuv420p \
  output_high_quality.mp4
```

#### Large File Size
```bash
# Use higher CRF value for smaller files
ffmpeg -framerate 24 -i "sequence_%04d.png" \
  -c:v libx264 -preset slow -crf 23 \
  -pix_fmt yuv420p \
  output_smaller.mp4
```

## 📝 Quick Reference Commands

### Most Common Commands
```bash
# Basic PNG sequence to MP4
ffmpeg -framerate 24 -i "sequence_%04d.png" -c:v libx264 -pix_fmt yuv420p output.mp4

# High quality EXR sequence
ffmpeg -framerate 24 -i "sequence_%04d.exr" -c:v libx264 -preset slow -crf 18 -pix_fmt yuv420p output.mp4

# GPU accelerated (NVIDIA)
ffmpeg -framerate 24 -i "sequence_%04d.png" -c:v h264_nvenc -preset slow -rc vbr -cq 18 -pix_fmt yuv420p output.mp4

# Scale to 1080p
ffmpeg -framerate 24 -i "sequence_%04d.png" -vf "scale=1920:1080" -c:v libx264 -pix_fmt yuv420p output.mp4
```

## 🎯 Tips for VFX Workflows

1. **Always use consistent frame rates** across your pipeline
2. **Test with a small sequence first** before processing large renders
3. **Keep original sequences** as backup
4. **Use descriptive output names** with quality indicators
5. **Monitor disk space** during large conversions
6. **Use GPU acceleration** when available for faster processing
7. **Consider file formats** based on your editing software requirements

---

**Happy converting!** 🎬✨ 