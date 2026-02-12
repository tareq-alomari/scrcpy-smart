#!/bin/bash

GREEN="\e[32m"
RED="\e[31m"
YELLOW="\e[33m"
CYAN="\e[36m"
RESET="\e[0m"

CONFIG="$HOME/.scrcpy-config"

echo -e "${CYAN}🚀 Scrcpy Smart Connect${RESET}\n"

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

PHONE_IP=$(adb shell ip -f inet addr show wlan0 2>/dev/null | grep -oP '(?<=inet\s)\d+(\.\d+){3}')

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
