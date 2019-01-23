class OeeCalculateListSerializer < ActiveModel::Serializer
  attributes :id, :program_number, :run_rate, :parts_count, :time

  def run_rate
	if object.run_rate == nil
	 "Not Assigned" 
    else
      Time.at((object.run_rate.to_i)*60).utc.strftime("%H:%M:%S")
   end
  end



 def time
        if object.time == nil
         "Not Assigned"
    else
      Time.at((object.time.to_i)*60).utc.strftime("%H:%M:%S")
   end
  end




end
