require 'test_helper'

class UserslogsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @userslog = userslogs(:one)
  end

  test "should get index" do
    get userslogs_url, as: :json
    assert_response :success
  end

  test "should create userslog" do
    assert_difference('Userslog.count') do
      post userslogs_url, params: { userslog: { approval_id: @userslog.approval_id, email_id: @userslog.email_id, first_name: @userslog.first_name, last_name: @userslog.last_name, password: @userslog.password, phone_number: @userslog.phone_number, remarks: @userslog.remarks, role_id: @userslog.role_id, tenant_id: @userslog.tenant_id, user_id: @userslog.user_id, usertype_id: @userslog.usertype_id } }, as: :json
    end

    assert_response 201
  end

  test "should show userslog" do
    get userslog_url(@userslog), as: :json
    assert_response :success
  end

  test "should update userslog" do
    patch userslog_url(@userslog), params: { userslog: { approval_id: @userslog.approval_id, email_id: @userslog.email_id, first_name: @userslog.first_name, last_name: @userslog.last_name, password: @userslog.password, phone_number: @userslog.phone_number, remarks: @userslog.remarks, role_id: @userslog.role_id, tenant_id: @userslog.tenant_id, user_id: @userslog.user_id, usertype_id: @userslog.usertype_id } }, as: :json
    assert_response 200
  end

  test "should destroy userslog" do
    assert_difference('Userslog.count', -1) do
      delete userslog_url(@userslog), as: :json
    end

    assert_response 204
  end
end
