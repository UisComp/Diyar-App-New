# Master plan still highlights buildings the user doesn't own

Follow-up to `PROJECT-MASTER-PLAN-CHANGE-REQUEST.md` (2026-09-19). Two items from its §6 checklist are
still open on `GET /api/projects/{id}`.

- **Date:** 2026-09-21
- **Endpoint:** `GET /api/projects/{id}` (project 1, LA' MER)
- **Priority:** High — same data exposure as the original request, in a narrower form.

---

## 1. What we see

Signed in as a user who owns exactly two units:

| Unit | Building |
|---|---|
| `B1-G-01` | Block 1 |
| `V-9` | Villa 9 |

- The **"My units"** section correctly lists **two** buildings: Block 1 and Villa 9.
- The **master plan** highlights **three** polygons: V-09, and two polygons over the block area in the
  bottom-right corner.

So the map draws at least one building the user owns nothing in.

## 2. What that tells us about the response

The app draws a polygon for a `building_mapping.shapes[]` entry whose `buildingId` appears in
`data.buildings[]`. The list section, in contrast, only shows a building that has a non-empty `units[]`.
The two disagree, so the response must contain a building in one of these shapes:

```jsonc
"buildings": [
  { "id": 5,  "type": "block", "code": "B1", "label": "Block 1", "units": [ { "id": 101, "code": "B1-G-01", … } ] },
  { "id": 23, "type": "villa", "code": "V-9", "label": "V-9",    "units": [ { "id": 140, "code": "V-9", … } ] },

  // ❌ Not the user's. Invisible in the list, but its shape is still drawn on the plan.
  { "id": 6,  "type": "block", "code": "B2", "label": "Block 2", "units": [] }
],
"building_mapping": {
  "shapes": [
    { "id": "s1", "buildingId": 5,  "points": [ … ] },
    { "id": "s2", "buildingId": 23, "points": [ … ] },
    { "id": "s3", "buildingId": 6,  "points": [ … ] }   // ❌ must not be sent
  ]
}
```

Either the building is returned with an empty `units` array, or its shape is returned for a building id
that isn't in `buildings` at all. Both are the same leak: the response tells the caller where another
resident's block or villa sits on the plan.

## 3. What we need

Two rules, both already in the original request (§1.3 and §6):

1. **`data.buildings[]` contains only buildings in which the signed-in user owns at least one unit.**
   A building with `"units": []` must not be returned at all — not even as an empty shell.
2. **`data.building_mapping.shapes[]` is filtered to exactly those building ids.** Every
   `shape.buildingId` must appear in `data.buildings[]`, and no shape for any other building may be sent.

`imageWidth` / `imageHeight` / `version` stay as they are — the app needs them to size the plan even when
there are no shapes.

Signed out, or a user who owns nothing in this project: `"buildings": []`, `"shapes": []`,
`"has_building_mapping": false`.

## 4. How to verify

Call the endpoint as that user and assert, on the raw JSON:

```bash
curl -s -H "Authorization: Bearer $TOKEN" https://diyar.uisdevs.com/api/projects/1 \
  | jq '.data | (.buildings | map(.id)) as $owned | {
      building_count:        (.buildings | length),
      shape_count:           (.building_mapping.shapes | length),
      buildings_with_no_units: [ .buildings[] | select((.units // []) | length == 0) | .code ],
      orphan_shapes:         [ .building_mapping.shapes[] | select((.buildingId | IN($owned[])) | not) | .id ]
    }'
```

For the account above the result must be:

```json
{
  "building_count": 2,
  "shape_count": 2,
  "buildings_with_no_units": [],
  "orphan_shapes": []
}
```

## 5. What the app does meanwhile

We shipped a defensive fix: the app now draws a polygon only for a building that carries at least one of
the user's units, so the plan and the "My units" list can no longer disagree. **This is not a fix for the
leak** — anyone calling the API directly still gets the extra buildings and their coordinates on the
master plan. The server change in §3 is still required.

## 6. Separate, for the dashboard team

The two polygons highlighted near Block 1 in the bottom-right corner are drawn loosely: they cover part of
the road and the garden next to the buildings, and one of them extends past the building's footprint.
Once §3 is deployed and only the user's buildings are highlighted, please re-draw the block shapes in the
mapping tool so each polygon follows its building's outline.

---

## 7. Checklist

- [ ] `GET /api/projects/{id}`: drop every building the signed-in user owns no unit in (no empty `units[]`)
- [ ] Filter `building_mapping.shapes[]` to the returned building ids
- [ ] Verify with the account above: 2 buildings, 2 shapes
- [ ] Re-draw the Block 1 polygons in the mapping dashboard (§6)
