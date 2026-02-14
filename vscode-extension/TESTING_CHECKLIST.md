# ✅ VSCode Extension - Testing & Publishing Checklist

**Extension**: Scrcpy Smart Connect v2.4.0  
**Status**: ✅ Installed & Ready  
**Contact**: tareq.software.devloper@gmail.com

---

## 🎮 Testing in VSCode

### ✅ Installation Status
- [x] Extension installed successfully
- [x] Extension ID: `tareq-alomari.scrcpy-smart`
- [x] Version: 2.4.0
- [x] Size: 23KB

### 🧪 Manual Testing Steps

#### Test 1: Quick Actions Menu
1. Open VSCode
2. Press `Ctrl+Alt+S` (or `Cmd+Alt+S` on Mac)
3. **Expected**: Menu appears with 8 options
4. **Result**: ⬜ Pass / ⬜ Fail

#### Test 2: Connect Device Command
1. Connect Android device via USB
2. Press `Ctrl+Alt+C`
3. **Expected**: Terminal opens and runs `scrcpy-smart`
4. **Result**: ⬜ Pass / ⬜ Fail

#### Test 3: Screenshot Command
1. Ensure device is connected
2. Press `Ctrl+Alt+P`
3. **Expected**: Terminal runs `scrcpy-smart --screenshot`
4. **Result**: ⬜ Pass / ⬜ Fail

#### Test 4: Command Palette
1. Press `Ctrl+Shift+P`
2. Type "Scrcpy"
3. **Expected**: 8 commands appear
4. **Result**: ⬜ Pass / ⬜ Fail

#### Test 5: Settings
1. Go to Settings → Extensions → Scrcpy Smart
2. Change bitrate to 16M
3. **Expected**: Setting saves
4. **Result**: ⬜ Pass / ⬜ Fail

---

## 📦 Publishing Preparation

### Prerequisites

#### 1. Install vsce
```bash
sudo npm install -g @vscode/vsce
```

#### 2. Create Publisher Account
- Go to: https://marketplace.visualstudio.com/manage
- Sign in with Microsoft/GitHub
- Create publisher: `tareq-alomari`

#### 3. Get Personal Access Token (PAT)
- Go to: https://dev.azure.com/tareq-alomari/_usersSettings/tokens
- Click "New Token"
- Settings:
  - Name: `vsce-publish`
  - Organization: All accessible organizations
  - Expiration: 1 year
  - Scopes: **Marketplace** → **Manage** ✅
- Copy token (save securely!)

---

## 🚀 Publishing Steps

### Step 1: Verify Package
```bash
cd vscode-extension
vsce ls
```
**Expected**: Lists all files to be included

### Step 2: Login
```bash
vsce login tareq-alomari
# Paste your Personal Access Token
```

### Step 3: Publish
```bash
vsce publish
```

Or with specific version:
```bash
vsce publish 2.4.0
```

---

## 📋 Pre-Publishing Checklist

### Required Files
- [x] `package.json` - Complete and valid
- [x] `README.md` - Clear documentation
- [x] `CHANGELOG.md` - Version history
- [x] `LICENSE` - MIT License
- [x] `icon.png` - 128x128 PNG
- [x] `src/extension.ts` - Source code
- [x] `.vscodeignore` - Exclude unnecessary files

### package.json Validation
- [x] `name`: "scrcpy-smart"
- [x] `displayName`: "Scrcpy Smart Connect"
- [x] `version`: "2.4.0"
- [x] `publisher`: "tareq-alomari"
- [x] `description`: Clear description
- [x] `repository`: GitHub URL
- [x] `keywords`: Relevant keywords
- [x] `icon`: "icon.png"
- [x] `engines.vscode`: "^1.80.0"
- [x] `categories`: ["Other"]

### Documentation Quality
- [x] README has installation instructions
- [x] README has usage examples
- [x] README has keyboard shortcuts
- [x] README has requirements
- [x] CHANGELOG is up to date
- [x] LICENSE is included

