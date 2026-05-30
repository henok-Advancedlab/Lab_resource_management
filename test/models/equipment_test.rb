require "test_helper"

class EquipmentTest < ActiveSupport::TestCase
  setup do
    @category = Category.create!(name: "Testing Lab")
  end

  def build_equipment(attrs = {})
    Equipment.new({ name: "Microscope", serial_number: "MIC-042", status: "available", category: @category }.merge(attrs))
  end

  test "valid with all valid attributes" do
    assert build_equipment.valid?
  end

  test "invalid without a name" do
    equipment = build_equipment(name: nil)
    assert_not equipment.valid?
    assert_includes equipment.errors[:name], "can't be blank"
  end

  test "invalid with a name shorter than 3 characters" do
    assert_not build_equipment(name: "AB").valid?
  end

  test "invalid when the name contains no letters" do
    [ "123", "!!!", "--" ].each do |bad|
      assert_not build_equipment(name: bad).valid?, "#{bad.inspect} should be invalid"
    end
  end

  test "accepts valid serial number formats" do
    # Three uppercase letters, a dash, three digits (matches the XXX-NNN rule).
    %w[MIC-042 ARD-999 ABC-123].each_with_index do |serial, i|
      equipment = build_equipment(serial_number: serial, name: "Device #{i}")
      assert equipment.valid?, "#{serial} should be valid: #{equipment.errors.full_messages}"
    end
  end

  test "rejects invalid serial number formats" do
    %w[lap-001 LAP01 LAP-1 LP-001].each do |serial|
      equipment = build_equipment(serial_number: serial)
      assert_not equipment.valid?, "#{serial} should be invalid"
      assert_includes equipment.errors[:serial_number], "must be in the format XXX-NNN"
    end
  end

  test "serial number must be unique" do
    build_equipment(serial_number: "ZZZ-999").save!
    dupe = build_equipment(serial_number: "ZZZ-999", name: "Another Device")
    assert_not dupe.valid?
    assert_includes dupe.errors[:serial_number], "has already been taken"
  end

  test "status must be one of available, in_use, maintenance" do
    %w[available in_use maintenance].each do |status|
      assert build_equipment(status: status).valid?, "#{status} should be valid"
    end
    invalid = build_equipment(status: "broken")
    assert_not invalid.valid?
    assert_includes invalid.errors[:status], "broken is not a valid status"
  end

  test "invalid without a category" do
    assert_not build_equipment(category: nil).valid?
  end

  test "destroying equipment cascades to its maintenance records" do
    equipment = build_equipment.tap(&:save!)
    equipment.maintenance_records.create!(performed_at: 1.day.ago, description: "Initial setup")

    assert_difference("MaintenanceRecord.count", -1) { equipment.destroy }
  end
end
