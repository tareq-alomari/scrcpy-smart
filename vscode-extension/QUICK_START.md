# 🚀 Quick Start - VS Code Extension

## Install Extension

```bash
code --install-extension scrcpy-smart-2.1.0.vsix
```

## Use Extension

1. Press `Ctrl+Shift+P`
2. Type "Scrcpy"
3. Choose command:
   - **Connect Device** - Connect to Android
   - **Connect to IP** - Enter IP address
   - **Take Screenshot** - Capture screen
   - **List Devices** - Show all devices
   - **Reset Connection** - Clear saved IP

## Settings

`Ctrl+,` → Search "scrcpy"

- **Bitrate**: Video quality (4M, 8M, 16M)
- **Max Size**: Resolution (720, 1024, 1920)
- **Max FPS**: Frame rate (30, 60)

## Requirements

```bash
# Install scrcpy-smart first
curl -fsSL https://raw.githubusercontent.com/tareq-alomari/scrcpy-smart/main/install.sh | bash
```

## Test

1. Connect Android device via USB
2. Enable USB debugging
3. Open VS Code
4. Run: `Scrcpy: Connect Device`

Done! 🎉
