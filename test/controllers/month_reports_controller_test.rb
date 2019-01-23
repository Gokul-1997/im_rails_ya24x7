require 'test_helper'

class MonthReportsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @month_report = month_reports(:one)
  end

  test "should get index" do
    get month_reports_url, as: :json
    assert_response :success
  end

  test "should create month_report" do
    assert_difference('MonthReport.count') do
      post month_reports_url, params: { month_report: {  } }, as: :json
    end

    assert_response 201
  end

  test "should show month_report" do
    get month_report_url(@month_report), as: :json
    assert_response :success
  end

  test "should update month_report" do
    patch month_report_url(@month_report), params: { month_report: {  } }, as: :json
    assert_response 200
  end

  test "should destroy month_report" do
    assert_difference('MonthReport.count', -1) do
      delete month_report_url(@month_report), as: :json
    end

    assert_response 204
  end
end
