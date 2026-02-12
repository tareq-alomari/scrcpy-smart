# Changelog

All notable changes to this project will be documented in this file.

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
