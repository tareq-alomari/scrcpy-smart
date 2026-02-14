# Auto-installer for scrcpy on Windows
# Run with: powershell -ExecutionPolicy Bypass -File install-scrcpy.ps1

Write-Host "🔍 Checking scrcpy installation..." -ForegroundColor Cyan

# Check if scrcpy is installed
if (Get-Command scrcpy -ErrorAction SilentlyContinue) {
    Write-Host "✅ scrcpy is already installed" -ForegroundColor Green
    scrcpy --version
    exit 0
}

Write-Host "📦 scrcpy not found. Installing..." -ForegroundColor Yellow

# Try winget first (Windows 11 / Windows 10 with App Installer)
if (Get-Command winget -ErrorAction SilentlyContinue) {
    Write-Host "🪟 Using winget..." -ForegroundColor Cyan
    winget install --id Genymobile.scrcpy --accept-package-agreements --accept-source-agreements
    winget install --id Google.PlatformTools --accept-package-agreements --accept-source-agreements
    Write-Host "✅ Installation complete!" -ForegroundColor Green
    exit 0
}

# Try Chocolatey
if (Get-Command choco -ErrorAction SilentlyContinue) {
    Write-Host "🍫 Using Chocolatey..." -ForegroundColor Cyan
    choco install scrcpy adb -y
    Write-Host "✅ Installation complete!" -ForegroundColor Green
    exit 0
}

# Try Scoop
if (Get-Command scoop -ErrorAction SilentlyContinue) {
    Write-Host "🥄 Using Scoop..." -ForegroundColor Cyan
    scoop install scrcpy adb
    Write-Host "✅ Installation complete!" -ForegroundColor Green
    exit 0
}

# No package manager found
Write-Host "❌ No package manager found!" -ForegroundColor Red
Write-Host ""
Write-Host "Please install one of the following:" -ForegroundColor Yellow
Write-Host "  1. winget (built-in on Windows 11)" -ForegroundColor White
Write-Host "  2. Chocolatey: https://chocolatey.org/install" -ForegroundColor White
Write-Host "  3. Scoop: https://scoop.sh" -ForegroundColor White
Write-Host ""
Write-Host "Or install manually:" -ForegroundColor Yellow
Write-Host "  scrcpy: https://github.com/Genymobile/scrcpy/releases" -ForegroundColor White
Write-Host "  ADB: https://developer.android.com/tools/adb" -ForegroundColor White
exit 1
