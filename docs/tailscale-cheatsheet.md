# راهنمای کامل دستورات Tailscale

مرجع فارسی دستورات خط فرمان تیل‌اسکیل، همراه با توضیح و مثال.

> 💡 نصب و راه‌اندازی اولیه‌ی تیل‌اسکیل روی سرور خانگی در [راه‌اندازی سرور خانگی](/home-server.md#tailscale--دسترسی-از-بیرون-خانه) آمده است. این صفحه مرجع خود دستورهاست.

---

## فهرست

1. [مفاهیم پایه](#۱-مفاهیم-پایه)
2. [نصب](#۲-نصب)
3. [ورود و اتصال](#۳-ورود-و-اتصال)
4. [وضعیت و اطلاعات](#۴-وضعیت-و-اطلاعات)
5. [تغییر تنظیمات با `set`](#۵-تغییر-تنظیمات-با-set)
6. [Exit node](#۶-exit-node)
7. [Subnet router](#۷-subnet-router)
8. [Tailscale SSH](#۸-tailscale-ssh)
9. [انتقال فایل (Taildrop)](#۹-انتقال-فایل-taildrop)
10. [Serve و Funnel](#۱۰-serve-و-funnel)
11. [DNS و MagicDNS](#۱۱-dns-و-magicdns)
12. [عیب‌یابی](#۱۲-عیب‌یابی)
13. [مدیریت سرویس](#۱۳-مدیریت-سرویس)
14. [جدول خلاصه](#۱۴-جدول-خلاصه)

---

## ۱. مفاهیم پایه

قبل از دستورات، چند اصطلاح که همه‌جا تکرار می‌شوند:

| اصطلاح | یعنی چه |
|---|---|
| **tailnet** | شبکه خصوصی تو — مجموعه همه دستگاه‌هایی که با یک حساب کاربری لاگین کرده‌اند |
| **node / peer** | هر دستگاهی داخل تیل‌نت |
| **آدرس `100.x.y.z`** | IP مجازی که تیل‌اسکیل به هر دستگاه می‌دهد (رنج CGNAT). ثابت است و تغییر نمی‌کند |
| **MagicDNS** | اسم دستگاه به جای IP: به‌جای `100.127.222.31` بنویس `vaio-server` |
| **exit node** | دستگاهی که کل ترافیک اینترنت تو از آن رد می‌شود (مثل VPN) |
| **subnet router** | دستگاهی که کل یک شبکه محلی (مثلاً `192.168.100.0/24`) را به تیل‌نت وصل می‌کند |
| **DERP** | سرورهای رله تیل‌اسکیل؛ وقتی اتصال مستقیم بین دو دستگاه برقرار نشود، ترافیک از آن‌ها رد می‌شود (کندتر) |

نکته مهم: تیل‌اسکیل به‌طور پیش‌فرض **فقط** ترافیک بین دستگاه‌های خودت را جابه‌جا می‌کند. اینترنت عادی‌ات دست‌نخورده می‌ماند — مگر اینکه exit node فعال کنی.

---

## ۲. نصب

### لینوکس (اوبونتو، دبیان، فدورا، …)

```bash
curl -fsSL https://tailscale.com/install.sh | sh
```

این اسکریپت خودش توزیع را تشخیص می‌دهد، مخزن رسمی را اضافه می‌کند و پکیج را نصب می‌کند.

### macOS

```bash
brew install --cask tailscale
```

### بررسی نسخه نصب‌شده

```bash
tailscale version
```

خروجی نمونه:

```
1.86.2
  tailscale commit: 3a1f...
  go version: go1.24.3
```

نسخه مهم است — بعضی از دستورهای این راهنما (مثل `tailscale set` و `tailscale exit-node list`) در نسخه‌های قدیمی وجود ندارند.

### به‌روزرسانی

```bash
sudo tailscale update
```

یا اگر با پکیج‌منیجر نصب کرده‌ای، همان مسیر عادی:

```bash
sudo apt update && sudo apt upgrade tailscale
```

---

## ۳. ورود و اتصال

### اولین بار: لاگین

```bash
sudo tailscale up
```

یک لینک در ترمینال چاپ می‌شود؛ آن را در مرورگر باز کن و با حساب کاربری‌ات تأیید کن. بعد از آن دستگاه وارد تیل‌نت می‌شود.

### روی سروری که مرورگر ندارد

همان لینک را کپی کن و روی لپ‌تاپ خودت باز کن. یا از auth key استفاده کن:

```bash
sudo tailscale up --authkey=tskey-auth-xxxxxxxxxxxx
```

auth key را از پنل ادمین می‌سازی: **Settings → Keys → Generate auth key**. برای سرورها معمولاً کلید **reusable** و **ephemeral=false** می‌خواهی.

### با اسم دلخواه برای دستگاه

```bash
sudo tailscale up --hostname=vaio-server
```

### قطع موقت (بدون خروج از حساب)

```bash
sudo tailscale down
```

دستگاه در تیل‌نت باقی می‌ماند ولی اتصالش قطع می‌شود. برای برگشت:

```bash
sudo tailscale up
```

### خروج کامل از حساب

```bash
sudo tailscale logout
```

بعد از این باید دوباره از اول لاگین کنی.

---

## ۴. وضعیت و اطلاعات

### وضعیت کلی

```bash
tailscale status
```

خروجی نمونه:

```
100.127.222.31  vaio-server          user@   linux   -
100.101.5.12    laptop               user@   linux   active; direct 203.0.113.9:41641
100.90.44.7     phone                user@   iOS     idle; relay "fra"
```

معنی ستون‌ها:

- ستون اول: IP تیل‌اسکیل
- ستون دوم: اسم دستگاه (همان چیزی که در MagicDNS استفاده می‌شود)
- `direct` یعنی اتصال مستقیم P2P برقرار است (سریع)
- `relay "fra"` یعنی از سرور رله فرانکفورت رد می‌شود (کندتر)
- `idle` یعنی الان ترافیکی رد و بدل نمی‌شود، ولی دستگاه آنلاین است

### خروجی JSON برای اسکریپت‌نویسی

```bash
tailscale status --json
```

مثال — گرفتن IP یک دستگاه خاص با `jq`:

```bash
tailscale status --json | jq -r '.Peer[] | select(.HostName=="vaio-server") | .TailscaleIPs[0]'
```

### دیدن IP خود دستگاه

```bash
tailscale ip -4
```

خروجی: `100.127.222.31`

برای IPv6:

```bash
tailscale ip -6
```

### همه تنظیمات فعلی

```bash
tailscale debug prefs
```

نشان می‌دهد الان چه فلگ‌هایی فعال‌اند — مثلاً exit node انتخاب‌شده، وضعیت `AcceptDNS` و `RouteAll`.

---

## ۵. تغییر تنظیمات با `set`

این مهم‌ترین نکته کار با تیل‌اسکیل است:

> `tailscale up` تمام تنظیمات را **از نو** می‌نویسد. هر فلگی که قبلاً داده بودی و این‌بار تکرار نکنی، پاک می‌شود.
> `tailscale set` فقط همان یک مورد را عوض می‌کند و بقیه دست‌نخورده می‌ماند.

مثال از مشکلی که پیش می‌آید:

```bash
# قبلاً این را زده بودی
sudo tailscale up --advertise-exit-node --ssh

# حالا فقط می‌خواهی اسم را عوض کنی و این را می‌زنی
sudo tailscale up --hostname=new-name
# ← نتیجه: هم exit node و هم ssh خاموش شدند!
```

راه درست:

```bash
sudo tailscale set --hostname=new-name
```

فلگ‌های پرکاربرد `set`:

```bash
sudo tailscale set --exit-node=my-vps            # انتخاب exit node
sudo tailscale set --exit-node=                  # لغو exit node
sudo tailscale set --exit-node-allow-lan-access  # حفظ دسترسی به شبکه محلی
sudo tailscale set --advertise-exit-node         # این دستگاه exit node بشود
sudo tailscale set --advertise-routes=192.168.100.0/24
sudo tailscale set --accept-routes               # قبول کردن مسیرهای دیگران
sudo tailscale set --accept-dns=false            # نادیده گرفتن DNS تیل‌اسکیل
sudo tailscale set --ssh                         # فعال کردن Tailscale SSH
sudo tailscale set --shields-up                  # رد کردن همه اتصالات ورودی
```

---

## ۶. Exit node

کل ترافیک اینترنتت از یک دستگاه دیگر رد می‌شود. دقیقاً رفتار VPN.

### الف) روی دستگاهی که می‌خواهد exit node باشد

اول باید فوروارد کردن بسته‌ها در کرنل روشن باشد:

```bash
echo 'net.ipv4.ip_forward = 1' | sudo tee /etc/sysctl.d/99-tailscale.conf
echo 'net.ipv6.conf.all.forwarding = 1' | sudo tee -a /etc/sysctl.d/99-tailscale.conf
sudo sysctl -p /etc/sysctl.d/99-tailscale.conf
```

بعد خودش را اعلام کند:

```bash
sudo tailscale set --advertise-exit-node
```

سپس در پنل ادمین باید **تأیید** شود:
`login.tailscale.com` → **Machines** → منوی سه‌نقطه دستگاه → **Edit route settings** → تیک **Use as exit node**

تا وقتی این تیک نخورد، دستگاه در لیست کلاینت‌ها ظاهر نمی‌شود.

### ب) روی کلاینت (دستگاهی که می‌خواهد وصل شود)

```bash
# دیدن لیست exit node های موجود
tailscale exit-node list

# وصل شدن
sudo tailscale set --exit-node=my-vps --exit-node-allow-lan-access

# تست اینکه واقعاً عوض شده
curl -s https://ifconfig.me

# قطع کردن
sudo tailscale set --exit-node=
```

خروجی نمونه `exit-node list`:

```
IP              HOSTNAME     COUNTRY   CITY        STATUS
100.88.12.4     my-vps       Germany   Frankfurt   -
100.71.203.9    home-pi      -         -           -
```

### چرا `--exit-node-allow-lan-access` مهم است

بدون این فلگ، وقتی exit node روشن است ترافیک شبکه محلی هم داخل تونل می‌رود — یعنی دسترسی‌ات به روتر (`192.168.1.1`)، پرینتر، NAS و سرور خانگی قطع می‌شود. با این فلگ، رنج‌های محلی مستقیم می‌مانند.

### نکته‌های تکمیلی

- تنظیم exit node بعد از ریبوت باقی می‌ماند؛ لازم نیست هر بار تکرارش کنی.
- در `tailscale status` بالای خروجی نوشته می‌شود که از کدام exit node رد می‌شوی.
- اگر exit node را روی سرور خانگی خودت بگذاری، IP خروجی همان IP اینترنت خانه‌ات می‌شود.

---

## ۷. Subnet router

با exit node فرق دارد: exit node **همه** ترافیک را می‌برد، subnet router فقط دسترسی به **یک شبکه محلی خاص** را به بقیه دستگاه‌های تیل‌نت می‌دهد.

کاربرد: می‌خواهی از بیرون به روتر و دوربین و NAS خانه‌ات دسترسی داشته باشی، بدون اینکه روی هرکدام تیل‌اسکیل نصب کنی.

### روی دستگاه داخل آن شبکه

```bash
# فوروارد کرنل (همان مرحله exit node)
echo 'net.ipv4.ip_forward = 1' | sudo tee /etc/sysctl.d/99-tailscale.conf
sudo sysctl -p /etc/sysctl.d/99-tailscale.conf

# اعلام کردن رنج شبکه
sudo tailscale set --advertise-routes=192.168.100.0/24
```

چند رنج با کاما:

```bash
sudo tailscale set --advertise-routes=192.168.100.0/24,10.0.0.0/24
```

سپس در پنل ادمین → **Edit route settings** → تیک زدن رنج‌ها.

### روی کلاینت‌ها

```bash
sudo tailscale set --accept-routes
```

بدون این فلگ، کلاینت مسیرها را نادیده می‌گیرد. (در موبایل و ویندوز معمولاً پیش‌فرض روشن است، در لینوکس خاموش.)

بعد از این می‌توانی مستقیم بزنی:

```bash
ssh user@192.168.100.217
```

حتی وقتی بیرون از خانه‌ای.

---

## ۸. Tailscale SSH

به جای مدیریت کلیدهای SSH، خود تیل‌اسکیل احراز هویت را انجام می‌دهد.

### روی سرور

```bash
sudo tailscale set --ssh
```

### از کلاینت

```bash
tailscale ssh user@vaio-server
```

نیازی به کلید، پسورد یا باز بودن پورت ۲۲ روی فایروال عمومی نیست — دسترسی با قوانین ACL تیل‌نت کنترل می‌شود.

> ⚠️ اگر SSH معمولی‌ات کار می‌کند و تنظیم شده، این را حتماً لازم نداری. فقط بدان که فعال کردنش یعنی هر کسی که ACL اجازه‌اش را دارد، بدون کلید وارد می‌شود — پس ACL را دقیق بنویس.

---

## ۹. انتقال فایل (Taildrop)

### فرستادن

```bash
tailscale file cp report.pdf vaio-server:
```

دقت کن: بعد از اسم دستگاه **دو نقطه** لازم است.

چند فایل با هم:

```bash
tailscale file cp a.txt b.txt photos.zip laptop:
```

### گرفتن فایل‌های دریافتی

```bash
tailscale file get ~/Downloads/
```

برای اینکه فایل‌ها خودکار در مسیری ذخیره شوند:

```bash
sudo tailscale set --operator=$USER
tailscale file get --wait ~/Downloads/
```

---

## ۱۰. Serve و Funnel

### Serve — انتشار سرویس فقط داخل تیل‌نت

اگر روی سرور چیزی روی پورت ۳۰۰۰ بالاست:

```bash
sudo tailscale serve --bg 3000
```

حالا از هر دستگاهی در تیل‌نت با `https://vaio-server.tailXXXX.ts.net` در دسترس است — با HTTPS معتبر و بدون هیچ تنظیم گواهی.

مسیر خاص:

```bash
sudo tailscale serve --bg --set-path=/api 8080
```

دیدن وضعیت و خاموش کردن:

```bash
tailscale serve status
sudo tailscale serve --https=443 off
```

### Funnel — انتشار روی اینترنت عمومی

```bash
sudo tailscale funnel --bg 3000
```

این یکی سرویس را برای **کل اینترنت** باز می‌کند، نه فقط تیل‌نت. قبل از استفاده مطمئن شو واقعاً همین را می‌خواهی.

```bash
tailscale funnel status
sudo tailscale funnel --https=443 off
```

---

## ۱۱. DNS و MagicDNS

MagicDNS باعث می‌شود به‌جای `100.127.222.31` بنویسی `vaio-server`.

فعال کردنش در پنل ادمین است: **DNS → Enable MagicDNS**

### روی کلاینت

```bash
sudo tailscale set --accept-dns=true    # پیش‌فرض
sudo tailscale set --accept-dns=false   # اگر تیل‌اسکیل با DNS خودت تداخل دارد
```

### وضعیت DNS

```bash
tailscale dns status
```

### تست کردن

```bash
tailscale ping vaio-server
```

اگر اسم resolve نشد ولی IP کار کرد، مشکل از MagicDNS است نه از اتصال.

---

## ۱۲. عیب‌یابی

### پینگ سطح تیل‌اسکیل

```bash
tailscale ping vaio-server
```

خروجی نمونه:

```
pong from vaio-server (100.127.222.31) via DERP(fra) in 74ms
pong from vaio-server (100.127.222.31) via 203.0.113.9:41641 in 21ms
```

خط اول یعنی از رله رد می‌شود، خط دوم یعنی اتصال مستقیم برقرار شد. معمولاً چند ثانیه طول می‌کشد تا از رله به مستقیم سوییچ کند.

این با `ping` معمولی فرق دارد: `ping` فقط ICMP می‌فرستد، `tailscale ping` مسیر واقعی تونل را نشان می‌دهد.

### بررسی وضعیت شبکه و NAT

```bash
tailscale netcheck
```

خروجی نمونه:

```
Report:
  * UDP: true
  * IPv4: yes, 203.0.113.9:41641
  * MappingVariesByDestIP: false
  * Nearest DERP: Frankfurt
  * DERP latency:
        fra: 42ms
        ams: 51ms
```

اگر `UDP: false` بود، فایروال یا ISP جلوی UDP را گرفته و همه ترافیک از رله رد می‌شود — یعنی کندی.
اگر `MappingVariesByDestIP: true` بود، NAT سختگیرانه‌ای داری و اتصال مستقیم سخت‌تر برقرار می‌شود.

### لاگ‌ها

```bash
sudo journalctl -u tailscaled -f
```

### گزارش کامل برای پشتیبانی

```bash
tailscale bugreport
```

یک شناسه چاپ می‌کند که موقع باز کردن تیکت به تیم تیل‌اسکیل می‌دهی.

### مسیرهای فعال کرنل

```bash
ip route show table 52
```

تیل‌اسکیل در لینوکس از جدول مسیریابی شماره ۵۲ استفاده می‌کند. اگر exit node فعال باشد، مسیر `0.0.0.0/0` را اینجا می‌بینی.

---

## ۱۳. مدیریت سرویس

در لینوکس، تیل‌اسکیل یک سرویس systemd به اسم `tailscaled` دارد.

```bash
sudo systemctl status tailscaled     # وضعیت
sudo systemctl restart tailscaled    # ری‌استارت
sudo systemctl enable tailscaled     # اجرا در بوت
sudo systemctl disable tailscaled    # غیرفعال کردن اجرا در بوت
```

فرق مهم:

- `tailscale down` → سرویس بالاست، فقط اتصال قطع است
- `systemctl stop tailscaled` → کل دیمن خاموش است

معمولاً همان اولی کافی است.

### اجرای دستور بدون sudo

```bash
sudo tailscale set --operator=$USER
```

بعد از این می‌توانی بیشتر دستورها را بدون `sudo` بزنی.

---

## ۱۴. جدول خلاصه

| کار | دستور |
|---|---|
| لاگین / اتصال | `sudo tailscale up` |
| قطع موقت | `sudo tailscale down` |
| خروج از حساب | `sudo tailscale logout` |
| دیدن دستگاه‌ها | `tailscale status` |
| IP خودم | `tailscale ip -4` |
| تغییر یک تنظیم | `sudo tailscale set --<flag>` |
| لیست exit node ها | `tailscale exit-node list` |
| وصل شدن به exit node | `sudo tailscale set --exit-node=NAME --exit-node-allow-lan-access` |
| قطع exit node | `sudo tailscale set --exit-node=` |
| exit node شدن | `sudo tailscale set --advertise-exit-node` |
| اعلام شبکه محلی | `sudo tailscale set --advertise-routes=192.168.100.0/24` |
| قبول مسیرهای دیگران | `sudo tailscale set --accept-routes` |
| فعال کردن SSH | `sudo tailscale set --ssh` |
| SSH زدن | `tailscale ssh user@HOST` |
| فرستادن فایل | `tailscale file cp FILE HOST:` |
| گرفتن فایل | `tailscale file get ~/Downloads/` |
| انتشار داخل تیل‌نت | `sudo tailscale serve --bg PORT` |
| انتشار روی اینترنت | `sudo tailscale funnel --bg PORT` |
| پینگ | `tailscale ping HOST` |
| بررسی NAT و UDP | `tailscale netcheck` |
| لاگ زنده | `sudo journalctl -u tailscaled -f` |
| به‌روزرسانی | `sudo tailscale update` |
| نسخه | `tailscale version` |

---

## دو اشتباه رایج

**۱. استفاده از `up` به‌جای `set` برای تغییر تنظیمات.** هر بار که `up` می‌زنی، تنظیمات قبلی پاک می‌شود. اگر لازم شد حتماً `up` بزنی، همه فلگ‌های قبلی را دوباره تکرار کن.

**۲. فراموش کردن تأیید در پنل ادمین.** برای `--advertise-exit-node` و `--advertise-routes`، خود دستور کافی نیست — تا وقتی در **Edit route settings** تیک نخورد، هیچ اتفاقی نمی‌افتد. اگر دستور را زدی و چیزی کار نکرد، اول همین را چک کن.
