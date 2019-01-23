require 'test_helper'

class HmiReasonsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @hmi_reason = hmi_reasons(:one)
  end

  test "should get index" do
    get hmi_reasons_url, as: :json
    assert_response :success
  end

  test "should create hmi_reason" do
    assert_difference('HmiReason.count') do
      post hmi_reasons_url, params: { hmi_reason: { image_path: @hmi_reason.image_path, is_active: @hmi_reason.is_active, name: @hmi_reason.name } }, as: :json
    end

    assert_response 201
  end

  test "should show hmi_reason" do
    get hmi_reason_url(@hmi_reason), as: :json
    assert_response :success
  end

  test "should update hmi_reason" do
    patch hmi_reason_url(@hmi_reason), params: { hmi_reason: { image_path: @hmi_reason.image_path, is_active: @hmi_reason.is_active, name: @hmi_reason.name } }, as: :json
    assert_response 200
  end

  test "should destroy hmi_reason" do
    assert_difference('HmiReason.count', -1) do
      delete hmi_reason_url(@hmi_reason), as: :json
    end

    assert_response 204
  end
end
