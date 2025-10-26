# الملفات المطلوب رفعها على السيرفر

## 📁 هيكل الملفات على السيرفر:

```
📁 /public_html/ (أو المجلد الرئيسي للموقع)
├── shared-cart.html                  ← تحديث الملف الموجود
├── shared-cart-redirect.html        ← ملف إضافي
└── .well-known/
    ├── assetlinks.json              ← موجود بالفعل
    └── apple-app-site-association  ← ملف جديد
```

## 🚀 خطوات الرفع:

### 1. تحديث الملف الموجود:
```
📤 shared-cart.html
📍 /public_html/shared-cart.html (استبدال الملف الموجود)
```

### 2. رفع الملف الإضافي:
```
📤 shared-cart-redirect.html
📍 /public_html/shared-cart-redirect.html
```

### 3. رفع ملف iOS:
```
📤 apple-app-site-association
📍 /public_html/.well-known/apple-app-site-association
```

### 3. التأكد من ملف Android (موجود بالفعل):
```
📁 /public_html/.well-known/assetlinks.json ✅
```

## 🔗 اختبار الـ Links:

### بعد الرفع، اختبر هذه الروابط:

1. **الرابط الجديد:**
   ```
   https://baqalty-back.addictaco.website/shared-cart-redirect.html?shared_cart_id=43
   ```

2. **الرابط القديم (سيظهر 401 - هذا طبيعي):**
   ```
   https://baqalty-back.addictaco.website/api/v1/cart?shared_cart_id=43
   ```

## ✅ النتيجة المتوقعة:

- **الرابط الجديد**: سيعمل بدون 401 وسيفتح التطبيق
- **الرابط القديم**: سيظهر 401 (هذا طبيعي ومتوقع)

## 📝 ملاحظة مهمة:

الآن عندما يشارك المستخدم السلة، سيتم استخدام الرابط الجديد بدلاً من القديم، ولن يظهر 401!
