# 📦 VS Code Extension - Installation Guide

## ⚠️ متطلبات التثبيت

**الإضافة تحتاج أداة scrcpy-smart CLI مثبتة أولاً!**

---

## 🚀 خطوات التثبيت الكاملة

### 1️⃣ تثبيت scrcpy-smart CLI (مطلوب)

**التثبيت السريع (موصى به):**
```bash
curl -fsSL https://raw.githubusercontent.com/tareq-alomari/scrcpy-smart/main/install.sh | bash
```

**التثبيت اليدوي:**
```bash
git clone https://github.com/tareq-alomari/scrcpy-smart.git
cd scrcpy-smart
./install.sh
```

**التحقق من التثبيت:**
```bash
which scrcpy-smart
# يجب أن يظهر: /home/username/.local/bin/scrcpy-smart

scrcpy-smart --version
# يجب أن يظهر رقم الإصدار
```

---

### 2️⃣ تثبيت scrcpy و ADB

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

---

### 3️⃣ تثبيت إضافة VS Code

#### من VS Code Marketplace:
1. افتح VS Code
2. اذهب إلى Extensions (Ctrl+Shift+X)
3. ابحث عن "Scrcpy Smart Connect"
4. اضغط Install

#### من ملف VSIX:
```bash
code --install-extension scrcpy-smart-2.4.1.vsix
```

#### من داخل VS Code:
1. اضغط `Ctrl+Shift+P`
2. اكتب: `Extensions: Install from VSIX`
3. اختر الملف: `scrcpy-smart-2.4.1.vsix`

---

## 🔧 حل المشاكل الشائعة

### ❌ خطأ: "scrcpy-smart not found"

**السبب:** الإضافة لا تجد أداة scrcpy-smart CLI

**الحلول:**

#### 1. تحقق من التثبيت:
```bash
which scrcpy-smart
```

إذا لم يظهر شيء، ثبت الأداة أولاً (راجع الخطوة 1 أعلاه)

#### 2. تحقق من PATH:
```bash
echo $PATH | grep ".local/bin"
```

إذا كان فارغاً، أضف إلى `~/.bashrc` أو `~/.zshrc`:
```bash
export PATH="$HOME/.local/bin:$PATH"
```

ثم أعد تحميل:
```bash
source ~/.bashrc  # أو source ~/.zshrc
```

#### 3. حدد المسار يدوياً في VS Code:
1. افتح Settings (Ctrl+,)
2. ابحث عن "scrcpy-smart.scriptPath"
3. أدخل المسار الكامل للسكريبت
4. مثال: `/home/username/.local/bin/scrcpy-smart`

#### 4. أعد تشغيل VS Code:
بعد تثبيت الأداة، أعد تشغيل VS Code بالكامل

---

## 📍 أماكن البحث التلقائي

الإضافة تبحث عن scrcpy-smart في:
1. ✅ أمر النظام `scrcpy-smart` (في PATH)
2. ✅ `~/.local/bin/scrcpy-smart`
3. ✅ `/usr/local/bin/scrcpy-smart`
4. ✅ `/usr/bin/scrcpy-smart`
5. ✅ المسار المخصص في الإعدادات

---

## 🎯 التحقق من التثبيت الصحيح

بعد التثبيت، جرب:

1. **من Terminal:**
   ```bash
   scrcpy-smart --version
   ```

2. **من VS Code:**
   - اضغط `Ctrl+Shift+P`
   - اكتب: `Scrcpy: Connect Device`
   - يجب أن يعمل بدون أخطاء

---

## 2️⃣ النشر على VS Code Marketplace

#### المتطلبات:
1. حساب على [Azure DevOps](https://dev.azure.com)
2. Personal Access Token (PAT)

#### خطوات النشر:

```bash
# 1. تسجيل الدخول
vsce login tareq-alomari

# 2. نشر الإضافة
vsce publish
```

#### إنشاء Personal Access Token:
1. اذهب إلى: https://dev.azure.com
2. User Settings → Personal Access Tokens
3. New Token
4. Name: `vsce-publish`
5. Organization: `All accessible organizations`
6. Scopes: `Marketplace (Manage)`
7. انسخ الـ Token

---

## 📖 الاستخدام

### الأوامر المتاحة:

افتح Command Palette (`Ctrl+Shift+P`) واكتب:

1. **Scrcpy: Connect Device** - الاتصال بالجهاز
2. **Scrcpy: Connect to IP** - الاتصال بـ IP محدد
3. **Scrcpy: Take Screenshot** - التقاط صورة
4. **Scrcpy: List Devices** - عرض الأجهزة
5. **Scrcpy: Reset Connection** - إعادة تعيين الاتصال

### الإعدادات:

في VS Code Settings (`Ctrl+,`):

```json
{
  "scrcpy-smart.bitrate": "8M",
  "scrcpy-smart.maxSize": 1024,
  "scrcpy-smart.maxFps": 60
}
```

---

## 🧪 الاختبار

### اختبار محلي:
1. افتح مجلد `vscode-extension` في VS Code
2. اضغط `F5` لفتح Extension Development Host
3. جرب الأوامر في النافذة الجديدة

---

## 📝 الملفات المهمة

```
vscode-extension/
├── scrcpy-smart-2.1.0.vsix    # الحزمة الجاهزة
├── package.json                # معلومات الإضافة
├── src/extension.ts            # الكود المصدري
├── out/extension.js            # الكود المترجم
├── README.md                   # التوثيق
├── CHANGELOG.md                # سجل التغييرات
└── LICENSE                     # الترخيص
```

---

## 🔄 التحديثات المستقبلية

لتحديث الإضافة:

```bash
# 1. عدّل الكود في src/extension.ts
# 2. حدّث رقم الإصدار في package.json
# 3. أضف التغييرات في CHANGELOG.md
# 4. أعد الترجمة والتعبئة
npm run compile
vsce package

# 5. انشر التحديث
vsce publish
```

---

## 🎯 الميزات الحالية

✅ الاتصال اللاسلكي بالأجهزة
✅ الاتصال بـ IP محدد
✅ التقاط الصور
✅ عرض الأجهزة المتصلة
✅ إعادة تعيين الاتصالات
✅ إعدادات قابلة للتخصيص

---

## 🚀 ميزات مستقبلية

- [ ] شريط الحالة لعرض الجهاز المتصل
- [ ] اختيار سريع للأجهزة
- [ ] إشعارات حالة الاتصال
- [ ] إعادة الاتصال التلقائي
- [ ] اختصارات لوحة المفاتيح
- [ ] دعم الملفات الشخصية (Profiles)

---

## 📞 الدعم

- GitHub: https://github.com/tareq-alomari/scrcpy-smart
- Issues: https://github.com/tareq-alomari/scrcpy-smart/issues

---

**تم بنجاح! 🎉**
