# 📚 المحاضرة 1: مقدمة وإعداد البيئة

**المدة**: 30 دقيقة  
**المستوى**: مبتدئ

---

## 🎯 أهداف المحاضرة

بنهاية هذه المحاضرة ستكون قادراً على:
- ✅ فهم ما هي إضافات VSCode
- ✅ إعداد بيئة التطوير
- ✅ تثبيت الأدوات المطلوبة
- ✅ إنشاء أول مشروع إضافة

---

## 📖 ما هي إضافات VSCode؟

إضافات VSCode هي برامج صغيرة تضيف وظائف جديدة لمحرر VSCode.

### أمثلة شهيرة:
- **Prettier**: تنسيق الكود
- **ESLint**: فحص الأخطاء
- **GitLens**: تحسين Git
- **Live Server**: خادم محلي

### لماذا نبني إضافات؟
- 🎯 حل مشاكل محددة
- 🚀 أتمتة المهام المتكررة
- 💡 مشاركة الأدوات مع الآخرين
- 📈 بناء portfolio

---

## 🛠️ إعداد البيئة

### 1. تثبيت Node.js

```bash
# تحقق من التثبيت
node --version  # يجب أن يكون v16 أو أحدث
npm --version   # يجب أن يكون v8 أو أحدث
```

**إذا لم يكن مثبتاً:**
- Linux: `sudo apt install nodejs npm`
- macOS: `brew install node`
- Windows: تحميل من nodejs.org

### 2. تثبيت VSCode

```bash
# تحقق من التثبيت
code --version  # يجب أن يكون v1.80 أو أحدث
```

**إذا لم يكن مثبتاً:**
- تحميل من: https://code.visualstudio.com/

### 3. تثبيت Yeoman و Generator

```bash
# تثبيت عالمي
npm install -g yo generator-code

# تحقق من التثبيت
yo --version
```

### 4. تثبيت TypeScript

```bash
# تثبيت عالمي
npm install -g typescript

# تحقق من التثبيت
tsc --version
```

---

## 🚀 إنشاء أول مشروع

### الطريقة 1: باستخدام Yeoman (موصى به)

```bash
# إنشاء مجلد المشروع
mkdir my-first-extension
cd my-first-extension

# تشغيل المولد
yo code

# اختر:
# ? What type of extension do you want to create? New Extension (TypeScript)
# ? What's the name of your extension? My First Extension
# ? What's the identifier of your extension? my-first-extension
# ? What's the description of your extension? My first VSCode extension
# ? Initialize a git repository? Yes
# ? Which package manager to use? npm
```

### الطريقة 2: يدوياً

```bash
# إنشاء المجلد
mkdir my-first-extension
cd my-first-extension

# إنشاء package.json
npm init -y

# تثبيت التبعيات
npm install --save-dev @types/vscode @types/node typescript

# إنشاء tsconfig.json
tsc --init
```

---

## 📁 بنية المشروع

بعد الإنشاء، ستجد:

```
my-first-extension/
├── .vscode/
│   ├── launch.json      # إعدادات التصحيح
│   └── tasks.json       # مهام البناء
├── src/
│   └── extension.ts     # الكود الرئيسي
├── .gitignore
├── package.json         # معلومات الإضافة
├── tsconfig.json        # إعدادات TypeScript
└── README.md
```

---

## 🔍 فحص الملفات

### package.json

```json
{
  "name": "my-first-extension",
  "displayName": "My First Extension",
  "description": "My first VSCode extension",
  "version": "0.0.1",
  "engines": {
    "vscode": "^1.80.0"
  },
  "categories": ["Other"],
  "activationEvents": [],
  "main": "./out/extension.js",
  "contributes": {
    "commands": [
      {
        "command": "my-first-extension.helloWorld",
        "title": "Hello World"
      }
    ]
  }
}
```

### src/extension.ts

```typescript
import * as vscode from 'vscode';

export function activate(context: vscode.ExtensionContext) {
    console.log('Extension is now active!');

    let disposable = vscode.commands.registerCommand(
        'my-first-extension.helloWorld',
        () => {
            vscode.window.showInformationMessage('Hello World!');
        }
    );

    context.subscriptions.push(disposable);
}

export function deactivate() {}
```

---

## 🧪 تشغيل الإضافة

### 1. فتح المشروع في VSCode

```bash
code .
```

### 2. تشغيل وضع التصحيح

- اضغط `F5` أو
- اذهب إلى: Run → Start Debugging

سيفتح نافذة VSCode جديدة (Extension Development Host)

### 3. تجربة الأمر

في النافذة الجديدة:
- اضغط `Ctrl+Shift+P`
- اكتب: "Hello World"
- اضغط Enter

يجب أن ترى رسالة: "Hello World!"

---

## 🎓 تمرين عملي

### المهمة:
قم بتعديل الرسالة لتقول "مرحباً بك في أول إضافة!"

### الخطوات:
1. افتح `src/extension.ts`
2. غير النص في `showInformationMessage`
3. احفظ الملف
4. أعد تشغيل التصحيح (F5)
5. جرب الأمر مرة أخرى

### الحل:

```typescript
vscode.window.showInformationMessage('مرحباً بك في أول إضافة!');
```

---

## ✅ ملخص المحاضرة

تعلمنا:
- ✅ ما هي إضافات VSCode
- ✅ إعداد بيئة التطوير
- ✅ تثبيت الأدوات المطلوبة
- ✅ إنشاء أول مشروع
- ✅ تشغيل وتجربة الإضافة

---

## 📝 واجب منزلي

1. أنشئ إضافة جديدة باسمك
2. غير الأمر ليعرض اسمك
3. جرب تشغيلها
4. التقط screenshot للنتيجة

---

## 🔗 موارد إضافية

- [VSCode Extension API](https://code.visualstudio.com/api)
- [Extension Samples](https://github.com/microsoft/vscode-extension-samples)
- [TypeScript Handbook](https://www.typescriptlang.org/docs/)

---

## ➡️ المحاضرة التالية

[المحاضرة 2: بنية المشروع](02-project-structure.md)

---

**أسئلة؟** tareq.software.devloper@gmail.com
