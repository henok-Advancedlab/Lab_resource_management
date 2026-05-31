require "test_helper"

class CategoryTest < ActiveSupport::TestCase
  test "valid with a name of at least 3 characters" do
    assert Category.new(name: "Optics").valid?
  end

  test "invalid without a name" do
    category = Category.new(name: nil)
    assert_not category.valid?
    assert_includes category.errors[:name], "can't be blank"
  end

  test "invalid with a name shorter than 3 characters" do
    [ "AB", "A", "" ].each do |bad|
      assert_not Category.new(name: bad).valid?, "#{bad.inspect} should be invalid"
    end
  end

  test "name must be unique" do
    Category.create!(name: "Computing")
    dupe = Category.new(name: "Computing")
    assert_not dupe.valid?
    assert_includes dupe.errors[:name], "has already been taken"
  end

  test "has many equipment" do
    assert_respond_to Category.new, :equipment
  end

  test "cannot be destroyed while equipment still references it" do
    category = Category.create!(name: "Networking")
    category.equipment.create!(name: "Router", serial_number: "RTR-001", status: "available")

    assert_no_difference("Category.count") { category.destroy }
    assert category.errors[:base].present?, "expected a restrict_with_error message on :base"
  end
end
