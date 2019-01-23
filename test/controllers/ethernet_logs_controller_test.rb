require 'test_helper'

class EthernetLogsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @ethernet_log = ethernet_logs(:one)
  end

  test "should get index" do
    get ethernet_logs_url, as: :json
    assert_response :success
  end

  test "should create ethernet_log" do
    assert_difference('EthernetLog.count') do
      post ethernet_logs_url, params: { ethernet_log: { date: @ethernet_log.date, machine_id: @ethernet_log.machine_id, status: @ethernet_log.status } }, as: :json
    end

    assert_response 201
  end

  test "should show ethernet_log" do
    get ethernet_log_url(@ethernet_log), as: :json
    assert_response :success
  end

  test "should update ethernet_log" do
    patch ethernet_log_url(@ethernet_log), params: { ethernet_log: { date: @ethernet_log.date, machine_id: @ethernet_log.machine_id, status: @ethernet_log.status } }, as: :json
    assert_response 200
  end

  test "should destroy ethernet_log" do
    assert_difference('EthernetLog.count', -1) do
      delete ethernet_log_url(@ethernet_log), as: :json
    end

    assert_response 204
  end
end
