require 'test_helper'

class PlannedmaintanancesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @plannedmaintanance = plannedmaintanances(:one)
  end

  test "should get index" do
    get plannedmaintanances_url, as: :json
    assert_response :success
  end

  test "should create plannedmaintanance" do
    assert_difference('Plannedmaintanance.count') do
      post plannedmaintanances_url, params: { plannedmaintanance: { duration_from: @plannedmaintanance.duration_from, duration_to: @plannedmaintanance.duration_to, expire_date: @plannedmaintanance.expire_date, machine_id: @plannedmaintanance.machine_id, maintanance_type: @plannedmaintanance.maintanance_type, remarks: @plannedmaintanance.remarks, supplier_name: @plannedmaintanance.supplier_name, tenant_id: @plannedmaintanance.tenant_id } }, as: :json
    end

    assert_response 201
  end

  test "should show plannedmaintanance" do
    get plannedmaintanance_url(@plannedmaintanance), as: :json
    assert_response :success
  end

  test "should update plannedmaintanance" do
    patch plannedmaintanance_url(@plannedmaintanance), params: { plannedmaintanance: { duration_from: @plannedmaintanance.duration_from, duration_to: @plannedmaintanance.duration_to, expire_date: @plannedmaintanance.expire_date, machine_id: @plannedmaintanance.machine_id, maintanance_type: @plannedmaintanance.maintanance_type, remarks: @plannedmaintanance.remarks, supplier_name: @plannedmaintanance.supplier_name, tenant_id: @plannedmaintanance.tenant_id } }, as: :json
    assert_response 200
  end

  test "should destroy plannedmaintanance" do
    assert_difference('Plannedmaintanance.count', -1) do
      delete plannedmaintanance_url(@plannedmaintanance), as: :json
    end

    assert_response 204
  end
end
