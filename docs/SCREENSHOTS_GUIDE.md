# Screenshots & Demo Guide

## Screenshots Needed

### 1. Terminal - First Connection
**Filename:** `screenshots/first-connection.png`
**Content:** Show terminal output when connecting for first time via USB
```
🚀 Scrcpy Smart Connect v1.2.0
OS: Linux

✅ Device found: ABC123
📡 Setting up wireless...
📱 IP saved: 192.168.1.100
✅ Wireless ready! Disconnect USB now
```

### 2. Terminal - Wireless Connection
**Filename:** `screenshots/wireless-connection.png`
**Content:** Show terminal output when connecting wirelessly
```
🚀 Scrcpy Smart Connect v1.2.0
OS: Linux

📡 Trying saved connection: 192.168.1.100
✅ Connected wirelessly!
```

### 3. Terminal - Help Command
**Filename:** `screenshots/help-command.png`
**Content:** Show `phone --help` output

### 4. Terminal - List Devices
**Filename:** `screenshots/list-devices.png`
**Content:** Show `phone --list` output with multiple devices

### 5. scrcpy Window
**Filename:** `screenshots/scrcpy-window.png`
**Content:** Show scrcpy mirroring an Android device screen

### 6. Workflow Diagram
**Filename:** `screenshots/workflow.png`
**Content:** Visual diagram showing:
- First time: USB → Detect → Save IP → Wireless
- Next times: Wireless direct connection

## GIF Demos Needed

### 1. Quick Start Demo
**Filename:** `demos/quick-start.gif`
**Duration:** ~15 seconds
**Content:**
1. Open terminal
2. Type `phone`
3. Show connection process
4. Show scrcpy window opening
5. Show device screen mirroring

### 2. Installation Demo
**Filename:** `demos/installation.gif`
**Duration:** ~20 seconds
**Content:**
1. Clone repo
2. Run install.sh
3. Show success message
4. Run `phone` command

### 3. Multiple Devices Demo
**Filename:** `demos/multiple-devices.gif`
**Duration:** ~15 seconds
**Content:**
1. Run `phone --list`
2. Run `phone --select`
3. Choose device
4. Connect

## Video Demo Script

**Title:** Scrcpy Smart Connect - Wireless Android Development

**Duration:** 2-3 minutes

**Script:**

[0:00-0:10] Introduction
"Hi! Today I'll show you Scrcpy Smart Connect - a tool that lets you connect to Android devices wirelessly for development."

[0:10-0:30] The Problem
"As mobile developers, we're constantly plugging and unplugging USB cables. It's restrictive and cables wear out. There's a better way."

[0:30-1:00] Installation
"Installation is simple. Just run this one command:"
[Show terminal with install command]
"It checks dependencies and sets everything up automatically."

[1:00-1:30] First Use
"First time, connect via USB and run 'phone'"
[Show terminal and connection process]
"It detects your device, gets the IP, and switches to wireless mode."
[Show disconnecting USB]

[1:30-2:00] Daily Use
"From now on, just type 'phone' and you're connected wirelessly!"
[Show quick connection]
"Perfect for Flutter hot reload, testing, or screen recording."

[2:00-2:30] Features
"It supports multiple devices, has USB fallback, and works on Linux, macOS, and Windows."
[Show --list and --select commands]

[2:30-2:45] Call to Action
"Check it out on GitHub - link in description. Star it if you find it useful!"
[Show GitHub page]

[2:45-3:00] Outro
"Thanks for watching! Let me know in the comments how you use it."

## How to Create Screenshots

### Terminal Screenshots
```bash
# Use asciinema for terminal recordings
asciinema rec demo.cast
# Then convert to GIF
agg demo.cast demo.gif
```

### Window Screenshots
```bash
# Linux
gnome-screenshot -w  # Select window

# macOS
Cmd+Shift+4, then Space, click window
```

### GIF Creation
```bash
# Use peek (Linux)
sudo apt install peek

# Or use ffmpeg
ffmpeg -i video.mp4 -vf "fps=10,scale=800:-1" output.gif
```

## Where to Add

### README.md
Add after features section:
```markdown
## 📸 Screenshots

### Quick Connection
![Quick Connection](screenshots/wireless-connection.png)

### First Time Setup
![First Setup](screenshots/first-connection.png)

## 🎥 Demo
![Demo](demos/quick-start.gif)
```

### Wiki Home
Add prominent demo GIF at top

### Social Media
- Use GIFs in tweets
- Use screenshots in Reddit posts
- Use video for Product Hunt
