class CtMachineLogSerializer < ActiveModel::Serializer
  attributes :id, :status, :heart_beat, :from_date, :to_date, :uptime, :reason
  has_one :machine
end
