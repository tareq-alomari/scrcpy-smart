#!/bin/bash

# Scrcpy Smart Connect - GUI Wrapper
# Uses zenity for simple graphical interface

VERSION="2.0.0"
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
MAIN_SCRIPT="$SCRIPT_DIR/scrcpy-smart.sh"

# Check if zenity is installed
if ! command -v zenity &> /dev/null; then
    echo "Error: zenity is required for GUI mode"
    echo "Install: sudo apt install zenity (Ubuntu/Debian)"
    echo "        brew install zenity (macOS)"
    exit 1
fi

# Main menu
show_main_menu() {
    choice=$(zenity --list \
        --title="Scrcpy Smart Connect v$VERSION" \
        --text="Choose an action:" \
        --column="Action" \
        --height=400 \
        --width=400 \
        "Connect to Device" \
        "Connect with Profile" \
        "Manage Devices" \
        "Monitor Connection" \
        "Daemon Control" \
        "View Logs" \
        "Settings" \
        "About" \
        "Exit")
    
    case "$choice" in
        "Connect to Device")
            connect_device
            ;;
        "Connect with Profile")
            connect_with_profile
            ;;
        "Manage Devices")
            manage_devices
            ;;
        "Monitor Connection")
            monitor_connection
            ;;
        "Daemon Control")
            daemon_control
            ;;
        "View Logs")
            view_logs
            ;;
        "Settings")
            show_settings
            ;;
        "About")
            show_about
            ;;
        "Exit")
            exit 0
            ;;
        *)
            exit 0
            ;;
    esac
}

