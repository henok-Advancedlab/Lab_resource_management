# API curl Tests & Responses

Worked `curl` examples and live responses for every endpoint, grouped by task,
plus all 10 edge cases. Captured against the seeded development database
(`bin/rails db:seed`) running on `http://localhost:3000`.

> IDs below reflect one seeded run; your local IDs may differ after re-seeding.

---

## Task 3 — Category CRUD

### List all (ordered by name, includes equipment_count)
```bash
curl http://localhost:3000/categories
```
`200 OK`
```json
[{"id":9,"name":"Computing","created_at":"2026-05-30T20:36:01.583Z","updated_at":"2026-05-30T20:36:01.583Z","equipment_count":2},
 {"id":12,"name":"Electronics","created_at":"2026-05-30T20:36:01.712Z","updated_at":"2026-05-30T20:36:01.712Z","equipment_count":3},
 {"id":11,"name":"Networking","created_at":"2026-05-30T20:36:01.697Z","updated_at":"2026-05-30T20:36:01.697Z","equipment_count":2},
 {"id":10,"name":"Optics","created_at":"2026-05-30T20:36:01.606Z","updated_at":"2026-05-30T20:36:01.606Z","equipment_count":2}]
```

### Show one (includes equipment_count)
```bash
curl http://localhost:3000/categories/9
```
`200 OK`
```json
{"id":9,"name":"Computing","created_at":"2026-05-30T20:36:01.583Z","updated_at":"2026-05-30T20:36:01.583Z","equipment_count":2}
```

### Create
```bash
curl -X POST http://localhost:3000/categories \
  -H "Content-Type: application/json" \
  -d '{"category":{"name":"Robotics"}}'
```
`201 Created`
```json
{"id":13,"name":"Robotics","created_at":"2026-05-30T20:37:03.640Z","updated_at":"2026-05-30T20:37:03.640Z","equipment_count":0}
```

### Update
```bash
curl -X PATCH http://localhost:3000/categories/13 \
  -H "Content-Type: application/json" \
  -d '{"category":{"name":"Robotics Lab"}}'
```
`200 OK`
```json
{"id":13,"name":"Robotics Lab","created_at":"2026-05-30T20:37:03.640Z","updated_at":"2026-05-30T20:37:04.088Z","equipment_count":0}
```

### Delete (no equipment attached)
```bash
curl -X DELETE http://localhost:3000/categories/13
```
`204 No Content` (empty body)

---

## Task 4 — Equipment CRUD with filtering

### List all (ordered by name, includes category_name)
```bash
curl http://localhost:3000/equipment
```
`200 OK`
```json
[{"id":18,"name":"BK Precision 1685B","serial_number":"BKP-009","status":"maintenance","category_id":12,"category_name":"Electronics", "...":"..."},
 {"id":14,"name":"Cisco Catalyst 2960","serial_number":"CSC-005","status":"available","category_id":11,"category_name":"Networking"},
 {"id":10,"name":"Dell Latitude 5520","serial_number":"DLL-001","status":"available","category_id":9,"category_name":"Computing"},
 {"id":17,"name":"Fluke 87V Multimeter","serial_number":"FLU-008","status":"available","category_id":12,"category_name":"Electronics"},
 {"id":11,"name":"HP EliteDesk 800","serial_number":"HPD-002","status":"in_use","category_id":9,"category_name":"Computing"},
 {"id":13,"name":"HeNe Laser System","serial_number":"LAS-004","status":"maintenance","category_id":10,"category_name":"Optics"},
 {"id":15,"name":"Netgear ProSafe GS108","serial_number":"NET-006","status":"in_use","category_id":11,"category_name":"Networking"},
 {"id":12,"name":"Olympus BX53 Microscope","serial_number":"OLY-003","status":"available","category_id":10,"category_name":"Optics"},
 {"id":16,"name":"Tektronix TBS1052B","serial_number":"TEK-007","status":"available","category_id":12,"category_name":"Electronics"}]
```

