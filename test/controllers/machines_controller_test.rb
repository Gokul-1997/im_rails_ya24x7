require 'test_helper'

class MachinesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @machine = machines(:one)
  end

  test "should get index" do
    get machines_url, as: :json
    assert_response :success
  end

  test "should create machine" do
    assert_difference('Machine.count') do
      post machines_url, params: { machine: { machine_model: @machine.machine_model, machine_name: @machine.machine_name, machine_serial_no: @machine.machine_serial_no, machine_type: @machine.machine_type, tenant_id: @machine.tenant_id } }, as: :json
    end

    assert_response 201
  end

  test "should show machine" do
    get machine_url(@machine), as: :json
    assert_response :success
  end

  test "should update machine" do
    patch machine_url(@machine), params: { machine: { machine_model: @machine.machine_model, machine_name: @machine.machine_name, machine_serial_no: @machine.machine_serial_no, machine_type: @machine.machine_type, tenant_id: @machine.tenant_id } }, as: :json
    assert_response 200
  end

  test "should destroy machine" do
    assert_difference('Machine.count', -1) do
      delete machine_url(@machine), as: :json
    end

    assert_response 204
  end
end
