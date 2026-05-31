# Lab Equipment Management API

A centralized RESTful JSON API built with Ruby on Rails to track laboratory
resources, equipment statuses, and historical maintenance logs.

## Requirements

- Ruby (see `.ruby-version`)
- SQLite 3

## Setup

```bash
git clone <repo-url>
cd Lab_resource_management
bundle install
bin/rails db:migrate
bin/rails db:seed
bin/rails server
```

The API is then available at `http://localhost:3000`.

## Running the tests

```bash
bin/rails test          # full suite
bin/rubocop             # lint (Omakase RuboCop)
```

## Data model

```
Category 1───* Equipment 1───* MaintenanceRecord
```

- **Category** — `name` (required, unique, min 3 chars). Cannot be deleted while equipment references it.
- **Equipment** — `name`, `serial_number` (unique, format `XXX-NNN`), `status` (`available` / `in_use` / `maintenance`, default `available`), `category_id`. Deleting equipment cascades to its maintenance records.
- **MaintenanceRecord** — `description`, `performed_at` (cannot be in the future), `equipment_id`.

## Endpoints

| Method | Path | Notes |
|--------|------|-------|
| GET | `/categories` | Ordered by name; includes `equipment_count` |
| GET | `/categories/:id` | Includes `equipment_count` |
| POST | `/categories` | |
| PATCH | `/categories/:id` | |
| DELETE | `/categories/:id` | `409` if equipment still references it |
| GET | `/equipment` | `?status=` filter; includes category name; ordered by name |
| GET | `/equipment/:id` | Includes category and maintenance records (newest first) |
| POST | `/equipment` | Accepts `category_id` |
| PATCH | `/equipment/:id` | |
| DELETE | `/equipment/:id` | Cascades to maintenance records |
| GET | `/maintenance_records` | `?equipment_id=` filter; ordered by `performed_at` desc; includes equipment name |
| GET | `/maintenance_records/:id` | Includes equipment name |
| POST | `/maintenance_records` | Accepts `equipment_id` |
| PATCH | `/maintenance_records/:id` | |
| DELETE | `/maintenance_records/:id` | |

## Response codes

| Situation | Code |
|-----------|------|
| Created | `201` |
| Read / updated | `200` |
| Deleted | `204` (empty body) |
| Record not found | `404` — `{ "error": "X not found" }` |
| Validation failed | `422` — `{ "errors": [...] }` |
| Delete category with equipment | `409` — `{ "error": "Cannot delete category. N equipment items still belong to it." }` |

See [`API_CURL_TESTS.md`](API_CURL_TESTS.md) for worked `curl` examples of every endpoint and all edge cases.

## Team

| Member | Role | Tasks |
|--------|------|-------|
| Henok | Team Lead / Architect | Data model & migrations (Task 1), Seed data (Task 2), PR management |
| Nathenael Tamirat | Backend Developer | Equipment CRUD (Task 4), code comments, technical documentation |
| Hosie Dereje | Backend Developer | Categories CRUD (Task 3), Edge case testing (Task 7) |
| Natnael Fikire | Backend Developer | MaintenanceRecord CRUD (Task 5) |
| Bereket Nebiyu | Validations Developer | Business rules & validations (Task 6), global error handling |
| Oliyad Bekele | Integration Engineer | Route fixes, model tests, API documentation, RuboCop cleanup |

### Task Assignment & Completion Status

| Task | Owner | Branch | Status |
|------|-------|--------|--------|
| 1 — Data model and migrations | Henok | `main` | Done |
| 2 — Seed data | Henok | `main` | Done |
| 3 — Categories CRUD | Hosie Dereje | `task-3-categories` | Done |
| 4 — Equipment CRUD | Nathenael Tamirat | `main` | Done |
| 5 — MaintenanceRecord CRUD | Natnael Fikire | `main` | Done |
| 6 — Business rules | Bereket Nebiyu | `main` | Done |
| 7 — Edge case testing | Hosie Dereje | `task-7-edge-cases` | Done |
