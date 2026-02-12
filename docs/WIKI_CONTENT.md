# Wiki Content Structure

## Home

Welcome to Scrcpy Smart Connect wiki!

### Quick Links
- [Installation Guide](Installation)
- [Usage Guide](Usage)
- [Troubleshooting](Troubleshooting)
- [FAQ](FAQ)
- [Performance Tuning](Performance-Tuning)
- [Advanced Usage](Advanced-Usage)

---

## Installation

### Prerequisites
- scrcpy installed
- ADB installed
- Android device with USB debugging

### Linux (Ubuntu/Debian)
```bash
sudo apt install scrcpy adb
git clone https://github.com/tareq-alomari/scrcpy-smart.git
cd scrcpy-smart
./install.sh
```

### macOS
```bash
brew install scrcpy android-platform-tools
git clone https://github.com/tareq-alomari/scrcpy-smart.git
cd scrcpy-smart
./install.sh
```

### Windows (WSL/Git Bash)
```bash
# Install scrcpy and ADB first
git clone https://github.com/tareq-alomari/scrcpy-smart.git
cd scrcpy-smart
./install.sh
```

---

## Usage

### First Time Setup
1. Connect Android device via USB
2. Enable USB debugging
3. Run: `scrcpy-smart` or `phone`
4. Disconnect USB when prompted

### Daily Usage
```bash
phone  # Just this!
```

### Command Options
```bash
phone --help      # Show help
phone --version   # Show version
phone --config    # Show config
phone --reset     # Reset IP
phone --list      # List devices
phone --select    # Select device
```

---

## Troubleshooting

### Connection Fails
**Problem:** Cannot connect wirelessly

**Solutions:**
1. Ensure same WiFi network
2. Check USB debugging enabled
3. Reset: `phone --reset`
4. Restart ADB: `adb kill-server && adb start-server`

### Lag/Stuttering
**Problem:** Screen lags or stutters

**Solutions:**
1. Lower bitrate: Edit script, change `--bit-rate 8M` to `4M`
2. Reduce resolution: Change `--max-size 1024` to `720`
3. Use 5GHz WiFi
4. Check WiFi signal strength

### IP Not Detected
**Problem:** Script can't detect device IP

**Solutions:**
1. Check WiFi interface: `adb shell ip addr`
2. Manually edit `~/.scrcpy-config` with device IP
3. Use USB mode

### Multiple Devices
**Problem:** Multiple devices connected

**Solutions:**
1. List devices: `phone --list`
2. Select specific: `phone --select`

---

## FAQ

### Q: Do I need USB every time?
**A:** No! Only first time or when changing WiFi network.

### Q: Does it work on Windows?
**A:** Yes, via WSL or Git Bash.

### Q: Can I use multiple devices?
**A:** Yes! Use `phone --select` to choose.

### Q: What if WiFi is slow?
**A:** Lower bitrate and resolution in the script.

### Q: Is it secure?
**A:** Uses standard ADB connection. Same security as USB.

### Q: Does it drain battery?
**A:** Similar to USB. You can add `--turn-screen-off` to save battery.

### Q: Can I record screen?
**A:** Yes! scrcpy has built-in recording: `scrcpy --record file.mp4`

---

## Performance Tuning

### Presets

#### Low Performance (Weak WiFi)
```bash
--max-size 720 --bit-rate 2M --max-fps 30
```

#### Balanced (Default)
```bash
--max-size 1024 --bit-rate 8M --max-fps 60
```

#### High Quality (Strong WiFi)
```bash
--max-size 1920 --bit-rate 16M --max-fps 60
```

### Custom Options

Edit `scrcpy-smart.sh` and modify the scrcpy command:

```bash
scrcpy -s "$SAVED_IP:5555" \
  --max-size 1024 \
  --bit-rate 8M \
  --max-fps 60 \
  --turn-screen-off \    # Turn off device screen
  --stay-awake \         # Keep device awake
  --show-touches         # Show touch points
```

### Network Optimization
- Use 5GHz WiFi when possible
- Reduce interference (move closer to router)
- Close bandwidth-heavy apps
- Use QoS on router for ADB traffic

---

## Advanced Usage

### Custom Alias
```bash
# Add to ~/.bashrc or ~/.zshrc
alias dev-phone="scrcpy-smart"
alias phone-record="scrcpy-smart --record ~/recording.mp4"
```

### Multiple Devices Workflow
```bash
# Save different configs
phone --select  # Choose device 1
mv ~/.scrcpy-config ~/.scrcpy-device1

phone --select  # Choose device 2
mv ~/.scrcpy-config ~/.scrcpy-device2

# Switch between devices
cp ~/.scrcpy-device1 ~/.scrcpy-config && phone
cp ~/.scrcpy-device2 ~/.scrcpy-config && phone
```

### Integration with IDE
Add to VS Code tasks.json:
```json
{
  "label": "Connect Phone",
  "type": "shell",
  "command": "scrcpy-smart",
  "problemMatcher": []
}
```

### Automation
```bash
# Auto-connect on boot
echo "@reboot sleep 30 && /home/user/.local/bin/scrcpy-smart" | crontab -
```

### Custom scrcpy Options
```bash
# Gaming mode
scrcpy --fullscreen --max-fps 120

# Presentation mode
scrcpy --window-borderless --always-on-top

# Recording mode
scrcpy --no-display --record output.mp4
```

---

## Contributing

See [CONTRIBUTING.md](../CONTRIBUTING.md)

---

## Changelog

See [CHANGELOG.md](../CHANGELOG.md)
