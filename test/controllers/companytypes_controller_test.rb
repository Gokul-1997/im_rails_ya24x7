require 'test_helper'

class CompanytypesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @companytype = companytypes(:one)
  end

  test "should get index" do
    get companytypes_url, as: :json
    assert_response :success
  end

  test "should create companytype" do
    assert_difference('Companytype.count') do
      post companytypes_url, params: { companytype: { companytype_name: @companytype.companytype_name, description: @companytype.description } }, as: :json
    end

    assert_response 201
  end

  test "should show companytype" do
    get companytype_url(@companytype), as: :json
    assert_response :success
  end

  test "should update companytype" do
    patch companytype_url(@companytype), params: { companytype: { companytype_name: @companytype.companytype_name, description: @companytype.description } }, as: :json
    assert_response 200
  end

  test "should destroy companytype" do
    assert_difference('Companytype.count', -1) do
      delete companytype_url(@companytype), as: :json
    end

    assert_response 204
  end
end
