# 📦 VS Code Extension - Installation Guide

## ✅ تم إنشاء الإضافة بنجاح!

الملف: `scrcpy-smart-2.1.0.vsix`

---

## 🚀 طرق التثبيت

### 1️⃣ التثبيت المحلي (Local Installation)

#### من VS Code:
1. افتح VS Code
2. اضغط `Ctrl+Shift+P` (أو `Cmd+Shift+P` على macOS)
3. اكتب: `Extensions: Install from VSIX`
4. اختر الملف: `scrcpy-smart-2.1.0.vsix`

#### من سطر الأوامر:
```bash
code --install-extension scrcpy-smart-2.1.0.vsix
```

---

### 2️⃣ النشر على VS Code Marketplace

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
