require "test_helper"

class EquipmentTest < ActiveSupport::TestCase
  test "should be valid with valid status" do
    category = Category.create!(name: "Testing")
    equipment = Equipment.new(
      name: "Laptop",
      serial_number: "ABC-123",
      status: "available",
      category: category
    )
    assert equipment.valid?
  end

  test "should be invalid with invalid status" do
    category = Category.create!(name: "Testing")
    equipment = Equipment.new(
      name: "Laptop",
      serial_number: "ABC-123",
      status: "broken",
      category: category
    )
    assert_not equipment.valid?
    assert_includes equipment.errors[:status], "broken is not a valid status"
  end
end
