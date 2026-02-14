# RFC-002: Do Not Use Riverpod as a Dependency Injection Container

**Status:** Proposed  
**Author:** Amir Sheibani  
**Date:** 2026-02-14  
**Reviewers:** Architecture Team  
**Impact Level:** High (Architecture)

---

## 1. Summary

This RFC proposes that **Riverpod** not be used as a Dependency Injection (DI) container in the project, and that DI be implemented independently of state management.

Goals of this decision:

- Preserve Clean Architecture
- Reduce coupling to the framework
- Improve testability
- Lower future migration cost

---

## 2. Background

Riverpod is a state management library in the Flutter/Dart ecosystem, designed to build a reactive dependency graph.

In some projects, Riverpod is also used to construct and inject dependencies (instead of dedicated DI tools such as GetIt or constructor injection).

This RFC evaluates whether using Riverpod as DI is aligned with our project's architecture principles.

---

## 3. Problem Statement

Using Riverpod as a DI container leads to:

1. Strong coupling of the Domain layer to the framework
2. Violation of separation of concerns
3. More complex unit tests
4. Higher future migration cost
5. Unclear dependency lifecycle

---

## 4. Technical Analysis

### 4.1 DI vs State Management

| Concern              | DI Container                 | Riverpod               |
| -------------------- | ---------------------------- | ---------------------- |
| Purpose              | Build object graph           | Manage state           |
| Scope                | Application / Feature        | Reactive ProviderScope |
| Lifecycle            | Explicit (Singleton/Factory)  | Reactive + autoDispose |
| Framework dependency | None                         | Tied to Riverpod       |

A DI container is infrastructure. Riverpod belongs to the Presentation layer. Mixing the two blurs layer boundaries.

---

### 4.2 Clean Architecture Violation

Current project architecture:

```
Presentation → Domain → Data
```

If Domain depends on Provider to resolve dependencies:

```
Presentation ↔ Domain
```

The Dependency Rule is broken, because Domain must not depend on the framework.

---

### 4.3 Testability Impact

With standard DI:

- Mocks are registered in the Composition Root
- Unit tests run independently of the framework

With Riverpod-based DI:

- ProviderContainer is required
- Tests become framework-aware
- Domain depends on Riverpod

This reduces the ability to do pure unit testing.

---

### 4.4 Lifecycle Ambiguity

Riverpod lifecycle is driven by ref.watch, autoDispose, and rebuild cycles. This does not align with explicit DI lifecycles (Singleton, LazySingleton, Factory) and can lead to unwanted dependency recreation, lost caches, and unpredictable behaviour.

---

### 4.5 Migration Risk

If we need to migrate to another state management solution, run the project in a Dart CLI environment, or extract Domain into a separate package, code whose DI is based on Riverpod will require large refactoring.

---

## 5. Alternatives Considered

### Option A: Riverpod as DI (Rejected)

Pros: Simplicity in small projects; single provider graph.  
Cons: High coupling; test complexity; architecture leakage.

---

### Option B: Dedicated DI + Riverpod for State (Proposed)

Use a dedicated DI solution (e.g. GetIt or constructor injection). Use Riverpod only for state and UI reactive updates. This approach preserves Clean Architecture, keeps Domain framework-agnostic, and simplifies tests.

---

## 6. Decision

The architecture team recommends:

> Riverpod is used only for state management and must not be used as a DI container.

DI should be implemented in the Composition Root and dependencies passed into layers via constructor injection.

---

## 7. Implementation Plan

1. Define Composition Root in the Infrastructure layer
2. Use constructor injection in Domain
3. Restrict Riverpod to the Presentation layer
4. Remove provider-based dependency wiring from Domain

---

## 8. Consequences

**Positive:** More stable architecture; better testability; easier migration; clear separation of concerns.

**Negative:** Slightly more boilerplate; separate DI setup to maintain.

---

## 9. Scope

This RFC applies to all new features and must be followed in future refactors.

---

## 10. Appendix

Riverpod is an excellent state management library. It is not, however, a professional DI container; using it in that role increases architectural complexity.

---

**Approval Required By:**  
[ ] Lead Engineer  
[ ] Architecture Owner  
[ ] Tech Lead  

---

<div dir="rtl">

# RFC-002: عدم استفاده از Riverpod به عنوان Dependency Injection Container

**Status:** Proposed  
**Author:** Amir Sheibani  
**Date:** 2026-02-14  
**Reviewers:** Architecture Team  
**Impact Level:** High (Architecture)

---

## ۱. خلاصه

این RFC پیشنهاد می‌کند که از **Riverpod** به عنوان Dependency Injection (DI) container در پروژه استفاده نشود و DI به صورت مستقل از state management پیاده‌سازی گردد.

هدف این تصمیم:

- حفظ Clean Architecture
- کاهش Coupling به Framework
- بهبود Testability
- کاهش Migration Cost در آینده

---

## ۲. زمینه

Riverpod یک کتابخانه مدیریت State در اکوسیستم Flutter/Dart است که برای ساخت reactive dependency graph طراحی شده است.

