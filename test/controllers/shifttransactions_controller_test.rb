require 'test_helper'

class ShifttransactionsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @shifttransaction = shifttransactions(:one)
  end

  test "should get index" do
    get shifttransactions_url, as: :json
    assert_response :success
  end

  test "should create shifttransaction" do
    assert_difference('Shifttransaction.count') do
      post shifttransactions_url, params: { shifttransaction: { actual_working_hours: @shifttransaction.actual_working_hours, shift_end_time: @shifttransaction.shift_end_time, shift_id: @shifttransaction.shift_id, shift_start_time: @shifttransaction.shift_start_time } }, as: :json
    end

    assert_response 201
  end

  test "should show shifttransaction" do
    get shifttransaction_url(@shifttransaction), as: :json
    assert_response :success
  end

  test "should update shifttransaction" do
    patch shifttransaction_url(@shifttransaction), params: { shifttransaction: { actual_working_hours: @shifttransaction.actual_working_hours, shift_end_time: @shifttransaction.shift_end_time, shift_id: @shifttransaction.shift_id, shift_start_time: @shifttransaction.shift_start_time } }, as: :json
    assert_response 200
  end

  test "should destroy shifttransaction" do
    assert_difference('Shifttransaction.count', -1) do
      delete shifttransaction_url(@shifttransaction), as: :json
    end

    assert_response 204
  end
end
