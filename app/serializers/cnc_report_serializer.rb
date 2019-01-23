class CncReportSerializer < ActiveModel::Serializer
  #attributes :id
  attributes :id,:date,:shift_no,:time,:operator_id,:operator_name,:machine_name,:machine_type,:job_description,:parts_produced,:total_downtime,:actual_running,:idle_time,:utilization,:shift_id, :program_number, :cycle_time, :actual_working_hours, :loading_and_unloading_time,:spendle_speed, :puls_code,:cutting_time,:feed_rate,:spindle_load,:servo_m_temp,:servo_load,:spindle_m_temp, :availability, :perfomance, :quality, :oee
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
  object.date#.strftime("%d-%m-%Y")
end

def total_downtime
	#Time.at(object.stop_time.to_i).utc.strftime("%H:%M:%S")
	if object.stop_time.to_i > object.run_time.to_i && object.stop_time.to_i > object.idle_time.to_i
      Time.at(object.stop_time.to_i + object.time_diff.to_i).utc.strftime("%H:%M:%S")
    else
	  Time.at(object.stop_time.to_i).utc.strftime("%H:%M:%S")
    end
end

def idle_time
	#Time.at(object.idle_time.to_i).utc.strftime("%H:%M:%S")
	if object.idle_time.to_i >= object.run_time.to_i && object.idle_time.to_i >= object.stop_time.to_i
      Time.at(object.idle_time.to_i + object.time_diff.to_i).utc.strftime("%H:%M:%S")
    else
	  Time.at(object.idle_time.to_i).utc.strftime("%H:%M:%S")
    end
end

def actual_running
	#object.run_time
	#Time.at(object.run_time.to_i).utc.strftime("%H:%M:%S")
	if object.run_time.to_i > object.idle_time.to_i && object.run_time.to_i > object.stop_time.to_i
      Time.at(object.run_time.to_i + object.time_diff.to_i).utc.strftime("%H:%M:%S")
    else
	  Time.at(object.run_time.to_i).utc.strftime("%H:%M:%S")
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
	Time.at(object.hour.to_i).utc.strftime("%H:%M:%S")
end

def loading_and_unloading_time
	Time.at(object.time_diff.to_i).utc.strftime("%H:%M:%S")
end


def cutting_time
	if object.cutting_time == []
	  "-"	
	else
		time1 = object.cutting_time.last
	   Time.at(time1.to_i).utc.strftime("%H:%M:%S")  
	end
end

def servo_load
	if object.servo_load == []
		[{x_axis: "0 - 0"}, {y_axis:"0 - 0"}, {z_axis: "0 - 0"}, {a_axis: "0 - 0"}, {b_axis: "0 - 0"}]
	else
		object.servo_load
	end	
end

def puls_code
	if object.puls_code == []
		[{x_axis: "0 - 0"}, {y_axis:"0 - 0"}, {z_axis: "0 - 0"}, {a_axis: "0 - 0"}, {b_axis: "0 - 0"}]
	else
		object.puls_code
	end	
end


def availability
  if object.availability.present?
      object.availability.to_f * 100
  else
     '-'
  end
end


 def perfomance
  if object.perfomance.present?
      object.perfomance.to_f * 100
  else
     '-'
  end
end

 
   def quality
  if object.quality.present?
      object.quality.to_f * 100
  else
     '-'
  end
end



  def oee
   if object.quality.present? && object.perfomance.present? && object.availability.present?
    (object.availability.to_f *  object.perfomance.to_f * object.quality.to_f)*100
   else

      '0'
   end
  end








end
