# Skeleton

A Flutter project skeleton with a **package-agnostic** feature-based architecture. The structure does not lock you into a specific state management or routing library—you can use Riverpod, Bloc, GetX, or others while keeping the same layering and conventions.

---

# English

## Overview

This project follows a **feature-first** structure with clear separation between **core** (shared utilities, DI, theme, services) and **features** (screens and their logic). Each feature is self-contained with its own state, pages, and widgets.

## Project Structure

```
lib/
├── app/                    # App shell & routing
│   ├── app.dart            # Root widget, theme, locale
│   └── router.dart         # go_router config & routes
├── bootstrap.dart          # App initialization (Supabase, DI, permissions)
├── main_dev.dart           # Dev entry + DevEnvironment
├── main_prod.dart          # Prod entry + ProdEnvironment
├── main_stage.dart         # Staging entry + StageEnvironment
├── core/                   # Shared code (no feature logic)
│   ├── common/extension/   # Extensions (context, string, int, date, etc.)
│   ├── config/             # Locale, app config
│   ├── di/                 # Dependency injection (GetIt + Injectable)
│   │   ├── base/           # di_setup, generated config
│   │   ├── local/          # Device, local services
│   │   └── remote/         # API client, interceptors
│   ├── env/                # Environment (dev/stage/prod)
│   ├── handler/            # Services & result types
│   │   ├── base/           # Result, BaseResponse
│   │   └── service/        # Auth, GPS, NFC, Internet, etc.
│   ├── theme/              # Theme + theme manager (light/dark/system)
│   └── widgets/            # Shared UI (overlay, dismiss keyboard)
├── features/               # Feature modules
│   ├── splash/
│   │   └── presentation/
│   │       ├── manager/    # splash_notifier, splash_provider, splash_state
│   │       └── pages/      # splash_page
│   ├── auth_layout/
│   │   └── presentation/
│   │       ├── features/   # login, register (sub-features)
│   │       │   ├── login/
│   │       │   │   └── presentation/
│   │       │   │       ├── manager/   # notifier, provider, state
│   │       │   │       ├── pages/     # login_page
│   │       │   │       └── widgets/   # login_password_field, etc.
│   │       │   └── register/ ...
│   │       ├── layout/     # auth_layout.dart
│   │       └── widgets/    # shared auth widgets (logo, social buttons)
│   └── main_layout/
│       └── presentation/
│           ├── features/   # home, profile, gps_info, car_slope, motion_info
│           │   └── <feature>/
│           │       └── presentation/
│           │           ├── manager/
│           │           ├── pages/
│           │           └── widgets/   (optional)
│           └── pages/      # main_layout.dart (shell)
├── l10n/                   # ARB files (intl_en.arb, intl_fa.arb)
└── generated/              # Generated l10n (do not edit)
```

## Layers & Responsibilities

| Layer | Purpose | Rules |
|-------|---------|--------|
| **app** | Root widget, router, global config | No business logic. Only wiring. |
| **core** | Reusable across features | No feature-specific code. No direct UI for a single feature. |
| **features** | One folder per feature (or layout group) | Feature code stays inside its folder. Cross-feature use only via core or explicit dependencies. |
| **presentation** | UI + state for a feature | Split into **manager** (state/logic), **pages** (full screens), **widgets** (reusable pieces inside the feature). |
| **manager** | State holder (e.g. Notifier/Cubit), provider, state classes | Handles events and emits state. Gets services from DI (GetIt), not from context. |
| **pages** | Full-screen widgets | Compose widgets, listen to manager (e.g. ref.watch(provider)), navigate. |
| **widgets** | Reusable UI inside the feature | Prefer small, focused widgets. Naming: `<feature>_<name>_widget.dart` or `<feature>_<name>.dart`. |

## Clean Architecture

