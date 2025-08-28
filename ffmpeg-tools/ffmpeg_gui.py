#!/usr/bin/env python3
"""
FFmpeg Image Sequence to MP4 Converter
A drag-and-drop GUI application for VFX professionals
"""

import tkinter as tk
from tkinter import ttk, filedialog, messagebox
import os
import subprocess
import threading
import re
from pathlib import Path
import json

# Try to import tkinterdnd2 for drag-and-drop support
try:
    import tkinterdnd2 as tkdnd
    DND_AVAILABLE = True
except ImportError:
    DND_AVAILABLE = False
    print("Warning: tkinterdnd2 not available. Drag-and-drop will be disabled.")

class FFmpegConverterGUI:
    def __init__(self, root):
        self.root = root
        self.root.title("FFmpeg Image Sequence Converter")
        self.root.geometry("800x600")
        self.root.configure(bg='#2b2b2b')
        
        # Style configuration
        self.style = ttk.Style()
        self.style.theme_use('clam')
        self.style.configure('TFrame', background='#2b2b2b')
        self.style.configure('TLabel', background='#2b2b2b', foreground='white')
        self.style.configure('TButton', background='#4a4a4a', foreground='white')
        
        # Variables
        self.input_folder = tk.StringVar()
        self.output_file = tk.StringVar()
        self.frame_rate = tk.StringVar(value="24")
        self.quality = tk.StringVar(value="18")
        self.preset = tk.StringVar(value="slow")
        self.file_pattern = tk.StringVar(value="%04d")
        self.file_extension = tk.StringVar(value="png")
        self.is_processing = False
        
        self.setup_ui()
        if DND_AVAILABLE:
            self.setup_drag_drop()
        else:
            # Add a note about drag-and-drop not being available
            self.add_dnd_note()
        
    def add_dnd_note(self):
        """Add a note about drag-and-drop not being available"""
        note_label = tk.Label(self.root, text="Note: Drag-and-drop not available. Use 'Browse' button instead.", 
                             bg='#2b2b2b', fg='#ff9800', font=("Arial", 9))
        note_label.place(relx=0.5, rely=0.95, anchor='center')
        
    def setup_ui(self):
        # Main frame
        main_frame = ttk.Frame(self.root, padding="20")
        main_frame.grid(row=0, column=0, sticky=(tk.W, tk.E, tk.N, tk.S))
        
        # Configure grid weights
        self.root.columnconfigure(0, weight=1)
        self.root.rowconfigure(0, weight=1)
        main_frame.columnconfigure(1, weight=1)
        
        # Title
        title_label = tk.Label(main_frame, text="FFmpeg Image Sequence Converter", 
                              font=("Arial", 16, "bold"), bg='#2b2b2b', fg='white')
        title_label.grid(row=0, column=0, columnspan=3, pady=(0, 20))
        
        # Instructions
        instructions = tk.Label(main_frame, text="Select a folder containing image sequence files (PNG, JPG, EXR, etc.)", 
                               bg='#2b2b2b', fg='#cccccc', font=("Arial", 10))
        instructions.grid(row=1, column=0, columnspan=3, pady=(0, 20))
        
        # Input folder selection
        tk.Label(main_frame, text="Input Folder:", bg='#2b2b2b', fg='white').grid(row=2, column=0, sticky=tk.W, pady=5)
        
        input_frame = ttk.Frame(main_frame)
        input_frame.grid(row=2, column=1, columnspan=2, sticky=(tk.W, tk.E), pady=5)
        input_frame.columnconfigure(0, weight=1)
        
        self.input_entry = tk.Entry(input_frame, textvariable=self.input_folder, bg='#3b3b3b', fg='white', insertbackground='white')
        self.input_entry.grid(row=0, column=0, sticky=(tk.W, tk.E), padx=(0, 10))
        
        browse_btn = tk.Button(input_frame, text="Browse", command=self.browse_input_folder, 
                              bg='#4a4a4a', fg='white', relief=tk.FLAT)
        browse_btn.grid(row=0, column=1)
        
        # Output file selection
        tk.Label(main_frame, text="Output File:", bg='#2b2b2b', fg='white').grid(row=3, column=0, sticky=tk.W, pady=5)
        
        output_frame = ttk.Frame(main_frame)
        output_frame.grid(row=3, column=1, columnspan=2, sticky=(tk.W, tk.E), pady=5)
        output_frame.columnconfigure(0, weight=1)
        
        self.output_entry = tk.Entry(output_frame, textvariable=self.output_file, bg='#3b3b3b', fg='white', insertbackground='white')
        self.output_entry.grid(row=0, column=0, sticky=(tk.W, tk.E), padx=(0, 10))
        
        save_btn = tk.Button(output_frame, text="Save As", command=self.browse_output_file, 
                            bg='#4a4a4a', fg='white', relief=tk.FLAT)
        save_btn.grid(row=0, column=1)
        
        # Settings frame
        settings_frame = ttk.LabelFrame(main_frame, text="Conversion Settings", padding="10")
        settings_frame.grid(row=4, column=0, columnspan=3, sticky=(tk.W, tk.E), pady=20)
        settings_frame.columnconfigure(1, weight=1)
        
        # Frame rate
        tk.Label(settings_frame, text="Frame Rate:", bg='#2b2b2b', fg='white').grid(row=0, column=0, sticky=tk.W, pady=5)
        frame_rate_combo = ttk.Combobox(settings_frame, textvariable=self.frame_rate, 
                                       values=["12", "15", "23.976", "24", "25", "29.97", "30", "50", "59.94", "60"])
        frame_rate_combo.grid(row=0, column=1, sticky=(tk.W, tk.E), padx=(10, 0), pady=5)
        
        # Quality
        tk.Label(settings_frame, text="Quality (CRF):", bg='#2b2b2b', fg='white').grid(row=1, column=0, sticky=tk.W, pady=5)
        quality_combo = ttk.Combobox(settings_frame, textvariable=self.quality, 
                                    values=["15", "16", "17", "18", "19", "20", "21", "22", "23", "24", "25"])
        quality_combo.grid(row=1, column=1, sticky=(tk.W, tk.E), padx=(10, 0), pady=5)
        
        # Preset
        tk.Label(settings_frame, text="Preset:", bg='#2b2b2b', fg='white').grid(row=2, column=0, sticky=tk.W, pady=5)
        preset_combo = ttk.Combobox(settings_frame, textvariable=self.preset, 
                                   values=["ultrafast", "superfast", "veryfast", "faster", "fast", "medium", "slow", "slower", "veryslow"])
        preset_combo.grid(row=2, column=1, sticky=(tk.W, tk.E), padx=(10, 0), pady=5)
        
        # File pattern
        tk.Label(settings_frame, text="File Pattern:", bg='#2b2b2b', fg='white').grid(row=3, column=0, sticky=tk.W, pady=5)
        pattern_combo = ttk.Combobox(settings_frame, textvariable=self.file_pattern, 
                                    values=["%04d", "%05d", "%06d", "frame_%04d", "render_%05d"])
        pattern_combo.grid(row=3, column=1, sticky=(tk.W, tk.E), padx=(10, 0), pady=5)
        
        # File extension
        tk.Label(settings_frame, text="File Extension:", bg='#2b2b2b', fg='white').grid(row=4, column=0, sticky=tk.W, pady=5)
        ext_combo = ttk.Combobox(settings_frame, textvariable=self.file_extension, 
                                values=["png", "jpg", "jpeg", "exr", "tiff", "tga"])
        ext_combo.grid(row=4, column=1, sticky=(tk.W, tk.E), padx=(10, 0), pady=5)
        
        # Auto-detect button
        detect_btn = tk.Button(settings_frame, text="Auto-Detect Settings", command=self.auto_detect_from_folder, 
                              bg='#2196F3', fg='white', relief=tk.FLAT)
        detect_btn.grid(row=5, column=0, columnspan=2, pady=10)
        
        # Progress frame
        progress_frame = ttk.LabelFrame(main_frame, text="Progress", padding="10")
        progress_frame.grid(row=5, column=0, columnspan=3, sticky=(tk.W, tk.E), pady=20)
        progress_frame.columnconfigure(0, weight=1)
        
        self.progress_bar = ttk.Progressbar(progress_frame, mode='indeterminate')
        self.progress_bar.grid(row=0, column=0, sticky=(tk.W, tk.E), pady=5)
        
        self.status_label = tk.Label(progress_frame, text="Ready to convert", bg='#2b2b2b', fg='white')
        self.status_label.grid(row=1, column=0, sticky=tk.W, pady=5)
        
        # Buttons frame
        button_frame = ttk.Frame(main_frame)
        button_frame.grid(row=6, column=0, columnspan=3, pady=20)
        
        self.convert_btn = tk.Button(button_frame, text="Convert to MP4", command=self.start_conversion, 
                                    bg='#4CAF50', fg='white', relief=tk.FLAT, font=("Arial", 12, "bold"))
        self.convert_btn.grid(row=0, column=0, padx=10)
        
        self.stop_btn = tk.Button(button_frame, text="Stop", command=self.stop_conversion, 
                                 bg='#f44336', fg='white', relief=tk.FLAT, state=tk.DISABLED)
        self.stop_btn.grid(row=0, column=1, padx=10)
        
        # Log frame
        log_frame = ttk.LabelFrame(main_frame, text="Log", padding="10")
        log_frame.grid(row=7, column=0, columnspan=3, sticky=(tk.W, tk.E, tk.N, tk.S), pady=10)
        log_frame.columnconfigure(0, weight=1)
        log_frame.rowconfigure(0, weight=1)
        
        self.log_text = tk.Text(log_frame, height=8, bg='#1e1e1e', fg='#ffffff', insertbackground='white')
        self.log_text.grid(row=0, column=0, sticky=(tk.W, tk.E, tk.N, tk.S))
        
        scrollbar = ttk.Scrollbar(log_frame, orient=tk.VERTICAL, command=self.log_text.yview)
        scrollbar.grid(row=0, column=1, sticky=(tk.N, tk.S))
        self.log_text.configure(yscrollcommand=scrollbar.set)
        
    def setup_drag_drop(self):
        """Setup drag-and-drop functionality"""
        try:
            self.root.drop_target_register(tkdnd.DND_FILES)
            self.root.dnd_bind('<<Drop>>', self.on_drop)
        except Exception as e:
            self.log_message(f"Drag-and-drop setup failed: {e}")
        
    def on_drop(self, event):
        """Handle file/folder drop events"""
        try:
            files = event.data
            if files:
                # Get the first file/folder dropped
                path = files.split()[0]
                if os.path.isdir(path):
                    self.input_folder.set(path)
                    self.auto_detect_settings(path)
                    self.auto_generate_output(path)
                    self.log_message(f"Dropped folder: {path}")
        except Exception as e:
            self.log_message(f"Drop handling error: {e}")
    
    def auto_detect_from_folder(self):
        """Auto-detect settings from the selected folder"""
        folder = self.input_folder.get()
        if not folder or not os.path.isdir(folder):
            messagebox.showwarning("Warning", "Please select an input folder first")
            return
            
        self.auto_detect_settings(folder)
        self.auto_generate_output(folder)
        self.log_message("Settings auto-detected from folder")
    
    def auto_detect_settings(self, folder_path):
        """Auto-detect file pattern and extension from the folder"""
        try:
            files = [f for f in os.listdir(folder_path) if f.lower().endswith(('.png', '.jpg', '.jpeg', '.exr', '.tiff', '.tga'))]
            if files:
                # Sort files to get the first one
                files.sort()
                first_file = files[0]
                
                # Detect extension
                ext = os.path.splitext(first_file)[1].lower().lstrip('.')
                if ext in ['png', 'jpg', 'jpeg', 'exr', 'tiff', 'tga']:
                    self.file_extension.set(ext)
                
                # Try to detect pattern
                name_without_ext = os.path.splitext(first_file)[0]
                if re.match(r'^\d+$', name_without_ext):
                    # Just numbers
                    digits = len(name_without_ext)
                    if digits == 4:
                        self.file_pattern.set("%04d")
                    elif digits == 5:
                        self.file_pattern.set("%05d")
                    elif digits == 6:
                        self.file_pattern.set("%06d")
                elif re.match(r'^frame_\d+$', name_without_ext):
                    self.file_pattern.set("frame_%04d")
                elif re.match(r'^render_\d+$', name_without_ext):
                    self.file_pattern.set("render_%05d")
                    
                self.log_message(f"Detected: {len(files)} files, pattern: {self.file_pattern.get()}, extension: {self.file_extension.get()}")
                    
        except Exception as e:
            self.log_message(f"Auto-detection error: {e}")
    
    def auto_generate_output(self, input_path):
        """Auto-generate output filename"""
        folder_name = os.path.basename(input_path)
        output_path = os.path.join(os.path.dirname(input_path), f"{folder_name}.mp4")
        self.output_file.set(output_path)
    
    def browse_input_folder(self):
        folder = filedialog.askdirectory(title="Select Input Folder")
        if folder:
            self.input_folder.set(folder)
            self.auto_detect_settings(folder)
            self.auto_generate_output(folder)
    
    def browse_output_file(self):
        file = filedialog.asksaveasfilename(
            title="Save MP4 As",
            defaultextension=".mp4",
            filetypes=[("MP4 files", "*.mp4"), ("All files", "*.*")]
        )
        if file:
            self.output_file.set(file)
    
    def log_message(self, message):
        """Add message to log"""
        self.log_text.insert(tk.END, f"{message}\n")
        self.log_text.see(tk.END)
        self.root.update_idletasks()
    
    def start_conversion(self):
        if self.is_processing:
            return
            
        if not self.input_folder.get() or not self.output_file.get():
            messagebox.showerror("Error", "Please select input folder and output file")
            return
        
        self.is_processing = True
        self.convert_btn.config(state=tk.DISABLED)
        self.stop_btn.config(state=tk.NORMAL)
        self.progress_bar.start()
        
        # Start conversion in separate thread
        thread = threading.Thread(target=self.convert_sequence)
        thread.daemon = True
        thread.start()
    
    def stop_conversion(self):
        self.is_processing = False
        self.log_message("Stopping conversion...")
    
    def convert_sequence(self):
        try:
            input_folder = self.input_folder.get()
            output_file = self.output_file.get()
            frame_rate = self.frame_rate.get()
            quality = self.quality.get()
            preset = self.preset.get()
            file_pattern = self.file_pattern.get()
            file_extension = self.file_extension.get()
            
            # Build input pattern
            input_pattern = os.path.join(input_folder, f"{file_pattern}.{file_extension}")
            
            self.log_message(f"Starting conversion...")
            self.log_message(f"Input: {input_pattern}")
            self.log_message(f"Output: {output_file}")
            self.log_message(f"Frame Rate: {frame_rate} fps")
            self.log_message(f"Quality: CRF {quality}")
            self.log_message(f"Preset: {preset}")
            
            # Build FFmpeg command
            cmd = [
                'ffmpeg',
                '-framerate', frame_rate,
                '-i', input_pattern,
                '-c:v', 'libx264',
                '-preset', preset,
                '-crf', quality,
                '-pix_fmt', 'yuv420p',
                '-movflags', '+faststart',
                '-y',  # Overwrite output file
                output_file
            ]
            
            self.log_message(f"FFmpeg command: {' '.join(cmd)}")
            
            # Run FFmpeg
            process = subprocess.Popen(
                cmd,
                stdout=subprocess.PIPE,
                stderr=subprocess.STDOUT,
                universal_newlines=True,
                bufsize=1
            )
            
            # Monitor output
            for line in process.stdout:
                if not self.is_processing:
                    process.terminate()
                    break
                    
                line = line.strip()
                if line:
                    self.log_message(line)
            
            process.wait()
            
            if self.is_processing:
                if process.returncode == 0:
                    self.log_message("Conversion completed successfully!")
                    messagebox.showinfo("Success", "Image sequence converted to MP4 successfully!")
                else:
                    self.log_message(f"Conversion failed with return code: {process.returncode}")
                    messagebox.showerror("Error", "Conversion failed. Check the log for details.")
            
        except Exception as e:
            self.log_message(f"Error: {e}")
            messagebox.showerror("Error", f"Conversion failed: {e}")
        
        finally:
            self.is_processing = False
            self.progress_bar.stop()
            self.convert_btn.config(state=tk.NORMAL)
            self.stop_btn.config(state=tk.DISABLED)
            self.status_label.config(text="Ready to convert")

def main():
    root = tk.Tk()
    app = FFmpegConverterGUI(root)
    
    # Configure grid weights for resizing
    root.columnconfigure(0, weight=1)
    root.rowconfigure(0, weight=1)
    
    root.mainloop()

if __name__ == "__main__":
    main() 