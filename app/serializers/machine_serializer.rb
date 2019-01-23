class MachineSerializer < ActiveModel::Serializer
  attributes :id,:machine_name, :machine_model, :machine_serial_no, :tenant_id,:machine_type,:machine_ip,:unit,:device_id, :controller_type
end
