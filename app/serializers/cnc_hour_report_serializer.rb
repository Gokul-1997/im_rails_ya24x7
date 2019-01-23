class CncHourReportSerializer < ActiveModel::Serializer
  attributes :id, :date, :shift_no, :time, :operator_id, :operator_name, :machine_name, :machine_type, :job_description, :parts_produced, :actual_running, :idle_time, :total_downtime, :utilization, :shift_id, :program_number, :cycle_time, :actual_working_hours, :loading_and_unloading_time,:spendle_speed, :puls_code,:cutting_time,:feed_rate,:spindle_load,:servo_m_temp,:servo_load,:spindle_m_temp

def machine_name
  object.machine.machine_name
end

def operator_id
	if object.operator_id == nil
	 "Not Assigned" 
    else
      object.operator.operator_spec_id
end
end
def machine_type
	object.machine.machine_type
end
def operator_name
	if object.operator_id == nil
	 "Not Assigned" 
    else
	object.operator.operator_name
end
end

def date
  object.date.strftime("%d-%m-%Y")
end

def actual_running
	#object.run_time.to_i/60
	if object.run_time.to_i > object.ideal_time.to_i && object.run_time.to_i > object.stop_time.to_i
      Time.at(object.run_time.to_i + object.time_diff.to_i).utc.strftime("%H:%M:%S")
    else
	  Time.at(object.run_time.to_i).utc.strftime("%H:%M:%S")
    end
end

def idle_time
	#object.ideal_time.to_i/60
	#Time.at(object.ideal_time.to_i).utc.strftime("%H:%M:%S")

	if object.ideal_time.to_i >= object.run_time.to_i && object.ideal_time.to_i >= object.stop_time.to_i
      Time.at(object.ideal_time.to_i + object.time_diff.to_i).utc.strftime("%H:%M:%S")
    else
	  Time.at(object.ideal_time.to_i).utc.strftime("%H:%M:%S")
    end
end

def total_downtime
	#object.stop_time.to_i/60
	#Time.at(object.stop_time.to_i).utc.strftime("%H:%M:%S")
	if object.stop_time.to_i > object.run_time.to_i && object.stop_time.to_i >  object.ideal_time.to_i
      Time.at(object.stop_time.to_i + object.time_diff.to_i).utc.strftime("%H:%M:%S")
    else
	  Time.at(object.stop_time.to_i).utc.strftime("%H:%M:%S")
    end
end
def program_number
	if object.all_cycle_time.present?
	  object.all_cycle_time.pluck(:program_number).uniq.reject{|i| i == "0" || i == ""}.split(",").join(" | ")
    else
    	"-"
    end
end

def cycle_time
	#byebug
	if object.all_cycle_time.present?
		#cycle = object.all_cycle_time.pluck(:cycle_time)
		#avg_cycl = cycle.inject(0.0) { |sum, el| sum + el } / cycle.size
		#Time.at(avg_cycl).utc.strftime("%H:%M:%S")
	#object.all_cycle_time.last[:cycle_time]
	  time = object.all_cycle_time.last[:cycle_time]
       Time.at(time).utc.strftime("%H:%M:%S")
     else
    	"-"
    end
end

def actual_working_hours
	#Time.at(object.hour.to_i).strftime("%H:%M:%S")
	#/60
	#object.hour.to_i/60
	Time.at(object.hour.to_i).utc.strftime("%H:%M:%S")
end

def loading_and_unloading_time
	#object.time_diff.to_i/60
	Time.at(object.time_diff.to_i).utc.strftime("%H:%M:%S")
end

def utilization

   if object.run_time.to_i > object.ideal_time.to_i && object.run_time.to_i > object.stop_time.to_i
      run_time = object.run_time.to_i + object.time_diff.to_i
    else
	  run_time = object.run_time.to_i
    end	
   
     uti = (((run_time*100)/object.hour.to_i).to_f).round
     
end



 def cutting_time
	if object.cutting_time == []
	  "-"	
	else
		time1 = object.cutting_time.last
	   Time.at(time1.to_i).utc.strftime("%H:%M:%S")  
	end
end


end
