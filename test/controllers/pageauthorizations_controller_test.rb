require 'test_helper'

class PageauthorizationsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @pageauthorization = pageauthorizations(:one)
  end

  test "should get index" do
    get pageauthorizations_url, as: :json
    assert_response :success
  end

  test "should create pageauthorization" do
    assert_difference('Pageauthorization.count') do
      post pageauthorizations_url, params: { pageauthorization: { authorization_name: @pageauthorization.authorization_name, description: @pageauthorization.description } }, as: :json
    end

    assert_response 201
  end

  test "should show pageauthorization" do
    get pageauthorization_url(@pageauthorization), as: :json
    assert_response :success
  end

  test "should update pageauthorization" do
    patch pageauthorization_url(@pageauthorization), params: { pageauthorization: { authorization_name: @pageauthorization.authorization_name, description: @pageauthorization.description } }, as: :json
    assert_response 200
  end

  test "should destroy pageauthorization" do
    assert_difference('Pageauthorization.count', -1) do
      delete pageauthorization_url(@pageauthorization), as: :json
    end

    assert_response 204
  end
end
