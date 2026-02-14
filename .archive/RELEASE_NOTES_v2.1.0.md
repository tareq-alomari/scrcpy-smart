# Release v2.1.0 - Enhanced Device Management

## 🎉 New Features

### Device Management
- **Device Rename** (`--rename OLD NEW`): Rename saved devices for better organization
  ```bash
  scrcpy-smart --rename myphone work-phone
  ```

### Network Options
- **Custom ADB Port** (`--port PORT`): Support for custom ADB ports
  ```bash
  scrcpy-smart --port 5556
  ```
- **Direct IP Connection** (`--ip IP`): Connect to specific IP addresses directly
  ```bash
  scrcpy-smart --ip 192.168.1.100
  ```

### Quick Actions
- **Screenshot** (`--screenshot`): Take screenshot and exit without GUI
  ```bash
  scrcpy-smart --screenshot
  # Saves as: screenshot_YYYYMMDD_HHMMSS.png
  ```
- **No Audio** (`--no-audio`): Disable audio forwarding for better performance
  ```bash
  scrcpy-smart --no-audio
  ```

### Logging
- **Clear Logs** (`--clear-logs`): Clear connection logs easily
  ```bash
  scrcpy-smart --clear-logs
  ```

## 🔧 Improvements

- More flexible device management
- Enhanced command-line options
- Better help documentation
- Improved error messages

## 📖 Usage Examples

```bash
# Connect to specific IP with custom port
scrcpy-smart --ip 192.168.1.100 --port 5556

# Take screenshot from saved device
scrcpy-smart --device myphone --screenshot

# Connect without audio for better performance
scrcpy-smart --profile gaming --no-audio

# Rename device for better organization
scrcpy-smart --rename old-name new-name
```

## 🐛 Bug Fixes

- Fixed IP detection on some network configurations
- Improved error handling for custom ports
- Better validation for device names

## 📚 Documentation

- Updated README with new features
- Enhanced help messages
- Added more usage examples

## 🙏 Thanks

Thanks to all contributors and users who provided feedback!

---

**Full Changelog**: https://github.com/tareq-alomari/scrcpy-smart/compare/v2.0.0...v2.1.0
