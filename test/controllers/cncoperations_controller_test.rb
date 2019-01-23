require 'test_helper'

class CncoperationsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @cncoperation = cncoperations(:one)
  end

  test "should get index" do
    get cncoperations_url, as: :json
    assert_response :success
  end

  test "should create cncoperation" do
    assert_difference('Cncoperation.count') do
      post cncoperations_url, params: { cncoperation: { cncjob_id: @cncoperation.cncjob_id, description: @cncoperation.description, operation_name: @cncoperation.operation_name, plan_status: @cncoperation.plan_status, tenant_id: @cncoperation.tenant_id } }, as: :json
    end

    assert_response 201
  end

  test "should show cncoperation" do
    get cncoperation_url(@cncoperation), as: :json
    assert_response :success
  end

  test "should update cncoperation" do
    patch cncoperation_url(@cncoperation), params: { cncoperation: { cncjob_id: @cncoperation.cncjob_id, description: @cncoperation.description, operation_name: @cncoperation.operation_name, plan_status: @cncoperation.plan_status, tenant_id: @cncoperation.tenant_id } }, as: :json
    assert_response 200
  end

  test "should destroy cncoperation" do
    assert_difference('Cncoperation.count', -1) do
      delete cncoperation_url(@cncoperation), as: :json
    end

    assert_response 204
  end
end
