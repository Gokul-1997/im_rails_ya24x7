require 'test_helper'

class MenuconfigurationsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @menuconfiguration = menuconfigurations(:one)
  end

  test "should get index" do
    get menuconfigurations_url, as: :json
    assert_response :success
  end

  test "should create menuconfiguration" do
    assert_difference('Menuconfiguration.count') do
      post menuconfigurations_url, params: { menuconfiguration: { page_id: @menuconfiguration.page_id, pageauthorization_id: @menuconfiguration.pageauthorization_id, role_id: @menuconfiguration.role_id, tenant_id: @menuconfiguration.tenant_id } }, as: :json
    end

    assert_response 201
  end

  test "should show menuconfiguration" do
    get menuconfiguration_url(@menuconfiguration), as: :json
    assert_response :success
  end

  test "should update menuconfiguration" do
    patch menuconfiguration_url(@menuconfiguration), params: { menuconfiguration: { page_id: @menuconfiguration.page_id, pageauthorization_id: @menuconfiguration.pageauthorization_id, role_id: @menuconfiguration.role_id, tenant_id: @menuconfiguration.tenant_id } }, as: :json
    assert_response 200
  end

  test "should destroy menuconfiguration" do
    assert_difference('Menuconfiguration.count', -1) do
      delete menuconfiguration_url(@menuconfiguration), as: :json
    end

    assert_response 204
  end
end
