# 🚀 Scrcpy Smart Connect

<div align="center">

[![إصدار GitHub](https://img.shields.io/github/v/release/tareq-alomari/scrcpy-smart)](https://github.com/tareq-alomari/scrcpy-smart/releases)
[![CI](https://github.com/tareq-alomari/scrcpy-smart/workflows/CI/badge.svg)](https://github.com/tareq-alomari/scrcpy-smart/actions)
[![الترخيص: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
[![المنصة](https://img.shields.io/badge/platform-Linux%20%7C%20macOS%20%7C%20Windows-blue)](https://github.com/tareq-alomari/scrcpy-smart)

**مدير اتصال لاسلكي ذكي لـ scrcpy - اتصل بأجهزة Android عبر WiFi تلقائياً**

[English](../README.md) · [العربية](README.ar.md) · [Español](README.es.md) · [中文](README.zh.md)

[المميزات](#-المميزات) • [التثبيت](#-التثبيت-السريع) • [الاستخدام](#-الاستخدام) • [التوثيق](https://github.com/tareq-alomari/scrcpy-smart/wiki)

</div>

---

## 🆕 ما الجديد في v2.1.0

- 🔄 **إعادة تسمية الأجهزة**: أعد تسمية الأجهزة المحفوظة لتنظيم أفضل
- 📸 **لقطة شاشة**: التقط لقطة شاشة سريعة بدون واجهة رسومية
- 🔌 **منفذ مخصص**: دعم منافذ ADB مخصصة
- 🌐 **IP مباشر**: اتصل بعناوين IP محددة مباشرة
- 🔇 **بدون صوت**: خيار لتعطيل نقل الصوت
- 🧹 **مسح السجلات**: امسح سجلات الاتصال بسهولة

[شاهد سجل التغييرات الكامل](../CHANGELOG.md)

---

## ✨ المميزات

- 🔄 **إعادة اتصال تلقائية**: يحفظ IP الجهاز ويتصل لاسلكياً
- 📱 **احتياطي USB**: يرجع تلقائياً لـ USB إذا فشل الاتصال اللاسلكي
- 🎯 **اختيار ذكي للجهاز**: يفضل الاتصال اللاسلكي على USB
- ⚡ **أداء محسّن**: معد مسبقاً لـ 60 FPS وجودة متوازنة
- 💾 **حفظ IP**: يحفظ IP الجهاز للاتصالات المستقبلية
- 🖥️ **متعدد المنصات**: يعمل على Linux و macOS و Windows
- 🛠️ **خيارات CLI**: واجهة سطر أوامر كاملة
- 📱 **أجهزة متعددة**: اختر من بين عدة أجهزة متصلة

## 📋 المتطلبات

- [scrcpy](https://github.com/Genymobile/scrcpy) - أداة عرض الشاشة
- [ADB](https://developer.android.com/tools/adb) - Android Debug Bridge
- جهاز Android مع تفعيل USB debugging

### التثبيت حسب النظام

<details>
<summary><b>Linux (Ubuntu/Debian)</b></summary>

```bash
sudo apt install scrcpy adb
```
</details>

<details>
<summary><b>macOS</b></summary>

```bash
brew install scrcpy android-platform-tools
```
</details>

<details>
<summary><b>Windows</b></summary>

- ثبت [scrcpy](https://github.com/Genymobile/scrcpy#windows)
- ثبت [ADB](https://developer.android.com/tools/adb)
</details>

## 🚀 التثبيت السريع

```bash
git clone https://github.com/tareq-alomari/scrcpy-smart.git
cd scrcpy-smart
./install.sh
```

أو بأمر واحد:
```bash
curl -fsSL https://raw.githubusercontent.com/tareq-alomari/scrcpy-smart/main/install.sh | bash
```

## 📖 الاستخدام

### الاستخدام الأساسي

```bash
scrcpy-smart        # الاتصال بالجهاز
phone               # نفس الشيء باستخدام الاختصار
```

### خيارات سطر الأوامر

```bash
scrcpy-smart --help      # عرض المساعدة
scrcpy-smart --version   # عرض الإصدار
scrcpy-smart --config    # عرض الإعدادات الحالية
scrcpy-smart --reset     # إعادة تعيين IP المحفوظ
scrcpy-smart --list      # عرض جميع الأجهزة
scrcpy-smart --select    # اختيار جهاز يدوياً
```

### الإعداد الأول

1. وصّل جهاز Android عبر USB
2. فعّل USB debugging على جهازك
3. شغّل: `scrcpy-smart`

السكربت سيقوم بـ:
- ✅ اكتشاف جهازك
- ✅ الحصول على عنوان IP
- ✅ التحويل للوضع اللاسلكي
- ✅ حفظ IP للاستخدام المستقبلي

### الاستخدامات اللاحقة

فقط شغّل `scrcpy-smart` أو `phone` - **بدون كيبل USB!**

## ⚙️ الإعدادات

يتم حفظ الإعدادات في `~/.scrcpy-config`

### ضبط الأداء

عدّل `scrcpy-smart.sh` وغيّر معاملات scrcpy:

```bash
scrcpy -s "$SAVED_IP:5555" --max-size 1024 --bit-rate 8M --max-fps 60
```

**الإعدادات المسبقة:**

| الإعداد | الدقة | Bitrate | FPS | الاستخدام |
|---------|-------|---------|-----|-----------|
| أداء | 720 | 4M | 30 | WiFi ضعيف |
| متوازن | 1024 | 8M | 60 | افتراضي |
| جودة | 1920 | 16M | 60 | WiFi قوي |

## 🐛 حل المشاكل

<details>
<summary><b>فشل الاتصال</b></summary>

- تأكد أن الجهاز والكمبيوتر على نفس شبكة WiFi
- تحقق من تفعيل USB debugging
- جرب: `scrcpy-smart --reset`
- أعد تشغيل ADB: `adb kill-server && adb start-server`
</details>

<details>
<summary><b>تقطيع أو بطء</b></summary>

- قلل bitrate: `--bit-rate 4M`
- قلل الدقة: `--max-size 720`
- تحقق من قوة إشارة WiFi
- استخدم WiFi 5GHz إن أمكن
</details>

<details>
<summary><b>أجهزة متعددة</b></summary>

- استخدم: `scrcpy-smart --list` لعرض الكل
- استخدم: `scrcpy-smart --select` للاختيار
</details>

## 📚 التوثيق

- [Wiki](https://github.com/tareq-alomari/scrcpy-smart/wiki) - توثيق مفصل
- [الأسئلة الشائعة](https://github.com/tareq-alomari/scrcpy-smart/wiki/FAQ)
- [حل المشاكل](https://github.com/tareq-alomari/scrcpy-smart/wiki/Troubleshooting)

## 🤝 المساهمة

المساهمات مرحب بها! الرجاء:

1. عمل Fork للمستودع
2. إنشاء فرع للميزة (`git checkout -b feature/amazing`)
3. حفظ التغييرات (`git commit -m 'إضافة ميزة رائعة'`)
4. رفع للفرع (`git push origin feature/amazing`)
5. فتح Pull Request

## 📄 الترخيص

ترخيص MIT - انظر ملف [LICENSE](../LICENSE) للتفاصيل.

## 🙏 الشكر

- [scrcpy](https://github.com/Genymobile/scrcpy) من Genymobile - أداة عرض الشاشة الرائعة
- تطوير [طارق العمري](https://github.com/tareq-alomari)

## 💡 حالات الاستخدام

- 📱 تطوير Flutter/React Native مع hot reload
- 🧪 اختبار وتصحيح تطبيقات الموبايل
- 🎥 تسجيل وبث الشاشة
- 🎮 ألعاب الموبايل على الكمبيوتر
- 🖥️ التحكم عن بعد بالجهاز
- 📊 العروض التقديمية والديمو

---

<div align="center">

**صُنع بـ ❤️ لمطوري الموبايل**

[الإبلاغ عن خطأ](https://github.com/tareq-alomari/scrcpy-smart/issues) · [طلب ميزة](https://github.com/tareq-alomari/scrcpy-smart/issues)

</div>
