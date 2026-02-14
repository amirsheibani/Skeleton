# RFC-001: معماری و قوانین پروژه Skeleton

**وضعیت:** پیشنهاد (Draft)  
**تاریخ:** 2025  
**نویسنده:** تیم پروژه

---

## خلاصه

این RFC معماری، لایه‌بندی، قوانین وابستگی و قراردادهای نام‌گذاری پروژه Flutter با نام Skeleton را تعریف می‌کند تا همهٔ فیچرها و تغییرات بعدی در یک چارچوب یکسان پیش بروند.

---

## زمینه و انگیزه

- پروژه یک **اسکلت (skeleton)** چندفلِیور (dev / stage / prod) با احراز هویت و قابلیت کیوسک روی اندروید است.
- نیاز به یک ساختار **feature-first**، **قابل گسترش** و **قابل تست** داریم بدون قفل شدن روی یک فریمورک خاص (مثلاً فقط GetX یا فقط Bloc).
- لازم است برای اضافه کردن فیچرهای جدید (مثل my_ip)، سرویس‌های جدید و تغییرات بزرگ یک **مرجع مکتوب** وجود داشته باشد تا بحث و تصمیم‌گیری شفاف باشد.

---

## دامنه

- ساختار پوشه‌ها و لایه‌ها در `lib/`.
- قوانین Clean Architecture و جهت وابستگی بین لایه‌ها.
- قراردادهای نام‌گذاری (فایل، کلاس، پوشه، state).
- نقش `core`، `app` و `features`.
- نحوهٔ پیشنهاد و ثبت تغییرات بزرگ (از طریق RFCهای بعدی).

---

## تصمیمات

### ۱. ساختار کلی

- **app:** فقط shell اپ و routing (go_router). بدون منطق کسب‌وکار.
- **core:** کد مشترک (DI، theme، handlerها، extensionها، config، env). بدون کد مخصوص یک فیچر.
- **features:** هر فیچر در یک پوشه؛ می‌تواند زیرمجموعهٔ یک layout (مثل main_layout) باشد.
- **ورودی اپ:** `main_dev.dart`، `main_stage.dart`، `main_prod.dart` با تنظیم `Environment` و سپس `bootstrap` و `runApp`.

### ۲. لایه‌بندی داخل هر فیچر (Clean Architecture)

- **domain (اختیاری):** entityها و قرارداد repository؛ بدون وابستگی به Flutter یا فریمورک.
- **data (اختیاری):** پیاده‌سازی repository، datasource، DTO و مپر به entity.
- **presentation:** همیشه؛ شامل manager (state)، pages و در صورت نیاز widgets.

وابستگی فقط به سمت داخل: `presentation` → `domain` ← `data`. هیچ لایه‌ای به لایهٔ بیرونی وابسته نباشد.

### ۳. قوانین وابستگی

- فیچرها یکدیگر را مستقیم import نمی‌کنند؛ اشتراک از طریق core یا وابستگی صریح (با ذکر در RFC در صورت نیاز).
- Manager سرویس را از DI (GetIt) می‌گیرد، نه از `BuildContext`.
- Core به هیچ فیچر وابسته نمی‌شود.

### ۴. نام‌گذاری

- فایل: `snake_case.dart`.
- کلاس/تایپ: `PascalCase`.
- متغیر/تابع/پارامتر: `camelCase`.
- پوشهٔ فیچر: `snake_case`.
- صفحهٔ تمام‌صفحه: پسوند `_page`؛ ویجت قابل استفاده مجدد: `_widget`؛ state/notifier: `_state`, `_notifier`, `_provider`.

### ۵. ابزارهای فعلی (قابل تعویض با RFC جدا)

- State: Riverpod  
- Routing: go_router  
- DI: get_it + injectable  
- شبکه: Dio + Retrofit  
- احراز هویت نمونه: Supabase  
- L10n: flutter_intl (ARB)

معماری به یک فریمورک خاص وابسته نیست؛ تعویض state یا auth با RFC و تغییر محدود در لایه‌های مربوطه مجاز است.

### ۶. کیوسک (Android)

- تنظیم Device Owner و کیوسک طبق سند جدا (مثلاً KIOSK_SETUP.md).
- کامپوننت ادمین: `top.amirdeveloper.skeleton.KioskDeviceAdminReceiver`؛ فرمت set-device-owner بر اساس flavor در همان سند.

---

## مثال مرجع: فیچر my_ip

- **domain:** entity مثل `MyIpInfo`، قرارداد `GetMyIpRepository`.
- **data:** مدل DTO (مثلاً `IpModel`)، datasource، پیاده‌سازی repository و مپر به entity.
- **presentation:** `MyIpPage`، `MyIpNotifier`/`MyIpState`؛ استفاده فقط از repository تزریق‌شده.

ساختار پوشه و نام فایل‌ها مطابق بخش لایه‌بندی و نام‌گذاری همین RFC است.

---

## RFCهای بعدی

- تغییرات شکست‌ناپذیر در معماری یا قوانین با یک RFC جدید پیشنهاد و پس از توافق اعمال شود.
- هر RFC شماره و عنوان و وضعیت (Draft / Accepted / Deprecated) داشته باشد.

---

## مراجع

- README پروژه (ساختار، Clean، لایه‌بندی، نام‌گذاری).
- KIOSK_SETUP.md برای تنظیمات کیوسک.
