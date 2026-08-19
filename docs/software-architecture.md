<div dir="rtl" align="right">

<a id="top"></a>

# درس‌نامه معماری نرم‌افزار

> یک مسیر آموزشی مرحله‌به‌مرحله برای فهم معماری نرم‌افزار، از پایه تا تصمیم‌های واقعی معماری در Backend و سیستم‌های توزیع‌شده.

این درس‌نامه بازسازی منسجم مسیری است که در گفت‌وگو درباره معماری نرم‌افزار طی شد. از تعریف پایه‌ای `Software Architecture` شروع می‌کند، به مفاهیم مرکزی مثل `Complexity`، `Coupling`، `Cohesion`، `Dependency Direction`، `SOLID` و `Dependency Injection` می‌رسد، سپس معماری‌هایی مثل `Layered`، `Hexagonal`، `Clean Architecture`، `Domain-Driven Design (DDD)`، `Modular Monolith`، الگوهای ارتباطی و سیستم‌های توزیع‌شده را توضیح می‌دهد.

در پایان دو بخش تکمیلی هم آمده است:

- انواع معماری‌های دیگری که در ادامه گفتگو مطرح شدند
- یک فصل عمیق‌تر درباره `Event-Driven Architecture`

هدف این فایل حفظ کردن اسم معماری‌ها نیست. هدف این است که وقتی با یک پروژه واقعی روبه‌رو می‌شوی، بتوانی ساختار، مرزها، وابستگی‌ها، هزینه تغییر، خطاهای توزیع‌شده و trade-offها را آگاهانه تحلیل کنی.

---

<a id="toc"></a>

## فهرست

### مسیر اصلی

