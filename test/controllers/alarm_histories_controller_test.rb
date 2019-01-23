require 'test_helper'

class AlarmHistoriesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @alarm_history = alarm_histories(:one)
  end

  test "should get index" do
    get alarm_histories_url, as: :json
    assert_response :success
  end

  test "should create alarm_history" do
    assert_difference('AlarmHistory.count') do
      post alarm_histories_url, params: { alarm_history: { alarm_no: @alarm_history.alarm_no, alarm_status: @alarm_history.alarm_status, alarm_type: @alarm_history.alarm_type, axis_no: @alarm_history.axis_no, machine_id: @alarm_history.machine_id, message: @alarm_history.message, time: @alarm_history.time } }, as: :json
    end

    assert_response 201
  end

  test "should show alarm_history" do
    get alarm_history_url(@alarm_history), as: :json
    assert_response :success
  end

  test "should update alarm_history" do
    patch alarm_history_url(@alarm_history), params: { alarm_history: { alarm_no: @alarm_history.alarm_no, alarm_status: @alarm_history.alarm_status, alarm_type: @alarm_history.alarm_type, axis_no: @alarm_history.axis_no, machine_id: @alarm_history.machine_id, message: @alarm_history.message, time: @alarm_history.time } }, as: :json
    assert_response 200
  end

  test "should destroy alarm_history" do
    assert_difference('AlarmHistory.count', -1) do
      delete alarm_history_url(@alarm_history), as: :json
    end

    assert_response 204
  end
end
