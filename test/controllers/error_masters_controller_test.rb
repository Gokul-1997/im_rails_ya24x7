require 'test_helper'

class ErrorMastersControllerTest < ActionDispatch::IntegrationTest
  setup do
    @error_master = error_masters(:one)
  end

  test "should get index" do
    get error_masters_url, as: :json
    assert_response :success
  end

  test "should create error_master" do
    assert_difference('ErrorMaster.count') do
      post error_masters_url, params: { error_master: { description: @error_master.description, error_code: @error_master.error_code, message: @error_master.message } }, as: :json
    end

    assert_response 201
  end

  test "should show error_master" do
    get error_master_url(@error_master), as: :json
    assert_response :success
  end

  test "should update error_master" do
    patch error_master_url(@error_master), params: { error_master: { description: @error_master.description, error_code: @error_master.error_code, message: @error_master.message } }, as: :json
    assert_response 200
  end

  test "should destroy error_master" do
    assert_difference('ErrorMaster.count', -1) do
      delete error_master_url(@error_master), as: :json
    end

    assert_response 204
  end
end
