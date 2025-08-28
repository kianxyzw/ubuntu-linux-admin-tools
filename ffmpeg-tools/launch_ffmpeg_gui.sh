#!/bin/bash

# FFmpeg Image Sequence Converter Launcher
# This script launches the FFmpeg GUI application

echo "Starting FFmpeg Image Sequence Converter..."

# Check if Python 3 is available
if ! command -v python3 &> /dev/null; then
    echo "Error: Python 3 is not installed"
    echo "Please install Python 3 and try again"
    exit 1
fi

# Check if FFmpeg is available
if ! command -v ffmpeg &> /dev/null; then
    echo "Error: FFmpeg is not installed"
    echo "Please install FFmpeg first:"
    echo "sudo apt install ffmpeg"
    exit 1
fi

# Check if tkinter is available
python3 -c "import tkinter" 2>/dev/null
if [ $? -ne 0 ]; then
    echo "Error: tkinter is not available"
    echo "Please install tkinter:"
    echo "sudo apt install python3-tk"
    exit 1
fi

# Install tkinterdnd2 for drag-and-drop support
echo "Installing drag-and-drop support..."
pip3 install tkinterdnd2 --quiet

# Check if tkinterdnd2 is now available
python3 -c "import tkinterdnd2" 2>/dev/null
if [ $? -eq 0 ]; then
    echo "Drag-and-drop support installed successfully!"
    echo ""
    echo "Choose version:"
    echo "1. Simple version (recommended)"
    echo "2. Advanced version with drag-and-drop"
    echo ""
    read -p "Enter choice (1 or 2): " choice
    
    case $choice in
        1)
            echo "Launching Simple Version..."
            python3 ffmpeg_gui_simple.py
            ;;
        2)
            echo "Launching Advanced Version with Drag-and-Drop..."
            python3 ffmpeg_gui.py
            ;;
        *)
            echo "Invalid choice, launching Simple Version..."
            python3 ffmpeg_gui_simple.py
            ;;
    esac
else
    echo "Note: Could not install drag-and-drop support, using simple version"
    echo "Launching FFmpeg Image Sequence Converter (Simple Version)..."
    python3 ffmpeg_gui_simple.py
fi 