# Connect to device
connect_device() {
    # Get saved devices
    devices_dir="$HOME/.scrcpy-devices"
    if [ -d "$devices_dir" ] && [ "$(ls -A $devices_dir 2>/dev/null)" ]; then
        devices=()
        for device in "$devices_dir"/*; do
            if [ -f "$device" ]; then
                name=$(basename "$device")
                ip=$(cat "$device")
                devices+=("$name ($ip)")
            fi
        done
        
        if [ ${#devices[@]} -gt 0 ]; then
            devices+=("Connect to new device")
            
            choice=$(zenity --list \
                --title="Select Device" \
                --text="Choose a device:" \
                --column="Device" \
                --height=300 \
                --width=400 \
                "${devices[@]}")
            
            if [ "$choice" = "Connect to new device" ]; then
                x-terminal-emulator -e "$MAIN_SCRIPT" &
            elif [ -n "$choice" ]; then
                device_name=$(echo "$choice" | cut -d' ' -f1)
                x-terminal-emulator -e "$MAIN_SCRIPT --device $device_name" &
            fi
        else
            x-terminal-emulator -e "$MAIN_SCRIPT" &
        fi
    else
        x-terminal-emulator -e "$MAIN_SCRIPT" &
    fi
    
    show_main_menu
}

# Connect with profile
connect_with_profile() {
    profile=$(zenity --list \
        --title="Select Profile" \
        --text="Choose a profile:" \
        --column="Profile" \
        --column="Description" \
        --height=300 \
        --width=500 \
        "gaming" "High FPS, low latency (120fps, 720p)" \
        "recording" "High quality (60fps, 1920p)" \
        "demo" "Borderless, always-on-top" \
        "battery" "Battery saver (30fps, 720p)")
    
    if [ -n "$profile" ]; then
        x-terminal-emulator -e "$MAIN_SCRIPT --profile $profile" &
    fi
    
    show_main_menu
}

# Manage devices
manage_devices() {
    action=$(zenity --list \
        --title="Manage Devices" \
        --text="Choose an action:" \
        --column="Action" \
        --height=300 \
        --width=400 \
        "List Devices" \
        "Save Current Device" \
        "Remove Device" \
        "Back")
    
    case "$action" in
        "List Devices")
            devices_list=$("$MAIN_SCRIPT" --devices 2>&1)
            zenity --info \
                --title="Saved Devices" \
                --text="$devices_list" \
                --width=400
            manage_devices
            ;;
        "Save Current Device")
            name=$(zenity --entry \
                --title="Save Device" \
                --text="Enter device nickname:")
            if [ -n "$name" ]; then
                result=$("$MAIN_SCRIPT" --save "$name" 2>&1)
                zenity --info --text="$result"
            fi
            manage_devices
            ;;
        "Remove Device")
            devices_dir="$HOME/.scrcpy-devices"
            if [ -d "$devices_dir" ] && [ "$(ls -A $devices_dir 2>/dev/null)" ]; then
                devices=()
                for device in "$devices_dir"/*; do
                    [ -f "$device" ] && devices+=("$(basename "$device")")
                done
                
                if [ ${#devices[@]} -gt 0 ]; then
                    device=$(zenity --list \
                        --title="Remove Device" \
                        --text="Select device to remove:" \
                        --column="Device" \
                        --height=300 \
                        "${devices[@]}")
                    
                    if [ -n "$device" ]; then
                        result=$("$MAIN_SCRIPT" --remove "$device" 2>&1)
                        zenity --info --text="$result"
                    fi
                fi
            else
                zenity --info --text="No saved devices"
            fi
            manage_devices
            ;;
        "Back")
            show_main_menu
            ;;
    esac
}

# Monitor connection
monitor_connection() {
    zenity --question \
        --title="Monitor Connection" \
        --text="Start connection monitoring?\n\nThis will auto-reconnect if connection drops." \
        --width=400
    
    if [ $? -eq 0 ]; then
        x-terminal-emulator -e "$MAIN_SCRIPT --monitor" &
    fi
    
    show_main_menu
}

# Daemon control
daemon_control() {
    # Check daemon status
    status=$("$MAIN_SCRIPT" --status 2>&1)
    
    if echo "$status" | grep -q "running"; then
        action=$(zenity --list \
            --title="Daemon Control" \
            --text="Daemon is running\n\nChoose an action:" \
            --column="Action" \
            --height=250 \
            "Stop Daemon" \
            "View Status" \
            "Back")
        
        case "$action" in
            "Stop Daemon")
                result=$("$MAIN_SCRIPT" --stop 2>&1)
                zenity --info --text="$result"
                daemon_control
                ;;
            "View Status")
                zenity --info --text="$status" --width=400
                daemon_control
                ;;
            "Back")
                show_main_menu
                ;;
        esac
    else
        zenity --question \
            --title="Daemon Control" \
            --text="Daemon is not running\n\nStart daemon?" \
            --width=400
        
        if [ $? -eq 0 ]; then
            result=$("$MAIN_SCRIPT" --daemon 2>&1)
            zenity --info --text="$result" --width=400
        fi
        
        show_main_menu
    fi
}

# View logs
view_logs() {
    log_file="$HOME/.scrcpy-smart.log"
    if [ -f "$log_file" ]; then
        zenity --text-info \
            --title="Connection Logs" \
            --filename="$log_file" \
            --width=600 \
            --height=400
    else
        zenity --info --text="No logs found"
    fi
    
    show_main_menu
}

# Settings
show_settings() {
    config_file="$HOME/.scrcpy-smart.conf"
    
    if [ -f "$config_file" ]; then
        zenity --text-info \
            --title="Settings" \
            --filename="$config_file" \
            --editable \
            --width=600 \
            --height=400 > /tmp/scrcpy-config.tmp
        
        if [ $? -eq 0 ]; then
            mv /tmp/scrcpy-config.tmp "$config_file"
            zenity --info --text="Settings saved!"
        fi
    else
        zenity --info \
            --text="No config file found\n\nCreate ~/.scrcpy-smart.conf to customize settings" \
            --width=400
    fi
    
    show_main_menu
}

# About
show_about() {
    zenity --info \
        --title="About Scrcpy Smart Connect" \
        --text="Scrcpy Smart Connect v$VERSION\n\nSmart wireless connection manager for scrcpy\n\nFeatures:\n• Auto-reconnect\n• Device profiles\n• Multi-device management\n• Background daemon\n• Connection monitoring\n\nGitHub: github.com/tareq-alomari/scrcpy-smart\nLicense: MIT" \
        --width=400
    
    show_main_menu
}

# Start
show_main_menu
