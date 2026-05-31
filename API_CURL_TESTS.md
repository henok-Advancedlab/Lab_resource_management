# API Curl Tests — Lab Equipment Management

Comprehensive curl-based tests covering every endpoint and all 10 edge cases.

**Base URL:** `http://localhost:3000`

---

## Categories

### GET /categories

List all categories ordered by name with equipment count.

```bash
curl -X GET http://localhost:3000/categories
```

**Response 200:**

```json
[
  {
    "id": 1,
    "name": "Computing",
    "created_at": "2026-05-28T17:57:19.000Z",
    "updated_at": "2026-05-28T17:57:19.000Z",
    "equipment_count": 2
  },
  {
    "id": 2,
    "name": "Electronics",
    "created_at": "2026-05-28T17:57:19.000Z",
    "updated_at": "2026-05-28T17:57:19.000Z",
    "equipment_count": 3
  },
  {
    "id": 3,
    "name": "Networking",
    "created_at": "2026-05-28T17:57:19.000Z",
    "updated_at": "2026-05-28T17:57:19.000Z",
    "equipment_count": 2
  },
  {
    "id": 4,
    "name": "Optics",
    "created_at": "2026-05-28T17:57:19.000Z",
    "updated_at": "2026-05-28T17:57:19.000Z",
    "equipment_count": 2
  }
]
```

---

### GET /categories/:id

Show a single category.

```bash
curl -X GET http://localhost:3000/categories/1
```

**Response 200:**

```json
{
  "id": 1,
  "name": "Computing",
  "created_at": "2026-05-28T17:57:19.000Z",
  "updated_at": "2026-05-28T17:57:19.000Z",
  "equipment_count": 2
}
```

---

### POST /categories

Create a new category.

```bash
curl -X POST http://localhost:3000/categories \
  -H "Content-Type: application/json" \
  -d '{"category": {"name": "Robotics"}}'
```

**Response 201:**

```json
{
  "id": 5,
  "name": "Robotics",
  "created_at": "2026-05-30T12:00:00.000Z",
  "updated_at": "2026-05-30T12:00:00.000Z",
  "equipment_count": 0
}
```

---

### PATCH /categories/:id

Update a category.

```bash
curl -X PATCH http://localhost:3000/categories/5 \
  -H "Content-Type: application/json" \
  -d '{"category": {"name": "Advanced Robotics"}}'
```

**Response 200:**

```json
{
  "id": 5,
  "name": "Advanced Robotics",
  "created_at": "2026-05-30T12:00:00.000Z",
  "updated_at": "2026-05-30T12:00:00.000Z",
  "equipment_count": 0
}
```

---

### DELETE /categories/:id (with no equipment)

```bash
curl -X DELETE http://localhost:3000/categories/5
```

**Response 204:** (empty body)

---

---

## Equipment

### GET /equipment

List all equipment ordered by name.

```bash
curl -X GET http://localhost:3000/equipment
```

**Response 200:**

```json
[
  {
    "id": 9,
    "name": "BK Precision 1685B",
    "serial_number": "BKP-009",
    "status": "maintenance",
    "category_id": 4,
    "created_at": "2026-05-28T17:57:19.000Z",
    "updated_at": "2026-05-28T17:57:19.000Z",
    "category_name": "Electronics"
  },
  {
    "id": 3,
    "name": "Cisco Catalyst 2960",
    "serial_number": "CSC-005",
    "status": "available",
    "category_id": 3,
    "created_at": "2026-05-28T17:57:19.000Z",
    "updated_at": "2026-05-28T17:57:19.000Z",
    "category_name": "Networking"
  }
]
```

Truncated — response includes all 9 seed equipment items ordered by name.

---

### GET /equipment?status=available

Filter equipment by status.

```bash
curl -X GET "http://localhost:3000/equipment?status=available"
```

**Response 200:**

```json
[
  {
    "id": 3,
    "name": "Cisco Catalyst 2960",
    "serial_number": "CSC-005",
    "status": "available",
    "category_id": 3,
    "created_at": "2026-05-28T17:57:19.000Z",
    "updated_at": "2026-05-28T17:57:19.000Z",
    "category_name": "Networking"
  },
  {
    "id": 1,
    "name": "Dell Latitude 5520",
    "serial_number": "DLL-001",
    "status": "available",
    "category_id": 1,
    "created_at": "2026-05-28T17:57:19.000Z",
    "updated_at": "2026-05-28T17:57:19.000Z",
    "category_name": "Computing"
  }
]
```

---

### GET /equipment/:id

Show equipment with category and maintenance records (newest first).

```bash
curl -X GET http://localhost:3000/equipment/1
```

**Response 200:**

