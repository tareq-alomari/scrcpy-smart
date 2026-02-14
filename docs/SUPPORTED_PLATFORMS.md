# 🌍 Supported Operating Systems

## ✅ Fully Supported

### 🐧 Linux
- **Ubuntu / Debian** (apt)
- **Fedora** (dnf)
- **Arch Linux** (pacman)
- **openSUSE** (zypper)
- **Other distributions** (manual installation guide provided)

### 🍎 macOS
- **macOS 10.13+** (Homebrew)
- Auto-installs Homebrew if not present

### 🪟 Windows
- **Windows 10 / 11** (winget)
- **Windows with Chocolatey** (choco)
- **Windows with Scoop** (scoop)
- **WSL (Windows Subsystem for Linux)** (apt/dnf/pacman)
- **Git Bash** (winget/choco/scoop)

---

## 📦 Package Managers Supported

| OS | Package Manager | Auto-Install |
|---|---|---|
| Ubuntu/Debian | apt | ✅ |
| Fedora | dnf | ✅ |
| Arch Linux | pacman | ✅ |
| openSUSE | zypper | ✅ |
| macOS | Homebrew | ✅ |
| Windows | winget | ✅ |
| Windows | Chocolatey | ✅ |
| Windows | Scoop | ✅ |

---

## 🚀 Installation Methods

### Linux (Bash Script)
```bash
bash ~/scrcpy-smart/install-scrcpy.sh
```

### Windows (PowerShell)
```powershell
powershell -ExecutionPolicy Bypass -File ~/scrcpy-smart/install-scrcpy.ps1
```

### From VS Code Extension
```
Ctrl+Alt+S → Install Dependencies
```

---

## 🔧 Manual Installation

If auto-install fails, follow these guides:

### Linux
```bash
# Ubuntu/Debian
sudo apt install scrcpy adb

# Fedora
sudo dnf install scrcpy android-tools

# Arch
sudo pacman -S scrcpy android-tools
```

### macOS
```bash
brew install scrcpy android-platform-tools
```

### Windows
```powershell
# Using winget
winget install Genymobile.scrcpy
winget install Google.PlatformTools

# Using Chocolatey
choco install scrcpy adb

# Using Scoop
scoop install scrcpy adb
```

Or download manually:
- scrcpy: https://github.com/Genymobile/scrcpy/releases
- ADB: https://developer.android.com/tools/adb

---

## 🌐 Cross-Platform Features

All features work on all platforms:
- ✅ Wireless connection
- ✅ USB fallback
- ✅ Screenshots
- ✅ Device management
- ✅ Profiles (Gaming, Recording, Demo, Battery)
- ✅ Auto-reconnect
- ✅ Status bar indicator
- ✅ Keyboard shortcuts

---

## 📱 Android Requirements

Same for all platforms:
- Android 5.0+ (API 21+)
- USB debugging enabled
- Same WiFi network (for wireless)

---

## 🎯 Tested On

- ✅ Ubuntu 20.04, 22.04, 24.04
- ✅ Debian 11, 12
- ✅ Fedora 38, 39
- ✅ Arch Linux (latest)
- ✅ macOS Monterey, Ventura, Sonoma
- ✅ Windows 10 (21H2+)
- ✅ Windows 11
- ✅ WSL2 (Ubuntu)

---

**Universal compatibility! 🌍**
