<div dir="rtl">


# Flutter Architecture Decision

این پروژه با هدف **مقیاس‌پذیری، تست‌پذیری و نگه‌داری بلندمدت** طراحی شده و از اصول **Clean Architecture** پیروی می‌کند.

---

## 🎯 هدف این تصمیم

* جلوگیری از coupling بین UI و Business Logic
* امکان توسعه‌ی featureهای پیچیده بدون refactor گسترده
* فراهم‌کردن ساختاری قابل فهم برای تیم‌های چندنفره
* کاهش technical debt در بلندمدت

---

## 🧱 معماری انتخاب‌شده (خلاصه)

* **Dependency Injection:** `get_it` + `injectable`
* **State Management:**

    * `Riverpod` → App-level / Shared State
    * `Cubit` → UI State
    * `Bloc` → Business Flows (multi-step processes)
* **Navigation:** `go_router`
* **Networking:** `dio` + `retrofit`

---

## 🧠 چرا Clean Architecture؟

Clean Architecture تضمین می‌کند که:

* Domain مستقل از Flutter و frameworkها باقی بماند
* تغییر در UI یا state management باعث شکستن business logic نشود
* تست unit برای domain بدون وابستگی به Flutter امکان‌پذیر باشد

قانون اصلی:

> **Inner layers must not depend on outer layers**

---

## 🔧 Dependency Injection (get_it + injectable)

### چرا؟

* ساخت dependency graph شفاف و قابل تست
* حذف tight coupling بین لایه‌ها
* مدیریت lifecycle آبجکت‌ها (singleton / lazy / scoped)

```dart
@injectable
class LoginUseCase {
  LoginUseCase(this.repository);
}
```

✔️ Domain و Application کاملاً **pure Dart** باقی می‌مانند

---

## 🌊 State Management

### Riverpod (محدود و هدفمند)

استفاده فقط برای:

* session کاربر
* config اپلیکیشن
* feature flags
* theme / locale

```dart
final sessionProvider = StateProvider<Session?>((ref) => null);
```

> Riverpod جایگزین DI نیست و برای ساخت UseCase یا Repository استفاده نمی‌شود.

---

### Cubit (UI State)

* ساده
* readable
* مناسب stateهای صفحه‌ای

```dart
class LoginCubit extends Cubit<LoginState> {}
```

---

### Bloc (Business Flow)

مناسب برای:

* authentication flow
* onboarding
* payment
* multi-step async processes

```text
Event → State → Event → State
```

---

## ❌ چرا GetX استفاده نشده است؟

GetX به‌صورت ذاتی:

* مرز لایه‌ها را می‌شکند
* از Service Locator داخلی (`Get.find`) استفاده می‌کند
* Controllerها را به God Object تبدیل می‌کند
* Domain را به Flutter و framework وابسته می‌کند

این موارد با اصول Clean Architecture در تضاد هستند.

> GetX برای MVP یا prototype مناسب است، اما برای پروژه‌های long-lived توصیه نمی‌شود.

---

## 🚫 Anti-patternهای اجتناب‌شده

### استفاده از Riverpod به‌عنوان DI

```dart
// ❌ Anti-pattern
final useCaseProvider = Provider((ref) => LoginUseCase());
```

### Business Logic داخل Provider

```dart
// ❌ Anti-pattern
final loginProvider = FutureProvider((ref) async {
  // logic پیچیده
});
```

### استفاده از DI برای UI State

```dart
// ❌ Anti-pattern
getIt.registerSingleton<LoginState>(LoginState());
```

---

## 🏗️ نمای کلی معماری

```
Presentation
 ├─ Riverpod (Shared/App State)
 ├─ Cubit (UI State)
 └─ Bloc (Business Flow)
        │
Application
 └─ UseCases (Injected)
        │
Domain / Data
 └─ Repository / DataSource (Injected)
```

---

## ✅ جمع‌بندی

* Riverpod = State
* get_it + injectable = Dependency Injection
* Bloc/Cubit = Process & UI State

این ترکیب:

* مقیاس‌پذیر است
* test-friendly است
* و برای تیم‌های حرفه‌ای Flutter طراحی شده است

---

📌 برای جزئیات بیشتر، به سند **ADR** مراجعه کنید.


</div>