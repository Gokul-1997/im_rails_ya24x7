class NotificationSerializer < ActiveModel::Serializer
  attributes :id,:machine_log_id,:machine_id,:date,:time,:machine_name,:reason

  def date
   object.created_at.localtime.strftime("%d-%m-%Y")
  end

  def time
   object.created_at.localtime.strftime("%I:%M:%S %p")
  end

  def machine_name
   object.message.split(":")[0]
  end

  def reason
  	object.message.split(":")[1]
  end

end
