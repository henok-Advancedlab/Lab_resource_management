require "test_helper"

class MaintenanceRecordsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @record = maintenance_records(:one)
    @equipment = equipment(:one)
  end

  test "index returns success" do
    get maintenance_records_url
    assert_response :success
  end

  test "index supports equipment_id filter" do
    get maintenance_records_url(equipment_id: @equipment.id)
    assert_response :success
    body = JSON.parse(response.body)
    assert body.all? { |r| r["equipment_id"] == @equipment.id }
  end

  test "show returns success" do
    get maintenance_record_url(@record)
    assert_response :success
  end

  test "show returns 404 for missing record" do
    get maintenance_record_url(id: 999_999)
    assert_response :not_found
  end

  test "create returns 201 with valid params" do
    assert_difference("MaintenanceRecord.count", 1) do
      post maintenance_records_url, params: {
        maintenance_record: { equipment_id: @equipment.id, performed_at: 1.day.ago, description: "Routine check" }
      }
    end
    assert_response :created
  end

  test "create returns 422 when equipment does not exist" do
    post maintenance_records_url, params: {
      maintenance_record: { equipment_id: 999_999, performed_at: 1.day.ago, description: "Routine check" }
    }
    assert_response :unprocessable_entity
  end

  test "create returns 422 when performed_at is in the future" do
    post maintenance_records_url, params: {
      maintenance_record: { equipment_id: @equipment.id, performed_at: 1.week.from_now, description: "Time travel" }
    }
    assert_response :unprocessable_entity
  end

  test "update returns 200" do
    patch maintenance_record_url(@record), params: {
      maintenance_record: { description: "Updated description" }
    }
    assert_response :success
  end

  test "destroy returns 204" do
    assert_difference("MaintenanceRecord.count", -1) do
      delete maintenance_record_url(@record)
    end
    assert_response :no_content
  end
end