1. [Software Architecture چیست؟](#chapter-01)
2. [مسئله اصلی معماری: Complexity، Coupling و Cohesion](#chapter-02)
3. [ساختار نرم‌افزار: Module، Component، Package، Layer و Dependency](#chapter-03)
4. [Dependency Direction](#chapter-04)
5. [Layered Architecture](#chapter-05)
6. [Separation of Concerns](#chapter-06)
7. [SOLID](#chapter-07)
8. [Dependency Injection](#chapter-08)
9. [Hexagonal Architecture / Ports & Adapters](#chapter-09)
10. [Clean Architecture](#chapter-10)
11. [Domain-Driven Design یا DDD](#chapter-11)
12. [Modular Monolith](#chapter-12)
13. [Communication & Integration Patterns](#chapter-13)
14. [Distributed Systems & Consistency](#chapter-14)
15. [Architecture Decision & Trade-offs](#chapter-15)
16. [انواع معماری‌های دیگر و سطح آن‌ها](#chapter-16)
17. [Event-Driven Architecture عمیق‌تر](#chapter-17)
18. [جمع‌بندی نهایی درس‌نامه](#final-summary)

### مفاهیم پرتکرار برای مراجعه سریع

- [تفاوت جهت Dependency و نوع ارتباط](#dependency-vs-communication)
- [Composition Root](#composition-root)
- [Inbound Port و Outbound Port](#inbound-outbound-ports)
- [Repository در DDD](#ddd-repository)
- [Sync و Async](#sync-async)
- [Command و Event](#command-event)
- [Outbox Pattern](#outbox-pattern)
- [Timeout، Retry و Backoff](#timeout-retry-backoff)
- [Idempotency و Idempotency Key](#idempotency-key)
- [Saga، Compensation، Choreography و Orchestration](#saga-pattern)
- [Architecture Decision Record یا ADR](#adr)
- [Event Contract و Versioning](#event-contract)
- [Event Envelope و event_id](#event-envelope)
- [CQRS و Event Sourcing](#cqrs-event-sourcing)

---

<a id="how-to-read"></a>

## چطور این درس‌نامه را بخوانی؟

این فایل هم برای مطالعه خطی مناسب است، هم برای مراجعه موردی. اگر تازه شروع کرده‌ای، فصل‌های ۱ تا ۸ را به ترتیب بخوان. این بخش‌ها پایه ذهنی لازم برای فهم `Clean Architecture`، `Hexagonal Architecture` و `DDD` را می‌سازند.

اگر قبلاً با معماری آشنا هستی، فصل‌های ۹ تا ۱۵ را عمیق‌تر بخوان. این قسمت‌ها به مرزهای سیستم، communication، consistency، failure و decision-making می‌پردازند.

برای مرور سریع، از فصل ۱۷ شروع نکن؛ `Event-Driven Architecture` روی مفاهیم قبلی مثل `Dependency Direction`، `Async Communication`، `Idempotency` و `Distributed Systems` سوار است.

### راهنمای مطالعه بر اساس هدف

| اگر دنبال این هستی | از این بخش‌ها شروع کن | خروجی ذهنی |
|---|---|---|
| فهم پایه معماری | فصل‌های ۱ تا ۴ | می‌فهمی معماری، dependency، boundary و complexity یعنی چه |
| تمیز کردن ساختار کد Backend | فصل‌های ۵ تا ۱۰ | فرق layer، clean، hexagonal، DI و interface را دقیق‌تر می‌بینی |
| مدل کردن Business Logic | فصل ۱۱ | با Entity، Value Object، Aggregate و Bounded Context آشنا می‌شوی |
| انتخاب بین Monolith و Microservice | فصل‌های ۱۲ و ۱۵ | می‌فهمی چه زمانی جداسازی سرویس ارزش هزینه‌اش را دارد |
| طراحی ارتباط بین سرویس‌ها | فصل‌های ۱۳ و ۱۴ | Sync، Async، broker، retry، consistency و failure را کنار هم می‌بینی |
| فهم عمیق Event-Driven | فصل ۱۷ | Event، contract، idempotency، ordering، DLQ، CQRS و Event Sourcing را یک‌جا می‌خوانی |

### قراردادهای نوشتاری این فایل

- اصطلاحات انگلیسی مهم با `inline code` آمده‌اند تا در متن فارسی سریع دیده شوند
- دیاگرام‌ها با `ASCII` نوشته شده‌اند تا در هر ویرایشگر Markdown درست نمایش داده شوند
- مثال‌ها بیشتر با ذهنیت Backend و Go نوشته شده‌اند، اما مفهوم‌ها به زبان خاصی محدود نیستند
- هر فصل اول مفهوم را توضیح می‌دهد، بعد سراغ مثال، دام رایج و جمع‌بندی می‌رود

---

<a id="learning-map"></a>

## نقشه یادگیری

```text
01. Software Architecture چیست؟
02. Complexity، Coupling و Cohesion
03. ساختار نرم‌افزار: Module، Component، Package، Layer، Dependency
04. Dependency Direction
05. Layered Architecture
06. Separation of Concerns
07. SOLID
08. Dependency Injection
09. Hexagonal Architecture / Ports & Adapters
10. Clean Architecture
11. Domain-Driven Design
12. Modular Monolith
13. Communication & Integration Patterns
14. Distributed Systems & Consistency
15. Architecture Decision & Trade-offs
16. انواع معماری‌های دیگر و سطح آن‌ها
17. Event-Driven Architecture عمیق‌تر
```

مدل ذهنی کل مسیر:

```text
Business Problem
       ↓
Domain Understanding
       ↓
Boundaries
       ↓
Modules / Components / Layers
       ↓
Dependency Direction
       ↓
Architecture Style
       ↓
Communication Patterns
       ↓
Distributed Failure & Consistency
       ↓
Architecture Decisions & Trade-offs
```

---

<a id="chapter-01"></a>

# فصل ۱: `Software Architecture` چیست؟

## تعریف ساده معماری نرم‌افزار

`Software Architecture` یعنی تصمیم‌های ساختاری مهمی که مشخص می‌کنند سیستم:

- از چه بخش‌هایی تشکیل شده است.
- هر بخش چه مسئولیتی دارد.
- بخش‌ها چگونه با هم ارتباط دارند.
- وابستگی‌ها بین بخش‌ها به چه سمتی حرکت می‌کنند.
- چه تصمیم‌هایی روی تغییرپذیری، نگهداری، مقیاس‌پذیری و پیچیدگی سیستم اثر جدی دارند.

مثلاً برای یک سیستم سفارش آنلاین، ساده‌ترین ساختار ممکن می‌تواند این باشد:

```text
User
 ↓
HTTP Handler
 ↓
Order Service
 ↓
Database
```

همین هم یک معماری است. معماری الزاماً چیز پیچیده‌ای نیست. هر سیستمی، حتی ساده‌ترین سیستم، یک معماری دارد؛ فقط ممکن است آن معماری آگاهانه طراحی نشده باشد.

## معماری فقط فولدر نیست

یک سوءتفاهم رایج این است که فکر کنیم معماری یعنی ساختن فولدرهایی مثل:

```text
handler/
service/
repository/
model/
```

اما این فقط یک شکل از سازمان‌دهی کد است. معماری واقعی پشت این سؤال‌هاست:

```text
چرا این بخش‌ها جدا شده‌اند؟
کدام بخش حق دارد کدام بخش را بشناسد؟
اگر دیتابیس تغییر کند، چه چیزی تغییر می‌کند؟
اگر API از REST به gRPC تبدیل شود، Business Logic هم تغییر می‌کند؟
```

اگر فولدرها تمیز باشند ولی وابستگی‌ها اشتباه باشند، معماری تمیز نداریم؛ فقط اسم فولدرها تمیز است.

## معماری چه چیزهایی را مشخص می‌کند؟

چهار سؤال پایه‌ای معماری:

### ۱. سیستم از چه بخش‌هایی تشکیل شده؟

مثلاً:

```text
User
Order
Payment
Inventory
Notification
Shipping
```

این‌ها می‌توانند `Module` یا `Component`های اصلی سیستم باشند.

### ۲. هر بخش چه مسئولیتی دارد؟

مثلاً:

```text
Order        → مدیریت سفارش
Payment      → مدیریت پرداخت
Inventory    → مدیریت موجودی
Notification → ارسال پیام و اعلان
Shipping     → مدیریت ارسال کالا
```

اگر مسئولیت‌ها واضح نباشند، بخش‌ها کم‌کم کارهای همدیگر را انجام می‌دهند و سیستم به‌سختی قابل تغییر می‌شود.

### ۳. بخش‌ها چگونه با هم ارتباط دارند؟

یعنی مکانیسم ارتباط چیست؟

```text
Order → HTTP → Payment
Order → gRPC → Payment
Order → NATS → Payment
Order → Function Call → Payment
Order → Event → Broker → Notification
```

این سؤال درباره نوع ارتباط است: `HTTP`، `gRPC`، `Message Broker`، `Function Call`، `Event` و غیره.

### ۴. وابستگی‌ها در چه جهتی هستند؟

این سؤال متفاوت است. اینجا می‌پرسیم:

```text
کدام بخش برای کار کردن باید کدام بخش را بشناسد؟
کدام کد به کدام کد وابسته است؟
```

مثلاً:

```text
Handler
   ↓
Service
   ↓
Repository
   ↓
Database
```

در این مدل، `Service` به `Repository` وابسته است و `Repository` به `Database`.

اما در معماری‌هایی مثل `Hexagonal` یا `Clean Architecture` تلاش می‌کنیم وابستگی Business Logic را به جزئیات فنی کم کنیم.

## تفاوت Architecture و Design

مرز بین `Architecture` و `Design` کاملاً ریاضی و قطعی نیست، اما به شکل ساده:

```text
Architecture
    ↓
تصمیم‌های کلان ساختاری

Design
    ↓
جزئیات طراحی داخل بخش‌ها
```

مثلاً این تصمیم بیشتر معماری است:

```text
Order Service از PostgreSQL مستقیم استفاده کند
یا از Repository Interface؟
```

اما این بیشتر طراحی داخلی است:

```go
type Order struct {
    ID     string
    UserID string
    Status string
}
```

البته گاهی یک تصمیم طراحی آن‌قدر مهم می‌شود که اثر معماری پیدا می‌کند. مثلاً انتخاب اینکه همه منطق کسب‌وکار داخل `HTTP Handler` باشد، فقط یک جزئیات کوچک نیست؛ روی کل ساختار سیستم اثر می‌گذارد.

## چرا معماری لازم داریم؟

چون نرم‌افزار تغییر می‌کند.

امروز ممکن است سیستم فقط این باشد:

```text
Application
    ↓
PostgreSQL
```

فردا ممکن است نیازها این‌ها باشند:

```text
Redis اضافه شود.
Payment جدا شود.
Notification با NATS کار کند.
چند instance از سرویس اجرا شود.
Database جدا یا shard شود.
API از REST به gRPC تغییر کند.
```

اگر همه چیز به همه چیز وصل باشد:

```text
A ─── B
│ ╲ ╱ │
│  X  │
│ ╱ ╲ │
C ─── D
```

یک تغییر کوچک می‌تواند اثرهای غیرقابل پیش‌بینی داشته باشد.

هدف اصلی معماری:

```text
کنترل پیچیدگی و کاهش هزینه تغییر سیستم
```

## معماری خوب الزاماً پیچیده نیست

برای یک پروژه کوچک، شاید این معماری کافی باشد:

```text
Go Application
      │
      ├── HTTP
      ├── Business Logic
      └── PostgreSQL
```

اضافه کردن ده‌ها لایه و Interface وقتی هنوز نیازی وجود ندارد، معماری را بهتر نمی‌کند. گاهی فقط مسیر فهم کد را طولانی‌تر می‌کند.

اصل مهم:

```text
Architecture should answer a real problem.
```

مثلاً:

```text
نیاز:
Payment Provider ممکن است تغییر کند.

تصمیم:
Payment پشت یک abstraction قرار بگیرد.
```

یا:

```text
نیاز:
Notification باید مستقل scale شود.

تصمیم:
Notification از Module داخلی به Service جدا تبدیل شود.
```

معماری خوب از نیاز و محدودیت شروع می‌شود، نه از اسم الگو.

---

<a id="chapter-02"></a>

# فصل ۲: مسئله اصلی معماری؛ `Complexity`، `Coupling` و `Cohesion`

## `Complexity` چیست؟

`Complexity` یعنی سخت شدن فهم، تغییر و پیش‌بینی رفتار سیستم.

اول پروژه ممکن است ساده باشد:

```text
User → App → Database
```

اما با اضافه شدن قابلیت‌ها:

```text
User
 ├── Order
 ├── Payment
 ├── Notification
 ├── Inventory
 ├── Shipping
 └── Discount
```

و ارتباط بین آن‌ها:

```text
Order ───── Payment
  │  ╲        │
  │   ╲       │
  ↓    ↓      ↓
Inventory   Notification
  │
  ↓
Shipping
```

دیگر با دیدن یک فایل نمی‌توانی بفهمی تغییرش چه چیزهایی را تحت تأثیر قرار می‌دهد.

پیچیدگی فقط از تعداد خطوط کد نمی‌آید. ممکن است یک پروژه `10000` خطی مرتب و قابل فهم باشد، و یک پروژه `1000` خطی آن‌قدر درهم باشد که هر تغییر کوچک خطرناک شود.

## `Coupling` چیست؟

`Coupling` یعنی میزان وابستگی بین بخش‌های سیستم.

مثلاً:

```go
func CreateOrder(db *sql.DB) error {
    // ...
}
```

این تابع مستقیماً به `database/sql` و در عمل به مدل ذخیره‌سازی وابسته است.

اگر آن را این‌طور طراحی کنیم:

```go
type OrderRepository interface {
    Save(order Order) error
}

func CreateOrder(repo OrderRepository) error {
    // ...
}
```

وابستگی مستقیم به جزئیات فنی کمتر می‌شود.

مدل ذهنی:

```text
High Coupling
    ↓
تغییر یک بخش، بخش‌های دیگر را هم مجبور به تغییر می‌کند

Low Coupling
    ↓
تغییر یک بخش، اثر محدودتری دارد
```

## چرا Coupling زیاد مشکل‌ساز است؟

فرض کن:

```text
Order
 ↓
Payment
 ↓
Notification
 ↓
Email Provider
```

اگر تغییر `Email Provider` باعث شود مجبور شوی `Order`، `Payment` و `Notification` را هم تغییر بدهی، Coupling زیاد است.

اما اگر داشته باشی:

```text
Notification
      ↓
EmailSender Interface
      ↑
      │
SendGrid Adapter
```

تغییر Provider بیشتر در Adapter محدود می‌شود.

## `Cohesion` چیست؟

`Cohesion` یعنی چیزهایی که داخل یک بخش قرار گرفته‌اند چقدر واقعاً به هم مربوط‌اند.

مثلاً:

```text
OrderService
 ├── CreateOrder
 ├── CancelOrder
 ├── CalculateOrderTotal
 └── GetOrder
```

این‌ها حول مفهوم `Order` هستند؛ پس Cohesion نسبتاً بالاست.

اما:

```text
CommonService
 ├── CreateOrder
 ├── SendEmail
 ├── HashPassword
 ├── CalculateTax
 ├── ResizeImage
 └── ChargePayment
```

اینجا مسئولیت‌های نامرتبط کنار هم جمع شده‌اند. Cohesion پایین است.

## رابطه Coupling و Cohesion

معمولاً می‌خواهیم:

```text
High Cohesion
      +
Low Coupling
      ↓
تغییرپذیری بهتر
نگهداری راحت‌تر
فهم ساده‌تر
```

یعنی داخل هر بخش، چیزهای مرتبط کنار هم باشند، ولی بین بخش‌ها وابستگی‌های غیرضروری کم شود.

## Coupling همیشه بد نیست

هیچ سیستم واقعی بدون Coupling نیست.

مثلاً:

```text
Order → Payment
```

کاملاً طبیعی است که `Order` somehow با `Payment` ارتباط داشته باشد. هدف این نیست که Coupling را صفر کنیم؛ هدف این است که Coupling را آگاهانه و در جای درست قرار بدهیم.

وابستگی مناسب:

```text
Order → Payment Capability
```

وابستگی مشکوک:

```text
Order → Stripe SDK
Order → SMTP Client
Order → SQL Query
```

## اصل طلایی فصل ۲

```text
Complexity
    ↓
از کنترل خارج شدن فهم و تغییر سیستم

Coupling
    ↓
وابستگی بین بخش‌ها

Cohesion
    ↓
ارتباط مفهومی چیزهای داخل یک بخش
```

معماری خوب تلاش می‌کند پیچیدگی را با مرزهای روشن، وابستگی‌های کنترل‌شده و مسئولیت‌های منسجم مدیریت کند.

---

<a id="chapter-03"></a>

# فصل ۳: ساختار نرم‌افزار؛ `Module`، `Component`، `Package`، `Layer` و `Dependency`

## چرا این فصل مهم است؟

وقتی می‌گوییم «ساختار نرم‌افزار»، باید بدانیم درباره چه سطحی حرف می‌زنیم. خیلی وقت‌ها این کلمات با هم قاطی می‌شوند:

```text
Module
Component
Package
Layer
Dependency
Boundary
```

هرکدام معنای خودش را دارد.

## `Module` چیست؟

`Module` یعنی بخشی نسبتاً مستقل از سیستم که یک قابلیت یا حوزه مشخص را پوشش می‌دهد.

مثلاً در فروشگاه:

```text
System
├── User
├── Order
├── Payment
├── Inventory
└── Notification
```

هرکدام می‌توانند یک `Module` باشند.

نکته مهم:

```text
Module الزاماً فولدر نیست.
Module یک مفهوم معماری است.
```

ممکن است در Go تبدیل شود به:

```text
internal/order/
```

اما خود Module مساوی Folder نیست.

## `Package` چیست؟

`Package` بیشتر مفهوم زبانی و کدی است.

در Go:

```text
internal/order
```

می‌تواند یک Package باشد:

```go
package order
```

پس:

```text
Module
    ↓
مفهوم معماری / قابلیت کسب‌وکاری

Package
    ↓
واحد سازمان‌دهی کد در زبان
```

یک Module ممکن است از چند Package تشکیل شود:

```text
ordering/
├── domain/
├── application/
├── ports/
└── adapters/
```

## `Component` چیست؟

`Component` یک واحد معماری با مسئولیت مشخص است که معمولاً از طریق قرارداد یا Interface با بقیه ارتباط دارد.

مثلاً:

```text
┌─────────────┐
│ Order       │
│ Component   │
└─────────────┘
       ↓
┌─────────────┐
│ Payment     │
│ Component   │
└─────────────┘
```

`Component` می‌تواند در سطح‌های مختلف باشد:

```text
یک Package
یک Module
یک Service
یک Microservice
یک Worker
```

پس Component اصطلاحی وابسته به Context است.

## `Layer` چیست؟

`Layer` سیستم را بر اساس نوع مسئولیت تقسیم می‌کند.

مثلاً:

```text
┌──────────────────────┐
│ Presentation Layer   │
├──────────────────────┤
│ Application Layer    │
├──────────────────────┤
│ Domain Layer         │
├──────────────────────┤
│ Infrastructure Layer │
└──────────────────────┘
```

در Backend:

```text
HTTP Handler
     ↓
Service
     ↓
Repository
     ↓
Database
```

تقریباً می‌توان نگاشت کرد:

```text
Handler        → Presentation
Service/UseCase→ Application
Domain Model   → Domain
DB/Redis/NATS  → Infrastructure
```

## تفاوت `Module` و `Layer`

این تفاوت بسیار مهم است.

`Module` می‌پرسد:

```text
کدام قابلیت یا حوزه؟
```

مثلاً:

```text
User
Order
Payment
Notification
```

`Layer` می‌پرسد:

```text
چه نوع مسئولیتی؟
```

مثلاً:

```text
Handler
Application
Domain
Infrastructure
```

تصویر خوب:

```text
              System
                 │
       ┌─────────┼─────────┐
       ↓         ↓         ↓
     User      Order     Payment
       │         │         │
       ├─────────┼─────────┤
       ↓         ↓         ↓
    Handler   Handler   Handler
       ↓         ↓         ↓
 Application Application Application
       ↓         ↓         ↓
    Domain    Domain    Domain
       ↓         ↓         ↓
Infrastructure Infrastructure Infrastructure
```

در این تصویر:

```text
ستون‌ها = Module
ردیف‌ها = Layer
```

## `Boundary` چیست؟

`Boundary` یعنی مرزی که مشخص می‌کند:

- چه چیزی داخل یک بخش است.
- چه چیزی بیرون آن است.
- از بیرون فقط چه API یا Contractهایی قابل استفاده‌اند.
- چه جزئیاتی نباید نشت کنند.

مثلاً `Payment Module` ممکن است داخل خودش این‌ها را داشته باشد:

```text
payment/
├── domain/
├── application/
├── adapters/
└── internal details
```

اما `Order` نباید بیاید مستقیم مدل داخلی یا جدول داخلی Payment را دستکاری کند.

بد:

```text
Order → paymentDB.Update(...)
Order → payment.InternalStatus
```

بهتر:

```text
Order → Payment Port/API → Payment Module
```

مرز یعنی هر بخش فقط از راه‌های تعریف‌شده با بخش دیگر ارتباط بگیرد.

## `Dependency` چیست؟

`Dependency` یعنی یک بخش برای انجام مسئولیتش به بخش دیگری نیاز داشته باشد.

مثلاً:

```go
type OrderService struct {
    repo OrderRepository
}
```

اینجا `OrderService` به `OrderRepository` وابسته است.

دیاگرام:

```text
OrderService
      ↓
OrderRepository
```

## Dependency فقط import نیست

در Go اگر بنویسی:

```go
import "database/sql"
```

واضح است که یک dependency داری.

اما Dependency فقط import نیست. مثلاً:

```go
func CreateOrder(payment Payment) error {
    // ...
}
```

تابع به مفهوم `Payment` وابسته است، حتی اگر Package خارجی import نکرده باشد.

پس Dependency مفهومی است:

```text
A برای انجام کارش به B نیاز دارد
```

## اصل مهم فصل ۳

```text
Module ≠ Package
Module ≠ Layer
Component ≠ Microservice
Dependency ≠ فقط import
Boundary ≠ فقط فولدر
```

این تفکیک‌ها بعداً در `Hexagonal Architecture`، `Clean Architecture`، `DDD` و `Modular Monolith` بسیار مهم می‌شوند.

---

<a id="chapter-04"></a>

# فصل ۴: `Dependency Direction`

## سؤال اصلی

تا الان گفتیم:

```text
A → B
```

یعنی A به B وابسته است.

اما سؤال معماری این است:

```text
این فلش باید به کدام سمت باشد؟
```

## مثال ساده

فرض کن:

```text
Order Service
      ↓
PostgreSQL
```

در Go:

```go
type OrderService struct {
    db *sql.DB
}
```

اینجا `OrderService` مستقیماً دیتابیس را می‌شناسد.

اما نیاز واقعی Order چیست؟

```text
Order باید ذخیره شود.
```

نه الزاماً:

```text
Order باید با PostgreSQL ذخیره شود.
```

این دو را جدا کن:

```text
Business Need
    ↓
"Order را ذخیره کن"

Technical Detail
    ↓
"با PostgreSQL ذخیره کن"
```

## وابستگی به قرارداد، نه Implementation

طراحی بهتر:

```go
type OrderRepository interface {
    Save(order Order) error
}

type OrderService struct {
    repo OrderRepository
}
```

و Implementation:

```go
type PostgresOrderRepository struct {
    db *sql.DB
}
```

دیاگرام:

```text
          Order Service
                ↓
        OrderRepository
                ↑
                │
   PostgresOrderRepository
                ↓
           PostgreSQL
```

`OrderService` دیگر نمی‌گوید «من PostgreSQL می‌خواهم». می‌گوید:

```text
من چیزی می‌خواهم که بتواند Order را ذخیره کند.
```

<a id="dependency-vs-communication"></a>

## تفاوت جهت Dependency و نوع ارتباط

این یکی از نکته‌های بسیار مهم معماری است.

سؤال اول:

```text
بخش‌ها چطور با هم ارتباط دارند؟
```

یعنی مکانیزم ارتباط چیست؟

```text
HTTP
gRPC
NATS
Function Call
Event
Queue
```

سؤال دوم:

```text
Dependency در کد به کدام سمت است؟
```

یعنی کدام بخش برای compile شدن، فهمیدن، تست شدن یا اجرا شدن به قرارداد کدام بخش نیاز دارد.

ممکن است Runtime Flow این باشد:

```text
Order → Stripe
```

اما Dependency در کد این‌طور طراحی شده باشد:

```text
Order Service
      ↓
Payment Interface
      ↑
      │
Stripe Adapter
```

پس:

```text
Runtime Flow
    ≠
Dependency Direction
```

این تفاوت پایه فهم `Dependency Inversion`، `Hexagonal Architecture` و `Clean Architecture` است.

## `Dependency Inversion`

اصل ساده:

```text
بخش‌های مهم سیستم نباید به جزئیات فنی وابسته باشند؛
جزئیات فنی باید به abstractionهای مورد نیاز بخش‌های مهم وابسته شوند.
```

بد:

```text
Order
 ↓
PostgreSQL
```

بهتر:

```text
Order
 ↓
OrderRepository Interface
 ↑
PostgreSQL Adapter
```

یعنی `PostgreSQL Adapter` خودش را با نیاز Domain/Application هماهنگ می‌کند، نه اینکه Domain خودش را با PostgreSQL تنظیم کند.

## قانون ذهنی

هر وقت dependency دیدی، بپرس:

```text
آیا این بخش واقعاً باید implementation آن بخش را بشناسد؟
```

مثلاً:

```text
Order → Stripe SDK
```

بپرس:

```text
آیا Order واقعاً باید Stripe SDK را بشناسد؟
```

معمولاً نیاز واقعی این است:

```text
Order → Payment capability
```

نه:

```text
Order → Stripe SDK
```

---

<a id="chapter-05"></a>

# فصل ۵: `Layered Architecture`

## تعریف

`Layered Architecture` یکی از رایج‌ترین سبک‌های سازمان‌دهی نرم‌افزار است. ایده آن ساده است:

```text
سیستم را به چند لایه تقسیم کن؛ هر لایه مسئولیت مشخصی دارد.
```

مدل کلاسیک:

```text
┌─────────────────────┐
│   Presentation      │
├─────────────────────┤
│   Application       │
├─────────────────────┤
│   Domain            │
├─────────────────────┤
│   Infrastructure    │
└─────────────────────┘
```

یا در Backend ساده:

```text
HTTP
 ↓
Handler
 ↓
Service
 ↓
Repository
 ↓
Database
```

## `Presentation Layer`

مسئول ارتباط با بیرون سیستم است:

```text
HTTP
gRPC
WebSocket
CLI
```

در Go:

```go
func CreateOrder(w http.ResponseWriter, r *http.Request) {
    // parse request
    // validate input shape
    // call application use case
    // write response
}
```

این لایه نباید Business Rule اصلی را نگه دارد.

مثلاً این‌ها نباید منطق اصلی Handler باشند:

```text
آیا سفارش پرداخت‌شده قابل لغو است؟
آیا موجودی کافی است؟
آیا کاربر اجازه خرید دارد؟
```

این‌ها مربوط به Domain/Application هستند.

## `Application Layer`

مسئول اجرای `Use Case`هاست:

```text
CreateOrder
CancelOrder
PayOrder
GetOrder
```

مثلاً:

```go
type CreateOrderService struct {
    orders  OrderRepository
    payment Payment
}

func (s *CreateOrderService) Execute(input CreateOrderInput) error {
    // execute use case workflow
}
```

این لایه می‌گوید وقتی یک Use Case اجرا می‌شود، چه قدم‌هایی باید طی شود.

## `Domain Layer`

قلب سیستم است. شامل قوانین کسب‌وکار و مدل‌های اصلی Domain است.

مثلاً:

```go
func (o *Order) Cancel() error {
    if o.Status == Paid {
        return ErrCannotCancelPaidOrder
    }

    o.Status = Cancelled
    return nil
}
```

این قانون:

```text
Paid Order → Cannot Cancel
```

ربطی به HTTP، PostgreSQL یا NATS ندارد. پس جای طبیعی آن Domain است.

## `Infrastructure Layer`

جزئیات فنی در این لایه هستند:

```text
PostgreSQL
Redis
NATS
Kafka
SMTP
Stripe SDK
External HTTP Client
```

مثلاً:

```go
type PostgresOrderRepository struct {
    db *sql.DB
}
```

یا:

```go
type NATSNotificationPublisher struct {
    conn *nats.Conn
}
```

## مشکل مدل ساده Layered

در مدل ساده ممکن است Dependency این‌طور باشد:

```text
Presentation
      ↓
Application
      ↓
Domain
      ↓
Infrastructure
```

اگر `Domain` به `Infrastructure` وابسته شود، Business Logic به جزئیات فنی وابسته شده است:

```text
Domain → PostgreSQL
Domain → Redis
Domain → NATS
```

این معمولاً مطلوب نیست.

مدل بهتر:

```text
Application/Domain
       ↓
   Abstraction
       ↑
Infrastructure Adapter
```

یعنی Infrastructure بیرونی‌تر است، ولی dependency آن به سمت قراردادهای داخلی حرکت می‌کند.

## اشتباه رایج در Layered Architecture

بعضی پروژه‌ها ظاهراً لایه دارند:

```text
handler
 ↓
service
 ↓
repository
 ↓
database
```

اما داخل `Service` همه چیز اتفاق می‌افتد:

```go
func CreateOrder(...) {
    validate()
    db.Insert(...)
    payment.Charge(...)
    sendEmail(...)
    updateInventory(...)
    publishEvent(...)
}
```

در این حالت `Service` تبدیل می‌شود به محلی برای همه Concernها:

```text
Service
 ├── Business Logic
 ├── Database Logic
 ├── Payment Logic
 ├── Notification Logic
 ├── Messaging Logic
 └── Infrastructure Logic
```

داشتن فولدرهای لایه‌ای کافی نیست؛ مسئولیت‌ها و dependencyها باید درست باشند.

## مزیت Layered Architecture

مهم‌ترین مزیت:

```text
Separation of Concerns
```

یعنی کدهای مربوط به HTTP، Business Rules، Use Case، Persistence و Infrastructure از هم جدا می‌شوند.

## محدودیت Layered Architecture

اگر کورکورانه اجرا شود:

- ممکن است فقط لایه‌های عبوری بسازد.
- ممکن است برای CRUD ساده پیچیدگی غیرضروری ایجاد کند.
- ممکن است Dependency Chain طولانی شود.
- ممکن است Domain به Infrastructure نشت کند.

پس Layered Architecture مفید است، اما کافی نیست. باید همراه با فهم `Dependency Direction` و `Separation of Concerns` استفاده شود.

---

<a id="chapter-06"></a>

# فصل ۶: `Separation of Concerns`

## تعریف

`Separation of Concerns` یعنی:

```text
دغدغه‌های متفاوت سیستم را بی‌دلیل با هم قاطی نکن.
```

یک `Concern` یعنی یک مسئله یا دغدغه مشخص:

```text
HTTP Handling
Business Rules
Persistence
Authentication
Payment
Messaging
Logging
Caching
```

## مثال بد

```go
func CreateOrder(w http.ResponseWriter, r *http.Request) {
    // parse HTTP request
    // validate user
    // check inventory
    // calculate price
    // insert into PostgreSQL
    // charge payment
    // publish NATS message
    // send HTTP response
}
```

این تابع چند دغدغه را با هم قاطی کرده:

```text
CreateOrder
├── HTTP
├── Validation
├── Business Logic
├── Database
├── Payment
├── Messaging
└── Response
```

مشکل فقط طولانی بودن تابع نیست. مشکل این است که تغییر هر Concern می‌تواند همین تابع را درگیر کند.

## چرا جداسازی مهم است؟

اگر HTTP framework تغییر کند:

```text
Gin → net/http
```

نباید Business Rule تغییر کند.

اگر دیتابیس تغییر کند:

```text
PostgreSQL → MySQL
```

نباید قانون «سفارش پرداخت‌شده قابل لغو نیست» تغییر کند.

اگر Broker تغییر کند:

```text
NATS → Kafka
```

نباید Domain Model تغییر کند.

## مثال Business Rule

قانون:

```text
Paid Order cannot be cancelled.
```

بد:

```go
func CancelOrder(w http.ResponseWriter, r *http.Request) {
    order := getOrderFromDB()

    if order.Status == "paid" {
        http.Error(w, "cannot cancel", http.StatusBadRequest)
        return
    }

    updateDatabase(order)
}
```

اینجا Business Rule داخل HTTP Handler است.

اگر فردا همین عملیات از راه‌های دیگری اجرا شود:

```text
HTTP
gRPC
NATS Consumer
CLI
```

باید همان قانون را تکرار کنیم و احتمال خطا بالا می‌رود.

بهتر:

```go
func (o *Order) Cancel() error {
    if o.Status == Paid {
        return ErrCannotCancelPaidOrder
    }

    o.Status = Cancelled
    return nil
}
```

حالا هر ورودی از همان قانون استفاده می‌کند:

```text
HTTP → Application → Order.Cancel()
gRPC → Application → Order.Cancel()
NATS → Application → Order.Cancel()
CLI  → Application → Order.Cancel()
```

## SoC با Layering یکی نیست

`Layering` یکی از روش‌های اجرای SoC است، اما خود SoC الگوی لایه‌بندی نیست.

```text
Separation of Concerns
        ↓
یک اصل طراحی/معماری

Layered Architecture
        ↓
یکی از روش‌های پیاده‌سازی آن
```

حتی بدون ساختار لایه‌ای کلاسیک هم می‌توان Concernها را جدا کرد.

مثلاً در یک Module:

```text
notification/
├── api/
├── usecase/
├── domain/
├── persistence/
└── messaging/
```

## تست ذهنی مفید

برای تشخیص Concernهای مخلوط‌شده بپرس:

```text
اگر X تغییر کند، چه چیزی باید تغییر کند؟
```

مثلاً:

```text
اگر HTTP framework عوض شود، آیا Business Logic تغییر می‌کند؟
اگر Payment Provider عوض شود، آیا Order Domain تغییر می‌کند؟
اگر NATS عوض شود، آیا Entity تغییر می‌کند؟
```

اگر جواب «بله» است، شاید Concernها به هم نشت کرده‌اند.

## اصل مهم فصل ۶

معماری خوب الزاماً کد را کمتر نمی‌کند؛ اما اثر تغییر را محدود می‌کند.

```text
Concern Separation
       ↓
Coupling کمتر
       ↓
تغییرات محدودتر
       ↓
Complexity کمتر
```

---

<a id="chapter-07"></a>

# فصل ۷: `SOLID`

## `SOLID` چیست؟

`SOLID` یک معماری نیست. مجموعه‌ای از اصول طراحی است که کمک می‌کند کد:

- مسئولیت‌های روشن‌تری داشته باشد.
- وابستگی‌های کنترل‌شده‌تری داشته باشد.
- تغییرپذیرتر باشد.
- تست‌پذیرتر باشد.

پنج اصل:

```text
S → Single Responsibility Principle
O → Open/Closed Principle
L → Liskov Substitution Principle
I → Interface Segregation Principle
D → Dependency Inversion Principle
```

## `S`؛ اصل مسئولیت واحد (`Single Responsibility Principle`)

تعریف ساده:

```text
یک بخش نرم‌افزار باید یک مسئولیت مشخص داشته باشد
و فقط به یک دلیل اصلی برای تغییر وابسته باشد.
```

مثال مشکوک:

```go
type OrderService struct {
    db      *sql.DB
    payment *StripeClient
    mail    *SMTPClient
}
```

و داخل آن:

```text
Create Order
Validate Order
Save Order
Charge Payment
Send Email
Generate Invoice
```

این بخش ممکن است به دلایل مختلف تغییر کند:

```text
Business Rule تغییر کند
Database تغییر کند
Payment Provider تغییر کند
Email Provider تغییر کند
Invoice Format تغییر کند
```

پس احتمالاً چند Concern در یک بخش جمع شده‌اند.

SRP نمی‌گوید هر Struct فقط یک متد داشته باشد. مثلاً:

```go
type Order struct {
    ID     string
    Status Status
}

func (o *Order) Cancel() error { return nil }
func (o *Order) Pay() error { return nil }
func (o *Order) Complete() error { return nil }
```

اگر همه این رفتارها مربوط به مفهوم `Order` باشند، Cohesion می‌تواند بالا باشد.

## `O`؛ اصل باز/بسته (`Open/Closed Principle`)

تعریف:

```text
کد باید برای گسترش باز باشد،
اما برای تغییر کد موجود تا حد امکان بسته باشد.
```

بد:

```go
func Pay(provider string, amount int64) error {
    if provider == "stripe" {
        // Stripe
    }

    if provider == "zarinpal" {
        // Zarinpal
    }

    return nil
}
```

هر Provider جدید یعنی تغییر همین تابع.

بهتر:

```go
type Payment interface {
    Pay(amount int64) error
}
```

و:

```text
Payment
   ↑
   ├── Stripe
   ├── Zarinpal
   └── PayPal
```

برای اضافه کردن Provider جدید، Adapter جدید اضافه می‌شود و Business Logic کمتر تغییر می‌کند.

## `L`؛ اصل جایگزینی لیسکوف (`Liskov Substitution Principle`)

تعریف ساده:

```text
اگر Implementation جای Abstraction قرار گرفت،
نباید رفتار سیستم را به شکل غیرمنتظره خراب کند.
```

مسئله اصلی درباره قرارداد رفتاری است.

مثلاً اگر Interface بگوید:

```go
type Payment interface {
    Pay(amount int64) error
}
```

هر Implementation باید واقعاً بتواند `Pay` را طبق انتظار انجام دهد. اگر یکی از Implementationها در حالت عادی panic کند یا قرارداد را نقض کند، Abstraction درست طراحی نشده یا Implementation معتبر نیست.

نکته:

```text
LSP درباره رفتار واقعی پشت Interface است،
نه فقط امضای متدها.
```

## `I`؛ اصل جداسازی Interfaceها (`Interface Segregation Principle`)

تعریف:

```text
Client نباید مجبور شود به Interfaceای وابسته باشد
که متدهای غیرلازم برای آن دارد.
```

بد:

```go
type Worker interface {
    Work()
    Eat()
    Sleep()
}
```

اگر یک Implementation فقط `Work` داشته باشد، مجبور است متدهای بی‌معنی پیاده کند.

بهتر:

```go
type Worker interface {
    Work()
}
```

در Go این اصل خیلی طبیعی است، چون Interfaceهای کوچک و مصرف‌کننده‌محور رایج‌اند:

```go
type Reader interface {
    Read(p []byte) (int, error)
}
```

## `D`؛ اصل وارونگی وابستگی (`Dependency Inversion Principle`)

این اصل برای معماری بسیار مهم است.

تعریف:

```text
High-level policy نباید به Low-level details وابسته باشد.
هر دو باید به abstraction وابسته باشند.
```

بد:

```text
Order Service
      ↓
PostgreSQL
```

بهتر:

```text
Order Service
      ↓
OrderRepository Interface
      ↑
Postgres Adapter
```

اینجا Business Logic به قرارداد وابسته است، نه به جزئیات دیتابیس.

## هشدار درباره SOLID

`SOLID` قانون مقدس نیست. اگر برای هر Struct یک Interface بسازی:

```text
UserService
UserServiceInterface
OrderService
OrderServiceInterface
PaymentService
PaymentServiceInterface
```

لزوماً معماری بهتری نداری.

Interface زمانی ارزش دارد که مرز واقعی، نیاز به تست، چند Implementation یا جداسازی مهمی وجود داشته باشد.

## جمع‌بندی SOLID

```text
S → مسئولیت‌ها را واضح نگه دار.
O → گسترش را آسان‌تر از تغییر کد موجود کن.
L → Implementation باید قرارداد Abstraction را واقعاً رعایت کند.
I → Interfaceها را کوچک و مخصوص نیاز مصرف‌کننده نگه دار.
D → Business Logic را به جزئیات فنی وابسته نکن.
```

---

<a id="chapter-08"></a>

# فصل ۸: `Dependency Injection`

## تعریف

`Dependency Injection` یک معماری نیست. یک تکنیک است.

تعریف ساده:

```text
یک Object وابستگی‌هایش را خودش نسازد،
بلکه از بیرون دریافت کند.
```

## مثال بد

```go
type OrderService struct {
    repo *PostgresOrderRepository
}

func NewOrderService() *OrderService {
    db := connectToPostgres()
    repo := NewPostgresOrderRepository(db)

    return &OrderService{
        repo: repo,
    }
}
```

اینجا `OrderService` خودش دیتابیس و Repository را می‌سازد. پس به جزئیات زیادی وابسته می‌شود.

## روش بهتر

```go
type OrderService struct {
    repo OrderRepository
}

func NewOrderService(repo OrderRepository) *OrderService {
    return &OrderService{
        repo: repo,
    }
}
```

و بیرون:

```go
repo := NewPostgresOrderRepository(db)
service := NewOrderService(repo)
```

حالا Service نمی‌داند `repo` چطور ساخته شده و دقیقاً چه دیتابیسی پشت آن است.

<a id="composition-root"></a>

## `Composition Root`

`Composition Root` جایی است که dependencyهای سیستم ساخته و به هم وصل می‌شوند.

در Go معمولاً `main.go` یا بخشی نزدیک به آن:

```go
func main() {
    db := NewDatabase()

    repo := NewPostgresOrderRepository(db)
    payment := NewStripePayment()

    service := NewOrderService(repo, payment)
    handler := NewOrderHandler(service)

    http.ListenAndServe(":8080", handler)
}
```

دیاگرام:

```text
            main.go / Composition Root
                       │
          ┌────────────┼────────────┐
          ↓            ↓            ↓
       Database     Repository    Payment
                         │
                         ↓
                    OrderService
                         ↓
                    OrderHandler
```

اصل مهم:

```text
Business Logic نباید مسئول ساخت Infrastructure باشد.
```

## `Constructor Injection`

رایج‌ترین شکل DI در Go:

```go
func NewOrderService(
    repo OrderRepository,
    payment Payment,
) *OrderService {
    return &OrderService{
        repo:    repo,
        payment: payment,
    }
}
```

مزیت‌ها:

- dependencyها واضح‌اند.
- Object ناقص ساخته نمی‌شود.
- تست ساده‌تر است.
- خواندن dependency graph راحت‌تر است.

## DI و تست

در Production:

```text
OrderRepository
      ↑
PostgresOrderRepository
```

در Test:

```text
OrderRepository
      ↑
FakeOrderRepository
```

مثلاً:

```go
fakeRepo := NewFakeOrderRepository()
service := NewOrderService(fakeRepo)
```

با این کار Business Logic بدون دیتابیس واقعی تست می‌شود.

## Interface کجا تعریف شود؟

در Go معمولاً قاعده مفید این است:

```text
Interface را نزدیک مصرف‌کننده تعریف کن،
نه الزاماً کنار Implementation.
```

مثلاً `OrderService` نیاز دارد Order را ذخیره کند:

```go
type OrderRepository interface {
    Save(order Order) error
}
```

این Interface می‌تواند در `application` یا جایی باشد که Use Case آن را مصرف می‌کند. Implementation در `infrastructure/postgres` قرار می‌گیرد.

## DI با Dependency Inversion یکی نیست

```text
Dependency Inversion
    ↓
طراحی جهت وابستگی‌ها به سمت abstraction

Dependency Injection
    ↓
روش دادن dependency از بیرون به Object
```

این دو به هم کمک می‌کنند، اما یکی نیستند.

## انواع DI

### `Constructor Injection`

```go
service := NewOrderService(repo, payment)
```

رایج‌ترین و معمولاً بهترین انتخاب در Go.

### `Method Injection`

وقتی dependency فقط برای یک عملیات لازم است:

```go
func (s *Service) Execute(ctx context.Context, sender Sender) error {
    // ...
}
```

### `Setter Injection`

```go
service.SetRepository(repo)
```

در Go معمولاً کمتر ترجیح داده می‌شود، چون ممکن است Object قبل از دریافت dependency لازم استفاده شود.

---

<a id="chapter-09"></a>

# فصل ۹: `Hexagonal Architecture` / `Ports & Adapters`

## ایده اصلی

`Hexagonal Architecture` یا `Ports & Adapters` می‌گوید:

```text
Business Logic را در مرکز قرار بده
و جزئیات بیرونی را از طریق Adapterها به آن وصل کن.
```

دیاگرام ساده:

```text
             HTTP
              │
              ↓
        ┌───────────┐
        │           │
NATS →  │   Core    │  ← gRPC
        │           │
        └───────────┘
          ↑       ↑
          │       │
     PostgreSQL  Redis
```

نکته:

```text
شش‌ضلعی بودن شکل معنای خاصی ندارد.
اصل ماجرا Core، Port و Adapter است.
```

## مشکل اصلی که Hexagonal حل می‌کند

بدون جداسازی:

```text
                 PostgreSQL
                     ↑
                     │
HTTP → Notification Service ← NATS
                     │
              ┌──────┼──────┐
              ↓      ↓      ↓
             SMS   Email  Telegram
```

Business Logic تبدیل می‌شود به مرکز اتصال همه تکنولوژی‌ها.

Hexagonal می‌گوید:

```text
Core نباید PostgreSQL، NATS، HTTP، SMTP یا Redis را بشناسد.
Core باید Business Logic را بشناسد.
```

## `Core` چیست؟

`Core` شامل منطق اصلی سیستم است:

```text
Use Cases
Domain Model
Business Rules
```

در Notification Service:

```text
Notification
Delivery
Template
Channel
SendNotification Use Case
```

## `Port` چیست؟

`Port` یک قرارداد بین Core و بیرون است.

مثلاً Core می‌گوید:

```text
من برای ذخیره Notification به چیزی نیاز دارم که Save کند.
```

پس:

```go
type NotificationRepository interface {
    Save(notification Notification) error
}
```

این یک Port است.

فرمول:

```text
Port = نیاز/قرارداد Core در مرز سیستم
```

## `Adapter` چیست؟

`Adapter` چیزی است که یک تکنولوژی واقعی را به Port وصل می‌کند.

مثلاً:

```go
type PostgresNotificationRepository struct {
    db *sql.DB
}
```

دیاگرام:

```text
              Core
               │
               ↓
      Repository Port
               ↑
               │
       PostgreSQL Adapter
               │
               ↓
          PostgreSQL
```

Core نمی‌داند PostgreSQL وجود دارد. Adapter می‌داند.

<a id="inbound-outbound-ports"></a>

## دو نوع Port

### `Inbound Port`

قراردادی که بیرون سیستم از طریق آن از Core استفاده می‌کند.

مثلاً:

```go
type CreateNotification interface {
    Execute(input CreateNotificationInput) error
}
```

HTTP Handler یا NATS Consumer می‌تواند این Port را صدا بزند.

دیاگرام:

```text
External World
      ↓
Inbound Adapter
      ↓
Inbound Port
      ↓
Core
```

### `Outbound Port`

قراردادی که Core برای استفاده از دنیای بیرون لازم دارد.

مثلاً:

```go
type EmailSender interface {
    Send(email Email) error
}
```

دیاگرام:

```text
Core
 ↓
Outbound Port
 ↑
External Adapter
 ↓
External System
```

## مثال Notification Service

```text
                   HTTP
                    │
                    ↓
              HTTP Adapter
                    │
                    ↓
             SendNotification
                    │
                    ↓
                  Core
                    │
                    ↓
          NotificationSender Port
             ↑      ↑      ↑
             │      │      │
            SMS    Email  Telegram
```

اگر فردا `NATS` هم اضافه شود:

```text
NATS
 ↓
NATS Adapter
 ↓
SendNotification Use Case
 ↓
Core
```

Core لازم نیست تغییر اساسی کند، چون NATS فقط یک Inbound Adapter جدید است.

## Dependency Direction در Hexagonal

اصل مهم:

```text
Business Logic
       ↓
    Port
       ↑
    Adapter
       ↓
External System
```

یعنی Adapter به قرارداد Core وابسته می‌شود، نه Core به Adapter.

## ساختار نمونه در Go

```text
notification/
├── cmd/
│   └── notification/
│       └── main.go
│
├── internal/
│   ├── domain/
│   │   └── notification.go
│   │
│   ├── application/
│   │   ├── ports/
│   │   │   ├── inbound.go
│   │   │   └── outbound.go
│   │   └── service.go
│   │
│   └── adapters/
│       ├── http/
│       ├── nats/
│       ├── postgres/
│       ├── sms/
│       ├── email/
│       └── telegram/
```

این فقط یک روش سازمان‌دهی است. خود Hexagonal نمی‌گوید حتماً فولدرها همین باشند.

اصل:

```text
Core کجاست؟
Portها کجایند؟
Adapterها کجایند؟
Dependency به کدام سمت است؟
```

## هر Interfaceای Port نیست

مثلاً:

```go
type StringFormatter interface {
    Format(string) string
}
```

ممکن است فقط یک abstraction داخلی باشد.

`Port` معمولاً جایی معنا دارد که مرز Core و بیرون را مشخص کند.

## دام رایج

Hexagonal یعنی ساختن Interface برای هر خط کد نیست.

اگر برای یک CRUD ساده از این مسیر عبور کنیم:

```text
Interface
Adapter
Factory
Builder
Mapper
Facade
Wrapper
Provider
```

ممکن است فقط پیچیدگی تشریفاتی ساخته باشیم.

هدف:

```text
مرزهای مهم را جدا کن،
نه اینکه بیشترین تعداد Interface ممکن بسازی.
```

---

<a id="chapter-10"></a>

# فصل ۱۰: `Clean Architecture`

## تعریف

`Clean Architecture` بیشتر با نام `Robert C. Martin` شناخته می‌شود. مدل معروف آن حلقه‌هایی دارد:

```text
┌───────────────────────────────────┐
│        Frameworks & Drivers       │
│                                   │
│   ┌───────────────────────────┐   │
│   │    Interface Adapters     │   │
│   │                           │   │
│   │   ┌───────────────────┐   │   │
│   │   │    Use Cases      │   │   │
│   │   │                   │   │   │
│   │   │  ┌─────────────┐  │   │   │
│   │   │  │  Entities   │  │   │   │
│   │   │  └─────────────┘  │   │   │
│   │   └───────────────────┘   │   │
│   └───────────────────────────┘   │
└───────────────────────────────────┘
```

اما اصل Clean Architecture دایره‌ها نیستند. اصل آن `Dependency Rule` است.

## `Dependency Rule`

قانون:

```text
Dependencyها باید به سمت داخل حرکت کنند.
```

یعنی:

```text
Frameworks/Drivers
        ↓
Interface Adapters
        ↓
Use Cases
        ↓
Entities
```

Domain/Entities نباید PostgreSQL، Redis، NATS، Gin، Kafka یا Stripe SDK را بشناسند.

## `Entities`

مرکز سیستم و محل قوانین اصلی کسب‌وکار.

مثلاً:

```go
type Order struct {
    ID     string
    Status Status
}

func (o *Order) Cancel() error {
    if o.Status == Paid {
        return ErrCannotCancel
    }

    o.Status = Cancelled
    return nil
}
```

این قانون به هیچ Framework یا دیتابیسی وابسته نیست.

## `Use Cases`

Use Caseها رفتارهای سیستم را اجرا می‌کنند:

```text
CreateOrder
CancelOrder
PayOrder
GetOrder
```

مثلاً:

```go
type CreateOrderUseCase struct {
    orders  OrderRepository
    payment Payment
}

func (u *CreateOrderUseCase) Execute(input CreateOrderInput) error {
    // workflow
    return nil
}
```

Use Case معمولاً جریان انجام یک کار را مدیریت می‌کند، اما Business Ruleهای اصلی را بهتر است در Domain نگه دارد.

## `Interface Adapters`

این بخش داده‌ها را بین دنیای بیرون و Use Caseها تبدیل می‌کند.

مثلاً:

```text
HTTP Request
     ↓
HTTP Controller
     ↓
Use Case Input
     ↓
Use Case
```

و برعکس:

```text
Use Case Output
     ↓
Presenter/Controller
     ↓
HTTP Response
```

DTOهای بیرونی نباید بی‌فکر وارد Domain شوند.

## `Frameworks & Drivers`

جزئیات بیرونی و تکنولوژیک:

```text
Gin
PostgreSQL
Redis
NATS
Kafka
Stripe SDK
SMTP
```

این‌ها بیرونی‌ترین بخش هستند، چون بیشتر از Business Ruleها تغییر می‌کنند.

## جای Interface در Clean Architecture

اگر Use Case نیاز به ذخیره Order دارد:

```go
type OrderRepository interface {
    Save(order Order) error
}
```

این Interface معمولاً نزدیک مصرف‌کننده یعنی Use Case/Application تعریف می‌شود.

بعد:

```text
Use Case
   ↓
OrderRepository Interface
   ↑
PostgresOrderRepository
```

این همان `Dependency Inversion` است.

## Clean Architecture و Hexagonal چه فرقی دارند؟

`Hexagonal` روی این تصویر تمرکز دارد:

```text
Core
 ↓
Ports
 ↑
Adapters
```

`Clean Architecture` روی این قانون تمرکز دارد:

```text
Dependencyها به سمت داخل
```

در عمل، ایده‌های مشترک زیادی دارند:

```text
Business Logic را از جزئیات بیرونی جدا کن.
Dependency را به سمت abstraction و core ببر.
Framework و Database نباید مرکز طراحی باشند.
```

می‌توان در یک پروژه از ایده‌های هر دو استفاده کرد.

## ساختار نمونه در Go

```text
internal/
├── domain/
│   └── order.go
│
├── application/
│   ├── create_order.go
│   └── ports.go
│
├── adapters/
│   ├── http/
│   └── postgres/
│
└── infrastructure/
    ├── postgres/
    └── nats/
```

اما دوباره:

```text
Clean Architecture = فولدرها نیست.
Clean Architecture = Rule + Boundary + Dependency Direction
```

## دام رایج

برای یک `GET /users/1` ساده، اگر مجبور شوی از ۱۴ فایل و ۸ Mapper عبور کنی، شاید معماری تمیز نیست؛ شاید Ceremony زیاد است.

سؤال درست:

```text
آیا مرزها و dependencyها واقعاً به کنترل تغییر کمک می‌کنند؟
```

---

<a id="chapter-11"></a>

# فصل ۱۱: `Domain-Driven Design` یا `DDD`

## DDD چه مسئله‌ای را حل می‌کند؟

تا اینجا بیشتر درباره ساختار فنی صحبت کردیم. `DDD` می‌پرسد:

```text
Business Domain را چطور مدل کنیم؟
```

یعنی قبل از فولدر و Framework، باید بفهمیم دنیای مسئله چیست.

## `Domain` چیست؟

`Domain` یعنی دنیای مسئله‌ای که نرم‌افزار برای آن ساخته شده.

مثلاً در سیستم بانکی:

```text
Account
Transaction
Transfer
Balance
Customer
Loan
```

در فروشگاه:

```text
Order
Product
Cart
Payment
Shipment
```

در Notification Service:

```text
Notification
Template
Channel
Delivery
Provider
Retry
```

## `Domain Model`

مدل خوب فقط داده نیست؛ رفتار و قانون هم دارد.

مثلاً:

```go
type Order struct {
    ID     string
    Status Status
}

func (o *Order) Cancel() error {
    if o.Status == Paid {
        return ErrCannotCancel
    }

    o.Status = Cancelled
    return nil
}
```

قانون داخل مدل Domain قرار گرفته، نه در Handler یا SQL Query.

## `Entity`

`Entity` چیزی است که هویت (`Identity`) دارد.

مثلاً:

```text
User
Order
Account
Payment
```

دو Order ممکن است مقدارهای مشابه داشته باشند، اما چون ID متفاوت دارند یکی نیستند:

```text
Order A: ID = 123
Order B: ID = 456

Order A ≠ Order B
```

پس:

```text
Entity = چیزی که هویتش مهم‌تر از مقدارهایش است.
```

## `Value Object`

`Value Object` هویت مستقل ندارد و بر اساس مقدارش معنا می‌شود.

مثلاً:

```text
Money
Email
Address
PhoneNumber
```

مثال:

```go
type Money struct {
    Amount   int64
    Currency Currency
}
```

دو مقدار:

```text
100 USD
100 USD
```

از نظر Value برابرند.

مزیت Value Object این است که قوانین مربوط به یک مفهوم در خودش نگه داشته می‌شود:

```go
func (m Money) Add(other Money) (Money, error) {
    if m.Currency != other.Currency {
        return Money{}, ErrCurrencyMismatch
    }

    return Money{
        Amount:   m.Amount + other.Amount,
        Currency: m.Currency,
    }, nil
}
```

## `Aggregate`

`Aggregate` یعنی مجموعه‌ای از Objectها که به عنوان یک واحد consistency و تغییر مدیریت می‌شوند.

مثلاً:

```text
Order
 ├── OrderItem
 ├── OrderItem
 └── OrderItem
```

`Order` می‌تواند `Aggregate Root` باشد.

بیرون نباید مستقیم `OrderItem` را بدون کنترل Order تغییر دهد.

بهتر:

```go
func (o *Order) AddItem(item OrderItem) error {
    // validate
    // update items
    // preserve invariants
    return nil
}
```

## `Invariant`

`Invariant` قانونی است که همیشه باید برقرار بماند.

مثلاً:

```text
Order total = sum(OrderItems)
```

اگر هرکسی بتواند مستقیم Item را تغییر دهد، ممکن است:

```text
Order.Total = 100
Items sum   = 120
```

Aggregate کمک می‌کند همه تغییرات مهم از یک مرز کنترل‌شده عبور کنند.

<a id="ddd-repository"></a>

## `Repository` در DDD

Repository یک abstraction برای دسترسی به Aggregateهاست.

مثلاً:

```go
type OrderRepository interface {
    FindByID(id string) (*Order, error)
    Save(order *Order) error
}
```

در DDD بهتر است Repository حول Domain طراحی شود، نه فقط یک Generic CRUD عمومی.

```text
OrderRepository
```

معمولاً گویاتر از:

```text
GenericRepository[T]
```

است، چون زبان Domain را بهتر نشان می‌دهد.

## `Bounded Context`

یکی از مهم‌ترین مفاهیم DDD.

یک کلمه ممکن است در Contextهای مختلف معنای متفاوت داشته باشد.

مثلاً `Customer`:

```text
Billing Context
    Customer = کسی که پرداخت می‌کند

Support Context
    Customer = کسی که Ticket ثبت می‌کند

Shipping Context
    Customer = گیرنده سفارش
```

لازم نیست یک مدل جهانی واحد برای همه داشته باشیم.

```text
┌─────────────────┐
│ Billing Context │
│ Customer        │
│ Invoice         │
│ Payment         │
└─────────────────┘

┌─────────────────┐
│ Support Context │
│ Customer        │
│ Ticket          │
│ Agent           │
└─────────────────┘
```

یک مدل مشترک جهانی ممکن است خودش منبع Coupling شود.

## `Ubiquitous Language`

تیم فنی و افراد Business باید تا حد ممکن از زبان مشترک استفاده کنند.

اگر Business می‌گوید:

```text
Membership Request
```

کد هم بهتر است همان مفهوم را نشان دهد:

```go
type MembershipRequest struct {
    // ...
}
```

زبان کد باید تا حد ممکن زبان Domain را بازتاب دهد.

## دو سطح DDD

### `Strategic DDD`

درباره تقسیم‌بندی بزرگ سیستم:

```text
Bounded Context
Context Map
Subdomain
Ubiquitous Language
```

### `Tactical DDD`

درباره مدل‌سازی داخل یک Context:

```text
Entity
Value Object
Aggregate
Repository
Domain Service
Domain Event
```

## DDD یعنی Microservice؟

نه.

می‌توان DDD را در Monolith هم اجرا کرد:

```text
internal/
├── billing/
├── ordering/
├── shipping/
└── notification/
```

DDD درباره مدل‌سازی Domain و مرزبندی آن است، نه الزاماً چند سرویس جدا.

## ارتباط DDD با Clean و Hexagonal

```text
DDD
 ↓
Domain Model و Business Boundaries

Hexagonal/Clean
 ↓
جدا کردن Core از Infrastructure و کنترل Dependency Direction
```

این‌ها رقیب نیستند. می‌توانی داشته باشی:

```text
DDD
+
Hexagonal Architecture
+
Clean Architecture
+
SOLID
+
Dependency Injection
```

---

<a id="chapter-12"></a>

# فصل ۱۲: `Modular Monolith`

## `Monolith` چیست؟

`Monolith` یعنی یک Application که به صورت یک واحد Deploy می‌شود.

مثلاً:

```text
                    Application
                         │
        ┌────────────────┼────────────────┐
        ↓                ↓                ↓
      User             Order           Payment
        │                │                │
        └────────────────┼────────────────┘
                         ↓
                     PostgreSQL
```

Monolith ذاتاً بد نیست. مشکل زمانی شروع می‌شود که داخل آن هیچ مرز روشنی وجود نداشته باشد.

## مشکل `Big Ball of Mud`

ساختار بد:

```text
internal/
├── handlers/
├── services/
├── repositories/
├── models/
└── utils/
```

و همه چیز می‌تواند همه چیز را صدا بزند:

```text
Order → User
User → Payment
Payment → Order
Order → Notification
Notification → User
```

بعد از مدتی:

```text
Everything depends on Everything
```

این مشکل Monolith بودن نیست؛ مشکل نبودن مرز است.

## `Modular Monolith` چیست؟

ایده:

```text
یک Application داریم،
اما داخل آن Moduleهای مستقل با Boundary روشن داریم.
```

مثلاً:

```text
Application
├── user
├── ordering
├── payment
└── notification
```

هر Module می‌تواند Domain، Application و Adapterهای خودش را داشته باشد:

```text
ordering/
├── domain/
├── application/
├── ports/
└── adapters/

payment/
├── domain/
├── application/
├── ports/
└── adapters/
```

## Module Boundary

اگر `Order` می‌خواهد Payment انجام دهد، نباید جزئیات داخلی Payment را دستکاری کند.

بد:

```text
Order → paymentRepo.Find(...)
Order → paymentDB.Update(...)
Order → paymentModel.Status = ...
```

بهتر:

```text
Order → Payment API/Port → Payment Module
```

یعنی Order فقط contract بیرونی Payment را می‌شناسد.

## ارتباط با DDD

`Bounded Context`های DDD می‌توانند به Moduleهای Modular Monolith نگاشت شوند:

```text
Billing Context      → billing module
Ordering Context     → ordering module
Notification Context → notification module
```

البته همیشه یک به یک نیست، اما مدل ذهنی خوبی است.

## چرا Modular Monolith جذاب است؟

چون ترکیبی از دو مزیت است:

```text
سادگی Monolith
    +
مرزبندی Modular
```

یعنی:

```text
یک Deployment
یک Codebase
یک Process
اما Domain Boundaries واضح
```

## Modular Monolith در مقابل Microservices

`Modular Monolith`:

```text
             Application
                  │
     ┌────────────┼────────────┐
     ↓            ↓            ↓
   User         Order       Payment
```

یک واحد Deploy دارد.

`Microservices`:

```text
User Service
Order Service
Payment Service
Notification Service
```

هرکدام process و deployment جدا دارند و ارتباطشان معمولاً از طریق network است.

## هزینه Microservice

وقتی یک Function Call تبدیل به Network Call می‌شود:

```text
payment.Pay()
```

تبدیل می‌شود به:

```text
Order Service
      │
      │ HTTP/gRPC/NATS
      ↓
Payment Service
```

چیزهای جدید اضافه می‌شوند:

```text
Network failure
Timeout
Retry
Serialization
Authentication
Observability
Deployment
Service discovery
Distributed transactions
```

پس Microservice فقط «چند قسمت کردن کد» نیست.

## Modular Monolith می‌تواند بعداً Microservice شود

اگر مرز Moduleها درست باشد، بعداً می‌توان یک Module را جدا کرد:

```text
Application
├── User
├── Order
└── Payment

Notification Service
```

اصل مهم:

```text
Microservice شدن باید نتیجه Boundary خوب باشد،
نه جایگزین Boundary خوب.
```

## ساختار مناسب در Go

```text
cmd/
└── api/
    └── main.go

internal/
├── ordering/
│   ├── domain/
│   ├── application/
│   └── adapters/
│
├── payment/
│   ├── domain/
│   ├── application/
│   └── adapters/
│
└── notification/
    ├── domain/
    ├── application/
    └── adapters/
```

این ساختار `Feature/Domain-oriented` است، نه صرفاً `Layer-oriented`.

## اصل فصل ۱۲

```text
اول Boundary درست کن.
بعد تصمیم بگیر همان Process باشد یا Process جدا.
```

---

<a id="chapter-13"></a>

# فصل ۱۳: `Communication & Integration Patterns`

## سؤال اصلی

وقتی سیستم به چند Module یا Service تقسیم می‌شود، باید تصمیم بگیریم:

```text
این بخش‌ها چطور با هم ارتباط بگیرند؟
```

این انتخاب فقط تکنولوژی نیست؛ روی Coupling، Availability، Failure Handling و Consistency اثر می‌گذارد.

<a id="sync-async"></a>

## دو نوع ارتباط اصلی

```text
Synchronous
Asynchronous
```

## ارتباط همزمان (`Synchronous Communication`)

در Sync، سرویس A درخواست می‌فرستد و منتظر پاسخ B می‌ماند.

```text
Order Service
      │
      │ HTTP/gRPC
      ↓
Payment Service
      │
      ↓
   Response
```

مثلاً:

```go
payment, err := paymentClient.Pay(ctx, amount)
if err != nil {
    return err
}
```

مزیت:

```text
ساده، مستقیم، قابل فهم
```

عیب:

```text
وابستگی زمانی
Availability(A) وابسته به Availability(B)
```

اگر Payment Down باشد، Order هم ممکن است گیر کند.

## ارتباط غیرهمزمان (`Asynchronous Communication`)

در Async، فرستنده لازم نیست منتظر پردازش گیرنده بماند.

```text
Order
  │
  │ publish event
  ↓
NATS
  │
  ↓
Notification
```

Order می‌گوید:

```text
OrderCreated
```

و ادامه می‌دهد. Notification بعداً آن را مصرف می‌کند.

<a id="command-event"></a>

## `Command` و `Event`

### `Command`

یعنی:

```text
لطفاً این کار را انجام بده.
```

مثال:

```text
ChargePayment
SendNotification
GenerateInvoice
```

Command معمولاً مقصد مشخص دارد.

### `Event`

یعنی:

```text
این اتفاق افتاد.
```

مثال:

```text
OrderCreated
PaymentCompleted
UserRegistered
NotificationSent
```

Event درباره گذشته صحبت می‌کند، نه دستور آینده.

## `HTTP` در مقابل `gRPC`

### `HTTP/REST`

برای Public API، Web Client و integrationهای عمومی رایج است.

```text
Client
 ↓
HTTP
 ↓
JSON
```

مزیت:

```text
ساده، عمومی، قابل debug، مناسب APIهای بیرونی
```

### `gRPC`

برای Service-to-Service جذاب است.

```text
Service A
    ↓
  gRPC
    ↓
Service B
```

قرارداد با `Proto` تعریف می‌شود:

```proto
service PaymentService {
    rpc Pay(PayRequest) returns (PayResponse);
}
```

مزیت:

```text
قرارداد قوی‌تر، performance خوب، code generation
```

## `Message Broker`

برای Async معمولاً Broker داریم:

```text
Producer
    ↓
Broker
    ↓
Consumer
```

مثال‌ها:

```text
NATS
Kafka
RabbitMQ
Amazon SQS
```

Broker مسئول تحویل، صف، مدیریت Consumer و گاهی persistence پیام‌هاست.

## `Queue` در مقابل `Pub/Sub`

### `Queue`

یک پیام معمولاً توسط یکی از Workerها پردازش می‌شود:

```text
Message
   ↓
Queue
 ┌─┼─┐
 ↓ ↓ ↓
C1 C2 C3
```

برای تقسیم کار بین Workerها مناسب است.

### `Pub/Sub`

یک Event می‌تواند به چند Subscriber برسد:

```text
           Event
             ↓
          Broker
       ┌─────┼─────┐
       ↓     ↓     ↓
      A      B     C
```

برای اعلام رخداد به چند بخش مناسب است.

## جای `NATS`

در مثال Notification:

```text
Other Services
      │
      ↓
    NATS
      │
      ↓
Notification Service
```

داخل Notification:

```text
NATS Consumer
      ↓
Application Use Case
      ↓
Domain
      ↓
Ports
      ↓
SMS / Email / Telegram Adapters
```

نکته:

```text
NATS Business Logic نیست.
NATS یک Transport/Adapter است.
```

## Transaction و Event

مشکل مهم:

```text
BEGIN TRANSACTION

INSERT order
PUBLISH OrderCreated

COMMIT
```

اگر `INSERT` موفق شود ولی `PUBLISH` شکست بخورد چه؟

یا اگر `PUBLISH` موفق شود ولی `COMMIT` شکست بخورد چه؟

ممکن است Database و Event Stream ناسازگار شوند.

<a id="outbox-pattern"></a>

## `Outbox Pattern`

راه رایج:

```text
Database Transaction
       │
       ├── orders
       └── outbox_events
```

در یک Transaction:

```text
BEGIN

INSERT order
INSERT outbox_event

COMMIT
```

بعد یک Publisher جدا:

```text
Outbox Table
     ↓
Publisher
     ↓
NATS
```

این باعث می‌شود ثبت State و ثبت قصد انتشار Event در یک transaction انجام شوند.

## انتخاب Communication

قاعده ساده:

```text
اگر به جواب فوری نیاز داری → Sync
اگر می‌خواهی وقوع چیزی را اعلام کنی → Event
اگر می‌خواهی یک سرویس مشخص کاری انجام دهد → Command
```

مثال‌ها:

```text
Get User              → Sync Query
Check Balance         → Sync
OrderCreated          → Event
PaymentCompleted      → Event
ChargePayment         → Command
SendNotification      → Command
```

---

<a id="chapter-14"></a>

# فصل ۱۴: `Distributed Systems & Consistency`

## `Distributed System` چیست؟

سیستمی که اجزای آن در چند process/node جدا اجرا می‌شوند و با شبکه با هم ارتباط دارند.

```text
Order Service
      │
      ↓
Payment Service
      │
      ↓
Notification Service
```

## تفاوت اصلی با Monolith

در Monolith:

```go
payment.Pay()
```

اما در Distributed System:

```text
Order
  │
  │ Network
  ↓
Payment
```

شبکه قابل اعتماد نیست:

```text
Request lost
Response lost
Timeout
Connection refused
Service crash
Packet delay
Broker unavailable
```

<a id="timeout-retry-backoff"></a>

## `Timeout`

نباید تا ابد منتظر پاسخ بمانیم.

در Go:

```go
ctx, cancel := context.WithTimeout(ctx, 2*time.Second)
defer cancel()
```

معنی:

```text
بعد از ۲ ثانیه عملیات cancel می‌شود.
```

هر ارتباط شبکه‌ای جدی باید timeout داشته باشد.

## `Retry`

اگر خطا موقت باشد، شاید دوباره تلاش کنیم:

```text
Attempt 1 ❌
Attempt 2 ❌
Attempt 3 ✅
```

اما هر خطایی قابل Retry نیست.

## `Transient Failure` و `Permanent Failure`

### خطای موقت (`Transient`)

ممکن است بعداً درست شود:

```text
Timeout
Connection reset
Database temporarily unavailable
Broker temporarily unavailable
Rate limit temporary
```

برای این‌ها Retry می‌تواند منطقی باشد.

### خطای دائمی (`Permanent`)

با Retry حل نمی‌شود:

```text
Invalid payload
Unknown user
Invalid state transition
Missing required field
Invalid phone number
```

Retry کردن این‌ها فقط فشار و نویز ایجاد می‌کند. باید fail شوند، ثبت شوند یا به `Dead Letter` بروند.

## `Exponential Backoff`

Retryها نباید بی‌فاصله پشت سر هم انجام شوند.

بهتر:

```text
1s
2s
4s
8s
16s
```

هدف این است که در زمان خرابی، سیستم مقصد زیر موج Retry له نشود.

## `Idempotency`

یکی از مهم‌ترین مفاهیم Distributed Systems.

اگر یک operation دوبار اجرا شد، نباید نتیجه مخرب ایجاد کند.

مثلاً:

```text
ChargePayment
```

اگر response گم شود، caller ممکن است دوباره تلاش کند. اگر عملیات idempotent نباشد:

```text
$100 charged
+
$100 charged again
=
$200 charged
```

این فاجعه است.

<a id="idempotency-key"></a>

## `Idempotency Key`

راه رایج:

```text
idempotency_key = abc-123
```

Request:

```json
{
  "amount": 100,
  "idempotency_key": "abc-123"
}
```

Payment Service ثبت می‌کند:

```text
abc-123 → processed
```

اگر همان request دوباره آمد، عملیات را دوباره انجام نمی‌دهد و نتیجه قبلی را برمی‌گرداند.

## `Consistency`

Consistency یعنی داده‌ها و State سیستم مطابق قوانین مورد انتظار باشند.

مثلاً ناسازگاری:

```text
Order DB:
Order = Paid

Payment DB:
Payment = Pending
```

در سیستم توزیع‌شده همیشه نمی‌توان همه چیز را فوراً و همزمان consistent نگه داشت.

## `Strong Consistency`

بعد از Write، همه بلافاصله مقدار جدید را می‌بینند.

مثلاً:

```text
Balance = 100
Withdraw 50
Immediately:
Balance = 50
```

برای بعضی Domainها مثل بخش‌های حساس مالی، این رفتار مهم است.

## `Eventual Consistency`

ممکن است برای مدت کوتاهی بخش‌های سیستم State متفاوت ببینند، اما نهایتاً به حالت درست می‌رسند.

مثلاً:

```text
Order Service:
Order = Paid

Notification Service:
not processed yet
```

چند لحظه بعد:

```text
Notification = processed
```

این یعنی `Eventual Consistency`.

## `Distributed Transactions`

در یک Database:

```sql
BEGIN;

UPDATE orders;
UPDATE payments;

COMMIT;
```

اگر خطا شود، rollback داریم.

اما اگر هر سرویس دیتابیس خودش را داشته باشد:

```text
Order Service → Order DB
Payment Service → Payment DB
```

یک transaction ساده مشترک نداریم.

<a id="saga-pattern"></a>

## `Saga Pattern`

برای workflowهای distributed از Saga استفاده می‌شود.

مثلاً:

```text
Create Order
     ↓
Reserve Inventory
     ↓
Charge Payment
     ↓
Confirm Order
```

اگر Payment شکست بخورد:

```text
Create Order       ✅
Reserve Inventory  ✅
Charge Payment     ❌
```

باید عملیات جبرانی انجام دهیم:

```text
Release Inventory
Cancel Order
```

این‌ها `Compensating Actions` هستند.

## `Choreography` و `Orchestration`

### `Choreography`

هیچ coordinator مرکزی نیست. سرویس‌ها Event منتشر می‌کنند و به Eventهای هم واکنش نشان می‌دهند:

```text
Order
 ↓ OrderCreated
Inventory
 ↓ InventoryReserved
Payment
 ↓ PaymentFailed
Inventory
 ↓ StockReleased
```

مزیت:

```text
مرکز کنترل واحد نداریم.
```

عیب:

```text
Business Flow ممکن است بین چند سرویس پخش و سخت‌فهم شود.
```

### `Orchestration`

یک Orchestrator جریان را کنترل می‌کند:

```text
           Orchestrator
          /      |      \
         ↓       ↓       ↓
      Order  Inventory Payment
```

مزیت:

```text
Workflow واضح‌تر و قابل مشاهده‌تر است.
```

عیب:

```text
Orchestrator مسئولیت زیادی می‌گیرد.
```

## `CAP Theorem`

در سیستم توزیع‌شده، هنگام Partition شبکه نمی‌توان همزمان این سه را کامل تضمین کرد:

```text
C = Consistency
A = Availability
P = Partition Tolerance
```

در عمل Partition ممکن است رخ دهد. پس هنگام Partition بین Consistency و Availability trade-off داریم.

مثال:

```text
Node A   X   Node B
```

اگر B نتواند State جدید A را ببیند:

- اگر Availability را حفظ کند، ممکن است request را قبول کند و بعداً conflict ایجاد شود.
- اگر Consistency را حفظ کند، ممکن است request را رد کند تا state خراب نشود.

CAP نمی‌گوید هر سیستم فقط یکی از C/A/P را دارد. می‌گوید هنگام Partition نمی‌توان Strong Consistency و Availability کامل را همزمان تضمین کرد.

## `Ordering`

ترتیب پیام‌ها مهم است.

مثلاً:

```text
OrderCreated
PaymentCompleted
OrderCancelled
```

اگر Consumer این ترتیب را بگیرد:

```text
PaymentCompleted
OrderCreated
OrderCancelled
```

ممکن است مشکل ایجاد شود.

پس باید بدانیم Broker و partitioning چه تضمینی درباره ordering می‌دهند.

## Failure بخشی از طراحی است

در Distributed System فقط Happy Path کافی نیست.

باید این‌ها را طراحی کنیم:

```text
Timeout
Retry
Duplicate
Out-of-order message
Partial failure
Crash
Network failure
Broker failure
Permanent failure
Dead Letter
Observability
```

اصل مهم:

```text
Failure یک Exception حاشیه‌ای نیست؛ بخشی از طراحی سیستم است.
```

---

<a id="chapter-15"></a>

# فصل ۱۵: `Architecture Decision & Trade-offs`

## معماری یعنی انتخاب

معماری خوب یعنی تصمیم گرفتن با توجه به نیازها و محدودیت‌ها.

سؤال‌ها:

```text
REST یا gRPC؟
Sync یا Async؟
Monolith یا Microservice؟
PostgreSQL یا MongoDB؟
NATS یا Kafka؟
Strong Consistency یا Eventual Consistency؟
Cache داشته باشیم یا نه؟
```

هیچ‌کدام ذاتاً بهترین نیستند. همه به Context بستگی دارند.

## Functional Requirements

اول باید بفهمیم سیستم چه کاری باید انجام دهد.

مثلاً Notification Service:

```text
Receive notification request
Validate
Store
Send
Track delivery
Retry failures
```

این‌ها نیازهای عملکردی هستند.

## Non-Functional Requirements

بعد می‌پرسیم سیستم چطور باید کار کند:

```text
Latency
Throughput
Availability
Durability
Consistency
Security
Scalability
Observability
```

مثلاً:

```text
API latency < 200ms
99.9% availability
10000 notifications/sec
Messages must not be lost
```

این‌ها معماری را تغییر می‌دهند.

<a id="adr"></a>

## `ADR` یا `Architecture Decision Record`

برای تصمیم‌های مهم بهتر است دلیل تصمیم ثبت شود.

ساختار ساده:

```text
Context
Decision
Alternatives
Consequences
```

مثال:

```text
Context:
Services need asynchronous communication.

Options:
- NATS
- Kafka
- RabbitMQ

Decision:
Use NATS.

Why:
- Lightweight
- Good fit for current workload
- Simple operational model
- Team familiarity

Trade-off:
Less suitable if we later need very large event-stream retention.
```

ADR کمک می‌کند بعداً بفهمیم چرا تصمیم گرفته شد، نه فقط چه تصمیمی گرفته شد.

## `Trade-off`

در معماری تقریباً همیشه چیزی را به دست می‌آوری و چیزی را از دست می‌دهی.

مثلاً Microservice:

```text
Benefits:
Independent deployment
Independent scaling
Isolation

Costs:
Network complexity
Operational complexity
Distributed transactions
Observability complexity
Debugging complexity
```

پس:

```text
Microservice = بهتر
```

نیست.

درست‌تر:

```text
Microservice = یک Trade-off
```

## Monolith در مقابل Microservices

| معیار | Modular Monolith | Microservices |
|---|---|---|
| Deployment | ساده‌تر | پیچیده‌تر |
| Network | کمتر | بیشتر |
| Scaling | کل App | مستقل |
| Debugging | ساده‌تر | سخت‌تر |
| Data consistency | ساده‌تر | سخت‌تر |
| Team independence | کمتر | بیشتر |
| Operational cost | پایین‌تر | بالاتر |

هیچ برنده مطلقی وجود ندارد.

## `Scalability`

`Scalability` یعنی با افزایش Load، سیستم بتواند منابع بیشتری مصرف کند و همچنان نیازها را پاسخ دهد.

## `Vertical Scaling`

یک سرور را قوی‌تر می‌کنیم:

```text
4 CPU / 8GB
     ↓
16 CPU / 64GB
```

## `Horizontal Scaling`

چند instance اجرا می‌کنیم:

```text
Server  Server  Server
   \       |       /
      Load Balancer
```

## چرا `Stateless` مهم است؟

اگر APIها پشت Load Balancer باشند:

```text
Client
  ↓
Load Balancer
  ↓
┌───────┬───────┬───────┐
│ API 1 │ API 2 │ API 3 │
└───────┴───────┴───────┘
```

و Session داخل process باشد، request بعدی ممکن است به instance دیگری برود و session را نداشته باشد.

پس معمولاً state را بیرون از process نگه می‌داریم:

```text
API
 ↓
Redis / Database
```

این کار horizontal scaling را آسان‌تر می‌کند.

## `Bottleneck`

اگر Application بتواند `5000 req/s` پردازش کند، اما Database فقط `300 req/s`:

```text
Application = 5000 req/s
Database    = 300 req/s
```

Bottleneck دیتابیس است.

معماری خوب یعنی Bottleneck واقعی را پیدا کنیم، نه اینکه بی‌هدف instance اضافه کنیم.

## `Cache`

برای داده‌هایی که زیاد خوانده می‌شوند:

```text
Client
 ↓
API
 ↓
Cache
 ↓ cache miss
Database
```

مثلاً `Redis`.

اما Cache هزینه دارد:

```text
Cache Invalidation
Stale Data
Consistency
Memory Cost
Operational Complexity
```

پس Cache هم Trade-off است.

## `Observability`

سه ستون اصلی:

```text
Logs
Metrics
Traces
```

### Logs

می‌گویند چه اتفاقی افتاد.

```text
payment request failed
order created
consumer retry started
```

### Metrics

می‌گویند چقدر:

```text
requests/sec
error rate
latency
CPU
memory
queue depth
retry count
```

### Traces

می‌گویند یک request از کجا عبور کرد:

```text
HTTP
 ↓
Order
 ↓
Payment
 ↓
NATS
 ↓
Notification
 ↓
SMS
```

در سیستم توزیع‌شده Trace بسیار مهم است.

## Security بخشی از Architecture است

Security را نباید آخر پروژه اضافه کرد.

موارد مهم:

```text
Authentication
Authorization
Encryption
Secrets Management
Network Boundaries
Audit
Rate Limiting
Input Validation
```

دو سؤال پایه‌ای:

```text
Who are you?
What are you allowed to do?
```

## روش طراحی معماری از صفر

یک ترتیب مفید:

```text
1. Understand Domain
2. Identify Use Cases
3. Identify Business Rules
4. Identify Boundaries
5. Identify Data
6. Identify Communication
7. Identify NFRs
8. Choose Architecture
9. Identify Failure Modes
10. Document Decisions
```

### ۱. Domain را بفهم

```text
سیستم درباره چیست؟
```

مثلاً Marketplace:

```text
User
Seller
Product
Order
Payment
Shipment
```

### ۲. Use Caseها را پیدا کن

```text
User registers
User creates order
Seller accepts order
Payment succeeds
Shipment created
```

### ۳. Business Ruleها را پیدا کن

```text
Order cannot be paid twice.
Order cannot be cancelled after shipment.
Seller cannot accept an already cancelled order.
Payment must belong to the order.
```

### ۴. Boundaryها را پیدا کن

```text
Identity
Catalog
Ordering
Payment
Shipping
Notification
```

### ۵. Data و Consistency را بررسی کن

```text
چه داده‌ای داریم؟
چه رابطه‌ای دارند؟
Transaction Boundary کجاست؟
Strong Consistency کجا لازم است؟
Eventual Consistency کجا قابل قبول است؟
```

### ۶. Communication را انتخاب کن

مثلاً:

```text
Order → Payment
```

آیا Sync لازم است؟ یا Event/Command کافی است؟

### ۷. NFRها را مشخص کن

```text
Latency?
Throughput?
Availability?
Durability?
Security?
Observability?
```

### ۸. معماری را انتخاب کن

مثلاً:

```text
Modular Monolith
+
DDD
+
Hexagonal
+
PostgreSQL
+
Redis
+
NATS
```

یا:

```text
Microservices
+
DDD
+
gRPC
+
Kafka
+
PostgreSQL per service
```

### ۹. Failure Modeها را طراحی کن

برای هر ارتباط بپرس:

```text
What if it fails?
What if response is lost?
What if message is duplicated?
What if consumer crashes?
What if broker is unavailable?
```

### ۱۰. تصمیم‌ها را مستند کن

با ADR تصمیم‌ها و Trade-offها را بنویس.

## مهم‌ترین جمع‌بندی ۱۵ فصل

```text
1. معماری یعنی مدیریت Complexity.
2. مرزها از فولدرها مهم‌ترند.
3. Dependency Direction از اسم Pattern مهم‌تر است.
4. Business Logic نباید به جزئیات تکنولوژیک وابسته باشد.
5. DDD کمک می‌کند مسئله را درست مدل کنیم.
6. Hexagonal و Clean کمک می‌کنند Core از بیرون جدا شود.
7. Modular Monolith اغلب نقطه شروع خوبی است.
8. Microservice راه‌حل بعضی مشکلات است، نه نشانه حرفه‌ای بودن.
9. Network Failure باید از ابتدا در طراحی دیده شود.
10. هیچ Architecture بدون Trade-off وجود ندارد.
```

---

<a id="chapter-16"></a>

# فصل ۱۶: انواع معماری‌های دیگر و سطح آن‌ها

همه چیزهایی که اسمشان `Architecture` است در یک سطح نیستند. بعضی Application Architecture هستند، بعضی Distributed Architecture، بعضی Data Architecture و بعضی بیشتر الگوی سازمان‌دهی کد یا مدل تفکر Domain هستند.

## نقشه ذهنی

```text
Software Architecture
│
├── Application Architecture
│   ├── Layered Architecture
│   ├── Hexagonal Architecture
│   ├── Clean Architecture
│   ├── Onion Architecture
│   ├── Vertical Slice Architecture
│   ├── Screaming Architecture
│   └── Pipes & Filters
│
├── Domain / Business Architecture
│   ├── Domain-Driven Design
│   ├── Modular Monolith
│   ├── Event Storming
│   └── Bounded Context
│
├── Distributed System Architecture
│   ├── Microservices
│   ├── SOA
│   ├── Event-Driven Architecture
│   ├── Serverless
│   ├── Actor Model
│   └── Peer-to-Peer
│
├── Data Architecture
│   ├── CQRS
│   ├── Event Sourcing
│   ├── Data Mesh
│   ├── Data Lake
│   └── Lambda Architecture
│
└── Infrastructure / Deployment Architecture
    ├── Monolith
    ├── Microservices
    ├── Serverless
    ├── Cloud-Native
    └── Kubernetes-based
```

در این درس‌نامه روی مواردی می‌مانیم که در گفتگو مطرح شدند.

## `Onion Architecture`

خیلی نزدیک به Clean Architecture است.

مرکز:

```text
Domain
```

لایه‌های بیرونی:

```text
Application
Infrastructure
UI/API
```

دیاگرام:

```text
┌──────────────────────────┐
│ Infrastructure           │
│   ┌──────────────────┐   │
│   │ Application      │   │
│   │   ┌───────────┐  │   │
│   │   │ Domain    │  │   │
│   │   └───────────┘  │   │
│   └──────────────────┘   │
└──────────────────────────┘
```

قاعده اصلی:

```text
Dependency به سمت مرکز می‌رود.
```

پس Onion، Clean و Hexagonal هم‌خانواده‌اند، نه سه جهان کاملاً جدا.

## `Vertical Slice Architecture`

به جای تقسیم صرفاً بر اساس Layer:

```text
controllers/
services/
repositories/
```

کد بر اساس Feature/Use Case تقسیم می‌شود:

```text
features/
├── create-order/
│   ├── handler.go
│   ├── usecase.go
│   └── repository.go
│
├── cancel-order/
│   ├── handler.go
│   ├── usecase.go
│   └── repository.go
│
└── get-order/
    ├── handler.go
    ├── query.go
    └── repository.go
```

مزیت:

```text
کد مرتبط با یک Use Case نزدیک هم است.
```

برای سیستم‌هایی با Use Caseهای زیاد، این مدل می‌تواند خواناتر باشد.

## `Screaming Architecture`

ایده:

```text
ساختار پروژه باید نشان دهد سیستم برای چیست.
```

بد:

```text
controllers/
services/
repositories/
models/
```

با نگاه کردن نمی‌فهمیم سیستم درباره چه Domainای است.

بهتر:

```text
orders/
payments/
shipping/
notifications/
```

ساختار باید Domain را فریاد بزند؛ یعنی اولین چیزی که دیده می‌شود مسئله کسب‌وکار باشد، نه Framework.

## `Pipes & Filters`

برای پردازش مرحله‌ای داده:

```text
Input
 ↓
Filter 1
 ↓
Filter 2
 ↓
Filter 3
 ↓
Output
```

مثلاً:

```text
Read
 ↓
Parse
 ↓
Validate
 ↓
Transform
 ↓
Store
```

برای pipelineهای data processing، ETL، پردازش فایل یا stream مفید است.

## `SOA` یا `Service-Oriented Architecture`

قدیمی‌تر و گسترده‌تر از Microservices است.

ایده کلی:

```text
Service A
Service B
Service C
      ↓
Enterprise Service Bus
```

تمرکز زیادی روی integration بین سیستم‌های سازمانی دارد.

Microservices را می‌توان در خانواده Service-oriented دانست، اما دقیقاً همان نیست.

## `Serverless Architecture`

در Serverless بخش زیادی از مدیریت server به cloud provider سپرده می‌شود.

مثلاً:

```text
HTTP
 ↓
Function
 ↓
Database
```

نمونه‌ها:

```text
AWS Lambda
Azure Functions
Google Cloud Functions
```

مزیت:

```text
مدیریت infrastructure کمتر
scale خودکارتر برای بعضی workloadها
```

Trade-off:

```text
Cold start
Vendor lock-in
Observability متفاوت
محدودیت runtime
پیچیدگی local development
```

## `Actor Model`

سیستم از Actorهایی تشکیل می‌شود. هر Actor:

```text
State
+
Mailbox
+
Behavior
```

دارد و با Message ارتباط می‌گیرد:

```text
Actor A
   │
   │ Message
   ↓
Actor B
```

برای سیستم‌های concurrent و distributed مفید است.

## `Peer-to-Peer` یا `P2P`

در P2P الزاماً server مرکزی وجود ندارد.

```text
Node ←→ Node
 ↑       ↓
Node ←→ Node
```

نمونه‌های معروف:

```text
Bitcoin
BitTorrent
```

برای blockchain و شبکه‌های غیرمتمرکز مهم است.

<a id="cqrs-event-sourcing"></a>

## `CQRS`

`Command Query Responsibility Segregation` یعنی مسیر/مدل Write و Read را جدا کنیم.

```text
             API
              │
       ┌──────┴──────┐
       ↓             ↓
   Commands       Queries
       ↓             ↓
   Write Model    Read Model
```

Commandها:

```text
CreateOrder
CancelOrder
PayOrder
```

Queryها:

```text
GetOrder
SearchOrders
ListOrders
```

نکته مهم:

```text
CQRS الزاماً یعنی دو Database جدا نیست.
```

گاهی فقط جدا کردن مدل کدی Command و Query کافی است.

## `Event Sourcing`

در Event Sourcing، Eventها منبع اصلی حقیقت (`Source of Truth`) هستند.

به جای ذخیره فقط state نهایی:

```text
Balance = 500
```

Eventها را ذخیره می‌کنیم:

```text
MoneyDeposited(1000)
MoneyWithdrawn(300)
MoneyWithdrawn(200)
```

State از Eventها بازسازی می‌شود:

```text
1000 - 300 - 200 = 500
```

Event Sourcing با Event-Driven فرق دارد. در Event-Driven ممکن است دیتابیس عادی source of truth باشد و Event فقط برای اطلاع‌رسانی منتشر شود.

## `Data Mesh`

بیشتر در معماری Data Platform مطرح است.

ایده:

```text
هر Domain مالک Data خودش باشد.
```

به جای یک تیم مرکزی که همه داده‌ها را مدیریت کند:

```text
             Data Platform
                   │
       ┌───────────┼───────────┐
       ↓           ↓           ↓
    Finance      Sales      Marketing
```

هر Domain داده خود را مثل یک محصول داده‌ای مدیریت می‌کند.

## ترکیب‌پذیری معماری‌ها

این معماری‌ها همیشه رقیب هم نیستند. ممکن است یک سیستم همزمان این‌ها را داشته باشد:

```text
Modular Monolith
+
DDD
+
Hexagonal Architecture
+
Vertical Slice
+
Event-Driven
+
CQRS
```

مثلاً:

```text
                    Application
                         │
       ┌─────────────────┼─────────────────┐
       ↓                 ↓                 ↓
    Ordering          Payment         Notification
       │                 │                 │
   Vertical           Vertical          Vertical
    Slices             Slices            Slices
       │                 │                 │
       └──────────── DDD Boundaries ──────┘
                         │
                    Hexagonal Core
                         │
                PostgreSQL + NATS
```

پس معماری را چندبعدی ببین:

```text
یک الگو برای کد
یک الگو برای Domain
یک الگو برای ارتباط
یک الگو برای داده
یک الگو برای deployment
```

---

<a id="chapter-17"></a>

# فصل ۱۷: `Event-Driven Architecture` عمیق‌تر

## تعریف کلی

`Event-Driven Architecture` یعنی سیستم حول رخدادها (`Events`) طراحی شود.

به جای اینکه یک سرویس مستقیماً به همه سرویس‌هایی که باید کاری انجام دهند دستور بدهد، یک اتفاق را اعلام می‌کند و بخش‌های دیگر مستقل به آن واکنش نشان می‌دهند.

## `Event` چیست؟

`Event` یعنی:

```text
یک اتفاقی در سیستم رخ داده است.
```

مثال:

```text
UserRegistered
OrderCreated
PaymentCompleted
OrderCancelled
NotificationSent
```

Event درباره گذشته صحبت می‌کند.

```text
OrderCreated
```

یعنی:

```text
سفارش ساخته شد.
```

نه:

```text
سفارش را بساز.
```

## `Event` در مقابل `Command` در مقابل `State`

### `Command`

یعنی:

```text
این کار را انجام بده.
```

مثال:

```text
CreateOrder
ChargePayment
SendNotification
```

### `Event`

یعنی:

```text
این اتفاق افتاد.
```

مثال:

```text
OrderCreated
PaymentCompleted
NotificationSent
```

### `State`

یعنی:

```text
الان وضعیت چیست؟
```

مثال:

```text
Order.status = PAID
Balance = 500
Notification.status = SENT
```

تصویر:

```text
Command
    ↓
"Do this"

Event
    ↓
"This happened"

State
    ↓
"This is current condition"
```

## مثال ساده بدون Event-Driven

```text
User
 ↓
Order Service
 ↓
Notification Service
 ↓
SMS
```

اینجا `Order Service` مستقیماً `Notification Service` را می‌شناسد.

اگر بعداً Analytics، Billing، Fraud Detection و Inventory هم اضافه شوند:

```text
Order Service
 ├──→ Notification
 ├──→ Analytics
 ├──→ Billing
 ├──→ Inventory
 └──→ Fraud Detection
```

Coupling بالا می‌رود.

## مدل Event-Driven

```text
User
 ↓
Order Service
 ↓
OrderCreated
 ↓
Broker
 ↓
Notification Service
```

Order Service فقط اعلام می‌کند:

```text
OrderCreated
```

و نمی‌داند چه Consumerهایی آن را مصرف می‌کنند.

## `Producer` و `Consumer`

`Producer` تولیدکننده Event است.

مثلاً:

```text
Order Service
```

`Consumer` مصرف‌کننده Event است.

مثلاً:

```text
Notification Service
Analytics Service
Inventory Service
```

دیاگرام:

```text
Order Service
      │
      │ publishes
      ↓
 OrderCreated
      │
      ↓
    Broker
      │
      │ consumes
      ↓
Notification Service
```

## `Broker`

Broker واسطه انتقال پیام بین Producer و Consumer است.

```text
Producer
    ↓
Broker
    ↓
Consumer
```

نمونه‌ها:

```text
NATS
Kafka
RabbitMQ
Amazon SQS
```

Broker می‌تواند مسئول این‌ها باشد:

```text
Message Delivery
Queueing
Consumer Management
Persistence
Retry mechanics
Subject/Topic routing
```

ویژگی دقیق هر Broker فرق دارد.

## `Pub/Sub`

در Pub/Sub یک Event می‌تواند توسط چند Subscriber دریافت شود.

```text
                    OrderCreated
                         │
                       Broker
              ┌──────────┼──────────┐
              ↓          ↓          ↓
        Notification  Analytics   Billing
```

مزیت:

```text
Producer به Consumerها وابسته نیست.
Consumer جدید می‌تواند اضافه شود بدون تغییر Producer.
```

## `Loose Coupling`

در ارتباط مستقیم:

```text
A → B
```

A باید B را بشناسد.

در Event-Driven:

```text
A → Event Contract → Broker
B → Event Contract
C → Event Contract
```

A دیگر B و C را مستقیم نمی‌شناسد. فقط Event Contract را می‌شناسد.

این Coupling را از:

```text
Service-to-Service Coupling
```

به:

```text
Service-to-Event-Contract Coupling
```

تبدیل می‌کند.

نکته مهم: Coupling صفر نمی‌شود؛ شکل آن تغییر می‌کند. حالا Event Schema بسیار مهم می‌شود.

## Event نباید دستور پنهان باشد

Event خوب:

```json
{
  "type": "OrderCreated",
  "order_id": "123",
  "user_id": "456"
}
```

این یعنی اتفاقی افتاده.

اما:

```json
{
  "type": "SendSMS",
  "phone": "..."
}
```

بیشتر شبیه Command است، چون به یک Consumer می‌گوید چه کاری انجام دهد.

البته Commandها هم می‌توانند از طریق Broker ارسال شوند، اما نباید آن‌ها را با Event اشتباه گرفت.

## Event معمولاً Immutable است

Event یک Fact تاریخی است.

```text
OrderCreated
PaymentCompleted
OrderCancelled
```

اگر Order بعداً Cancel شود، `OrderCreated` را تغییر نمی‌دهیم. یک Event جدید اضافه می‌شود:

```text
OrderCancelled
```

پس:

```text
Event = immutable fact
```

<a id="event-contract"></a>

## `Event Contract`

وقتی Producer Event منتشر می‌کند، Consumerها به شکل و معنای آن وابسته می‌شوند.

مثلاً:

```json
{
  "type": "OrderCreated",
  "order_id": "123",
  "user_id": "456",
  "amount": 150
}
```

این JSON تبدیل به Contract می‌شود.

اگر Producer ناگهان تغییر دهد:

```json
{
  "type": "OrderCreated",
  "id": "123"
}
```

Consumerها ممکن است خراب شوند.

پس Event Schema باید با دقت مدیریت شود.

## `Schema` و `Versioning`

روش رایج:

```text
OrderCreated.v1
OrderCreated.v2
```

یا داخل پیام:

```json
{
  "event_type": "OrderCreated",
  "version": 2
}
```

قواعد مهم:

```text
فیلدهای جدید را طوری اضافه کن که Consumerهای قدیمی نشکنند.
فیلدهای موجود را بی‌هشدار حذف یا تغییر معنا نده.
Version را جدی بگیر.
```

<a id="event-envelope"></a>

## `Event Envelope`

بهتر است Event فقط payload کسب‌وکاری نباشد. معمولاً یک envelope دارد.

مثال:

```json
{
  "event_id": "evt_123",
  "event_type": "OrderCreated",
  "version": 1,
  "occurred_at": "2026-08-19T10:00:00Z",
  "producer": "order-service",
  "correlation_id": "req_456",
  "data": {
    "order_id": "123",
    "user_id": "456"
  }
}
```

قسمت بیرونی:

```text
event_id
event_type
version
occurred_at
producer
correlation_id
```

می‌شود `Envelope`.

قسمت:

```text
data
```

می‌شود payload اصلی Event.

## چرا `event_id` مهم است؟

برای تشخیص Duplicate.

فرض کن:

```text
event_id = evt_123
```

Consumer پیام را می‌گیرد و پردازش می‌کند، اما قبل از Ack کردن crash می‌کند.

Broker ممکن است دوباره همان پیام را بفرستد.

Consumer باید بفهمد:

```text
این event قبلاً پردازش شده است.
```

مثلاً با جدول:

```text
processed_events
----------------
event_id
evt_123
```

## `At-least-once Delivery`

در بسیاری از سیستم‌های واقعی، تضمین رایج این است:

```text
پیام حداقل یک بار تحویل داده می‌شود.
```

یعنی:

```text
1x ✅
2x ممکن است
3x ممکن است در شرایط خطا
```

پس Consumer باید `Idempotent` باشد.

## `Idempotent Consumer`

Consumer باید بتواند یک Event تکراری را بدون اثر مخرب مدیریت کند.

مثال مشکل:

```text
OrderCreated
 ↓
Send SMS
```

اگر Event دوبار برسد، ممکن است SMS دوبار ارسال شود.

راه‌حل:

```text
Check event_id
    ↓
Already processed?
    ├── yes → skip / return previous result
    └── no  → process and mark processed
```

## `Dead Letter`

اگر Event بعد از چند بار Retry همچنان fail شود، نباید تا ابد retry شود.

```text
Event
 ↓
Consumer ❌
 ↓
Retry
 ↓
Consumer ❌
 ↓
Retry
 ↓
Consumer ❌
 ↓
Dead Letter Queue
```

`DLQ` برای بررسی، alert، replay کنترل‌شده یا اصلاح داده استفاده می‌شود.

خطاهای دائمی مثل payload نامعتبر معمولاً باید سریع‌تر به DLQ یا مسیر خطای مناسب بروند.

## `Ordering`

ترتیب Eventها می‌تواند حیاتی باشد.

مثلاً:

```text
OrderCreated
PaymentCompleted
OrderCancelled
```

اگر Consumer اول `PaymentCompleted` را بگیرد و هنوز Order را نشناسد، ممکن است خطا رخ دهد.

راهکارها بسته به سیستم:

```text
Partition by aggregate_id
Sequence number
Consumer-side buffering
Idempotent state transitions
Reject/Retry out-of-order events
```

مهم این است که بدانیم Broker چه تضمینی می‌دهد و Domain چه ترتیبی لازم دارد.

## `Event Chaining`

یک Event می‌تواند باعث Eventهای بعدی شود:

```text
OrderCreated
     ↓
InventoryReserved
     ↓
PaymentCompleted
     ↓
OrderConfirmed
     ↓
NotificationRequested
```

این جریان می‌تواند طبیعی باشد، اما اگر زنجیره‌ها زیاد و نامرئی شوند، فهم و Debug سخت می‌شود.

برای همین:

```text
correlation_id
trace_id
logs
metrics
traces
workflow visibility
```

بسیار مهم‌اند.

## `Choreography` در Event-Driven

در Choreography، هیچ Coordinator مرکزی نیست.

```text
Order
 ↓ OrderCreated
Inventory
 ↓ InventoryReserved
Payment
 ↓ PaymentCompleted
Order
 ↓ OrderConfirmed
Notification
```

مزیت:

```text
Decentralized
Consumerها مستقل‌اند
Coupling مستقیم کمتر است
```

عیب:

```text
Flow اصلی بین سرویس‌ها پخش می‌شود
فهمیدن اینکه کل فرآیند کجاست سخت‌تر می‌شود
```

## `Orchestration` در Event-Driven

در Orchestration، یک coordinator جریان را هدایت می‌کند:

```text
             Order Saga
                 │
       ┌─────────┼─────────┐
       ↓         ↓         ↓
   Inventory   Payment   Shipping
```

Orchestrator می‌گوید:

```text
1. Reserve inventory
2. Charge payment
3. Create shipment
4. Confirm order
```

اگر مرحله‌ای شکست خورد:

```text
Compensating Action
```

مثلاً:

```text
Release inventory
Cancel order
Refund payment
```

مزیت:

```text
Workflow واضح‌تر است.
```

عیب:

```text
Orchestrator خودش بخش مهم و حساس سیستم می‌شود.
```

## رابطه Event-Driven با `CQRS`

این دو زیاد کنار هم دیده می‌شوند، اما یکی نیستند.

مدل ترکیبی رایج:

```text
Command
   ↓
Write Model
   ↓
Event
   ↓
Read Model
```

مثلاً:

```text
CreateOrder
    ↓
Order Write Model
    ↓
OrderCreated
    ↓
Order Read Model
```

بعد Queryها از Read Model می‌خوانند:

```text
GetOrder → Read DB
```

اما:

```text
Event-Driven ≠ CQRS
```

می‌توان Event-Driven داشت بدون CQRS کامل، و CQRS داشت بدون Event-Driven گسترده.

## رابطه Event-Driven با `Event Sourcing`

باز هم یکی نیستند.

`Event-Driven`:

```text
Event منتشر می‌شود تا Consumerها واکنش نشان دهند.
```

`Event Sourcing`:

```text
Eventها منبع اصلی State هستند.
```

در Event-Driven معمولی:

```text
Database = Source of Truth
Events = Integration/Notification mechanism
```

در Event Sourcing:

```text
Event Store = Source of Truth
State = derived from events
```

## مثال کامل Notification Service

فرض کن `Order Service` بعد از ساخت سفارش Event منتشر می‌کند:

```text
Order Service
      │
      │ OrderCreated
      ↓
     NATS
      │
      ↓
Notification Worker
```

Event:

```json
{
  "event_id": "evt_01",
  "event_type": "OrderCreated",
  "version": 1,
  "occurred_at": "2026-08-19T10:00:00Z",
  "producer": "order-service",
  "correlation_id": "req_789",
  "data": {
    "order_id": "ord_123",
    "user_id": "usr_456"
  }
}
```

داخل Notification:

```text
NATS Consumer
      ↓
Validate Event Envelope
      ↓
Check Schema Version
      ↓
Check Idempotency by event_id
      ↓
Execute SendNotification Use Case
      ↓
Notification Domain
      ↓
Sender Port
      ↓
SMS / Email / Telegram Adapter
      ↓
Ack
```

اگر خطای موقت رخ دهد:

```text
Retry + Backoff
```

اگر خطای دائمی رخ دهد:

```text
Dead Letter
```

اگر Event تکراری باشد:

```text
Idempotent Consumer → skip or return previous result
```

اگر ارسال موفق شود:

```text
NotificationSent event
```

می‌تواند منتشر شود.

## معماری داخلی Notification در مدل Hexagonal

```text
                   NATS
                    │
                    ↓
              NATS Adapter
                    │
                    ↓
          SendNotification Use Case
                    │
                    ↓
              Notification Domain
                    │
          ┌─────────┼─────────┐
          ↓         ↓         ↓
     Repository   Sender    Template
        Port       Port      Port
          ↑         ↑         ↑
          │         │         │
     PostgreSQL  SMS/Email  Template Store
      Adapter    Adapters      Adapter
```

در این مدل:

```text
NATS یک Adapter است.
PostgreSQL یک Adapter است.
SMS Provider یک Adapter است.
Core فقط Use Case و Domain را می‌شناسد.
```

## نکات طراحی Event-Driven

### ۱. Event را از زبان Domain بساز

به جای:

```text
DoNotificationStuff
```

از زبان Domain استفاده کن:

```text
OrderCreated
PaymentCompleted
NotificationRequested
NotificationSent
```

### ۲. Event را کوچک ولی کافی نگه دار

Event نباید تمام دیتابیس را حمل کند، اما باید آن‌قدر اطلاعات داشته باشد که Consumerها بدون وابستگی غیرضروری کار کنند.

### ۳. Schema را Contract بدان

Event Contract بخشی از API سیستم است.

### ۴. Duplicate را طبیعی فرض کن

Consumer را از اول idempotent طراحی کن.

### ۵. Failure را طراحی کن

```text
Retry
Backoff
DLQ
Observability
Replay
Poison message handling
```

### ۶. Eventual Consistency را با Product هماهنگ کن

اگر UI یا Business انتظار دارد همه چیز فوراً تغییر کند، Eventual Consistency باید در طراحی تجربه کاربری و قوانین سیستم دیده شود.

## دام‌های رایج Event-Driven

### Event برای همه چیز

اگر هر تغییر کوچک را Event کنی، سیستم پر از پیام‌های بی‌ارزش می‌شود.

### Eventهای خیلی مبهم

مثلاً:

```text
UserUpdated
```

گاهی خیلی کلی است. Consumer نمی‌داند چه چیزی تغییر کرده.

ممکن است بهتر باشد Event دقیق‌تر باشد:

```text
UserEmailChanged
UserPhoneVerified
UserSuspended
```

البته این هم Trade-off دارد؛ Eventهای خیلی ریز هم تعداد را زیاد می‌کنند.

### پنهان شدن Business Flow

اگر همه چیز فقط Choreography باشد، فهمیدن جریان کامل سخت می‌شود. برای workflowهای مهم، Orchestration یا مستندسازی دقیق لازم است.

### نادیده گرفتن Ordering

اگر Eventهای یک Aggregate بدون ترتیب درست پردازش شوند، state خراب می‌شود.

### نبودن Observability

بدون correlation_id، trace و metrics، debug سیستم Event-Driven بسیار سخت می‌شود.

## خلاصه نهایی Event-Driven

```text
Event
    ↓
یک واقعیت تاریخی: "این اتفاق افتاد"

Producer
    ↓
بخشی که Event را منتشر می‌کند

Consumer
    ↓
بخشی که Event را مصرف می‌کند

Broker
    ↓
واسط انتقال پیام

Pub/Sub
    ↓
یک Event، چند Subscriber

Event Contract
    ↓
قرارداد schema و معنای Event

At-least-once
    ↓
Duplicate ممکن است

Idempotent Consumer
    ↓
پردازش تکراری نباید اثر مخرب داشته باشد

DLQ
    ↓
مسیر پیام‌های شکست‌خورده

Ordering
    ↓
ترتیب پیام‌ها باید آگاهانه طراحی شود

CQRS
    ↓
جداسازی Command و Query

Event Sourcing
    ↓
Eventها Source of Truth هستند
```

---

<a id="final-summary"></a>

# جمع‌بندی نهایی درس‌نامه

اگر کل مسیر را در یک تصویر ببینیم:

```text
Business Problem
       ↓
Domain Understanding
       ↓
Boundaries
       ↓
Modules / Components
       ↓
Dependency Direction
       ↓
Architecture Style
       ↓
Communication Patterns
       ↓
Failure & Consistency Design
       ↓
Architecture Decisions / ADR
       ↓
Trade-offs
```

معماری نرم‌افزار یعنی انتخاب‌های آگاهانه درباره ساختار، مرزها، وابستگی‌ها و رفتار سیستم در برابر تغییر و خطا.

یک معمار خوب فقط Pattern بلد نیست. می‌تواند توضیح دهد:

```text
چرا این تصمیم گرفته شد؟
چه مشکلی را حل می‌کند؟
چه هزینه‌ای دارد؟
چه چیزی را سخت‌تر می‌کند؟
اگر شرایط تغییر کند، کدام تصمیم باید دوباره بررسی شود؟
```

این طرز فکر از اسم معماری‌ها مهم‌تر است.

</div>
