require 'test_helper'

class BreakTimesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @break_time = break_times(:one)
  end

  test "should get index" do
    get break_times_url, as: :json
    assert_response :success
  end

  test "should create break_time" do
    assert_difference('BreakTime.count') do
      post break_times_url, params: { break_time: { end_time: @break_time.end_time, reasion: @break_time.reasion, shifttransaction_id: @break_time.shifttransaction_id, start_time: @break_time.start_time, total_minutes: @break_time.total_minutes } }, as: :json
    end

    assert_response 201
  end

  test "should show break_time" do
    get break_time_url(@break_time), as: :json
    assert_response :success
  end

  test "should update break_time" do
    patch break_time_url(@break_time), params: { break_time: { end_time: @break_time.end_time, reasion: @break_time.reasion, shifttransaction_id: @break_time.shifttransaction_id, start_time: @break_time.start_time, total_minutes: @break_time.total_minutes } }, as: :json
    assert_response 200
  end

  test "should destroy break_time" do
    assert_difference('BreakTime.count', -1) do
      delete break_time_url(@break_time), as: :json
    end

    assert_response 204
  end
end
