# 🚀 VSCode Extension - Publishing Guide

**Extension**: Scrcpy Smart Connect  
**Version**: 2.4.0  
**Publisher**: tareq-alomari  
**Contact**: tareq.software.devloper@gmail.com

---

## ✅ Extension Installed Successfully!

The extension is now installed in your VSCode.

---

## 🎮 How to Use

### Quick Actions Menu
Press `Ctrl+Alt+S` (or `Cmd+Alt+S` on Mac)

This opens a menu with all available actions:
- Connect Device
- Connect to IP
- Screenshot
- List Devices
- Reset Connection
- Connect with Profile
- Install Dependencies

### Keyboard Shortcuts

| Shortcut | Action |
|----------|--------|
| `Ctrl+Alt+S` | Quick Actions Menu |
| `Ctrl+Alt+C` | Connect Device |
| `Ctrl+Alt+P` | Take Screenshot |

### Command Palette

Press `Ctrl+Shift+P` and type "Scrcpy" to see all commands:
- `Scrcpy: Connect Device`
- `Scrcpy: Quick Actions`
- `Scrcpy: Connect to IP`
- `Scrcpy: Take Screenshot`
- `Scrcpy: List Devices`
- `Scrcpy: Reset Connection`
- `Scrcpy: Connect with Profile`
- `Scrcpy: Install Dependencies`

---

## ⚙️ Settings

Go to: Settings → Extensions → Scrcpy Smart

Available settings:
- **Bitrate**: Video bitrate (default: 8M)
- **Max Size**: Maximum resolution (default: 1024)
- **Max FPS**: Maximum frames per second (default: 60)

---

## 🧪 Testing the Extension

### Test 1: Quick Actions
1. Press `Ctrl+Alt+S`
2. You should see a menu with options
3. Try selecting "Connect Device"

### Test 2: Connect Device
1. Connect your Android device via USB
2. Press `Ctrl+Alt+C`
3. Terminal should open and run scrcpy-smart

### Test 3: Screenshot
1. While device is connected
2. Press `Ctrl+Alt+P`
3. Screenshot should be taken

### Test 4: Settings
1. Go to Settings → Extensions → Scrcpy Smart
2. Change bitrate to 16M
3. Settings should be saved

---

## 📦 Publishing to VSCode Marketplace

### Prerequisites

1. **Install vsce** (VSCode Extension Manager)
   ```bash
   npm install -g @vscode/vsce
   ```

2. **Create Publisher Account**
   - Go to: https://marketplace.visualstudio.com/manage
   - Sign in with Microsoft/GitHub account
   - Create publisher: `tareq-alomari`

3. **Get Personal Access Token**
   - Go to: https://dev.azure.com/tareq-alomari/_usersSettings/tokens
   - Create new token with:
     - Name: vsce-publish
     - Organization: All accessible organizations
     - Scopes: Marketplace → Manage
   - Copy the token (save it securely!)

---

### Publishing Steps

#### 1. Login to vsce
```bash
cd vscode-extension
vsce login tareq-alomari
# Enter your Personal Access Token
```

#### 2. Verify Package
```bash
vsce ls
# Lists all files that will be included
```

#### 3. Package Extension (Optional)
```bash
vsce package
# Creates scrcpy-smart-2.4.0.vsix
```

#### 4. Publish Extension
```bash
vsce publish
# Publishes to marketplace
```

Or publish specific version:
```bash
vsce publish 2.4.0
```

Or publish with patch increment:
```bash
vsce publish patch  # 2.4.0 → 2.4.1
vsce publish minor  # 2.4.0 → 2.5.0
vsce publish major  # 2.4.0 → 3.0.0
```

---

### Alternative: Manual Upload

1. Package the extension:
   ```bash
   vsce package
   ```

2. Go to: https://marketplace.visualstudio.com/manage/publishers/tareq-alomari

3. Click "New extension" → "Visual Studio Code"

4. Upload `scrcpy-smart-2.4.0.vsix`

---

## 📝 Before Publishing Checklist

