# إعداد السيرفر للـ Deep Linking

## الملفات المطلوب رفعها على السيرفر

### 1. رفع ملف HTML
```
📁 /public_html/ (أو المجلد الرئيسي للموقع)
└── shared-cart-redirect.html
```

### 2. تحديث ملف apple-app-site-association
```
📁 /public_html/.well-known/
└── apple-app-site-association
```

أضف هذا المحتوى:
```json
{
  "applinks": {
    "apps": [],
    "details": [
      {
        "appID": "TEAMID.com.app.baqalty",
        "paths": [
          "/shared-cart-redirect.html*",
          "/shared-cart.html*"
        ]
      }
    ]
  }
}
```

### 3. تحديث ملف assetlinks.json
```
📁 /public_html/.well-known/
└── assetlinks.json
```

أضف هذا المحتوى:
```json
[{
  "relation": ["delegate_permission/common.handle_all_urls"],
  "target": {
    "namespace": "android_app",
    "package_name": "com.app.baqalty",
    "sha256_cert_fingerprints": ["YOUR_SHA256_FINGERPRINT"]
  }
}]
```

## كيفية الحصول على SHA256 Fingerprint

### للـ Android:
```bash
keytool -list -v -keystore android/app/upload-keystore.jks -alias upload
```

### للـ iOS:
استخدم App ID من Apple Developer Console

## اختبار الـ Deep Links

### 1. اختبار الـ Redirect Page:
```
https://baqalty-back.addictaco.website/shared-cart-redirect.html?shared_cart_id=43
```

### 2. اختبار الـ Deep Link:
```
baqalty://shared-cart?id=43
```

### 3. اختبار الـ Universal Link:
```
https://baqalty-back.addictaco.website/shared-cart-redirect.html?shared_cart_id=43
```

## ملاحظات مهمة

1. **تأكد من أن الملفات موجودة على السيرفر** قبل اختبار الـ deep links
2. **تحديث الـ SHA256 fingerprint** في ملف `assetlinks.json`
3. **تحديث الـ App ID** في ملف `apple-app-site-association`
4. **اختبار على أجهزة حقيقية** وليس المحاكي فقط

## استكشاف الأخطاء

### إذا لم يعمل الـ Deep Link:
1. تأكد من رفع الملفات على السيرفر
2. تحقق من صحة الـ SHA256 fingerprint
3. تأكد من إعداد الـ AndroidManifest.xml و Info.plist
4. اختبر على جهاز حقيقي

### إذا ظهر 401 Unauthorized:
هذا طبيعي! الـ redirect page سيتعامل مع هذا ويحول المستخدم للتطبيق أو المتجر.
