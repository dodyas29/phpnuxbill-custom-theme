# PRD: Custom Theme PHPNuxBill — License System

## Overview

A license management system for the custom PHPNuxBill theme (`ui/ui_custom/`) that:
1. Encrypts all PHP files using **ionCube Encoder** — source code is unreadable
2. Validates licenses via a **remote API server** — no valid license = no functionality
3. Serves CSS/JS through **PHP proxy files** — assets protected behind license validation
4. Provides an **admin plugin** for PHPNuxBill to manage licenses, customers, and activations

**Goal**: Theme files cannot be used without a valid, purchased license key.

---

## Architecture

```
┌──────────────────────────────────────────────────────────┐
│                    License Server                          │
│  Ubuntu 22.04 + aaPanel + Nginx + MySQL + PHP 8.2        │
│  Domain: lisensi.domain-anda.com                          │
│                                                            │
│  /api/v1/                                                  │
│    validate        (POST) — validate license key          │
│    heartbeat       (POST) — extend activation token       │
│                                                            │
│  Database: license_db                                      │
│    licenses        — license keys + status                │
│    customers       — buyer data                           │
│    activations     — domain binding + token               │
│    audit_log       — activity log                         │
└──────────────────────────────────────────────────────────┘
          ▲                         ▲
          │ HTTPS                   │ HTTPS
          ▼                         ▼
┌─────────────────────┐  ┌─────────────────────────────────┐
│  Theme (Customer     │  │  PHPNuxBill Admin                │
│   Server)            │  │  (Your Server)                   │
│                      │  │                                  │
│  license.php         │  │  Plugin: theme_license           │
│  c.php (CSS proxy)   │  │  ├── License CRUD                │
│  j.php (JS proxy)    │  │  ├── Customer CRUD               │
│                      │  │  ├── Activation log              │
│                      │  │  └── Revoke / Suspend            │
└─────────────────────┘  └─────────────────────────────────┘
```

---

## 1. Database Schema

### Table: `licenses`

| Column | Type | Description |
|---|---|---|
| `id` | INT PK AI | Primary key |
| `license_key` | VARCHAR(64) UNIQUE | Generated key (e.g., `PNB-THEME-XXXX-XXXX-XXXX`) |
| `customer_id` | INT FK → customers | Buyer reference |
| `product_type` | ENUM | `theme_basic`, `theme_pro`, `theme_ultimate` |
| `max_domains` | INT | Max allowed domain activations (default 1) |
| `status` | ENUM | `active`, `suspended`, `expired`, `revoked` |
| `issued_at` | DATETIME | Issuance date |
| `expires_at` | DATETIME NULL | Expiry (NULL = lifetime) |
| `created_at` | DATETIME | Record creation |
| `updated_at` | DATETIME | Last update |

### Table: `customers`

| Column | Type | Description |
|---|---|---|
| `id` | INT PK AI | Primary key |
| `name` | VARCHAR(255) | Customer name |
| `email` | VARCHAR(255) | Contact email |
| `phone` | VARCHAR(20) | Contact phone |
| `company` | VARCHAR(255) | Company/ISP name |
| `notes` | TEXT | Admin notes |
| `created_at` | DATETIME | Record creation |

### Table: `activations`

| Column | Type | Description |
|---|---|---|
| `id` | INT PK AI | Primary key |
| `license_id` | INT FK → licenses | License reference |
| `domain` | VARCHAR(255) | Activated domain |
| `server_ip` | VARCHAR(45) | Server IP |
| `token` | VARCHAR(128) | JWT token (7-day expiry) |
| `token_expires` | DATETIME | Token expiry timestamp |
| `last_heartbeat` | DATETIME | Last heartbeat time |
| `status` | ENUM | `active`, `inactive` |
| `created_at` | DATETIME | Activation date |

### Table: `audit_log`

| Column | Type | Description |
|---|---|---|
| `id` | INT PK AI | Primary key |
| `license_id` | INT FK → licenses | License reference |
| `action` | VARCHAR(50) | `validate`, `heartbeat`, `activate`, `revoke` |
| `domain` | VARCHAR(255) | Requesting domain |
| `ip_address` | VARCHAR(45) | Requesting IP |
| `details` | TEXT | JSON payload (for debugging) |
| `created_at` | DATETIME | Event timestamp |

