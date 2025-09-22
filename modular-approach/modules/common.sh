#!/bin/bash
# Common functions and variables for Ubuntu Unity setup

# Colors
readonly RED='\033[0;31m'
readonly GREEN='\033[0;32m'
readonly YELLOW='\033[1;33m'
readonly BLUE='\033[0;34m'
readonly NC='\033[0m'

# Configuration
readonly BACKUP_DIR="$HOME/.ubuntu-gnome-backup-$(date +%Y%m%d_%H%M%S)"
readonly LOG_FILE="$HOME/.ubuntu-gnome-setup.log"

# Logging functions
log() {
    echo -e "${GREEN}[INFO]${NC} $1" | tee -a "$LOG_FILE"
}

warn() {
    echo -e "${YELLOW}[WARNING]${NC} $1" | tee -a "$LOG_FILE"
}

error() {
    echo -e "${RED}[ERROR]${NC} $1" | tee -a "$LOG_FILE"
}

header() {
    echo -e "${BLUE}=== $1 ===${NC}" | tee -a "$LOG_FILE"
}

# Backup function
backup_file() {
    local file="$1"
    if [[ -f "$file" ]]; then
        mkdir -p "$BACKUP_DIR"
        cp "$file" "$BACKUP_DIR/$(basename "$file")"
        log "Backed up: $file -> $BACKUP_DIR/$(basename "$file")"
    fi
}

# Check prerequisites
check_prerequisites() {
    header "Checking Prerequisites"
    
    # Check if running as root
    if [[ $EUID -eq 0 ]]; then
        error "Don't run this script as root"
        exit 1
    fi
    
    # Check desktop environment
    if [[ "${XDG_CURRENT_DESKTOP:-}" != "ubuntu:GNOME" ]] && [[ "${XDG_CURRENT_DESKTOP:-}" != "GNOME" ]]; then
        warn "This script is optimized for GNOME desktop (current: ${XDG_CURRENT_DESKTOP:-unknown})"
        read -p "Continue anyway? (y/N): " -n 1 -r
        echo
        if [[ ! $REPLY =~ ^[Yy]$ ]]; then
            exit 1
        fi
    fi
    
    # Install required packages
    local packages=("xclip" "xdotool" "xinput")
    local missing_packages=()
    
    for package in "${packages[@]}"; do
        if ! command -v "$package" >/dev/null 2>&1; then
            missing_packages+=("$package")
        fi
    done
    
    if [[ ${#missing_packages[@]} -gt 0 ]]; then
        log "Installing missing packages: ${missing_packages[*]}"
        sudo apt update
        sudo apt install -y "${missing_packages[@]}"
    fi
    
    log "Prerequisites check complete"
}

# Create necessary directories
setup_directories() {
    header "Setting Up Directories"
    
    local dirs=(
        "$HOME/.local/bin"
        "$HOME/.config/autostart"
        "$HOME/Pictures/Screenshots"
        "$BACKUP_DIR"
    )
    
    for dir in "${dirs[@]}"; do
        mkdir -p "$dir"
        log "Created directory: $dir"
    done
}