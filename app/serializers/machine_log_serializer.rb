class MachineLogSerializer < ActiveModel::Serializer
  attributes :id,:parts_count,:machine_status,:last_machine_on,:machine_id,:created_at
end
