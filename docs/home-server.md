# راه‌اندازی سرور خانگی روی لپ‌تاپ

> تبدیل یک لپ‌تاپ Sony Vaio به سرور شخصی با Ubuntu Server، Dokploy و Cloudflare Tunnel

---

## فهرست

1. [معماری نهایی](#معماری-نهایی)
2. [مشخصات سیستم](#مشخصات-سیستم)
3. [مرحله ۱ — نصب سیستم‌عامل](#مرحله-۱--نصب-سیستمعامل)
4. [مرحله ۲ — پیکربندی شبکه](#مرحله-۲--پیکربندی-شبکه)
5. [مرحله ۳ — تنظیمات لپ‌تاپ به‌عنوان سرور](#مرحله-۳--تنظیمات-لپتاپ-بهعنوان-سرور)
6. [مرحله ۴ — دسترسی و امن‌سازی](#مرحله-۴--دسترسی-و-امنسازی)
7. [مرحله ۵ — Docker](#مرحله-۵--docker)
8. [مرحله ۶ — Dokploy](#مرحله-۶--dokploy)
9. [مرحله ۷ — Cloudflare Tunnel](#مرحله-۷--cloudflare-tunnel)
10. [مرحله ۸ — افزودن دامنه](#مرحله-۸--افزودن-دامنه)
11. [مرحله ۹ — دیپلوی اپلیکیشن](#مرحله-۹--دیپلوی-اپلیکیشن)
12. [عیب‌یابی — مشکلات واقعی و راه‌حل‌ها](#عیبیابی--مشکلات-واقعی-و-راهحلها)
13. [نگهداری](#نگهداری)
14. [کارهای باقی‌مانده](#کارهای-باقیمانده)

---

## معماری نهایی

```
                        اینترنت
                           │
                           ▼
                   ┌───────────────┐
                   │  Cloudflare   │  ← TLS اینجا تمام می‌شود
                   │     Edge      │     آی‌پی خانه مخفی می‌ماند
                   └───────┬───────┘
                           │  تونل خروجی (HTTP/2, port 7844)
                           │  هیچ پورتی روی مودم باز نیست
                           ▼
        ┌──────────────────────────────────────┐
        │        لپ‌تاپ (vaio-server)          │
        │                                      │
        │   cloudflared ──► Traefik :80        │
        │                      │               │
        │                      ├─► App 1       │
        │                      ├─► App 2       │
        │                      └─► Database    │
        │                                      │
        │   Dokploy UI :3000 (فقط LAN/Tailscale)│
        └──────────────────────────────────────┘
```

**اصول طراحی:**

| اصل                         | پیاده‌سازی                               |
| --------------------------- | ---------------------------------------- |
| هیچ پورت ورودی باز نباشد    | Cloudflare Tunnel به‌جای port forwarding |
| آی‌پی خانه مخفی بماند       | پروکسی کلادفلر (ابر نارنجی)              |
| پنل مدیریت عمومی نباشد      | محدود به LAN و Tailscale                 |
| دسترسی از بیرون امن باشد    | Tailscale به‌جای باز کردن SSH            |
| وابسته به آی‌پی ثابت نباشیم | تونل، بدون نیاز به DDNS                  |

---

## مشخصات سیستم

| مورد              | مقدار                                        |
| ----------------- | -------------------------------------------- |
| سخت‌افزار         | Sony Vaio, Intel Core i5, 8 GB RAM, 1 TB HDD |
| سیستم‌عامل        | Ubuntu Server 26.04 LTS (codename: resolute) |
| Hostname          | `vaio-server`                                |
| شبکه              | Ethernet — `enp9s0` — `192.168.100.217/24`   |
| Docker            | 29.7.2                                       |
| Dokploy           | v0.29.14                                     |
| دسترسی از راه دور | Tailscale — `100.127.222.31`                 |

---

## مرحله ۱ — نصب سیستم‌عامل

### چرا Ubuntu Server به‌جای Linux Mint

| معیار            | Mint (دسکتاپ)                        | Ubuntu Server          |
| ---------------- | ------------------------------------ | ---------------------- |
| رم در حالت بیکار | ~۱٫۵ گیگ                             | ~۴۰۰ مگ                |
| تعداد بسته       | چند هزار                             | چند صد                 |
| مدیریت انرژی     | دسکتاپ گاهی روی `logind` سوار می‌شود | فقط `logind`           |
| پشتیبانی ابزارها | گاهی توزیع مشتق شناخته نمی‌شود       | مستقیم پشتیبانی می‌شود |

> **گزینه‌ی میانی:** اگر نمی‌خواهی نصب مجدد کنی، با `sudo systemctl set-default multi-user.target` روی Mint بمان و بوت گرافیکی را خاموش کن. حدود ۸۰٪ فایده را بدون نصب مجدد می‌گیری.

### ساخت فلش بوتیبل

```bash
# ۱. شناسایی فلش — دقت کن دیسک اشتباه را انتخاب نکنی
lsblk -o NAME,SIZE,TYPE,MODEL,LABEL

# ۲. نوشتن ISO
sudo umount /dev/sdX1 2>/dev/null
sudo dd if=~/Downloads/ubuntu-26.04-live-server-amd64.iso \
        of=/dev/sdX bs=4M status=progress oflag=sync

# ۳. تأیید — این مرحله را هرگز رد نکن
sync
lsblk -f /dev/sdX
```

**خروجی مورد انتظار مرحله ۳:**

```
sdb1  iso9660  Ubuntu-Server 26.04 amd64
sdb2  vfat     ESP
```

> ⚠️ اگر `iso9660` را ندیدی، فلش نوشته نشده. سراغ BIOS نرو — مشکل آنجا نیست.

### تنظیمات BIOS در لپ‌تاپ‌های Sony

| تنظیم                | مقدار                  | توضیح                                |
| -------------------- | ---------------------- | ------------------------------------ |
| External Device Boot | `Enabled`              | **بدون این، فلش اصلاً دیده نمی‌شود** |
| Secure Boot          | `Disabled`             |                                      |
| Boot Order           | External Device بالاتر |                                      |

ورود به BIOS: دکمه‌ی `ASSIST` (با لپ‌تاپ خاموش) یا `F2` هنگام روشن شدن.

### حین نصب

- کابل شبکه یا دانگل USB وصل باشد
- تیک **Install OpenSSH server** را بزن
- در Storage: `Use an entire disk` + LVM

---

## مرحله ۲ — پیکربندی شبکه

> در Ubuntu 26.04 دستور `dhclient` حذف شده. مدیریت شبکه فقط از طریق netplan است.

```bash
sudo tee /etc/netplan/00-installer-config.yaml > /dev/null <<'EOF'
network:
  version: 2
  ethernets:
    enp9s0:
      dhcp4: true
      optional: true
EOF

sudo chmod 600 /etc/netplan/00-installer-config.yaml
sudo netplan apply
ip -brief addr
```

**نکات:**

- تورفتگی‌ها فقط با **فاصله**، هرگز Tab
- `optional: true` باعث می‌شود بوت سیستم منتظر اینترفیس بدون کابل نماند
- `chmod 600` هشدار netplan درباره‌ی دسترسی باز فایل را حذف می‌کند

### رزرو آی‌پی در مودم

```bash
ip link show enp9s0 | grep ether
```

MAC را در پنل مودم، بخش `DHCP Static IP` (یا `Address Reservation`)، به آی‌پی مورد نظر ببند. بدون این کار، آی‌پی سرور روزی عوض می‌شود و همه‌ی تنظیمات از کار می‌افتد.

---

## مرحله ۳ — تنظیمات لپ‌تاپ به‌عنوان سرور

### جلوگیری از خوابیدن با بستن درب

```bash
sudo sed -i 's/^#*HandleLidSwitch=.*/HandleLidSwitch=ignore/; \
             s/^#*HandleLidSwitchExternalPower=.*/HandleLidSwitchExternalPower=ignore/; \
             s/^#*HandleLidSwitchDocked=.*/HandleLidSwitchDocked=ignore/' \
             /etc/systemd/logind.conf

sudo systemctl mask sleep.target suspend.target hibernate.target hybrid-sleep.target
sudo systemctl restart systemd-logind

# تأیید
grep -i lid /etc/systemd/logind.conf
```

**تست عملی:** درب را ببند، ۳۰ ثانیه صبر کن، از راه دور SSH بزن.

### آپدیت خودکار امنیتی

```bash
sudo apt install unattended-upgrades -y
cat /etc/apt/apt.conf.d/20auto-upgrades
```

باید هر دو مقدار `1` باشند:

```
APT::Periodic::Update-Package-Lists "1";
APT::Periodic::Unattended-Upgrade "1";
```

### مزیت پنهان لپ‌تاپ

باتری یک **UPS داخلی رایگان** است. با قطعی برق، سرور خاموش نمی‌شود. اگر مدل لپ‌تاپ اجازه می‌دهد، سقف شارژ را روی ۸۰٪ بگذار تا عمر باتری بیشتر شود:

```bash
cat /sys/class/power_supply/BAT0/charge_control_end_threshold
```

---

## مرحله ۴ — دسترسی و امن‌سازی

### ورود با کلید SSH

**روی کلاینت (نه سرور):**

```bash
ssh-keygen -t ed25519
ssh-copy-id user@192.168.100.217
```

**تست قبل از بستن پسورد — این مرحله حیاتی است:**

```bash
ssh -o PreferredAuthentications=publickey user@192.168.100.217
```

اگر بدون پرسیدن رمز وارد شدی، ادامه بده. اگر رمز خواست، **متوقف شو**.

### سخت‌سازی SSH

```bash
sudo tee /etc/ssh/sshd_config.d/99-hardening.conf > /dev/null <<'EOF'
PasswordAuthentication no
PermitRootLogin no
KbdInteractiveAuthentication no
EOF

sudo sshd -t && sudo systemctl restart ssh
```

> `sshd -t` تنظیمات را قبل از اعمال بررسی می‌کند. اگر خطایی باشد، سرویس ریستارت نمی‌شود و ارتباط فعلی سالم می‌ماند.

### فایروال

**ترتیب اهمیت دارد** — قانون SSH باید قبل از فعال کردن اضافه شود:

```bash
sudo ufw allow 22/tcp
sudo ufw allow in on tailscale0
sudo ufw allow from 192.168.100.0/24 to any port 3000 proto tcp
sudo ufw enable
sudo ufw status verbose
```

**وضعیت نهایی:** پورت‌های ۸۰ و ۴۴۳ **لازم نیستند** — تمام ترافیک وب از تونل و از `localhost` می‌آید، نه از اینترنت.

```bash
sudo ufw delete allow 80/tcp
sudo ufw delete allow 443/tcp
```

### fail2ban

```bash
sudo apt install fail2ban -y
sudo systemctl enable --now fail2ban
sudo fail2ban-client status sshd
```

### Tailscale — دسترسی از بیرون خانه

```bash
curl -fsSL https://tailscale.com/install.sh | sh
sudo tailscale up
```

لینک چاپ‌شده را روی هر دستگاه دیگری باز کن و لاگین کن. سرور نیازی به مرورگر ندارد.

```bash
tailscale ip -4       # آی‌پی 100.x.y.z
tailscale status      # وضعیت اتصال — direct یا relay
```

**دو مسیر دسترسی:**

| مسیر        | آدرس              | کاربرد                  |
| ----------- | ----------------- | ----------------------- |
| شبکه‌ی محلی | `192.168.100.217` | در خانه — سریع و مستقیم |
| Tailscale   | `100.127.222.31`  | بیرون از خانه           |

> اگر `tailscale status` عبارت `relay` نشان دهد، ترافیک از سرور واسط کلادفلر عبور می‌کند و تأخیر بالا می‌رود (۲۰۰+ میلی‌ثانیه). با اتصال کابلی معمولاً `direct` می‌شود.

---

## مرحله ۵ — Docker

> **مهم:** اسکریپت نصب Dokploy نسخه‌ی مشخصی از داکر را درخواست می‌کند که برای Ubuntu 26.04 موجود نیست. پس داکر را **دستی و قبل از Dokploy** نصب می‌کنیم.

```bash
sudo apt install ca-certificates curl -y
sudo install -m 0755 -d /etc/apt/keyrings
sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg \
     -o /etc/apt/keyrings/docker.asc
sudo chmod a+r /etc/apt/keyrings/docker.asc

echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] \
https://download.docker.com/linux/ubuntu $(. /etc/os-release && echo "$VERSION_CODENAME") stable" \
| sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

sudo apt update
sudo apt install docker-ce docker-ce-cli containerd.io \
                 docker-buildx-plugin docker-compose-plugin -y

sudo docker run hello-world
```

### آینه‌ی رجیستری

اگر کشیدن ایمیج‌ها کند یا ناموفق بود:

```bash
sudo tee /etc/docker/daemon.json > /dev/null <<'EOF'
{
  "registry-mirrors": ["https://docker.arvancloud.ir"]
}
EOF
sudo systemctl restart docker
```

---

## مرحله ۶ — Dokploy

```bash
curl -sSL https://dokploy.com/install.sh | sudo ADVERTISE_ADDR=192.168.100.217 sh
```

**دو نکته‌ی حیاتی:**

1. متغیر `ADVERTISE_ADDR` باید **داخل خود دستور** به `sudo` داده شود. `export` جداگانه کار نمی‌کند چون `sudo` محیط را ریست می‌کند.
2. **هرگز وسط نصب `Ctrl+C` نزن.** نصب ناقص، Traefik را از قلم می‌اندازد و اسکریپت هم دیگر اجازه‌ی اجرای مجدد نمی‌دهد (چون پورت ۳۰۰۰ اشغال است).

**تأیید — باید هر سه را ببینی:**

```bash
sudo docker ps --format "table {{.Names}}\t{{.Status}}"
```

```
dokploy-traefik
dokploy.1.xxxxx
dokploy-postgres.1.xxxxx
```

سپس:

```
http://192.168.100.217:3000
```

- رمز قوی
- **2FA را همان لحظه فعال کن**

### ساختار Dokploy

```
Organization        ← فضای کاری ایزوله (برای یک نفر: فقط یکی)
  └── Project       ← گروه‌بندی منطقی — واحد اصلی کنترل دسترسی
        └── Environment    ← production / staging
              └── Service  ← Application | Database | Compose
```

> **Organization دوم نساز** مگر اینکه برای مشتری کار کنی. هر سازمان اتصال گیت‌هاب، مقصد بکاپ و کلیدهای جداگانه می‌خواهد.

---

## مرحله ۷ — Cloudflare Tunnel

### نصب و ساخت تونل

```bash
curl -L https://github.com/cloudflare/cloudflared/releases/latest/download/cloudflared-linux-amd64.deb \
     -o /tmp/cf.deb
sudo dpkg -i /tmp/cf.deb

sudo cloudflared tunnel login      # لینک را روی کلاینت باز کن
sudo cloudflared tunnel create home
sudo ls /root/.cloudflared/        # UUID را بردار
```

> با `sudo` لاگین کن تا اعتبارنامه در `/root/.cloudflared/` بیفتد و سرویس سیستمی بتواند پیدایش کند.

### فایل تنظیمات

```yaml
# /etc/cloudflared/config.yml
tunnel: home
credentials-file: /root/.cloudflared/<TUNNEL-UUID>.json
protocol: http2

ingress:
  - hostname: example.com
    service: http://localhost:80
  - hostname: "*.example.com"
    service: http://localhost:80
  - service: http_status:404
```

**`protocol: http2` چرا لازم است:**

`cloudflared` به‌طور پیش‌فرض از QUIC روی UDP پورت ۷۸۴۴ استفاده می‌کند. اگر شبکه UDP را عبور ندهد، سرویس با تایم‌اوت شکست می‌خورد و مدام ریستارت می‌شود. تشخیصش در لاگ:

```
UDP Connectivity   QUIC connection failed
TCP Connectivity   HTTP/2 connection successful
SUMMARY: Environment ready with degraded transport.
```

> ⚠️ خط `http_status:404` باید **همیشه آخرین** مورد باشد. هر چیزی بعد از آن نادیده گرفته می‌شود.

### اجرا به‌عنوان سرویس

```bash
sudo cloudflared service install
sudo systemctl enable --now cloudflared
sudo systemctl status cloudflared --no-pager
```

### تنظیمات سمت کلادفلر

| تنظیم                    | مقدار            | دلیل                                                                              |
| ------------------------ | ---------------- | --------------------------------------------------------------------------------- |
| SSL/TLS mode             | `Full`           | `Flexible` حلقه‌ی ریدایرکت می‌سازد؛ `Full (strict)` گواهی معتبر روی مبدأ می‌خواهد |
| Proxy status             | Proxied (نارنجی) | رکوردهای `cfargotunnel.com` بدون پروکسی کار نمی‌کنند                              |
| Let's Encrypt در Dokploy | **خاموش**        | TLS را کلادفلر تمام می‌کند؛ چالش HTTP-01 شکست می‌خورد                             |

---

## مرحله ۸ — افزودن دامنه

### دامنه‌ی جدید (زون جدید)

**۱.** دامنه را در کلادفلر اضافه کن → نیم‌سرورها را در پنل ثبت‌کننده عوض کن → صبر تا `Active`

**۲.** رکوردها را **دستی در پنل کلادفلر** بساز:

| Type  | Name | Target                           | Proxy   |
| ----- | ---- | -------------------------------- | ------- |
| CNAME | `@`  | `<TUNNEL-UUID>.cfargotunnel.com` | Proxied |
| CNAME | `*`  | `<TUNNEL-UUID>.cfargotunnel.com` | Proxied |

> ⚠️ دستور `cloudflared tunnel route dns` برای دامنه‌های خارج از زونی که موقع `login` انتخاب کرده‌ای **کار نمی‌کند**. فایل `cert.pem` فقط برای همان زون مجوز دارد و اسم جدید را به‌عنوان ساب‌دامین آن در نظر می‌گیرد. نتیجه: رکوردهایی مثل `example.ir.original-zone.com` ساخته می‌شود که بی‌مصرف‌اند.

**۳.** دامنه را به `ingress` در `config.yml` اضافه کن و سرویس را ریستارت کن.

**۴.** `SSL/TLS` را برای زون جدید هم روی `Full` بگذار — این تنظیم برای هر دامنه جداگانه است.

### ساب‌دامین دامنه‌ی موجود

اگر `*.example.com` را از قبل داری، **هیچ کاری روی سرور لازم نیست**. فقط در Dokploy تب `Domains` اپ، ساب‌دامین را اضافه کن.

### یک اپ روی چند دامنه

در تب `Domains` اپلیکیشن، هر دامنه را جداگانه `Add Domain` کن. همه به یک کانتینر اشاره می‌کنند و Traefik بر اساس نام دامنه‌ی درخواست مسیریابی می‌کند. دیپلوی دوم لازم نیست.

---

## مرحله ۹ — دیپلوی اپلیکیشن

### اتصال گیت‌هاب

`Settings` → `Git` → `GitHub` → `Create GitHub App`

مزیت نسبت به URL ساده: دیپلوی خودکار با هر push.

### ساخت اپلیکیشن

`Projects` → `Create Project` → `Create Service` → `Application`

**تب General:**

| فیلد                | مقدار                                |
| ------------------- | ------------------------------------ |
| Source              | GitHub → ریپو → برنچ                 |
| Build Type          | `Dockerfile` یا `Nixpacks`           |
| Docker File         | `Dockerfile` (نام دقیق فایل در ریپو) |
| Docker Context Path | `.`                                  |

> اگر خطای `failed to read dockerfile: open <x>: no such file or directory` گرفتی، مقدار فیلد `Docker File` اشتباه است. لینوکس به بزرگی و کوچکی حروف حساس است.

**تب Domains:**

| فیلد           | مقدار                            |
| -------------- | -------------------------------- |
| Host           | دامنه                            |
| Path           | `/`                              |
| Container Port | پورتی که کانتینر `EXPOSE` می‌کند |
| HTTPS          | **خاموش**                        |

**تعیین Container Port:**

| نوع پروژه                                    | پورت   |
| -------------------------------------------- | ------ |
| استاتیک سرو شده با nginx (Astro، Vite، Hugo) | `80`   |
| Next.js / Nuxt / Node                        | `3000` |

### نمونه Dockerfile چندمرحله‌ای

```dockerfile
# ───────── build ─────────
FROM node:22-alpine AS build
WORKDIR /app
RUN corepack enable
COPY package.json pnpm-lock.yaml ./
RUN pnpm install --frozen-lockfile
COPY . .
RUN pnpm build

# ───────── serve ─────────
FROM nginx:1.27-alpine AS runtime
COPY nginx.conf /etc/nginx/conf.d/default.conf
COPY --from=build /app/dist /usr/share/nginx/html
EXPOSE 80
HEALTHCHECK --interval=30s --timeout=3s --start-period=5s \
  CMD wget -qO- http://127.0.0.1/ >/dev/null || exit 1
CMD ["nginx", "-g", "daemon off;"]
```

بیلد چندمرحله‌ای باعث می‌شود ایمیج نهایی فقط nginx و فایل‌های استاتیک را داشته باشد — بدون Node و `node_modules`. روی سخت‌افزار محدود تفاوت واقعی ایجاد می‌کند.

---

## عیب‌یابی — مشکلات واقعی و راه‌حل‌ها

### فلش بوت نمی‌شود

**تشخیص:**

```bash
lsblk -f /dev/sdX
```

اگر `FSTYPE` خالی باشد، چیزی نوشته نشده — حتی اگر `dd` موفقیت گزارش کرده باشد.

**تست قطعی سلامت فلش:**

```bash
sudo dd if=/dev/urandom of=/tmp/t.bin bs=1M count=16
sudo dd if=/tmp/t.bin of=/dev/sdX bs=1M oflag=direct
sudo blockdev --flushbufs /dev/sdX
sudo dd if=/dev/sdX of=/tmp/b.bin bs=1M count=16 iflag=direct
cmp /tmp/t.bin /tmp/b.bin
```

خروجی `differ` یعنی فلش نوشتن را گزارش می‌کند ولی ذخیره نمی‌کند — فلش خراب یا تقلبی است. عوضش کن.

> **درس کلی:** هرگز به «موفقیت‌آمیز بود» اعتماد نکن. همیشه تأیید مستقل بگیر. همین اصل برای بکاپ دیتابیس هم صدق می‌کند.

### قطعی مکرر وای‌فای

**تشخیص:**

```bash
sudo dmesg | grep -iE 'wlan|firmware|ath|iwlwifi' | tail -40
```

| الگو در لاگ                                | معنی                 | راه‌حل           |
| ------------------------------------------ | -------------------- | ---------------- |
| `deauthenticating ... by local choice`     | خود سیستم قطع می‌کند | power management |
| `Unable to reset channel, reset status -5` | **خطای سخت‌افزاری**  | تعویض کارت       |
| `firmware crash` / `failed to load`        | مشکل درایور          | نصب فرم‌ور       |

**رفع power management:**

```bash
sudo tee /etc/NetworkManager/conf.d/wifi-powersave.conf > /dev/null <<'EOF'
[connection]
wifi.powersave = 2
EOF
```

> برای یک سرور، **کابل شبکه همیشه پاسخ درست است** — حتی اگر وای‌فای سالم باشد.

### Dokploy: خطای احراز هویت دیتابیس

```
PostgresError: password authentication failed for user "dokploy"
```

**علت:** والیوم داکر مستقل از کانتینر باقی می‌ماند. نصب مجدد رمز جدید می‌سازد، اما Postgres رمز را فقط بار اول (روی پوشه‌ی خالی) تنظیم می‌کند.

**راه‌حل — پاکسازی کامل:**

```bash
sudo docker service rm dokploy dokploy-postgres
sudo docker rm -f $(sudo docker ps -aq) 2>/dev/null
sudo docker swarm leave --force
sudo docker volume ls          # اول ببین چه چیزی هست
sudo docker volume prune -a -f
sudo rm -rf /etc/dokploy
```

> ⚠️ `volume prune -a` همه‌ی والیوم‌های بلااستفاده را پاک می‌کند. **وقتی دیتابیس پروژه‌های واقعی روی سرور است، هرگز کورکورانه نزن.**

### cloudflared بالا نمی‌آید

```bash
sudo systemctl stop cloudflared
sudo cloudflared --config /etc/cloudflared/config.yml tunnel run
```

| خطا                                                | علت                                    | راه‌حل              |
| -------------------------------------------------- | -------------------------------------- | ------------------- |
| `Cannot determine default origin certificate path` | مسیر UUID در `config.yml` جایگزین نشده | UUID واقعی را بگذار |
| `Failed to dial a quic connection`                 | UDP مسدود است                          | `protocol: http2`   |
| `failed to resolve reference`                      | دسترسی به رجیستری                      | آینه‌ی رجیستری      |

### خطاهای DNS

| خطا         | معنی                       | بررسی                       |
| ----------- | -------------------------- | --------------------------- |
| `NXDOMAIN`  | دامنه وجود ندارد           | ثبت دامنه                   |
| `ENODATA`   | دامنه هست، رکورد `A` ندارد | رکورد CNAME تونل ساخته نشده |
| `ESERVFAIL` | سرور DNS شکست خورد         | DNSSEC یا کش منفی           |

**تست DNSSEC:**

```bash
dig example.com @1.1.1.1 +short          # بدون جواب؟
dig example.com @1.1.1.1 +cd +short      # با جواب؟  → مشکل DNSSEC
dig +short DS example.com @1.1.1.1       # رکورد DS باقی‌مانده
```

اگر رکورد `DS` قدیمی در ثبت‌کننده مانده باشد، اعتبارسنجی شکست می‌خورد. یا حذفش کن، یا DNSSEC را در کلادفلر فعال کن و `DS` جدید را جایگزین کن.

**پاک کردن کش DNS در macOS:**

```bash
sudo dscacheutil -flushcache; sudo killall -HUP mDNSResponder
```

**تست مستقیم از نیم‌سرور، بدون واسطه:**

```bash
dig example.com @<name>.ns.cloudflare.com +short
```

### برچسب `Invalid` روی دامنه در Dokploy

**این خطا نیست.** Dokploy رکورد `A` دامنه را با آی‌پی عمومی سرور مقایسه می‌کند. پشت تونل، دامنه به آی‌پی کلادفلر اشاره می‌کند، نه به سرور. پس این برچسب همیشه قرمز می‌ماند.

معیار واقعی: بالا آمدن سایت در مرورگر.

---

## نگهداری

### چک‌لیست ماهانه

```bash
sudo apt update && sudo apt upgrade -y
sudo docker system prune -f          # ایمیج‌های بلااستفاده — بدون -a و بدون --volumes
df -h                                 # فضای دیسک
sensors                               # دمای لپ‌تاپ
sudo fail2ban-client status sshd     # تلاش‌های ورود
```

### بکاپ

در Dokploy: `Settings` → `S3 Destinations` → افزودن مقصد. سپس در هر **دیتابیس**، تب `Backups` ظاهر می‌شود.

> تب `Backups` تا وقتی دیتابیسی نساخته باشی دیده نمی‌شود — بکاپ به دیتابیس تعلق دارد، نه به کل سرور.

**⚠️ محدودیت مهم:** بکاپ Dokploy فقط دیتابیس‌ها را می‌گیرد، نه تنظیمات خود Dokploy را. برای بازیابی کامل، تعریف پروژه‌ها را به شکل کد (Docker Compose در گیت) نگه دار.

### دستورهای پرکاربرد

```bash
# وضعیت سرویس‌ها
sudo docker ps --format "table {{.Names}}\t{{.Status}}"
sudo docker service ls

# لاگ‌ها
sudo docker service logs dokploy --tail 50
sudo journalctl -u cloudflared -n 50 --no-pager

# شبکه
ip -brief addr
tailscale status
sudo ufw status verbose

# تست زنجیره
curl -I http://localhost              # Traefik زنده است؟ (404 = بله)
curl -I https://example.com           # کل مسیر
```

---

## کارهای باقی‌مانده

- [ ] راه‌اندازی بکاپ S3 قبل از آوردن پروژه‌ی واقعی
- [ ] تعویض کارت وای‌فای معیوب با دانگل USB
- [ ] بررسی ACL در Tailscale اگر tailnet مشترک است
- [ ] نگه‌داری تعریف پروژه‌ها به‌شکل Docker Compose در گیت
- [ ] تنظیم Cloudflare Access اگر روزی پنل Dokploy عمومی شد

---

## منابع

- [Dokploy Docs](https://docs.dokploy.com)
- [Dokploy Multi-Tenancy](https://docs.dokploy.com/docs/core/multi-tenancy)
- [Cloudflare Tunnel Docs](https://developers.cloudflare.com/cloudflare-one/connections/connect-networks/)
- [Tailscale Docs](https://tailscale.com/kb)
