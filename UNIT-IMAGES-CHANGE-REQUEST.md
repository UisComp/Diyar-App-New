# Unit pictures are missing from the unit payloads

Follow-up to `PROJECT-MASTER-PLAN-CHANGE-REQUEST.md` §3.2 and §6 ("Always return `main_image` and full
`media`"), which is still unchecked.

- **Date:** 2026-09-21
- **Endpoints:** `GET /api/units`, `GET /api/units/{id}`, `GET /api/projects/{id}`, `GET /api/user/finance`
- **Priority:** Medium — nothing leaks; units simply show a placeholder everywhere in the app.

---

## 1. What we see

Every screen that shows a unit shows a grey placeholder instead of a picture. The app reads
`main_image.url` on each unit and, as of this release, also `media[]` as the unit's gallery. If those
keys are absent or `null`, there is nothing to draw.

We can't confirm from outside which endpoints are affected — the unit payloads need a resident token —
so please run §3 against a real account.

## 2. What the app expects

Each unit object, on **every** endpoint that returns one:

```jsonc
{
  "id": 412,
  "code": "T1-G",
  "label": "Town 1 · T-1-G",
  // …

  // The unit's own photo. Same shape as the project's main_image.
  "main_image": {
    "id": 90,
    "name": "T1-G",
    "file_name": "t1-g.jpg",
    "url": "https://diyar.uisdevs.com/storage/90/t1-g.jpg",
    "size": 210000,
    "mime_type": "image/jpeg",
    "uploaded_at": "2026-05-01T10:00:00Z"
  },

  // Optional gallery: floor plan, finishes, handover photos.
  // The app pages through main_image first, then these.
  "media": [
    { "id": 91, "url": "https://diyar.uisdevs.com/storage/91/t1-g-plan.jpg", "mime_type": "image/jpeg" }
  ]
}
```

Rules:

- `main_image` is an **object or `null`** — never a bare url string. The app only reads `{ "url": … }`.
- `media` is an **array or absent**. Entries without a `url` are skipped.
- Both are private data: send them only to the unit's owner, exactly like `unit_value`.
- Where the backend has no picture for a unit, `null` / `[]` is correct — the app draws its own
  placeholder and says so. It just never invents one.

### Endpoints

| Endpoint | Where the app uses the picture |
|---|---|
| `GET /api/units` | The "My units" rows on the profile |
| `GET /api/units/{id}` | Unit details: large image + gallery, tap to zoom |
| `GET /api/projects/{id}` → `buildings[].units[]` | "My units" on the project, and the unit sheet |
| `GET /api/user/finance` → `units[]` | The finance card and the payment plan header (optional here) |

## 3. How to verify

```bash
curl -s -H "Authorization: Bearer $TOKEN" https://diyar.uisdevs.com/api/units \
  | jq '[ .data[] | { code, has_main_image: (.main_image.url != null), media: (.media // [] | length) } ]'
```

Expected, for a resident whose units have pictures uploaded:

```json
[ { "code": "T1-G", "has_main_image": true, "media": 1 } ]
```

Repeat for `GET /api/units/{id}`, and for `GET /api/projects/1 | jq '.data.buildings[].units[]'`.

Double-check the url itself is reachable and not a double-slashed path — `GET /api/projects` currently
returns `https://diyar.uisdevs.com//storage/2/…` (two slashes after the host). It happens to resolve, but
please normalise it.

## 4. What the app does meanwhile

This release:

- parses `main_image` **and** `media` on all four payloads above;
- shows the unit's pictures on the profile rows, the unit details screen, the project's unit sheet, the
  finance card and the payment plan;
- opens any of them full screen, pinch- and double-tap-zoomable, swiping between the unit's pictures;
- draws a labelled "No image found" placeholder when a unit has none, so a missing picture is visible
  rather than silent.

Nothing else is needed on the app side — the moment the payloads carry `main_image`, the pictures appear.

---

## 5. Checklist

- [ ] `GET /api/units`: `main_image` (+ `media`) on every unit
- [ ] `GET /api/units/{id}`: same
- [ ] `GET /api/projects/{id}` → `buildings[].units[]`: same, owner only
- [ ] `GET /api/user/finance` → `units[]`: same (optional, nice to have)
- [ ] Media urls are absolute, reachable, and single-slashed