```json
{
  "id": 1,
  "name": "Dell Latitude 5520",
  "serial_number": "DLL-001",
  "status": "available",
  "category_id": 1,
  "created_at": "2026-05-28T17:57:19.000Z",
  "updated_at": "2026-05-28T17:57:19.000Z",
  "category_name": "Computing",
  "category": {
    "id": 1,
    "name": "Computing"
  },
  "maintenance_records": [
    {
      "id": 2,
      "performed_at": "2026-05-21T17:57:19.000Z",
      "description": "Cleaned cooling fans and applied new thermal paste.",
      "created_at": "2026-05-28T17:57:19.000Z",
      "updated_at": "2026-05-28T17:57:19.000Z"
    },
    {
      "id": 1,
      "performed_at": "2026-03-28T17:57:19.000Z",
      "description": "Replaced battery and updated BIOS firmware.",
      "created_at": "2026-05-28T17:57:19.000Z",
      "updated_at": "2026-05-28T17:57:19.000Z"
    }
  ]
}
```

---

### POST /equipment

Create new equipment.

```bash
curl -X POST http://localhost:3000/equipment \
  -H "Content-Type: application/json" \
  -d '{"equipment": {"name": "Heat Gun", "serial_number": "HTG-010", "status": "available", "category_id": 4}}'
```

**Response 201:**

```json
{
  "id": 10,
  "name": "Heat Gun",
  "serial_number": "HTG-010",
  "status": "available",
  "category_id": 4,
  "created_at": "2026-05-30T12:00:00.000Z",
  "updated_at": "2026-05-30T12:00:00.000Z",
  "category_name": "Electronics"
}
```

---

### PATCH /equipment/:id

Update equipment status.

```bash
curl -X PATCH http://localhost:3000/equipment/10 \
  -H "Content-Type: application/json" \
  -d '{"equipment": {"status": "maintenance"}}'
```

**Response 200:**

```json
{
  "id": 10,
  "name": "Heat Gun",
  "serial_number": "HTG-010",
  "status": "maintenance",
  "category_id": 4,
  "created_at": "2026-05-30T12:00:00.000Z",
  "updated_at": "2026-05-30T12:00:00.000Z",
  "category_name": "Electronics"
}
```

---

### DELETE /equipment/:id

Delete equipment (cascades to maintenance records).

```bash
curl -X DELETE http://localhost:3000/equipment/10
```

**Response 204:** (empty body)

---

## Maintenance Records

### GET /maintenance_records

List all maintenance records (newest first).

```bash
curl -X GET http://localhost:3000/maintenance_records
```

**Response 200:**

```json
[
  {
    "id": 4,
    "equipment_id": 4,
    "performed_at": "2026-05-23T17:57:19.000Z",
    "description": "Safety inspection completed. All interlocks functioning properly.",
    "created_at": "2026-05-28T17:57:19.000Z",
    "updated_at": "2026-05-28T17:57:19.000Z",
    "equipment_name": "HeNe Laser System"
  }
]
```

Truncated — response includes all 5 seed maintenance records ordered by performed_at DESC.

---

### GET /maintenance_records?equipment_id=:id

Filter by equipment.

```bash
curl -X GET "http://localhost:3000/maintenance_records?equipment_id=1"
```

**Response 200:**

```json
[
  {
    "id": 2,
    "equipment_id": 1,
    "performed_at": "2026-05-21T17:57:19.000Z",
    "description": "Cleaned cooling fans and applied new thermal paste.",
    "created_at": "2026-05-28T17:57:19.000Z",
    "updated_at": "2026-05-28T17:57:19.000Z",
    "equipment_name": "Dell Latitude 5520"
  },
  {
    "id": 1,
    "equipment_id": 1,
    "performed_at": "2026-03-28T17:57:19.000Z",
    "description": "Replaced battery and updated BIOS firmware.",
    "created_at": "2026-05-28T17:57:19.000Z",
    "updated_at": "2026-05-28T17:57:19.000Z",
    "equipment_name": "Dell Latitude 5520"
  }
]
```

---

### GET /maintenance_records/:id

Show a single maintenance record.

```bash
curl -X GET http://localhost:3000/maintenance_records/1
```

**Response 200:**

```json
{
  "id": 1,
  "equipment_id": 1,
  "performed_at": "2026-03-28T17:57:19.000Z",
  "description": "Replaced battery and updated BIOS firmware.",
  "created_at": "2026-05-28T17:57:19.000Z",
  "updated_at": "2026-05-28T17:57:19.000Z",
  "equipment_name": "Dell Latitude 5520"
}
```

---

### POST /maintenance_records

Create a maintenance record.

```bash
curl -X POST http://localhost:3000/maintenance_records \
  -H "Content-Type: application/json" \
  -d '{"maintenance_record": {"equipment_id": 1, "performed_at": "2026-05-30T10:00:00Z", "description": "Routine inspection completed."}}'
```

**Response 201:**

```json
{
  "id": 6,
  "equipment_id": 1,
  "performed_at": "2026-05-30T10:00:00.000Z",
  "description": "Routine inspection completed.",
  "created_at": "2026-05-30T12:00:00.000Z",
  "updated_at": "2026-05-30T12:00:00.000Z",
  "equipment_name": "Dell Latitude 5520"
}
```