---

## 2. API Endpoints

All endpoints accept and return JSON over HTTPS.

### 2.1 `POST /api/v1/validate`

**Purpose**: Validate a license key and domain binding on activation or re-check.

**Request:**

```json
{
    "license_key": "PNB-THEME-A1B2-C3D4-E5F6",
    "domain": "isp-customer.com",
    "server_ip": "192.168.1.100"
}
```

**Response — Success:**

```json
{
    "success": true,
    "token": "eyJhbGciOiJIUzI1NiJ9...",
    "expires_in": 604800,
    "product": "theme_pro",
    "message": "License valid"
}
```

**Response — Failure:**

```json
{
    "success": false,
    "error": "LICENSE_EXPIRED",
    "message": "License has expired. Please renew."
}
```

**Logic:**
1. Lookup `license_key` in `licenses` table
2. Check status (only `active` is valid)
3. Check `expires_at` — if set and past → mark expired
4. Check domain:
   - No prior activation → auto-bind domain (first activation)
   - Existing activation → check domain match
   - `max_domains` reached → reject
5. Generate JWT token (HMAC-SHA256, 7-day expiry)
6. Upsert `activations` record
7. Log to `audit_log`
8. Return token

### 2.2 `POST /api/v1/heartbeat`

**Purpose**: Extend token validity every 7 days (auto-called by theme).

**Request:**

```json
{
    "license_key": "PNB-THEME-A1B2-C3D4-E5F6",
    "domain": "isp-customer.com",
    "token": "eyJhbGciOiJIUzI1NiJ9..."
}
```

**Response:**

```json
{
    "success": true,
    "token": "eyJhbGciOiJIUzI1NiJ9...",
    "expires_in": 604800,
    "message": "Token refreshed"
}
```

**Logic:**
1. Validasi JWT (signature + expiry)
2. Update `last_heartbeat` and `token` in `activations`
3. Generate new token (extend 7 days)
4. Return

### Error Codes

| Code | Message |
|---|---|
| `LICENSE_NOT_FOUND` | License key does not exist |
| `LICENSE_SUSPENDED` | License suspended |
| `LICENSE_EXPIRED` | License has expired |
| `LICENSE_REVOKED` | License revoked |
| `DOMAIN_MISMATCH` | Domain not bound to this license |
| `MAX_DOMAINS` | Max domain activations reached |
| `INVALID_TOKEN` | JWT token invalid or expired |
| `RATE_LIMITED` | Too many requests |

---

## 3. PHPNuxBill Plugin: License Manager

### 3.1 File Structure

```
system/plugin/
├── theme_license.php               ← Main plugin file
└── ui/
    ├── theme_license_list.tpl      ← License table with actions
    ├── theme_license_add.tpl       ← Add license form
    ├── theme_license_edit.tpl      ← Edit license + customer
    └── theme_license_view.tpl      ← Detail view: activations + logs
```

### 3.2 Menu Registration

```php
register_menu(
    "Theme License",           // Display name
    true,                      // Admin menu
    "theme_license_list",      // Function name / route
    'SETTINGS',                // Position
    'ion-key',                 // Icon
    '', '', '',
    ['SuperAdmin']             // Only SuperAdmin
);
```

### 3.3 Functions

| Function | Route | Description |
|---|---|---|
| `theme_license_list()` | `plugin/theme_license_list` | Table of all licenses with status badges and actions |
| `theme_license_add()` | `plugin/theme_license_add` | Form: select customer, product type, max domains, expiry |
| `theme_license_edit()` | `plugin/theme_license_edit&id=X` | Edit license + customer details |
| `theme_license_view()` | `plugin/theme_license_view&id=X` | Detail: activations table, audit log table |
| `theme_license_revoke()` | `plugin/theme_license_revoke&id=X` | Set status = revoked, deactivate all domains |
| `theme_license_suspend()` | `plugin/theme_license_suspend&id=X` | Set status = suspended |
| `theme_license_reactivate()` | `plugin/theme_license_reactivate&id=X` | Set status = active |

### 3.4 UI Pages

#### License List

