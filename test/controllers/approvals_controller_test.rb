require 'test_helper'

class ApprovalsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @approval = approvals(:one)
  end

  test "should get index" do
    get approvals_url, as: :json
    assert_response :success
  end

  test "should create approval" do
    assert_difference('Approval.count') do
      post approvals_url, params: { approval: { approval_status_name: @approval.approval_status_name, description: @approval.description } }, as: :json
    end

    assert_response 201
  end

  test "should show approval" do
    get approval_url(@approval), as: :json
    assert_response :success
  end

  test "should update approval" do
    patch approval_url(@approval), params: { approval: { approval_status_name: @approval.approval_status_name, description: @approval.description } }, as: :json
    assert_response 200
  end

  test "should destroy approval" do
    assert_difference('Approval.count', -1) do
      delete approval_url(@approval), as: :json
    end

    assert_response 204
  end
end
