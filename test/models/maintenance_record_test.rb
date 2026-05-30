require "test_helper"

class MaintenanceRecordTest < ActiveSupport::TestCase
  setup do
    category = Category.create!(name: "Optics Lab")
    @equipment = Equipment.create!(name: "Laser System", serial_number: "LAS-001", status: "available", category: category)
  end

  def build_record(attrs = {})
    MaintenanceRecord.new({ equipment: @equipment, performed_at: 1.day.ago, description: "Routine calibration" }.merge(attrs))
  end

  test "valid with equipment, a past performed_at, and a description" do
    assert build_record.valid?
  end

  test "invalid without a description" do
    record = build_record(description: nil)
    assert_not record.valid?
    assert_includes record.errors[:description], "can't be blank"
  end

  test "invalid without performed_at" do
    assert_not build_record(performed_at: nil).valid?
  end

  test "invalid when performed_at is in the future" do
    record = build_record(performed_at: 1.day.from_now)
    assert_not record.valid?
    assert_includes record.errors[:performed_at], "cannot be in the future"
  end

  test "valid when performed_at is now or earlier" do
    assert build_record(performed_at: Time.current).valid?
    assert build_record(performed_at: 1.year.ago).valid?
  end

  test "invalid without equipment" do
    assert_not build_record(equipment: nil).valid?
  end
end
