#!/bin/bash

VERSION="2.2.0"

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
LOG_FILE="$HOME/.scrcpy-smart.log"
PID_FILE="$HOME/.scrcpy-smart.pid"
ADB_PORT="${ADB_PORT:-5555}"

# Create devices directory if not exists
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
