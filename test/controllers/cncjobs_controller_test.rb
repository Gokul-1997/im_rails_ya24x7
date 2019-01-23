require 'test_helper'

class CncjobsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @cncjob = cncjobs(:one)
  end

  test "should get index" do
    get cncjobs_url, as: :json
    assert_response :success
  end

  test "should create cncjob" do
    assert_difference('Cncjob.count') do
      post cncjobs_url, params: { cncjob: { cncclient_id: @cncjob.cncclient_id, description: @cncjob.description, job_due_date: @cncjob.job_due_date, job_start_date: @cncjob.job_start_date, order_quantity: @cncjob.order_quantity, tenant_id: @cncjob.tenant_id } }, as: :json
    end

    assert_response 201
  end

  test "should show cncjob" do
    get cncjob_url(@cncjob), as: :json
    assert_response :success
  end

  test "should update cncjob" do
    patch cncjob_url(@cncjob), params: { cncjob: { cncclient_id: @cncjob.cncclient_id, description: @cncjob.description, job_due_date: @cncjob.job_due_date, job_start_date: @cncjob.job_start_date, order_quantity: @cncjob.order_quantity, tenant_id: @cncjob.tenant_id } }, as: :json
    assert_response 200
  end

  test "should destroy cncjob" do
    assert_difference('Cncjob.count', -1) do
      delete cncjob_url(@cncjob), as: :json
    end

    assert_response 204
  end
end
