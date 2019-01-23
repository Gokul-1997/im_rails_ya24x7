require 'test_helper'

class CncclientsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @cncclient = cncclients(:one)
  end

  test "should get index" do
    get cncclients_url, as: :json
    assert_response :success
  end

  test "should create cncclient" do
    assert_difference('Cncclient.count') do
      post cncclients_url, params: { cncclient: { client_name: @cncclient.client_name, email_id: @cncclient.email_id, phone_number: @cncclient.phone_number, tenant_id: @cncclient.tenant_id } }, as: :json
    end

    assert_response 201
  end

  test "should show cncclient" do
    get cncclient_url(@cncclient), as: :json
    assert_response :success
  end

  test "should update cncclient" do
    patch cncclient_url(@cncclient), params: { cncclient: { client_name: @cncclient.client_name, email_id: @cncclient.email_id, phone_number: @cncclient.phone_number, tenant_id: @cncclient.tenant_id } }, as: :json
    assert_response 200
  end

  test "should destroy cncclient" do
    assert_difference('Cncclient.count', -1) do
      delete cncclient_url(@cncclient), as: :json
    end

    assert_response 204
  end
end