| Column | Data | Format |
|---|---|---|
| Key | `license_key` | Masked: `PNB-XXXX-...-XXXX` |
| Customer | `customers.name` | Text + link to edit |
| Product | `product_type` | Badge label |
| Status | `status` | Badge: green=active, orange=suspended, red=expired/revoked |
| Domain | First `activations.domain` | Text |
| Expires | `expires_at` | Date or "Lifetime" badge |
| Actions | — | View, Edit, Revoke, Suspend |

#### Add / Edit License

Form fields: Customer (dropdown or new), Product Type (dropdown), Max Domains (number), Expiry Date (date picker, optional). License key auto-generated: `PNB-` + random string.

#### View License (Detail)

Three sections:
1. License info card (key, customer, status, product, expiry)
2. Activations table (domain, IP, last heartbeat, token expiry, status)
3. Audit log table (action, domain, IP, timestamp)

---

## 4. Client-Side License Module

### 4.1 Files

```
ui/ui_custom/customer/
├── license.php      ← Core: _license_check(), _license_call()
├── c.php            ← CSS proxy (checks license, serves style.css)
└── j.php            ← JS proxy (checks license, serves script.js)
```

### 4.2 `license.php` Core Logic

```php
<?php
define('LICENSE_KEY', 'PNB-THEME-XXXX-XXXX-XXXX');
define('LICENSE_API', 'https://lisensi.domain-anda.com/api/v1');

function _license_check() {
    $cache = __DIR__ . '/../license.cache';

    // Check cache (valid < 7 days)
    if (file_exists($cache)) {
        $data = json_decode(file_get_contents($cache), true);
        if ($data['expires'] > time()) return $data;
    }

    // Heartbeat with existing token
    $token = $data['token'] ?? '';
    $result = _license_call('heartbeat', [
        'license_key' => LICENSE_KEY,
        'domain' => $_SERVER['HTTP_HOST'],
        'token' => $token
    ]);

    if ($result['success']) {
        _license_cache($result);
        return $result;
    }

    // Full validate (first time or expired token)
    $result = _license_call('validate', [
        'license_key' => LICENSE_KEY,
        'domain' => $_SERVER['HTTP_HOST'],
        'server_ip' => $_SERVER['SERVER_ADDR'] ?? ''
    ]);

    if ($result['success']) {
        _license_cache($result);
        return $result;
    }

    return false;
}

function _license_cache($data) {
    file_put_contents(__DIR__ . '/../license.cache', json_encode([
        'token' => $data['token'],
        'expires' => time() + $data['expires_in']
    ]));
}

function _license_call($endpoint, $data) {
    return json_decode(Http::postJsonData(
        LICENSE_API . '/' . $endpoint,
        $data
    ), true);
}
```

### 4.3 CSS/JS Proxy

```php
// c.php — CSS Proxy
require_once __DIR__ . '/license.php';
if (!_license_check()) {
    http_response_code(403);
    die('/* License inactive */');
}
header('Content-Type: text/css; charset=utf-8');
header('Cache-Control: public, max-age=86400');
readfile(__DIR__ . '/assets/css/style.css');
```

```php
// j.php — JS Proxy
require_once __DIR__ . '/license.php';
if (!_license_check()) {
    http_response_code(403);
    die('// License inactive');
}
header('Content-Type: application/javascript; charset=utf-8');
header('Cache-Control: public, max-age=86400');
readfile(__DIR__ . '/assets/js/script.js');
```

### 4.4 Template Changes

**`_head_common.tpl` — Before:**

```smarty
<link rel="stylesheet" href="{$app_url}/ui/ui_custom/customer/assets/css/style.css?v=21">
```

**`_head_common.tpl` — After:**

```smarty
<link rel="stylesheet" href="{$app_url}/ui/ui_custom/customer/c.php">
```

**`_scripts_common.tpl` — Before:**

```smarty
<script src="{$app_url}/ui/ui_custom/customer/assets/js/script.js"></script>
```

**`_scripts_common.tpl` — After:**

```smarty
<script src="{$app_url}/ui/ui_custom/customer/j.php"></script>
```

**Plugin templates (postpaid.tpl, postpaid_verify.tpl)** — same change.

---

## 5. Server Setup (Ubuntu 22.04 + aaPanel)

### 5.1 Initial Setup

```bash
# Install aaPanel
wget -O install.sh http://www.aapanel.com/script/install-ubuntu_6.0_en.sh
bash install.sh

# Login to aaPanel → Install via panel:
# - Nginx 1.24
# - MySQL 8.0
# - PHP 8.2 (ensure ionCube loader is checked)
```