### Required Files
- [x] `package.json` - Extension manifest
- [x] `README.md` - Extension documentation
- [x] `CHANGELOG.md` - Version history
- [x] `LICENSE` - MIT License
- [x] `icon.png` - Extension icon (128x128)

### package.json Validation
- [x] `name`: scrcpy-smart
- [x] `displayName`: Scrcpy Smart Connect
- [x] `version`: 2.4.0
- [x] `publisher`: tareq-alomari
- [x] `description`: Clear and concise
- [x] `repository`: GitHub URL
- [x] `keywords`: Relevant keywords
- [x] `categories`: ["Other"]
- [x] `icon`: icon.png
- [x] `engines.vscode`: ^1.80.0

### Documentation
- [x] README.md has:
  - Clear description
  - Installation instructions
  - Usage examples
  - Screenshots (add if possible)
  - Keyboard shortcuts
  - Settings
  - Requirements
  - Known issues
  - License

### Testing
- [x] Extension installs correctly
- [x] All commands work
- [x] Keyboard shortcuts work
- [x] Settings work
- [x] No errors in console

---

## 🎯 Post-Publishing

### 1. Verify Publication
- Check: https://marketplace.visualstudio.com/items?itemName=tareq-alomari.scrcpy-smart
- Test installation from marketplace
- Check ratings and reviews

### 2. Update README Badge
Add to main README.md:
```markdown
[![VS Code Marketplace](https://img.shields.io/vscode-marketplace/v/tareq-alomari.scrcpy-smart)](https://marketplace.visualstudio.com/items?itemName=tareq-alomari.scrcpy-smart)
```

### 3. Announce
- Tweet about it
- Post on Reddit
- Add to README.md
- Update documentation

---

## 🔄 Updating the Extension

### 1. Make Changes
Edit files in `vscode-extension/`

### 2. Update Version
In `package.json`:
```json
"version": "2.4.1"
```

In `CHANGELOG.md`:
```markdown
## [2.4.1] - 2026-02-14
### Fixed
- Bug fixes
```

### 3. Test Changes
```bash
code --install-extension scrcpy-smart-2.4.1.vsix
```

### 4. Publish Update
```bash
vsce publish
```

---

## 📊 Marketplace Statistics

After publishing, you can track:
- **Installs**: Total installations
- **Downloads**: Total downloads
- **Rating**: User ratings (1-5 stars)
- **Reviews**: User feedback

View at: https://marketplace.visualstudio.com/manage/publishers/tareq-alomari

---

## 🐛 Troubleshooting

### Error: Publisher not found
```bash
vsce login tareq-alomari
# Enter your PAT
```

### Error: Missing publisher
Add to `package.json`:
```json
"publisher": "tareq-alomari"
```

### Error: Invalid icon
- Icon must be PNG
- Size: 128x128 pixels
- Path: `icon.png` in root

### Error: Missing README
- Must have `README.md`
- Must contain description

---

## 📚 Resources

- **vsce Documentation**: https://code.visualstudio.com/api/working-with-extensions/publishing-extension
- **Marketplace**: https://marketplace.visualstudio.com/
- **Publisher Portal**: https://marketplace.visualstudio.com/manage
- **Extension Guidelines**: https://code.visualstudio.com/api/references/extension-guidelines

---

## 🎯 Quick Commands Reference

```bash
# Install vsce
npm install -g @vscode/vsce

# Login
vsce login tareq-alomari

# Package
vsce package

# Publish
vsce publish

# Publish with version bump
vsce publish patch  # 2.4.0 → 2.4.1
vsce publish minor  # 2.4.0 → 2.5.0
vsce publish major  # 2.4.0 → 3.0.0

# List files
vsce ls

# Show info
vsce show tareq-alomari.scrcpy-smart

# Unpublish (careful!)
vsce unpublish tareq-alomari.scrcpy-smart
```

---

## ✅ Ready to Publish!

Your extension is:
- ✅ Packaged (scrcpy-smart-2.4.0.vsix)
- ✅ Tested locally
- ✅ Documented
- ✅ Ready for marketplace

**Next step**: Create publisher account and publish!

---

**Contact**: tareq.software.devloper@gmail.com  
**GitHub**: https://github.com/tareq-alomari/scrcpy-smart
