require 'test_helper'

class MaintananceentriesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @maintananceentry = maintananceentries(:one)
  end

  test "should get index" do
    get maintananceentries_url, as: :json
    assert_response :success
  end

  test "should create maintananceentry" do
    assert_difference('Maintananceentry.count') do
      post maintananceentries_url, params: { maintananceentry: { machine_id: @maintananceentry.machine_id, maintanance_date: @maintananceentry.maintanance_date, maintanance_time: @maintananceentry.maintanance_time, maintanance_type: @maintananceentry.maintanance_type, remarks: @maintananceentry.remarks, service_engineer_name: @maintananceentry.service_engineer_name, tenant_id: @maintananceentry.tenant_id } }, as: :json
    end

    assert_response 201
  end

  test "should show maintananceentry" do
    get maintananceentry_url(@maintananceentry), as: :json
    assert_response :success
  end

  test "should update maintananceentry" do
    patch maintananceentry_url(@maintananceentry), params: { maintananceentry: { machine_id: @maintananceentry.machine_id, maintanance_date: @maintananceentry.maintanance_date, maintanance_time: @maintananceentry.maintanance_time, maintanance_type: @maintananceentry.maintanance_type, remarks: @maintananceentry.remarks, service_engineer_name: @maintananceentry.service_engineer_name, tenant_id: @maintananceentry.tenant_id } }, as: :json
    assert_response 200
  end

  test "should destroy maintananceentry" do
    assert_difference('Maintananceentry.count', -1) do
      delete maintananceentry_url(@maintananceentry), as: :json
    end

    assert_response 204
  end
end
