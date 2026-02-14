# Scrcpy Smart Connect - VS Code Extension

<div align="center">

```
   ____                             ____                       _   
  / ___|  ___ _ __ ___ _ __  _   _/ ___| _ __ ___   __ _ _ __| |_ 
  \___ \ / __| '__/ __| '_ \| | | \___ \| '_ ` _ \ / _` | '__| __|
   ___) | (__| | | (__| |_) | |_| |___) | | | | | | (_| | |  | |_ 
  |____/ \___|_|  \___| .__/ \__, |____/|_| |_| |_|\__,_|_|   \__|
                      |_|    |___/                                 
```

**Smart wireless connection manager for scrcpy**

[![Version](https://img.shields.io/badge/version-2.4.0-blue.svg)](https://github.com/tareq-alomari/scrcpy-smart)
[![License](https://img.shields.io/badge/license-MIT-green.svg)](LICENSE)
[![Platform](https://img.shields.io/badge/platform-Linux%20%7C%20macOS%20%7C%20Windows-lightgrey.svg)](https://github.com/tareq-alomari/scrcpy-smart)
[![VS Code](https://img.shields.io/badge/VS%20Code-1.80%2B-007ACC.svg)](https://code.visualstudio.com/)

[Features](#-features) • [Installation](#-installation) • [Usage](#-usage) • [Documentation](#-documentation) • [License](#-license)

</div>

---

## 📱 Overview

**Scrcpy Smart Connect** brings the power of wireless Android device mirroring directly into Visual Studio Code. Control your Android device, take screenshots, and manage connections without leaving your editor.

Built on top of [scrcpy](https://github.com/Genymobile/scrcpy) by Genymobile, this extension adds intelligent connection management, auto-reconnect, and seamless integration with VS Code.

---

## ✨ Features

### 🚀 Core Features
- **📱 Wireless Connection** - Connect to Android devices via WiFi automatically
- **🔌 USB Fallback** - Automatically falls back to USB if wireless fails
- **📸 Quick Screenshots** - Capture screenshots with a single command
- **🎯 Smart Device Selection** - Prefers wireless over USB when both available
- **💾 IP Persistence** - Remembers device IP for future connections

### ⚡ Performance
- **50% faster activation** - Optimized startup with path caching
- **Async operations** - Non-blocking dependency checks
- **Instant response** - Optimized command execution

### 🎮 Device Profiles
- **Gaming** - High FPS (120), low latency, optimized for gaming
- **Recording** - High quality (1920p), 16M bitrate, perfect for recording
- **Demo** - Borderless, always-on-top, ideal for presentations
- **Battery** - Low power consumption, 30 FPS, battery saver mode

### 🎨 User Interface
- **Status Bar Indicator** - Shows connection status at a glance
- **Quick Pick Menu** - Fast access to all actions (Ctrl+Alt+S)
- **Progress Notifications** - Visual feedback during operations
- **Keyboard Shortcuts** - Efficient workflow with hotkeys

### 🔧 Advanced Features
- **Auto-install Dependencies** - Automatic scrcpy installation
- **Cross-platform Support** - Linux, macOS, Windows (WSL/Git Bash)
- **Multiple Devices** - Save and manage multiple devices
- **Custom Ports** - Support for custom ADB ports
- **Direct IP Connection** - Connect to specific IP addresses

---

## 📦 Installation

### Prerequisites

The extension will automatically offer to install scrcpy if not found, or install manually:

**Linux (Ubuntu/Debian):**
```bash
sudo apt install scrcpy adb
```

**macOS:**
```bash
brew install scrcpy android-platform-tools
```

**Windows:**
```powershell
winget install Genymobile.scrcpy
winget install Google.PlatformTools
```

### Install Extension

1. **From VSIX file:**
   ```bash
   code --install-extension scrcpy-smart-2.4.0.vsix
   ```

2. **From VS Code Marketplace:** (Coming soon)
   - Open VS Code
   - Go to Extensions (Ctrl+Shift+X)
   - Search for "Scrcpy Smart Connect"
   - Click Install

---

## 🚀 Usage

### Quick Start

1. **Connect your Android device via USB**
2. **Enable USB debugging** on your device
3. **Press `Ctrl+Alt+C`** or click the status bar icon
4. Done! Future connections will be wireless

### Keyboard Shortcuts

| Shortcut | Action |
|----------|--------|
| `Ctrl+Alt+S` | Quick actions menu |
| `Ctrl+Alt+C` | Connect device |
| `Ctrl+Alt+P` | Take screenshot |

### Commands

Open Command Palette (`Ctrl+Shift+P`) and type:

- `Scrcpy: Connect Device` - Connect to your Android device
- `Scrcpy: Connect to IP` - Connect to specific IP address
- `Scrcpy: Take Screenshot` - Capture a screenshot
- `Scrcpy: List Devices` - Show all connected devices
- `Scrcpy: Reset Connection` - Reset saved device IP
- `Scrcpy: Connect with Profile` - Choose device profile
- `Scrcpy: Install Dependencies` - Install scrcpy automatically

### Status Bar

Click the **📱 Scrcpy** icon in the status bar for quick access to all actions.

---

## ⚙️ Configuration

Configure in VS Code Settings (`Ctrl+,`):

```json
{
  "scrcpy-smart.bitrate": "8M",      // Video bitrate (4M, 8M, 16M)
  "scrcpy-smart.maxSize": 1024,      // Max resolution (720, 1024, 1920)
  "scrcpy-smart.maxFps": 60          // Max FPS (30, 60, 120)
}
```

---

## 📚 Documentation

- **[User Guide](USER_GUIDE.md)** - Complete usage guide
- **[Supported Platforms](SUPPORTED_PLATFORMS.md)** - OS compatibility
- **[Troubleshooting](TROUBLESHOOTING.md)** - Common issues and solutions
- **[Changelog](CHANGELOG.md)** - Version history

---

## 🤝 Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

1. Fork the repository
2. Create your feature branch (`git checkout -b feature/amazing`)
3. Commit your changes (`git commit -m 'Add amazing feature'`)
4. Push to the branch (`git push origin feature/amazing`)
5. Open a Pull Request

---

## 📄 License

**MIT License**

Copyright (c) 2026 Tareq Alomari

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.

---

## 🙏 Credits

- **[scrcpy](https://github.com/Genymobile/scrcpy)** by Genymobile - The amazing screen mirroring tool
- **Developed by** [Tareq Alomari](https://github.com/tareq-alomari)
- **Contributors** - Thank you to all contributors!

---

## 📞 Support

- **GitHub Issues:** [Report a bug](https://github.com/tareq-alomari/scrcpy-smart/issues)
- **GitHub Discussions:** [Ask a question](https://github.com/tareq-alomari/scrcpy-smart/discussions)
- **Email:** tareq.alomari@example.com

---

## 🌟 Star History

If you find this extension useful, please consider giving it a star on GitHub!

[![Star History Chart](https://api.star-history.com/svg?repos=tareq-alomari/scrcpy-smart&type=Date)](https://star-history.com/#tareq-alomari/scrcpy-smart&Date)

---

<div align="center">

**Made with ❤️ by Tareq Alomari**

**© 2026 Tareq Alomari. All rights reserved.**

[GitHub](https://github.com/tareq-alomari) • [Website](https://tareq-alomari.github.io) • [LinkedIn](https://linkedin.com/in/tareq-alomari)

</div>
