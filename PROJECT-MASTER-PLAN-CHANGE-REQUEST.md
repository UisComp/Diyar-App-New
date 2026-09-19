# Project master plan: change request from the mobile team

Changes we need to `GET /api/projects/{id}` so that the project screen shows only the units the user
owns, plus the project gallery.

- **Date:** 2026-09-19
- **Why (security):** Today the endpoint returns **every building and every unit** in the project, with
  each unit's code, floor and status (`available` / `reserved` / `sold`), plus availability counts per
  building. Any resident, and even a signed-out visitor, can list the whole compound and see which
  units are sold. A user must only see **their own** units.
- **Priority:** High. This is a data exposure. Please fix it on the server; hiding data in the app is not
  enough, because anyone can call the API directly.

---

## 1. Business rules

1. **A user sees only the units they own.** No other unit may appear in any project payload: not its
   code, floor, status or id.
2. **No availability data.** Remove `unit_counts` (total / available / reserved / sold) from every
   building. Residents don't need sales figures.
3. **Only the buildings that contain the user's units** are returned, and only those buildings'
   shapes are returned on the master plan.
4. **The owned unit comes with its full details** (§3.2), so the app doesn't need a second call per
   unit.
5. **The project gallery is public**: the master plan image, description and gallery images can be
   shown to anyone who can open the project.
6. **Signed-out visitors** get the project info and gallery only: no buildings, no units, no shapes.
7. **Security staff** (guards) get the same as a signed-out visitor, unless you decide otherwise.
   Please tell us.

---

## 2. What the API returns today (the problem)

`GET /api/projects/{id}`, current response (trimmed):

```json
{
  "success": true,
  "data": {
    "id": 1,
    "name": "La Mer",
    "description": "La Mer residential compound: 14 blocks, 52 towns and 23 villas.",
    "main_image": { "id": 10, "url": "https://…/master-plan.jpg", "…": "…" },
    "media": [ { "id": 11, "url": "https://…/1.jpg" } ],
    "buildings": [
      {
        "id": 5, "type": "block", "code": "B1", "label": "Block 1",
        "unit_counts": { "total": 12, "available": 0, "reserved": 3, "sold": 9 },
        "units": [
          { "id": 101, "code": "B1-G-01", "floor": 0, "status": "sold" },
          { "id": 102, "code": "B1-G-02", "floor": 0, "status": "available" }
        ]
      }
      // … all 89 buildings, every unit in each
    ],
    "has_building_mapping": true,
    "building_mapping": {
      "version": "1", "imageWidth": 2400, "imageHeight": 3400,
      "shapes": [ { "id": "s1", "shapeType": "polygon", "buildingId": 5, "points": [[0.1,0.2], …] } ]
      // shapes for every building
    }
  }
}
```

Problems:

| Field | Problem |
|---|---|
| `buildings` | Every building in the project |
| `buildings[].units` | Every unit, including other owners' units |
| `buildings[].units[].status` | Reveals which units are sold / reserved / available |
| `buildings[].unit_counts` | Sales figures per building |
| `building_mapping.shapes` | Shapes for every building |
| Auth | The endpoint also works signed out, so all of the above is public |

---

## 3. What we need

### 3.1 `GET /api/projects/{id}`, new response

Same endpoint, same envelope. The server filters by the bearer token.

```json
{
  "success": true,
  "message": "OK",
  "data": {
    "id": 1,
    "name": "La Mer",
    "description": "La Mer residential compound: 14 blocks, 52 towns and 23 villas.",

    "main_image": {
      "id": 10, "name": "master-plan", "file_name": "master-plan.jpg",
      "url": "https://…/master-plan.jpg", "size": 812345, "mime_type": "image/jpeg"
    },
    "media": [
      { "id": 11, "name": "pool", "file_name": "pool.jpg", "url": "https://…/pool.jpg",
        "size": 402311, "mime_type": "image/jpeg" },
      { "id": 12, "name": "tour", "file_name": "tour.mp4", "url": "https://…/tour.mp4",
        "size": 9812345, "mime_type": "video/mp4" }
    ],

    "buildings": [
      {
        "id": 23, "type": "town", "code": "T1", "name": "Town 1", "label": "Town 1",
        "units": [ { "…": "full owned unit, see §3.2" } ]
      }
    ],

    "has_building_mapping": true,
    "building_mapping": {
      "version": "1", "imageWidth": 2400, "imageHeight": 3400,
      "shapes": [
        { "id": "s23", "shapeType": "polygon", "buildingId": 23,
          "points": [[0.71, 0.61], [0.74, 0.61], [0.74, 0.66], [0.71, 0.66]] }
      ]
    }
  }
}
```

Rules for this response:

