class DataLossEntrySerializer < ActiveModel::Serializer
  attributes :id, :start_time, :end_time, :downtime, :parts_produced,:machine_id

  def start_time
   #object.start_time.strftime("%I:%M %p")
   object.start_time.localtime
  end

  def end_time
   object.end_time.localtime
  end

  has_one :machine
end
