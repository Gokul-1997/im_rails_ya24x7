class SetAlarmSettingSerializer < ActiveModel::Serializer
  attributes :id, :alarm_for, :time_interval, :alarm_type,:active
  has_one :machine
end
