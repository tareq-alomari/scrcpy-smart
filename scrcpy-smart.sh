#!/bin/bash

VERSION="2.3.0"

GREEN="\e[32m"
RED="\e[31m"
YELLOW="\e[33m"
CYAN="\e[36m"
BLUE="\e[34m"
MAGENTA="\e[35m"
RESET="\e[0m"

CONFIG="$HOME/.scrcpy-config"
CONFIG_FILE="$HOME/.scrcpy-smart.conf"
DEVICES_DIR="$HOME/.scrcpy-devices"
PROFILES_DIR="$HOME/.scrcpy-profiles"
ALIASES_DIR="$HOME/.scrcpy-aliases"
LOG_FILE="$HOME/.scrcpy-smart.log"
PID_FILE="$HOME/.scrcpy-smart.pid"
ADB_PORT="${ADB_PORT:-5555}"

# Create directories if not exist
mkdir -p "$DEVICES_DIR" "$PROFILES_DIR" "$ALIASES_DIR"
mkdir -p "$DEVICES_DIR"

# Load config file if exists
if [ -f "$CONFIG_FILE" ]; then
    source "$CONFIG_FILE"
fi

# Default settings (can be overridden by config file)
DEFAULT_BITRATE="${DEFAULT_BITRATE:-8M}"
DEFAULT_SIZE="${DEFAULT_SIZE:-1024}"
DEFAULT_FPS="${DEFAULT_FPS:-60}"
VERBOSE="${VERBOSE:-false}"
AUTO_RECONNECT="${AUTO_RECONNECT:-false}"
RECONNECT_INTERVAL="${RECONNECT_INTERVAL:-5}"
ERROR_LOG="${ERROR_LOG:-true}"

# Detect OS
OS="$(uname -s)"
case "$OS" in
    Linux*)     OS_TYPE="Linux";;
    Darwin*)    OS_TYPE="macOS";;
    CYGWIN*|MINGW*|MSYS*) OS_TYPE="Windows";;
    *)          OS_TYPE="Unknown";;
esac

# Error handling function
handle_error() {
    local error_msg="$1"
    local error_code="${2:-1}"
    
    echo -e "${RED}❌ Error: $error_msg${RESET}" >&2
    [ "$ERROR_LOG" = "true" ] && echo "[$(date)] ERROR: $error_msg" >> "$LOG_FILE"
    
    # Suggest solutions
    case "$error_msg" in
        *"No device"*) 
            echo -e "${YELLOW}💡 Try: Connect USB or check WiFi${RESET}"
            ;;
        *"connection"*|*"connect"*)
            echo -e "${YELLOW}💡 Try: scrcpy-smart --reset${RESET}"
            ;;
        *"IP"*)
            echo -e "${YELLOW}💡 Try: scrcpy-smart --ip YOUR_IP${RESET}"
            ;;
    esac
    
    exit "$error_code"
}

