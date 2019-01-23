require 'test_helper'

class PlanstatusesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @planstatus = planstatuses(:one)
  end

  test "should get index" do
    get planstatuses_url, as: :json
    assert_response :success
  end

  test "should create planstatus" do
    assert_difference('Planstatus.count') do
      post planstatuses_url, params: { planstatus: { description: @planstatus.description, planstatus_name: @planstatus.planstatus_name } }, as: :json
    end

    assert_response 201
  end

  test "should show planstatus" do
    get planstatus_url(@planstatus), as: :json
    assert_response :success
  end

  test "should update planstatus" do
    patch planstatus_url(@planstatus), params: { planstatus: { description: @planstatus.description, planstatus_name: @planstatus.planstatus_name } }, as: :json
    assert_response 200
  end

  test "should destroy planstatus" do
    assert_difference('Planstatus.count', -1) do
      delete planstatus_url(@planstatus), as: :json
    end

    assert_response 204
  end
end