### Code Quality
- [x] No TypeScript errors
- [x] All commands work
- [x] Keyboard shortcuts work
- [x] Settings work
- [x] No console errors

---

## 🎯 Post-Publishing

### Immediate Actions
1. **Verify Publication**
   - Check: https://marketplace.visualstudio.com/items?itemName=tareq-alomari.scrcpy-smart
   - Test installation from marketplace
   - Verify all information is correct

2. **Test Installation**
   ```bash
   code --install-extension tareq-alomari.scrcpy-smart
   ```

3. **Update Main README**
   Add badge:
   ```markdown
   [![VS Code Marketplace](https://img.shields.io/vscode-marketplace/v/tareq-alomari.scrcpy-smart)](https://marketplace.visualstudio.com/items?itemName=tareq-alomari.scrcpy-smart)
   ```

### Announcements
- [ ] Tweet about release
- [ ] Post on Reddit (r/vscode)
- [ ] Update GitHub README
- [ ] Add to SOCIAL_MEDIA_POSTS.md

---

## 🔄 Future Updates

### Version Bump Commands
```bash
# Patch: 2.4.0 → 2.4.1 (bug fixes)
vsce publish patch

# Minor: 2.4.0 → 2.5.0 (new features)
vsce publish minor

# Major: 2.4.0 → 3.0.0 (breaking changes)
vsce publish major
```

### Update Process
1. Make changes in `src/`
2. Update `CHANGELOG.md`
3. Update version in `package.json`
4. Test locally
5. Run `vsce publish`

---

## 📊 Monitoring

### Marketplace Statistics
View at: https://marketplace.visualstudio.com/manage/publishers/tareq-alomari

Track:
- **Installs**: Total installations
- **Downloads**: Total downloads
- **Rating**: User ratings (1-5 stars)
- **Reviews**: User feedback
- **Trends**: Install trends over time

---

## 🐛 Common Issues

### Issue: Publisher not found
**Solution**:
```bash
vsce login tareq-alomari
# Enter your PAT
```

### Issue: Missing publisher in package.json
**Solution**: Add to `package.json`:
```json
"publisher": "tareq-alomari"
```

### Issue: Invalid icon
**Solution**:
- Icon must be PNG format
- Size must be 128x128 pixels
- Path must be `icon.png` in root

### Issue: README too short
**Solution**: README must have:
- Description
- Installation
- Usage
- At least 100 words

---

## 📚 Resources

- **Publishing Guide**: https://code.visualstudio.com/api/working-with-extensions/publishing-extension
- **Marketplace**: https://marketplace.visualstudio.com/
- **Publisher Portal**: https://marketplace.visualstudio.com/manage
- **Extension Guidelines**: https://code.visualstudio.com/api/references/extension-guidelines
- **vsce Documentation**: https://github.com/microsoft/vscode-vsce

---

## ✅ Current Status

### Completed
- [x] Extension developed
- [x] Extension packaged (.vsix)
- [x] Extension tested locally
- [x] Documentation complete
- [x] Icon created
- [x] License added
- [x] Changelog updated

### Pending
- [ ] Install vsce (`sudo npm install -g @vscode/vsce`)
- [ ] Create publisher account
- [ ] Get Personal Access Token
- [ ] Login with vsce
- [ ] Publish to marketplace
- [ ] Announce release

---

## 🎯 Quick Commands

```bash
# Install vsce
sudo npm install -g @vscode/vsce

# Navigate to extension
cd vscode-extension

# List files
vsce ls

# Login
vsce login tareq-alomari

# Package (optional)
vsce package

# Publish
vsce publish

# Show extension info
vsce show tareq-alomari.scrcpy-smart
```

---

## 📝 Notes

- Extension is **ready** for publishing
- All files are **complete**
- Testing is **recommended** before publishing
- Publisher account is **required**
- Personal Access Token is **required**

---

**Contact**: tareq.software.devloper@gmail.com  
**GitHub**: https://github.com/tareq-alomari/scrcpy-smart  
**Extension**: vscode-extension/scrcpy-smart-2.4.0.vsix
