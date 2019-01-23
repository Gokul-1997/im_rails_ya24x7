require 'test_helper'

class OperatorworkingdetailsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @operatorworkingdetail = operatorworkingdetails(:one)
  end

  test "should get index" do
    get operatorworkingdetails_url, as: :json
    assert_response :success
  end

  test "should create operatorworkingdetail" do
    assert_difference('Operatorworkingdetail.count') do
      post operatorworkingdetails_url, params: { operatorworkingdetail: { from_time: @operatorworkingdetail.from_time, machine_id: @operatorworkingdetail.machine_id, shifttransaction_id: @operatorworkingdetail.shifttransaction_id, tenant_id: @operatorworkingdetail.tenant_id, to_time: @operatorworkingdetail.to_time, user_id: @operatorworkingdetail.user_id, working_date: @operatorworkingdetail.working_date } }, as: :json
    end

    assert_response 201
  end

  test "should show operatorworkingdetail" do
    get operatorworkingdetail_url(@operatorworkingdetail), as: :json
    assert_response :success
  end

  test "should update operatorworkingdetail" do
    patch operatorworkingdetail_url(@operatorworkingdetail), params: { operatorworkingdetail: { from_time: @operatorworkingdetail.from_time, machine_id: @operatorworkingdetail.machine_id, shifttransaction_id: @operatorworkingdetail.shifttransaction_id, tenant_id: @operatorworkingdetail.tenant_id, to_time: @operatorworkingdetail.to_time, user_id: @operatorworkingdetail.user_id, working_date: @operatorworkingdetail.working_date } }, as: :json
    assert_response 200
  end

  test "should destroy operatorworkingdetail" do
    assert_difference('Operatorworkingdetail.count', -1) do
      delete operatorworkingdetail_url(@operatorworkingdetail), as: :json
    end

    assert_response 204
  end
end
