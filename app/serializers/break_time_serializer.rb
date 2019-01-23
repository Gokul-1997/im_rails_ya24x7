class BreakTimeSerializer < ActiveModel::Serializer
  attributes :id, :reasion, :start_time, :end_time, :total_minutes,:start_time_dummy,:end_time_dumy
  has_one :shifttransaction
end
