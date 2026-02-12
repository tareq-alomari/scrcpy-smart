# 🚀 Scrcpy Smart Connect

Smart wireless connection manager for [scrcpy](https://github.com/Genymobile/scrcpy) - automatically connects to Android devices via WiFi with USB fallback.

## ✨ Features

- 🔄 **Auto-reconnect**: Remembers your device IP and connects wirelessly
- 📱 **USB Fallback**: Automatically falls back to USB if wireless fails
- 🎯 **Smart Device Selection**: Prefers wireless over USB when both are available
- ⚡ **Optimized Performance**: Pre-configured for 60 FPS and balanced quality
- 💾 **IP Persistence**: Saves device IP for future connections
- 🖥️ **Cross-Platform**: Works on Linux, macOS, and Windows (WSL/Git Bash)
- 🛠️ **CLI Options**: Full command-line interface with multiple options
- 📱 **Multiple Devices**: Select from multiple connected devices

## 📋 Requirements

- [scrcpy](https://github.com/Genymobile/scrcpy) installed
- [ADB](https://developer.android.com/tools/adb) installed
- Android device with USB debugging enabled

### Installation by OS

**Linux (Ubuntu/Debian):**
```bash
sudo apt install scrcpy adb
```

**macOS:**
```bash
brew install scrcpy android-platform-tools
```

**Windows:**
- Install [scrcpy](https://github.com/Genymobile/scrcpy#windows)
- Install [ADB](https://developer.android.com/tools/adb)

## 🚀 Quick Install

```bash
git clone https://github.com/tareq-alomari/scrcpy-smart.git
cd scrcpy-smart
./install.sh
```

The installer will:
- Check dependencies
- Install to `~/.local/bin`
- Add to your PATH
- Create `phone` alias

## 📖 Usage

### Basic Usage

```bash
scrcpy-smart        # Connect to device
phone               # Same using alias
```

### Command-Line Options

```bash
scrcpy-smart --help      # Show help
scrcpy-smart --version   # Show version
scrcpy-smart --config    # Show current config
scrcpy-smart --reset     # Reset saved IP
scrcpy-smart --list      # List all devices
scrcpy-smart --select    # Select device manually
```

### First Time Setup

1. Connect your Android device via USB
2. Enable USB debugging on your device
3. Run: `scrcpy-smart`

The script will:
- Detect your device
- Get its IP address
- Switch to wireless mode
- Save the IP for future use

### Subsequent Uses

Simply run `scrcpy-smart` or `phone` - no USB cable needed!

## ⚙️ Configuration

Configuration is saved in `~/.scrcpy-config`

### Performance Tuning

Edit `scrcpy-smart.sh` and modify scrcpy parameters:

```bash
scrcpy -s "$SAVED_IP:5555" --max-size 1024 --bit-rate 8M --max-fps 60
```

**Options:**
- `--max-size`: Resolution (720, 1024, 1920)
- `--bit-rate`: Quality (2M-8M)
- `--max-fps`: Frame rate (30, 60)

**For better performance:**
```bash
--max-size 720 --bit-rate 4M --max-fps 30
```

**For better quality:**
```bash
--max-size 1920 --bit-rate 16M --max-fps 60
```

## 🐛 Troubleshooting

**Connection fails:**
- Ensure device and computer are on same WiFi
- Check USB debugging is enabled
- Try: `scrcpy-smart --reset`

**Lag or stuttering:**
- Lower bitrate: `--bit-rate 4M`
- Reduce resolution: `--max-size 720`
- Check WiFi signal strength

**IP not detected:**
- Script assumes WiFi interface is `wlan0`
- Check: `adb shell ip addr`
- May need manual connection

**Multiple devices:**
- Use: `scrcpy-smart --list` to see all
- Use: `scrcpy-smart --select` to choose

## 🤝 Contributing

Contributions are welcome! Please:

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Submit a pull request

## 📄 License

MIT License - see [LICENSE](LICENSE) file for details.

## 🙏 Credits

- [scrcpy](https://github.com/Genymobile/scrcpy) by Genymobile
- Developed for Flutter/mobile developers

## 💡 Use Cases

- Flutter development with hot reload
- Mobile app testing
- Screen recording/streaming
- Remote device control
- Wireless debugging sessions
- Game streaming
- Presentations and demos

## 🔧 Advanced Usage

### Custom scrcpy options

Pass additional options by editing the script:

```bash
scrcpy -s "$IP:5555" \
  --max-size 1024 \
  --bit-rate 8M \
  --max-fps 60 \
  --turn-screen-off \
  --stay-awake
```

### Multiple devices workflow

```bash
# List devices
scrcpy-smart --list

# Select specific device
scrcpy-smart --select

# Reset and reconnect
scrcpy-smart --reset
```

## 📊 Changelog

See [CHANGELOG.md](CHANGELOG.md) for version history.
