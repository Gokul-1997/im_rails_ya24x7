require 'test_helper'

class MachineallocationsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @machineallocation = machineallocations(:one)
  end

  test "should get index" do
    get machineallocations_url, as: :json
    assert_response :success
  end

  test "should create machineallocation" do
    assert_difference('Machineallocation.count') do
      post machineallocations_url, params: { machineallocation: { actual_quantity: @machineallocation.actual_quantity, cncoperation_id: @machineallocation.cncoperation_id, cycle_time: @machineallocation.cycle_time, end_time: @machineallocation.end_time, from_date: @machineallocation.from_date, idle_cycle_time: @machineallocation.idle_cycle_time, machine_id: @machineallocation.machine_id, produced_quantiy: @machineallocation.produced_quantiy, start_time: @machineallocation.start_time, tenant_id: @machineallocation.tenant_id, to_date: @machineallocation.to_date, total_down_time: @machineallocation.total_down_time } }, as: :json
    end

    assert_response 201
  end

  test "should show machineallocation" do
    get machineallocation_url(@machineallocation), as: :json
    assert_response :success
  end

  test "should update machineallocation" do
    patch machineallocation_url(@machineallocation), params: { machineallocation: { actual_quantity: @machineallocation.actual_quantity, cncoperation_id: @machineallocation.cncoperation_id, cycle_time: @machineallocation.cycle_time, end_time: @machineallocation.end_time, from_date: @machineallocation.from_date, idle_cycle_time: @machineallocation.idle_cycle_time, machine_id: @machineallocation.machine_id, produced_quantiy: @machineallocation.produced_quantiy, start_time: @machineallocation.start_time, tenant_id: @machineallocation.tenant_id, to_date: @machineallocation.to_date, total_down_time: @machineallocation.total_down_time } }, as: :json
    assert_response 200
  end

  test "should destroy machineallocation" do
    assert_difference('Machineallocation.count', -1) do
      delete machineallocation_url(@machineallocation), as: :json
    end

    assert_response 204
  end
end