---

### PATCH /maintenance_records/:id

Update a maintenance record.

```bash
curl -X PATCH http://localhost:3000/maintenance_records/6 \
  -H "Content-Type: application/json" \
  -d '{"maintenance_record": {"description": "Full inspection and cleaning completed."}}'
```

**Response 200:**

```json
{
  "id": 6,
  "equipment_id": 1,
  "performed_at": "2026-05-30T10:00:00.000Z",
  "description": "Full inspection and cleaning completed.",
  "created_at": "2026-05-30T12:00:00.000Z",
  "updated_at": "2026-05-30T12:00:00.000Z",
  "equipment_name": "Dell Latitude 5520"
}
```

---

### DELETE /maintenance_records/:id

Delete a maintenance record.

```bash
curl -X DELETE http://localhost:3000/maintenance_records/6
```

**Response 204:** (empty body)

---

## Health Check

### GET /up

```bash
curl -X GET http://localhost:3000/up
```

**Response 200:** `"{\"status\":\"OK\",\"database\":\"schema_version:2026_05_28_175719\"}"`

---

# Edge Cases — 10 Required Tests

## Edge Case 1: Equipment with non-existent category_id → 422

```bash
curl -X POST http://localhost:3000/equipment \
  -H "Content-Type: application/json" \
  -d '{"equipment": {"name": "Orphan", "serial_number": "ORP-001", "status": "available", "category_id": 999999}}'
```

**Response 422:**

```json
{
  "errors": ["Category must exist"]
}
```

---

## Edge Case 2: Equipment with duplicate serial_number → 422

```bash
curl -X POST http://localhost:3000/equipment \
  -H "Content-Type: application/json" \
  -d '{"equipment": {"name": "Dupe Device", "serial_number": "DLL-001", "status": "available", "category_id": 1}}'
```

**Response 422:**

```json
{
  "errors": ["Serial number has already been taken"]
}
```

---

## Edge Case 3: Equipment with invalid status → 422

```bash
curl -X POST http://localhost:3000/equipment \
  -H "Content-Type: application/json" \
  -d '{"equipment": {"name": "Broken One", "serial_number": "BRK-001", "status": "broken", "category_id": 1}}'
```

**Response 422:**

```json
{
  "errors": ["broken is not a valid status"]
}
```

---

## Edge Case 4: Category with duplicate name → 422

```bash
curl -X POST http://localhost:3000/categories \
  -H "Content-Type: application/json" \
  -d '{"category": {"name": "Computing"}}'
```

**Response 422:**

```json
{
  "errors": ["Name has already been taken"]
}
```

---

## Edge Case 5: MaintenanceRecord with non-existent equipment_id → 422

```bash
curl -X POST http://localhost:3000/maintenance_records \
  -H "Content-Type: application/json" \
  -d '{"maintenance_record": {"equipment_id": 999999, "performed_at": "2026-05-30T10:00:00Z", "description": "Orphan record"}}'
```

**Response 422:**

```json
{
  "errors": ["Equipment must exist"]
}
```

---

## Edge Case 6: DELETE /categories/:id with equipment referencing it → 409

```bash
curl -X DELETE http://localhost:3000/categories/1
```

**Response 409:**

```json
{
  "error": "Cannot delete category. 2 equipment items still belong to it."
}
```

---

## Edge Case 7: GET /categories/999 → 404

```bash
curl -X GET http://localhost:3000/categories/999999
```

**Response 404:**

```json
{
  "error": "Category not found"
}
```

---

## Edge Case 8: GET /equipment/999 → 404

```bash
curl -X GET http://localhost:3000/equipment/999999
```

**Response 404:**

```json
{
  "error": "Equipment not found"
}
```

---

## Edge Case 9: PATCH /categories/999 → 404

```bash
curl -X PATCH http://localhost:3000/categories/999999 \
  -H "Content-Type: application/json" \
  -d '{"category": {"name": "Nope"}}'
```

**Response 404:**

```json
{
  "error": "Category not found"
}
```

---

## Edge Case 10: MaintenanceRecord with future performed_at → 422

```bash
curl -X POST http://localhost:3000/maintenance_records \
  -H "Content-Type: application/json" \
  -d '{"maintenance_record": {"equipment_id": 1, "performed_at": "2099-12-31T23:59:59Z", "description": "Time travel"}}'
```

**Response 422:**

```json
{
  "errors": ["Performed at cannot be in the future"]
}
```

---

## Error Response Reference

| Status | Condition | Body |
|--------|-----------|------|
| `201` | Resource created | Full resource JSON |
| `200` | Resource read/updated | Full resource JSON |
| `204` | Resource deleted | (empty) |
| `404` | Record not found | `{ "error": "X not found" }` |
| `409` | Delete category with equipment | `{ "error": "Cannot delete category. N equipment items still belong to it." }` |
| `422` | Validation failure | `{ "errors": ["message1", "message2"] }` |
