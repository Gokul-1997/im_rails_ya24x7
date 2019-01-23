class EthernetLogSerializer < ActiveModel::Serializer
  attributes :id, :date, :status,:time
  has_one :machine
 # has_one :tenant
   def date
   object.date.localtime.strftime("%d-%m-%Y ")
end

def time
   object.date.strftime("%I:%M:%S %p")
end

def status
   if object.status   == "0"
      "Disconnected"
  elsif object.status == "1"
      "Connected"
  elsif object.status == "2"
      "Restarted"
  elsif object.status == "3"
      "unplugged"
   else
          "false"
  end
end

end
