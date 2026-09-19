# Login & registration: change request from the mobile team

> **Answered and done.** The backend implemented this; see *MOBILE-API-CHANGES-AUTH-2026-09-19.md*.
> The app follows that document. Kept for the record only: don't send it again.

Changes we need to the login, registration and SMS behaviour described in
*MOBILE-API-CHANGES-AUTH.md*, and what the app already does.

- **Date:** 2026-09-19
- **Why:** SMS messages cost money. A code should be sent only when it's really needed, never on an
  everyday login.
- **The app is already built for this** (§6). It works with today's API too; nothing breaks while you
  make the changes.

---

## 1. Business rules

1. **One login screen for everyone.** A single "Phone number or email" field and a password.
   - Residents type their **phone number**.
   - Security staff type their **work email**.
2. **Password is the default.** An everyday login never sends an SMS.
3. **An SMS code is sent only in these three cases:**

   | Case | Who | How often |
   |---|---|---|
   | Registration | A new resident proving their number | Once |
   | First login of an account **created by staff in the dashboard** (no password yet) | That resident | Once, then they set a password |
   | "Forgot password?" | A resident who forgot it | Only when they ask |

4. **Residents choose their password when they register**, so after approval they log in with
   phone + password. No code is needed at their first login.
5. **Residents can list all their units when they register**, not just one.

---

## 2. Login

### 2.1 What the app does now (works with today's API)

| Typed | Endpoint | Body |
|---|---|---|
| Phone number | `POST /api/auth/login` | `phone`, `password`, `fcm_token`, `platform` |
| Email | `POST /api/login` | `email`, `password`, `fcm_token`, `platform` |

- The app **no longer calls `POST /api/auth/identify`**. Login goes straight to password.
- Phone numbers are sent in international form (`+201012345678`). The app converts local numbers,
  Arabic digits, spaces and dashes.
- An SMS code is requested **only** when the user taps **"Sign in with SMS code"** or
  **"Forgot password?"**, or agrees after `password_not_set` (§2.2).

### 2.2 What we need from `POST /api/auth/login`

1. **It must never send an SMS.** Please confirm.
2. For an account **created by staff** that has no password yet, answer `409` with
   `errors.code = password_not_set` (as documented in §4.6). The app then offers "We'll text you a
   code" and calls `POST /api/auth/otp` only if the user agrees.
3. An unknown number should answer `401 wrong_credentials`, not `404`, so the login doesn't reveal
   which numbers are registered.
4. A security staff member's phone number: keep `403 use_email_login`. The app tells them to use
   their work email on the same screen.

### 2.3 Optional: one login endpoint

To keep one login for everyone on the server side too, we'd welcome `POST /api/auth/login`
accepting **either** a phone number or an email:

```json
{ "login": "01012345678", "password": "secret123", "fcm_token": "…", "platform": "ios" }
{ "login": "guard@lamer.com", "password": "secret123", "fcm_token": "…", "platform": "android" }
```

If you add it, tell us and the app will switch to it. Until then the app picks the endpoint itself
(§2.1).

---

## 3. SMS codes

| Endpoint | The app calls it when | Should stay |
|---|---|---|
| `POST /api/auth/register/otp` | Registration, once, after the resident enters their number | Yes |
| `POST /api/auth/otp` | "Sign in with SMS code" (first login of a staff-created account), after `password_not_set`, or "Forgot password?" | Yes |
| `POST /api/profile/phones/otp` | A resident **adds or replaces** a phone number in the app | **Your decision (Q6)** |

- Rate limits (§4.3) stay as they are.
- `POST /api/auth/otp` for an account that **already has** a password works like "Forgot
  password?": the resident sets a new password. That's what we want.

### 3.1 Other SMS the backend sends today (costs to review)

From *MOBILE-API-CHANGES-AUTH.md*:

| SMS | Sent to | Our suggestion |
|---|---|---|
| Registration approved/rejected | The resident | Keep. They have no app login yet, so a push can't reach them. |
| Phone number request sent (§7.7) | **Every** number on the account | Only the primary number. |
| Phone number request reviewed (§7.7) | The primary number, plus a push and an in-app notification | Push + in-app notification only. |
| Number removed or replaced (§7.7) | That number | Keep (security). |

---

## 4. Registration: several units and a password

### 4.1 `POST /api/auth/register`

```json
// request
{
  "registration_token": "vN3…",
  "name": "John Doe",
  "email": "john@example.com",            // optional, as today
  "unit_codes": ["B1-G-01", "T-12-S"],     // NEW: 1 to 10 codes, any case, no duplicates
  "password": "secret123",                 // NEW: at least 8 characters
  "password_confirmation": "secret123",    // NEW
  "locale": "ar"
}

// 201: unchanged (the User, pending approval; still not a login)
```

- Keep accepting the old single `unit_code` for a while, for app versions already in the stores.
  If both are sent, `unit_codes` wins.
- Keep the 422 map, with the index of the failing code:

```json
{
  "success": false,
  "message": "The given data was invalid.",
  "errors": {
    "unit_codes.1": ["Unit is already assigned to another user"],
    "password": ["The password must be at least 8 characters."]
  }
}
```

- As today, a validation error must **not** use up the `registration_token`.
- `password` should be **required** for new app versions (optional only while old versions are
  still in use).

### 4.2 `GET /api/check-unit-availability`

No change. The app calls it once per unit code as the resident types; please make sure the rate limit
allows about 10 checks in a row.

### 4.3 Staff review in the dashboard

- Show every requested unit and let staff **approve or reject each one**.
- If at least one unit is approved, the account is approved. If every unit is rejected, we assume
  the registration is rejected.
- The approval SMS should say: *"Your account is approved. Sign in with your phone number and your
  password."* and list the approved units (or how many).

### 4.4 After approval

- `POST /api/auth/login` with phone + the password chosen at registration logs the resident in.
  **No SMS code at the first login.**
- "Forgot password?" and the dashboard's **Reset login** keep working as today.

---

## 5. Accounts created by staff in the dashboard

- Created with phone numbers only, no password (as today).
- The resident's first login: they tap **"Sign in with SMS code"** (or get `password_not_set` after
  trying a password) → one code → they set a password. From then on: phone + password.
- Nothing needs to change on the server for this, as long as §2.2 holds.

---

## 6. What the app sends today

- **Login:** §2.1. It never calls `auth/identify`.
- **Registration:**

```json
{
  "registration_token": "vN3…",
  "name": "John Doe",
  "email": "john@example.com",
  "unit_code": "B1-G-01",
  "unit_codes": ["B1-G-01", "T-12-S"],
  "password": "secret123",
  "password_confirmation": "secret123",
  "locale": "ar"
}
```

- `unit_code` is always the first entry of `unit_codes`. Today's API reads `unit_code` and ignores
  the rest; once you support `unit_codes`, read that instead.
- Until you store `password`, residents who registered keep today's first login (one code, then set a
  password). As soon as you store it, they log in with it.

---

## 7. Questions for the backend team

1. Does `POST /api/auth/login` ever send an SMS today? (It must not.)
2. Will you add the combined `login` field (§2.3), or should the app keep choosing the endpoint?
3. Maximum units per registration? (The app allows 10.)
4. Password rules: still at least 8 characters? (The app requires 8.)
5. Will you add new `errors.code` values (e.g. a rejected unit)? Please list them so we can show
   Arabic and English messages.
6. Adding or replacing a phone number currently needs an SMS code to the new number (§7.2). Keep it
   (it proves the resident owns the number) or drop it to save SMS?
7. Can the SMS in §3.1 be reduced as suggested?
