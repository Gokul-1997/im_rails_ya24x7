require 'test_helper'

class DeviceTypesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @device_type = device_types(:one)
  end

  test "should get index" do
    get device_types_url, as: :json
    assert_response :success
  end

  test "should create device_type" do
    assert_difference('DeviceType.count') do
      post device_types_url, params: { device_type: { count: @device_type.count, created_by: @device_type.created_by, deleted_at: @device_type.deleted_at, name: @device_type.name, per_pic_price: @device_type.per_pic_price, purchase_date: @device_type.purchase_date, total_price: @device_type.total_price, updated_by: @device_type.updated_by } }, as: :json
    end

    assert_response 201
  end

  test "should show device_type" do
    get device_type_url(@device_type), as: :json
    assert_response :success
  end

  test "should update device_type" do
    patch device_type_url(@device_type), params: { device_type: { count: @device_type.count, created_by: @device_type.created_by, deleted_at: @device_type.deleted_at, name: @device_type.name, per_pic_price: @device_type.per_pic_price, purchase_date: @device_type.purchase_date, total_price: @device_type.total_price, updated_by: @device_type.updated_by } }, as: :json
    assert_response 200
  end

  test "should destroy device_type" do
    assert_difference('DeviceType.count', -1) do
      delete device_type_url(@device_type), as: :json
    end

    assert_response 204
  end
end
