# Changelog

All notable changes to this project will be documented in this file.

## [2.1.0] - 2026-02-13

### Added
- **Device Rename**: Rename saved devices (`--rename OLD NEW`)
- **Clear Logs**: Clear connection logs (`--clear-logs`)
- **Screenshot**: Take screenshot and exit (`--screenshot`)
- **Custom Port**: Use custom ADB port (`--port PORT`)
- **Direct IP**: Connect to specific IP (`--ip IP`)
- **No Audio**: Disable audio forwarding (`--no-audio`)

### Enhanced
- More flexible device management
- Better command-line options
- Improved help documentation

### Use Cases
- Rename devices for better organization
- Take quick screenshots without GUI
- Use custom ADB ports
- Connect to specific IPs directly

## [2.0.0] - 2026-02-13

### Added
- **GUI Mode**: Optional graphical interface using zenity
- **Desktop Integration**: .desktop file for application menu
- **Visual Device Management**: GUI for all operations
- **GUI Features**:
  - Device selection dialog
  - Profile chooser with descriptions
  - Device management (save/remove)
  - Daemon control panel
  - Settings editor
  - Connection logs viewer
  - About dialog

### Changed
- Major version bump for GUI addition
- Enhanced user experience for non-CLI users
- Desktop environment integration

### Features
- Launch with `scrcpy-smart-gui.sh`
- Install to application menu
- Visual feedback for all operations
- No terminal required for basic usage

## [1.5.0] - 2026-02-13

### Added
- **Auto-Reconnect Monitoring**: Monitor connection and auto-reconnect on disconnect
- **Background Daemon**: Run monitoring as background service
- **Connection Logging**: Track all connection events
- **Daemon Management**:
  - `--monitor` - Monitor connection with auto-reconnect
  - `--daemon` - Run as background daemon
  - `--stop` - Stop daemon
  - `--status` - Check daemon status
  - `--logs` - View connection logs

### Features
- Automatic reconnection on WiFi drops
- Configurable reconnect interval
- Connection event logging to `~/.scrcpy-smart.log`
- PID file management for daemon
- Graceful daemon start/stop

### Use Cases
- Long development sessions without interruption
- Unstable WiFi environments
- Automatic recovery from connection drops
- Background monitoring for always-on connections

## [1.4.0] - 2026-02-13

### Added
- **Multi-Device Management**: Save and manage multiple devices
- **Device Nicknames**: Give friendly names to your devices
- **Quick Device Switching**: Switch between saved devices instantly
- **Device Management Commands**:
  - `--save NAME` - Save current device with nickname
  - `--device NAME` - Connect to saved device
  - `--devices` - List all saved devices
  - `--remove NAME` - Remove saved device

### Features
- Devices stored in `~/.scrcpy-devices/`
- Easy switching between work phone, personal phone, tablet, etc.
- Persistent device storage
- Verbose logging for device operations

### Use Cases
- Manage multiple test devices
- Switch between personal and work phones
- Quick access to frequently used devices

## [1.3.0] - 2026-02-13

### Added
- **Device Profiles**: Gaming, Recording, Demo, Battery Saver
- **Config File Support**: `~/.scrcpy-smart.conf` for custom defaults
- **Verbose Mode**: `-V` or `--verbose` for debug logging
- **Quick Options**: `--fullscreen` and `--record FILE`
- **Better Help**: Detailed help with examples and profiles

### Changed
- Dynamic scrcpy parameters based on profile/config
- Improved logging with color-coded messages
- Better error handling and user feedback

### Features
- Gaming profile: 120fps, 720p, 4M bitrate, low latency
- Recording profile: 60fps, 1920p, 16M bitrate, high quality
- Demo profile: Borderless, always-on-top
- Battery saver profile: 30fps, 720p, 2M bitrate, screen off

## [1.2.0] - 2026-02-13

### Added
- GitHub Actions CI/CD workflows (automated testing and releases)
- Multilingual documentation (Arabic, Spanish, Chinese)
- SEO optimization with badges and keywords
- Issue templates (bug report, feature request)
- Contributing guidelines
- Enhanced README with better formatting and sections
- Star history chart
- Community health files

### Improved
- README structure with collapsible sections
- Documentation organization
- Project discoverability

## [1.1.0] - 2026-02-13

### Added
- Command-line options (--help, --version, --config, --reset, --list, --select)
- Cross-platform support (Linux, macOS, Windows)
- Automatic OS detection
- Multiple device selection
- Installer script with dependency checking
- Automatic PATH configuration
- Enhanced IP detection with fallback methods

### Changed
- Improved error handling
- Better user feedback with detailed messages
- More robust IP detection for different OS

### Fixed
- macOS compatibility issues with grep
- IP detection on different WiFi interfaces

## [1.0.0] - 2026-02-13

### Added
- Initial release
- Automatic wireless connection with IP persistence
- USB fallback mechanism
- Smart device selection (prefers wireless over USB)
- Optimized scrcpy parameters for performance
- Color-coded terminal output
- IP address auto-detection from wlan0 interface

### Features
- Saves device IP in `~/.scrcpy-config`
- Automatic reconnection on subsequent runs
- Graceful fallback to USB when wireless fails
- Pre-configured for 60 FPS, 1024p resolution, 8M bitrate
