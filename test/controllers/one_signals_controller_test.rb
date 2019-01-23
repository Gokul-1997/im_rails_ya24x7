require 'test_helper'

class OneSignalsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @one_signal = one_signals(:one)
  end

  test "should get index" do
    get one_signals_url, as: :json
    assert_response :success
  end

  test "should create one_signal" do
    assert_difference('OneSignal.count') do
      post one_signals_url, params: { one_signal: { player_id: @one_signal.player_id, tenant_id: @one_signal.tenant_id, user_id: @one_signal.user_id } }, as: :json
    end

    assert_response 201
  end

  test "should show one_signal" do
    get one_signal_url(@one_signal), as: :json
    assert_response :success
  end

  test "should update one_signal" do
    patch one_signal_url(@one_signal), params: { one_signal: { player_id: @one_signal.player_id, tenant_id: @one_signal.tenant_id, user_id: @one_signal.user_id } }, as: :json
    assert_response 200
  end

  test "should destroy one_signal" do
    assert_difference('OneSignal.count', -1) do
      delete one_signal_url(@one_signal), as: :json
    end

    assert_response 204
  end
end
