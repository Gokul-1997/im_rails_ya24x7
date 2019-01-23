require 'test_helper'

class CnctoolsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @cnctool = cnctools(:one)
  end

  test "should get index" do
    get cnctools_url, as: :json
    assert_response :success
  end

  test "should create cnctool" do
    assert_difference('Cnctool.count') do
      post cnctools_url, params: { cnctool: { machine_id: @cnctool.machine_id, material_string: @cnctool.material_string, no_of_parts: @cnctool.no_of_parts, produced_count: @cnctool.produced_count, tenant_id: @cnctool.tenant_id, tool_name: @cnctool.tool_name } }, as: :json
    end

    assert_response 201
  end

  test "should show cnctool" do
    get cnctool_url(@cnctool), as: :json
    assert_response :success
  end

  test "should update cnctool" do
    patch cnctool_url(@cnctool), params: { cnctool: { machine_id: @cnctool.machine_id, material_string: @cnctool.material_string, no_of_parts: @cnctool.no_of_parts, produced_count: @cnctool.produced_count, tenant_id: @cnctool.tenant_id, tool_name: @cnctool.tool_name } }, as: :json
    assert_response 200
  end

  test "should destroy cnctool" do
    assert_difference('Cnctool.count', -1) do
      delete cnctool_url(@cnctool), as: :json
    end

    assert_response 204
  end
end
