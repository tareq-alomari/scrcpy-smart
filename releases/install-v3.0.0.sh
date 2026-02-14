#!/bin/bash

set -e

GREEN="\e[32m"
CYAN="\e[36m"
YELLOW="\e[33m"
RED="\e[31m"
RESET="\e[0m"

echo -e "${CYAN}🚀 Scrcpy Smart Connect Installer${RESET}\n"

# Detect OS
OS="$(uname -s)"
case "$OS" in
    Linux*)     OS_TYPE="Linux";;
    Darwin*)    OS_TYPE="macOS";;
    CYGWIN*|MINGW*|MSYS*) OS_TYPE="Windows";;
    *)          
        echo -e "${RED}Unsupported OS: $OS${RESET}"
        exit 1
        ;;
esac

echo -e "${CYAN}Detected OS: $OS_TYPE${RESET}\n"

# Check dependencies
check_dependency() {
    if ! command -v $1 &> /dev/null; then
        echo -e "${RED}❌ $1 is not installed${RESET}"
        return 1
    else
        echo -e "${GREEN}✅ $1 found${RESET}"
        return 0
    fi
}

echo "Checking dependencies..."
MISSING=0

if ! check_dependency adb; then
    MISSING=1
    echo -e "${YELLOW}Install: https://developer.android.com/tools/adb${RESET}"
fi

if ! check_dependency scrcpy; then
    MISSING=1
    if [ "$OS_TYPE" = "Linux" ]; then
        echo -e "${YELLOW}Install: sudo apt install scrcpy${RESET}"
    elif [ "$OS_TYPE" = "macOS" ]; then
        echo -e "${YELLOW}Install: brew install scrcpy${RESET}"
    fi
fi

if [ $MISSING -eq 1 ]; then
    echo -e "\n${RED}Please install missing dependencies first${RESET}"
    exit 1
fi

# Install script
INSTALL_DIR="$HOME/.local/bin"
mkdir -p "$INSTALL_DIR"

echo -e "\n${YELLOW}Installing to $INSTALL_DIR...${RESET}"
cp scrcpy-smart.sh "$INSTALL_DIR/scrcpy-smart"
chmod +x "$INSTALL_DIR/scrcpy-smart"

# Add to PATH
SHELL_RC=""
if [ -f "$HOME/.bashrc" ]; then
    SHELL_RC="$HOME/.bashrc"
elif [ -f "$HOME/.zshrc" ]; then
    SHELL_RC="$HOME/.zshrc"
fi

if [ -n "$SHELL_RC" ]; then
    if ! grep -q "$INSTALL_DIR" "$SHELL_RC"; then
        echo -e "\n${YELLOW}Adding to PATH in $SHELL_RC...${RESET}"
        echo "" >> "$SHELL_RC"
        echo "# Scrcpy Smart Connect" >> "$SHELL_RC"
        echo 'export PATH="$HOME/.local/bin:$PATH"' >> "$SHELL_RC"
        echo 'alias phone="scrcpy-smart"' >> "$SHELL_RC"
        
        echo -e "${GREEN}✅ Added to PATH${RESET}"
        echo -e "${YELLOW}Run: source $SHELL_RC${RESET}"
    else
        echo -e "${GREEN}✅ Already in PATH${RESET}"
    fi
fi

echo -e "\n${GREEN}🎉 Installation complete!${RESET}"
echo -e "\nUsage:"
echo -e "  ${CYAN}scrcpy-smart${RESET}        # Connect to device"
echo -e "  ${CYAN}phone${RESET}               # Shortcut alias"
echo -e "  ${CYAN}scrcpy-smart --help${RESET} # Show all options"
echo -e "\nRestart your terminal or run: ${YELLOW}source $SHELL_RC${RESET}"