- **Layers:** A feature can have `domain`, `data`, and `presentation` layers. Dependencies point inward only: presentation → domain ← data.
- **Domain:** Pure models (entities), repository contracts (abstract interfaces), and optionally use cases. No dependency on Flutter or any framework.
- **Data:** Repository implementations, data sources (remote/local), DTOs and mappers to entities. Depends only on domain.
- **Presentation:** UI and state (e.g. Riverpod); uses only domain/use case or injected repository.
- **Core:** Shared code (DI, theme, handlers, extensions) lives in `core/` and is used by features; features may depend on core, core must not depend on any feature.
- **Dependency rule:** No layer may depend on an outer layer (e.g. domain must not depend on data or presentation).

**Example (my_ip feature):** For “show device IP” you can implement:
- **domain:** Entity e.g. `MyIpInfo`, contract `GetMyIpRepository`; no Flutter or API dependency.
- **data:** e.g. `GetMyIpRepositoryImpl` that fetches IP from a service/API and maps DTO to entity.
- **presentation:** `MyIpPage`, `MyIpNotifier`/`MyIpState` that only get the repository from DI and render from state.

## Layering (per feature)

Suggested folder structure and dependency direction:

```
feature_name/
├── domain/                    # Core logic; no Flutter/framework dependency
│   ├── entities/
│   ├── repositories/          # Interface contracts
│   └── use_cases/             # Optional: single action (e.g. GetUserProfile)
├── data/
│   ├── datasources/           # remote (API) and local (DB/cache)
│   ├── models/                # DTOs and mappers to entity
│   └── repositories/          # Implementations of domain interfaces
└── presentation/
    ├── manager/               # Notifier/Provider and State
    ├── pages/
    └── widgets/
```

