require 'test_helper'

class AlarmCodesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @alarm_code = alarm_codes(:one)
  end

  test "should get index" do
    get alarm_codes_url, as: :json
    assert_response :success
  end

  test "should create alarm_code" do
    assert_difference('AlarmCode.count') do
      post alarm_codes_url, params: { alarm_code: { code: @alarm_code.code, description: @alarm_code.description } }, as: :json
    end

    assert_response 201
  end

  test "should show alarm_code" do
    get alarm_code_url(@alarm_code), as: :json
    assert_response :success
  end

  test "should update alarm_code" do
    patch alarm_code_url(@alarm_code), params: { alarm_code: { code: @alarm_code.code, description: @alarm_code.description } }, as: :json
    assert_response 200
  end

  test "should destroy alarm_code" do
    assert_difference('AlarmCode.count', -1) do
      delete alarm_code_url(@alarm_code), as: :json
    end

    assert_response 204
  end
end
