require 'test_helper'

class OperatorMappingAllocationsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @operator_mapping_allocation = operator_mapping_allocations(:one)
  end

  test "should get index" do
    get operator_mapping_allocations_url, as: :json
    assert_response :success
  end

  test "should create operator_mapping_allocation" do
    assert_difference('OperatorMappingAllocation.count') do
      post operator_mapping_allocations_url, params: { operator_mapping_allocation: {  } }, as: :json
    end

    assert_response 201
  end

  test "should show operator_mapping_allocation" do
    get operator_mapping_allocation_url(@operator_mapping_allocation), as: :json
    assert_response :success
  end

  test "should update operator_mapping_allocation" do
    patch operator_mapping_allocation_url(@operator_mapping_allocation), params: { operator_mapping_allocation: {  } }, as: :json
    assert_response 200
  end

  test "should destroy operator_mapping_allocation" do
    assert_difference('OperatorMappingAllocation.count', -1) do
      delete operator_mapping_allocation_url(@operator_mapping_allocation), as: :json
    end

    assert_response 204
  end
end
