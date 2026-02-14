#!/bin/bash
# Auto-installer for scrcpy dependencies

set -e

echo "🔍 Checking scrcpy installation..."

# Check if scrcpy is installed
if command -v scrcpy &> /dev/null; then
    echo "✅ scrcpy is already installed: $(scrcpy --version | head -1)"
    exit 0
fi

echo "📦 scrcpy not found. Installing..."

# Detect OS
if [[ "$OSTYPE" == "linux-gnu"* ]]; then
    # Linux
    if command -v apt &> /dev/null; then
        echo "🐧 Detected Ubuntu/Debian"
        sudo apt update
        sudo apt install -y scrcpy adb
    elif command -v dnf &> /dev/null; then
        echo "🐧 Detected Fedora"
        sudo dnf install -y scrcpy android-tools
    elif command -v pacman &> /dev/null; then
        echo "🐧 Detected Arch Linux"
        sudo pacman -S --noconfirm scrcpy android-tools
    elif command -v zypper &> /dev/null; then
        echo "🐧 Detected openSUSE"
        sudo zypper install -y scrcpy android-tools
    else
        echo "❌ Unsupported Linux distribution"
        echo "Please install manually: https://github.com/Genymobile/scrcpy"
        exit 1
    fi
elif [[ "$OSTYPE" == "darwin"* ]]; then
    # macOS
    echo "🍎 Detected macOS"
    if ! command -v brew &> /dev/null; then
        echo "❌ Homebrew not found. Installing Homebrew first..."
        /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    fi
    brew install scrcpy android-platform-tools
elif [[ "$OSTYPE" == "msys" || "$OSTYPE" == "cygwin" ]]; then
    # Windows (Git Bash/WSL)
    echo "🪟 Detected Windows"
    if command -v winget &> /dev/null; then
        echo "Using winget..."
        winget install --id Genymobile.scrcpy
        winget install --id Google.PlatformTools
    elif command -v choco &> /dev/null; then
        echo "Using Chocolatey..."
        choco install scrcpy adb -y
    elif command -v scoop &> /dev/null; then
        echo "Using Scoop..."
        scoop install scrcpy adb
    else
        echo "❌ No package manager found (winget/choco/scoop)"
        echo "Please install manually:"
        echo "  scrcpy: https://github.com/Genymobile/scrcpy/releases"
        echo "  ADB: https://developer.android.com/tools/adb"
        exit 1
    fi
else
    echo "❌ Unsupported OS: $OSTYPE"
    echo "Please install manually: https://github.com/Genymobile/scrcpy"
    exit 1
fi

echo "✅ scrcpy installed successfully!"
scrcpy --version || echo "⚠️ Please restart your terminal"
