class ShifttransactionSerializer < ActiveModel::Serializer
  attributes :id,:start_noon,:end_noon,:shift_start_time,:shift_end_time,:actual_working_hours,:shift_no,:shift_start_time_dummy,:shift_end_time_dummy,:actual_working_hours_dummy,:day,:end_day 
  def start_noon
   object.shift_start_time.to_time.strftime("%p")
  end
  def end_noon
   object.shift_end_time.to_time.strftime("%p")
  end

end
