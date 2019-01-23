require 'test_helper'

class DeliverytypesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @deliverytype = deliverytypes(:one)
  end

  test "should get index" do
    get deliverytypes_url, as: :json
    assert_response :success
  end

  test "should create deliverytype" do
    assert_difference('Deliverytype.count') do
      post deliverytypes_url, params: { deliverytype: { deliverytype_name: @deliverytype.deliverytype_name, description: @deliverytype.description } }, as: :json
    end

    assert_response 201
  end

  test "should show deliverytype" do
    get deliverytype_url(@deliverytype), as: :json
    assert_response :success
  end

  test "should update deliverytype" do
    patch deliverytype_url(@deliverytype), params: { deliverytype: { deliverytype_name: @deliverytype.deliverytype_name, description: @deliverytype.description } }, as: :json
    assert_response 200
  end

  test "should destroy deliverytype" do
    assert_difference('Deliverytype.count', -1) do
      delete deliverytype_url(@deliverytype), as: :json
    end

    assert_response 204
  end
end
