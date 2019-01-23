require 'test_helper'

class CtMachineLogsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @ct_machine_log = ct_machine_logs(:one)
  end

  test "should get index" do
    get ct_machine_logs_url, as: :json
    assert_response :success
  end

  test "should create ct_machine_log" do
    assert_difference('CtMachineLog.count') do
      post ct_machine_logs_url, params: { ct_machine_log: { from_date: @ct_machine_log.from_date, heart_beat: @ct_machine_log.heart_beat, machine_id: @ct_machine_log.machine_id, reason: @ct_machine_log.reason, status: @ct_machine_log.status, to_date: @ct_machine_log.to_date, uptime: @ct_machine_log.uptime } }, as: :json
    end

    assert_response 201
  end

  test "should show ct_machine_log" do
    get ct_machine_log_url(@ct_machine_log), as: :json
    assert_response :success
  end

  test "should update ct_machine_log" do
    patch ct_machine_log_url(@ct_machine_log), params: { ct_machine_log: { from_date: @ct_machine_log.from_date, heart_beat: @ct_machine_log.heart_beat, machine_id: @ct_machine_log.machine_id, reason: @ct_machine_log.reason, status: @ct_machine_log.status, to_date: @ct_machine_log.to_date, uptime: @ct_machine_log.uptime } }, as: :json
    assert_response 200
  end

  test "should destroy ct_machine_log" do
    assert_difference('CtMachineLog.count', -1) do
      delete ct_machine_log_url(@ct_machine_log), as: :json
    end

    assert_response 204
  end
end
