require 'test_helper'

class CncvendorsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @cncvendor = cncvendors(:one)
  end

  test "should get index" do
    get cncvendors_url, as: :json
    assert_response :success
  end

  test "should create cncvendor" do
    assert_difference('Cncvendor.count') do
      post cncvendors_url, params: { cncvendor: { cncoperation_id: @cncvendor.cncoperation_id, delivery_date: @cncvendor.delivery_date, email_id: @cncvendor.email_id, phone_number: @cncvendor.phone_number, quantity: @cncvendor.quantity, start_date: @cncvendor.start_date, tenant_id: @cncvendor.tenant_id, vendor_name: @cncvendor.vendor_name } }, as: :json
    end

    assert_response 201
  end

  test "should show cncvendor" do
    get cncvendor_url(@cncvendor), as: :json
    assert_response :success
  end

  test "should update cncvendor" do
    patch cncvendor_url(@cncvendor), params: { cncvendor: { cncoperation_id: @cncvendor.cncoperation_id, delivery_date: @cncvendor.delivery_date, email_id: @cncvendor.email_id, phone_number: @cncvendor.phone_number, quantity: @cncvendor.quantity, start_date: @cncvendor.start_date, tenant_id: @cncvendor.tenant_id, vendor_name: @cncvendor.vendor_name } }, as: :json
    assert_response 200
  end

  test "should destroy cncvendor" do
    assert_difference('Cncvendor.count', -1) do
      delete cncvendor_url(@cncvendor), as: :json
    end

    assert_response 204
  end
end
