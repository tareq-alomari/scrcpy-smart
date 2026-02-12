# 🚀 Scrcpy Smart Connect

<div align="center">

[![GitHub 版本](https://img.shields.io/github/v/release/tareq-alomari/scrcpy-smart)](https://github.com/tareq-alomari/scrcpy-smart/releases)
[![CI](https://github.com/tareq-alomari/scrcpy-smart/workflows/CI/badge.svg)](https://github.com/tareq-alomari/scrcpy-smart/actions)
[![许可证: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
[![平台](https://img.shields.io/badge/platform-Linux%20%7C%20macOS%20%7C%20Windows-blue)](https://github.com/tareq-alomari/scrcpy-smart)

**scrcpy 的智能无线连接管理器 - 通过 WiFi 自动连接 Android 设备**

[English](../README.md) · [العربية](README.ar.md) · [Español](README.es.md) · [中文](README.zh.md)

</div>

---

## ✨ 特性

- 🔄 **自动重连**: 记住设备 IP 并无线连接
- 📱 **USB 备用**: 无线连接失败时自动回退到 USB
- 🎯 **智能设备选择**: 优先选择无线而非 USB
- ⚡ **性能优化**: 预配置 60 FPS 和平衡质量
- 💾 **IP 持久化**: 保存设备 IP 供将来连接
- 🖥️ **跨平台**: 支持 Linux、macOS 和 Windows
- 🛠️ **CLI 选项**: 完整的命令行界面
- 📱 **多设备**: 从多个连接的设备中选择

## 🚀 快速安装

```bash
git clone https://github.com/tareq-alomari/scrcpy-smart.git
cd scrcpy-smart
./install.sh
```

## 📖 使用

### 基本使用

```bash
scrcpy-smart        # 连接设备
phone               # 使用别名
```

### 命令行选项

```bash
scrcpy-smart --help      # 显示帮助
scrcpy-smart --version   # 显示版本
scrcpy-smart --config    # 显示配置
scrcpy-smart --reset     # 重置保存的 IP
scrcpy-smart --list      # 列出所有设备
scrcpy-smart --select    # 手动选择设备
```

## 📄 许可证

MIT 许可证 - 详见 [LICENSE](../LICENSE) 文件

---

<div align="center">

**用 ❤️ 为移动开发者打造**

</div>
