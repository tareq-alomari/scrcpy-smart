# 🚀 Scrcpy Smart Connect

Smart wireless connection manager for [scrcpy](https://github.com/Genymobile/scrcpy) - automatically connects to Android devices via WiFi with USB fallback.

## ✨ Features

- 🔄 **Auto-reconnect**: Remembers your device IP and connects wirelessly
- 📱 **USB Fallback**: Automatically falls back to USB if wireless fails
- 🎯 **Smart Device Selection**: Prefers wireless over USB when both are available
- ⚡ **Optimized Performance**: Pre-configured for 60 FPS and balanced quality
- 💾 **IP Persistence**: Saves device IP for future connections

## 📋 Requirements

- Linux (Ubuntu/Debian tested)
- [scrcpy](https://github.com/Genymobile/scrcpy) installed
- [ADB](https://developer.android.com/tools/adb) installed
- Android device with USB debugging enabled

## 🚀 Installation

```bash
git clone https://github.com/YOUR_USERNAME/scrcpy-smart.git
cd scrcpy-smart
chmod +x scrcpy-smart.sh
```

### Optional: Add to PATH

```bash
echo 'alias phone="$HOME/scrcpy-smart/scrcpy-smart.sh"' >> ~/.bashrc
source ~/.bashrc
```

## 📖 Usage

### First Time (USB Required)

1. Connect your Android device via USB
2. Enable USB debugging on your device
3. Run the script:

```bash
./scrcpy-smart.sh
```

The script will:
- Detect your device
- Get its IP address
- Switch to wireless mode
- Save the IP for future use

### Subsequent Uses

Simply run:

```bash
./scrcpy-smart.sh
```

No USB cable needed! The script will connect wirelessly using the saved IP.

### If You Changed WiFi Network

Connect via USB once and run the script again to update the saved IP.

## ⚙️ Configuration

The script saves the device IP in `~/.scrcpy-config`. You can manually edit this file if needed.

### Performance Tuning

Edit the scrcpy parameters in the script:

```bash
scrcpy -s "$SAVED_IP:5555" --max-size 1024 --bit-rate 8M --max-fps 60
```

- `--max-size`: Resolution (lower = better performance)
- `--bit-rate`: Quality (4M-8M recommended)
- `--max-fps`: Frame rate (30-60)

## 🐛 Troubleshooting

**Connection fails:**
- Ensure device and computer are on the same WiFi network
- Check that USB debugging is enabled
- Try restarting ADB: `adb kill-server && adb start-server`

**Lag or stuttering:**
- Lower `--bit-rate` to 4M
- Reduce `--max-size` to 720
- Check WiFi signal strength

**IP not detected:**
- The script assumes WiFi interface is `wlan0`
- Check your interface: `adb shell ip addr`
- Modify the script if using different interface

## 🤝 Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

## 📄 License

MIT License - see [LICENSE](LICENSE) file for details.

## 🙏 Credits

- [scrcpy](https://github.com/Genymobile/scrcpy) by Genymobile
- Developed for Flutter/mobile developers who need efficient wireless debugging

## 💡 Use Cases

- Flutter development with hot reload
- Mobile app testing
- Screen recording/streaming
- Remote device control
- Wireless debugging sessions