show_help() {
    echo -e "${CYAN}Scrcpy Smart Connect v$VERSION${RESET}"
    echo ""
    echo "Usage: $0 [OPTIONS]"
    echo ""
    echo "Options:"
    echo "  -h, --help       Show this help message"
    echo "  -r, --reset      Reset saved IP configuration"
    echo "  -c, --config     Show current configuration"
    echo "  -l, --list       List all connected devices"
    echo "  -s, --select     Select device manually"
    echo "  -v, --version    Show version"
    echo "  -V, --verbose    Verbose mode"
    echo ""
    echo "Multi-Device:"
    echo "  --save NAME      Save current device with nickname"
    echo "  --device NAME    Connect to saved device by nickname"
    echo "  --devices        List all saved devices"
    echo "  --remove NAME    Remove saved device"
    echo "  --rename OLD NEW Rename saved device"
    echo ""
    echo "Monitoring:"
    echo "  --monitor        Monitor connection and auto-reconnect"
    echo "  --daemon         Run as background daemon"
    echo "  --stop           Stop daemon"
    echo "  --status         Show daemon status"
    echo "  --logs           Show connection logs"
    echo "  --clear-logs     Clear connection logs"
    echo ""
    echo "Profiles:"
    echo "  --profile gaming     High FPS, low latency (120fps, 720p, 4M)"
    echo "  --profile recording  High quality (60fps, 1920p, 16M)"
    echo "  --profile demo       Borderless, always-on-top"
    echo "  --profile battery    Battery saver (30fps, 720p, 2M)"
    echo "  --profile dev        Development (60fps, 1024p, stay-awake)"
    echo "  --profile presentation  Fullscreen presentation mode"
    echo ""
    echo "Quick Options:"
    echo "  --fullscreen    Launch in fullscreen"
    echo "  --record FILE   Record to file"
    echo "  --screenshot    Take screenshot and exit"
    echo "  --no-audio      Disable audio forwarding"
    echo ""
    echo "Network:"
    echo "  --port PORT     Use custom ADB port (default: 5555)"
    echo "  --ip IP         Connect to specific IP"
    echo "  --scan          Scan network for Android devices"
    echo "  --perf          Show performance stats"
    echo ""
    echo "Quick Actions:"
    echo "  --reboot        Reboot device"
    echo "  --install FILE  Install APK"
    echo "  --shell         Open ADB shell"
    echo ""
    echo "Config Profiles:"
    echo "  --save-profile NAME  Save current settings as profile"
    echo "  --load-profile NAME  Load saved profile"
    echo "  --list-profiles      List all saved profiles"
    echo ""
    echo "Backup/Restore:"
    echo "  --backup DIR    Backup device data"
    echo "  --restore DIR   Restore device data"
    echo ""
    echo "Aliases:"
    echo "  --alias NAME CMD    Create command alias"
    echo "  --run-alias NAME    Run saved alias"
    echo "  --list-aliases      List all aliases"
    echo ""
    echo "Quality Presets:"
    echo "  --quality low       Low quality (480p, 2M, 30fps)"
    echo "  --quality medium    Medium quality (720p, 4M, 60fps)"
    echo "  --quality high      High quality (1080p, 8M, 60fps)"
    echo "  --quality ultra     Ultra quality (1440p, 16M, 60fps)"
    echo ""
    echo "Display:"
    echo "  --rotate [0|90|180|270]  Rotate screen"
    echo "  --crop WxH:X:Y           Crop screen"
    echo ""
    echo "Device Info:"
    echo "  --info              Show device information"
    echo ""
    echo "Examples:"
    echo "  $0                          # Connect to last device"
    echo "  $0 --monitor                # Connect with auto-reconnect"
    echo "  $0 --daemon                 # Run as background daemon"
    echo "  $0 --device phone1          # Connect to 'phone1'"
    echo "  $0 --screenshot             # Take screenshot"
    echo "  $0 --ip 192.168.1.100       # Connect to specific IP"
    exit 0
}

show_version() {
    echo "Scrcpy Smart Connect v$VERSION"
    echo "OS: $OS_TYPE"
    exit 0
}

show_config() {
    if [ -f "$CONFIG" ]; then
        echo -e "${CYAN}Current Configuration:${RESET}"
        echo "Saved IP: $(cat $CONFIG)"
        echo "Config file: $CONFIG"
        echo ""
    else
        echo -e "${YELLOW}No saved IP found${RESET}"
        echo ""
    fi
    
    if [ -f "$CONFIG_FILE" ]; then
        echo -e "${CYAN}Settings (from $CONFIG_FILE):${RESET}"
        cat "$CONFIG_FILE"
    else
        echo -e "${CYAN}Default Settings:${RESET}"
        echo "DEFAULT_BITRATE=$DEFAULT_BITRATE"
        echo "DEFAULT_SIZE=$DEFAULT_SIZE"
        echo "DEFAULT_FPS=$DEFAULT_FPS"
        echo ""
        echo -e "${YELLOW}Create $CONFIG_FILE to customize${RESET}"
    fi
    exit 0
}

reset_config() {
    if [ -f "$CONFIG" ]; then
        rm "$CONFIG"
        echo -e "${GREEN}✅ Configuration reset${RESET}"
    else
        echo -e "${YELLOW}No configuration to reset${RESET}"
    fi
    exit 0
}

list_devices() {
    echo -e "${CYAN}Connected Devices:${RESET}"
    adb devices -l
    exit 0
}

