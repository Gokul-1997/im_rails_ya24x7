class HmiMachineDetailSerializer < ActiveModel::Serializer
    attributes :id, :operator_id, :operator_name, :machine_name, :time, :idle_time, :operator_name, :machine_id, :tenant_id, :start_time, :end_time, :description, :shifttransaction_id, :shift_no, :duration, :date

  def operator_id
	if object.operator_id == nil
	 "Not Assigned" 
    else
      object.operator.operator_spec_id
    end
  end

  def operator_name
  	if object.operator_id == nil
  		"Not Assigned"
  	else
  		object.operator.operator_name
  	end
  end

  def machine_name
    object.machine.machine_name
  end

  def machine_id
  	object.machine.machine_type
  end

  def duration
  	 object.start_time.localtime.strftime('%H:%M:%S')+' - '+object.end_time.localtime.strftime('%H:%M:%S')
  end

  def time
    object.shifttransaction.shift_start_time+' - '+object.shifttransaction.shift_end_time
  end

  def idle_time
    Time.at(object.duration).utc.strftime("%H:%M:%S")
  end


end
