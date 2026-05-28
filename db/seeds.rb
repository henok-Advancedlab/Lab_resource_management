# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).

# Clear existing data (in reverse order of dependencies)
puts "Clearing existing data..."
MaintenanceRecord.destroy_all
Equipment.destroy_all
Category.destroy_all

# Create Categories
puts "Creating categories..."
computing = Category.create!(name: "Computing")
optics = Category.create!(name: "Optics")
networking = Category.create!(name: "Networking")
electronics = Category.create!(name: "Electronics")

puts "Created #{Category.count} categories"

# Create Equipment (8+ items across different statuses and categories)
puts "Creating equipment..."

# Computing equipment
laptop1 = Equipment.create!(
  name: "Dell Latitude 5520",
  serial_number: "DL-2024-001",
  status: "available",
  category: computing
)

desktop1 = Equipment.create!(
  name: "HP EliteDesk 800",
  serial_number: "HP-2024-002",
  status: "checked_out",
  category: computing
)

# Optics equipment
microscope1 = Equipment.create!(
  name: "Olympus BX53 Microscope",
  serial_number: "OLY-2024-003",
  status: "available",
  category: optics
)

laser1 = Equipment.create!(
  name: "HeNe Laser System",
  serial_number: "LAS-2024-004",
  status: "maintenance",
  category: optics
)

# Networking equipment
router1 = Equipment.create!(
  name: "Cisco Catalyst 2960",
  serial_number: "CSC-2024-005",
  status: "available",
  category: networking
)

switch1 = Equipment.create!(
  name: "Netgear ProSafe GS108",
  serial_number: "NET-2024-006",
  status: "checked_out",
  category: networking
)

# Electronics equipment
oscilloscope1 = Equipment.create!(
  name: "Tektronix TBS1052B",
  serial_number: "TEK-2024-007",
  status: "available",
  category: electronics
)

multimeter1 = Equipment.create!(
  name: "Fluke 87V Multimeter",
  serial_number: "FLU-2024-008",
  status: "retired",
  category: electronics
)

power_supply1 = Equipment.create!(
  name: "BK Precision 1685B",
  serial_number: "BKP-2024-009",
  status: "maintenance",
  category: electronics
)

puts "Created #{Equipment.count} equipment items"

# Create Maintenance Records (5+ records across 3 different equipment items)
puts "Creating maintenance records..."

# Maintenance for laptop1
MaintenanceRecord.create!(
  equipment: laptop1,
  performed_at: 2.months.ago,
  description: "Replaced battery and updated BIOS firmware. System running optimally."
)

MaintenanceRecord.create!(
  equipment: laptop1,
  performed_at: 1.week.ago,
  description: "Cleaned cooling fans and applied new thermal paste. Temperature readings normal."
)

# Maintenance for laser1
MaintenanceRecord.create!(
  equipment: laser1,
  performed_at: 3.weeks.ago,
  description: "Calibrated laser alignment and replaced optical filters. Power output verified."
)

MaintenanceRecord.create!(
  equipment: laser1,
  performed_at: 5.days.ago,
  description: "Safety inspection completed. All interlocks functioning properly."
)

# Maintenance for oscilloscope1
MaintenanceRecord.create!(
  equipment: oscilloscope1,
  performed_at: 1.month.ago,
  description: "Annual calibration performed. All channels within specification."
)

puts "Created #{MaintenanceRecord.count} maintenance records"

puts "\n=== Seed Data Summary ==="
puts "Categories: #{Category.count}"
puts "Equipment: #{Equipment.count}"
puts "  - Available: #{Equipment.where(status: 'available').count}"
puts "  - Checked Out: #{Equipment.where(status: 'checked_out').count}"
puts "  - Maintenance: #{Equipment.where(status: 'maintenance').count}"
puts "  - Retired: #{Equipment.where(status: 'retired').count}"
puts "Maintenance Records: #{MaintenanceRecord.count}"
puts "\nEquipment with no maintenance history:"
Equipment.left_joins(:maintenance_records)
         .where(maintenance_records: { id: nil })
         .each { |e| puts "  - #{e.name} (#{e.serial_number})" }
puts "\nSeeding completed successfully!"
