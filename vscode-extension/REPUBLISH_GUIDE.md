# 🚀 دليل إعادة النشر - Scrcpy Smart v2.5.0

## الطريقة 1: النشر عبر VS Code Marketplace (موصى به)

### الخطوة 1: تسجيل الدخول إلى Marketplace

افتح: https://marketplace.visualstudio.com/manage/publishers/

### الخطوة 2: رفع الملف يدوياً

1. اضغط على اسم الناشر: **tareq-alomari**
2. اضغط على **"..."** بجانب الإضافة الحالية
3. اختر **"Update"**
4. ارفع الملف: `scrcpy-smart-2.5.0.vsix`
5. اضغط **"Upload"**

✅ تم! الإضافة ستتحدث خلال دقائق

---

## الطريقة 2: النشر عبر سطر الأوامر

### إذا كان عندك Personal Access Token:

```bash
cd /home/tareq/CS/projects/scrcpy-smart/vscode-extension

# تسجيل الدخول (مرة واحدة)
vsce login tareq-alomari
# أدخل الـ PAT عندما يطلب

# النشر
vsce publish
```

### إذا ما عندك PAT، اعمل واحد جديد:

1. اذهب إلى: https://dev.azure.com
2. اضغط على أيقونة المستخدم (أعلى يمين)
3. **User Settings** → **Personal Access Tokens**
4. **+ New Token**
5. املأ البيانات:
   - **Name:** `vsce-publish-scrcpy-smart`
   - **Organization:** `All accessible organizations`
   - **Expiration:** 90 days (أو حسب رغبتك)
   - **Scopes:** اختر **Custom defined**
     - ✅ **Marketplace** → **Manage**
6. اضغط **Create**
7. **انسخ الـ Token** (لن تراه مرة ثانية!)

ثم:
```bash
vsce login tareq-alomari
# الصق الـ PAT

vsce publish
```

---

## الطريقة 3: تحديث الإصدار فقط

إذا تريد تحديث رقم الإصدار وتنشر:

```bash
# زيادة الإصدار تلقائياً
vsce publish patch   # 2.5.0 → 2.5.1
vsce publish minor   # 2.5.0 → 2.6.0
vsce publish major   # 2.5.0 → 3.0.0

# أو حدد الإصدار
vsce publish 2.5.0
```

---

## ✅ التحقق من النشر

بعد النشر، تحقق من:

1. **Marketplace:**
   https://marketplace.visualstudio.com/items?itemName=tareq-alomari.scrcpy-smart

2. **من VS Code:**
   - Extensions → Search "Scrcpy Smart Connect"
   - تحقق من رقم الإصدار: **2.5.0**

3. **من سطر الأوامر:**
   ```bash
   code --install-extension tareq-alomari.scrcpy-smart
   ```

---

## 📋 قائمة التحقق قبل النشر

- [x] الإصدار محدث في package.json (2.5.0)
- [x] CHANGELOG.md محدث
- [x] README.md محدث
- [x] الكود مترجم بدون أخطاء
- [x] الحزمة تم إنشاؤها (scrcpy-smart-2.5.0.vsix)
- [x] الاختبارات التلقائية نجحت (8/8)
- [ ] الاختبار اليدوي في VS Code
- [ ] اختبار على نظام نظيف

---

## 🔄 إذا حصل خطأ

### خطأ: "Personal Access Token verification failed"

**الحل:**
```bash
# احذف الـ token القديم
rm ~/.vsce

# سجل دخول من جديد
vsce login tareq-alomari
```

### خطأ: "Extension already exists"

**الحل:** استخدم الطريقة 1 (رفع يدوي) أو:
```bash
vsce publish --force
```

### خطأ: "Version already exists"

**الحل:** زود رقم الإصدار:
```bash
# في package.json غير 2.5.0 إلى 2.5.1
npm version patch

# ثم انشر
vsce publish
```

---

## 📊 بعد النشر

### انتظر 5-10 دقائق حتى:
- ✅ الإضافة تظهر في Marketplace
- ✅ المستخدمين يقدرون يحملونها
- ✅ التحديث يظهر للمستخدمين الحاليين

### أعلن عن التحديث:
- GitHub Release
- README.md
- Social Media

---

## 🎯 الخلاصة

**أسرع طريقة:**
1. افتح: https://marketplace.visualstudio.com/manage/publishers/tareq-alomari
2. Update → Upload `scrcpy-smart-2.5.0.vsix`
3. تم! ✅

**أو من Terminal:**
```bash
vsce publish
```

---

## 📞 مساعدة

إذا واجهت مشاكل:
- [VS Code Publishing Guide](https://code.visualstudio.com/api/working-with-extensions/publishing-extension)
- [vsce Documentation](https://github.com/microsoft/vscode-vsce)
