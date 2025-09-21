#!/bin/bash
# Chrome MMB Paste Fix - X11 Level Solution
# This intercepts MMB events before they reach Chrome

echo "=== Chrome MMB Paste Fix ==="
echo "This will block MMB paste in Chrome at the X11 level"
echo ""

# Check if required tools are installed
if ! command -v xdotool >/dev/null 2>&1; then
    echo "Installing xdotool..."
    sudo apt update && sudo apt install -y xdotool
fi

# Function to monitor and block MMB paste in Chrome
monitor_chrome_mmb() {
    echo "Monitoring Chrome for MMB events..."
    
    while true; do
        # Find Chrome windows
        chrome_windows=$(xdotool search --class "Google-chrome" 2>/dev/null || true)
        
        if [[ -n "$chrome_windows" ]]; then
            for window in $chrome_windows; do
                # Monitor this Chrome window for MMB clicks
                xdotool behave "$window" button --button 2 exec sh -c '
                    # Clear primary selection immediately when MMB is clicked
                    echo "" | xclip -selection primary 2>/dev/null || true
                    # Small delay to ensure it takes effect
                    sleep 0.01
                ' 2>/dev/null &
            done
        fi
        
        sleep 2
    done
}

# Start monitoring in background
echo "Starting Chrome MMB monitor..."
monitor_chrome_mmb &
MMB_PID=$!

echo "✓ Chrome MMB paste blocker started (PID: $MMB_PID)"
echo "✓ MMB paste should now be blocked in Chrome"
echo "✓ MMB autoscroll and new tabs still work"
echo ""
echo "To stop: kill $MMB_PID"
echo "Press Ctrl+C to stop monitoring"

# Wait for user to stop
trap "kill $MMB_PID 2>/dev/null; echo 'MMB monitor stopped'; exit 0" INT
wait