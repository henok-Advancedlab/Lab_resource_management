require "test_helper"

class EquipmentControllerTest < ActionDispatch::IntegrationTest
  setup do
    @equipment = equipment(:one) # Laptop, available, category one
    @category = categories(:one)
  end

  test "index returns success ordered by name and includes category name" do
    get equipment_index_url
    assert_response :success
    body = JSON.parse(response.body)
    names = body.map { |e| e["name"] }
    assert_equal names.sort, names
    assert body.all? { |e| e.key?("category_name") }
  end

  test "index supports status filter" do
    get equipment_index_url(status: "available")
    assert_response :success
    body = JSON.parse(response.body)
    assert body.all? { |e| e["status"] == "available" }
  end

  test "show includes category and maintenance records" do
    get equipment_url(@equipment)
    assert_response :success
    body = JSON.parse(response.body)
    assert body.key?("category")
    assert body.key?("maintenance_records")
  end

  test "show returns 404 for missing equipment" do
    get equipment_url(id: 999_999)
    assert_response :not_found
  end

  test "create returns 201 with valid params" do
    assert_difference("Equipment.count", 1) do
      post equipment_index_url, params: {
        equipment: { name: "New Scope", serial_number: "NEW-100", status: "available", category_id: @category.id }
      }
    end
    assert_response :created
  end

  test "create returns 422 when category does not exist" do
    post equipment_index_url, params: {
      equipment: { name: "Orphan", serial_number: "ORP-001", status: "available", category_id: 999_999 }
    }
    assert_response :unprocessable_entity
  end

  test "create returns 422 for duplicate serial number" do
    post equipment_index_url, params: {
      equipment: { name: "Dupe", serial_number: @equipment.serial_number, status: "available", category_id: @category.id }
    }
    assert_response :unprocessable_entity
  end

  test "create returns 422 for invalid status" do
    post equipment_index_url, params: {
      equipment: { name: "Broken One", serial_number: "BRK-001", status: "broken", category_id: @category.id }
    }
    assert_response :unprocessable_entity
  end

  test "create returns 422 for malformed serial number" do
    post equipment_index_url, params: {
      equipment: { name: "Bad Serial", serial_number: "lap-1", status: "available", category_id: @category.id }
    }
    assert_response :unprocessable_entity
  end

  test "update returns 200" do
    patch equipment_url(@equipment), params: { equipment: { status: "maintenance" } }
    assert_response :success
  end

  test "destroy returns 204 and cascades maintenance records" do
    assert_difference("Equipment.count", -1) do
      delete equipment_url(@equipment)
    end
    assert_response :no_content
  end
end