| Field | Signed-in resident | Signed out / guard |
|---|---|---|
| `id`, `name`, `description` | Yes | Yes |
| `main_image` (master plan) | Yes | Yes |
| `media` (gallery) | Yes, **all** gallery items, ordered as in the dashboard | Yes |
| `buildings` | Only buildings holding at least one unit the user owns | `[]` |
| `buildings[].units` | Only the user's own units, with full details (§3.2) | not sent |
| `buildings[].unit_counts` | **Remove** | **Remove** |
| `building_mapping.shapes` | Only shapes whose `buildingId` is in `buildings` | `[]` |
| `has_building_mapping` | `true` only if at least one shape is returned | `false` |

- A resident who owns **no unit in this project** gets `buildings: []` and `shapes: []`, with `200`,
  not an error. The app then shows the gallery and project info only.
- Keep `main_image`, `imageWidth` and `imageHeight` even when `shapes` is empty. The app still shows the
  master plan picture.
- Please keep the building order: blocks, then towns, then villas; by code within each type. Inside a
  building: ground floor first, then by code.

### 3.2 An owned unit inside `buildings[].units`

The same fields `GET /api/units/{id}` already returns to the owner, so the app shows the full details
straight from the master plan:

```json
{
  "id": 412,
  "code": "T1-G",
  "name": "Town 1 Ground",
  "label": "Town 1 · T-1-G",
  "floor": 0,
  "status": "sold",
  "project_id": 1,
  "building_id": 23,
  "user_id": 77,
  "area": 185.5,
  "bedrooms": 3,
  "bathrooms": 2,
  "unit_value": 4500000,
  "maintenance_deposit_amount": 350000,
  "club_house_amount": 100000,
  "contract_total": 4950000,
  "delivery_date": "2027-06-30",
  "main_image": { "id": 90, "url": "https://…/t1-g.jpg", "file_name": "t1-g.jpg", "size": 210000,
                  "uploaded_at": "2026-05-01T10:00:00Z" },
  "media": [ { "id": 91, "url": "https://…/t1-g-plan.jpg", "mime_type": "image/jpeg" } ]
}
```

| Field | Notes |
|---|---|
| `id`, `code`, `name`, `label` | As today |
| `floor` | `0` = ground. `null` for villas. Towns: `0` ground, `1` upper |
| `status` | The owner's own unit only |
| `project_id`, `building_id`, `user_id` | As in `GET /api/units/{id}` |
| `unit_value`, `maintenance_deposit_amount`, `club_house_amount`, `contract_total` | As in `GET /api/units/{id}` |
| `main_image` | Unit image |
| `area`, `bedrooms`, `bathrooms`, `delivery_date`, `media` | **New, optional.** Send them if the data exists; the app hides any field that is missing or `null` |

`news` is **not** needed here. The app loads a unit's news from `GET /news/unit/{id}` when the user taps
the unit.

### 3.3 `GET /api/units/{id}`

Please confirm this endpoint returns `403` (or `404`) when the unit doesn't belong to the signed-in
user. Today the app only calls it for the user's own units, but anyone can change the id.

### 3.4 Other endpoints to check

The same rule applies anywhere a unit list or a unit's status can leak. Please check:

| Endpoint | Check |
|---|---|
| `GET /api/projects` and `GET /api/projects/user` | No `buildings`, `units` or `unit_counts` in the list |
| `GET /news/unit/{id}` | Only for the owner of that unit |
| `POST /api/check-unit-availability` (registration) | Returns only whether the code can be claimed; no owner, status or other unit data |

---

## 4. Errors

| Case | Status | Body |
|---|---|---|
| Project doesn't exist | `404` | `{ "success": false, "message": "Project not found" }` |
| Resident owns no unit in the project | `200` | Normal response with `buildings: []`, `shapes: []` |
| Expired / invalid token | `401` | As on other endpoints. The app signs the user out |
| `GET /api/units/{id}` for someone else's unit | `403` | `{ "success": false, "message": "Forbidden" }` |

---

## 5. What the app will do

Once you deploy, the app will:

1. Remove the "Has available units / No available units" legend and the "N available" line on each
   building card.
2. Draw on the master plan only the shapes you return (the user's buildings), highlighted.
3. Show a **"My units"** section in place of the full Block / Town / Villa list, grouped by building
   and floor, each with its full details (§3.2).
4. Show the project **gallery** (`media`) for everyone.
5. For signed-out users, show the master plan picture, description and gallery only.

The app reads every field defensively, so the new response won't crash older versions: missing
`unit_counts` and fewer buildings are already handled.

---

## 6. Summary checklist for the backend

- [ ] `GET /api/projects/{id}`: return only the signed-in user's buildings and units
- [ ] Remove `unit_counts` from every building
- [ ] Filter `building_mapping.shapes` to the returned buildings
- [ ] Signed out / guard: `buildings: []`, `shapes: []`, `has_building_mapping: false`
- [ ] Always return `main_image` and full `media` (gallery)
- [ ] Owned units carry the full fields from §3.2
- [ ] `GET /api/units/{id}`: `403` for someone else's unit
- [ ] Check the endpoints in §3.4
- [ ] Tell us which optional fields (`area`, `bedrooms`, `bathrooms`, `delivery_date`, unit `media`) you
      can send
- [ ] Tell us what guards should see (§1.7)
