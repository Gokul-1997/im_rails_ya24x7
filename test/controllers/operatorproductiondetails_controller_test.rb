require 'test_helper'

class OperatorproductiondetailsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @operatorproductiondetail = operatorproductiondetails(:one)
  end

  test "should get index" do
    get operatorproductiondetails_url, as: :json
    assert_response :success
  end

  test "should create operatorproductiondetail" do
    assert_difference('Operatorproductiondetail.count') do
      post operatorproductiondetails_url, params: { operatorproductiondetail: { last_machine_reset_time: @operatorproductiondetail.last_machine_reset_time, no_of_parts_produced: @operatorproductiondetail.no_of_parts_produced, no_of_rejects: @operatorproductiondetail.no_of_rejects, operatorworkingdetail_id: @operatorproductiondetail.operatorworkingdetail_id, parts_moved_to_next_operation: @operatorproductiondetail.parts_moved_to_next_operation, reason_for_down_time: @operatorproductiondetail.reason_for_down_time, remarks: @operatorproductiondetail.remarks, tenant_id: @operatorproductiondetail.tenant_id, total_down_time: @operatorproductiondetail.total_down_time } }, as: :json
    end

    assert_response 201
  end

  test "should show operatorproductiondetail" do
    get operatorproductiondetail_url(@operatorproductiondetail), as: :json
    assert_response :success
  end

  test "should update operatorproductiondetail" do
    patch operatorproductiondetail_url(@operatorproductiondetail), params: { operatorproductiondetail: { last_machine_reset_time: @operatorproductiondetail.last_machine_reset_time, no_of_parts_produced: @operatorproductiondetail.no_of_parts_produced, no_of_rejects: @operatorproductiondetail.no_of_rejects, operatorworkingdetail_id: @operatorproductiondetail.operatorworkingdetail_id, parts_moved_to_next_operation: @operatorproductiondetail.parts_moved_to_next_operation, reason_for_down_time: @operatorproductiondetail.reason_for_down_time, remarks: @operatorproductiondetail.remarks, tenant_id: @operatorproductiondetail.tenant_id, total_down_time: @operatorproductiondetail.total_down_time } }, as: :json
    assert_response 200
  end

  test "should destroy operatorproductiondetail" do
    assert_difference('Operatorproductiondetail.count', -1) do
      delete operatorproductiondetail_url(@operatorproductiondetail), as: :json
    end

    assert_response 204
  end
end
