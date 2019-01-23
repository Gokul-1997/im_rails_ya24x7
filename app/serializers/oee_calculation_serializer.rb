class OeeCalculationSerializer < ActiveModel::Serializer
  attributes :id, :duration, :date, :prod_time, :machine_id, :shifttransaction_id, :machine, :shift
  has_many :oee_calculate_lists

    def duration
        if object.duration == nil
         "Not Assigned"
    else
      Time.at((object.duration.to_i)*60).utc.strftime("%H:%M:%S")
   end
  end


   def prod_time
        if object.prod_time == nil
         "Not Assigned"
    else
      Time.at((object.prod_time.to_i)*60).utc.strftime("%H:%M:%S")
   end
  end

  
  def prod_time
        if object.prod_time == nil
         "Not Assigned"
    else
      Time.at((object.prod_time.to_i)*60).utc.strftime("%H:%M:%S")
   end
  end


  def machine
       object.machine.machine_name
  end

   def shift
       object.shifttransaction.shift_no
  end


end
