<div dir="rtl">

# RFC-002: عدم استفاده از Riverpod به عنوان Dependency Injection Container

**Status:** Proposed
**Author:** [Your Name]
**Date:** 2026-02-14
**Reviewers:** Architecture Team
**Impact Level:** High (Architecture)

---

## 1. Summary

این RFC پیشنهاد می‌کند که از **Riverpod** به عنوان Dependency Injection (DI) container در پروژه استفاده نشود و DI به صورت مستقل از state management پیاده‌سازی گردد.

هدف این تصمیم:

* حفظ Clean Architecture
* کاهش Coupling به Framework
* بهبود Testability
* کاهش Migration Cost در آینده

---

## 2. Background

Riverpod یک کتابخانه مدیریت State در اکوسیستم Flutter/Dart است که برای ساخت reactive dependency graph طراحی شده است.

در برخی پروژه‌ها، از Riverpod برای ساخت و تزریق وابستگی‌ها نیز استفاده می‌شود (به جای ابزارهای DI اختصاصی مانند GetIt یا constructor injection).

این RFC بررسی می‌کند که آیا استفاده از Riverpod به عنوان DI با اصول معماری پروژه ما سازگار است یا خیر.

---

## 3. Problem Statement

استفاده از Riverpod به عنوان DI container منجر به مشکلات زیر می‌شود:

1. Coupling شدید Domain Layer به Framework
2. نقض Separation of Concerns
3. پیچیدگی تست‌های Unit
4. افزایش هزینه مهاجرت در آینده
5. ابهام در Lifecycle وابستگی‌ها

---

## 4. Technical Analysis

### 4.1 تفاوت مفهومی DI و State Management

| Concern              | DI Container                 | Riverpod               |
| -------------------- | ---------------------------- | ---------------------- |
| هدف                  | ساخت Object Graph            | مدیریت State           |
| Scope                | Application / Feature         | Reactive ProviderScope |
| Lifecycle            | Explicit (Singleton/Factory)  | Reactive + autoDispose |
| Framework dependency | ندارد                        | وابسته به Riverpod     |

DI container زیرساخت است.
Riverpod بخشی از لایه Presentation محسوب می‌شود.

ترکیب این دو باعث آمیختگی لایه‌ها می‌شود.

---

### 4.2 نقض Clean Architecture

در معماری فعلی پروژه:

```
Presentation → Domain → Data
```

اگر Domain برای دریافت وابستگی‌ها به Provider وابسته شود:

```
Presentation ↔ Domain
```

Dependency Rule شکسته می‌شود زیرا Domain نباید به framework وابسته باشد.

---

### 4.3 Testability Impact

در DI استاندارد:

* Mock ها در Composition Root ثبت می‌شوند
* Unit test مستقل از framework اجرا می‌شود

در Riverpod-based DI:

* نیاز به ProviderContainer وجود دارد
* تست‌ها framework-aware می‌شوند
* Domain به Riverpod وابسته می‌شود

این موضوع باعث کاهش Pure Unit Testing می‌شود.

---

### 4.4 Lifecycle Ambiguity

Riverpod lifecycle وابسته به:

* ref.watch
* autoDispose
* rebuild cycle

است.

این رفتار با lifecycle صریح DI (Singleton, LazySingleton, Factory) هم‌راستا نیست و می‌تواند منجر به:

* recreation ناخواسته dependency
* از دست رفتن cache
* رفتار غیرقابل پیش‌بینی

شود.

---

### 4.5 Migration Risk

در صورت نیاز به:

* مهاجرت به state management دیگر
* اجرای پروژه در محیط Dart CLI
* استخراج Domain به پکیج مستقل

کدی که DI آن مبتنی بر Riverpod است نیازمند refactor گسترده خواهد بود.

---

## 5. Alternatives Considered

### Option A: Riverpod as DI (Rejected)

مزایا:

* سادگی در پروژه‌های کوچک
* یکپارچگی در Provider graph

معایب:

* Coupling بالا
* Test complexity
* Architecture leakage

---

### Option B: Dedicated DI + Riverpod for State (Proposed)

DI مستقل (مثلاً GetIt یا constructor injection)

Riverpod صرفاً برای:

* State
* UI reactive updates

این رویکرد:

* Clean Architecture را حفظ می‌کند
* Domain را framework-agnostic نگه می‌دارد
* تست‌ها را ساده‌تر می‌کند

---

## 6. Decision

تیم معماری توصیه می‌کند:

> Riverpod فقط برای State Management استفاده شود و به عنوان DI container مورد استفاده قرار نگیرد.

DI باید در Composition Root پیاده‌سازی شود و از طریق constructor injection به لایه‌ها منتقل گردد.

---

## 7. Implementation Plan

1. تعریف Composition Root در لایه Infrastructure
2. استفاده از constructor injection در Domain
3. محدود کردن Riverpod به Presentation layer
4. حذف Provider-based dependency wiring از Domain

---

## 8. Consequences

### Positive

* Architecture پایدارتر
* تست‌پذیری بهتر
* Migration ساده‌تر
* جداسازی واضح مسئولیت‌ها

### Negative

* مقدار کمی Boilerplate بیشتر
* نیاز به مدیریت DI جداگانه

---

## 9. Scope

این RFC برای تمامی Featureهای جدید الزامی است و در Refactorهای آینده نیز باید رعایت شود.

---

## 10. Appendix

Riverpod یک state management عالی است.
اما DI container حرفه‌ای محسوب نمی‌شود و استفاده از آن در این نقش باعث افزایش پیچیدگی معماری خواهد شد.

---

**Approval Required By:**
[ ] Lead Engineer
[ ] Architecture Owner
[ ] Tech Lead


</div>