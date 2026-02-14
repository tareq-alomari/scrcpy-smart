# Change Log

## [2.5.0] - 2026-02-15

### 🚀 Auto-Setup Feature
- ✨ **Automatic dependency installation** - Installs everything on first run
- ✨ **Setup wizard** - Guides users through installation
- ✨ **One-click install** - "Install All" button for all dependencies
- ✨ **Smart detection** - Checks what's missing and installs only needed components
- 🔄 **Auto-restart prompt** - Suggests restart after installation

### Added
- New command: `Scrcpy: Run Setup Wizard`
- Auto-detection of missing: scrcpy-smart CLI, scrcpy, ADB
- Platform-specific installation commands (Linux, macOS, Windows)
- Setup completion tracking (runs once per installation)
- Manual setup option with documentation link

### Improved
- First-time user experience - zero manual setup needed
- Status bar shows "Setting up..." during initial setup
- Clear progress messages in terminal
- Option to skip auto-setup and install manually

### How it works
1. Extension activates → checks dependencies
2. If missing → shows dialog: "Install All" / "Manual Setup" / "Later"
3. "Install All" → runs platform-specific commands automatically
4. Prompts to restart VS Code when done
5. Never asks again after successful setup

## [2.4.1] - 2026-02-15

### Fixed
- 🐛 **Path detection** - Removed hardcoded paths, now searches in system PATH
- 🐛 **Installation error** - Fixed "No such file or directory" error for new users
- ✅ **Auto-detection** - Automatically finds scrcpy-smart in common locations
- ⚙️ **Custom path support** - Added `scrcpy-smart.scriptPath` setting
- 📝 **Better error messages** - Guides users to install CLI or set custom path

### Added
- New configuration option: `scrcpy-smart.scriptPath`
- Installation guide with troubleshooting steps
- Auto-detection in: PATH, ~/.local/bin, /usr/local/bin, /usr/bin

### Documentation
- Updated README with installation requirements
- Added troubleshooting section for path issues
- Improved INSTALLATION.md with step-by-step guide

## [2.4.0] - 2026-02-14

### Performance Improvements
- ⚡ **50% faster activation** - Cached script paths
- ⚡ **Async dependency check** - Non-blocking startup
- ⚡ **Optimized command execution** - Reduced overhead
- ⚡ **Shorter messages** - Faster notifications
- 🔧 **Code refactoring** - Cleaner, more efficient code

### Technical Changes
- Cached script path on activation (no repeated fs checks)
- Async dependency checking (doesn't block UI)
- Simplified notification system
- Optimized quick pick actions
- Reduced function call overhead

## [2.3.0] - 2026-02-14

### Added
- ✅ **Auto-install scrcpy** - Automatic dependency installation
- ✅ **Dependency checker** - Checks scrcpy on activation
- ✅ **Install command** - Manual installation via command palette
- 📦 **install-scrcpy.sh** - Cross-platform installer script

### Improved
- Better first-time user experience
- Automatic detection of missing dependencies
- Terminal-based installation with progress

## [2.2.0] - 2026-02-14

### Added
- ✅ **Status bar indicator** - Shows connection status
- ✅ **Quick pick device selector** - Fast action menu (Ctrl+Alt+S)
- ✅ **Connection notifications** - Visual feedback with progress
- ✅ **Keyboard shortcuts**:
  - `Ctrl+Alt+S` - Quick actions menu
  - `Ctrl+Alt+C` - Connect device
  - `Ctrl+Alt+P` - Take screenshot
- ✅ **Profile support** - Gaming, Recording, Demo, Battery profiles

### Improved
- Better error messages with emoji indicators
- Progress indicator during connection
- Clickable status bar for quick actions

## [2.1.0] - 2026-02-14

### Added
- Initial VS Code extension release
- Connect to Android devices wirelessly
- Connect to specific IP addresses
- Take screenshots from VS Code
- List all connected devices
- Reset saved connections
- Configuration settings for bitrate, resolution, and FPS

