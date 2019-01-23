require 'test_helper'

class MacIdConfigsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @mac_id_config = mac_id_configs(:one)
  end

  test "should get index" do
    get mac_id_configs_url, as: :json
    assert_response :success
  end

  test "should create mac_id_config" do
    assert_difference('MacIdConfig.count') do
      post mac_id_configs_url, params: { mac_id_config: { mac_id: @mac_id_config.mac_id, player_id: @mac_id_config.player_id } }, as: :json
    end

    assert_response 201
  end

  test "should show mac_id_config" do
    get mac_id_config_url(@mac_id_config), as: :json
    assert_response :success
  end

  test "should update mac_id_config" do
    patch mac_id_config_url(@mac_id_config), params: { mac_id_config: { mac_id: @mac_id_config.mac_id, player_id: @mac_id_config.player_id } }, as: :json
    assert_response 200
  end

  test "should destroy mac_id_config" do
    assert_difference('MacIdConfig.count', -1) do
      delete mac_id_config_url(@mac_id_config), as: :json
    end

    assert_response 204
  end
end