select_device() {
    echo -e "${CYAN}Available Devices:${RESET}"
    DEVICES=($(adb devices | awk 'NR>1 {print $1}' | grep -v "^$"))
    
    if [ ${#DEVICES[@]} -eq 0 ]; then
        echo -e "${RED}No devices found${RESET}"
        exit 1
    fi
    
    for i in "${!DEVICES[@]}"; do
        echo "$((i+1)). ${DEVICES[$i]}"
    done
    
    read -p "Select device number: " choice
    SELECTED="${DEVICES[$((choice-1))]}"
    
    if [[ $SELECTED == *":"* ]]; then
        IP=$(echo $SELECTED | cut -d: -f1)
        echo "$IP" > "$CONFIG"
        echo -e "${GREEN}✅ Device selected: $IP${RESET}"
    fi
    exit 0
}

log_verbose() {
    if [ "$VERBOSE" = "true" ]; then
        echo -e "${BLUE}[DEBUG]${RESET} $1"
    fi
}

log_to_file() {
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] $1" >> "$LOG_FILE"
}

show_logs() {
    if [ -f "$LOG_FILE" ]; then
        echo -e "${CYAN}Connection Logs:${RESET}"
        tail -50 "$LOG_FILE"
    else
        echo -e "${YELLOW}No logs found${RESET}"
    fi
    exit 0
}

check_daemon_status() {
    if [ -f "$PID_FILE" ]; then
        local pid=$(cat "$PID_FILE")
        if ps -p "$pid" > /dev/null 2>&1; then
            echo -e "${GREEN}✅ Daemon running (PID: $pid)${RESET}"
            exit 0
        else
            echo -e "${YELLOW}⚠️  Daemon not running (stale PID file)${RESET}"
            rm "$PID_FILE"
            exit 1
        fi
    else
        echo -e "${RED}❌ Daemon not running${RESET}"
        exit 1
    fi
}

stop_daemon() {
    if [ -f "$PID_FILE" ]; then
        local pid=$(cat "$PID_FILE")
        if ps -p "$pid" > /dev/null 2>&1; then
            kill "$pid"
            rm "$PID_FILE"
            echo -e "${GREEN}✅ Daemon stopped${RESET}"
        else
            rm "$PID_FILE"
            echo -e "${YELLOW}⚠️  Daemon was not running${RESET}"
        fi
    else
        echo -e "${RED}❌ No daemon running${RESET}"
    fi
    exit 0
}

monitor_connection() {
    local ip="$1"
    
    echo -e "${CYAN}🔍 Monitoring connection to $ip${RESET}"
    echo -e "${YELLOW}Press Ctrl+C to stop${RESET}\n"
    
    log_to_file "Monitor started for $ip"
    
    while true; do
        if ! adb devices | grep -q "$ip"; then
            echo -e "${YELLOW}⚠️  Connection lost. Reconnecting...${RESET}"
            log_to_file "Connection lost to $ip, attempting reconnect"
            
            adb connect "$ip:5555" &>/dev/null
            sleep 2
            
            if adb devices | grep -q "$ip"; then
                echo -e "${GREEN}✅ Reconnected!${RESET}"
                log_to_file "Successfully reconnected to $ip"
            else
                echo -e "${RED}❌ Reconnect failed. Retrying in ${RECONNECT_INTERVAL}s...${RESET}"
                log_to_file "Reconnect failed for $ip"
            fi
        else
            log_verbose "Connection OK"
        fi
        
        sleep "$RECONNECT_INTERVAL"
    done
}

start_daemon() {
    if [ -f "$PID_FILE" ]; then
        local pid=$(cat "$PID_FILE")
        if ps -p "$pid" > /dev/null 2>&1; then
            echo -e "${YELLOW}⚠️  Daemon already running (PID: $pid)${RESET}"
            exit 1
        fi
    fi
    
    if [ ! -f "$CONFIG" ]; then
        echo -e "${RED}❌ No device configured. Connect first.${RESET}"
        exit 1
    fi
    
    local ip=$(cat "$CONFIG")
    
    echo -e "${CYAN}🚀 Starting daemon for $ip${RESET}"
    log_to_file "Daemon started for $ip"
    
    # Run in background
    nohup bash -c "
        while true; do
            if ! adb devices | grep -q '$ip'; then
                adb connect '$ip:5555' &>/dev/null
                echo \"[$(date '+%Y-%m-%d %H:%M:%S')] Reconnected to $ip\" >> '$LOG_FILE'
            fi
            sleep $RECONNECT_INTERVAL
        done
    " > /dev/null 2>&1 &
    
    echo $! > "$PID_FILE"
    echo -e "${GREEN}✅ Daemon started (PID: $!)${RESET}"
    echo -e "${CYAN}Use: $0 --stop to stop daemon${RESET}"
    exit 0
}

# Profile configurations
apply_profile() {
    case "$1" in
        gaming)
            PROFILE_SIZE=720
            PROFILE_BITRATE=4M
            PROFILE_FPS=120
            PROFILE_OPTS="--display-buffer=50"
            echo -e "${MAGENTA}🎮 Gaming Profile${RESET}"
            ;;
        recording)
            PROFILE_SIZE=1920
            PROFILE_BITRATE=16M
            PROFILE_FPS=60
            PROFILE_OPTS=""
            echo -e "${MAGENTA}🎥 Recording Profile${RESET}"
            ;;
        demo)
            PROFILE_SIZE=1024
            PROFILE_BITRATE=8M
            PROFILE_FPS=60
            PROFILE_OPTS="--window-borderless --always-on-top"
            echo -e "${MAGENTA}📊 Demo Profile${RESET}"
            ;;
        battery)
            PROFILE_SIZE=720
            PROFILE_BITRATE=2M
            PROFILE_FPS=30
            PROFILE_OPTS="--turn-screen-off"
            echo -e "${MAGENTA}🔋 Battery Saver Profile${RESET}"
            ;;
        dev)
            PROFILE_SIZE=1024
            PROFILE_BITRATE=6M
            PROFILE_FPS=60
            PROFILE_OPTS="--stay-awake"
            echo -e "${MAGENTA}💻 Development Profile${RESET}"
            ;;
        presentation)
            PROFILE_SIZE=1280
            PROFILE_BITRATE=10M
            PROFILE_FPS=60
            PROFILE_OPTS="--window-borderless --always-on-top --fullscreen"
            echo -e "${MAGENTA}🎤 Presentation Profile${RESET}"
            ;;
        *)
            handle_error "Unknown profile: $1. Available: gaming, recording, demo, battery, dev, presentation"
            ;;
    esac
}

