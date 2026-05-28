# Database Setup Documentation
## Developer 1: Henok - Database Architect & Seed Master

This document explains the database layer implementation for the Lab Resource Management system.

---

## Models Overview

### 1. **Category**
Represents equipment categories in the lab (e.g., Computing, Optics, Networking, Electronics).

**Purpose**: Organizes equipment into logical groups for easier management and filtering.

**Fields**:
- `name` (string, required, unique): The category name

**Associations**:
- `has_many :equipment` - A category can have multiple equipment items

---

### 2. **Equipment**
Represents individual pieces of lab equipment that can be tracked and maintained.

**Purpose**: Tracks all lab equipment with unique serial numbers, current status, and category classification.

**Fields**:
- `name` (string, required): Equipment name/model
- `serial_number` (string, required, unique): Unique identifier for each equipment
- `status` (string, required, default: "available"): Current status (available, checked_out, maintenance, retired)
- `category_id` (foreign key, required): Links to the category

**Associations**:
- `belongs_to :category` - Each equipment belongs to one category
- `has_many :maintenance_records` - Equipment can have multiple maintenance records

---

### 3. **MaintenanceRecord**
Tracks maintenance activities performed on equipment.

**Purpose**: Maintains a complete history of all maintenance work, repairs, and inspections for each equipment item.

**Fields**:
- `equipment_id` (foreign key, required): Links to the equipment
- `performed_at` (datetime, required): When the maintenance was performed
- `description` (text, required): Details about the maintenance work

**Associations**:
- `belongs_to :equipment` - Each record belongs to one equipment item

---

## Database Constraints

### Unique Indexes
- `categories.name` - Prevents duplicate category names
- `equipment.serial_number` - Ensures each equipment has a unique serial number

### Foreign Keys
- `equipment.category_id` → `categories.id` (with cascade)
- `maintenance_records.equipment_id` → `equipment.id` (with cascade)

### Default Values
- `equipment.status` defaults to "available"

### Composite Index
- `maintenance_records(equipment_id, performed_at)` - Optimizes queries for equipment maintenance history

### NOT NULL Constraints
All critical fields are marked as `null: false` at the database level for data integrity.

---

## Model Validations

### Category
```ruby
validates :name, presence: true, uniqueness: true
```

### Equipment
```ruby
validates :name, presence: true
validates :serial_number, presence: true, uniqueness: true
validates :status, presence: true
validates :category, presence: true
```

### MaintenanceRecord
```ruby
validates :equipment, presence: true
validates :performed_at, presence: true
validates :description, presence: true
```

---

## Seed Data

The seed file creates:

### Categories (4 total)
- Computing
- Optics
- Networking
- Electronics

### Equipment (9 items across all statuses)
- **Available** (4 items): Ready for use
- **Checked Out** (2 items): Currently in use
- **Maintenance** (2 items): Under repair/maintenance
- **Retired** (1 item): No longer in service

### Maintenance Records (5 records)
- Spread across 3 different equipment items
- Some equipment intentionally has no maintenance history (6 items)

---

## Rails Commands Used

### Generate Models
```bash
# Category was already generated
rails generate model Equipment name:string serial_number:string status:string category:references
rails generate model MaintenanceRecord equipment:references performed_at:datetime description:text
```

### Run Migrations
```bash
rails db:migrate
```

### Seed Database
```bash
rails db:seed
```

### Reset Database (if needed)
```bash
rails db:reset  # Drops, creates, migrates, and seeds
```

---

## Git Workflow

### Check Status
```bash
git status
```

### Stage All Changes
```bash
git add .
```

### Commit with Descriptive Message
```bash
git commit -m "Add database schema: Category, Equipment, MaintenanceRecord models with migrations, validations, and seed data"
```

### Push to Remote Repository
```bash
git push origin main
```

Or if you're on a different branch:
```bash
git push origin <branch-name>
```

---

## File Structure

```
db/
├── migrate/
│   ├── 20260528175539_create_categories.rb
│   ├── 20260528175707_create_equipment.rb
│   └── 20260528175719_create_maintenance_records.rb
├── schema.rb (auto-generated after migration)
└── seeds.rb

app/
└── models/
    ├── category.rb
    ├── equipment.rb
    └── maintenance_record.rb
```

---

## Testing the Setup

### Rails Console Commands
```ruby
# Open Rails console
rails console

# Check data
Category.count          # Should return 4
Equipment.count         # Should return 9
MaintenanceRecord.count # Should return 5

# Test associations
computing = Category.find_by(name: "Computing")
computing.equipment     # Returns all computing equipment

laptop = Equipment.find_by(serial_number: "DL-2024-001")
laptop.maintenance_records  # Returns maintenance history
laptop.category.name        # Returns "Computing"

# Test validations
Equipment.create!(name: "Test", serial_number: "DL-2024-001", category: computing)
# Should fail with uniqueness error on serial_number
```

---

## Notes for Team Members

1. **Pull this baseline first**: Run `git pull origin main` to get the complete database schema
2. **Run migrations**: Execute `rails db:migrate` after pulling
3. **Seed your local database**: Run `rails db:seed` to populate with test data
4. **Database is ready**: You can now build controllers, views, and APIs on top of this foundation

---

## Design Decisions

### Why these field names?
- `serial_number`: Industry standard for unique equipment identification
- `performed_at`: Clear datetime field for maintenance scheduling and history
- `description`: Flexible text field for detailed maintenance notes
- `status`: Simple string for equipment availability tracking

### Why these associations?
- **Category → Equipment**: One-to-many allows flexible categorization
- **Equipment → MaintenanceRecord**: One-to-many preserves complete maintenance history
- **Dependent destroy**: When equipment is deleted, its maintenance records are also removed (data integrity)
- **Dependent restrict**: Categories cannot be deleted if they have equipment (prevents orphaned records)

### Why composite index on maintenance_records?
- Optimizes common query: "Show me all maintenance for this equipment, ordered by date"
- Improves performance when filtering maintenance history by equipment and time range

---

## Completed by: Henok
**Role**: Database Architect & Seed Master  
**Date**: May 28, 2026