### 5.2 Domain + SSL

- Add domain `lisensi.domain-anda.com` via aaPanel website manager
- Enable SSL → Let's Encrypt auto-renew

### 5.3 Nginx Config

```nginx
server {
    listen 80;
    server_name lisensi.domain-anda.com;
    return 301 https://$server_name$request_uri;
}

server {
    listen 443 ssl http2;
    server_name lisensi.domain-anda.com;

    root /www/wwwroot/lisensi/public;
    index index.php;

    # API rate limiting
    limit_req_zone $binary_remote_addr zone=lic_api:10m rate=10r/s;

    location /api/ {
        limit_req zone=lic_api burst=20 nodelay;
        try_files $uri /api/index.php?$query_string;
    }

    location / {
        try_files $uri $uri/ =404;
    }

    location ~ \.php$ {
        fastcgi_pass unix:/tmp/php-cgi-82.sock;
        fastcgi_index index.php;
        fastcgi_param SCRIPT_FILENAME $document_root$fastcgi_script_name;
        include fastcgi_params;
    }

    ssl_certificate /www/server/panel/vhost/cert/lisensi.domain-anda.com/fullchain.pem;
    ssl_certificate_key /www/server/panel/vhost/cert/lisensi.domain-anda.com/privkey.pem;
}
```

### 5.4 PHP `config.php`

```php
<?php
define('JWT_SECRET', 'your-256-bit-secret-key-here-keep-it-safe');
define('DB_PATH', __DIR__ . '/../db/licenses.db');

// Database (SQLite or MySQL)
$db = new PDO('sqlite:' . DB_PATH);
$db->setAttribute(PDO::ATTR_ERRMODE, PDO::ERRMODE_EXCEPTION);
```

### 5.5 Migration

Create all 4 tables on first run via migration script or manual SQL.

---

## 6. Security

| Layer | Implementation |
|---|---|
| **Transport** | HTTPS via Let's Encrypt (auto-renew) |
| **Rate Limiting** | Nginx `limit_req`: 10 req/sec, burst 20 |
| **JWT** | HMAC-SHA256, 256-bit secret, 7-day expiry |
| **License Keys** | Random 64-char alphanumeric, unique |
| **SQL Injection** | PDO prepared statements |
| **PHP Source Code** | Encoded with ionCube Encoder |
| **Firewall** | aaPanel system firewall (ports 80, 443 only) |
| **Backup** | aaPanel scheduled database backup to remote storage |

---

## 7. File Inventory

### Files to ENCODE (ionCube)

| # | File | Location |
|---|---|---|
| 1 | `plan.php` | `ui/ui_custom/customer/api/` |
| 2 | `device.php` | `ui/ui_custom/customer/api/` |
| 3 | `packages.php` | `ui/ui_custom/customer/api/` |
| 4 | `tripay_channels.php` | `ui/ui_custom/customer/api/` |
| 5 | `routers_coverage.php` | `ui/ui_custom/customer/api/` |
| 6 | `check_username.php` | `ui/ui_custom/customer/api/` |
| 7 | `save_guest_coords.php` | `ui/ui_custom/customer/api/` |
| 8 | `send_otp.php` | `ui/ui_custom/customer/api/` |
| 9 | `verify_otp.php` | `ui/ui_custom/customer/api/` |
| 10 | `hold_registration_data.php` | `ui/ui_custom/customer/api/` |
| 11 | `recharge_redirect.php` | `ui/ui_custom/customer/api/` |
| 12 | `voucher_payment.php` | `ui/ui_custom/customer/api/` |
| 13 | `cancel_transaction.php` | `ui/ui_custom/customer/api/` |
| 14 | `change_password.php` | `ui/ui_custom/customer/api/` |
| 15 | `destroy_session.php` | `ui/ui_custom/customer/api/` |
| 16 | `order_history.php` | `ui/ui_custom/customer/api/` |
| 17 | `seed_plans.php` | `ui/ui_custom/customer/api/` |
| 18 | `seed_balance.php` | `ui/ui_custom/customer/api/` |
| 19 | `balance_payment.php` | `ui/ui_custom/customer/api/` |
| 20 | `package_payment.php` | `ui/ui_custom/customer/api/` |
| 21 | `postpaid_payment.php` | `ui/ui_custom/customer/api/` |
| 22 | `postpaid_verify.php` | `ui/ui_custom/customer/api/` |
| 23 | `postpaid_upgrade.php` | `ui/ui_custom/customer/api/` |
| 24 | `license.php` | `ui/ui_custom/customer/` |
| 25 | `c.php` | `ui/ui_custom/customer/` |
| 26 | `j.php` | `ui/ui_custom/customer/` |
| 27 | `postpaid.php` | `system/plugin/` |

