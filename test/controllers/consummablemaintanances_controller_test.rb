require 'test_helper'

class ConsummablemaintanancesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @consummablemaintanance = consummablemaintanances(:one)
  end

  test "should get index" do
    get consummablemaintanances_url, as: :json
    assert_response :success
  end

  test "should create consummablemaintanance" do
    assert_difference('Consummablemaintanance.count') do
      post consummablemaintanances_url, params: { consummablemaintanance: { change_date: @consummablemaintanance.change_date, machine_id: @consummablemaintanance.machine_id, maintance_type: @consummablemaintanance.maintance_type, next_change_date: @consummablemaintanance.next_change_date, reason_for_change: @consummablemaintanance.reason_for_change, tenant_id: @consummablemaintanance.tenant_id } }, as: :json
    end

    assert_response 201
  end

  test "should show consummablemaintanance" do
    get consummablemaintanance_url(@consummablemaintanance), as: :json
    assert_response :success
  end

  test "should update consummablemaintanance" do
    patch consummablemaintanance_url(@consummablemaintanance), params: { consummablemaintanance: { change_date: @consummablemaintanance.change_date, machine_id: @consummablemaintanance.machine_id, maintance_type: @consummablemaintanance.maintance_type, next_change_date: @consummablemaintanance.next_change_date, reason_for_change: @consummablemaintanance.reason_for_change, tenant_id: @consummablemaintanance.tenant_id } }, as: :json
    assert_response 200
  end

  test "should destroy consummablemaintanance" do
    assert_difference('Consummablemaintanance.count', -1) do
      delete consummablemaintanance_url(@consummablemaintanance), as: :json
    end

    assert_response 204
  end
end
