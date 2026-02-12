# 🚀 Scrcpy Smart Connect

<div align="center">

[![GitHub release](https://img.shields.io/github/v/release/tareq-alomari/scrcpy-smart)](https://github.com/tareq-alomari/scrcpy-smart/releases)
[![CI](https://github.com/tareq-alomari/scrcpy-smart/workflows/CI/badge.svg)](https://github.com/tareq-alomari/scrcpy-smart/actions)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
[![Platform](https://img.shields.io/badge/platform-Linux%20%7C%20macOS%20%7C%20Windows-blue)](https://github.com/tareq-alomari/scrcpy-smart)
[![Shell](https://img.shields.io/badge/shell-bash-green)](https://www.gnu.org/software/bash/)

**Smart wireless connection manager for scrcpy - Connect to Android devices via WiFi automatically**

[English](README.md) · [العربية](docs/README.ar.md) · [Español](docs/README.es.md) · [中文](docs/README.zh.md)

[Features](#-features) • [Installation](#-quick-install) • [Usage](#-usage) • [Documentation](https://github.com/tareq-alomari/scrcpy-smart/wiki)

</div>

---

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

- [scrcpy](https://github.com/Genymobile/scrcpy) - Screen mirroring tool
- [ADB](https://developer.android.com/tools/adb) - Android Debug Bridge
- Android device with USB debugging enabled

### Installation by OS

<details>
<summary><b>Linux (Ubuntu/Debian)</b></summary>

```bash
sudo apt install scrcpy adb
```
</details>

<details>
<summary><b>macOS</b></summary>

```bash
brew install scrcpy android-platform-tools
```
</details>

<details>
<summary><b>Windows</b></summary>

- Install [scrcpy](https://github.com/Genymobile/scrcpy#windows)
- Install [ADB](https://developer.android.com/tools/adb)
</details>

## 🚀 Quick Install

```bash
git clone https://github.com/tareq-alomari/scrcpy-smart.git
cd scrcpy-smart
./install.sh
```

Or one-liner:
```bash
curl -fsSL https://raw.githubusercontent.com/tareq-alomari/scrcpy-smart/main/install.sh | bash
```

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
scrcpy-smart --verbose   # Verbose mode
```

### Device Profiles

Choose optimized settings for different use cases:

```bash
# Gaming - High FPS, low latency
scrcpy-smart --profile gaming

# Recording - High quality
scrcpy-smart --profile recording

# Demo/Presentation - Borderless, always-on-top
scrcpy-smart --profile demo

# Battery Saver - Low power consumption
scrcpy-smart --profile battery
```

### Quick Options

```bash
# Fullscreen mode
scrcpy-smart --fullscreen

# Record to file
scrcpy-smart --record demo.mp4

# Combine options
scrcpy-smart --profile gaming --fullscreen
```

### Multi-Device Management

Save and manage multiple devices with nicknames:

```bash
# Save current device
scrcpy-smart --save myphone

# Save another device
scrcpy-smart --save tablet

# List all saved devices
scrcpy-smart --devices

# Connect to specific device
scrcpy-smart --device myphone

# Connect with profile
scrcpy-smart --device tablet --profile recording

# Remove device
scrcpy-smart --remove myphone
```

**Use Cases:**
- Manage work and personal phones
- Quick switch between test devices
- Organize multiple tablets
- Team device sharing

### First Time Setup

1. Connect your Android device via USB
2. Enable USB debugging on your device
3. Run: `scrcpy-smart`

The script will:
- ✅ Detect your device
- ✅ Get its IP address
- ✅ Switch to wireless mode
- ✅ Save the IP for future use

### Subsequent Uses

Simply run `scrcpy-smart` or `phone` - **no USB cable needed!**

## ⚙️ Configuration

### Config File

Create `~/.scrcpy-smart.conf` to customize defaults:

```bash
# Copy example config
cp .scrcpy-smart.conf.example ~/.scrcpy-smart.conf

# Edit settings
nano ~/.scrcpy-smart.conf
```

**Example config:**
```bash
DEFAULT_BITRATE=8M      # Video bitrate
DEFAULT_SIZE=1024       # Max resolution
DEFAULT_FPS=60          # Max FPS
VERBOSE=false           # Debug logging
```

### Device IP

Configuration is saved in `~/.scrcpy-config`

### Performance Tuning

Edit `scrcpy-smart.sh` and modify scrcpy parameters:

```bash
scrcpy -s "$SAVED_IP:5555" --max-size 1024 --bit-rate 8M --max-fps 60
```

**Presets:**

| Preset | Resolution | Bitrate | FPS | Use Case |
|--------|-----------|---------|-----|----------|
| Performance | 720 | 4M | 30 | Weak WiFi |
| Balanced | 1024 | 8M | 60 | Default |
| Quality | 1920 | 16M | 60 | Strong WiFi |

## 🐛 Troubleshooting

<details>
<summary><b>Connection fails</b></summary>

- Ensure device and computer are on same WiFi
- Check USB debugging is enabled
- Try: `scrcpy-smart --reset`
- Restart ADB: `adb kill-server && adb start-server`
</details>

<details>
<summary><b>Lag or stuttering</b></summary>

- Lower bitrate: `--bit-rate 4M`
- Reduce resolution: `--max-size 720`
- Check WiFi signal strength
- Use 5GHz WiFi if available
</details>

<details>
<summary><b>Multiple devices</b></summary>

- Use: `scrcpy-smart --list` to see all
- Use: `scrcpy-smart --select` to choose
</details>

## 📚 Documentation

- [Wiki](https://github.com/tareq-alomari/scrcpy-smart/wiki) - Detailed documentation
- [FAQ](https://github.com/tareq-alomari/scrcpy-smart/wiki/FAQ) - Frequently asked questions
- [Troubleshooting](https://github.com/tareq-alomari/scrcpy-smart/wiki/Troubleshooting) - Common issues

## 🤝 Contributing

Contributions are welcome! Please:

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/amazing`)
3. Commit your changes (`git commit -m 'Add amazing feature'`)
4. Push to the branch (`git push origin feature/amazing`)
5. Open a Pull Request

## 📄 License

MIT License - see [LICENSE](LICENSE) file for details.

## 🙏 Credits

- [scrcpy](https://github.com/Genymobile/scrcpy) by Genymobile - The amazing screen mirroring tool
- Developed by [Tareq Alomari](https://github.com/tareq-alomari)

## 💡 Use Cases

- 📱 Flutter/React Native development with hot reload
- 🧪 Mobile app testing and debugging
- 🎥 Screen recording and streaming
- 🎮 Mobile gaming on PC
- 🖥️ Remote device control
- 📊 Presentations and demos

## ⭐ Star History

[![Star History Chart](https://api.star-history.com/svg?repos=tareq-alomari/scrcpy-smart&type=Date)](https://star-history.com/#tareq-alomari/scrcpy-smart&Date)

## 📊 Stats

![GitHub stars](https://img.shields.io/github/stars/tareq-alomari/scrcpy-smart?style=social)
![GitHub forks](https://img.shields.io/github/forks/tareq-alomari/scrcpy-smart?style=social)
![GitHub watchers](https://img.shields.io/github/watchers/tareq-alomari/scrcpy-smart?style=social)

---

<div align="center">

**Made with ❤️ for mobile developers**

[Report Bug](https://github.com/tareq-alomari/scrcpy-smart/issues) · [Request Feature](https://github.com/tareq-alomari/scrcpy-smart/issues)

</div>