### Files NOT encoded (plain text)

| Type | Examples | Reason |
|---|---|---|
| `.tpl` (Smarty templates) | `dashboard.tpl`, `postpaid.tpl`, etc. | Parsed by Smarty engine |
| `.css` (stylesheets) | `style.css`, `login.css`, `register.css` | Read by browser |
| `.js` (JavaScript) | `script.js`, `profile.js` | Read by browser |
| Image assets | `assets/logo/*.png` | Static files |
| `.md` / `.txt` | Documentation | Not functional |

---

## 8. Implementation Plan

### Phase 1 — License Server (Day 1-2)

- [ ] Setup Ubuntu 22.04 + aaPanel + Nginx + MySQL + PHP 8.2
- [ ] Create database schema (4 tables)
- [ ] Create API directory + index.php router
- [ ] Implement `/api/v1/validate`
- [ ] Implement `/api/v1/heartbeat`
- [ ] Test with curl / Postman
- [ ] Configure firewall + SSL + rate limiting

### Phase 2 — Admin Plugin (Day 3-5)

- [ ] Create `theme_license.php` plugin
- [ ] Create `theme_license_list.tpl`
- [ ] Create `theme_license_add.tpl`
- [ ] Create `theme_license_edit.tpl`
- [ ] Create `theme_license_view.tpl`
- [ ] Implement CRUD functions
- [ ] Test all admin flows

### Phase 3 — Client Module (Day 6-8)

- [ ] Create `license.php` core
- [ ] Create `c.php` + `j.php` proxy files
- [ ] Update `_head_common.tpl` + `_scripts_common.tpl`
- [ ] Update plugin templates
- [ ] Test with valid and invalid licenses
- [ ] Test heartbeat auto-renewal

### Phase 4 — Encryption (Day 9-10)

- [ ] Purchase ionCube Encoder Basic ($200)
- [ ] Encode all PHP files
- [ ] Test integration end-to-end
- [ ] Package theme for distribution

### Phase 5 — Testing (Day 11-12)

- [ ] Full flow: purchase → install → activate → heartbeat
- [ ] Test revocation + suspension
- [ ] Test domain mismatch rejection
- [ ] Test expiry behavior
- [ ] Bug fixes

---

## 9. Budget

| Item | Cost |
|---|---|
| Domain (`lisensi.domain-anda.com`) | ~$10/year |
| VPS (DigitalOcean / Linode / Vultr $6/month) | ~$72/year |
| ionCube Encoder Basic | $200 (one-time) |
| **Total Year 1** | **~$282** |
| **Annual Renewal** | **~$82/year** |

---

## 10. FAQ

**Q: Can the customer bypass the license by editing the template?**
A: No. CSS/JS are served through PHP proxy files (`c.php`, `j.php`). If license is invalid, the proxy returns empty content — the entire theme breaks visually and functionally. Editing `.tpl` files won't fix the missing CSS/JS.

**Q: Can they delete `license.php` and reference CSS directly?**
A: All PHP files are encoded with ionCube — `license.php` cannot be removed because other encoded files reference it. Removing it causes PHP fatal errors everywhere.

**Q: What if the license server is down?**
A: The theme caches the token (7 days). During those 7 days, it works offline. After 7 days, the heartbeat check needs to reach the server. If the server is still down, the theme stops working.

**Q: Can ionCube be decoded?**
A: Yes, by professional reverse engineers (costs $500-5000). No DRM is 100% unbreakable. The goal is to make it **difficult enough** that the vast majority of users will just pay for a license.

**Q: What about updates to the theme?**
A: Updates are distributed as new ionCube-encoded packages. The license key remains the same — no need to re-activate.