در برخی پروژه‌ها، از Riverpod برای ساخت و تزریق وابستگی‌ها نیز استفاده می‌شود (به جای ابزارهای DI اختصاصی مانند GetIt یا constructor injection).

این RFC بررسی می‌کند که آیا استفاده از Riverpod به عنوان DI با اصول معماری پروژه ما سازگار است یا خیر.

---

## ۳. بیان مسئله

استفاده از Riverpod به عنوان DI container منجر به مشکلات زیر می‌شود:

۱. Coupling شدید Domain Layer به Framework  
۲. نقض Separation of Concerns  
۳. پیچیدگی تست‌های Unit  
۴. افزایش هزینه مهاجرت در آینده  
۵. ابهام در Lifecycle وابستگی‌ها  

---

## ۴. تحلیل فنی

### ۴.۱ تفاوت مفهومی DI و State Management

| Concern              | DI Container                 | Riverpod               |
| -------------------- | ---------------------------- | ---------------------- |
| هدف                  | ساخت Object Graph            | مدیریت State           |
| Scope                | Application / Feature        | Reactive ProviderScope |
| Lifecycle            | Explicit (Singleton/Factory)  | Reactive + autoDispose |
| Framework dependency | ندارد                        | وابسته به Riverpod     |

DI container زیرساخت است. Riverpod بخشی از لایه Presentation محسوب می‌شود. ترکیب این دو باعث آمیختگی لایه‌ها می‌شود.

---

### ۴.۲ نقض Clean Architecture

در معماری فعلی پروژه: `Presentation → Domain → Data`. اگر Domain برای دریافت وابستگی‌ها به Provider وابسته شود: `Presentation ↔ Domain`. Dependency Rule شکسته می‌شود زیرا Domain نباید به framework وابسته باشد.

---

### ۴.۳ Testability Impact

در DI استاندارد: Mock ها در Composition Root ثبت می‌شوند؛ Unit test مستقل از framework اجرا می‌شود. در Riverpod-based DI: نیاز به ProviderContainer وجود دارد؛ تست‌ها framework-aware می‌شوند؛ Domain به Riverpod وابسته می‌شود. این موضوع باعث کاهش Pure Unit Testing می‌شود.

---

### ۴.۴ Lifecycle Ambiguity

Riverpod lifecycle وابسته به ref.watch، autoDispose و rebuild cycle است. این رفتار با lifecycle صریح DI (Singleton, LazySingleton, Factory) هم‌راستا نیست و می‌تواند منجر به recreation ناخواسته dependency، از دست رفتن cache و رفتار غیرقابل پیش‌بینی شود.

---

### ۴.۵ Migration Risk

در صورت نیاز به مهاجرت به state management دیگر، اجرای پروژه در محیط Dart CLI، یا استخراج Domain به پکیج مستقل، کدی که DI آن مبتنی بر Riverpod است نیازمند refactor گسترده خواهد بود.

---

## ۵. گزینه‌های بررسی‌شده

### Option A: Riverpod as DI (Rejected)

مزایا: سادگی در پروژه‌های کوچک؛ یکپارچگی در Provider graph.  
معایب: Coupling بالا؛ Test complexity؛ Architecture leakage.

---

### Option B: Dedicated DI + Riverpod for State (Proposed)

DI مستقل (مثلاً GetIt یا constructor injection). Riverpod صرفاً برای State و UI reactive updates. این رویکرد Clean Architecture را حفظ می‌کند، Domain را framework-agnostic نگه می‌دارد و تست‌ها را ساده‌تر می‌کند.

---

## ۶. تصمیم

تیم معماری توصیه می‌کند:

> Riverpod فقط برای State Management استفاده شود و به عنوان DI container مورد استفاده قرار نگیرد.

DI باید در Composition Root پیاده‌سازی شود و از طریق constructor injection به لایه‌ها منتقل گردد.

---

## ۷. برنامه پیاده‌سازی

۱. تعریف Composition Root در لایه Infrastructure  
۲. استفاده از constructor injection در Domain  
۳. محدود کردن Riverpod به Presentation layer  
۴. حذف Provider-based dependency wiring از Domain  

---

## ۸. پیامدها

مثبت: Architecture پایدارتر؛ تست‌پذیری بهتر؛ Migration ساده‌تر؛ جداسازی واضح مسئولیت‌ها.  
منفی: مقدار کمی Boilerplate بیشتر؛ نیاز به مدیریت DI جداگانه.

---

## ۹. دامنه

این RFC برای تمامی Featureهای جدید الزامی است و در Refactorهای آینده نیز باید رعایت شود.

---

## ۱۰. پیوست

Riverpod یک state management عالی است. اما DI container حرفه‌ای محسوب نمی‌شود و استفاده از آن در این نقش باعث افزایش پیچیدگی معماری خواهد شد.

---

**Approval Required By:**  
[ ] Lead Engineer  
[ ] Architecture Owner  
[ ] Tech Lead  

</div>