- **Dependency direction:** presentation → domain ← data. Domain does not depend on any other layer.
- **Core** is shared; features may depend on core, core must not depend on features.
- **app/** is only routing and shell; it depends on core and features.

If a feature is simple, you can start with only `presentation` and use handlers/services from core; add `domain` and `data` as the feature grows.

**Example folder structure for my_ip:**

```
features/my_ip/
├── domain/
│   ├── entities/
│   │   └── my_ip_info.dart
│   └── repositories/
│       └── get_my_ip_repository.dart
├── data/
│   ├── datasources/
│   │   └── my_ip_remote_datasource.dart
│   ├── models/
│   │   └── my_ip_dto.dart
│   └── repositories/
│       └── get_my_ip_repository_impl.dart
└── presentation/
    ├── manager/
    │   ├── my_ip_notifier.dart
    │   ├── my_ip_provider.dart
    │   └── my_ip_state.dart
    ├── pages/
    │   └── my_ip_page.dart
    └── widgets/
        └── my_ip_display_widget.dart
```

## Conventions & Rules

### Naming

- **Files:** `snake_case` (e.g. `login_notifier.dart`, `car_slope_page.dart`). Avoid capital letters in the middle (e.g. use `motion_info_page.dart`, not `motion_Info_page.dart`).
- **Folders:** `snake_case` (e.g. `auth_layout`, `car_slope_info`).
- **Classes:** `PascalCase` (e.g. `LoginNotifier`, `LoginState`).
- **State classes:** Descriptive and consistent (e.g. `LoginInit`, `LoginLoading`, `LoginSuccess`, `LoginFailed`).

### Feature layout

- **Layout feature** (e.g. `auth_layout`, `main_layout`): holds a shell (layout + navigation) and **features** as children.
- **Screen feature** (e.g. `login`, `home`): has `presentation/manager`, `presentation/pages`, and optionally `presentation/widgets`.

### Dependency rules

- **Features** must not import other features directly. Shared logic goes in **core** (handlers, extensions, DI).
- **Manager** gets services via **GetIt** (or your DI), not from BuildContext.
- **Pages** use the manager via provider (e.g. Riverpod’s `ref.watch` / `ref.read`). No business logic in pages.

### State management (current setup)

- **StateNotifier** (or Cubit/Bloc if you switch) holds logic; **sealed/final state classes** represent UI states.
- One **provider** per manager (e.g. `loginProvider`). Provider file can also export the notifier type for tests.

### Routing

- Routes are defined in **app/router.dart**.
- Use an enum (e.g. `AppRouterPath`) for path constants to avoid magic strings.
- Use **ShellRoute** for layout shells (auth shell, main shell); attach child routes to the shell.

### Environment

- **core/env/environment.dart**: base `Environment` and variants (`DevEnvironment`, `StageEnvironment`, `ProdEnvironment`).
- **main_dev.dart**, **main_prod.dart**, **main_stage.dart**: set `environment = ...`, then call `appConfiguration()` and `runApp(...)`.
- Never commit real API keys or secrets; use env files or CI secrets and pass them into the Environment.

### Localization

- **l10n/**: `intl_en.arb`, `intl_fa.arb` (and others if needed).
- **generated/**: generated by flutter_intl; do not edit by hand.
- Use the generated `S` class (e.g. `S.of(context).someKey`) in the UI.

### DI (GetIt + Injectable)

- Register dependencies in **core/di** (e.g. `remote/remote_module.dart`, handler modules).
- Run **build_runner** after adding `@injectable` / `@lazySingleton` so **di_setup.config.dart** is updated.
- Use `getIt<MyService>()` in app code; avoid passing GetIt everywhere.

## How to Use

### Run the app

```bash
# Dev
flutter run -t lib/main_dev.dart

# Staging
flutter run -t lib/main_stage.dart

# Prod
flutter run -t lib/main_prod.dart
```

### Add a new feature (under main_layout)

1. Create folder: `lib/features/main_layout/presentation/features/<feature_name>/presentation/`.
2. Add **manager**: `manager/<feature>_notifier.dart`, `<feature>_provider.dart`, `<feature>_state.dart`.
3. Add **page**: `pages/<feature>_page.dart`.
4. Add **widgets** (optional): `widgets/<feature>_*.dart`.
5. Register route in **app/router.dart** and add a navigation item in **main_layout** if needed.
6. Register any new service in **core/di** and run `dart run build_runner build --delete-conflicting-outputs` if you use Injectable.

### Add a new core service

1. Create handler/service in **core/handler/service/** (e.g. `my_service_handler.dart`).
2. Create a module (or add to an existing one) and register in **core/di**.
3. Annotate with `@injectable` / `@lazySingleton` and run build_runner.
4. Use `getIt<MyService>()` in the notifier/cubit that needs it.

### Add a new extension

- Add file under **core/common/extension/** (e.g. `my_extension.dart`). Use in any feature or core code.

## Tools & Libraries

| Purpose | Package | Usage |
|--------|---------|--------|
| State management | flutter_riverpod | Providers + StateNotifier in manager layer |
| Routing | go_router | Declarative routes, ShellRoute for layouts |
| DI | get_it + injectable | Registration in core/di, generated init |
| HTTP | dio + retrofit | API client in core/di/remote, interceptors |
| Auth (example) | supabase_flutter | Used in auth handler; replaceable |
| Localization | flutter_intl | ARB in l10n/, generated S class |
| Linting | flutter_lints | analysis_options.yaml |

The architecture is **not tied** to a single framework (e.g. GetX). You can swap state management (e.g. to Bloc) or auth (e.g. to Firebase) by replacing only the manager and handler layers and keeping the same folder structure and layering rules.

## References

- [Flutter documentation](https://docs.flutter.dev/)
- [Flutter architecture samples](https://github.com/brianegan/flutter_architecture_samples)
- [go_router](https://pub.dev/packages/go_router)
- [Riverpod](https://riverpod.dev/)
- [get_it](https://pub.dev/packages/get_it) · [injectable](https://pub.dev/packages/injectable)
- [Dio](https://pub.dev/packages/dio) · [Retrofit](https://pub.dev/packages/retrofit)
- [Supabase Flutter](https://supabase.com/docs/reference/dart/introduction)
- [flutter_intl](https://plugins.jetbrains.com/plugin/13666-flutter-intl)

---

<div dir="rtl">

# فارسی

## نمای کلی

این پروژه با ساختار **feature-first** طراحی شده و مرز مشخصی بین **core** (ابزارهای مشترک، DI، تم، سرویس‌ها) و **features** (صفحات و منطق آن‌ها) دارد. هر feature به صورت مستقل state، pages و widgets خود را دارد.

## ساختار پروژه
</div>
<div dir="ltr">

```
lib/
├── app/                    # پوسته اپ و مسیریابی
│   ├── app.dart            # ویجت روت، تم، زبان
│   └── router.dart         # تنظیمات go_router و مسیرها
├── bootstrap.dart          # مقداردهی اولیه اپ (Supabase، DI، دسترسی‌ها)
├── main_dev.dart           # نقطه ورود محیط توسعه
├── main_prod.dart          # نقطه ورود محیط تولید
├── main_stage.dart         # نقطه ورود محیط استیج
├── core/                   # کد مشترک (بدون منطق feature)
│   ├── common/extension/   # اکستنشن‌ها (context، string، int، date و ...)
│   ├── config/             # لوکال و تنظیمات اپ
│   ├── di/                 # تزریق وابستگی (GetIt + Injectable)
│   │   ├── base/           # di_setup و فایل تولیدشده
│   │   ├── local/          # دستگاه و سرویس‌های محلی
│   │   └── remote/         # کلاینت API و اینترسپتورها
│   ├── env/                # محیط (dev / stage / prod)
│   ├── handler/            # سرویس‌ها و نوع Result
│   │   ├── base/           # Result، BaseResponse
│   │   └── service/        # Auth، GPS، NFC، اینترنت و ...
│   ├── theme/              # تم و مدیریت تم (روشن/تاریک/سیستم)
│   └── widgets/            # UI مشترک (overlay، dismiss keyboard)
├── features/               # ماژول‌های feature
│   ├── splash/
│   │   └── presentation/
│   │       ├── manager/    # splash_notifier، provider، state
│   │       └── pages/      # splash_page
│   ├── auth_layout/
│   │   └── presentation/
│   │       ├── features/   # login، register
│   │       │   ├── login/
│   │       │   │   └── presentation/
│   │       │   │       ├── manager/   # notifier، provider، state
│   │       │   │       ├── pages/     # login_page
│   │       │   │       └── widgets/   # فیلد پسورد، لینک ثبت‌نام و ...
│   │       │   └── register/ ...
│   │       ├── layout/     # auth_layout.dart
│   │       └── widgets/    # ویجت‌های مشترک auth (لوگو، دکمه‌های شبکه اجتماعی)
│   └── main_layout/
│       └── presentation/
│           ├── features/   # home، profile، gps_info، car_slope، motion_info
│           │   └── <feature>/
│           │       └── presentation/
│           │           ├── manager/
│           │           ├── pages/
│           │           └── widgets/   (اختیاری)
│           └── pages/      # main_layout.dart (پوسته)
├── l10n/                   # فایل‌های ARB (intl_en.arb، intl_fa.arb)
└── generated/              # خروجی l10n (دستکاری نکنید)
```

</div>
<div dir="rtl">

## لایه‌ها و مسئولیت‌ها

| لایه | هدف | قوانین |
|------|-----|--------|
| **app** | ویجت روت، روتر، تنظیمات سراسری | بدون منطق کسب‌وکار؛ فقط اتصال. |
| **core** | قابل استفاده در همه featureها | بدون کد مخصوص یک feature؛ بدون UI اختصاصی یک feature. |
| **features** | یک پوشه به ازای هر feature (یا گروه layout) | کد feature فقط داخل همان پوشه. استفاده بین featureها فقط از طریق core یا وابستگی صریح. |
| **presentation** | UI و state یک feature | تقسیم به **manager** (state/منطق)، **pages** (صفحات کامل)، **widgets** (قطعات قابل استفاده داخل همان feature). |
| **manager** | نگهدارنده state (مثلاً Notifier/Cubit)، provider، کلاس‌های state | رویدادها را هندل و state را emit می‌کند. سرویس‌ها را از DI (GetIt) می‌گیرد، نه از context. |
| **pages** | ویجت‌های تمام‌صفحه | ویجت‌ها را ترکیب می‌کند، به manager گوش می‌دهد (مثلاً ref.watch(provider))، ناوبری. |
| **widgets** | UI قابل استفاده داخل همان feature | ویجت‌های کوچک و متمرکز. نام‌گذاری: `<feature>_<name>_widget.dart` یا `<feature>_<name>.dart`. |

## Clean Architecture

- **لایه‌ها:** هر feature می‌تواند لایه‌های `domain`، `data`، `presentation` داشته باشد. وابستگی فقط از بیرون به داخل است: presentation → domain ← data.
- **Domain:** مدل‌های خالص (entities)، قرارداد repository (interface)، و در صورت نیاز use case. بدون وابستگی به Flutter یا فریمورک.
- **Data:** پیاده‌سازی repository، data source (remote/local)، DTO و مپر به entity. فقط به domain وابسته است.
- **Presentation:** UI و state (مثلاً Riverpod)؛ فقط از domain/use case یا repository تزریق‌شده استفاده می‌کند.
- **Core:** کد مشترک (DI، theme، handler، extension) در `core/` است و توسط features استفاده می‌شود؛ feature به core وابسته می‌تواند باشد، core به feature نه.
- **قانون وابستگی:** هیچ لایه‌ای به لایهٔ بیرونی وابسته نباشد (مثلاً domain به data یا presentation وابسته نباشد).

**مثال (فیچر my_ip):** برای «نمایش IP دستگاه»:
- **domain:** entity مثل `MyIpInfo`، قرارداد `GetMyIpRepository`؛ بدون وابستگی به Flutter یا API.
- **data:** مثلاً `GetMyIpRepositoryImpl` که IP را از سرویس/API می‌گیرد و DTO را به entity مپ می‌کند.
- **presentation:** `MyIpPage`، `MyIpNotifier`/`MyIpState` که فقط repository را از DI می‌گیرند و روی state رندر می‌کنند.

## لایه‌بندی (به ازای هر feature)

ساختار پوشه و جهت وابستگی پیشنهادی:

</div>
<div dir="ltr">

```
feature_name/
├── domain/                    # هستهٔ منطق؛ بدون وابستگی به Flutter/فریمورک
│   ├── entities/
│   ├── repositories/         # قرارداد (interface)
│   └── use_cases/            # اختیاری: یک عمل (مثلاً GetUserProfile)
├── data/
│   ├── datasources/          # remote (API) و local (DB/cache)
│   ├── models/               # DTO و مپر به entity
│   └── repositories/         # پیاده‌سازی interfaceهای domain
└── presentation/
    ├── manager/              # Notifier/Provider و State
    ├── pages/
    └── widgets/
```
</div>
<div dir="rtl">
- **جهت وابستگی:** presentation → domain ← data. domain به هیچ لایهٔ دیگری وابسته نیست.
- **Core** مشترک است؛ featureها می‌توانند به core وابسته باشند، core به feature وابسته نشود.
- **app/** فقط routing و shell است؛ به core و features وابسته است.

اگر feature ساده است، می‌توانید فقط `presentation` داشته باشید و از handler/سرویس core استفاده کنید؛ با رشد feature لایه‌های `domain` و `data` را اضافه کنید.

**مثال ساختار پوشه برای my_ip:**
</div>
<div dir="ltr">

```
features/my_ip/
├── domain/
│   ├── entities/
│   │   └── my_ip_info.dart
│   └── repositories/
│       └── get_my_ip_repository.dart
├── data/
│   ├── datasources/
│   │   └── my_ip_remote_datasource.dart
│   ├── models/
│   │   └── my_ip_dto.dart
│   └── repositories/
│       └── get_my_ip_repository_impl.dart
└── presentation/
    ├── manager/
    │   ├── my_ip_notifier.dart
    │   ├── my_ip_provider.dart
    │   └── my_ip_state.dart
    ├── pages/
    │   └── my_ip_page.dart
    └── widgets/
        └── my_ip_display_widget.dart
```
</div>

<div dir="rtl">

## قوانین و قراردادها

### نام‌گذاری

- **فایل‌ها:** `snake_case` (مثلاً `login_notifier.dart`, `car_slope_page.dart`). از حرف بزرگ در وسط نام پرهیز کنید (مثلاً `motion_info_page.dart` نه `motion_Info_page.dart`).
- **پوشه‌ها:** `snake_case` (مثلاً `auth_layout`, `car_slope_info`).
- **کلاس‌ها:** `PascalCase` (مثلاً `LoginNotifier`, `LoginState`).
- **کلاس‌های state:** توصیفی و یکدست (مثلاً `LoginInit`, `LoginLoading`, `LoginSuccess`, `LoginFailed`).

### چیدمان feature

- **Layout feature** (مثل `auth_layout`, `main_layout`): پوسته (layout + ناوبری) و **features** به عنوان فرزند.
- **Screen feature** (مثل `login`, `home`): دارای `presentation/manager`, `presentation/pages` و در صورت نیاز `presentation/widgets`.

### قوانین وابستگی

- **Features** نباید مستقیماً feature دیگر را import کنند. منطق مشترک در **core** (handlerها، extensionها، DI).
- **Manager** سرویس‌ها را از **GetIt** (یا DI شما) می‌گیرد، نه از BuildContext.
- **Pages** فقط از طریق provider (مثلاً `ref.watch` / `ref.read` Riverpod) با manager صحبت می‌کنند. بدون منطق کسب‌وکار در pages.

### مدیریت state (تنظیم فعلی)

- **StateNotifier** (یا Cubit/Bloc در صورت تعویض) منطق را نگه می‌دارد؛ **sealed/final state classes** وضعیت UI را نشان می‌دهند.
- یک **provider** به ازای هر manager (مثلاً `loginProvider`). فایل provider می‌تواند نوع notifier را برای تست هم export کند.

### مسیریابی

- مسیرها در **app/router.dart** تعریف می‌شوند.
- از enum (مثلاً `AppRouterPath`) برای ثابت‌های مسیر استفاده کنید تا از رشته‌های جادویی جلوگیری شود.
- برای پوسته‌های layout از **ShellRoute** استفاده کنید و مسیرهای فرزند را به آن وصل کنید.

### محیط (Environment)

- **core/env/environment.dart**: کلاس پایه `Environment` و نوع‌های مختلف (`DevEnvironment`, `StageEnvironment`, `ProdEnvironment`).
- **main_dev.dart**, **main_prod.dart**, **main_stage.dart**: مقدار `environment = ...` را تنظیم کنید، سپس `appConfiguration()` و `runApp(...)` را فراخوانی کنید.
- کلیدها و secretهای واقعی را commit نکنید؛ از env یا secretهای CI استفاده کنید و به Environment پاس بدهید.

### چندزبانگی

- **l10n/**: `intl_en.arb`, `intl_fa.arb` (و در صورت نیاز بقیه).
- **generated/**: خروجی flutter_intl؛ دستی ویرایش نشود.
- در UI از کلاس تولیدشده `S` استفاده کنید (مثلاً `S.of(context).someKey`).

### DI (GetIt + Injectable)

- وابستگی‌ها در **core/di** ثبت می‌شوند (مثلاً `remote/remote_module.dart`, ماژول‌های handler).
- بعد از اضافه کردن `@injectable` / `@lazySingleton` حتماً **build_runner** بزنید تا **di_setup.config.dart** به‌روز شود.
- در کد اپ از `getIt<MyService>()` استفاده کنید؛ از پاس دادن GetIt همه‌جا خودداری کنید.

## نحوه استفاده

### اجرای اپ

<div dir="ltr">

```bash
# توسعه
flutter run -t lib/main_dev.dart

# استیج
flutter run -t lib/main_stage.dart

# تولید
flutter run -t lib/main_prod.dart
```
</div>
<div dir="rtl">

### اضافه کردن feature جدید (زیر main_layout)

1. پوشه بسازید: `lib/features/main_layout/presentation/features/<feature_name>/presentation/`.
2. **manager** اضافه کنید: `manager/<feature>_notifier.dart`, `<feature>_provider.dart`, `<feature>_state.dart`.
3. **page** اضافه کنید: `pages/<feature>_page.dart`.
4. در صورت نیاز **widgets**: `widgets/<feature>_*.dart`.
5. مسیر را در **app/router.dart** ثبت و در صورت نیاز آیتم ناوبری را در **main_layout** اضافه کنید.
6. در صورت استفاده از Injectable، سرویس جدید را در **core/di** ثبت و `dart run build_runner build --delete-conflicting-outputs` را اجرا کنید.

### اضافه کردن سرویس core جدید

1. handler/service را در **core/handler/service/** بسازید (مثلاً `my_service_handler.dart`).
2. ماژول بسازید (یا به ماژول موجود اضافه کنید) و در **core/di** ثبت کنید.
3. با `@injectable` / `@lazySingleton` علامت بزنید و build_runner را اجرا کنید.
4. در notifier/cubit از `getIt<MyService>()` استفاده کنید.

### اضافه کردن extension

- فایل زیر **core/common/extension/** اضافه کنید (مثلاً `my_extension.dart`). در هر feature یا core قابل استفاده است.

## ابزارها و کتابخانه‌ها

| کاربرد | پکیج | استفاده |
|--------|------|---------|
| مدیریت state | flutter_riverpod | Provider و StateNotifier در لایه manager |
| مسیریابی | go_router | مسیرهای declarative، ShellRoute برای layoutها |
| DI | get_it + injectable | ثبت در core/di، init تولیدشده |
| HTTP | dio + retrofit | کلاینت API در core/di/remote، اینترسپتورها |
| احراز هویت (نمونه) | supabase_flutter | در auth handler؛ قابل تعویض |
| چندزبانگی | flutter_intl | ARB در l10n/، کلاس S تولیدشده |
| Lint | flutter_lints | analysis_options.yaml |

معماری به یک فریمورک خاص (مثل GetX) وابسته نیست. می‌توانید مدیریت state (مثلاً به Bloc) یا auth (مثلاً به Firebase) را عوض کنید و فقط لایه‌های manager و handler را جایگزین کنید؛ همان ساختار پوشه و قوانین لایه‌بندی حفظ می‌شود.

## منابع و رفرنس

- [مستندات Flutter](https://docs.flutter.dev/)
- [نمونه‌های معماری Flutter](https://github.com/brianegan/flutter_architecture_samples)
- [go_router](https://pub.dev/packages/go_router)
- [Riverpod](https://riverpod.dev/)
- [get_it](https://pub.dev/packages/get_it) · [injectable](https://pub.dev/packages/injectable)
- [Dio](https://pub.dev/packages/dio) · [Retrofit](https://pub.dev/packages/retrofit)
- [Supabase Flutter](https://supabase.com/docs/reference/dart/introduction)
- [flutter_intl](https://plugins.jetbrains.com/plugin/13666-flutter-intl)


</div>