class ConnectionLogSerializer < ActiveModel::Serializer
  attributes :id, :date,:time,:status
  has_one :tenant
  def date
  	if object.date.present?
   object.date.localtime.strftime("%d-%m-%Y ")
   else
   	"00:00:00"
   end
end

def time
   #object.date.localtime.strftime("%I:%M:%S %p")
   if object.date.present?
   object.date.strftime("%I:%M:%S %p")
   else
   	"00:00:00"
   end
end


  def status
   if object.status   == "0"
      "Disconnected"
  elsif object.status == "1"
      "Connected"
  elsif object.status == "2"
      "Power Connected"
  elsif object.status == "3"
      "unplugged"
   else
          "false"
  end
end
end