### Filter by status
```bash
curl "http://localhost:3000/equipment?status=maintenance"
```
`200 OK`
```json
[{"id":18,"name":"BK Precision 1685B","serial_number":"BKP-009","status":"maintenance","category_id":12,"category_name":"Electronics"},
 {"id":13,"name":"HeNe Laser System","serial_number":"LAS-004","status":"maintenance","category_id":10,"category_name":"Optics"}]
```

### Show one (includes category and maintenance records, newest first)
```bash
curl http://localhost:3000/equipment/18
```
`200 OK`
```json
{"id":18,"name":"BK Precision 1685B","serial_number":"BKP-009","status":"maintenance","category_id":12,
 "category_name":"Electronics","category":{"id":12,"name":"Electronics"},"maintenance_records":[]}
```

### Create (accepts category_id)
```bash
curl -X POST http://localhost:3000/equipment \
  -H "Content-Type: application/json" \
  -d '{"equipment":{"name":"Arduino Uno Kit","serial_number":"ARD-100","status":"available","category_id":9}}'
```
`201 Created`
```json
{"id":19,"name":"Arduino Uno Kit","serial_number":"ARD-100","status":"available","category_id":9,"category_name":"Computing"}
```

### Update
```bash
curl -X PATCH http://localhost:3000/equipment/19 \
  -H "Content-Type: application/json" \
  -d '{"equipment":{"status":"in_use"}}'
```
`200 OK`
```json
{"id":19,"name":"Arduino Uno Kit","serial_number":"ARD-100","status":"in_use","category_id":9,"category_name":"Computing"}
```

### Delete (cascades to maintenance records)
```bash
curl -X DELETE http://localhost:3000/equipment/19
```
`204 No Content` (empty body)

---

## Task 5 — MaintenanceRecord CRUD with filtering

### List all (ordered by performed_at desc, includes equipment_name)
```bash
curl http://localhost:3000/maintenance_records
```
`200 OK`
```json
[{"id":9,"equipment_id":13,"performed_at":"2026-05-25T20:36:01.966Z","description":"Safety inspection completed. All interlocks functioning properly.","equipment_name":"HeNe Laser System"},
 {"id":7,"equipment_id":10,"performed_at":"2026-05-23T20:36:01.935Z","description":"Cleaned cooling fans and applied new thermal paste. Temperature readings normal.","equipment_name":"Dell Latitude 5520"},
 {"id":8,"equipment_id":13,"performed_at":"2026-05-09T20:36:01.950Z","description":"Calibrated laser alignment and replaced optical filters. Power output verified.","equipment_name":"HeNe Laser System"},
 {"id":10,"equipment_id":16,"performed_at":"2026-04-30T20:36:01.978Z","description":"Annual calibration performed. All channels within specification.","equipment_name":"Tektronix TBS1052B"},
 {"id":6,"equipment_id":10,"performed_at":"2026-03-30T20:36:01.918Z","description":"Replaced battery and updated BIOS firmware. System running optimally.","equipment_name":"Dell Latitude 5520"}]
```

### Filter by equipment_id
```bash
curl "http://localhost:3000/maintenance_records?equipment_id=13"
```
`200 OK`
```json
[{"id":9,"equipment_id":13,"performed_at":"2026-05-25T20:36:01.966Z","description":"Safety inspection completed. All interlocks functioning properly.","equipment_name":"HeNe Laser System"},
 {"id":8,"equipment_id":13,"performed_at":"2026-05-09T20:36:01.950Z","description":"Calibrated laser alignment and replaced optical filters. Power output verified.","equipment_name":"HeNe Laser System"}]
```

### Show one (includes equipment_name)
```bash
curl http://localhost:3000/maintenance_records/9
```
`200 OK`
```json
{"id":9,"equipment_id":13,"performed_at":"2026-05-25T20:36:01.966Z","description":"Safety inspection completed. All interlocks functioning properly.","equipment_name":"HeNe Laser System"}
```

