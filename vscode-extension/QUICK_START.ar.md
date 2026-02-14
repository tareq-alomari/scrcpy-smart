# 🚀 دليل البدء السريع - Scrcpy Smart Connect

## المتطلبات الأساسية

قبل استخدام الإضافة، تأكد من:

### 1. تثبيت scrcpy-smart CLI ✅

```bash
curl -fsSL https://raw.githubusercontent.com/tareq-alomari/scrcpy-smart/main/install.sh | bash
```

### 2. تثبيت scrcpy و ADB ✅

**Linux:**
```bash
sudo apt install scrcpy adb
```

**macOS:**
```bash
brew install scrcpy android-platform-tools
```

---

## الاستخدام الأول

### 1. وصل جهازك عبر USB
- فعّل "تصحيح USB" على جهاز Android
- وصل الجهاز بالكمبيوتر

### 2. افتح VS Code
- اضغط `Ctrl+Alt+C` أو
- اضغط على أيقونة 📱 في شريط الحالة

### 3. تم! 🎉
- الاتصالات القادمة ستكون لاسلكية تلقائياً

---

## الاختصارات السريعة

| الاختصار | الوظيفة |
|----------|---------|
| `Ctrl+Alt+S` | قائمة الإجراءات السريعة |
| `Ctrl+Alt+C` | الاتصال بالجهاز |
| `Ctrl+Alt+P` | التقاط صورة |

---

## الأوامر الأساسية

افتح Command Palette (`Ctrl+Shift+P`):

- **Scrcpy: Connect Device** - اتصل بجهازك
- **Scrcpy: Connect to IP** - اتصل بـ IP محدد
- **Scrcpy: Take Screenshot** - التقط صورة
- **Scrcpy: Quick Actions** - القائمة السريعة

---

## حل المشاكل

### ❌ خطأ: "scrcpy-smart not found"

**الحل:**

1. تأكد من تثبيت CLI:
   ```bash
   which scrcpy-smart
   ```

2. إذا لم يظهر، ثبته:
   ```bash
   curl -fsSL https://raw.githubusercontent.com/tareq-alomari/scrcpy-smart/main/install.sh | bash
   ```

3. أعد تشغيل VS Code

4. إذا استمرت المشكلة، حدد المسار يدوياً:
   - Settings → "scrcpy-smart.scriptPath"
   - أدخل: `/home/username/.local/bin/scrcpy-smart`

---

## الإعدادات الأساسية

في Settings (`Ctrl+,`):

```json
{
  "scrcpy-smart.scriptPath": "",    // المسار المخصص (اتركه فارغاً للكشف التلقائي)
  "scrcpy-smart.bitrate": "8M",     // جودة الفيديو
  "scrcpy-smart.maxSize": 1024,     // الدقة
  "scrcpy-smart.maxFps": 60         // معدل الإطارات
}
```

---

## الملفات الشخصية (Profiles)

اختر الملف المناسب لاستخدامك:

- **Gaming** - ألعاب (120 FPS، تأخير منخفض)
- **Recording** - تسجيل (جودة عالية، 1920p)
- **Demo** - عروض (بدون حدود، دائماً في المقدمة)
- **Battery** - توفير البطارية (30 FPS)

---

## الدعم

- [التوثيق الكامل](README.md)
- [حل المشاكل](INSTALLATION.md)
- [GitHub Issues](https://github.com/tareq-alomari/scrcpy-smart/issues)

---

**استمتع! 🎉**
