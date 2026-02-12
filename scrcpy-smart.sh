#!/bin/bash

VERSION="1.1.0"

GREEN="\e[32m"
RED="\e[31m"
YELLOW="\e[33m"
CYAN="\e[36m"
RESET="\e[0m"

CONFIG="$HOME/.scrcpy-config"

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
    echo ""
    echo "Examples:"
    echo "  $0              # Connect to saved device"
    echo "  $0 --reset      # Clear saved IP and reconnect"
    echo "  $0 --list       # Show all devices"
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
    else
        echo -e "${YELLOW}No configuration found${RESET}"
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

# Parse arguments
while [[ $# -gt 0 ]]; do
    case $1 in
        -h|--help) show_help ;;
        -v|--version) show_version ;;
        -c|--config) show_config ;;
        -r|--reset) reset_config ;;
        -l|--list) list_devices ;;
        -s|--select) select_device ;;
        *) echo "Unknown option: $1"; show_help ;;
    esac
    shift
done

echo -e "${CYAN}🚀 Scrcpy Smart Connect v$VERSION${RESET}"
echo -e "${CYAN}OS: $OS_TYPE${RESET}\n"

# Try wireless first
if [ -f "$CONFIG" ]; then
    SAVED_IP=$(cat "$CONFIG")
    echo -e "${YELLOW}📡 Trying saved connection: $SAVED_IP${RESET}"
    
    adb connect "$SAVED_IP:5555" &>/dev/null
    sleep 1
    
    if adb devices | grep -q "$SAVED_IP"; then
        echo -e "${GREEN}✅ Connected wirelessly!${RESET}"
        scrcpy -s "$SAVED_IP:5555" --max-size 1024 --bit-rate 8M --max-fps 60
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

scrcpy -s "$PHONE_IP:5555" --max-size 1024 --bit-rate 8M --max-fps 60 2>/dev/null || scrcpy --max-size 1024 --bit-rate 8M --max-fps 60
