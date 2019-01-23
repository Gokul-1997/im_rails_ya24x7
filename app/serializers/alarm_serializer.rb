class AlarmSerializer < ActiveModel::Serializer
  attributes :id, :alarm_type, :alarm_number, :alarm_message, :emergency,:created_at,:updated_at
  #,:alarm_date1,:alarm_time1
  has_one :machine
   
def updated_at
   object.updated_at.localtime
   #.strftime("%d-%m-%Y %I:%M %p")
end

def created_at
   object.created_at.localtime
end
=begin
def alarm_date1
   object.updated_at.localtime.strftime("%d-%m-%Y")
end

def alarm_time1
   object.updated_at.localtime.strftime("%I:%M:%S %p")
end
=end



end
