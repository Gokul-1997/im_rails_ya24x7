require 'test_helper'

class MachineSeriesNosControllerTest < ActionDispatch::IntegrationTest
  setup do
    @machine_series_no = machine_series_nos(:one)
  end

  test "should get index" do
    get machine_series_nos_url, as: :json
    assert_response :success
  end

  test "should create machine_series_no" do
    assert_difference('MachineSeriesNo.count') do
      post machine_series_nos_url, params: { machine_series_no: { controller_name: @machine_series_no.controller_name, number: @machine_series_no.number } }, as: :json
    end

    assert_response 201
  end

  test "should show machine_series_no" do
    get machine_series_no_url(@machine_series_no), as: :json
    assert_response :success
  end

  test "should update machine_series_no" do
    patch machine_series_no_url(@machine_series_no), params: { machine_series_no: { controller_name: @machine_series_no.controller_name, number: @machine_series_no.number } }, as: :json
    assert_response 200
  end

  test "should destroy machine_series_no" do
    assert_difference('MachineSeriesNo.count', -1) do
      delete machine_series_no_url(@machine_series_no), as: :json
    end

    assert_response 204
  end
end
