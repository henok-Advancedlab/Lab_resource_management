require "test_helper"

class CategoriesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @category = categories(:one) # has equipment(:one) referencing it
  end

  test "index returns success ordered by name" do
    get categories_url
    assert_response :success
    names = JSON.parse(response.body).map { |c| c["name"] }
    assert_equal names.sort, names
  end

  test "show returns success and includes equipment_count" do
    get category_url(@category)
    assert_response :success
    body = JSON.parse(response.body)
    assert_equal @category.equipment.count, body["equipment_count"]
  end

  test "show returns 404 for missing category" do
    get category_url(id: 999_999)
    assert_response :not_found
  end

  test "create returns 201 with valid params" do
    assert_difference("Category.count", 1) do
      post categories_url, params: { category: { name: "Robotics" } }
    end
    assert_response :created
  end

  test "create returns 422 for duplicate name" do
    post categories_url, params: { category: { name: @category.name } }
    assert_response :unprocessable_entity
  end

  test "create returns 422 for name shorter than 3 characters" do
    post categories_url, params: { category: { name: "AB" } }
    assert_response :unprocessable_entity
  end

  test "update returns 200" do
    patch category_url(@category), params: { category: { name: "Renamed Category" } }
    assert_response :success
  end

  test "update returns 404 for missing category" do
    patch category_url(id: 999_999), params: { category: { name: "Nope" } }
    assert_response :not_found
  end

  test "destroy returns 409 when equipment still references the category" do
    assert_no_difference("Category.count") do
      delete category_url(@category)
    end
    assert_response :conflict
    assert JSON.parse(response.body)["error"].include?("Cannot delete category")
  end

  test "destroy returns 204 when no equipment references the category" do
    empty = Category.create!(name: "Empty Category")
    assert_difference("Category.count", -1) do
      delete category_url(empty)
    end
    assert_response :no_content
  end
end
