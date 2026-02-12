# Changelog

All notable changes to this project will be documented in this file.

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
