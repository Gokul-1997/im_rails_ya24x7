require 'test_helper'

class UsertypesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @usertype = usertypes(:one)
  end

  test "should get index" do
    get usertypes_url, as: :json
    assert_response :success
  end

  test "should create usertype" do
    assert_difference('Usertype.count') do
      post usertypes_url, params: { usertype: { description: @usertype.description, usertype_name: @usertype.usertype_name } }, as: :json
    end

    assert_response 201
  end

  test "should show usertype" do
    get usertype_url(@usertype), as: :json
    assert_response :success
  end

  test "should update usertype" do
    patch usertype_url(@usertype), params: { usertype: { description: @usertype.description, usertype_name: @usertype.usertype_name } }, as: :json
    assert_response 200
  end

  test "should destroy usertype" do
    assert_difference('Usertype.count', -1) do
      delete usertype_url(@usertype), as: :json
    end

    assert_response 204
  end
end