# Multi-device functions
save_device() {
    local name="$1"
    if [ -z "$name" ]; then
        echo -e "${RED}Error: Device name required${RESET}"
        echo "Usage: $0 --save NAME"
        exit 1
    fi
    
    if [ ! -f "$CONFIG" ]; then
        echo -e "${RED}Error: No device connected. Connect first, then save.${RESET}"
        exit 1
    fi
    
    local ip=$(cat "$CONFIG")
    echo "$ip" > "$DEVICES_DIR/$name"
    echo -e "${GREEN}✅ Device saved as '$name' ($ip)${RESET}"
    exit 0
}

list_saved_devices() {
    echo -e "${CYAN}Saved Devices:${RESET}"
    
    if [ ! "$(ls -A $DEVICES_DIR 2>/dev/null)" ]; then
        echo -e "${YELLOW}No saved devices${RESET}"
        echo "Use: $0 --save NAME to save a device"
        exit 0
    fi
    
    for device in "$DEVICES_DIR"/*; do
        if [ -f "$device" ]; then
            local name=$(basename "$device")
            local ip=$(cat "$device")
            echo -e "  ${GREEN}$name${RESET} → $ip"
        fi
    done
    exit 0
}

connect_to_device() {
    local name="$1"
    if [ -z "$name" ]; then
        echo -e "${RED}Error: Device name required${RESET}"
        echo "Usage: $0 --device NAME"
        exit 1
    fi
    
    local device_file="$DEVICES_DIR/$name"
    if [ ! -f "$device_file" ]; then
        echo -e "${RED}Error: Device '$name' not found${RESET}"
        echo "Available devices:"
        list_saved_devices
        exit 1
    fi
    
    local ip=$(cat "$device_file")
    echo "$ip" > "$CONFIG"
    echo -e "${GREEN}✅ Switched to device '$name' ($ip)${RESET}"
    log_verbose "Device file: $device_file"
}

remove_device() {
    local name="$1"
    if [ -z "$name" ]; then
        echo -e "${RED}Error: Device name required${RESET}"
        echo "Usage: $0 --remove NAME"
        exit 1
    fi
    
    local device_file="$DEVICES_DIR/$name"
    if [ ! -f "$device_file" ]; then
        echo -e "${RED}Error: Device '$name' not found${RESET}"
        exit 1
    fi
    
    rm "$device_file"
    echo -e "${GREEN}✅ Device '$name' removed${RESET}"
    exit 0
}

rename_device() {
    local old_name="$1"
    local new_name="$2"
    
    if [ -z "$old_name" ] || [ -z "$new_name" ]; then
        echo -e "${RED}Error: Both old and new names required${RESET}"
        echo "Usage: $0 --rename OLD_NAME NEW_NAME"
        exit 1
    fi
    
    local old_file="$DEVICES_DIR/$old_name"
    local new_file="$DEVICES_DIR/$new_name"
    
    if [ ! -f "$old_file" ]; then
        echo -e "${RED}Error: Device '$old_name' not found${RESET}"
        exit 1
    fi
    
    if [ -f "$new_file" ]; then
        echo -e "${RED}Error: Device '$new_name' already exists${RESET}"
        exit 1
    fi
    
    mv "$old_file" "$new_file"
    echo -e "${GREEN}✅ Device renamed: '$old_name' → '$new_name'${RESET}"
    exit 0
}

clear_logs() {
    if [ -f "$LOG_FILE" ]; then
        > "$LOG_FILE"
        echo -e "${GREEN}✅ Logs cleared${RESET}"
    else
        echo -e "${YELLOW}No logs to clear${RESET}"
    fi
    exit 0
}

take_screenshot() {
    local filename="screenshot_$(date +%Y%m%d_%H%M%S).png"
    echo -e "${CYAN}📸 Taking screenshot...${RESET}"
    
    if [ -f "$CONFIG" ]; then
        local ip=$(cat "$CONFIG")
        adb -s "$ip:$ADB_PORT" exec-out screencap -p > "$filename"
    else
        adb exec-out screencap -p > "$filename"
    fi
    
    if [ -f "$filename" ]; then
        echo -e "${GREEN}✅ Screenshot saved: $filename${RESET}"
    else
        echo -e "${RED}❌ Screenshot failed${RESET}"
        exit 1
    fi
    exit 0
}

scan_network() {
    echo -e "${CYAN}🔍 Scanning network for Android devices...${RESET}"
    
    # Get local network
    local network=$(ip route | grep default | awk '{print $3}' | cut -d. -f1-3)
    
    if [ -z "$network" ]; then
        handle_error "Could not detect network"
    fi
    
    echo -e "${YELLOW}Scanning ${network}.0/24...${RESET}"
    
    local found=0
    for i in {1..254}; do
        local ip="${network}.$i"
        timeout 0.2 adb connect "$ip:5555" &>/dev/null
        if adb devices | grep -q "$ip"; then
            echo -e "${GREEN}✅ Found device at: $ip${RESET}"
            ((found++))
        fi
    done
    
    if [ $found -eq 0 ]; then
        echo -e "${YELLOW}No devices found on network${RESET}"
    else
        echo -e "${GREEN}Found $found device(s)${RESET}"
    fi
    
    exit 0
}

show_performance() {
    echo -e "${CYAN}📊 Performance Stats${RESET}\n"
    
    if [ -f "$CONFIG" ]; then
        local ip=$(cat "$CONFIG")
        local device="$ip:$ADB_PORT"
    else
        local device=$(adb devices | awk 'NR==2 {print $1}')
    fi
    
    if [ -z "$device" ]; then
        handle_error "No device connected"
    fi
    
    echo -e "${YELLOW}Device: $device${RESET}"
    
    # Battery
    local battery=$(adb -s "$device" shell dumpsys battery | grep level | awk '{print $2}')
    echo -e "🔋 Battery: ${GREEN}${battery}%${RESET}"
    
    # CPU
    local cpu=$(adb -s "$device" shell top -n 1 | grep "CPU:" | awk '{print $2}')
    echo -e "⚡ CPU: ${CYAN}${cpu}${RESET}"
    
    # Memory
    local mem=$(adb -s "$device" shell dumpsys meminfo | grep "Total RAM" | awk '{print $3}')
    echo -e "💾 Memory: ${CYAN}${mem}${RESET}"
    
    # Screen
    local screen=$(adb -s "$device" shell dumpsys power | grep "mScreenOn" | awk -F= '{print $2}')
    echo -e "📱 Screen: ${CYAN}${screen}${RESET}"
    
    exit 0
}

quick_reboot() {
    echo -e "${YELLOW}🔄 Rebooting device...${RESET}"
    adb reboot
    echo -e "${GREEN}✅ Reboot command sent${RESET}"
    exit 0
}

quick_install() {
    local apk="$1"
    if [ ! -f "$apk" ]; then
        handle_error "APK file not found: $apk"
    fi
    
    echo -e "${CYAN}📦 Installing $apk...${RESET}"
    adb install "$apk"
    echo -e "${GREEN}✅ Installation complete${RESET}"
    exit 0
}

quick_shell() {
    echo -e "${CYAN}🐚 Opening ADB shell...${RESET}"
    adb shell
    exit 0
}

save_config_profile() {
    local name="$1"
    [ -z "$name" ] && handle_error "Profile name required"
    
    local profile_file="$PROFILES_DIR/$name"
    cat > "$profile_file" << EOF
BITRATE=$DEFAULT_BITRATE
SIZE=$DEFAULT_SIZE
FPS=$DEFAULT_FPS
PROFILE=${PROFILE:-default}
EOF
    
    echo -e "${GREEN}✅ Profile '$name' saved${RESET}"
    exit 0
}

load_config_profile() {
    local name="$1"
    [ -z "$name" ] && handle_error "Profile name required"
    
    local profile_file="$PROFILES_DIR/$name"
    [ ! -f "$profile_file" ] && handle_error "Profile '$name' not found"
    
    source "$profile_file"
    DEFAULT_BITRATE=$BITRATE
    DEFAULT_SIZE=$SIZE
    DEFAULT_FPS=$FPS
    
    echo -e "${GREEN}✅ Profile '$name' loaded${RESET}"
}

list_config_profiles() {
    echo -e "${CYAN}📋 Saved Profiles:${RESET}\n"
    
    if [ ! "$(ls -A $PROFILES_DIR 2>/dev/null)" ]; then
        echo -e "${YELLOW}No profiles saved${RESET}"
        exit 0
    fi
    
    for profile in "$PROFILES_DIR"/*; do
        local name=$(basename "$profile")
        echo -e "${GREEN}• $name${RESET}"
        source "$profile"
        echo -e "  Size: $SIZE, Bitrate: $BITRATE, FPS: $FPS"
    done
    
    exit 0
}

backup_device() {
    local dir="${1:-backup_$(date +%Y%m%d_%H%M%S)}"
    mkdir -p "$dir"
    
    echo -e "${CYAN}💾 Backing up device to $dir...${RESET}"
    
    adb backup -apk -shared -all -f "$dir/backup.ab"
    
    echo -e "${GREEN}✅ Backup complete: $dir${RESET}"
    exit 0
}

restore_device() {
    local dir="$1"
    [ -z "$dir" ] && handle_error "Backup directory required"
    [ ! -d "$dir" ] && handle_error "Directory not found: $dir"
    
    local backup_file="$dir/backup.ab"
    [ ! -f "$backup_file" ] && handle_error "Backup file not found"
    
    echo -e "${YELLOW}⚠️  Restoring will overwrite device data${RESET}"
    echo -e "${CYAN}📦 Restoring from $dir...${RESET}"
    
    adb restore "$backup_file"
    
    echo -e "${GREEN}✅ Restore complete${RESET}"
    exit 0
}

create_alias() {
    local name="$1"
    local cmd="$2"
    [ -z "$name" ] || [ -z "$cmd" ] && handle_error "Usage: --alias NAME COMMAND"
    
    echo "$cmd" > "$ALIASES_DIR/$name"
    echo -e "${GREEN}✅ Alias '$name' created${RESET}"
    exit 0
}

run_alias() {
    local name="$1"
    [ -z "$name" ] && handle_error "Alias name required"
    
    local alias_file="$ALIASES_DIR/$name"
    [ ! -f "$alias_file" ] && handle_error "Alias '$name' not found"
    
    local cmd=$(cat "$alias_file")
    echo -e "${CYAN}▶️  Running: $cmd${RESET}"
    eval "$cmd"
    exit 0
}

list_aliases() {
    echo -e "${CYAN}📋 Saved Aliases:${RESET}\n"
    
    if [ ! "$(ls -A $ALIASES_DIR 2>/dev/null)" ]; then
        echo -e "${YELLOW}No aliases saved${RESET}"
        exit 0
    fi
    
    for alias_file in "$ALIASES_DIR"/*; do
        local name=$(basename "$alias_file")
        local cmd=$(cat "$alias_file")
        echo -e "${GREEN}• $name${RESET}: $cmd"
    done
    
    exit 0
}

apply_quality() {
    case "$1" in
        low)
            DEFAULT_SIZE=480
            DEFAULT_BITRATE=2M
            DEFAULT_FPS=30
            echo -e "${YELLOW}📉 Low Quality${RESET}"
            ;;
        medium)
            DEFAULT_SIZE=720
            DEFAULT_BITRATE=4M
            DEFAULT_FPS=60
            echo -e "${CYAN}📊 Medium Quality${RESET}"
            ;;
        high)
            DEFAULT_SIZE=1080
            DEFAULT_BITRATE=8M
            DEFAULT_FPS=60
            echo -e "${GREEN}📈 High Quality${RESET}"
            ;;
        ultra)
            DEFAULT_SIZE=1440
            DEFAULT_BITRATE=16M
            DEFAULT_FPS=60
            echo -e "${MAGENTA}🚀 Ultra Quality${RESET}"
            ;;
        *)
            handle_error "Unknown quality: $1. Use: low, medium, high, ultra"
            ;;
    esac
}

show_device_info() {
    echo -e "${CYAN}📱 Device Information${RESET}\n"
    
    if [ -f "$CONFIG" ]; then
        local ip=$(cat "$CONFIG")
        local device="$ip:$ADB_PORT"
    else
        local device=$(adb devices | awk 'NR==2 {print $1}')
    fi
    
    [ -z "$device" ] && handle_error "No device connected"
    
    echo -e "${YELLOW}Device: $device${RESET}\n"
    
    # Model
    local model=$(adb -s "$device" shell getprop ro.product.model)
    echo -e "📱 Model: ${GREEN}$model${RESET}"
    
    # Android Version
    local android=$(adb -s "$device" shell getprop ro.build.version.release)
    echo -e "🤖 Android: ${GREEN}$android${RESET}"
    
    # SDK Version
    local sdk=$(adb -s "$device" shell getprop ro.build.version.sdk)
    echo -e "📦 SDK: ${GREEN}$sdk${RESET}"
    
    # Resolution
    local res=$(adb -s "$device" shell wm size | grep -oE '[0-9]+x[0-9]+')
    echo -e "📐 Resolution: ${GREEN}$res${RESET}"
    
    # Battery
    local battery=$(adb -s "$device" shell dumpsys battery | grep level | awk '{print $2}')
    echo -e "🔋 Battery: ${GREEN}${battery}%${RESET}"
    
    # IP Address
    local ip_addr=$(adb -s "$device" shell ip addr show wlan0 | grep -oE '([0-9]{1,3}\.){3}[0-9]{1,3}' | head -1)
    echo -e "🌐 IP: ${GREEN}$ip_addr${RESET}"
    
    exit 0
}

# Parse arguments
PROFILE=""
EXTRA_OPTS=""
RECORD_FILE=""
DEVICE_NAME=""
MONITOR_MODE=false
CUSTOM_IP=""

while [[ $# -gt 0 ]]; do
    case $1 in
        -h|--help) show_help ;;
        -v|--version) show_version ;;
        -c|--config) show_config ;;
        -r|--reset) reset_config ;;
        -l|--list) list_devices ;;
        -s|--select) select_device ;;
        -V|--verbose) VERBOSE=true ;;
        --save)
            save_device "$2"
            ;;
        --device)
            DEVICE_NAME="$2"
            shift
            ;;
        --devices)
            list_saved_devices
            ;;
        --remove)
            remove_device "$2"
            ;;
        --rename)
            rename_device "$2" "$3"
            ;;
        --monitor)
            MONITOR_MODE=true
            ;;
        --daemon)
            start_daemon
            ;;
        --stop)
            stop_daemon
            ;;
        --status)
            check_daemon_status
            ;;
        --logs)
            show_logs
            ;;
        --clear-logs)
            clear_logs
            ;;
        --screenshot)
            take_screenshot
            ;;
        --scan)
            scan_network
            ;;
        --perf)
            show_performance
            ;;
        --reboot)
            quick_reboot
            ;;
        --install)
            quick_install "$2"
            ;;
        --shell)
            quick_shell
            ;;
        --save-profile)
            save_config_profile "$2"
            ;;
        --load-profile)
            load_config_profile "$2"
            ;;
        --list-profiles)
            list_config_profiles
            ;;
        --backup)
            backup_device "$2"
            ;;
        --restore)
            restore_device "$2"
            ;;
        --alias)
            create_alias "$2" "$3"
            ;;
        --run-alias)
            run_alias "$2"
            ;;
        --list-aliases)
            list_aliases
            ;;
        --quality)
            apply_quality "$2"
            shift
            ;;
        --rotate)
            EXTRA_OPTS="$EXTRA_OPTS --rotation=$2"
            shift
            ;;
        --crop)
            EXTRA_OPTS="$EXTRA_OPTS --crop=$2"
            shift
            ;;
        --info)
            show_device_info
            ;;
        --profile)
            PROFILE="$2"
            shift
            ;;
        --fullscreen)
            EXTRA_OPTS="$EXTRA_OPTS --fullscreen"
            ;;
        --no-audio)
            EXTRA_OPTS="$EXTRA_OPTS --no-audio"
            ;;
        --record)
            RECORD_FILE="$2"
            shift
            ;;
        --port)
            ADB_PORT="$2"
            shift
            ;;
        --ip)
            CUSTOM_IP="$2"
            shift
            ;;
        *) echo "Unknown option: $1"; show_help ;;
    esac
    shift
done

# Use custom IP if provided
if [ -n "$CUSTOM_IP" ]; then
    echo "$CUSTOM_IP" > "$CONFIG"
    echo -e "${GREEN}✅ Using IP: $CUSTOM_IP${RESET}"
fi

# Switch to specific device if requested
if [ -n "$DEVICE_NAME" ]; then
    connect_to_device "$DEVICE_NAME"
fi

# Apply profile if specified
if [ -n "$PROFILE" ]; then
    apply_profile "$PROFILE"
    SCRCPY_SIZE="${PROFILE_SIZE:-$DEFAULT_SIZE}"
    SCRCPY_BITRATE="${PROFILE_BITRATE:-$DEFAULT_BITRATE}"
    SCRCPY_FPS="${PROFILE_FPS:-$DEFAULT_FPS}"
    SCRCPY_OPTS="$PROFILE_OPTS"
else
    SCRCPY_SIZE="$DEFAULT_SIZE"
    SCRCPY_BITRATE="$DEFAULT_BITRATE"
    SCRCPY_FPS="$DEFAULT_FPS"
    SCRCPY_OPTS=""
fi

# Add recording if specified
if [ -n "$RECORD_FILE" ]; then
    SCRCPY_OPTS="$SCRCPY_OPTS --record=$RECORD_FILE"
    echo -e "${MAGENTA}🎥 Recording to: $RECORD_FILE${RESET}"
fi

# Add extra options
SCRCPY_OPTS="$SCRCPY_OPTS $EXTRA_OPTS"

echo -e "${CYAN}🚀 Scrcpy Smart Connect v$VERSION${RESET}"
echo -e "${CYAN}OS: $OS_TYPE${RESET}\n"

log_verbose "Config file: $CONFIG_FILE"
log_verbose "Settings: Size=$SCRCPY_SIZE, Bitrate=$SCRCPY_BITRATE, FPS=$SCRCPY_FPS"

# Try wireless first
if [ -f "$CONFIG" ]; then
    SAVED_IP=$(cat "$CONFIG")
    echo -e "${YELLOW}📡 Trying saved connection: $SAVED_IP${RESET}"
    log_verbose "Connecting to $SAVED_IP:5555"
    
    adb connect "$SAVED_IP:5555" &>/dev/null
    sleep 1
    
    if adb devices | grep -q "$SAVED_IP"; then
        echo -e "${GREEN}✅ Connected wirelessly!${RESET}"
        log_verbose "Launching scrcpy with: --max-size $SCRCPY_SIZE --bit-rate $SCRCPY_BITRATE --max-fps $SCRCPY_FPS $SCRCPY_OPTS"
        scrcpy -s "$SAVED_IP:5555" --max-size "$SCRCPY_SIZE" --bit-rate "$SCRCPY_BITRATE" --max-fps "$SCRCPY_FPS" $SCRCPY_OPTS
        exit 0
    fi
    
    echo -e "${YELLOW}⚠️  Wireless failed, trying USB...${RESET}"
fi

# USB fallback
adb kill-server &>/dev/null
adb start-server &>/dev/null

DEVICE=$(adb devices | awk 'NR==2 {print $1}')

if [ -z "$DEVICE" ]; then
    handle_error "No device found via USB or WiFi"
fi

echo -e "${GREEN}✅ Device found: $DEVICE${RESET}"

# Setup wireless
echo -e "${YELLOW}📡 Setting up wireless...${RESET}"
adb tcpip 5555
sleep 2

# Detect WiFi interface based on OS
if [ "$OS_TYPE" = "macOS" ]; then
    PHONE_IP=$(adb shell ip -f inet addr show wlan0 2>/dev/null | grep -oE '([0-9]{1,3}\.){3}[0-9]{1,3}' | head -1)
else
    PHONE_IP=$(adb shell ip -f inet addr show wlan0 2>/dev/null | grep -oP '(?<=inet\s)\d+(\.\d+){3}')
fi

# Fallback: try alternative methods
if [ -z "$PHONE_IP" ]; then
    PHONE_IP=$(adb shell ip route 2>/dev/null | grep -oE '([0-9]{1,3}\.){3}[0-9]{1,3}' | head -1)
fi

if [ -z "$PHONE_IP" ]; then
    echo -e "${YELLOW}⚠️  Could not detect IP, using USB${RESET}"
    scrcpy --max-size 1024 --bit-rate 8M --max-fps 60
    exit 0
fi

echo "$PHONE_IP" > "$CONFIG"
echo -e "${GREEN}📱 IP saved: $PHONE_IP${RESET}"

adb connect "$PHONE_IP:5555"
sleep 2

if adb devices | grep -q "$PHONE_IP"; then
    echo -e "${GREEN}✅ Wireless ready! Disconnect USB now${RESET}"
else
    echo -e "${YELLOW}⚠️  Using USB connection${RESET}"
fi

log_verbose "Launching scrcpy with: --max-size $SCRCPY_SIZE --bit-rate $SCRCPY_BITRATE --max-fps $SCRCPY_FPS $SCRCPY_OPTS"

# Start monitor if requested
if [ "$MONITOR_MODE" = "true" ]; then
    # Launch scrcpy in background
    scrcpy -s "$PHONE_IP:5555" --max-size "$SCRCPY_SIZE" --bit-rate "$SCRCPY_BITRATE" --max-fps "$SCRCPY_FPS" $SCRCPY_OPTS &
    SCRCPY_PID=$!
    
    # Monitor connection
    monitor_connection "$PHONE_IP"
else
    # Normal mode
    scrcpy -s "$PHONE_IP:5555" --max-size "$SCRCPY_SIZE" --bit-rate "$SCRCPY_BITRATE" --max-fps "$SCRCPY_FPS" $SCRCPY_OPTS 2>/dev/null || \
    scrcpy --max-size "$SCRCPY_SIZE" --bit-rate "$SCRCPY_BITRATE" --max-fps "$SCRCPY_FPS" $SCRCPY_OPTS
fi
