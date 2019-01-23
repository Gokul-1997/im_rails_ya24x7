require 'test_helper'

class CommonSettingsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @common_setting = common_settings(:one)
  end

  test "should get index" do
    get common_settings_url, as: :json
    assert_response :success
  end

  test "should create common_setting" do
    assert_difference('CommonSetting.count') do
      post common_settings_url, params: { common_setting: { setting_id: @common_setting.setting_id, setting_name: @common_setting.setting_name } }, as: :json
    end

    assert_response 201
  end

  test "should show common_setting" do
    get common_setting_url(@common_setting), as: :json
    assert_response :success
  end

  test "should update common_setting" do
    patch common_setting_url(@common_setting), params: { common_setting: { setting_id: @common_setting.setting_id, setting_name: @common_setting.setting_name } }, as: :json
    assert_response 200
  end

  test "should destroy common_setting" do
    assert_difference('CommonSetting.count', -1) do
      delete common_setting_url(@common_setting), as: :json
    end

    assert_response 204
  end
end
