<div dir="rtl">

# راهنمای تنظیم کیوسک مود (Kiosk Mode Setup Guide)

این راهنما برای تنظیم اپ به عنوان Device Owner و فعال کردن حالت کیوسک است.

## ⚠️ نکات مهم

1. **Device Owner فقط می‌تواند روی دستگاه‌های factory reset شده تنظیم شود**
2. **بعد از تنظیم Device Owner، نمی‌توان آن را حذف کرد مگر با factory reset**
3. **این تنظیمات فقط برای دستگاه‌های اختصاصی (Dedicated Devices) مناسب است**

## 📋 پیش‌نیازها

- دستگاه اندروید با Android 5.0 (Lollipop) یا بالاتر
- USB Debugging فعال
- ADB نصب شده روی کامپیوتر
- دسترسی root یا factory reset شده بودن دستگاه

## 🔧 مراحل تنظیم

### مرحله 1: فعال کردن USB Debugging

1. به **Settings** > **About phone** بروید
2. 7 بار روی **Build number** بزنید تا Developer Options فعال شود
3. به **Settings** > **Developer options** بروید
4. **USB debugging** را فعال کنید

### مرحله 2: اتصال دستگاه به کامپیوتر

```bash
# چک کردن اتصال
adb devices
```

اگر دستگاه را دیدید، ادامه دهید.

### مرحله 3: نصب اپ

```bash
# Build کردن اپ
flutter build apk --release

# نصب اپ (قبل از factory reset)
adb install -r build/app/outputs/flutter-apk/app-release.apk
```

### مرحله 4: تنظیم Device Owner

**⚠️ مهم: این مرحله فقط روی دستگاه factory reset شده کار می‌کند!**

#### گزینه 1: تنظیم روی دستگاه Factory Reset شده

```bash
# بعد از factory reset و قبل از setup اولیه اندروید
# ⚠️ مهم: package name بستگی به flavor دارد:
# - dev: top.amirdeveloper.skeleton.dev
# - stage: top.amirdeveloper.skeleton.stage  
# - prod: top.amirdeveloper.skeleton

# برای dev flavor:
adb shell dpm set-device-owner top.amirdeveloper.skeleton.dev/.KioskDeviceAdminReceiver

# برای prod flavor:
adb shell dpm set-device-owner top.amirdeveloper.skeleton/.KioskDeviceAdminReceiver
```

#### گزینه 2: تنظیم با ADB (نیاز به root یا factory reset)

```bash
# حذف تمام کاربران (فقط برای تست - خطرناک!)
adb shell pm remove-user 0

# تنظیم Device Owner
# ⚠️ مهم: package name بستگی به flavor دارد
# برای dev flavor:
adb shell dpm set-device-owner top.amirdeveloper.skeleton.dev/.KioskDeviceAdminReceiver

# برای prod flavor:
adb shell dpm set-device-owner top.amirdeveloper.skeleton/.KioskDeviceAdminReceiver
```

#### پیدا کردن package name واقعی

```bash
# لیست تمام package های نصب شده
adb shell pm list packages | grep skeleton

# یا
adb shell pm list packages -3 | grep skeleton
```

### مرحله 5: فعال کردن Lock Task Mode

بعد از تنظیم Device Owner، اپ به صورت خودکار Lock Task Mode را فعال می‌کند.

اگر نیاز به فعال کردن دستی دارید:

```bash
# از طریق ADB
adb shell dpm set-lock-task-packages top.amirdeveloper.skeleton

# یا از طریق اپ (بعد از اینکه Device Owner شد)
# اپ به صورت خودکار Lock Task Mode را فعال می‌کند
```

## 🧪 تست کردن

### چک کردن Device Owner

```bash
adb shell dpm list-owners
```

باید package name اپ را ببینید (مثلاً `top.amirdeveloper.skeleton.dev` برای dev flavor).

### چک کردن Lock Task Packages

```bash
adb shell dpm get-lock-task-packages
```

باید package name اپ را ببینید (مثلاً `top.amirdeveloper.skeleton.dev` برای dev flavor).

### تست از طریق اپ

در اپ می‌توانید از `KioskService` استفاده کنید:

```dart
final kioskService = getIt<KioskService>();

// چک کردن Device Owner
final isOwner = await kioskService.isDeviceOwner();
print('Is Device Owner: $isOwner');

// فعال کردن Lock Task Mode
await kioskService.enableLockTaskMode();

// چک کردن Lock Task Mode
final isLocked = await kioskService.isLockTaskModeActive();
print('Is Lock Task Mode Active: $isLocked');
```

## 🔓 خروج از کیوسک مود

### روش 1: از طریق ADB

```bash
# غیرفعال کردن Lock Task Mode
adb shell dpm clear-lock-task-packages

# یا
adb shell am task lock stop
```

### روش 2: Factory Reset

تنها راه حذف Device Owner، factory reset کردن دستگاه است:

```bash
adb reboot recovery
# سپس از منوی recovery، Factory Reset را انتخاب کنید
```

## 📱 استفاده در Production

برای استفاده در production:

1. **دستگاه را factory reset کنید**
2. **قبل از setup اولیه اندروید، Device Owner را تنظیم کنید**
3. **اپ را نصب کنید**
4. **اپ به صورت خودکار Lock Task Mode را فعال می‌کند**

## 🛠️ Troubleshooting

### خطا: "Not allowed to set the package as device owner"

**راه حل:**
- دستگاه باید factory reset شده باشد
- نباید هیچ کاربری روی دستگاه وجود داشته باشد
- باید قبل از setup اولیه اندروید تنظیم شود

### خطا: "Device owner already set"

**راه حل:**
- Device Owner قبلاً تنظیم شده
- برای تغییر، باید factory reset کنید

### اپ در Lock Task Mode نمی‌رود

**راه حل:**
- چک کنید که Device Owner تنظیم شده باشد
- چک کنید که package name درست باشد
- از `adb shell dpm get-lock-task-packages` استفاده کنید

## 📚 منابع بیشتر

- [Android Device Policy Manager](https://developer.android.com/reference/android/app/admin/DevicePolicyManager)
- [Lock Task Mode](https://developer.android.com/work/dpc/dedicated-devices/lock-task-mode)
- [Device Owner](https://developer.android.com/work/dpc/dedicated-devices)

## ⚠️ هشدارهای امنیتی

1. **هرگز Device Owner را روی دستگاه شخصی تنظیم نکنید**
2. **بعد از تنظیم Device Owner، نمی‌توانید آن را حذف کنید مگر با factory reset**
3. **این تنظیمات فقط برای دستگاه‌های اختصاصی (Kiosk Devices) مناسب است**
4. **قبل از تنظیم، از داده‌های مهم backup بگیرید**


</div>