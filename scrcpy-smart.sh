#!/bin/bash

VERSION="1.4.0"

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

# Detect OS
OS="$(uname -s)"
case "$OS" in
    Linux*)     OS_TYPE="Linux";;
    Darwin*)    OS_TYPE="macOS";;
    CYGWIN*|MINGW*|MSYS*) OS_TYPE="Windows";;
    *)          OS_TYPE="Unknown";;
esac

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
    echo ""
    echo "Profiles:"
    echo "  --profile gaming     High FPS, low latency (120fps, 720p, 4M)"
    echo "  --profile recording  High quality (60fps, 1920p, 16M)"
    echo "  --profile demo       Borderless, always-on-top"
    echo "  --profile battery    Battery saver (30fps, 720p, 2M)"
    echo ""
    echo "Quick Options:"
    echo "  --fullscreen    Launch in fullscreen"
    echo "  --record FILE   Record to file"
    echo ""
    echo "Examples:"
    echo "  $0                          # Connect to last device"
    echo "  $0 --save phone1            # Save current device as 'phone1'"
    echo "  $0 --device phone1          # Connect to 'phone1'"
    echo "  $0 --devices                # List saved devices"
    echo "  $0 --profile gaming         # Connect with gaming profile"
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
        *)
            echo -e "${RED}Unknown profile: $1${RESET}"
            exit 1
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

# Parse arguments
PROFILE=""
EXTRA_OPTS=""
RECORD_FILE=""
DEVICE_NAME=""

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
        --profile)
            PROFILE="$2"
            shift
            ;;
        --fullscreen)
            EXTRA_OPTS="$EXTRA_OPTS --fullscreen"
            ;;
        --record)
            RECORD_FILE="$2"
            shift
            ;;
        *) echo "Unknown option: $1"; show_help ;;
    esac
    shift
done

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
    echo -e "${RED}❌ No device found via USB or WiFi${RESET}"
    echo "📌 Connect via USB or enable Wireless Debugging"
    exit 1
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
scrcpy -s "$PHONE_IP:5555" --max-size "$SCRCPY_SIZE" --bit-rate "$SCRCPY_BITRATE" --max-fps "$SCRCPY_FPS" $SCRCPY_OPTS 2>/dev/null || \
scrcpy --max-size "$SCRCPY_SIZE" --bit-rate "$SCRCPY_BITRATE" --max-fps "$SCRCPY_FPS" $SCRCPY_OPTS