### Create (accepts equipment_id)
```bash
curl -X POST http://localhost:3000/maintenance_records \
  -H "Content-Type: application/json" \
  -d '{"maintenance_record":{"equipment_id":13,"performed_at":"2026-05-01T10:00:00Z","description":"Firmware update and diagnostics"}}'
```
`201 Created`
```json
{"id":11,"equipment_id":13,"performed_at":"2026-05-01T10:00:00.000Z","description":"Firmware update and diagnostics","equipment_name":"HeNe Laser System"}
```

### Update
```bash
curl -X PATCH http://localhost:3000/maintenance_records/11 \
  -H "Content-Type: application/json" \
  -d '{"maintenance_record":{"description":"Firmware update, diagnostics, and cleaning"}}'
```
`200 OK`
```json
{"id":11,"equipment_id":13,"performed_at":"2026-05-01T10:00:00.000Z","description":"Firmware update, diagnostics, and cleaning","equipment_name":"HeNe Laser System"}
```

### Delete
```bash
curl -X DELETE http://localhost:3000/maintenance_records/11
```
`204 No Content` (empty body)

---

## Task 7 — Edge Cases (all 10)

### 1. Create equipment with non-existent category_id → 422
```bash
curl -X POST http://localhost:3000/equipment \
  -H "Content-Type: application/json" \
  -d '{"equipment":{"name":"Orphan","serial_number":"ORP-001","status":"available","category_id":999}}'
```
`422 Unprocessable Entity`
```json
{"errors":["Category must exist"]}
```

### 2. Create equipment with duplicate serial number → 422
```bash
curl -X POST http://localhost:3000/equipment \
  -H "Content-Type: application/json" \
  -d '{"equipment":{"name":"Dupe","serial_number":"DLL-001","status":"available","category_id":9}}'
```
`422 Unprocessable Entity`
```json
{"errors":["Serial number has already been taken"]}
```

### 3. Create equipment with invalid status → 422
```bash
curl -X POST http://localhost:3000/equipment \
  -H "Content-Type: application/json" \
  -d '{"equipment":{"name":"Broken","serial_number":"BRK-001","status":"broken","category_id":9}}'
```
`422 Unprocessable Entity`
```json
{"errors":["Status broken is not a valid status"]}
```

### 4. Create category with duplicate name → 422
```bash
curl -X POST http://localhost:3000/categories \
  -H "Content-Type: application/json" \
  -d '{"category":{"name":"Computing"}}'
```
`422 Unprocessable Entity`
```json
{"errors":["Name has already been taken"]}
```

### 5. Create maintenance record with non-existent equipment_id → 422
```bash
curl -X POST http://localhost:3000/maintenance_records \
  -H "Content-Type: application/json" \
  -d '{"maintenance_record":{"equipment_id":999,"performed_at":"2026-01-01","description":"x"}}'
```
`422 Unprocessable Entity`
```json
{"errors":["Equipment must exist"]}
```

### 6. Delete a category that still has equipment → 409
```bash
curl -X DELETE http://localhost:3000/categories/9
```
`409 Conflict`
```json
{"error":"Cannot delete category. 2 equipment items still belong to it."}
```

### 7. GET non-existent category → 404
```bash
curl http://localhost:3000/categories/999
```
`404 Not Found`
```json
{"error":"Category not found"}
```

### 8. GET non-existent equipment → 404
```bash
curl http://localhost:3000/equipment/999
```
`404 Not Found`
```json
{"error":"Equipment not found"}
```

### 9. PATCH non-existent category → 404
```bash
curl -X PATCH http://localhost:3000/categories/999 \
  -H "Content-Type: application/json" \
  -d '{"category":{"name":"Nope"}}'
```
`404 Not Found`
```json
{"error":"Category not found"}
```

### 10. Create maintenance record with future performed_at → 422
```bash
curl -X POST http://localhost:3000/maintenance_records \
  -H "Content-Type: application/json" \
  -d '{"maintenance_record":{"equipment_id":13,"performed_at":"2099-01-01","description":"future"}}'
```
`422 Unprocessable Entity`
```json
{"errors":["Performed at cannot be in the future"]}
```
