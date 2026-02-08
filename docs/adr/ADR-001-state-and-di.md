<div dir="rtl">

# ADR-001: انتخاب State Management و Dependency Injection

## Status
Accepted

## Date
2026-02-08

---

## Context

این پروژه Flutter یک محصول **long-lived** با تیم چندنفره است که نیازمند:

- مقیاس‌پذیری (Scalability)
- تست‌پذیری بالا (Testability)
- جداسازی واضح مسئولیت‌ها (Separation of Concerns)
- پشتیبانی از featureهای پیچیده و multi-step flows

چالش‌های اصلی:
1. مدیریت state در UI و سطح اپلیکیشن
2. مدیریت lifecycle و dependency graph
3. جلوگیری از coupling بین Presentation و Domain
4. جلوگیری از technical debt در بلندمدت

گزینه‌های بررسی‌شده:
- استفاده‌ی کامل از Riverpod
- استفاده‌ی کامل از GetX
- استفاده از BLoC/Cubit همراه DI
- معماری Hybrid

---

## Decision

تصمیم گرفته شد:

- **get_it + injectable** به‌عنوان تنها راهکار **Dependency Injection**
- **Riverpod** فقط برای **App-level / Shared State**
- **Cubit** برای **UI State**
- **Bloc** برای **Business Flow و processهای چندمرحله‌ای**
- **GetX استفاده نمی‌شود**

Riverpod **جایگزین DI نیست** و برای ساخت UseCase یا Repository استفاده نخواهد شد.

---

## Rationale (دلایل فنی)

### 1. انطباق با Clean Architecture
- Domain و Application باید **pure Dart** باشند
- inner layers نباید به framework وابسته شوند
- DI باید خارج از Presentation انجام شود

### 2. تفکیک مسئولیت واقعی
- Riverpod → reactive state
- Bloc/Cubit → state و flow
- get_it → object graph

### 3. جلوگیری از God Object
- GetX controllerها معمولاً UI + logic + data را ترکیب می‌کنند
- این الگو با SRP و Clean Architecture در تضاد است

### 4. تست‌پذیری
- Domain با get_it بدون Flutter تست می‌شود
- Bloc با event/state تست می‌شود
- Riverpod با override تست می‌شود

---

## Consequences

### مثبت
- معماری مقیاس‌پذیر
- کاهش coupling
- refactor-friendly
- مناسب تیم‌های چندنفره

### منفی
- نیاز به آشنایی تیم با چند ابزار
- نیاز به guideline داخلی

---

## Architecture Overview

</div>

<div dir="ltr">

```
Presentation
 ├─ Riverpod (Shared / App State)
 ├─ Cubit (UI State)
 └─ Bloc (Business Flow)
        │
Application
 └─ UseCases (Injected via get_it)
        │
Domain / Data
 └─ Repository / DataSource (Injected)
```

---

</div>
<div dir="rtl">

## Anti-Patterns

### ❌ Anti-pattern 1: استفاده از Riverpod به‌عنوان DI

</div>
<div dir="ltr">

```dart
final loginUseCaseProvider = Provider(
  (ref) => LoginUseCase(AuthRepositoryImpl()),
);
```
</div>
<div dir="rtl">

**مشکل:**
- وابستگی Domain به Presentation
- lifecycle غیرشفاف
- نقض Clean Architecture

**راه درست:**

</div>
<div dir="ltr">

```dart
@injectable
class LoginUseCase {
  LoginUseCase(this.repository);
}
```
---

</div>
<div dir="rtl">

### ❌ Anti-pattern 2: Business Logic داخل Provider
</div>
<div dir="ltr">

```dart
final loginProvider = FutureProvider((ref) async {
  // business logic پیچیده
});
```
</div>
<div dir="rtl">

**مشکل:**
- flow غیرقابل trace
- تست سخت
- reuse پایین

**راه درست:**
- انتقال منطق به UseCase
- مدیریت flow با Bloc

---

### ❌ Anti-pattern 3: استفاده از DI برای UI State
</div>
<div dir="ltr">

```dart
getIt.registerSingleton<LoginState>(LoginState());
```
</div>
<div dir="rtl">

**مشکل:**
- state reactive نیست
- lifecycle صفحه رعایت نمی‌شود

**راه درست:**
- Cubit یا Riverpod برای UI State

---

### ❌ Anti-pattern 4: استفاده از Riverpod برای multi-step flow

</div>
<div dir="ltr">

```dart
ref.watch(step1Provider);
ref.watch(step2Provider);
ref.watch(step3Provider);
```
</div>
<div dir="rtl">

**مشکل:**
- provider dependency hell
- debug سخت
- async chain ناخوانا

**راه درست:**
- Bloc با Event / State explicit

---

## Summary

- Riverpod ≠ Dependency Injection
- DI ≠ State Management
- GetX با Clean Architecture هم‌راستا نیست
- معماری Hybrid انتخاب شده برای کاهش technical debt و افزایش عمر پروژه

</div>