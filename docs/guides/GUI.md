# GUI Mode

Scrcpy Smart Connect now includes an optional graphical interface!

## Requirements

- zenity (for GUI dialogs)

```bash
# Ubuntu/Debian
sudo apt install zenity

# macOS
brew install zenity
```

## Usage

```bash
./scrcpy-smart-gui.sh
```

## Features

### Main Menu
- Connect to Device
- Connect with Profile
- Manage Devices
- Monitor Connection
- Daemon Control
- View Logs
- Settings
- About

### Device Management
- List all saved devices
- Save current device with nickname
- Remove devices
- Visual device selection

### Profiles
- Gaming (120fps, 720p, low latency)
- Recording (1920p, 16M bitrate)
- Demo (borderless, always-on-top)
- Battery Saver (30fps, low power)

### Daemon Control
- Start/stop background daemon
- Check daemon status
- Visual status indicators

### Logs Viewer
- View connection logs
- Scrollable text view
- Real-time updates

### Settings Editor
- Edit config file visually
- Save changes directly
- Syntax highlighting

## Desktop Integration

Install to application menu:

```bash
cp scrcpy-smart.desktop ~/.local/share/applications/
sed -i "s|/home/tareq|$HOME|g" ~/.local/share/applications/scrcpy-smart.desktop
```

Now you can launch from your application menu!

## Screenshots

Coming soon!
