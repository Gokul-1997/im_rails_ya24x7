require 'test_helper'

class ConnectionLogsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @connection_log = connection_logs(:one)
  end

  test "should get index" do
    get connection_logs_url, as: :json
    assert_response :success
  end

  test "should create connection_log" do
    assert_difference('ConnectionLog.count') do
      post connection_logs_url, params: { connection_log: { date: @connection_log.date, status: @connection_log.status, tenant_id: @connection_log.tenant_id } }, as: :json
    end

    assert_response 201
  end

  test "should show connection_log" do
    get connection_log_url(@connection_log), as: :json
    assert_response :success
  end

  test "should update connection_log" do
    patch connection_log_url(@connection_log), params: { connection_log: { date: @connection_log.date, status: @connection_log.status, tenant_id: @connection_log.tenant_id } }, as: :json
    assert_response 200
  end

  test "should destroy connection_log" do
    assert_difference('ConnectionLog.count', -1) do
      delete connection_log_url(@connection_log), as: :json
    end

    assert_response 204
  end
end
